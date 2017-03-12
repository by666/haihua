//
//  CommentDetailViewController.h
//  haihua
//
//  Created by by.huang on 16/3/24.
//  Copyright © 2016年 by.huang. All rights reserved.
//

#import "BaseViewController.h"
#import "MsgModel.h"
#import "UIPlaceholderTextView.h"
@interface CommentDetailViewController : BaseViewController<UINavigationBarDelegate,UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate,UIPlaceholderTextViewDelegate>


+(void)show : (BaseViewController *)controller model: (MsgModel *)model;

+(void)show : (BaseViewController *)controller mid: (int)mid;

@end
