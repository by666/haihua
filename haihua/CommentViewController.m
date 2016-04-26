//
//  MainViewController.m
//  haihua
//
//  Created by by.huang on 16/3/8.
//  Copyright © 2016年 by.huang. All rights reserved.
//

#import "CommentViewController.h"
#import <MBProgressHUD.h>
#import "NewsModel.h"
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

#define Top_Height 180
#define ITEM_HEIGHT 110
#define REQUEST_SIZE 10

@interface CommentViewController ()

@property (copy, nonatomic) NSString *mainTitle;

@property (strong, nonatomic) UIScrollView *scrollerView;

@property (strong, nonatomic) UIScrollView *topScrollerView;

@property (strong, nonatomic) UIPageControl *page;

@property (strong, nonatomic) UITableView *tableView;

@property (strong, nonatomic) NSMutableArray *datas;

@property (strong, nonatomic) TabButton *messageBtn;

@property (strong, nonatomic) TabButton *personalBtn;

@property (strong, nonatomic) UIButton *errorView;

@end

@implementation CommentViewController
{
    int CURRENT;
}

+(void)show : (UIViewController *)controller title: (NSString *)title
{
    CommentViewController *openViewControler = [[CommentViewController alloc]init];
    openViewControler.mainTitle = title;
    [controller.navigationController pushViewController:openViewControler animated:YES];
}



- (void)viewDidLoad {
    [super viewDidLoad];
    _datas = [[NSMutableArray alloc]init];
    [self initView];
}


#pragma mark 初始化视图
- (void)initView{
    [self.view setBackgroundColor:BACKGROUND_COLOR];
    [self showNavigationBar];
    [self.navBar setTitle:_mainTitle];
    [self initTopView];
    [self initTableView];
    [self initErrorView];
    [self uploadNew];
    
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
    for(int i= 0 ; i < 5 ; i ++)
    {
        UIImageView *imageView = [[UIImageView alloc]init];
        imageView.contentMode  = UIViewContentModeScaleAspectFill;
        imageView.image = [UIImage imageNamed:@"test"];
        imageView.frame = CGRectMake(i*SCREEN_WIDTH, 0, SCREEN_WIDTH, Top_Height);
        [_topScrollerView addSubview:imageView];
    }
    [_topScrollerView setContentSize:CGSizeMake(5 * SCREEN_WIDTH, Top_Height)];
    [_scrollerView addSubview:_topScrollerView];
    
    _page = [[UIPageControl alloc]init];
    _page.frame = CGRectMake(0, Top_Height-25,SCREEN_WIDTH, 20);
    _page.numberOfPages = 5;
    _page.currentPage = 0;
    _page.currentPageIndicatorTintColor = [UIColor whiteColor];
    _page.pageIndicatorTintColor = [ColorUtil colorWithHexString:@"#ffffff" alpha:0.3];
    [_scrollerView addSubview:_page];
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
        NewsModel *model = [_datas objectAtIndex:indexPath.row];
        [cell setNewsData:model];
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(!IS_NS_COLLECTION_EMPTY(_datas))
    {
        NewsModel *model = [_datas objectAtIndex:indexPath.row];
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
    [manager GET:Request_InfoList parameters:params
         success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         ResponseModel *model = [ResponseModel mj_objectWithKeyValues:responseObject];
         if(model.code == SUCCESS_CODE)
         {
             id data = model.data;
             if(isLoadMore)
             {
                 NSMutableArray *temp = [NewsModel mj_objectArrayWithKeyValuesArray:data];
                 if(IS_NS_COLLECTION_EMPTY(temp))
                 {
                     [_scrollerView.footer noticeNoMoreData];
                     return ;
                 }
                 [_datas addObjectsFromArray:temp];
             }
             else
             {
                 _datas = [NewsModel mj_objectArrayWithKeyValuesArray:data];
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


@end
