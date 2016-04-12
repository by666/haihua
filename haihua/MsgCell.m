//
//  CommentMsgCell.m
//  haihua
//
//  Created by by.huang on 16/3/21.
//  Copyright © 2016年 by.huang. All rights reserved.
//

#import "MsgCell.h"
#import "AppUtil.h"


#define Item_Height 190
#define Title_Height 40
@interface MsgCell()

@property (strong, nonatomic) UIButton *rootView;

@property (strong, nonatomic) UILabel *titleLabel;

@property (strong, nonatomic) UILabel *contentLabel;

@property (strong, nonatomic) UIImageView *commentImage;

@property (strong, nonatomic) UILabel *countLabel;

@property (strong, nonatomic) UILabel *timeLabel;

@end

@implementation MsgCell

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
    _rootView.layer.borderWidth = 1;
    _rootView.layer.borderColor = [LINE_COLOR CGColor];
    _rootView.layer.masksToBounds = YES;
    _rootView.layer.cornerRadius = 4;
    _rootView.frame = CGRectMake(15, 0, SCREEN_WIDTH-30, Item_Height-10);
    [self.contentView addSubview:_rootView];
    
    UIView *topLine = [[UIView alloc]init];
    topLine.backgroundColor = LINE_COLOR;
    topLine.frame = CGRectMake(10, Title_Height, SCREEN_WIDTH-50, 0.5);
    [_rootView addSubview:topLine];
    
    _titleLabel = [[UILabel alloc]init];
    _titleLabel.font = [UIFont systemFontOfSize:15.0f];
    _titleLabel.textColor = [UIColor blackColor];
    _titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    [_rootView addSubview:_titleLabel];
    
    _contentLabel = [[UILabel alloc]init];
    _contentLabel.font = [UIFont systemFontOfSize:12.0f];
    _contentLabel.textColor = [ColorUtil colorWithHexString:@"#000000" alpha:0.6f];
    _contentLabel.numberOfLines = 0;
    _contentLabel.lineBreakMode = NSLineBreakByWordWrapping | NSLineBreakByTruncatingTail;
    [_rootView addSubview:_contentLabel];
    
    UIView *bottomLine = [[UIView alloc]init];
    bottomLine.backgroundColor = LINE_COLOR;
    bottomLine.frame = CGRectMake(10, Item_Height-10 - 40, SCREEN_WIDTH-50, 0.5);
    [_rootView addSubview:bottomLine];
    
    UIButton *commentView = [[UIButton alloc]init];
    commentView.frame = CGRectMake(SCREEN_WIDTH - 100, Item_Height-10 - 40, 100, 40);
    [_rootView addSubview:commentView];
    
    _commentImage = [[UIImageView alloc]init];
    _commentImage.image = [UIImage imageNamed:@"ic_commend_normal"];
    _commentImage.frame = CGRectMake(0, 10, 20, 20);
    [commentView addSubview:_commentImage];
    
    _countLabel = [[UILabel alloc]init];
    _countLabel.textColor = [ColorUtil colorWithHexString:@"#a9b7b7"];
    _countLabel.font = [UIFont systemFontOfSize:14.0f];
    [commentView addSubview:_countLabel];
    
    _timeLabel = [[UILabel alloc]init];
    _timeLabel.textColor = [ColorUtil colorWithHexString:@"#a9b7b7"];
    _timeLabel.font = [UIFont systemFontOfSize:14.0f];
    [_rootView addSubview:_timeLabel];
    
}


-(void)setData:(MessageModel *)model
{
    _titleLabel.text = model.title;
    _titleLabel.frame = CGRectMake(0, 0, SCREEN_WIDTH - 50, _titleLabel.contentSize.height);
    _titleLabel.center = CGPointMake((SCREEN_WIDTH -30)/2, 20);
    
    _contentLabel.text = model.content;
    _contentLabel.frame = CGRectMake(10, Title_Height + 5, SCREEN_WIDTH - 50, Item_Height-Title_Height -60);
    
    if([model.type isEqualToString:@"comment"])
    {
        _countLabel.text = [NSString stringWithFormat:@"%d",model.totalComment];
    }
    else
    {
        _commentImage.image = [UIImage imageNamed:@"ic_vote_normal"];
        _countLabel.text = @"投票";
    }
    _countLabel.frame = CGRectMake(25, 5, _countLabel.contentSize.width, _countLabel.contentSize.height);
    _countLabel.centerY = 20;
    
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:model.publishTs];
    _timeLabel.text =[formatter stringFromDate:date];
    _timeLabel.frame = CGRectMake(10, Item_Height-10 - 40, _timeLabel.contentSize.width, _timeLabel.contentSize.height);
    _timeLabel.centerY = Item_Height-30;
    
}

+(NSString *)identify
{
    return @"commentMsgCell";
}
@end
