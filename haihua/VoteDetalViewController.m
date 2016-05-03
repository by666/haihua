//
//  VoteDetalViewController.m
//  haihua
//
//  Created by by.huang on 16/3/24.
//  Copyright © 2016年 by.huang. All rights reserved.
//

#import "VoteDetalViewController.h"
#import "MJRefresh.h"
#import "VoteModel.h"
#import "Account.h"
#import "VoteItemCell.h"
#import "AppUtil.h"
#import "DialogHelper.h"
#import "Account.h"
#import "LoginViewController.h"
#define  ITEM_HEIGHT 50
#define TOP_HEIGHT 60
@interface VoteDetalViewController ()

@property (strong, nonatomic) UIScrollView *scrollView;

@property (strong ,nonatomic) MsgModel *model;

@property (assign ,nonatomic) int mid;

@property (strong ,nonatomic) NSMutableArray *datas;

@property (strong, nonatomic) UITableView *tableView;

@end

@implementation VoteDetalViewController
{
    CGSize labelsize;
    BOOL hasVote;
    int  selectPosition;
    int contentHeight;
}


+(void)show : (BaseViewController *)controller model: (MsgModel *)model;
{
    VoteDetalViewController *targetController = [[VoteDetalViewController alloc]init];
    targetController.model = model;
    [controller.navigationController pushViewController:targetController animated:YES];
    
}

+(void)show : (BaseViewController *)controller mid: (int)mid
{
    VoteDetalViewController *targetController = [[VoteDetalViewController alloc]init];
    targetController.mid = mid;
    [controller.navigationController pushViewController:targetController animated:YES];
}



- (void)viewDidLoad {
    [super viewDidLoad];
    selectPosition = -1;
    [self initView];
}

#pragma mark 初始化视图
-(void)initView
{
    self.view.backgroundColor = BACKGROUND_COLOR;
    [self initNavigationBar];
    if(_model == nil)
    {
        [self requestData];
        return;
    }
    [self initTopView];
    [self initBody];
    [self initVoteView];
}


-(void)initNavigationBar
{
    [self showNavigationBar];
    [self.navBar.leftBtn setHidden:NO];
    self.navBar.delegate = self;
    [self.navBar.leftBtn setImage:[UIImage imageNamed:@"ic_back"] forState:UIControlStateNormal];
}

-(void)initTopView
{
    UIView *topView = [[UIView alloc]init];
    topView.backgroundColor = MAIN_COLOR;
    topView.frame = CGRectMake(0, NavigationBar_HEIGHT +StatuBar_HEIGHT, SCREEN_WIDTH, TOP_HEIGHT);
    [self.view addSubview:topView];
    
    UILabel *titleLabel = [[UILabel alloc]init];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.font = [UIFont systemFontOfSize:15.0f];
    titleLabel.numberOfLines = 0;
    titleLabel.contentMode = NSLineBreakByWordWrapping;
    titleLabel.text = _model.title;
    CGSize size = [titleLabel.text sizeWithFont:titleLabel.font constrainedToSize:CGSizeMake(SCREEN_WIDTH-30, MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping];
    titleLabel.frame = CGRectMake(15, 0, SCREEN_WIDTH-30, size.height);
    [topView addSubview:titleLabel];
    
    UILabel *timeLabel = [[UILabel alloc]init];
    timeLabel.textColor = [UIColor whiteColor];
    timeLabel.font = [UIFont systemFontOfSize:13.0f];
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:_model.publishTs];
    timeLabel.text = [formatter stringFromDate:date];
    timeLabel.frame = CGRectMake(15, 5 + size.height, timeLabel.contentSize.width, timeLabel.contentSize.height);
    [topView addSubview:timeLabel];
    
    UIButton *button = [[UIButton alloc]init];
    button.backgroundColor = [UIColor whiteColor];
    button.layer.masksToBounds = YES;
    button.layer.cornerRadius = 2;
    button.titleLabel.font = [UIFont systemFontOfSize:12.0f];
    [button setTitle:@"投票" forState:UIControlStateNormal];
    [button setTitleColor:MAIN_COLOR forState:UIControlStateNormal];
    button.frame = CGRectMake(SCREEN_WIDTH - 40 , 40 , 30, 15);
    [self.view addSubview:button];
}

