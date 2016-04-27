//
//  CommentMsgCell.m
//  haihua
//
//  Created by by.huang on 16/3/21.
//  Copyright © 2016年 by.huang. All rights reserved.
//

#import "CommentViewCell.h"
#import "AppUtil.h"
#import "TimeUtil.h"

#define Item_Height 110
#define Title_Height 40
#define Image_Width 80
@interface CommentViewCell()

@property (strong, nonatomic) UIButton *rootView;

@property (strong, nonatomic) UILabel *titleLabel;

@property (strong, nonatomic) UILabel *timeLabel;

@property (strong, nonatomic) UIImageView *commentImage;

@property (strong, nonatomic) UILabel *countLabel;

@property (strong, nonatomic) UIImageView *showImageView;

@end

@implementation CommentViewCell

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
    _timeLabel.textColor = [ColorUtil colorWithHexString:@"#a9b7b7"];
    _timeLabel.font = [UIFont systemFontOfSize:12.0f];
    [_rootView addSubview:_timeLabel];


    
    _commentImage = [[UIImageView alloc]init];
    _commentImage.image = [UIImage imageNamed:@"ic_talk"];
    [_rootView addSubview:_commentImage];
    
    _countLabel = [[UILabel alloc]init];
    _countLabel.textColor = [ColorUtil colorWithHexString:@"#a9b7b7"];
    _countLabel.font = [UIFont systemFontOfSize:12.0f];
    [_rootView addSubview:_countLabel];
    
}


-(void)setNewsData:(NewsModel *)model
{

    _showImageView.image = [UIImage imageNamed:@"test"];
    
    _titleLabel.text = model.title;
    if(IS_NS_COLLECTION_EMPTY(model.picNotes))
    {
        _showImageView.hidden = YES;
        _titleLabel.frame = CGRectMake(10, 10, SCREEN_WIDTH - 20 - 20 , Item_Height - 50);
    }
    else
    {
        PictureModel *picModel = [model.picNotes objectAtIndex:0];
        [_showImageView sd_setImageWithURL:[NSURL URLWithString:picModel.data] placeholderImage:[UIImage imageNamed:@"net_error"]];
        _titleLabel.frame = CGRectMake(10, 10, SCREEN_WIDTH - 50 -(Item_Height-30) , Item_Height - 50);
    }
    
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:model.publishTs];
    _timeLabel.text =[TimeUtil cl_prettyDateWithReference : date];
    _timeLabel.frame = CGRectMake(10, Item_Height-20 - _timeLabel.contentSize.height, _timeLabel.contentSize.width, _timeLabel.contentSize.height);
    
    
    _commentImage.frame = CGRectMake(100,  Item_Height-20 - _timeLabel.contentSize.height, 15, 15);

    _countLabel.text = [NSString stringWithFormat:@"%d",model.totalComment];
    _countLabel.frame = CGRectMake(_commentImage.x + _commentImage.width + 5, Item_Height-20 - _timeLabel.contentSize.height, _countLabel.contentSize.width, _countLabel.contentSize.height);
    
    
}

-(void)setFeedBackData:(FeedbackModel *)model
{
    
    _showImageView.image = [UIImage imageNamed:@"test"];
    
    _titleLabel.text = model.title;
    if(IS_NS_COLLECTION_EMPTY(model.pictures))
    {
        _showImageView.hidden = YES;
        _titleLabel.frame = CGRectMake(10, 10, SCREEN_WIDTH - 20 - 20 , Item_Height - 50);
    }
    else
    {
        [_showImageView sd_setImageWithURL:[NSURL URLWithString:[model.pictures objectAtIndex:0]] placeholderImage:[UIImage imageNamed:@"net_error"]];
        _titleLabel.frame = CGRectMake(10, 10, SCREEN_WIDTH - 50 -(Item_Height-30) , Item_Height - 50);
    }

    NSDate *date = [NSDate dateWithTimeIntervalSince1970:model.ts];
    _timeLabel.text =[TimeUtil cl_prettyDateWithReference : date];
    _timeLabel.frame = CGRectMake(10, Item_Height-20 - _timeLabel.contentSize.height, _timeLabel.contentSize.width, _timeLabel.contentSize.height);
    
    
    _commentImage.frame = CGRectMake(100,  Item_Height-20 - _timeLabel.contentSize.height, 15, 15);
    
    _countLabel.text = [NSString stringWithFormat:@"%d",0];
    _countLabel.frame = CGRectMake(_commentImage.x + _commentImage.width + 5, Item_Height-20 - _timeLabel.contentSize.height, _countLabel.contentSize.width, _countLabel.contentSize.height);
    
    
}

+(NSString *)identify
{
    return @"commentMsgCell";
}
@end
