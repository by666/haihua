//
//  VillageListViewController.h
//  haihua
//
//  Created by by.huang on 16/3/13.
//  Copyright © 2016年 by.huang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"


@interface VillageListViewController : BaseViewController<UITableViewDelegate,UITableViewDataSource>

//是否从完善资料跳转
@property (assign, nonatomic) BOOL isFromImprove;

@property (assign, nonatomic) BOOL isFromMain;

@property (strong, nonatomic) id delegate;

@end
