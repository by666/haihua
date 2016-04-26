//
//  FeedbackListViewController.h
//  haihua
//
//  Created by by.huang on 16/4/26.
//  Copyright © 2016年 by.huang. All rights reserved.
//

#import "BaseViewController.h"

@interface FeedbackListViewController : BaseViewController<UITableViewDelegate,UITableViewDataSource>

+(void)show : (BaseViewController *)controller;

@end
