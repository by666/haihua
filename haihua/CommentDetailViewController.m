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
#define TOP_HEIGHT 80
#define REQUEST_SIZE 10
#define MORE_HEIGHT 50
#define COMMENTTITLE_HEIGHT 50
@interface CommentDetailViewController ()

@property (strong, nonatomic) UIScrollView *scrollView;

@property (strong, nonatomic) UIPlaceholderTextView *commentTextView;

@property (strong, nonatomic) UIButton *sendButton;

@property (strong, nonatomic) UITableView *tableView;

@property (strong ,nonatomic) MsgModel *model;

@property (assign ,nonatomic) int mid;

@property (copy ,nonatomic) NSString *type;

@property (strong, nonatomic) UIView *bottomView;

@property (strong, nonatomic) UIView *maskView;

@property (strong, nonatomic) NSMutableArray *datas;

@property (strong, nonatomic) UILabel *heightLabel;

@property (strong, nonatomic) UIView *commentTitleView;

@property (strong, nonatomic) UILabel *commentTitleLabel;

@property (strong, nonatomic) UILabel *countLabel;


@end

@implementation CommentDetailViewController
{
    int CURRENT;
    int contentHeight;
    int Height;
}

+(void)show : (BaseViewController *)controller model: (MsgModel *)model;
{
    CommentDetailViewController *targetController = [[CommentDetailViewController alloc]init];
    targetController.model = model;
    [controller.navigationController pushViewController:targetController animated:YES];
}

+(void)show : (BaseViewController *)controller mid: (int)mid
{
    CommentDetailViewController *targetController = [[CommentDetailViewController alloc]init];
    targetController.mid = mid;
    [controller.navigationController pushViewController:targetController animated:YES];
}

+(void)show : (BaseViewController *)controller mid: (int)mid type:(NSString *)type
{
    CommentDetailViewController *targetController = [[CommentDetailViewController alloc]init];
    targetController.mid = mid;
    targetController.type = type;
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
    _heightLabel = [[UILabel alloc]init];
    _heightLabel.font = [UIFont systemFontOfSize:13.0f];
    _heightLabel.numberOfLines = 0;
    _heightLabel.lineBreakMode = NSLineBreakByCharWrapping;
    if(_model == nil)
    {
        [self requestData];
        return;
    }
    [self initTopView];
    [self initBody];
    [self initBottom];
    [self initComment];
    
}

-(void)initNavigationBar
{
    [self showNavigationBar];
    [self.navBar.leftBtn setHidden:NO];
    self.navBar.delegate = self;
    [self.navBar.leftBtn setImage:[UIImage imageNamed:@"topbar_back"] forState:UIControlStateNormal];
    if(IS_NS_STRING_EMPTY(_type))
    {
        [self.navBar setTitle:@"议事详情"];
    }
}

-(void)initTopView
{
    UIView *topView = [[UIView alloc]init];
    topView.backgroundColor = MAIN_COLOR;
    topView.frame = CGRectMake(0, NavigationBar_HEIGHT +StatuBar_HEIGHT, SCREEN_WIDTH, TOP_HEIGHT);
    [self.view addSubview:topView];
    
    
    UILabel *titleLabel = [[UILabel alloc]init];
    titleLabel.textColor = [UIColor blackColor];
    titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:20];
    titleLabel.numberOfLines = 0;
    titleLabel.contentMode = NSLineBreakByWordWrapping;
    titleLabel.text = _model.title;
    CGSize size = [titleLabel.text sizeWithFont:titleLabel.font constrainedToSize:CGSizeMake(SCREEN_WIDTH-30, MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping];
    titleLabel.frame = CGRectMake(15, 10, SCREEN_WIDTH-30, size.height);
    [topView addSubview:titleLabel];
    
    UIImageView *commentImage = [[UIImageView alloc]init];
    commentImage.image = [UIImage imageNamed:@"home_comment"];
    commentImage.frame = CGRectMake(15, 20 + size.height, 15 ,15);
    [topView addSubview:commentImage];
    
    _countLabel = [[UILabel alloc]init];
    _countLabel.textColor = [ColorUtil colorWithHexString:@"#999999"];
    _countLabel.font = [UIFont systemFontOfSize:13.0f];
    _countLabel.text = [NSString stringWithFormat:@"%d",_model.totalComment];
    [topView addSubview:_countLabel];
    _countLabel.frame = CGRectMake(35, 20 + size.height, _countLabel.contentSize.width, _countLabel.contentSize.height);

    UIImageView *timeImage = [[UIImageView alloc]init];
    timeImage.image = [UIImage imageNamed:@"home_time"];
    timeImage.frame = CGRectMake(80, 20 + size.height, 15 ,15);
    [topView addSubview:timeImage];
    
    UILabel *timeLabel = [[UILabel alloc]init];
    timeLabel.textColor = [ColorUtil colorWithHexString:@"#999999"];
    timeLabel.font = [UIFont systemFontOfSize:13.0f];
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:_model.publishTs];
    timeLabel.text = [formatter stringFromDate:date];
    timeLabel.frame = CGRectMake(100, 20 + size.height, timeLabel.contentSize.width, timeLabel.contentSize.height);
    [topView addSubview:timeLabel];
    
}

