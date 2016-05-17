//
//  SKPagedList.h
//  SKUtils
//
//  Created by Shin-Kai Chen on 2016/5/17.
//  Copyright © 2016年 SK. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SKPagedList : NSObject

@property(nonatomic, strong, nullable) id nextPage;
@property(nonatomic, strong, readonly, nonnull) NSMutableArray *list;
@property(nonatomic, assign) BOOL finished;

@end