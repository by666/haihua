//
//  VoteDetalViewController.h
//  haihua
//
//  Created by by.huang on 16/3/24.
//  Copyright © 2016年 by.huang. All rights reserved.
//

#import "BaseViewController.h"
#import "NewsModel.h"

@interface VoteDetalViewController : BaseViewController<UINavigationBarDelegate,UIScrollViewDelegate,UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate>

+(void)show : (BaseViewController *)controller model: (NewsModel *)model;

@end
