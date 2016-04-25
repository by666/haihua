//
//  VillageCell.h
//  haihua
//
//  Created by by.huang on 16/4/25.
//  Copyright © 2016年 by.huang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VillageModel.h"
@interface VillageCell : UITableViewCell

-(void)setData : (VillageModel *)model;

-(void)setSelect : (BOOL) select;

+(NSString *)identify;

@end
