//
//  SKLruList.h
//  SKUtils
//
//  Created by Shin-Kai Chen on 2016/3/29.
//  Copyright © 2016年 SK. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^SpillerBlock)(id _Nonnull object);

@interface SKLruList : NSObject

- (nonnull instancetype)initWithCapacity:(NSUInteger)capacity andSpiller:(nullable SpillerBlock)spiller;

- (void)touchObject:(nonnull id)object;
- (void)removeAllObjects;

@end