-(void)initBody
{
    _scrollView = [[UIScrollView alloc]init];
    _scrollView.frame = CGRectMake(0, NavigationBar_HEIGHT + StatuBar_HEIGHT + TOP_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - (NavigationBar_HEIGHT +StatuBar_HEIGHT) - TOP_HEIGHT);
    _scrollView.delegate = self;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:_scrollView];
    
    UIView *bodyView = [[UIView alloc]init];
    bodyView.backgroundColor = [UIColor whiteColor];
    [_scrollView addSubview:bodyView];
    
    NSMutableArray *pictures = _model.picNotes;
    if(!IS_NS_COLLECTION_EMPTY(pictures))
    {
        for(PictureModel *model in pictures)
        {
            //文字
            if(model.type == 1)
            {
                UILabel *label = [[UILabel alloc]init];
                label.font = [UIFont systemFontOfSize:13.0f];
                label.textColor = [UIColor blackColor];
                label.text = model.data;
                label.numberOfLines = 0;
                label.lineBreakMode = NSLineBreakByWordWrapping;
                CGSize labelSize = [label.text sizeWithFont:label.font constrainedToSize:CGSizeMake(SCREEN_WIDTH - 30, MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping];
                label.frame = CGRectMake(15, 15 + contentHeight, SCREEN_WIDTH - 30, labelSize.height);
                [_scrollView addSubview:label];
                
                contentHeight += (labelSize.height + 15);
            }
            //图片
            else if(model.type == 2)
            {
                UIImageView *imageView = [[UIImageView alloc]init];
                imageView.contentMode = UIViewContentModeScaleAspectFill;
                imageView.clipsToBounds = YES;
                [imageView sd_setImageWithURL:[NSURL URLWithString:model.data] placeholderImage:[UIImage imageNamed:@"bg_logo"]];
                imageView.frame = CGRectMake(15, 15 + contentHeight, SCREEN_WIDTH -30, SCREEN_WIDTH -30);
                [_scrollView addSubview:imageView];
                contentHeight += (SCREEN_WIDTH - 30 + 15);
            }
        }
    }
    
    bodyView.frame = CGRectMake(0, 0, SCREEN_WIDTH, contentHeight  + 15);
    [_scrollView setContentSize:CGSizeMake(SCREEN_WIDTH, contentHeight + 15)];
    
    [self requestVoteResult];

}


-(void)initVoteView
{
    _tableView = [[UITableView alloc]init];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.scrollEnabled = NO;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.showsHorizontalScrollIndicator = NO;
    if(!_model.hasVote)
    {
        _tableView.backgroundColor = MAIN_COLOR;
    }
    else
    {
        _tableView.backgroundColor = [UIColor whiteColor];
        
    }
    _tableView.layer.masksToBounds = YES;
    _tableView.layer.cornerRadius = 4;
    [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [_scrollView addSubview:_tableView];
    
    
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
    
    VoteItemCell *cell = [[VoteItemCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[VoteItemCell identify]];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if(!IS_NS_COLLECTION_EMPTY(_datas))
    {
        VoteModel *model = [_datas objectAtIndex:indexPath.row];
        [cell setData:model];
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(!IS_NS_COLLECTION_EMPTY(_datas))
    {
        for(VoteModel *model in _datas)
        {
            model.isSeleted = NO;
        }
        
        selectPosition = indexPath.row;
        VoteModel *selectModel = [_datas objectAtIndex:indexPath.row];
        selectModel.isSeleted = YES;
        [tableView reloadData];
        
        if(selectModel.hasVote)
        {
            return;
        }
        NSString *message = [NSString stringWithFormat:@"是否确定投票给\"%@\"",selectModel.option];
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"投票" message:message delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alertView show];
    }
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 1)
    {
        [self requestVote];
    }
    else
    {
        [self voteFail];
    }
}

#pragma mark 点击回调
-(void)OnLeftClickCallback
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark 请求数据
-(void)requestData
{
    __weak MBProgressHUD *hua = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"mid"] = [NSString stringWithFormat:@"%d",_mid];
    [manager GET:Request_Msg_Detail parameters:params
         success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         ResponseModel *model = [ResponseModel mj_objectWithKeyValues:responseObject];
         if(model.code == SUCCESS_CODE)
         {
             id data = model.data;
             _model = [MsgModel mj_objectWithKeyValues:data];
             _model.picNotes = [PictureModel mj_objectArrayWithKeyValuesArray:_model.picNotes];
             [self initTopView];
             [self initBody];
             [self initVoteView];
         }
         hua.hidden = YES;
     }
         failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         [_scrollView.footer endRefreshing];
         hua.hidden = YES;
     }
     ];
}

