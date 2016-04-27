//
//  CommentCell.m
//  haihua
//
//  Created by by.huang on 16/3/26.
//  Copyright © 2016年 by.huang. All rights reserved.
//

#import "CommentCell.h"
#import "TimeUtil.h"

@interface CommentCell()

@property (strong , nonatomic) UILabel *nameLabel;

@property (strong , nonatomic) UILabel *contentLabel;

@property (strong , nonatomic) UILabel *timeLabel;

@property (strong , nonatomic) UIImageView *genderImageView;


@end
@implementation CommentCell


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
    _genderImageView = [[UIImageView alloc]init];
    _genderImageView.frame = CGRectMake(10, 10, 30, 30);
    [self.contentView addSubview:_genderImageView];
    
    _nameLabel = [[UILabel alloc]init];
    _nameLabel.font = [UIFont systemFontOfSize:15.0f];
    _nameLabel.textColor = [UIColor blackColor];
    [self.contentView addSubview:_nameLabel];
    
    _contentLabel = [[UILabel alloc]init];
    _contentLabel.font = [UIFont systemFontOfSize:13.0f];
    _contentLabel.textColor = [ColorUtil colorWithHexString:@"#000000" alpha:0.6];
    _contentLabel.numberOfLines = 0;
      _contentLabel.lineBreakMode = NSLineBreakByWordWrapping | NSLineBreakByTruncatingTail;
    [self.contentView addSubview:_contentLabel];
    
    _timeLabel = [[UILabel alloc]init];
    _timeLabel.font = [UIFont systemFontOfSize:13.0f];
    _timeLabel.textColor = [ColorUtil colorWithHexString:@"#000000" alpha:0.8];
    [self.contentView addSubview:_timeLabel];
}

-(void)setData:(CommentModel *)model
{
    if([model.sex isEqualToString:@"man"])
    {
        _genderImageView.image = [UIImage imageNamed:@"ic_head_male"];
    }
    else
    {
        _genderImageView.image = [UIImage imageNamed:@"ic_head_female"];
    }
    
    _nameLabel.text = model.name;
    _nameLabel.frame = CGRectMake(_genderImageView.x + 30 + 5, 10 + (30 - _nameLabel.contentSize.height)/2, _nameLabel.contentSize.width, _nameLabel.contentSize.height);
    
    _contentLabel.text = model.content;
    _contentLabel.frame = CGRectMake(_genderImageView.x + 30 + 5, _genderImageView.y + 30, SCREEN_WIDTH - (_genderImageView.x + 30 + 5) - 10 , 48);
    
 
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:model.ts];
    _timeLabel.text =[TimeUtil cl_prettyDateWithReference:date];
    _timeLabel.frame = CGRectMake(SCREEN_WIDTH - 15 - _timeLabel.contentSize.width , 10 + (30 - _nameLabel.contentSize.height)/2, _timeLabel.contentSize.width,_timeLabel.contentSize.height);
}

+(NSString *)identify
{
    return @"commentCell";
}

@end
