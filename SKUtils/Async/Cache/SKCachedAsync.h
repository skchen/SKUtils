//
//  SKCachedAsync.h
//  SKUtils
//
//  Created by Shin-Kai Chen on 2016/6/3.
//  Copyright © 2016年 SK. All rights reserved.
//

#import "SKAsync.h"

@interface SKCachedAsync : SKAsync

+ (nonnull NSString *)cacheKeyWithElements:(NSUInteger)numberOfElements, ...;

@end