-(void)initBody
{
    _scrollView = [[UIScrollView alloc]init];
    _scrollView.frame = CGRectMake(0, NavigationBar_HEIGHT + StatuBar_HEIGHT +TOP_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - (NavigationBar_HEIGHT +StatuBar_HEIGHT)-50 -TOP_HEIGHT);
    _scrollView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(uploadMore)];

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
                imageView.contentMode = UIViewContentModeScaleAspectFit;
                imageView.clipsToBounds = YES;
                [imageView sd_setImageWithURL:[NSURL URLWithString:model.data] placeholderImage:[UIImage imageNamed:@"bg_logo"]];
                imageView.frame = CGRectMake(15, 15 + contentHeight, SCREEN_WIDTH -30, SCREEN_WIDTH -30);
                [_scrollView addSubview:imageView];
                contentHeight += (SCREEN_WIDTH - 30 + 15);
            }
        }
    }
    
    bodyView.frame = CGRectMake(0, 0, SCREEN_WIDTH, contentHeight  + 15);
    [_scrollView setContentSize:CGSizeMake(SCREEN_WIDTH, contentHeight + 15 +COMMENTTITLE_HEIGHT)];
    
    [self requestCommentList:NO];
}


-(void)initComment
{
    _commentTitleView = [[UIView alloc]init];
    _commentTitleView.backgroundColor = [UIColor whiteColor];
    _commentTitleView.frame = CGRectMake(0, contentHeight + 30 , SCREEN_WIDTH, COMMENTTITLE_HEIGHT);
    [_scrollView addSubview:_commentTitleView];
    contentHeight += COMMENTTITLE_HEIGHT;
    
    UIView *view = [[UIView alloc]init];
    view.frame = CGRectMake(10, (COMMENTTITLE_HEIGHT - 32)/2, 6, 32);
    view.backgroundColor = [ColorUtil colorWithHexString:@"#2082D0"];
    view.layer.masksToBounds = YES;
    view.layer.cornerRadius = 3;
    [_commentTitleView addSubview:view];
    
    _commentTitleLabel = [[UILabel alloc]init];
    _commentTitleLabel.textColor = [UIColor blackColor];
    _commentTitleLabel.text = [NSString stringWithFormat:@"评论(%d)",_model.totalComment];
    _commentTitleLabel.font = [UIFont systemFontOfSize:16.0f];
    _commentTitleLabel.frame = CGRectMake(26, (COMMENTTITLE_HEIGHT - _commentTitleLabel.contentSize.height)/2, _commentTitleLabel.contentSize.width, _commentTitleLabel.contentSize.height);
    [_commentTitleView addSubview:_commentTitleLabel];

    
    _tableView = [[UITableView alloc]init];
    _tableView.frame = CGRectMake(0, contentHeight + 30 , SCREEN_WIDTH, 0);
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.scrollEnabled = NO;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.showsHorizontalScrollIndicator = NO;
    [_scrollView addSubview:_tableView];
    
    
}


-(void)initBottom
{
    _maskView = [[UIView alloc]init];
    _maskView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-50);
    _maskView.backgroundColor = LINE_COLOR;
    UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(TapOtherArea)];
    [_maskView addGestureRecognizer:recognizer];
    [self.view addSubview:_maskView];
    _maskView.hidden = YES;
    
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
    _commentTextView.holderDelegate = self;
    [_bottomView addSubview:_commentTextView];
    

    _sendButton = [[UIButton alloc]init];
    _sendButton.layer.masksToBounds = YES;
    _sendButton.layer.cornerRadius = 2;
    [_sendButton setImage:[UIImage imageNamed:@"home_out_n"] forState:UIControlStateNormal];
    [_sendButton setTitleColor:[ColorUtil colorWithHexString:@"#999999"] forState:UIControlStateNormal];
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
    if(!IS_NS_COLLECTION_EMPTY(_datas))
    {
        CommentModel *model = [_datas objectAtIndex:indexPath.row];
        _heightLabel.text = model.content;
//        CGSize size = [_heightLabel.text sizeWithFont:_heightLabel.font constrainedToSize:CGSizeMake(SCREEN_WIDTH - 60 , MAXFLOAT) lineBreakMode:NSLineBreakByCharWrapping];
        CGSize size  =[_heightLabel boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 60 , MAXFLOAT)];

        return size.height+50;
    }
    return 0;

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


//键盘拉起回调
- (void) keyboardWasShown:(NSNotification *) notif
{
//    if(!isKeyShow)
//    {
//        isKeyShow = YES;
    NSDictionary *info = [notif userInfo];
    NSValue *value = [info objectForKey:UIKeyboardFrameBeginUserInfoKey];
    CGSize keyboardSize = [value CGRectValue].size;
    NSLog(@"%f",keyboardSize.height);
    
    int keyboardHeight =302.666667;
    if(IS_IPHONE_5)
    {
        keyboardHeight = 253;
    }
    else if(IS_IPHONE_6)
    {
        keyboardHeight = 258;
    }
    
    _maskView.hidden = NO;
    __weak UIView *weakBottomView = _bottomView;

    [UIView animateWithDuration:0.2 animations:^{
        weakBottomView.frame = CGRectMake(0, SCREEN_HEIGHT - 50-keyboardHeight, SCREEN_WIDTH, 50);
    } completion:nil];
//    }
}

