//
//  UserInfoView.m
//  haihua
//
//  Created by by.huang on 16/3/28.
//  Copyright © 2016年 by.huang. All rights reserved.
//

#import "UserInfoView.h"
#import "UserInfoCell.h"
#import "UserModel.h"
#import "Account.h"
#import "UserTableModel.h"
#import "AboutViewController.h"
#import "FeedBackViewController.h"
#import "DialogHelper.h"
#define ITEM_HEIGHT 50

@interface UserInfoView()

@property (strong , nonatomic) NSMutableArray *datas;

@property (strong, nonatomic) UILabel *myTitleLabel;

@property (strong, nonatomic) UIScrollView *scrollView;

@end

@implementation UserInfoView

-(instancetype)initWithInfoView : (BaseViewController *)controller;
{
    if(self == [super init])
    {
        _datas = [[NSMutableArray alloc]init];
        _controller = controller;
        [self initView];
    }
    return self;
}




#pragma mark 初始化视图
-(void)initView
{
    [self requestUserInfo];
}

-(void)updateView : (UserModel *)model
{
    
    _scrollView = [[UIScrollView alloc]init];
    _scrollView.frame = self.bounds;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.showsHorizontalScrollIndicator= NO;
    [self addSubview:_scrollView];
    
    NSString *gender;
    if([model.sex isEqualToString:@"man"])
    {
        gender = @"先生";
    }
    else
    {
        gender = @"女士";
    }
    _myTitleLabel = [[UILabel alloc]init];
    _myTitleLabel.text = [NSString stringWithFormat:@"%@%@%@",@"欢迎您! ",model.name,gender];
    _myTitleLabel.frame = CGRectMake(0, 20, SCREEN_WIDTH, _myTitleLabel.contentSize.height);
    _myTitleLabel.textAlignment = NSTextAlignmentCenter;
    _myTitleLabel.textColor = [ColorUtil colorWithHexString:@"#000000" alpha:0.8f];
    _myTitleLabel.font = [UIFont systemFontOfSize:18.0f];
    [_scrollView addSubview:_myTitleLabel];
    
    
    [self createData:model];

    
    UITableView *tableView = [[UITableView alloc]init];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.frame = CGRectMake(0, _myTitleLabel.y + _myTitleLabel.contentSize.height + 20, SCREEN_WIDTH, ITEM_HEIGHT * [_datas count]);
    tableView.scrollEnabled = NO;
    [_scrollView addSubview:tableView];
    
    UIView *lineView = [[UIView alloc]init];
    lineView.frame = CGRectMake(0, _myTitleLabel.y + _myTitleLabel.contentSize.height + 20, SCREEN_WIDTH, 0.5);
    lineView.backgroundColor = LINE_COLOR;
    [_scrollView addSubview:lineView];

}

-(void)createData : (UserModel *)model
{
    [_datas addObject:[UserTableModel buildModel:@"小区名称" content:model.communityName isClick:NO]];
    [_datas addObject:[UserTableModel buildModel:@"门牌号码" content:model.gatehouse isClick:NO]];
    NSString *verifyStatu = @"正在审核中";
    if([model.verified isEqualToString:@"1"])
    {
        verifyStatu = @"审核通过";
    }
    [_datas addObject:[UserTableModel buildModel:@"审核状态" content:verifyStatu isClick:NO]];
    
     [_datas addObject:[UserTableModel buildModel:@"曝光反馈" content:nil isClick:YES]];
    
    [_datas addObject:[UserTableModel buildModel:@"推送设置" content:nil isClick:YES]];
    
    [_datas addObject:[UserTableModel buildModel:@"检查更新" content:nil isClick:YES]];
    
    [_datas addObject:[UserTableModel buildModel:@"关于" content:nil isClick:YES]];
    
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
    

    UserInfoCell *cell = [[UserInfoCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[UserInfoCell identify]];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if(!IS_NS_COLLECTION_EMPTY(_datas))
    {
        UserTableModel *model =  [_datas objectAtIndex:indexPath.row];
        [cell setData:model];
    }
    return cell;
}



-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(!IS_NS_COLLECTION_EMPTY(_datas))
    {
        UserTableModel *model = [_datas objectAtIndex:indexPath.row];
        if(model.isClick)
        {
            if([model.title isEqualToString:@"曝光反馈"])
            {
                [FeedBackViewController show:_controller];
            }
            else if([model.title isEqualToString:@"关于"])
            {
                [AboutViewController show:_controller];
            }
            else if([model.title isEqualToString:@"检查更新"])
            {
                [DialogHelper showSuccessTips:@"已是最新版本"];
            }
        }

    }
}

#pragma mark 请求用户信息
-(void)requestUserInfo
{
    [MBProgressHUD showHUDAddedTo:self animated:YES];
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
             [self updateView:userModel];
            
         }
         [MBProgressHUD hideAllHUDsForView:self animated:YES];
     }
         failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         [MBProgressHUD hideAllHUDsForView:self animated:YES];
     }];
    

}
@end
