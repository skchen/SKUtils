//
//  SKLruStorage.h
//  SKUtils
//
//  Created by Shin-Kai Chen on 2016/4/1.
//  Copyright © 2016年 SK. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "SKLruDictionary.h"

@interface SKLruStorage : SKLruDictionary

@property(nonatomic, strong, nonnull) NSFileManager *fileManager;

@end