//键盘隐藏回调
- (void)keyboardWasHidden:(NSNotification *) notif
{
//    if(isKeyShow)
//    {
//        isKeyShow = NO;
        _maskView.hidden = YES;
        __weak UIView *weakBottomView = _bottomView;
        [UIView animateWithDuration:0.2 animations:^{
            weakBottomView.frame = CGRectMake(0, SCREEN_HEIGHT - 50, SCREEN_WIDTH, 50);
        } completion:nil];
//    }

}

#pragma mark 请求页面数据
-(void)requestData
{
    __weak MBProgressHUD *hua = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"mid"] = [NSString stringWithFormat:@"%d",_mid];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    [manager GET:Request_Msg_Detail parameters:params progress:^(NSProgress * _Nonnull downloadProgress) {
        
    }
         success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
             
             ResponseModel *model = [ResponseModel mj_objectWithKeyValues:responseObject];
             if(model.code == SUCCESS_CODE)
             {
                 id data = model.data;
                 _model = [MsgModel mj_objectWithKeyValues:data];
                 _model.picNotes = [PictureModel mj_objectArrayWithKeyValuesArray:_model.picNotes];
                 [self initTopView];
                 [self initBody];
                 [self initBottom];
                 [self initComment];
             }
             hua.hidden = YES;
         }
     
         failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull   error) {
             
             [_scrollView.footer endRefreshing];
             hua.hidden = YES;
         }];

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

    __weak MBProgressHUD *hua = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"uid"] = [account getUid];
    params[@"cid"] = [NSString stringWithFormat:@"%d",(int)[userDefaults integerForKey:VillageID]];
    params[@"mid"] = [NSString stringWithFormat:@"%ld", _model.mid];
    params[@"content"]= _commentTextView.text;
    params[@"token"] = [account getToken];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    
    
    [manager POST:Request_Comment parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        ResponseModel *model = [ResponseModel mj_objectWithKeyValues:responseObject];
        
        if(model.code == SUCCESS_CODE)
        {
            [DialogHelper showSuccessTips:@"评论成功，感谢您的支持"];
            [_datas removeAllObjects];
            CURRENT = 0;
            [self requestCommentList:YES];
            _commentTextView.text = nil;
            _model.totalComment +=1;
            _commentTitleLabel.text = [NSString stringWithFormat:@"评论(%d)",_model.totalComment];
            _countLabel.text = [NSString stringWithFormat:@"%d",_model.totalComment];
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
        hua.hidden = YES;

        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        hua.hidden = YES;
        [DialogHelper showWarnTips:@"评论失败"];
    }];

}


#pragma mark 获取评论列表
-(void)requestCommentList : (BOOL)isLoadMore
{
    __weak MBProgressHUD *hua;
    if(!isLoadMore)
    {
        hua = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    }
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"index"] = [NSString stringWithFormat:@"%d",CURRENT];
    params[@"length"] = [NSString stringWithFormat:@"%d",REQUEST_SIZE];
    params[@"mid"] = [NSString stringWithFormat:@"%ld",_model.mid];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    [manager GET:Request_CommentList parameters:params progress:^(NSProgress * _Nonnull downloadProgress) {
        
    }
         success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
             
             ResponseModel *model = [ResponseModel mj_objectWithKeyValues:responseObject];
             if(model.code == SUCCESS_CODE)
             {
                 id data = model.data;
                 NSMutableArray *requestDatas = [CommentModel mj_objectArrayWithKeyValuesArray:data];
                 
                 if(IS_NS_COLLECTION_EMPTY(requestDatas))
                 {
                     [_scrollView.footer noticeNoMoreData];
                     hua.hidden = YES;
                     return;
                 }
                 [_datas addObjectsFromArray:requestDatas];
                 
                 int tableViewHeight = 0;
                 int height = contentHeight + 30;
                 for(CommentModel *model in _datas)
                 {
                     _heightLabel.text = model.content;
                     CGSize size  =[_heightLabel boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 60 , MAXFLOAT) ];
                     
                     tableViewHeight += (size.height+50);
                 }
                 _tableView.frame = CGRectMake(0, contentHeight + 30 , SCREEN_WIDTH, tableViewHeight);
                 _scrollView.contentSize = CGSizeMake(SCREEN_WIDTH, height +tableViewHeight);
                 [_tableView reloadData];
             }
             [_scrollView.footer endRefreshing];
             hua.hidden = YES;
             
         }
     
         failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull   error) {
             
             [_scrollView.footer endRefreshing];
             hua.hidden = YES;
             
         }];
  
}


-(void)OnClickConfirm
{
    [self requestComment];
}
@end
