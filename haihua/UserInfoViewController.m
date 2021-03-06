//
//  UserInfoView.m
//  haihua
//
//  Created by by.huang on 16/3/28.
//  Copyright © 2016年 by.huang. All rights reserved.
//

#import "UserInfoViewController.h"
#import "UserInfoCell.h"
#import "UserModel.h"
#import "Account.h"
#import "UserTableModel.h"
#import "AboutViewController.h"
#import "FeedBackViewController.h"
#import "DialogHelper.h"
#import "AboutViewController.h"
#import "HeadUtil.h"
#import "FeedbackListViewController.h"
#import "LogoutViewController.h"
#import "MsgListViewController.h"
#define ITEM_HEIGHT 50

@interface UserInfoViewController()

@property (strong , nonatomic) NSMutableArray *datas;

@property (strong, nonatomic) UIScrollView *scrollView;

@property (strong, nonatomic) UIButton *headView;

@property (strong, nonatomic) UIImageView *headImageView;

@property (strong, nonatomic) UILabel *nameLabel;

@property (strong, nonatomic) UILabel *villageLabel;

@property (strong, nonatomic) UITableView *tableView;

@property (strong, nonatomic) UserModel *model;

@end

@implementation UserInfoViewController
{
    NSString *updateUrl;
}

+(void)show : (UIViewController *)controller
{
    UserInfoViewController *openViewControler = [[UserInfoViewController alloc]init];
    [controller.navigationController pushViewController:openViewControler animated:YES];
}



- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = BACKGROUND_COLOR;
    _datas = [[NSMutableArray alloc]init];
    [self initView];
}


#pragma mark 初始化视图
-(void)initView
{
    [self initNavigationBar];
    
    _scrollView = [[UIScrollView alloc]init];
    _scrollView.frame = Default_Frame;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.showsHorizontalScrollIndicator= NO;
    [self.view addSubview:_scrollView];
    
    [self buildHeadView];
    
    _tableView = [[UITableView alloc]init];
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.showsHorizontalScrollIndicator = NO;
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.scrollEnabled = NO;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    _tableView.frame = CGRectMake(0, 80, SCREEN_WIDTH, ITEM_HEIGHT * 7 +30);
    [_scrollView addSubview:_tableView];
    
    [self requestUserInfo];
}

-(void)initNavigationBar
{
    [self showNavigationBar];
    [self.navBar setTitle:@"我的"];
}

#pragma mark 创建数据
-(void)createData : (UserModel *)model
{

    NSString *verifyStatu = @"正在审核中";
    if([model.verified isEqualToString:@"1"])
    {
        verifyStatu = @"审核通过";
    }
        [_datas addObject:[UserTableModel buildModel:[UIImage imageNamed:@"one_my_shenhe"] title :@"审核状态" content:verifyStatu isClick:NO]];
    [_datas addObject:[UserTableModel buildModel:[UIImage imageNamed:@"one_my_jianyi"] title :@"我的建议" content:[NSString stringWithFormat:@"%d",model.total_feedback] isClick:YES]];
    [_datas addObject:[UserTableModel buildModel:[UIImage imageNamed:@"one_my_pinglun"] title :@"我的评论" content:[NSString stringWithFormat:@"%d",model.total_msg] isClick:YES]];
    [_datas addObject:[UserTableModel buildModel:[UIImage imageNamed:@"one_my_toupiao"] title :@"我的投票" content:[NSString stringWithFormat:@"%d",model.total_vote] isClick:YES]];
    [_datas addObject:[UserTableModel buildModel:[UIImage imageNamed:@"one_my_guanyu"] title :@"关于" content:nil isClick:YES]];
    [_datas addObject:[UserTableModel buildModel:[UIImage imageNamed:@"one_my_shezhi"] title :@"设置" content:nil isClick:YES]];
    
}

#pragma mark 创建头像布局
-(void)buildHeadView
{
    _headView = [[UIButton alloc]init];
    _headView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 80);
    _headView.backgroundColor = [UIColor whiteColor];
    
    _headImageView = [[UIImageView alloc]init];
    _headImageView.frame = CGRectMake(15, 10, 60, 60);
    [_headView addSubview:_headImageView];
    
    _nameLabel = [[UILabel alloc]init];
    _nameLabel.font = [UIFont systemFontOfSize:18.0f];
    _nameLabel.textColor = [UIColor blackColor];
    [_headView addSubview:_nameLabel];
    
    _villageLabel = [[UILabel alloc]init];
    _villageLabel.font = [UIFont systemFontOfSize:14.0f];
    _villageLabel.textColor = [ColorUtil colorWithHexString:@"#000000" alpha:0.6f];
    [_headView addSubview:_villageLabel];
    
    UIImageView *arrowImageView = [[UIImageView alloc]init];
    UIImage *image = [UIImage imageNamed:@"ic_arow"];
    arrowImageView.image = image;
    arrowImageView.hidden = YES;
    arrowImageView.frame = CGRectMake(SCREEN_WIDTH -  image.size.width - 15, (80 - image.size.height )/2, image.size.width, image.size.height);
    [_headView addSubview:arrowImageView];
    
    UIView *lineView =[[UIView alloc]init];
    lineView.backgroundColor = LINE_COLOR;
    lineView.frame = CGRectMake(0, 80 -0.5, SCREEN_WIDTH, 0.5);
    [_headView addSubview:lineView];
    
