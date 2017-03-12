//
//  BaseViewController.m
//  haihua
//
//  Created by by.huang on 16/3/8.
//  Copyright © 2016年 by.huang. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()


@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.hidden = YES;
    self.automaticallyAdjustsScrollViewInsets = NO;
}


-(void)showNavigationBar
{
    _navBar = [[ByNavigationBar alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, StatuBar_HEIGHT +NavigationBar_HEIGHT)];
    _navBar.delegate = self;
    [self.view addSubview:_navBar];
    
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleDefault];
}


@end
