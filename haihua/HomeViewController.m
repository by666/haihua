//
//  HomeViewController.m
//  haihua
//
//  Created by by.huang on 16/4/13.
//  Copyright © 2016年 by.huang. All rights reserved.
//

#import "HomeViewController.h"
#import "CommentViewController.h"
#import "UserInfoViewController.h"
#import "Account.h"
#import "LoginViewController.h"
#import "FeedbackListViewController.h"
#define BUTTON_WIDTH 70

@interface HomeViewController()

@property (strong , nonatomic) UIButton *button1;

@property (strong , nonatomic) UIButton *button2;

@property (strong , nonatomic) UIButton *button3;

@property (strong , nonatomic) UIButton *button4;

@property (strong , nonatomic) UIButton *button5;

@property (strong , nonatomic) UIButton *personButton;

@end

@implementation HomeViewController

+(void)show : (BaseViewController *)controller
{
    HomeViewController *openController = [[HomeViewController alloc]init];
    [controller.navigationController pushViewController:openController animated:YES];
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    [self initView];
}

-(void)initView
{
    int left = (SCREEN_WIDTH - BUTTON_WIDTH * 3)/4;
    
    [self.view setBackgroundColor:[UIColor blueColor]];
    
    _button1 = [self build:_button1 image:[UIImage imageNamed:@"ic_ppp"] text:@"居民议事" frame:CGRectMake(left +(left + BUTTON_WIDTH)/2,SCREEN_HEIGHT/2-BUTTON_WIDTH,BUTTON_WIDTH,BUTTON_WIDTH)];
    _button2 = [self build:_button2 image:[UIImage imageNamed:@"ic_ttt"] text:@"投票做主" frame:CGRectMake(left +(left + BUTTON_WIDTH) *3/2 ,SCREEN_HEIGHT/2-BUTTON_WIDTH,BUTTON_WIDTH,BUTTON_WIDTH)];
    
    _button3 = [self build:_button3 image:[UIImage imageNamed:@"ic_sss"] text:@"办事指南" frame:CGRectMake(left,SCREEN_HEIGHT/2+50,BUTTON_WIDTH,BUTTON_WIDTH)];
    _button4 = [self build:_button4 image:[UIImage imageNamed:@"ic_bbb"] text:@"意见采集" frame:CGRectMake(left *2+BUTTON_WIDTH,SCREEN_HEIGHT/2+50,BUTTON_WIDTH,BUTTON_WIDTH)];
    _button5 = [self build:_button5 image:[UIImage imageNamed:@"ic_qqq"] text:@"其他小区" frame:CGRectMake(left *3+BUTTON_WIDTH *2,SCREEN_HEIGHT/2+50,BUTTON_WIDTH,BUTTON_WIDTH)];
    
    _personButton = [[UIButton alloc]init];
    _personButton.frame = CGRectMake(SCREEN_WIDTH - 15 -40 , 40, 40, 40);
    [_personButton setImage:[UIImage imageNamed:@"ic_our"] forState:UIControlStateNormal];
    [_personButton addTarget:self action:@selector(OnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_personButton];


}

-(UIButton *)build : (UIButton *)button
       image : (UIImage *)image
        text : (NSString *)text
       frame : (CGRect)rect
{
    button = [[UIButton alloc]init];
    button.frame = rect;
    [button setImage:image forState:UIControlStateNormal];
    [button addTarget:self action:@selector(OnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    UILabel *label1 = [[UILabel alloc]init];
    label1.text = text;
    label1.textColor = [UIColor whiteColor];
    label1.font = [UIFont systemFontOfSize:14.0f];
    label1.textAlignment = NSTextAlignmentCenter;
    label1.frame = CGRectMake(rect.origin.x, button.y + button.height+5, rect.size.width, label1.contentSize.height);
    [self.view addSubview:label1];
    
    return button;
}


-(void)OnClick : (id)sender
{
    UIButton *button = sender;
    if(button == _button1)
    {
        [CommentViewController show:self title:@"居民议事"];
    }
    else if(button == _button2)
    {
        [CommentViewController show:self title:@"投票做主"];
    }
    else if(button == _button3)
    {
        [CommentViewController show:self title:@"办事指南"];
    }
    else if(button == _button4)
    {
        [FeedbackListViewController show:self];
    }
    else if(button == _button5)
    {
        
        VillageListView *view = [[VillageListView alloc]init];
        view.delegate = self;
        [self.view addSubview:view];
    }
    else if(button == _personButton)
    {
        if([[Account sharedAccount]isLogin])
        {
            [UserInfoViewController show:self];
        }
        else
        {
            [LoginViewController show:self];
        }

    }
}

-(void)OnSelectVillage:(VillageModel *)model
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setInteger:model.villageId forKey:VillageID];
    [userDefaults setValue:model.name forKey:VillageName];
}

@end
