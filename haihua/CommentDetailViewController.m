//
//  CommentDetailViewController.m
//  haihua
//
//  Created by by.huang on 16/3/24.
//  Copyright © 2016年 by.huang. All rights reserved.
//

#import "CommentDetailViewController.h"
#import "UIPlaceholderTextView.h"
#import "DialogHelper.h"
#import "CommentModel.h"
#import "CommentCell.h"
#import "MJRefresh.h"
#import "LoginViewController.h"
#import "Account.h"

#define ITEM_HEIGHT 100
#define REQUEST_SIZE 3
#define MORE_HEIGHT 50
@interface CommentDetailViewController ()

@property (strong, nonatomic) UIScrollView *scrollView;

@property (strong, nonatomic) UILabel *msgTitleLabel;

@property (strong, nonatomic) UILabel *msgTimeLabel;

@property (strong, nonatomic) UILabel *msgContentLabel;

@property (strong, nonatomic) UIPlaceholderTextView *commentTextView;

@property (strong, nonatomic) UIButton *sendButton;

@property (strong, nonatomic) UITableView *tableView;

@property (strong ,nonatomic) NewsModel *model;

@property (strong, nonatomic) UIView *bottomView;

@property (strong, nonatomic) UIView *maskView;

@property (strong, nonatomic) UIView *dynamicTitleView;

@property (strong, nonatomic) NSMutableArray *datas;

//@property (strong, nonatomic) UIButton *moreBtn;

@end

@implementation CommentDetailViewController
{
    CGSize labelsize;
    int CURRENT;
}

+(void)show : (BaseViewController *)controller model: (NewsModel *)model;
{
    CommentDetailViewController *targetController = [[CommentDetailViewController alloc]init];
    targetController.model = model;
    [controller.navigationController pushViewController:targetController animated:YES];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    _datas = [[NSMutableArray alloc]init];
    [self initView];
    [self registerForKeyboardNotifications];
}

#pragma mark 初始化视图
-(void)initView
{
    self.view.backgroundColor = BACKGROUND_COLOR;
    [self initNavigationBar];
    _scrollView = [[UIScrollView alloc]init];
    _scrollView.frame = CGRectMake(0, NavigationBar_HEIGHT + StatuBar_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - (NavigationBar_HEIGHT +StatuBar_HEIGHT)-50);
    _scrollView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(uploadMore)];

    _scrollView.delegate = self;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:_scrollView];
    [self initBody];
    [self initComment];
    [self initMaskView];
    [self initBottom];
    _scrollView.contentSize = CGSizeMake(SCREEN_WIDTH, 15 + _msgTimeLabel.contentSize.height + 15 + labelsize.height + 15 + 30);
    [self requestCommentList : NO];
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
    _msgContentLabel.text = _model.content;
    _msgContentLabel.font = [UIFont systemFontOfSize:13.0f];
    _msgContentLabel.textColor = [UIColor blackColor];
    _msgContentLabel.lineBreakMode = NSLineBreakByCharWrapping;
    _msgContentLabel.numberOfLines = 0;
    labelsize = [_model.content sizeWithFont:_msgContentLabel.font constrainedToSize: CGSizeMake(SCREEN_WIDTH - 20,CGFLOAT_MAX)
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
    commentTitleLabel.text = @"评论";
    commentTitleLabel.font = [UIFont systemFontOfSize:12.0f];
    commentTitleLabel.textColor = [ColorUtil colorWithHexString:@"#000000" alpha:0.6f];
    commentTitleLabel.frame = CGRectMake(10, 0, commentTitleLabel.contentSize.width, commentTitleLabel.contentSize.height);
    commentTitleLabel.centerY = 15;
    [commentTitle addSubview:commentTitleLabel];
    return commentTitle;
}

