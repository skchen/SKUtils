//
//  SKLruStorage.h
//  SKUtils
//
//  Created by Shin-Kai Chen on 2016/4/1.
//  Copyright © 2016年 SK. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "SKLruTable.h"

@interface SKLruStorage : SKLruTable

- (nonnull instancetype)initWithConstraint:(NSUInteger)constraint andCoster:(nullable id<SKLruCoster>)coster andSpiller:(nullable id<SKLruTableSpiller>)spiller andFileManager:(nullable NSFileManager *)fileManager;

@end
