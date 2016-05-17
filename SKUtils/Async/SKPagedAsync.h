//
//  SKPagedAsync.h
//  SKUtils
//
//  Created by Shin-Kai Chen on 2016/5/17.
//  Copyright © 2016年 SK. All rights reserved.
//

#import <SKUtils/SKUtils.h>

typedef void (^SKPagedListCallback)(NSArray  * _Nonnull list, BOOL finished);

@interface SKPagedAsync : SKAsync

@end
