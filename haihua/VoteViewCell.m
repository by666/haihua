//
//  VoteViewCell.m
//  haihua
//
//  Created by by.huang on 2017/3/15.
//  Copyright © 2017年 by.huang. All rights reserved.
//

#import "VoteViewCell.h"
#import "CommentViewCell.h"
#import "AppUtil.h"
#import "TimeUtil.h"
#import "VoteItemCell.h"

#define Vote_Height 110
#define Top_Height 110
#define Title_Height 40
#define Image_Width 80
@interface VoteViewCell()

@property (strong, nonatomic) UIButton *rootView;

@property (strong, nonatomic) UILabel *titleLabel;

@property (strong, nonatomic) UIImageView *timeImage;

@property (strong, nonatomic) UILabel *timeLabel;

@property (strong, nonatomic) UIImageView *commentImage;

@property (strong, nonatomic) UILabel *countLabel;

@property (strong, nonatomic) UIImageView *showImageView;

@property (strong, nonatomic) UITableView *tableView;

@property (strong, nonatomic) NSMutableArray *datas;

@end

@implementation VoteViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if(self == [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        [self initView];
    }
    return self;
}

-(void)initView
{
    self.contentView.backgroundColor = BACKGROUND_COLOR;
    self.contentView.frame = CGRectMake(0, 0, SCREEN_WIDTH, Top_Height +200);
    
    
    _rootView = [[UIButton alloc]init];
    _rootView.userInteractionEnabled = NO;
    _rootView.backgroundColor = [UIColor whiteColor];
    _rootView.layer.masksToBounds = YES;
    _rootView.layer.cornerRadius = 4;
    _rootView.frame = CGRectMake(10, 0, SCREEN_WIDTH - 20, Top_Height +200-10);
    [self.contentView addSubview:_rootView];
    
    _showImageView = [[UIImageView alloc]init];
    _showImageView.frame = CGRectMake(SCREEN_WIDTH - 30 - Image_Width, 10, Image_Width, Image_Width);
    _showImageView.layer.masksToBounds = YES;
    _showImageView.layer.cornerRadius = 4;
    _showImageView.contentMode = UIViewContentModeScaleAspectFill;
    [_rootView addSubview:_showImageView];
    
    _titleLabel = [[UILabel alloc]init];
    _titleLabel.font = [UIFont systemFontOfSize:15.0f];
    _titleLabel.textColor = [UIColor blackColor];
    _titleLabel.textAlignment = NSTextAlignmentLeft;
    _titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    _titleLabel.numberOfLines = 0;
    [_rootView addSubview:_titleLabel];
    
    _timeLabel = [[UILabel alloc]init];
    _timeLabel.textColor = [ColorUtil colorWithHexString:@"#999999"];
    _timeLabel.font = [UIFont systemFontOfSize:12.0f];
    [_rootView addSubview:_timeLabel];
    
    
    
    _commentImage = [[UIImageView alloc]init];
    _commentImage.image = [UIImage imageNamed:@"home_vote"];
    [_rootView addSubview:_commentImage];
    
    _timeImage = [[UIImageView alloc]init];
    _timeImage.image = [UIImage imageNamed:@"home_time"];
    [_rootView addSubview:_timeImage];
    
    _countLabel = [[UILabel alloc]init];
    _countLabel.textColor = [ColorUtil colorWithHexString:@"#999999"];
    _countLabel.font = [UIFont systemFontOfSize:12.0f];
    [_rootView addSubview:_countLabel];
    
}



-(void)setNewsData:(MsgModel *)model
{
    _datas = [[NSMutableArray alloc]init];
    _datas = model.options;


    _titleLabel.text = model.title;
    BOOL hasImage = NO;
    if(!IS_NS_COLLECTION_EMPTY(model.picNotes))
    {
        for(PictureModel *picModel in model.picNotes)
        {
            if(picModel.pic == 1)
            {
                hasImage = YES;
                break;
            }
        }
    }
    if(!hasImage)
    {
        _showImageView.hidden = YES;
        _titleLabel.frame = CGRectMake(10, 10, SCREEN_WIDTH - 20 - 20 , Top_Height - 50);
    }
    else
    {
        PictureModel *picModel = [model.picNotes objectAtIndex:0];
        [_showImageView sd_setImageWithURL:[NSURL URLWithString:picModel.data] placeholderImage:[UIImage imageNamed:@"bg_logo"]];
        _titleLabel.frame = CGRectMake(10, 10, SCREEN_WIDTH - 50 -(Top_Height-30) , Top_Height - 50);
    }
    
    
    
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:model.publishTs];
    _timeLabel.text =[TimeUtil formatTime: date];
    _timeLabel.frame = CGRectMake(80, Top_Height-20 - _timeLabel.contentSize.height, _timeLabel.contentSize.width, _timeLabel.contentSize.height);
    
    _timeImage.frame = CGRectMake(60,  Top_Height-20 - _timeLabel.contentSize.height, 15, 15);
    
    
    _commentImage.frame = CGRectMake(10,  Top_Height-20 - _timeLabel.contentSize.height, 15, 15);
    
    _countLabel.text = [NSString stringWithFormat:@"%d",model.totalComment];
    _countLabel.frame = CGRectMake(_commentImage.x + _commentImage.width + 5, Top_Height-20 - _timeLabel.contentSize.height, _countLabel.contentSize.width, _countLabel.contentSize.height);
    
    int height = _countLabel.y+_countLabel.contentSize.height ;
  
    UIView *listView = [[UIView alloc]init];
    listView.frame = CGRectMake(10, height, SCREEN_WIDTH - 20, [model.options count] *Vote_Height);
    
    for(int i = 0 ; i < [model.options count]; i++)
    {
        VoteModel *voteModel = [model.options objectAtIndex:i];
        [self buildView:listView model:voteModel position:i total:model.totalComment];
    }
   
    [_rootView addSubview:listView];
    
}



