//
//  IDSRefresh.h
//  Radar
//
//  Created by freeman.feng on 15/12/10.
//  Copyright © 2015年 com.brotherhood. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "MJRefresh.h"

@interface IDSRefresh : NSObject

+ (MJRefreshNormalHeader *)headerWithRefreshingTarget:(id)target refreshingAction:(SEL)action;

+ (MJRefreshBackNormalFooter *)footerWithRefreshingTarget:(id)target refreshingAction:(SEL)action;

@end

