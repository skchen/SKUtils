//
//  SKAsync_Protected.h
//  SKUtils
//
//  Created by Shin-Kai Chen on 2016/5/13.
//  Copyright © 2016年 SK. All rights reserved.
//

#import "SKAsync.h"

@interface SKAsync ()

- (nonnull SKTimeCallback)wrappedTimeCallback:(nonnull SKTimeCallback)original;
- (nonnull SKErrorCallback)wrappedErrorCallback:(nonnull SKErrorCallback)original;

@end
