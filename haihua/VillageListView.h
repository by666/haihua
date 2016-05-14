//
//  VillageListView.h
//  haihua
//
//  Created by by.huang on 16/4/25.
//  Copyright © 2016年 by.huang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VillageModel.h"
#import "UserModel.h"

@protocol VillageListViewDelegate

@optional -(void)OnSelectVillage : (VillageModel *)model;

@end

@interface VillageListView : UIView<UITableViewDelegate,UITableViewDataSource>

@property (strong , nonatomic) id delegate;

@property (strong , nonatomic) UserModel *userModel;

-(instancetype)initWithData : (UserModel *)userModel;

@end