-(void)initComment
{
    _tableView = [[UITableView alloc]init];
    _tableView.frame = CGRectMake(0, 15 + _msgTimeLabel.contentSize.height + 15 + labelsize.height + 15 + 30 , SCREEN_WIDTH, 0);
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.scrollEnabled = NO;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.showsHorizontalScrollIndicator = NO;
    [_scrollView addSubview:_tableView];
    
//    _moreBtn = [[UIButton alloc]init];
//    [_moreBtn setTitle:@"查看更多评论" forState:UIControlStateNormal];
//    [_moreBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
//
//    _moreBtn.titleLabel.font = [UIFont systemFontOfSize:15.0f];
//    _moreBtn.backgroundColor = [UIColor clearColor];
//    _moreBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
//    [_moreBtn addTarget:self action:@selector(TapMoreArea) forControlEvents:UIControlEventTouchUpInside];
//    [_scrollView addSubview:_moreBtn];
    
}

-(void)initMaskView
{
    _maskView = [[UIView alloc]init];
    _maskView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-50);
    _maskView.backgroundColor = LINE_COLOR;
    UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(TapOtherArea)];
    [_maskView addGestureRecognizer:recognizer];
    [self.view addSubview:_maskView];
    _maskView.hidden = YES;
}

-(void)initBottom
{
    _bottomView = [[UIView alloc]init];
    _bottomView.frame = CGRectMake(0, SCREEN_HEIGHT - 50, SCREEN_WIDTH, 50);
    _bottomView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_bottomView];
    
    UIView *topLineView = [[UIView alloc]init];
    topLineView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 0.5);
    topLineView.backgroundColor = [ColorUtil colorWithHexString:@"#000000" alpha:0.2f];
    [_bottomView addSubview:topLineView];
    
    _commentTextView = [[UIPlaceholderTextView alloc]init];
    _commentTextView.placeholder = @"我来说两句...";
    _commentTextView.layer.borderColor = [LINE_COLOR CGColor];
    _commentTextView.layer.borderWidth = 0.5;
    _commentTextView.layer.masksToBounds = YES;
    _commentTextView.layer.cornerRadius = 2;
    _commentTextView.textColor = [UIColor blackColor];
    _commentTextView.frame = CGRectMake(10, 8 ,SCREEN_WIDTH -80,34);
    [_bottomView addSubview:_commentTextView];
    

    _sendButton = [[UIButton alloc]init];
    _sendButton.layer.masksToBounds = YES;
    _sendButton.layer.cornerRadius = 2;
    [_sendButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_sendButton setTitle:@"发送" forState:UIControlStateNormal];
    _sendButton.frame = CGRectMake(SCREEN_WIDTH -60, 8 ,50,34);
    _sendButton.backgroundColor = MAIN_COLOR;
    _sendButton.titleLabel.font = [UIFont systemFontOfSize:13.0f];
    [_sendButton addTarget:self action:@selector(OnSendButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [_bottomView addSubview:_sendButton];

}


#pragma mark 注册键盘监听事件
- (void) registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:) name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter]  addObserver:self selector:@selector(keyboardWasHidden:) name:UIKeyboardWillHideNotification object:nil];
}

#pragma mark 更新视图
-(void)uploadMore
{
    CURRENT += REQUEST_SIZE;
    [self requestCommentList : YES];
}

#pragma mark 滚动回调
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    double distY = scrollView.contentOffset.y;
    NSLog(@"%f",distY);
    if(distY > 15 + _msgTimeLabel.contentSize.height + 15 + labelsize.height + 15)
    {
        [_dynamicTitleView setHidden:NO];
    }
    else
    {
        [_dynamicTitleView setHidden:YES];
    }
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


#pragma mark 点击回调
-(void)OnLeftClickCallback
{
    [self.navigationController popViewControllerAnimated:YES];
}

//点击发送按钮
-(void)OnSendButtonClicked
{
    if(IS_NS_STRING_EMPTY(_commentTextView.text))
    {
        [DialogHelper showWarnTips:@"请输入评论内容"];
        return;
    }
    [self TapOtherArea];
    [self requestComment];
}

//点击其他区域
-(void)TapOtherArea
{
    if (![_commentTextView isExclusiveTouch]) {
        [_commentTextView resignFirstResponder];
    }
}

//点击更多区域
-(void)TapMoreArea
{
//    [CommentListViewController show:self mid:[NSString stringWithFormat:@"%ld",_model.mid]];
}

