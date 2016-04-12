//
//  VoteItemCell.h
//  haihua
//
//  Created by by.huang on 16/3/31.
//  Copyright © 2016年 by.huang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VoteModel.h"

@interface VoteItemCell : UITableViewCell

-(void)setData : (VoteModel *)model;

+(NSString *)identify;

@end
