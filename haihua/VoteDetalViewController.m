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
@interface VoteDetalViewController ()

@property (strong, nonatomic) UIScrollView *scrollView;

@property (strong, nonatomic) UILabel *msgTitleLabel;

@property (strong, nonatomic) UILabel *msgTimeLabel;

@property (strong, nonatomic) UILabel *msgContentLabel;

@property (strong, nonatomic) UIView *dynamicTitleView;

@property (strong ,nonatomic) NewsModel *model;

@property (strong ,nonatomic) NSMutableArray *datas;

@property (strong, nonatomic) UITableView *tableView;

@property (strong, nonatomic) UIButton *voteBtn;

@property (strong, nonatomic) UILabel *voteTitleLabel;


@end

@implementation VoteDetalViewController
{
    CGSize labelsize;
    BOOL hasVote;
    BOOL isSelected;
    VoteModel *selectModel;
}


+(void)show : (BaseViewController *)controller model: (NewsModel *)model;
{
    VoteDetalViewController *targetController = [[VoteDetalViewController alloc]init];
    targetController.model = model;
    [controller.navigationController pushViewController:targetController animated:YES];
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
}

#pragma mark 初始化视图
-(void)initView
{
    self.view.backgroundColor = BACKGROUND_COLOR;
    [self initNavigationBar];
    _scrollView = [[UIScrollView alloc]init];
    _scrollView.frame = CGRectMake(0, NavigationBar_HEIGHT + StatuBar_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - (NavigationBar_HEIGHT +StatuBar_HEIGHT));
    
    _scrollView.delegate = self;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:_scrollView];
    [self initBody];
    [self initVoteView];
    [self requestVoteResult];
}


-(void)initNavigationBar
{
    [self showNavigationBar];
    [self.navBar.leftBtn setHidden:NO];
    self.navBar.delegate = self;
    [self.navBar.leftBtn setImage:[UIImage imageNamed:@"ic_back"] forState:UIControlStateNormal];
    [self.navBar setTitle:_model.title];
}

-(void)initBody
{
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:_model.publishTs];
    
    _msgTimeLabel = [[UILabel alloc]init];
    _msgTimeLabel.text = [formatter stringFromDate:date];
    _msgTimeLabel.font = [UIFont systemFontOfSize:12.0f];
    _msgTimeLabel.textColor = [ColorUtil colorWithHexString:@"#000000" alpha:0.8f];
    _msgTimeLabel.frame = CGRectMake(10, 15, SCREEN_WIDTH -20, _msgTimeLabel.contentSize.height);
    [_scrollView addSubview:_msgTimeLabel];
    
    _msgContentLabel = [[UILabel alloc]init];
    _msgContentLabel.font = [UIFont systemFontOfSize:13.0f];
    _msgContentLabel.textColor = [UIColor blackColor];
    _msgContentLabel.lineBreakMode = NSLineBreakByCharWrapping;
    _msgContentLabel.numberOfLines = 0;
    labelsize = [@"" sizeWithFont:_msgContentLabel.font constrainedToSize: CGSizeMake(SCREEN_WIDTH - 20,CGFLOAT_MAX)
                               lineBreakMode:NSLineBreakByCharWrapping];
    
    _msgContentLabel.frame = CGRectMake(10, _msgTimeLabel.contentSize.height + _msgTimeLabel.y+15, SCREEN_WIDTH - 20, labelsize.height);
    [_scrollView addSubview:_msgContentLabel];
    
    
    UIView *commentTitle = [self createTitleView];
    commentTitle.frame = CGRectMake(0, 15 + _msgTimeLabel.contentSize.height + 15 + labelsize.height + 15, SCREEN_WIDTH, 30);
    [_scrollView addSubview:commentTitle];
    
    _dynamicTitleView = [self createTitleView];
    _dynamicTitleView.frame = CGRectMake(0, NavigationBar_HEIGHT + StatuBar_HEIGHT, SCREEN_WIDTH, 30);
    _dynamicTitleView.hidden= YES;
    [self.view addSubview:_dynamicTitleView];
}

-(UIView *)createTitleView
{
    UIView *commentTitle = [[UIView alloc]init];
    commentTitle.backgroundColor = [ColorUtil colorWithHexString:@"#FFFAF0"];
    
    UILabel *commentTitleLabel = [[UILabel alloc]init];
    commentTitleLabel.text = @"投票结果";
    commentTitleLabel.font = [UIFont systemFontOfSize:12.0f];
    commentTitleLabel.textColor = [ColorUtil colorWithHexString:@"#000000" alpha:0.6f];
    commentTitleLabel.frame = CGRectMake(10, 0, commentTitleLabel.contentSize.width, commentTitleLabel.contentSize.height);
    commentTitleLabel.centerY = 15;
    [commentTitle addSubview:commentTitleLabel];
    return commentTitle;
}




