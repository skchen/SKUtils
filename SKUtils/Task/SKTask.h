//
//  SKTask.h
//  SKTaskUtils
//
//  Created by Shin-Kai Chen on 2016/3/27.
//  Copyright © 2016年 SK. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SKTask : NSObject

- (nonnull instancetype)initWithId:(nonnull id)id block:(void (^_Nonnull)(void))block;

@property(nonatomic, copy, readonly, nonnull) id id;
@property(nonatomic, copy, readonly, nonnull) void (^block)(void);

@end
