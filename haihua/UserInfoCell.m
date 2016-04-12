//
//  UserInfoCell.m
//  haihua
//
//  Created by by.huang on 16/3/29.
//  Copyright © 2016年 by.huang. All rights reserved.
//

#import "UserInfoCell.h"

@interface UserInfoCell()

@property (strong, nonatomic) UILabel *userTitleLabel;

@property (strong, nonatomic) UILabel *userContentLabel;

@property (strong, nonatomic) UIImageView *arrowImageView;


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
    _userTitleLabel = [[UILabel alloc]init];
    _userTitleLabel.textColor = [ColorUtil colorWithHexString:@"#000000" alpha:0.8f];
    _userTitleLabel.font  = [UIFont systemFontOfSize:13];
    [self.contentView addSubview:_userTitleLabel];
    
    _userContentLabel = [[UILabel alloc]init];
    _userContentLabel.textColor = [ColorUtil colorWithHexString:@"#000000" alpha:0.6f];
    _userContentLabel.font  = [UIFont systemFontOfSize:13];
    [self.contentView addSubview:_userContentLabel];
    
    _arrowImageView = [[UIImageView alloc]init];
    UIImage *image = [UIImage imageNamed:@"ic_right_arrow"];
    _arrowImageView.image = image;
    _arrowImageView.frame = CGRectMake(SCREEN_WIDTH - image.size.width-20, (self.contentView.height - image.size.height )/2, image.size.width, image.size.height);
    _arrowImageView.hidden = YES;
    [self.contentView addSubview:_arrowImageView];
    
    UIView *lineView = [[UIView alloc]init];
    lineView.backgroundColor = LINE_COLOR;
    lineView.frame = CGRectMake(0, self.bounds.size.height, SCREEN_WIDTH, 0.5);
    [self.contentView addSubview:lineView];
}


-(void)setData : (UserTableModel *)model;
{
    
    _userTitleLabel.text = model.title;
    _userTitleLabel.frame = CGRectMake(20, 0, 100, self.contentView.height);
    _userTitleLabel.centerY = self.contentView.height / 2;
    
    _userContentLabel.text = model.content;
    _userContentLabel.frame = CGRectMake(SCREEN_WIDTH - 20 - _userContentLabel.contentSize.width, 0, _userContentLabel.contentSize.width, self.contentView.height);
    _userContentLabel.centerY = self.contentView.height / 2;
    
    if(model.isClick)
    {
        _arrowImageView.hidden = NO;
    }
}

+(NSString *)identify
{
    return  @"UserInfoCell";
}
@end
