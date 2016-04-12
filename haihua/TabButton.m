//
//  TabButton.m
//  haihua
//
//  Created by by.huang on 16/3/22.
//  Copyright © 2016年 by.huang. All rights reserved.
//

#import "TabButton.h"
#import "AppUtil.h"

@interface TabButton()

@property (strong, nonatomic) UIImageView *tabImageView;

@property (strong, nonatomic) UILabel *tabLabel;

@property (copy, nonatomic) NSString *text;

@property (strong, nonatomic) UIImage *normalImage;

@property (strong, nonatomic) UIImage *pressImage;

@end
@implementation TabButton

-(instancetype)initWithImageAndText : (NSString *)text normal:(UIImage *)normalImage
                 pressImage : (UIImage *)pressImage
{
    if(self == [super init])
    {
        _text = text;
        _normalImage = normalImage;
        _pressImage = pressImage;
        [self initView];
    }
    return self;
}

-(void)initView
{
    self.frame = CGRectMake(0, 0, SCREEN_WIDTH/2, 50);
    
//    [self setBackgroundImage:[AppUtil imageWithColor:[UIColor clearColor]] forState:UIControlStateNormal];
//    [self setBackgroundImage:[AppUtil imageWithColor:[ColorUtil colorWithHexString:@"#f2f2f2"]] forState:UIControlStateHighlighted];
    
    _tabImageView = [[UIImageView alloc]init];
    _tabImageView.image = _normalImage;
    _tabImageView.frame = CGRectMake(0, 0, 20, 20);
    _tabImageView.center = CGPointMake(SCREEN_WIDTH/4, 18);
    [self addSubview:_tabImageView];
    
    _tabLabel = [[UILabel alloc]init];
    _tabLabel.text = _text;
    _tabLabel.font = [UIFont systemFontOfSize:11.0f];
    _tabLabel.textColor = [ColorUtil colorWithHexString:@"#a9b7b7"];
    _tabLabel.frame = CGRectMake(0, 0, _tabLabel.contentSize.width, _tabLabel.contentSize.height);
    _tabLabel.center = CGPointMake(SCREEN_WIDTH/4, 38);
    [self addSubview:_tabLabel];
    
    
}

-(void)changeState:(TabButtonType) type
{
    if(type == Normal)
    {
        _tabImageView.image = _normalImage;
        _tabLabel.textColor = [ColorUtil colorWithHexString:@"#a9b7b7"];
    }
    else if(type == Press)
    {
        _tabImageView.image = _pressImage;
        _tabLabel.textColor = MAIN_COLOR;
    }
}

@end
