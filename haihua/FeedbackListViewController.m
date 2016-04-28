//
//  FeedbackListViewController.m
//  haihua
//
//  Created by by.huang on 16/4/26.
//  Copyright © 2016年 by.huang. All rights reserved.
//

#import "FeedbackListViewController.h"
#import "IDSRefresh.h"
#import <MBProgressHUD.h>
#import "FeedbackCell.h"
#import "FeedBackViewController.h"
#import "FeedbackDetailViewController.h"
#import "Account.h"

#define ITEM_HEIGHT 200
#define REQUEST_SIZE 10

@interface FeedbackListViewController ()

@property (strong, nonatomic) NSMutableArray *datas;

@property (strong, nonatomic) UITableView *tableView;

@property (strong, nonatomic) UIButton *errorView;

@property (strong, nonatomic) UIButton *feedbackBtn;

@property (assign, nonatomic) BOOL isMine;

@end

@implementation FeedbackListViewController
{
    int CURRENT;
}

+(void)show : (BaseViewController *)controller
       mine : (BOOL)isMine
{
    FeedbackListViewController *openViewControler = [[FeedbackListViewController alloc]init];
    openViewControler.isMine = isMine;
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
    [self.navBar setTitle:@"意见采集"];
    [self initTableView];
    [self initErrorView];
    [self uploadNew];
    
}

-(void)initTableView
{
    _tableView = [[UITableView alloc]init];
    _tableView.frame = Default_Frame;
    _tableView.contentInset = UIEdgeInsetsMake(10, 0, 10, 0);
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = [UIColor clearColor];
    [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    _tableView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(uploadMore)];
    
    MJRefreshStateHeader *header = [MJRefreshStateHeader headerWithRefreshingTarget:self refreshingAction:@selector(uploadNew)];
    header.lastUpdatedTimeLabel.hidden = YES;
    _tableView.header = header;
    [self.view addSubview:_tableView];
    
    _feedbackBtn = [[UIButton alloc]init];
    [_feedbackBtn setImage:[UIImage imageNamed:@"ic_post"] forState:UIControlStateNormal];
    [_feedbackBtn addTarget:self action:@selector(OnFeedbackClick:) forControlEvents:UIControlEventTouchUpInside];
    _feedbackBtn.frame = CGRectMake(SCREEN_WIDTH - 80, SCREEN_HEIGHT - 80, 60, 60);
    [self.view addSubview:_feedbackBtn];
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
    FeedbackModel *model = [_datas objectAtIndex:indexPath.row];

    if(IS_NS_COLLECTION_EMPTY(model.pictures))
    {
        return 120;
    }
    return ITEM_HEIGHT;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    FeedbackCell *cell = [[FeedbackCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[FeedbackCell identify]];
    cell.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if(!IS_NS_COLLECTION_EMPTY(_datas))
    {
        FeedbackModel *model = [_datas objectAtIndex:indexPath.row];
        [cell setFeedBackData:model];
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(!IS_NS_COLLECTION_EMPTY(_datas))
    {
        [FeedbackDetailViewController show:self model:[_datas objectAtIndex:indexPath.row]];
    }
}


#pragma mark 点击返回
-(void)OnLeftClickCallback
{
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark 点击上传
-(void)OnFeedbackClick : (id)sender
{
    [FeedBackViewController show:self];
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
    NSString *url = Request_FeedBack_List;
    if(_isMine)
    {
        url = Request_MyFeedBack_List;
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
                 NSMutableArray *temp = [FeedbackModel mj_objectArrayWithKeyValuesArray:data];
                 if(IS_NS_COLLECTION_EMPTY(temp))
                 {
                     [_tableView.footer noticeNoMoreData];
                     return ;
                 }
                 [_datas addObjectsFromArray:temp];
             }
             else
             {
                 _datas = [FeedbackModel mj_objectArrayWithKeyValuesArray:data];
             }
             
             if(!IS_NS_COLLECTION_EMPTY(_datas))
             {
                 for(FeedbackModel *model in _datas)
                 {
                     NSMutableArray *datas = [[NSMutableArray alloc]init];
                     NSArray *arrayValue = model.pics.allValues;
                     for(NSString *temp in arrayValue)
                     {
                         [datas addObject:temp];
                     }
                     model.pictures = datas;
                 }
             }

        
             [_tableView reloadData];
             [_tableView.header endRefreshing];
             [_tableView.footer endRefreshing];
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
