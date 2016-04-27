//
//  FeedbackDetailViewController.h
//  haihua
//
//  Created by by.huang on 16/4/26.
//  Copyright © 2016年 by.huang. All rights reserved.
//

#import "BaseViewController.h"
#import "FeedbackModel.h"
@interface FeedbackDetailViewController : BaseViewController<ByNavigationBarDelegate>

+(void)show : (BaseViewController *)controller
       model: (FeedbackModel *)model;

@end
