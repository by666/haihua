//
//  VillageListViewController.m
//  haihua
//
//  Created by by.huang on 16/3/13.
//  Copyright © 2016年 by.huang. All rights reserved.
//

#import "VillageListViewController.h"
#import "VillageModel.h"
#import "VillageListCell.h"
#import "MainViewController.h"
#import "ImproveInfoViewController.h"

#define ITEM_HEIGHT 50
@interface VillageListViewController()

@property (strong , nonatomic) UITableView *tableView;

@property (strong, nonatomic) UIButton *errorView;

@property (copy , nonatomic) NSMutableArray *datas;

@end

@implementation VillageListViewController


-(void)viewDidLoad
{
    [super viewDidLoad];
    _datas = [[NSMutableArray alloc]init];
    [self initView];
}

-(void)initView
{
    [self showNavigationBar];
    [self.navBar.leftBtn setHidden:YES];
    [self.navBar setTitle:@"请选择您所在的小区"];
    
    _tableView = [[UITableView alloc]init];
    _tableView.frame = Default_Frame;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    
    _errorView = [[UIButton alloc]init];
    [_errorView addTarget:self action:@selector(requestList) forControlEvents:UIControlEventTouchUpInside];
    _errorView.frame = Default_Frame;
    [_errorView setHidden:YES];
    [self.view addSubview:_errorView];
    
    UIImageView *imageView = [[UIImageView alloc]init];
    UIImage *image = [UIImage imageNamed:@"net_error"];
    imageView.image = image;
    imageView.frame = CGRectMake((SCREEN_WIDTH - image.size.width)/2, (Default_Frame.size.height - image.size.height )/2 - 60, image.size.width, image.size.height);
    [_errorView addSubview:imageView];
    
    UILabel *label = [[UILabel alloc]init];
    label.text = Info_Net_Error;
    label.textColor = [ColorUtil colorWithHexString:@"#a9b7b7"];
    label.font = [UIFont systemFontOfSize:13.0f];
    label.frame = CGRectMake(0,0,label.contentSize.width, label.contentSize.height);
    label.center = CGPointMake(imageView.center.x, imageView.center.y + 60);
    [_errorView addSubview:label];

    
    [self requestList];
}

/**
 *  请求小区列表
 */
-(void)requestList
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [_datas removeAllObjects];
    [manager GET:Request_VillageList parameters:nil
         success:^(AFHTTPRequestOperation *operation, id responseObject)
         {
             ResponseModel *model = [ResponseModel mj_objectWithKeyValues:responseObject];
             if(model.code == SUCCESS_CODE)
             {
                 id data = model.data;
                 _datas = [VillageModel mj_objectArrayWithKeyValuesArray:data];
             }
            [self updateView];
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
         }
         failure:^(AFHTTPRequestOperation *operation, NSError *error)
         {
             [self showFailView];
             [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
         }];

}


/**
 *  更新视图
 */
-(void)updateView
{
  
    [_tableView reloadData];
//    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
//    [userDefaults setBool:YES forKey:@"firstLauncher"];
//    [userDefaults synchronize];
}

/**
 *  显示网络加载失败视图
 */
-(void)showFailView
{
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    [_tableView setHidden:YES];
    [_errorView setHidden:NO];
}

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
    VillageListCell *cell = [[VillageListCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[VillageListCell identify]];
    VillageModel *model = [_datas objectAtIndex:indexPath.row];
    [cell setData:model.name];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    VillageModel *model = [_datas objectAtIndex:indexPath.row];
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setInteger:model.villageId forKey:VillageID];
    [userDefaults setValue:model.name forKeyPath:VillageName];
        [userDefaults synchronize];
    if(_isFromImprove)
    {
        [_delegate OnSelectVillage:model.villageId name:model.name];
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }
    if(_isFromMain)
    {
        [_delegate OnSelectVillage:model.villageId name:model.name];
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }
    [MainViewController show:self villageId:model.villageId name:model.name];
}
@end
