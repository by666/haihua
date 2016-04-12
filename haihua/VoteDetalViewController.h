//
//  VoteDetalViewController.h
//  haihua
//
//  Created by by.huang on 16/3/24.
//  Copyright © 2016年 by.huang. All rights reserved.
//

#import "BaseViewController.h"
#import "MessageModel.h"

@interface VoteDetalViewController : BaseViewController<UINavigationBarDelegate,UIScrollViewDelegate,UITableViewDelegate,UITableViewDataSource>

+(void)show : (BaseViewController *)controller model: (MessageModel *)model;

@end
