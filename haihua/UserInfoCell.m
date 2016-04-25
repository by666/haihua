//
//  UserInfoCell.m
//  haihua
//
//  Created by by.huang on 16/3/29.
//  Copyright © 2016年 by.huang. All rights reserved.
//

#import "UserInfoCell.h"
#define Item_Height 50

@interface UserInfoCell()

@property (strong, nonatomic) UIImageView *userImageView;

@property (strong, nonatomic) UILabel *userTitleLabel;

@property (strong, nonatomic) UILabel *userContentLabel;

@property (strong, nonatomic) UIImageView *arrowImageView;

@property (strong, nonatomic) UIView *lineView;


@end

@implementation UserInfoCell

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
    _userImageView = [[UIImageView alloc]init];
    [self.contentView addSubview:_userImageView];
    
    _userTitleLabel = [[UILabel alloc]init];
    _userTitleLabel.textColor = [ColorUtil colorWithHexString:@"#000000" alpha:0.8f];
    _userTitleLabel.font  = [UIFont systemFontOfSize:13];
    [self.contentView addSubview:_userTitleLabel];
    
    _userContentLabel = [[UILabel alloc]init];
    _userContentLabel.textColor = [ColorUtil colorWithHexString:@"#000000" alpha:0.6f];
    _userContentLabel.font  = [UIFont systemFontOfSize:13];
    [self.contentView addSubview:_userContentLabel];
    
    _arrowImageView = [[UIImageView alloc]init];
    UIImage *image = [UIImage imageNamed:@"ic_arow"];
    _arrowImageView.image = image;
    _arrowImageView.frame = CGRectMake(SCREEN_WIDTH - image.size.width-20, (Item_Height - image.size.height )/2, image.size.width, image.size.height);
    _arrowImageView.hidden = YES;
    [self.contentView addSubview:_arrowImageView];
    
    _lineView = [[UIView alloc]init];
    _lineView.backgroundColor = LINE_COLOR;
    _lineView.frame = CGRectMake(0, Item_Height-0.5, SCREEN_WIDTH, 0.5);
    [self.contentView addSubview:_lineView];
}


-(void)setData : (UserTableModel *)model;
{
    UIImage *image = model.image;
    _userImageView.image = model.image;
    _userImageView.frame = CGRectMake(15, (Item_Height - image.size.height )/2, image.size.width, image.size.height);
    
    _userTitleLabel.text = model.title;
    _userTitleLabel.frame = CGRectMake(25 + image.size.width, 0, 100,Item_Height);
    _userTitleLabel.centerY = Item_Height / 2;
    
    _userContentLabel.text = model.content;
    if(model.isClick && !IS_NS_STRING_EMPTY(model.content))
    {
        _userContentLabel.frame = CGRectMake(SCREEN_WIDTH - 20 - _userContentLabel.contentSize.width -20, 0, _userContentLabel.contentSize.width, Item_Height);
    }
    else
    {
        _userContentLabel.frame = CGRectMake(SCREEN_WIDTH - 20 - _userContentLabel.contentSize.width, 0, _userContentLabel.contentSize.width, Item_Height);
    }
    _userContentLabel.centerY = Item_Height / 2;
    
    if(model.isClick)
    {
        _arrowImageView.hidden = NO;
    }
}

-(void)hideLine
{
    [_lineView setHidden:YES];
}


+(NSString *)identify
{
    return  @"UserInfoCell";
}
@end
