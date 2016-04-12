//
//  BaseViewController.h
//  haihua
//
//  Created by by.huang on 16/3/8.
//  Copyright © 2016年 by.huang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ByNavigationBar.h"


@interface BaseViewController : UIViewController<ByNavigationBarDelegate>


@property (strong, nonatomic) ByNavigationBar *navBar;

@property (strong,nonatomic) UIButton *leftBtn;

@property (strong,nonatomic) UILabel *titleLabel;

-(void)showNavigationBar;


@end
