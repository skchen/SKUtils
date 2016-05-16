//
//  SKAsync.m
//  SKUtils
//
//  Created by Shin-Kai Chen on 2016/5/13.
//  Copyright © 2016年 SK. All rights reserved.
//

#import "SKAsync.h"

@implementation SKAsync

- (instancetype)init {
    self = [super init];
    
    NSString *bundleIdentifier = [[NSBundle mainBundle] bundleIdentifier];
    NSString *classIdentifier = NSStringFromClass([self class]);
    NSString *queueIdentifier = [NSString stringWithFormat:@"%@.%@", bundleIdentifier, classIdentifier];
    
    _workerQueue = dispatch_queue_create([queueIdentifier UTF8String], 0);
    _callbackQueue = dispatch_get_main_queue();
    
    return self;
}

- (nonnull SKTimeCallback)wrappedTimeCallback:(nonnull SKTimeCallback)original {
    return ^void(NSTimeInterval interval) {
        dispatch_async(_callbackQueue, ^{
            original(interval);
        });
    };
}

- (nonnull SKErrorCallback)wrappedErrorCallback:(nonnull SKErrorCallback)original {
    return ^void(NSError * _Nullable error) {
        dispatch_async(_callbackQueue, ^{
            original(error);
        });
    };
}

@end
