//
//  VillageListCell.m
//  haihua
//
//  Created by by.huang on 16/3/13.
//  Copyright © 2016年 by.huang. All rights reserved.
//

#import "VillageListCell.h"

@interface VillageListCell()

@property (strong, nonatomic) UILabel *contentLabel;

@end

@implementation VillageListCell


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
    _contentLabel = [[UILabel alloc]init];
    _contentLabel.font = [UIFont systemFontOfSize:15.0f];
    _contentLabel.textColor = [ColorUtil colorWithHexString:@"#000000"];
    _contentLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:_contentLabel];
}

-(void)setData:(NSString *)name
{
    _contentLabel.text = name;
    _contentLabel.frame = CGRectMake(0, 0, _contentLabel.contentSize.width, _contentLabel.contentSize.height);
    _contentLabel.center = self.contentView.center;
}

+(NSString *)identify
{
    return @"villageListCell";
}

@end
