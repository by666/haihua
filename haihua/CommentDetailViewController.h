//
//  CommentDetailViewController.h
//  haihua
//
//  Created by by.huang on 16/3/24.
//  Copyright © 2016年 by.huang. All rights reserved.
//

#import "BaseViewController.h"
#import "MessageModel.h"
@interface CommentDetailViewController : BaseViewController<UINavigationBarDelegate,UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate>


+(void)show : (BaseViewController *)controller model: (MessageModel *)model;

@end