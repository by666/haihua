//
//  CommentListViewController.m
//  haihua
//
//  Created by by.huang on 16/3/27.
//  Copyright © 2016年 by.huang. All rights reserved.
//

#import "CommentListViewController.h"
#import "CommentCell.h"
#import "MJRefresh.h"
#define ITEM_HEIGHT 100
#define REQUEST_SIZE 3

@interface CommentListViewController ()

@property (strong, nonatomic) UITableView *tableView;

@property (strong, nonatomic) NSMutableArray *datas;

@end

@implementation CommentListViewController
{
    int CURRENT;
}

+(void)show : (BaseViewController *)controller mid : (NSString *)mid
{
    CommentListViewController *targetController = [[CommentListViewController alloc]init];
    targetController.mid = mid;
    [controller.navigationController pushViewController:targetController animated:YES];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    _datas = [[NSMutableArray alloc]init];
    self.view.backgroundColor = BACKGROUND_COLOR;
    [self initView];
    [self requestCommentList];
}

#pragma mark 初始化视图
-(void)initView
{
    [self initNavigationBar];
    [self initTableView];
}

-(void)initNavigationBar
{
    [self showNavigationBar];
    [self.navBar.leftBtn setHidden:NO];
    self.navBar.delegate = self;
    [self.navBar.leftBtn setImage:[UIImage imageNamed:@"ic_back"] forState:UIControlStateNormal];
    [self.navBar setTitle:@"更多评论"];
}

-(void)initTableView
{
    _tableView = [[UITableView alloc]init];
    _tableView.frame = Default_Frame;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.showsHorizontalScrollIndicator = NO;
    _tableView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(uploadMore)];

    [self.view addSubview:_tableView];
}

#pragma mark 更新视图
-(void)uploadMore
{
    CURRENT += REQUEST_SIZE;
    [self requestCommentList];
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
    
    CommentCell *cell = [[CommentCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[CommentCell identify]];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if(!IS_NS_COLLECTION_EMPTY(_datas))
    {
        CommentModel *model = [_datas objectAtIndex:indexPath.row];
        [cell setData:model];
    }
    return cell;
}


#pragma mark 点击返回按钮
-(void)OnLeftClickCallback
{
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark 获取评论列表
-(void)requestCommentList
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"index"] = [NSString stringWithFormat:@"%d",CURRENT];
    params[@"length"] = [NSString stringWithFormat:@"%d",REQUEST_SIZE];
    params[@"mid"] = _mid;
    [manager GET:Request_CommentList parameters:params
         success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         ResponseModel *model = [ResponseModel mj_objectWithKeyValues:responseObject];
         if(model.code == SUCCESS_CODE)
         {
             CommentModel *model = [[CommentModel alloc]init];
             model.name = @"by";
             model.content = @"不错不错不错不错不错不错不错不错不错不错不错不错不错不错不错不错不错不错不错不错不错不错不错不错不错不错不错不错不错不错不错不错不错不错不错不错不错不错不错不错不错不错不错不错不错不错不错不错不错不错不错不错不错不错不错不错不错不错!";
             model.ts =1458646004;
             model.sex = @"man";
             [_datas addObject:model];
             [_datas addObject:model];
             [_datas addObject:model];
             
             [_tableView reloadData];
             [_tableView.footer endRefreshing];

         }
         [MBProgressHUD hideHUDForView:self.view animated:YES];
     }
         failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         [_tableView.footer endRefreshing];
         [MBProgressHUD hideHUDForView:self.view animated:YES];
     }];
}

@end
