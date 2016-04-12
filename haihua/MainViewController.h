//
//  MainViewController.h
//  haihua
//
//  Created by by.huang on 16/3/8.
//  Copyright © 2016年 by.huang. All rights reserved.
//

#import "BaseViewController.h"
@protocol MainDelegate

@optional -(void)OnSelectVillage : (int)villageId name : (NSString *)villageName;

@end

@interface MainViewController : BaseViewController<UITableViewDelegate,UITableViewDataSource,MainDelegate>

@property (assign , nonatomic) NSInteger villageId;

@property (copy, nonatomic) NSString *name;

+(void)show : (UIViewController *)controller villageId:(NSInteger)villageId name:(NSString *)name;

@end
