//
//  VillageCell.m
//  haihua
//
//  Created by by.huang on 16/4/25.
//  Copyright © 2016年 by.huang. All rights reserved.
//

#import "VillageCell.h"

@interface VillageCell()

@property (strong , nonatomic) UIButton *button;

@end

@implementation VillageCell


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
    _button = [[UIButton alloc]init];
    _button.layer.masksToBounds = YES;
    _button.layer.cornerRadius = self.bounds.size.height/2;
    _button.layer.borderColor = [[UIColor blackColor] CGColor];
    _button.layer.borderWidth = 1;
    _button.userInteractionEnabled = NO;
    [_button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    _button.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    _button.frame = CGRectMake(0, 5, SCREEN_WIDTH - 60, 40);
    [self.contentView addSubview:_button];
}

-(void)setData : (VillageModel *)model
{
    [_button setTitle:model.name forState:UIControlStateNormal];
}

-(void)setSelect : (BOOL) select
{
    if(select)
    {
        [_button setBackgroundImage:[AppUtil imageWithColor:[ColorUtil colorWithHexString:@"e6a880" ]] forState:UIControlStateNormal];
    }
    else
    {
        [_button setBackgroundImage:nil forState:UIControlStateNormal];
    }
}

+(NSString *)identify
{
    return @"VillageCell";
}

@end
