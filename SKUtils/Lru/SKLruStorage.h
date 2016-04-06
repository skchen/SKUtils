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

- (nonnull instancetype)initWithFileManager:(nonnull NSFileManager *)fileManager andLruTable:(nonnull SKLruTable *)lruTable andCoster:(nonnull id<SKLruCoster>)coster andSpiller:(nonnull id<SKLruTableSpiller>)spiller;

@end
