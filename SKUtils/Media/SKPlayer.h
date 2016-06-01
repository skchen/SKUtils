//
//  SKPlayer.h
//  SKUtils
//
//  Created by Shin-Kai Chen on 2016/4/19.
//  Copyright © 2016年 SK. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "SKAsync.h"

typedef NS_ENUM(NSUInteger, SKPlayerState) {
    SKPlayerStopped,
    SKPlayerPreparing,
    SKPlayerPrepared,
    SKPlayerStarted,
    SKPlayerPaused
};

@class SKPlayer;

@protocol SKPlayerDelegate <NSObject>

@optional
- (void)player:(nonnull SKPlayer *)player didChangeState:(SKPlayerState)newState;

- (void)playerDidComplete:(nonnull SKPlayer *)player;
- (void)player:(nonnull SKPlayer *)player didReceiveError:(nonnull NSError *)error;

@end

@interface SKPlayer<DataSourceType> : SKAsync

@property(nonatomic, readonly) SKPlayerState state;

@property(nonatomic, strong, readonly, nullable) DataSourceType source;
@property(nonatomic, strong, readonly, nullable) id current;
@property(nonatomic, weak, nullable) id<SKPlayerDelegate> delegate;

@property(nonatomic, assign) BOOL looping;

- (BOOL)isPlaying;

- (void)setDataSource:(nonnull id)source;

- (void)prepare:(nullable SKErrorCallback)callback;
- (void)start:(nullable SKErrorCallback)callback;
- (void)pause:(nullable SKErrorCallback)callback;
- (void)stop:(nullable SKErrorCallback)callback;

- (void)getCurrentPosition:(nonnull SKTimeCallback)success failure:(nullable SKErrorCallback)failure;
- (void)getDuration:(nonnull SKTimeCallback)success failure:(nullable SKErrorCallback)failure;

- (void)seekTo:(NSTimeInterval)time success:(nonnull SKTimeCallback)success failure:(nullable SKErrorCallback)failure;

@end
