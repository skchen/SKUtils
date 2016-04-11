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

@property(nonatomic, strong, nonnull) NSFileManager *fileManager;

- (nonnull instancetype)initWithConstraint:(NSUInteger)constraint;

@end
