//
//  MainViewController.m
//  haihua
//
//  Created by by.huang on 16/3/8.
//  Copyright © 2016年 by.huang. All rights reserved.
//

#import "MainViewController.h"
#import <MBProgressHUD.h>
#import "MessageModel.h"
#import "MsgCell.h"
#import "TabButton.h"
#import "LoginViewController.h"
#import "CommentDetailViewController.h"
#import "IDSRefresh.h"
#import "DialogHelper.h"
#import "UserInfoView.h"
#import "VillageListViewController.h"
#import "Account.h"
#import "AppUtil.h"
#import "VoteDetalViewController.h"
#import "FileDataParams.h"

#define ITEM_HEIGHT 190
#define REQUEST_SIZE 2

@interface MainViewController ()

@property (strong, nonatomic) UITableView *tableView;

@property (strong, nonatomic) UIView *userInfoView;

@property (strong, nonatomic) NSMutableArray *datas;

@property (strong, nonatomic) TabButton *messageBtn;

@property (strong, nonatomic) TabButton *personalBtn;

@property (strong, nonatomic) UIButton *errorView;

@end

@implementation MainViewController
{
    int CURRENT;
}

+(void)show : (UIViewController *)controller villageId:(NSInteger)villageId name:(NSString *)name
{
    MainViewController *openViewControler = [[MainViewController alloc]init];
    openViewControler.villageId = villageId;
    openViewControler.name = name;
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
    [self.navBar.leftBtn setHidden:YES];
    [self.navBar setTitle:[_name stringByAppendingString:@" ▼"]];
    [self.navBar setTitleClick:YES];
    [self initTableView];
    [self initUserInfoView];
    [self initBottomTab];
    [self initErrorView];
    [self uploadNew];
    
}


-(void)initTableView
{
    _tableView = [[UITableView alloc]init];
    _tableView.frame = CGRectMake(0, NavigationBar_HEIGHT + StatuBar_HEIGHT , SCREEN_WIDTH, SCREEN_HEIGHT - (NavigationBar_HEIGHT + StatuBar_HEIGHT) - 50);
    _tableView.contentInset = UIEdgeInsetsMake(20, 0, 10, 0);
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    _tableView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(uploadMore)];
    
    MJRefreshStateHeader *header = [MJRefreshStateHeader headerWithRefreshingTarget:self refreshingAction:@selector(uploadNew)];
    header.lastUpdatedTimeLabel.hidden = YES;
    _tableView.header = header;
    
    [self.view addSubview:_tableView];
}


-(void)initUserInfoView
{
 
    _userInfoView = [[UserInfoView alloc]initWithInfoView:self];
    _userInfoView.frame = Default_Frame;
    _userInfoView.backgroundColor = [UIColor clearColor];
    _userInfoView.hidden = YES;
    [self.view addSubview:_userInfoView];
}


-(void)initBottomTab
{
    UIView *bottomView = [[UIView alloc]init];
    bottomView.frame = CGRectMake(0, SCREEN_HEIGHT - 50, SCREEN_WIDTH, 50);
    bottomView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bottomView];
    
    UIView *topLineView = [[UIView alloc]init];
    topLineView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 0.5);
    topLineView.backgroundColor = [ColorUtil colorWithHexString:@"#000000" alpha:0.2f];
    [bottomView addSubview:topLineView];
    
    UIView *centerLine = [[UIView alloc]init];
    centerLine.frame = CGRectMake(SCREEN_WIDTH/2, 10, 0.5, 30);
    centerLine.backgroundColor = [ColorUtil colorWithHexString:@"#000000" alpha:0.2f];
    [bottomView addSubview:centerLine];
    
    _messageBtn = [[TabButton alloc]initWithImageAndText:@"政务信息" normal:[UIImage imageNamed:@"ic_message_normal"] pressImage:[UIImage imageNamed:@"ic_message_press"]];
    _messageBtn.frame = CGRectMake(0, 0, SCREEN_WIDTH/2, 50);
    [_messageBtn addTarget:self action:@selector(OnClickCallback:) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:_messageBtn];
    
    _personalBtn = [[TabButton alloc]initWithImageAndText:@"个人信息" normal:[UIImage imageNamed:@"ic_personal_normal"] pressImage:[UIImage imageNamed:@"ic_personal_press"]];
    _personalBtn.frame = CGRectMake(SCREEN_WIDTH/2, 0, SCREEN_WIDTH/2, 50);
    [_personalBtn addTarget:self action:@selector(OnClickCallback:) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:_personalBtn];
    [_messageBtn changeState:Press];
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

    MsgCell *cell = [[MsgCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[MsgCell identify]];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
//    MessageModel *model = [[MessageModel alloc]init];
    if(!IS_NS_COLLECTION_EMPTY(_datas))
    {
        MessageModel *model = [_datas objectAtIndex:indexPath.row];
        [cell setData:model];
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(!IS_NS_COLLECTION_EMPTY(_datas))
    {
        MessageModel *model = [_datas objectAtIndex:indexPath.row];
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



#pragma mark 点击回调
-(void)OnClickCallback : (id)sender
{
    if(sender == _messageBtn)
    {
        [self.navBar setTitle:[_name stringByAppendingString:@" ▼"]];
        [self.navBar setTitleClick:YES];
        [_tableView setHidden:NO];
        [_userInfoView setHidden:YES];
        [_messageBtn changeState:Press];
        [_personalBtn changeState:Normal];
    }
    else if(sender == _personalBtn)
    {
        if([[Account sharedAccount]isLogin])
        {
            [self.navBar setTitleClick:NO];
            [_tableView setHidden:YES];
            [_userInfoView setHidden:NO];
            [self.navBar setTitle:@"个人信息"];
            [_messageBtn changeState:Normal];
            [_personalBtn changeState:Press];
        }
        else
        {
            [LoginViewController show:self];
        }

    }
    
}

#pragma mark 点击标题
-(void)OnTitleClick
{
    VillageListViewController *controller =[[VillageListViewController alloc]init];
    controller.isFromMain = YES;
    controller.delegate = self;
    [self.navigationController pushViewController:controller animated:YES];
}

-(void)OnSelectVillage:(int)villageId name:(NSString *)villageName
{
    _villageId = villageId;
    _name = villageName;
    [self.navBar setTitle:[villageName stringByAppendingString:@" ▼"]];
    [_datas removeAllObjects];
    [self uploadNew];
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
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"cid"] = [NSString stringWithFormat:@"%d",_villageId];
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
                 NSMutableArray *temp = [MessageModel mj_objectArrayWithKeyValuesArray:data];
                 if(IS_NS_COLLECTION_EMPTY(temp))
                 {
                     [_tableView.footer noticeNoMoreData];
                     return ;
                 }
                 [_datas addObjectsFromArray:temp];
             }
             else
             {
                 _datas = [MessageModel mj_objectArrayWithKeyValuesArray:data];
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
