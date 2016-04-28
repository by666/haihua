//
//  LogoutViewController.m
//  haihua
//
//  Created by by.huang on 16/4/28.
//  Copyright © 2016年 by.huang. All rights reserved.
//

#import "LogoutViewController.h"
#import "Account.h"
#import "LoginViewController.h"

@interface LogoutViewController ()

@end

@implementation LogoutViewController

+(void)show : (BaseViewController *)controller
{
    LogoutViewController *openController = [[LogoutViewController alloc]init];
    [controller.navigationController pushViewController:openController animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
    
}

-(void)initView
{
    self.view.backgroundColor = BACKGROUND_COLOR;
    [self initNavigationBar];
    
    UIButton *logoutBtn = [[UIButton alloc]init];
    logoutBtn.backgroundColor = [UIColor whiteColor];
    [logoutBtn setTitle:@"退出登陆" forState:UIControlStateNormal];
    [logoutBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    logoutBtn.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    logoutBtn.frame = CGRectMake(0, NavigationBar_HEIGHT + StatuBar_HEIGHT, SCREEN_WIDTH, 50);
    [logoutBtn addTarget:self action:@selector(logout) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:logoutBtn];
}

-(void)initNavigationBar
{
    [self showNavigationBar];
    [self.navBar setTitle:@"设置"];
}


-(void)OnLeftClickCallback
{
    [self.navigationController popViewControllerAnimated:YES];
}


-(void)logout
{
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"是否退出登陆?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alertView show];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 1)
    {
        [[Account sharedAccount] logout];
        [LoginViewController show:self close:YES];
    }
}

@end
