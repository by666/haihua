//
//  HomeViewController.h
//  haihua
//
//  Created by by.huang on 16/4/13.
//  Copyright © 2016年 by.huang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "VillageListView.h"

@interface HomeViewController : BaseViewController<VillageListViewDelegate>

+(void)show : (BaseViewController *)controller;

@end
