//
//  FeedBackTableViewController.m
//  haihua
//
//  Created by by.huang on 16/4/18.
//  Copyright © 2016年 by.huang. All rights reserved.
//

#import "FeedBackTableViewController.h"

#define REQUEST_SIZE 2

@interface FeedBackTableViewController ()

@end

@implementation FeedBackTableViewController
{
    int CURRENT;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self requestFeedBack];
}

-(void)requestFeedBack
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSInteger villageId = [userDefaults integerForKey:VillageID];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"cid"] = [NSString stringWithFormat:@"%d",(int)villageId];
    params[@"index"] = [NSString stringWithFormat:@"%d",CURRENT];
    params[@"length"] = [NSString stringWithFormat:@"%d",REQUEST_SIZE];
    
    [manager GET:Request_FeedBack_List parameters:params
     
         success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         ResponseModel *model = [ResponseModel mj_objectWithKeyValues:responseObject];
         if(model.code == SUCCESS_CODE)
         {
         }
         [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
     }
         failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
     }];

}




@end
