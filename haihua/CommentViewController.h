//
//  MainViewController.h
//  haihua
//
//  Created by by.huang on 16/3/8.
//  Copyright © 2016年 by.huang. All rights reserved.
//

#import "BaseViewController.h"

@interface CommentViewController : BaseViewController<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate>

+(void)show : (BaseViewController *)controller title: (NSString *)title;

@end