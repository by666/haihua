//
//  ByNavigationBar.m
//  haihua
//
//  Created by by.huang on 16/3/8.
//  Copyright © 2016年 by.huang. All rights reserved.
//

#import "ByNavigationBar.h"
#import "UILabel+ContentSize.h"

@implementation ByNavigationBar


-(instancetype)initWithFrame:(CGRect)frame
{
    if(self == [super initWithFrame:frame])
    {
        [self initView];
    }
    return self;
}

-(void)initView
{
    self.backgroundColor = MAIN_COLOR;
    self.userInteractionEnabled = YES;
    _leftBtn = [[UIButton alloc]init];
    _leftBtn.frame = CGRectMake(0, StatuBar_HEIGHT, NavigationBar_HEIGHT, NavigationBar_HEIGHT);
    [_leftBtn setContentEdgeInsets:UIEdgeInsetsMake(10, 10, 10, 10)];
    [_leftBtn addTarget:self action:@selector(OnLeftCallBack) forControlEvents:UIControlEventTouchUpInside];
    [_leftBtn setImage:[UIImage imageNamed:@"ic_back"] forState:UIControlStateNormal];
    
    _titleLabel = [[UILabel alloc]init];
    _titleLabel.textColor = [UIColor whiteColor];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.font = [UIFont systemFontOfSize:16.0f];
    
    _titleClickBtn= [[UIButton alloc]init];
    _titleClickBtn.frame = self.frame;
    _titleClickBtn.backgroundColor = [UIColor clearColor];
    _titleClickBtn.hidden = YES;
    [_titleClickBtn addTarget:self action:@selector(OnTapTitle) forControlEvents:UIControlEventTouchUpInside];
    
    
    [self addSubview:_leftBtn];
    [self addSubview:_titleLabel];
    [self addSubview:_titleClickBtn];
}

-(void)OnTapTitle
{
    if(self.delegate)
    {
        [self.delegate OnTitleClick];
    }
}

-(void)setTitleClick : (BOOL)isClick
{
    if(isClick)
    {
        [_titleClickBtn setHidden:NO];
        return;
    }
    [_titleClickBtn setHidden:YES];
}
    
-(void)setTitle:(NSString *)title
{
    if(_titleLabel)
    {
        [_titleLabel setText:title];
        float height = _titleLabel.contentSize.height;
        _titleLabel.frame = CGRectMake(30, StatuBar_HEIGHT + (NavigationBar_HEIGHT - height)/2, SCREEN_WIDTH - 60, height);
    }
}

-(void)OnLeftCallBack
{
    if(self.delegate)
    {
        [self.delegate OnLeftClickCallback];
    }
}





@end