//    [_headView addTarget:self action:@selector(OnClick:) forControlEvents:UIControlEventTouchUpInside];
    [_scrollView addSubview:_headView];
    
}

#pragma mark 列表处理
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger count = 0;
    switch (section) {
        case 0:
            count = 1;
            break;
        case 1:
            count = 3;
            break;
        case 2:
            count = 1;
            break;
        case 3:
            count = 1;
            break;
        default:
            break;
    }
    return count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return ITEM_HEIGHT;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(section != 0)
    {
        return 10;
    }
    return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UserInfoCell *cell = [[UserInfoCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[UserInfoCell identify]];
    if(!IS_NS_COLLECTION_EMPTY(_datas))
    {
        UserTableModel *model;
        switch (indexPath.section) {
            case 0:
                model = [_datas objectAtIndex:indexPath.row];
                [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
                [cell hideLine];
                break;
            case 1:
                model = [_datas objectAtIndex:indexPath.row +1];
                if(indexPath.row == 2)
                {
                    [cell hideLine];
                }
                break;
            case 2:
                model = [_datas objectAtIndex:indexPath.row +4];
                if(indexPath.row == 1)
                {
                    [cell hideLine];
                }
                break;
            case 3:
                model = [_datas objectAtIndex:indexPath.row +5];
                [cell hideLine];
                break;
            default:
                break;
        }
        [cell setData:model];
    }
    return  cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSInteger section = indexPath.section;
    switch (section) {
        case 1:
            if(indexPath.row == 0)
            {
                [FeedbackListViewController show:self mine:YES];
            }
            else if(indexPath.row == 1)
            {
                [MsgListViewController show:self title:@"我的评论" type:@"discuss" mine:YES isVote: NO];
            }
            else if(indexPath.row == 2)
            {
                [MsgListViewController show:self title:@"我的投票" type:@"vote" mine:YES isVote: YES];
            }
            break;
        case 2:
            if(indexPath.row == 0)
            {
//                [self requestUpdate];
                [AboutViewController show:self];

            }
//            else if(indexPath.row == 1)
//            {
//                [AboutViewController show:self];
//            }
            break;
        case 3:
            if(indexPath.row == 0)
            {
                [LogoutViewController show:self];
            }
            break;
            
        default:
            break;
    }
}


#pragma mark 请求用户信息
-(void)requestUserInfo
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"uid"] = [[Account sharedAccount] getUid];
    params[@"token"] = [[Account sharedAccount] getToken];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    [manager GET:Request_GetUserInfo parameters:params progress:^(NSProgress * _Nonnull downloadProgress) {
        
    }
         success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
             
             ResponseModel *model = [ResponseModel mj_objectWithKeyValues:responseObject];
             if(model.code == SUCCESS_CODE)
             {
                 id data = model.data;
                 UserModel *userModel = [UserModel mj_objectWithKeyValues:data];
                 userModel.total_feedback = model.total_feedback;
                 userModel.total_vote = model.total_vote;
                 userModel.total_msg = model.total_msg;
                 [[Account sharedAccount]saveTel:userModel.tel];
                 [self updateView:userModel];
                 
             }
             [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
         }
     
         failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull   error) {
             
             [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
             
         }];
 
}

-(void)updateView : (UserModel *)model
{
 
    _nameLabel.text = model.name;
    _nameLabel.frame = CGRectMake(85, 20, _nameLabel.contentSize.width, _nameLabel.contentSize.height);

    _villageLabel.text = [NSString stringWithFormat:@"%@,%@",model.communityName,model.gatehouse];
    _villageLabel.frame = CGRectMake(85, 45, _villageLabel.contentSize.width, _villageLabel.contentSize.height);

    _headImageView.image = [HeadUtil getHeadImage:model.sex position:model.avatar];

    [self createData : model];
    [_tableView reloadData];

}

#pragma mark 返回按钮
-(void)OnLeftClickCallback
{
    [self.navigationController popViewControllerAnimated:YES];
}


-(void)requestUpdate
{
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *appCurVersionNum = [infoDictionary objectForKey:@"CFBundleVersion"];
    NSLog(@"当前应用版本号码：%@",appCurVersionNum);
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"pt"] = @"0";
    params[@"ver"] = appCurVersionNum;
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    [manager GET:Request_Update parameters:params progress:^(NSProgress * _Nonnull downloadProgress) {
        
    }
         success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
             
             ResponseModel *model = [ResponseModel mj_objectWithKeyValues:responseObject];
             if(model.code == UPDATE)
             {
                 UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"发现新版本" message:@"是否更新到最新版本？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
                 updateUrl = model.data;
                 [alertView show];
             }
             else
             {
                 [DialogHelper showSuccessTips:@"已是最新版本"];
             }
         }
     
         failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull   error) {
             
             [DialogHelper showTips:@"请检查您的网络"];
             
         }];
    
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 1)
    {
        if(!IS_NS_STRING_EMPTY(updateUrl))
        {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:updateUrl]];
        }
        
    }
}

@end
