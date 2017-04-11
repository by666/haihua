//
//  FeedbackDetailViewController.m
//  haihua
//
//  Created by by.huang on 16/4/26.
//  Copyright © 2016年 by.huang. All rights reserved.
//

#import "FeedbackDetailViewController.h"
#import "TimeUtil.h"
#import "HeadUtil.h"
#import "CommentCell.h"
#import "MJRefresh.h"

#define ITEM_HEIGHT 100
#define REQUEST_SIZE 10
#define MORE_HEIGHT 50

@interface FeedbackDetailViewController ()

@property (strong , nonatomic) FeedbackModel *model;

@property (strong, nonatomic) UITableView *tableView;

@property (strong, nonatomic) UIScrollView *scrollView;

@property (strong, nonatomic) UILabel *heightLabel;

@property (strong, nonatomic) NSMutableArray *datas;


@end

@implementation FeedbackDetailViewController
{
    int CURRENT;
    int contentHeight;
    int Height;
}

+(void)show : (BaseViewController *)controller
       model: (FeedbackModel *)model
{
    FeedbackDetailViewController *openViewControler = [[FeedbackDetailViewController alloc]init];
    openViewControler.model = model;
    [controller.navigationController pushViewController:openViewControler animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _datas = [[NSMutableArray alloc]init];
    _heightLabel = [[UILabel alloc]init];
    _heightLabel.font = [UIFont systemFontOfSize:13.0f];
    _heightLabel.numberOfLines = 0;
    _heightLabel.lineBreakMode = NSLineBreakByCharWrapping;
    [self initView];
}


#pragma mark 初始化视图
- (void)initView{
    [self.view setBackgroundColor:BACKGROUND_COLOR];
    [self showNavigationBar];
    [self.navBar setTitle:@"详细"];
    
    _scrollView = [[UIScrollView alloc]init];
    _scrollView.frame = Default_Frame;
      _scrollView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(uploadMore)];
    [self.view addSubview:_scrollView];
    
    UIImageView *headImageView = [[UIImageView alloc]init];
    headImageView.image = [HeadUtil getHeadImage: _model.sex position:_model.avatar];
    headImageView.frame = CGRectMake(10, 10, 30, 30);
    [_scrollView addSubview:headImageView];
    
    UILabel *nameLabel = [[UILabel alloc]init];
    nameLabel.textColor = [UIColor blackColor];
    nameLabel.font = [UIFont systemFontOfSize:14.0f];
    nameLabel.text = _model.name;
    nameLabel.frame = CGRectMake(50, 10 + (30 - nameLabel.contentSize.height)/2, nameLabel.contentSize.width, nameLabel.contentSize.height);
    [_scrollView addSubview:nameLabel];
    
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:_model.ts];
    UILabel *timeLabel = [[UILabel alloc]init];
    timeLabel.textColor = [ColorUtil colorWithHexString:@"#000000" alpha:0.6f];
    timeLabel.font = [UIFont systemFontOfSize:14.0f];
    timeLabel.text =[TimeUtil formatTime: date];
    timeLabel.frame = CGRectMake(SCREEN_WIDTH - 10 - timeLabel.contentSize.width, 10 + (30 - timeLabel.contentSize.height)/2, timeLabel.contentSize.width, timeLabel.contentSize.height);
    [_scrollView addSubview:timeLabel];
    
    UILabel *contentLabel = [[UILabel alloc]init];
    contentLabel.textColor = [UIColor blackColor];
    contentLabel.font = [UIFont systemFontOfSize:14.0f];
    contentLabel.lineBreakMode = NSLineBreakByWordWrapping;
    contentLabel.numberOfLines = 0;
    contentLabel.text = _model.content;
    CGSize size = [contentLabel.text sizeWithFont:contentLabel.font constrainedToSize:CGSizeMake(SCREEN_WIDTH-20, MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping];
    contentLabel.frame = CGRectMake(10, headImageView.y + headImageView.height + 20, SCREEN_WIDTH -20, size.height);
    [_scrollView addSubview:contentLabel];
    
    if(!IS_NS_COLLECTION_EMPTY(_model.pictures))
    {
        for(int i=0 ; i < _model.pictures.count ; i++)
        {
            NSString *url = [_model.pictures objectAtIndex:i];
            UIImageView *imageView = [[UIImageView alloc]init];
            [imageView sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"bg_logo"]];
            imageView.contentMode = UIViewContentModeScaleAspectFill;
            imageView.clipsToBounds = YES;
            imageView.layer.cornerRadius = 4;
            imageView.layer.masksToBounds = YES;
            imageView.frame = CGRectMake(10,headImageView.y + headImageView.height + 20 + size.height + 10 * (i+1) + (SCREEN_WIDTH - 20)*i,SCREEN_WIDTH - 20,SCREEN_WIDTH - 20);
            [_scrollView addSubview:imageView];
        }
    }
    
    contentHeight = headImageView.y + headImageView.height + 20 + size.height
    + (SCREEN_WIDTH -20 + 10 ) * _model.pictures.count + 10;
    
    _tableView = [[UITableView alloc]init];
    _tableView.frame = CGRectMake(0, contentHeight, SCREEN_WIDTH, 0);
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.scrollEnabled = NO;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.showsHorizontalScrollIndicator = NO;
    [_scrollView addSubview:_tableView];
    
    [self requestCommentList:NO];
    
    [_scrollView setContentSize:CGSizeMake(SCREEN_WIDTH, contentHeight)];
}


#pragma mark 更新视图
-(void)uploadMore
{
    CURRENT += REQUEST_SIZE;
    [self requestCommentList : YES];
}


-(void)OnLeftClickCallback
{
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark 列表视图
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(IS_NS_COLLECTION_EMPTY(_datas))
    {
        return 0;
    }
    return [_datas count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(!IS_NS_COLLECTION_EMPTY(_datas))
    {
        CommentModel *model = [_datas objectAtIndex:indexPath.row];
        _heightLabel.text = model.content;
        CGSize size  =[_heightLabel boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 60 , MAXFLOAT)];
        
        return size.height+50;
    }
    return 0;}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    CommentCell *cell = [[CommentCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[CommentCell identify]];
   
    if(!IS_NS_COLLECTION_EMPTY(_datas))
    {
        [cell setData:[_datas objectAtIndex:indexPath.row]];
    }
    return  cell;
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
    params[@"mid"] = [NSString stringWithFormat:@"%d",_model.fid];
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
                 for(CommentModel *model in _datas)
                 {
                     _heightLabel.text = model.content;
                     CGSize size  =[_heightLabel boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 60 , MAXFLOAT) ];
                     tableViewHeight += (size.height+50);
                 }
                 _tableView.frame = CGRectMake(0, contentHeight + 30 , SCREEN_WIDTH, tableViewHeight);
                 _scrollView.contentSize = CGSizeMake(SCREEN_WIDTH, contentHeight + 30 +tableViewHeight);
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


@end