-(void)initVoteView
{
    _voteTitleLabel = [[UILabel alloc]init];
    _voteTitleLabel.textColor = [ColorUtil colorWithHexString:@"#000000" alpha:0.8];
    _voteTitleLabel.textAlignment = NSTextAlignmentCenter;
    _voteTitleLabel.font = [UIFont systemFontOfSize:18.0f];
    _voteTitleLabel.frame = CGRectMake(0, 15 + _msgTimeLabel.contentSize.height + 15 + labelsize.height + 15 + 30 + 15, SCREEN_WIDTH, _voteTitleLabel.contentSize.height);
    [_scrollView addSubview:_voteTitleLabel];
    
    _tableView = [[UITableView alloc]init];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.scrollEnabled = NO;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.showsHorizontalScrollIndicator = NO;
    [_scrollView addSubview:_tableView];
    
    
    UIView *lineView = [[UIView alloc]init];
    lineView.frame = CGRectMake(15, 15 + _msgTimeLabel.contentSize.height + 15 + labelsize.height + 15 + 30 + 15 + _voteTitleLabel.contentSize.height +10, SCREEN_WIDTH- 15, 0.5);
    lineView.backgroundColor = LINE_COLOR;
    [_scrollView addSubview:lineView];
    
    _voteBtn = [[UIButton alloc]init];
    [_voteBtn setBackgroundImage:[AppUtil imageWithColor:MAIN_COLOR] forState:UIControlStateNormal];
    [_voteBtn setBackgroundImage:[AppUtil imageWithColor:[ColorUtil colorWithHexString:@"#2d90ff" alpha:0.6f]] forState:UIControlStateHighlighted];
    [_voteBtn setTitle:@"投票" forState:UIControlStateNormal];
    [_voteBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _voteBtn.titleLabel.font = [UIFont systemFontOfSize:18];
    _voteBtn.layer.masksToBounds=YES;
    _voteBtn.layer.cornerRadius = 6;
    [_voteBtn addTarget:self action:@selector(requestVote) forControlEvents:UIControlEventTouchUpInside];
    [_scrollView addSubview:_voteBtn];
    
    [_scrollView setContentSize:CGSizeMake(SCREEN_WIDTH,  15 + _msgTimeLabel.contentSize.height + 15 + labelsize.height + 15 + 30 + 15 + _voteTitleLabel.contentSize.height + 10 + [_datas count] * ITEM_HEIGHT + 60)];
    
   
    
}

-(void)updateVoteView
{
    if(hasVote)
    {
        [_voteBtn setHidden:YES];
    }
    _tableView.frame = CGRectMake(0, 15 + _msgTimeLabel.contentSize.height + 15 + labelsize.height + 15 + 30 + 15 + _voteTitleLabel.contentSize.height +10, SCREEN_WIDTH, [_datas count] *ITEM_HEIGHT);
    [_tableView reloadData];
    _voteBtn.frame = CGRectMake((SCREEN_WIDTH - 120)/2, _tableView.y + _tableView.size.height + 20, 120, 40);
    [_scrollView setContentSize:CGSizeMake(SCREEN_WIDTH,  15 + _msgTimeLabel.contentSize.height + 15 + labelsize.height + 15 + 30 + 15 + _voteTitleLabel.contentSize.height + 10 + [_datas count] * ITEM_HEIGHT + 60)];
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
        int size = 0;
        for(VoteModel *model in _datas)
        {
            size += model.total;
        }
        VoteModel *model = [_datas objectAtIndex:indexPath.row];
        model.hasVote = hasVote;
        model.allTotal = size;
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
        selectModel = [_datas objectAtIndex:indexPath.row];
        selectModel.isSeleted = YES;
        isSelected = YES;
        [tableView reloadData];
    }
}

#pragma mark 点击回调
-(void)OnLeftClickCallback
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark 获取投票结果
-(void)requestVoteResult
{
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
             [self updateVoteView];
         }
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
    if(isSelected)
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
                 [DialogHelper showWarnTips:@"帐户正在审核中，请稍后操作"];
             }
             else
             {
                 [DialogHelper showWarnTips:@"投票失败"];
             }
             [hua hide:YES];
         }
              failure:^(AFHTTPRequestOperation *operation, NSError *error)
         {
             [hua hide:YES];
             [DialogHelper showWarnTips:@"投票失败"];
         }];

    }
    else
    {
        [DialogHelper showWarnTips:@"请选择一个投票选项"];
    }
}

@end
