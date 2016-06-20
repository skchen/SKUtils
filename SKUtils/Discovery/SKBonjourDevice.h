//
//  SKBonjourDevice.h
//  SKUtils
//
//  Created by Shin-Kai Chen on 2016/6/20.
//  Copyright © 2016年 SK. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SKBonjourDevice : NSObject<NSCoding>

@property(nonatomic, copy, nonnull, readonly) NSString *ip;
@property(nonatomic, readonly) int port;

- (nonnull instancetype)initWithNetService:(nonnull NSNetService *)netService;

@end
