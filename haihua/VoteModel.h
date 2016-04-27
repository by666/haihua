//
//  VoteModel.h
//  haihua
//
//  Created by by.huang on 16/3/30.
//  Copyright © 2016年 by.huang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VoteModel : NSObject

@property (assign ,nonatomic) int voId;

@property (assign ,nonatomic) int total;

@property (assign ,nonatomic) int allTotal;

@property (copy ,nonatomic) NSString *option;

@property (assign, nonatomic) BOOL isSeleted;

@property (assign, nonatomic) BOOL hasVote;

@property (copy, nonatomic) NSString *myOption;

@end
