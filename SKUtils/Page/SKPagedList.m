//
//  SKPagedList.m
//  SKUtils
//
//  Created by Shin-Kai Chen on 2016/5/17.
//  Copyright © 2016年 SK. All rights reserved.
//

#import "SKPagedList.h"

@implementation SKPagedList

- (nonnull instancetype)init {
    self = [super init];
    _list = [[NSMutableArray alloc] init];
    _finished = NO;
    return self;
}

@end
