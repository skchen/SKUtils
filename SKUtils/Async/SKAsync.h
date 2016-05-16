//
//  SKAsync.h
//  SKUtils
//
//  Created by Shin-Kai Chen on 2016/5/13.
//  Copyright © 2016年 SK. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^SKTimeCallback)(NSTimeInterval interval);
typedef void (^SKErrorCallback)(NSError * _Nullable error);

@interface SKAsync : NSObject {
@protected
    dispatch_queue_t _workerQueue;
    dispatch_queue_t _callbackQueue;
}

@property(nonatomic, copy, nonnull) dispatch_queue_t workerQueue;
@property(nonatomic, copy, nonnull) dispatch_queue_t callbackQueue;

@end