//键盘拉起回调
- (void) keyboardWasShown:(NSNotification *) notif
{
    NSDictionary *info = [notif userInfo];
    NSValue *value = [info objectForKey:UIKeyboardFrameBeginUserInfoKey];
    CGSize keyboardSize = [value CGRectValue].size;
    
    _maskView.hidden = NO;
    __weak UIView *weakBottomView = _bottomView;

    [UIView animateWithDuration:0.2 animations:^{
        weakBottomView.frame = CGRectMake(0, SCREEN_HEIGHT - 50-keyboardSize.height, SCREEN_WIDTH, 50);
    } completion:nil];
}

//键盘隐藏回调
- (void)keyboardWasHidden:(NSNotification *) notif
{
    _maskView.hidden = YES;
    __weak UIView *weakBottomView = _bottomView;
    [UIView animateWithDuration:0.2 animations:^{
        weakBottomView.frame = CGRectMake(0, SCREEN_HEIGHT - 50, SCREEN_WIDTH, 50);
    } completion:nil];
}


#pragma mark 请求评论
-(void)requestComment
{
    Account *account = [Account sharedAccount];
    if(![account isLogin])
    {
        [LoginViewController show:self];
        return;
    }
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];

    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"uid"] = [account getUid];
    params[@"cid"] = [NSString stringWithFormat:@"%d",(int)[userDefaults integerForKey:VillageID]];
    params[@"mid"] = [NSString stringWithFormat:@"%ld", _model.mid];
    params[@"content"]= _commentTextView.text;
    params[@"token"] = [account getToken];
    
    [manager POST:Request_Comment parameters:params
         success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         ResponseModel *model = [ResponseModel mj_objectWithKeyValues:responseObject];
         
         if(model.code == SUCCESS_CODE)
         {
             [DialogHelper showSuccessTips:@"评论成功，感谢您的支持"];
             [_datas removeAllObjects];
             CURRENT = 0;
             [self requestCommentList:YES];
             _commentTextView.text = nil;
         }
         else if(model.code == ERROR_TOKEN)
         {
             [LoginViewController show:self];
         }
         else if(model.code == SUCCESS_VERIFY_FAIL)
         {
             [DialogHelper showWarnTips:@"帐户正在审核中，请稍后操作"];
         }
         else if(model.code == ERROR_USER_NOT_IN_VILLAGE)
         {
             [DialogHelper showWarnTips:@"您不是本小区成员，不能进行评论"];
         }
         else
         {
             [DialogHelper showWarnTips:@"评论失败"];
         }
         [MBProgressHUD hideHUDForView:self.view animated:YES];
     }
         failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         [MBProgressHUD hideHUDForView:self.view animated:YES];
         [DialogHelper showWarnTips:@"评论失败"];
     }];
}


#pragma mark 获取评论列表
-(void)requestCommentList : (BOOL)isLoadMore
{
    if(!isLoadMore)
    {
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    }
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"index"] = [NSString stringWithFormat:@"%d",CURRENT];
    params[@"length"] = [NSString stringWithFormat:@"%d",REQUEST_SIZE];
    params[@"mid"] = [NSString stringWithFormat:@"%ld",_model.mid];
    [manager GET:Request_CommentList parameters:params
         success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         ResponseModel *model = [ResponseModel mj_objectWithKeyValues:responseObject];
         if(model.code == SUCCESS_CODE)
         {
             id data = model.data;
             NSMutableArray *requestDatas = [CommentModel mj_objectArrayWithKeyValuesArray:data];

             [_datas addObjectsFromArray:requestDatas];
             int height = 15 + _msgTimeLabel.contentSize.height + 15 + labelsize.height + 15 + 30 +([_datas count] *ITEM_HEIGHT);
             _tableView.frame = CGRectMake(0, 15 + _msgTimeLabel.contentSize.height + 15 + labelsize.height + 15 + 30 , SCREEN_WIDTH, ([_datas count] *ITEM_HEIGHT));
            _scrollView.contentSize = CGSizeMake(SCREEN_WIDTH, height);
             [_tableView reloadData];
         }
         [MBProgressHUD hideHUDForView:self.view animated:YES];
         [_scrollView.footer endRefreshing];
     }
         failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         [_scrollView.footer endRefreshing];
         [MBProgressHUD hideHUDForView:self.view animated:YES];
     }];
}
@end
