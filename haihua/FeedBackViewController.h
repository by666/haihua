//
//  FeedBackViewController.h
//  haihua
//
//  Created by by.huang on 16/3/31.
//  Copyright © 2016年 by.huang. All rights reserved.
//

#import "BaseViewController.h"

@interface FeedBackViewController : BaseViewController<ByNavigationBarDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIActionSheetDelegate>

+(void)show : (BaseViewController *)controller;


@end
