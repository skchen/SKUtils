//
//  SKTask.m
//  SKTaskUtils
//
//  Created by Shin-Kai Chen on 2016/3/27.
//  Copyright © 2016年 SK. All rights reserved.
//

#import "SKTask.h"

@implementation SKTask

- (instancetype)initWithId:(id)id block:(void (^_Nonnull)(void))block {
    self = [super init];
    
    _id = id;
    _block = block;
    
    return self;
}

- (BOOL)isEqual:(id)object {
    if([object isKindOfClass:[SKTask class]]) {
        SKTask *rightHandSide = (SKTask *)object;
        return [_id isEqual:rightHandSide.id];
    }
    
    return [super isEqual:object];
}

@end
