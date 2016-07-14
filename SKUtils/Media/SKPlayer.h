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
    SKPlayerUnknown,
    SKPlayerStopped,
    SKPlayerPlaying,
    SKPlayerPaused
};

@class SKPlayer;

@protocol SKPlayerDelegate <NSObject>

@optional
- (void)playerDidChangeState:(nonnull SKPlayer *)player;
- (void)playerDidChangeSource:(nonnull SKPlayer *)player;
- (void)playerDidChangeMode:(nonnull SKPlayer *)player;

- (void)playerDidComplete:(nonnull SKPlayer *)player playback:(nonnull id)source;

- (void)player:(nonnull SKPlayer *)player didReceiveError:(nonnull NSError *)error;

@end

@interface SKPlayer : SKAsync

@property(nonatomic, weak, nullable) id<SKPlayerDelegate> delegate;

#pragma mark - State

@property(nonatomic, readonly) SKPlayerState state;

- (void)start:(nullable SKErrorCallback)callback;
- (void)pause:(nullable SKErrorCallback)callback;
- (void)stop:(nullable SKErrorCallback)callback;

#pragma mark - Source

@property(nonatomic, strong, readonly, nullable) id source;
- (void)setSource:(nonnull id)source callback:(nullable SKErrorCallback)callback;

#pragma mark - Mode

@property(nonatomic, readonly) BOOL looping;
- (void)setLooping:(BOOL)looping callback:(nullable SKErrorCallback)callback;

#pragma mark - Progress

- (void)seekTo:(NSTimeInterval)time success:(nonnull SKTimeCallback)success failure:(nullable SKErrorCallback)failure;

- (void)getProgress:(nonnull SKTimeCallback)success failure:(nullable SKErrorCallback)failure;
- (void)getDuration:(nonnull SKTimeCallback)success failure:(nullable SKErrorCallback)failure;

@end
