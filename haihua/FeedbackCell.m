//
//  FeedbackCell.m
//  haihua
//
//  Created by by.huang on 16/4/27.
//  Copyright © 2016年 by.huang. All rights reserved.
//

#import "FeedbackCell.h"
#import "TimeUtil.h"
#import "HeadUtil.h"
#define Item_Height 200

@interface FeedbackCell()

@property (strong, nonatomic) UIButton *rootView;

@property (strong, nonatomic) UIImageView *headImageView;

@property (strong, nonatomic) UILabel *nameLabel;

@property (strong, nonatomic) UILabel *timeLabel;

@property (strong, nonatomic) UILabel *contentLabel;

@property (strong, nonatomic) UIImageView *statuImageView;


@end

@implementation FeedbackCell

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
    self.contentView.frame = CGRectMake(0, 0, SCREEN_WIDTH, Item_Height);
    
    _rootView = [[UIButton alloc]init];
    _rootView.userInteractionEnabled = NO;
    _rootView.backgroundColor = [UIColor whiteColor];
    _rootView.layer.masksToBounds = YES;
    _rootView.layer.cornerRadius = 4;
    _rootView.frame = CGRectMake(10, 0, SCREEN_WIDTH - 20, Item_Height-10);
    [self.contentView addSubview:_rootView];
    
    _headImageView = [[UIImageView alloc]init];
    _headImageView.frame = CGRectMake(10, 10, 30, 30);
    [_rootView addSubview:_headImageView];
    
    _nameLabel = [[UILabel alloc]init];
    _nameLabel.textColor = [UIColor blackColor];
    _nameLabel.font = [UIFont systemFontOfSize:14.0f];
    [_rootView addSubview:_nameLabel];
    
    _contentLabel = [[UILabel alloc]init];
    _contentLabel.textColor = [UIColor blackColor];
    _contentLabel.font = [UIFont systemFontOfSize:14.0f];
    _contentLabel.lineBreakMode = NSLineBreakByWordWrapping | NSLineBreakByTruncatingTail;
    _contentLabel.numberOfLines = 0;
    [_rootView addSubview:_contentLabel];

    _timeLabel = [[UILabel alloc]init];
    _timeLabel.textColor = [ColorUtil colorWithHexString:@"#000000" alpha:0.6f];
    _timeLabel.font = [UIFont systemFontOfSize:14.0f];
    [_rootView addSubview:_timeLabel];

}

-(void)setFeedBackData : (FeedbackModel *)model
{
    _headImageView.image = [HeadUtil getHeadImage:model.sex position:model.avatar];

    _nameLabel.text = model.name;
    _nameLabel.frame = CGRectMake(50, 10 + (30 - _nameLabel.contentSize.height)/2, _nameLabel.contentSize.width, _nameLabel.contentSize.height);
    
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:model.ts];
    _timeLabel.text =[TimeUtil cl_prettyDateWithReference : date];
    _timeLabel.frame = CGRectMake(SCREEN_WIDTH - 30 - _timeLabel.contentSize.width, 10 + (30 - _timeLabel.contentSize.height)/2, _timeLabel.contentSize.width, _timeLabel.contentSize.height);
    
    _contentLabel.text = model.content;

    int imageWidth = (SCREEN_WIDTH - 60 )/3;
    if(!IS_NS_COLLECTION_EMPTY(model.pictures))
    {
        for(int i=0 ; i < model.pictures.count ; i++)
        {
            NSString *url = [model.pictures objectAtIndex:i];
            UIImageView *imageView = [[UIImageView alloc]init];
            [imageView sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"net_error"]];
            imageView.contentMode = UIViewContentModeScaleAspectFill;
            imageView.clipsToBounds = YES;
            imageView.layer.cornerRadius = 4;
            imageView.layer.masksToBounds = YES;
            imageView.frame = CGRectMake(10 * (i+1) + imageWidth * i, 50, imageWidth, imageWidth);
            [_rootView addSubview:imageView];
        }
        
        _contentLabel.frame = CGRectMake(10, 50+ imageWidth + 10, SCREEN_WIDTH -40 , 40);
        
    }
    else
    {
        _contentLabel.frame = CGRectMake(10, 50, SCREEN_WIDTH -40 , 40);
        _rootView.frame = CGRectMake(10, 0, SCREEN_WIDTH - 20, 110);
    }
}

+(NSString *)identify
{
    return @"FeedbackCell";
}

@end
