//
//  CommentListViewController.h
//  haihua
//
//  Created by by.huang on 16/3/27.
//  Copyright © 2016年 by.huang. All rights reserved.
//

#import "BaseViewController.h"

@interface CommentListViewController : BaseViewController<UINavigationBarDelegate,UITableViewDelegate,UITableViewDataSource>

@property (copy, nonatomic) NSString *mid;

+(void)show : (BaseViewController *)controller mid : (NSString *)mid;

@end