#pragma mark 获取投票结果
-(void)requestVoteResult
{
    [_datas removeAllObjects];
    __weak MBProgressHUD *hua =[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"mid"] = [NSString stringWithFormat:@"%ld",_model.mid];
    params[@"tel"] = [[Account sharedAccount]getTel];
    [manager GET:Request_VoteResult parameters:params
         success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         ResponseModel *model = [ResponseModel mj_objectWithKeyValues:responseObject];
         if(model.code == SUCCESS_CODE)
         {
             id data = model.data;
             if([model.status isEqualToString:@"submit"])
             {
                 hasVote = YES;
             }
             _datas = [VoteModel mj_objectArrayWithKeyValuesArray:data];
             int size = 0;
             for(VoteModel *temp in _datas)
             {
                 size += temp.total;
             }
             for(VoteModel *temp in _datas)
             {
                 temp.allTotal = size;
                 temp.hasVote = hasVote;
                 temp.commentedVoId = model.commentedVoId;
             }
         }
         _tableView.frame = CGRectMake(10, contentHeight + 30, SCREEN_WIDTH - 20, [_datas count] * ITEM_HEIGHT + 15);
         [_scrollView setContentSize:CGSizeMake(SCREEN_WIDTH, contentHeight + 60 + [_datas count] * ITEM_HEIGHT)];

         [_tableView reloadData];
         [hua hide:YES];
     }
         failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         [hua hide:YES];
     }];
}


#pragma mark 请求投票
-(void)requestVote
{
        Account *account = [Account sharedAccount];
        if(![account isLogin])
        {
            [LoginViewController show:self];
            return;
        }
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        __weak MBProgressHUD *hua= [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        params[@"uid"] = [account getUid];
        params[@"cid"] = [NSString stringWithFormat:@"%d",(int)[userDefaults integerForKey:VillageID]];
        params[@"mid"] = [NSString stringWithFormat:@"%ld", _model.mid];
        params[@"token"] = [account getToken];
        VoteModel *selectModel = [_datas objectAtIndex:selectPosition];
        params[@"voId"]= [NSString stringWithFormat:@"%d",selectModel.voId];

        [manager POST:Request_Vote parameters:params
              success:^(AFHTTPRequestOperation *operation, id responseObject)
         {
             ResponseModel *model = [ResponseModel mj_objectWithKeyValues:responseObject];
             
             if(model.code == SUCCESS_CODE)
             {
                 [DialogHelper showSuccessTips:@"投票成功，感谢您的支持"];
                 [self requestVoteResult];
             }
             else if(model.code == ERROR_TOKEN)
             {
                 [LoginViewController show:self];
             }
             else if(model.code == SUCCESS_VERIFY_FAIL)
             {
                 [self voteFail];
                 [DialogHelper showWarnTips:@"帐户正在审核中，请稍后操作"];
             }
             else if(model.code == SUCCESS_USER_COMMITED)
             {
                 [self voteFail];
                 [DialogHelper showWarnTips:@"请勿重复提交"];
             }
             else
             {
                 [self voteFail];
                 [DialogHelper showWarnTips:@"投票失败"];
             }
             [hua hide:YES];
         }
              failure:^(AFHTTPRequestOperation *operation, NSError *error)
         {
             [hua hide:YES];
             [self voteFail];
             [DialogHelper showWarnTips:@"投票失败"];
         }];

}

-(void)voteFail
{
    if(selectPosition >= 0)
    {
        VoteModel *selectModel = [_datas objectAtIndex:selectPosition];
        selectModel.isSeleted = NO;
        [_tableView reloadData];
        selectPosition = -1;
    }
}

@end
