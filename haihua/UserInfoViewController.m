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
#define ITEM_HEIGHT 50

@interface UserInfoViewController()

@property (strong , nonatomic) NSMutableArray *datas;

@property (strong, nonatomic) UIScrollView *scrollView;

@property (strong, nonatomic) UIButton *headView;

@property (strong, nonatomic) UIImageView *headImage;

@property (strong, nonatomic) UILabel *nameLabel;

@property (strong, nonatomic) UILabel *villageLabel;

@property (strong, nonatomic) UITableView *tableView;

@property (strong, nonatomic) UserModel *model;

@end

@implementation UserInfoViewController

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
    [self createData : nil];
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
    _tableView.scrollEnabled = NO;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    _tableView.frame = CGRectMake(0, 80, SCREEN_WIDTH, ITEM_HEIGHT * 7 +30);
    [_scrollView addSubview:_tableView];
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
    [_datas addObject:[UserTableModel buildModel:[UIImage imageNamed:@"ic_ass"] title :@"审核状态" content:verifyStatu isClick:NO]];
    [_datas addObject:[UserTableModel buildModel:[UIImage imageNamed:@"ic_bby"] title :@"我的建议" content:@"20" isClick:YES]];
    [_datas addObject:[UserTableModel buildModel:[UIImage imageNamed:@"ic_ppl"] title :@"我的评论" content:@"11" isClick:YES]];
    [_datas addObject:[UserTableModel buildModel:[UIImage imageNamed:@"ic_ttl"] title :@"我的投票" content:@"200" isClick:YES]];
    [_datas addObject:[UserTableModel buildModel:[UIImage imageNamed:@"ic_xxl"] title :@"检查更新" content:nil isClick:YES]];
    [_datas addObject:[UserTableModel buildModel:[UIImage imageNamed:@"ic_ggy"] title :@"关于" content:nil isClick:YES]];
    [_datas addObject:[UserTableModel buildModel:[UIImage imageNamed:@"ic_set"] title :@"设置" content:nil isClick:YES]];
    
}

#pragma mark 创建头像布局
-(void)buildHeadView
{
    _headView = [[UIButton alloc]init];
    _headView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 80);
    _headView.backgroundColor = [UIColor whiteColor];
    
    UIImageView *headImage = [[UIImageView alloc]init];
    headImage.image = [UIImage imageNamed:@"ic_boy_a"];
    headImage.frame = CGRectMake(15, 10, 60, 60);
    [_headView addSubview:headImage];
    
    _nameLabel = [[UILabel alloc]init];
    _nameLabel.font = [UIFont systemFontOfSize:18.0f];
    _nameLabel.text = @"by";
    _nameLabel.textColor = [UIColor blackColor];
    _nameLabel.frame = CGRectMake(85, 20, _nameLabel.contentSize.width, _nameLabel.contentSize.height);
    [_headView addSubview:_nameLabel];
    
    _villageLabel = [[UILabel alloc]init];
    _villageLabel.font = [UIFont systemFontOfSize:14.0f];
    _villageLabel.text = @"尚都花园，2e-1002";
    _villageLabel.textColor = [ColorUtil colorWithHexString:@"#000000" alpha:0.6f];
    _villageLabel.frame = CGRectMake(85, 45, _villageLabel.contentSize.width, _villageLabel.contentSize.height);
    [_headView addSubview:_villageLabel];
    
    UIImageView *arrowImageView = [[UIImageView alloc]init];
    UIImage *image = [UIImage imageNamed:@"ic_arow"];
    arrowImageView.image = image;
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
            count = 2;
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
                model = [_datas objectAtIndex:indexPath.row +6];
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
                NSLog(@"我的建议");
            }
            else if(indexPath.row == 1)
            {
                NSLog(@"我的评论");
            }
            else if(indexPath.row == 2)
            {
                NSLog(@"我的投票");
            }
            break;
        case 2:
            if(indexPath.row == 0)
            {
                [DialogHelper showSuccessTips:@"已是最新版本"];
            }
            else if(indexPath.row == 1)
            {
                [AboutViewController show:self];
            }
            break;
        case 3:
            if(indexPath.row == 0)
            {
                NSLog(@"设置");
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
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"uid"] = [[Account sharedAccount] getUid];
    params[@"token"] = [[Account sharedAccount] getToken];
    [manager GET:Request_GetUserInfo parameters:params
         success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         ResponseModel *model = [ResponseModel mj_objectWithKeyValues:responseObject];
         if(model.code == SUCCESS_CODE)
         {
             id data = model.data;
             UserModel *userModel = [UserModel mj_objectWithKeyValues:data];
             [[Account sharedAccount]saveTel:userModel.tel];
//             [self updateView:userModel];
            
         }
         [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
     }
         failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
     }];
}

#pragma mark 返回按钮
-(void)OnLeftClickCallback
{
    [self.navigationController popViewControllerAnimated:YES];
}


@end
