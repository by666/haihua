//
//  IDSRefresh.m
//  Radar
//
//  Created by freeman.feng on 15/12/10.
//  Copyright © 2015年 com.brotherhood. All rights reserved.
//

#import "IDSRefresh.h"


@interface IDSRefresh()

@end

@implementation IDSRefresh

+(MJRefreshNormalHeader *)headerWithRefreshingTarget:(id)target refreshingAction:(SEL)action
{
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:target
                                                                     refreshingAction:action];
        //设置文字
    [header setTitle:@"下拉开始刷新" forState:MJRefreshStateIdle];
    [header setTitle:@"松开立即刷新" forState:MJRefreshStatePulling];
    [header setTitle:@"正在刷新数据中..." forState:MJRefreshStateRefreshing];

    // 设置字体
    header.stateLabel.font = [UIFont systemFontOfSize:12];
    header.stateLabel.textColor = [UIColor whiteColor];
    header.lastUpdatedTimeLabel.hidden = YES;
    
    header.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhite;
    header.arrowView.hidden = YES;
    
    return header;
}

+(MJRefreshBackNormalFooter *)footerWithRefreshingTarget:(id)target refreshingAction:(SEL)action
{
    MJRefreshBackNormalFooter *footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:target refreshingAction:action];
    //设置文字
    [footer setTitle:@"正在加载数据..." forState:MJRefreshStateRefreshing];
    [footer setTitle:@"已经到底啦" forState:MJRefreshStateNoMoreData];
    
    footer.stateLabel.textColor = [UIColor whiteColor];
    footer.stateLabel.font = [UIFont systemFontOfSize:12];
    
    footer.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhite;
    footer.arrowView.hidden = YES;
    
    footer.colorType = COLOR_TYPE_WHITE;
    
    footer.scrollViewContentAddBottom = 45;
    
    return footer;
}


@end