+(NSString *)identify
{
    return @"VoteViewCell";
}

-(void)buildView : (UIView *)view model : (VoteModel *)model position : (int)position total : (int)allTotal
{
    
        int ProgressWidth = SCREEN_WIDTH - 60;
        
        UIView *bgView = [[UIView alloc]init];
        bgView.frame = CGRectMake(10, 10 + 50 * position, ProgressWidth, 50-10);
        bgView.layer.masksToBounds = YES;
        bgView.backgroundColor  = LINE_COLOR;
        bgView.layer.cornerRadius = (50 - 10 )/2;
        bgView.userInteractionEnabled = NO;
        [view addSubview:bgView];
        
        UIView *progressView = [[UIView alloc]init];
        progressView.layer.masksToBounds = YES;
        progressView.userInteractionEnabled = NO;
        progressView.backgroundColor  = LINE_COLOR;
        progressView.frame = CGRectMake(10, 10 + 50 * position, 0, 50-10);
        [view addSubview:progressView];
        
        UILabel *optionLabel = [[UILabel alloc]init];
        optionLabel.textColor = [UIColor blackColor];
        optionLabel.font = [UIFont systemFontOfSize:16.0f];
        optionLabel.backgroundColor = [UIColor clearColor];
        optionLabel.frame = CGRectMake(10, 10 + 50 * position, ProgressWidth, 50-10);
        optionLabel.textAlignment = NSTextAlignmentCenter;
        [view addSubview:optionLabel];
        
        UILabel *percentLabel = [[UILabel alloc]init];
        percentLabel.textColor = [ColorUtil colorWithHexString:@"#000000" alpha:0.6f];
        percentLabel.font = [UIFont systemFontOfSize:14.0f];
        percentLabel.hidden = YES;
        [view addSubview:percentLabel];
    
    optionLabel.text = model.option;
    
    float percent = 0;
    if(allTotal > 0)
    {
        model.hasVote = YES;
        percent = (float)model.total / (float)allTotal;
    }
    percentLabel.text = [[NSString stringWithFormat:@"%.1f",percent * 100] stringByAppendingString:@"%"];
    percentLabel.frame = CGRectMake(SCREEN_WIDTH - 50 - percentLabel.contentSize.width-20, 10 + 50 * position , percentLabel.contentSize.width, 50-10);
    
    if(model.hasVote)
    {
        percentLabel.hidden = NO;
       
        progressView.backgroundColor  = [ColorUtil colorWithHexString:@"#ffcdb1"];
    
        
        [UIView animateWithDuration:2.0f animations:^{
            progressView.frame = CGRectMake(10, 10 + 50 * position,  ProgressWidth * percent, 50-10);
        } completion:^(BOOL finished) {
            
        }];
        
        if(ProgressWidth * percent > ProgressWidth - (50 - 10 )/2)
        {
            progressView.layer.cornerRadius = (50 - 10 )/2;
        }
        else
        {
            CAShapeLayer *maskLayer = [CAShapeLayer layer];
            maskLayer.path = [UIBezierPath bezierPathWithRoundedRect:progressView.bounds byRoundingCorners: UIRectCornerTopLeft | UIRectCornerBottomLeft cornerRadii: (CGSize){(50 - 10 )/2, (50 - 10 )/2}].CGPath;
            progressView.layer.mask = maskLayer;
        }
        
    }
    else
    {
        percentLabel.hidden = YES;
        if(model.isSeleted)
        {
            bgView.backgroundColor  = [UIColor orangeColor];
        }
        else
        {
            bgView.backgroundColor  = LINE_COLOR;
        }
    }
}
@end
