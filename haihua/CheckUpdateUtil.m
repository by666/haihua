
//
//  CheckUpdateUtil.m
//  haihua
//
//  Created by by.huang on 16/5/11.
//  Copyright © 2016年 by.huang. All rights reserved.
//

#import "CheckUpdateUtil.h"
#import "UpdateModel.h"

#define APPID @"1098800414"

@implementation CheckUpdateUtil
{
    NSString *downUrl;
}

SINGLETON_IMPLEMENTION(CheckUpdateUtil);


-(void)check
{
    
    NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
    float currentVersion = [[infoDic valueForKey:@"CFBundleShortVersionString"] floatValue];
    
    NSDictionary *params = @{@"id":APPID};

   // NSMutableDictionary *params = [NSMutableDictionary dictionary];
    //params[@"id"] = APPID;
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager GET:@"http://itunes.apple.com/lookup" parameters:params progress:^(NSProgress * _Nonnull downloadProgress) {
        
    }
         success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
             
             UpdateModel *model = [UpdateModel mj_objectWithKeyValues:responseObject];
             int resultCount =model.resultCount;
             if(resultCount > 0)
             {
                 NSMutableArray *resultArray = model.results;
                 if(!IS_NS_COLLECTION_EMPTY(resultArray))
                 {
                     NSDictionary *dic= [resultArray objectAtIndex:0];
                     float appstoreVersion = [[dic objectForKey:@"version"] floatValue];
                     downUrl = [dic objectForKey:@"trackViewUrl"];
                     if(appstoreVersion > currentVersion)
                     {
                         [self showUpdateDialog];
                     }
                 }
             }
             
         }
     
         failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull   error) {
             
             NSLog(@"%@",error);  //这里打印错误信息
             
         }];

}

-(void)showUpdateDialog
{
    
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"发现新版本" message:@"是否更新到最新版本？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alertView show];
}


-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 1)
    {
        if(!IS_NS_STRING_EMPTY(downUrl))
        {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:downUrl]];
        }

    }
}

@end
