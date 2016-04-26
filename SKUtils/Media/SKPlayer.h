//
//  SKPlayer.h
//  SKUtils
//
//  Created by Shin-Kai Chen on 2016/4/19.
//  Copyright © 2016年 SK. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SKPlayer;

@protocol SKPlayerDelegate <NSObject>

@optional
- (void)onPlayerPrepared:(nonnull SKPlayer *)player;
- (void)onPlayerStarted:(nonnull SKPlayer *)player atPosition:(int)position;
- (void)onPlayerPaused:(nonnull SKPlayer *)player;
- (void)onPlayerStopped:(nonnull SKPlayer *)player;
- (void)onPlayerCompletion:(nonnull SKPlayer *)player;
- (void)onPlayer:(nonnull SKPlayer *)player error:(nonnull NSError *)error;

@end

@interface SKPlayer<DataSourceType> : NSObject

@property(nonatomic, strong, readonly, nullable) DataSourceType source;
@property(nonatomic, weak, nullable) id<SKPlayerDelegate> delegate;

@property(nonatomic, readonly) BOOL loop;

- (nullable NSError *)setDataSource:(nonnull DataSourceType)source;

- (nullable NSError *)prepare;
- (void)prepareAsync;

- (nullable NSError *)start;
- (nullable NSError *)pause;
- (nullable NSError *)stop;

- (BOOL)isPlaying;

- (int)getCurrentPosition;
- (int)getDuration;

- (nullable NSError *)seekTo:(int)msec;

@end
