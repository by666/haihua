//
//  MainViewController.m
//  haihua
//
//  Created by by.huang on 16/3/8.
//  Copyright © 2016年 by.huang. All rights reserved.
//

#import "CommentViewController.h"
#import <MBProgressHUD.h>
#import "MsgModel.h"
#import "CommentViewCell.h"
#import "TabButton.h"
#import "LoginViewController.h"
#import "CommentDetailViewController.h"
#import "IDSRefresh.h"
#import "DialogHelper.h"
#import "Account.h"
#import "AppUtil.h"
#import "VoteDetalViewController.h"
#import "FileDataParams.h"
#import "BannerModel.h"

#define ITEM_HEIGHT 110
#define REQUEST_SIZE 10

@interface CommentViewController ()

@property (copy, nonatomic) NSString *mainTitle;

@property (strong, nonatomic) UIScrollView *scrollerView;

@property (strong, nonatomic) UIScrollView *topScrollerView;

@property (strong, nonatomic) UIPageControl *page;

@property (strong, nonatomic) UITableView *tableView;

@property (strong, nonatomic) NSMutableArray *datas;

@property (strong, nonatomic) NSMutableArray *imageDatas;

@property (strong, nonatomic) TabButton *messageBtn;

@property (strong, nonatomic) TabButton *personalBtn;

@property (strong, nonatomic) UIButton *errorView;

@property (copy, nonatomic) NSString *type;

@property (assign , nonatomic) BOOL isMine;

@end

@implementation CommentViewController
{
    int CURRENT;
    int Top_Height;

}


+(void)show : (UIViewController *)controller
       title: (NSString *)title
        type: (NSString *)type
        mine:(BOOL)isMine
{
    CommentViewController *openViewControler = [[CommentViewController alloc]init];
    openViewControler.mainTitle = title;
    openViewControler.type = type;
    openViewControler.isMine = isMine;
    [controller.navigationController pushViewController:openViewControler animated:YES];
}



- (void)viewDidLoad {
    [super viewDidLoad];
    Top_Height = 180;
    _datas = [[NSMutableArray alloc]init];
    _imageDatas= [[NSMutableArray alloc]init];
    [self initView];
}


#pragma mark 初始化视图
- (void)initView{
    if(_isMine)
    {
        Top_Height = 0;
    }
    [self.view setBackgroundColor:BACKGROUND_COLOR];
    [self showNavigationBar];
    [self.navBar setTitle:_mainTitle];
    [self requestBanner];
    
}

-(void)initTopView
{
    _scrollerView = [[UIScrollView alloc]init];
    _scrollerView.frame = CGRectMake(0, NavigationBar_HEIGHT + StatuBar_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - (NavigationBar_HEIGHT + StatuBar_HEIGHT));
    _scrollerView.showsVerticalScrollIndicator = NO;
    _scrollerView.showsHorizontalScrollIndicator = NO;
    _scrollerView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(uploadMore)];
    
    MJRefreshStateHeader *header = [MJRefreshStateHeader headerWithRefreshingTarget:self refreshingAction:@selector(uploadNew)];
    header.lastUpdatedTimeLabel.hidden = YES;
    _scrollerView.header = header;
    [self.view addSubview:_scrollerView];
    
    _topScrollerView =[[UIScrollView alloc]init];;
    _topScrollerView.frame = CGRectMake(0, 0, SCREEN_WIDTH, Top_Height);
    _topScrollerView.pagingEnabled = YES;
    _topScrollerView.showsVerticalScrollIndicator = NO;
    _topScrollerView.delegate = self;
    _topScrollerView.showsHorizontalScrollIndicator = NO;
    int count = 0;
    if(!IS_NS_COLLECTION_EMPTY(_imageDatas))
    {
        count = _imageDatas.count;
        for(int i= 0 ; i < count ; i ++)
        {
            BannerModel *model = [_imageDatas objectAtIndex:i];
            UIImageView *imageView = [[UIImageView alloc]init];
            imageView.tag = i;
            imageView.contentMode  = UIViewContentModeScaleAspectFill;
            [imageView sd_setImageWithURL:[NSURL URLWithString:model.url] placeholderImage:[UIImage imageNamed:@"net_error"]];
            imageView.frame = CGRectMake(i*SCREEN_WIDTH, 0, SCREEN_WIDTH, Top_Height);
            UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(OnImageClick:)];
            [imageView addGestureRecognizer:recognizer];
            [_topScrollerView addSubview:imageView];
        }
        [_topScrollerView setContentSize:CGSizeMake(count * SCREEN_WIDTH, Top_Height)];
        [_scrollerView addSubview:_topScrollerView];
        
        _page = [[UIPageControl alloc]init];
        _page.frame = CGRectMake(0, Top_Height-25,SCREEN_WIDTH, 20);
        _page.numberOfPages = count;
        _page.currentPage = 0;
        _page.currentPageIndicatorTintColor = [UIColor whiteColor];
        _page.pageIndicatorTintColor = [ColorUtil colorWithHexString:@"#ffffff" alpha:0.3];
        [_scrollerView addSubview:_page];
    }
    else{
        Top_Height = 0;
    }
    
    [self initTableView];
    [self initErrorView];
    [self uploadNew];

}

