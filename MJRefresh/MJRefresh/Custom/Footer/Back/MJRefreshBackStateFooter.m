//
//  MJRefreshBackStateFooter.m
//  MJRefreshExample
//
//  Created by MJ Lee on 15/6/13.
//  Copyright © 2015年 小码哥. All rights reserved.
//

#import "MJRefreshBackStateFooter.h"

@interface MJRefreshBackStateFooter()
{
    /** 显示刷新状态的label */
    __weak UILabel *_stateLabel;
}
/** 所有状态对应的文字 */
@property (strong, nonatomic) NSMutableDictionary *stateTitles;
@end

@implementation MJRefreshBackStateFooter
#pragma mark - 懒加载
- (NSMutableDictionary *)stateTitles
{
    if (!_stateTitles) {
        self.stateTitles = [NSMutableDictionary dictionary];
    }
    return _stateTitles;
}

- (UILabel *)stateLabel
{
    if (!_stateLabel) {
        [self addSubview:_stateLabel = [UILabel label]];
    }
    return _stateLabel;
}

#pragma mark - 公共方法
- (void)setTitle:(NSString *)title forState:(MJRefreshState)state
{
    if (title == nil) return;
    self.stateTitles[@(state)] = title;
    self.stateLabel.text = self.stateTitles[@(self.state)];
}

#pragma mark - 重写父类的方法
- (void)prepare
{
    [super prepare];
    
    // 初始化文字
    [self setTitle:MJRefreshBackFooterIdleText forState:MJRefreshStateIdle];
    [self setTitle:MJRefreshBackFooterPullingText forState:MJRefreshStatePulling];
    [self setTitle:MJRefreshBackFooterRefreshingText forState:MJRefreshStateRefreshing];
    [self setTitle:MJRefreshBackFooterNoMoreDataText forState:MJRefreshStateNoMoreData];
}

- (void)placeSubviews
{
    [super placeSubviews];
    
    // 状态标签
    self.stateLabel.frame = self.bounds;
    
    if (self.state == MJRefreshStateNoMoreData)
    {
        UIView *leftline = [self viewWithTag:101];
        UIView *rightline = [self viewWithTag:102];
        CGRect selfframe = self.frame;
        CGSize stateSize = self.stateLabel.contentSize;
        int space = 20;
        if([[UIScreen mainScreen] bounds].size.height >= 600) //IPHONE6以上
        {
            space += 10;
        }
        if(leftline)
        {
            leftline.frame = CGRectMake(space, selfframe.size.height/2, (selfframe.size.width-stateSize.width)/2 - space*2, 0.5f);
        }
        if (rightline)
        {
            rightline.frame = CGRectMake(selfframe.size.width/2+stateSize.width/2+space, selfframe.size.height/2, leftline.frame.size.width, 0.5f);
        }
    }
}

- (void)setState:(MJRefreshState)state
{
    MJRefreshCheckState
    
    // 设置状态文字
    self.stateLabel.text = self.stateTitles[@(state)];
    
    
    if (state == MJRefreshStateNoMoreData)
    {
        
        float color = 255;
        if (_colorType == COLOR_TYPE_BLACK) {
            color = 0;
        }
        CGRect selfframe = self.frame;
        CGSize stateSize = self.stateLabel.contentSize;
        
        int space = 20;
        if([[UIScreen mainScreen] bounds].size.height >= 600) //IPHONE6以上
        {
            space += 10;
        }
        
        self.stateLabel.textColor = [UIColor colorWithRed:color green:color blue:color alpha:0.5f];
        UIView *leftline = [self viewWithTag:101];
        if (leftline == nil)
        {
            leftline = [[UIView alloc]init];
            [leftline setBackgroundColor:[UIColor colorWithRed:color green:color blue:color alpha:0.1f]];
            [leftline setTag:101];
            [self addSubview:leftline];
        }
        leftline.frame = CGRectMake(space, selfframe.size.height/2, (selfframe.size.width-stateSize.width)/2 - space*2, 0.5f);
        leftline.hidden = NO;
        
        UIView *rightline = [self viewWithTag:102];
        if (rightline == nil)
        {
            rightline = [[UIView alloc]init];
            [rightline setBackgroundColor:[UIColor colorWithRed:color green:color blue:color alpha:0.1f]];
            [rightline setTag:102];
            [self addSubview:rightline];
        }
        rightline.frame = CGRectMake(selfframe.size.width/2+stateSize.width/2+space, selfframe.size.height/2, leftline.frame.size.width, 0.5f);
        rightline.hidden = NO;
    }
    else
    {
        if (_colorType == COLOR_TYPE_BLACK)
        {
            self.stateLabel.textColor = [UIColor blackColor];
        }
        else
        {
            self.stateLabel.textColor = [UIColor whiteColor];
        }
        UIView *leftline = [self viewWithTag:101];
        if (leftline != nil && !leftline.hidden)
        {
            leftline.hidden = YES;
        }
        UIView *rightline = [self viewWithTag:102];
        if (rightline != nil && !rightline.hidden)
        {
            rightline.hidden = YES;
        }
    }
}
@end
