
//
//  GuideViewController.m
//  haihua
//
//  Created by by.huang on 2017/3/12.
//  Copyright © 2017年 by.huang. All rights reserved.
//

#import "GuideViewController.h"
#import "MsgListViewController.h"
@interface GuideViewController ()


@end

@implementation GuideViewController
{
    NSArray *titles;
    NSArray *images;
}

+(void)show : (BaseViewController *)controller
{
    GuideViewController *openViewControler = [[GuideViewController alloc]init];
    [controller.navigationController pushViewController:openViewControler animated:YES];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:BACKGROUND_COLOR];
    titles = [[NSArray alloc]initWithObjects:@"民政",@"计生",@"城建",@"社保",@"安全",@"法律",@"劳动",@"房屋租赁",nil];
    images = [[NSArray alloc]initWithObjects:@"one_guide_minzheng",@"one_guide_jisheng",@"one_guide_chengjian",@"one_guide_shebao",@"one_guide_anquan",@"one_guide_falv",@"one_guide_laodong",@"one_guide_zufang",nil];
    [self showNavigationBar];
    [self.navBar setTitle:@"办事指南"];
    [self initView];
}


-(void)OnLeftClickCallback
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)initView
{
    int width = (SCREEN_WIDTH - 1 ) /  3;
    int height = NavigationBar_HEIGHT + StatuBar_HEIGHT + 10;
    int imageWidth = width /2;
    int imageY = width /6;
    int labelY = imageWidth + imageY + 10;

    
    for(int i = 0 ; i <[titles count] ; i++)
    {
        UIButton *button = [[UIButton alloc]init];
        [button setBackgroundImage:[AppUtil imageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
        button.tag = i;
        [button addTarget: self action:@selector(OnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:button];
        int m = i % 3;
        int row = i/3;
        switch (m) {
            case 0:
                button.frame = CGRectMake(0, height + row *(width + 0.5), width, width);
                break;
            case 1:
                button.frame = CGRectMake(width + 0.5, height + row *(width + 0.5), width, width);
                break;
            case 2:
                button.frame = CGRectMake(width * 2 + 1, height + row *(width + 0.5), width, width);
                break;
                
            default:
                break;
        }
        
        
        UIImageView *imageView = [[UIImageView alloc]init];
        UIImage *image = [UIImage imageNamed:[images objectAtIndex:i]];
        imageView.image = image;
        imageView.frame = CGRectMake((width - imageWidth)/2, imageY, imageWidth, imageWidth);
        [button addSubview:imageView];
        
        
        UILabel *label = [[UILabel alloc]init];
        label.textColor = [ColorUtil colorWithHexString:@"#333333"];
        label.text = [titles objectAtIndex:i];
        label.font = [UIFont systemFontOfSize: 14.0f];
        label.frame = CGRectMake((width - label.contentSize.width )/2, labelY, label.contentSize.width, label.contentSize.height);
        [button addSubview:label];
    
    }
    
    

}


-(void)OnClick : (id)sender
{
    UIButton *button = sender;
    int tag = (int)button.tag;
    NSString *temp;
    switch (tag) {
        case 0:
            temp = @"livelihood";
            break;
        case 1:
            temp = @"family_planning";
            break;
        case 2:
            temp = @"urban_construction";
            break;
        case 3:
            temp = @"social_security";
            break;
        case 4:
            temp = @"security";
            break;
        case 5:
            temp = @"law";
            break;
        case 6:
            temp = @"labour";
            break;
        case 7:
            temp = @"housing_lease";
            break;
        default:
            break;
    }
    [MsgListViewController show:self title:[titles objectAtIndex:tag] type:@"guide" mine: NO isVote: NO temp:temp];
    
}



@end
