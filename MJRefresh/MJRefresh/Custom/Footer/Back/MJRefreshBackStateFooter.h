//
//  MJRefreshBackStateFooter.h
//  MJRefreshExample
//
//  Created by MJ Lee on 15/6/13.
//  Copyright © 2015年 小码哥. All rights reserved.
//

#import "MJRefreshBackFooter.h"

enum MainColorType
{
    COLOR_TYPE_WHITE = 0,
    COLOR_TYPE_BLACK
};

@interface MJRefreshBackStateFooter : MJRefreshBackFooter
/** 显示刷新状态的label */
@property (weak, nonatomic, readonly) UILabel *stateLabel;
/** 字体等颜色类型*/
@property enum MainColorType colorType;
/** 设置state状态下的文字 */
- (void)setTitle:(NSString *)title forState:(MJRefreshState)state;
@end
