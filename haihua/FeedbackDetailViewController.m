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

@interface FeedbackDetailViewController ()

@property (strong , nonatomic) FeedbackModel *model;

@end

@implementation FeedbackDetailViewController

+(void)show : (BaseViewController *)controller
       model: (FeedbackModel *)model
{
    FeedbackDetailViewController *openViewControler = [[FeedbackDetailViewController alloc]init];
    openViewControler.model = model;
    [controller.navigationController pushViewController:openViewControler animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
}

#pragma mark 初始化视图
- (void)initView{
    [self.view setBackgroundColor:BACKGROUND_COLOR];
    [self showNavigationBar];
    [self.navBar setTitle:@"详细"];
    
    UIScrollView *scrollView = [[UIScrollView alloc]init];
    scrollView.frame = Default_Frame;
    [self.view addSubview:scrollView];
    
    UIImageView *headImageView = [[UIImageView alloc]init];
    headImageView.image = [HeadUtil getHeadImage: _model.sex position:_model.avatar];
    headImageView.frame = CGRectMake(10, 10, 30, 30);
    [scrollView addSubview:headImageView];
    
    UILabel *nameLabel = [[UILabel alloc]init];
    nameLabel.textColor = [UIColor blackColor];
    nameLabel.font = [UIFont systemFontOfSize:14.0f];
    nameLabel.text = _model.name;
    nameLabel.frame = CGRectMake(50, 10 + (30 - nameLabel.contentSize.height)/2, nameLabel.contentSize.width, nameLabel.contentSize.height);
    [scrollView addSubview:nameLabel];
    
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:_model.ts];
    UILabel *timeLabel = [[UILabel alloc]init];
    timeLabel.textColor = [ColorUtil colorWithHexString:@"#000000" alpha:0.6f];
    timeLabel.font = [UIFont systemFontOfSize:14.0f];
    timeLabel.text =[TimeUtil cl_prettyDateWithReference : date];
    timeLabel.frame = CGRectMake(SCREEN_WIDTH - 10 - timeLabel.contentSize.width, 10 + (30 - timeLabel.contentSize.height)/2, timeLabel.contentSize.width, timeLabel.contentSize.height);
    [scrollView addSubview:timeLabel];
    
    UILabel *contentLabel = [[UILabel alloc]init];
    contentLabel.textColor = [UIColor blackColor];
    contentLabel.font = [UIFont systemFontOfSize:14.0f];
    contentLabel.lineBreakMode = NSLineBreakByWordWrapping;
    contentLabel.numberOfLines = 0;
    contentLabel.text = _model.content;
    CGSize size = [contentLabel.text sizeWithFont:contentLabel.font constrainedToSize:CGSizeMake(SCREEN_WIDTH-20, MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping];
    contentLabel.frame = CGRectMake(10, headImageView.y + headImageView.height + 20, SCREEN_WIDTH -20, size.height);
    [scrollView addSubview:contentLabel];
    
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
            [scrollView addSubview:imageView];
        }
    }
    
    [scrollView setContentSize:CGSizeMake(SCREEN_WIDTH, headImageView.y + headImageView.height + 20 + size.height
                                          + (SCREEN_WIDTH -20 + 10 ) * _model.pictures.count + 10)];
}



-(void)OnLeftClickCallback
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
