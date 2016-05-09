//
//  AboutViewController.m
//  haihua
//
//  Created by by.huang on 16/3/29.
//  Copyright © 2016年 by.huang. All rights reserved.
//

#import "AboutViewController.h"

@interface AboutViewController ()

@end

@implementation AboutViewController

+(void)show : (BaseViewController *)controller
{
    AboutViewController *target = [[AboutViewController alloc]init];
    [controller.navigationController pushViewController:target animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = BACKGROUND_COLOR;
    [self initView];
}

-(void)initView
{
    [self initNavigationBar];
    [self initMainView];
}



-(void)initNavigationBar
{
    [self showNavigationBar];
    [self.navBar.leftBtn setHidden:NO];
    self.navBar.delegate = self;
    [self.navBar.leftBtn setImage:[UIImage imageNamed:@"ic_back"] forState:UIControlStateNormal];
    [self.navBar setTitle:@"关于"];
}

-(void)initMainView
{
    UIImageView *imageView = [[UIImageView alloc]init];
    UIImage *image = [UIImage imageNamed:@"ic_appicon"];
    imageView.image = image;
    imageView.frame = CGRectMake((SCREEN_WIDTH - image.size.width)/2,NavigationBar_HEIGHT + StatuBar_HEIGHT+ 50, image.size.width, image.size.height);
    [self.view addSubview:imageView];
    
    
    UILabel *appNameLabel = [[UILabel alloc]init];
    appNameLabel.text = @"海华e事通 v1.0";
    appNameLabel.textColor = [UIColor blackColor];
    appNameLabel.font = [UIFont systemFontOfSize:15.0f];
    appNameLabel.frame = CGRectMake((SCREEN_WIDTH - appNameLabel.contentSize.width)/2, imageView.y + imageView.size.height + 20, appNameLabel.contentSize.width, appNameLabel.contentSize.height);
    [self.view addSubview:appNameLabel];
    
    UILabel *fromLabel = [[UILabel alloc]init];
    fromLabel.text = @"深圳市宝安区海华社区工作站 版权所有";
    fromLabel.textColor = [ColorUtil colorWithHexString:@"#000000" alpha:0.6f];
    fromLabel.font = [UIFont systemFontOfSize:12.0f];
    fromLabel.textAlignment = NSTextAlignmentCenter;
    fromLabel.frame = CGRectMake(0, SCREEN_HEIGHT - fromLabel.contentSize.height - 30, SCREEN_WIDTH, fromLabel.contentSize.height);
    [self.view addSubview:fromLabel];
    
    UILabel *copyRightLabel = [[UILabel alloc]init];
    copyRightLabel.text = @"Copyright ©2016 Scrat.All Right Reserve.";
    copyRightLabel.textColor = [ColorUtil colorWithHexString:@"#000000" alpha:0.6f];
    copyRightLabel.font = [UIFont systemFontOfSize:12.0f];
    copyRightLabel.textAlignment = NSTextAlignmentCenter;
    copyRightLabel.frame = CGRectMake(0, SCREEN_HEIGHT - copyRightLabel.contentSize.height - 10, SCREEN_WIDTH, copyRightLabel.contentSize.height);
    [self.view addSubview:copyRightLabel];
    
    
}

-(void)OnLeftClickCallback
{
    [self.navigationController popViewControllerAnimated:YES];
}
@end