-(void)initTableView
{
    _tableView = [[UITableView alloc]init];
    _tableView.frame = CGRectMake(0,Top_Height, SCREEN_WIDTH, SCREEN_HEIGHT - (NavigationBar_HEIGHT + StatuBar_HEIGHT) - Top_Height);
    _tableView.contentInset = UIEdgeInsetsMake(10, 0, 10, 0);
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.scrollEnabled = NO;
    [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [_scrollerView addSubview:_tableView];
}


-(void)initErrorView
{
    _errorView = [[UIButton alloc]init];
    [_errorView addTarget:self action:@selector(uploadNew) forControlEvents:UIControlEventTouchUpInside];
    _errorView.frame = Default_Frame;
    [_errorView setHidden:YES];
    [self.view addSubview:_errorView];
}

#pragma mark 更新视图
-(void)showFailView
{
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    [_tableView setHidden:YES];
    [_errorView setHidden:NO];
}

#pragma mark 列表视图
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_datas count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return ITEM_HEIGHT;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    CommentViewCell *cell = [[CommentViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[CommentViewCell identify]];
    cell.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if(!IS_NS_COLLECTION_EMPTY(_datas))
    {
        MsgModel *model = [_datas objectAtIndex:indexPath.row];
        [cell setNewsData:model];
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(!IS_NS_COLLECTION_EMPTY(_datas))
    {
        MsgModel *model = [_datas objectAtIndex:indexPath.row];
        if ([model.type isEqualToString:@"vote"])
        {
            [VoteDetalViewController show:self model:model];
        }
        else
        {
            [CommentDetailViewController show:self model:model];
        }
    }
}

#pragma mark 滑动事件处理
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if(scrollView == _topScrollerView)
    {
        int x = scrollView.contentOffset.x;
        int current = x / SCREEN_WIDTH;
        [_page setCurrentPage:current];
    }
}


#pragma mark 点击返回
-(void)OnLeftClickCallback
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark 点击图片
-(void)OnImageClick : (UITapGestureRecognizer *)recognizer
{
    UIView *view = recognizer.view;
    if(!IS_NS_COLLECTION_EMPTY(_imageDatas))
    {
    
    }
}

#pragma mark 请求列表数据

-(void)uploadNew
{
    CURRENT = 0;
    [self requestList : NO];
}

-(void)uploadMore
{
    CURRENT += REQUEST_SIZE;
    [self requestList : YES];
}

-(void)requestList : (BOOL)isLoadMore
{
    if(!isLoadMore)
    {
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    }
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"cid"] = [NSString stringWithFormat:@"%d", [userDefault integerForKey:VillageID]];
    params[@"index"] = [NSString stringWithFormat:@"%d",CURRENT];
    params[@"length"] = [NSString stringWithFormat:@"%d",REQUEST_SIZE];
    params[@"type"] = _type;
    NSString *url = Request_InfoList;
    if(_isMine)
    {
        url = Request_MyInfoList;
        params[@"uid"] = [[Account sharedAccount] getUid];
        params[@"token"] = [[Account sharedAccount] getToken];
    }
    [manager GET:url parameters:params
         success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         ResponseModel *model = [ResponseModel mj_objectWithKeyValues:responseObject];
         if(model.code == SUCCESS_CODE)
         {
             id data = model.data;
             if(isLoadMore)
             {
                 NSMutableArray *temp = [MsgModel mj_objectArrayWithKeyValuesArray:data];
                 if(IS_NS_COLLECTION_EMPTY(temp))
                 {
                     [_scrollerView.footer noticeNoMoreData];
                     return ;
                 }
                 else
                 {
                     for( int i = 0 ; i < temp.count ; i ++)
                     {
                         MsgModel *model = [temp objectAtIndex:i];
                         model.picNotes = [PictureModel mj_objectArrayWithKeyValuesArray:model.picNotes];
                     }
                 }
                 [_datas addObjectsFromArray:temp];
             }
             else
             {
                 _datas = [MsgModel mj_objectArrayWithKeyValuesArray:data];
                 for( int i = 0 ; i < _datas.count ; i ++)
                 {
                     MsgModel *model = [_datas objectAtIndex:i];
                     model.picNotes = [PictureModel mj_objectArrayWithKeyValuesArray:model.picNotes];
                 }
             }
             _tableView.frame = CGRectMake(0,Top_Height, SCREEN_WIDTH,  [_datas count] * ITEM_HEIGHT);
             [_scrollerView setContentSize:CGSizeMake(SCREEN_WIDTH, [_datas count] * ITEM_HEIGHT + Top_Height)];
             [_tableView reloadData];
             [_scrollerView.header endRefreshing];
             [_scrollerView.footer endRefreshing];
             
         }
         [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
     }
         failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         [self showFailView];
         [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
     }];

}


-(void)requestBanner
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"type"] = _type;
    [manager GET:Request_Banner parameters:params
         success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         ResponseModel *model = [ResponseModel mj_objectWithKeyValues:responseObject];
         if(model.code == SUCCESS_CODE)
         {
             _imageDatas = [BannerModel mj_objectArrayWithKeyValuesArray:model.data];
             [self initTopView];
         }
     }
         failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         [self showFailView];
     }];

}

@end
