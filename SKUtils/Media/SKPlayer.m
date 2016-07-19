//
//  SKPlayer.m
//  SKUtils
//
//  Created by Shin-Kai Chen on 2016/4/19.
//  Copyright © 2016年 SK. All rights reserved.
//

#import "SKPlayer_Protected.h"

#import "SKAbstractClassUtils.h"

#import "SKLog.h"

#undef SKLog
#define SKLog(__FORMAT__, ...)

static NSString * const kErrorMessageIllegalState = @"IllegalState";

@implementation SKPlayer

#pragma mark - State

- (void)start:(nullable SKErrorCallback)callback {
    THROW_NOT_OVERRIDE_EXCEPTION
}

- (void)restart:(nullable SKErrorCallback)callback {
    switch (_state) {
        case SKPlayerStopped:
            [self start:callback];
            break;
            
        case SKPlayerPlaying: {
            [self seekTo:0 success:^(NSTimeInterval interval) {
                callback(nil);
            } failure:callback];
        }
            break;
            
        case SKPlayerPaused: {
            [self stop:^(NSError * _Nullable error) {
                if(error) {
                    callback(error);
                } else {
                    [self start:callback];
                }
            }];
        }
            break;
            
        default:
            break;
    }
}

- (void)pause:(nullable SKErrorCallback)callback {
    THROW_NOT_OVERRIDE_EXCEPTION
}

- (void)stop:(nullable SKErrorCallback)callback {
    THROW_NOT_OVERRIDE_EXCEPTION
}

#pragma mark - Source

- (void)setSource:(nonnull id)source callback:(nullable SKErrorCallback)callback {
    [self changeSource:source callback:callback];
}

#pragma mark - Mode

- (void)setLooping:(BOOL)looping callback:(nullable SKErrorCallback)callback {
    _looping = looping;
    [self notifyChangeMode:callback];
}

#pragma mark - Progress

- (void)seekTo:(NSTimeInterval)time success:(nonnull SKTimeCallback)success failure:(nullable SKErrorCallback)failure {
    THROW_NOT_OVERRIDE_EXCEPTION
}

- (void)getProgress:(nonnull SKTimeCallback)success failure:(nullable SKErrorCallback)failure {
    THROW_NOT_OVERRIDE_EXCEPTION
}

- (void)getDuration:(nonnull SKTimeCallback)success failure:(nullable SKErrorCallback)failure {
    THROW_NOT_OVERRIDE_EXCEPTION
}

#pragma mark - Protected

- (void)changeState:(SKPlayerState)newState callback:(nullable SKErrorCallback)callback {
    SKLog(@"changeState:%@", @(newState));
    
    BOOL changeState = (_state!=newState);
    _state = newState;
    
    dispatch_async(self.callbackQueue, ^{
        if(changeState) {
            if([_delegate respondsToSelector:@selector(playerDidChangeState:)]) {
                [_delegate playerDidChangeState:self];
            }
        }
        
        if(callback) {
            callback(nil);
        }
    });
}

- (void)changeSource:(id)source callback:(nullable SKErrorCallback)callback {
    SKLog(@"changeSource:%@", source);
    
    BOOL changeSource = (_source!=source);
    _source = source;
    
    dispatch_async(self.callbackQueue, ^{
        if(changeSource) {
            if([_delegate respondsToSelector:@selector(playerDidChangeSource:)]) {
                [_delegate playerDidChangeSource:self];
            }
        }
        
        if(callback) {
            callback(nil);
        }
    });
}

- (void)playbackDidComplete:(nonnull id)playback {
    if(_looping) {
        [self restart:^(NSError * _Nullable error) {
            if(error) {
                [self notifyError:error callback:nil];
            }
        }];
    } else {
        [self changeState:SKPlayerStopped callback:nil];
        
        dispatch_async(self.callbackQueue, ^{
            if([_delegate respondsToSelector:@selector(player:didCompletePlayback:)]) {
                [_delegate player:self didCompletePlayback:playback];
            }
        });
    }
}

- (void)notifyChangeMode:(nullable SKErrorCallback)callback {
    dispatch_async(self.callbackQueue, ^{
        if([_delegate respondsToSelector:@selector(playerDidChangeMode:)]) {
            [_delegate playerDidChangeMode:self];
        }
        
        if(callback) {
            callback(nil);
        }
    });
}

- (void)notifyError:(nonnull NSError *)error callback:(nullable SKErrorCallback)callback {
    
    [self changeState:SKPlayerStopped callback:nil];
    
    dispatch_async(self.callbackQueue, ^{
        if([_delegate respondsToSelector:@selector(player:didReceiveError:)]) {
            [_delegate player:self didReceiveError:error];
        }
        
        if(callback) {
            callback(error);
        }
    });
}

- (void)notifyErrorMessage:(nonnull NSString *)message callback:(nullable SKErrorCallback)callback {
    [self notifyError:[NSError errorWithDomain:message code:0 userInfo:nil] callback:callback];
}

- (void)notifyIllegalStateException:(nullable SKErrorCallback)callback {
    [self notifyErrorMessage:kErrorMessageIllegalState callback:callback];
}

@end
