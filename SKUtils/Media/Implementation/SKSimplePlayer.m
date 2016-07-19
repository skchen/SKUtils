//
//  SKSimplePlayer.m
//  SKUtils
//
//  Created by Shin-Kai Chen on 2016/7/14.
//  Copyright © 2016年 SK. All rights reserved.
//

#import "SKSimplePlayer.h"

#import "SKPlayer_Protected.h"

@implementation SKSimplePlayer

- (instancetype)init {
    self = [super init];
    if (self) {
        _state = SKPlayerStopped;
        _looping = NO;
    }
    return self;
}

#pragma mark - State

- (void)start:(SKErrorCallback)callback {
    dispatch_async(self.workerQueue, ^{
        switch (_state) {
            case SKPlayerStopped:
                [self _start:[self wrappedErrorCallback:callback]];
                break;
                
            case SKPlayerPaused:
                [self _resume:[self wrappedErrorCallback:callback]];
                break;
                
            case SKPlayerPlaying: {
                dispatch_async(self.callbackQueue, ^{
                    if(callback) callback(nil);
                });
            }
                break;
                
            default:
                [self notifyIllegalStateException:callback];
                break;
        }
    });
}

- (void)pause:(SKErrorCallback)callback {
    dispatch_async(self.workerQueue, ^{
        switch (_state) {
            case SKPlayerPlaying:
                [self _pause:[self wrappedErrorCallback:callback]];
                break;
                
            case SKPlayerPaused: {
                dispatch_async(self.callbackQueue, ^{
                    if(callback) callback(nil);
                });
            }
                
            default:
                [self notifyIllegalStateException:callback];
                break;
        }
    });
}

- (void)stop:(SKErrorCallback)callback {
    dispatch_async(self.workerQueue, ^{
        switch (_state) {
            case SKPlayerPlaying:
            case SKPlayerPaused:
                [self _stop:[self wrappedErrorCallback:callback]];
                break;
                
            case SKPlayerStopped: {
                dispatch_async(self.callbackQueue, ^{
                    if(callback) callback(nil);
                });
            }
                
            default:
                [self notifyIllegalStateException:callback];
                break;
        }
    });
}

#pragma mark - Source

- (void)setSource:(nonnull id)source callback:(nullable SKErrorCallback)callback {
    __weak __typeof(self) weakSelf = self;
    
    switch (_state) {
        case SKPlayerStopped:
            [self _setSource:source callback:callback];
            break;
            
        case SKPlayerPaused:
        case SKPlayerPlaying: {
            [self _stop:^(NSError * _Nullable error) {
                if(error) {
                    callback(error);
                } else {
                    [self _setSource:source callback:^(NSError * _Nullable error) {
                        if(error) {
                            callback(error);
                        } else {
                            [weakSelf _start:callback];
                        }
                    }];
                }
            }];
        }
            break;
            
        default:
            [self notifyIllegalStateException:callback];
            break;
    }
}

#pragma mark - Progress

- (void)getDuration:(SKTimeCallback)success failure:(SKErrorCallback)failure {
    dispatch_async(self.workerQueue, ^{
        [self _getDuration:[self wrappedTimeCallback:success] failure:[self wrappedErrorCallback:failure]];
    });
}

- (void)getProgress:(SKTimeCallback)success failure:(SKErrorCallback)failure {
    dispatch_async(self.workerQueue, ^{
        [self _getProgress:[self wrappedTimeCallback:success] failure:[self wrappedErrorCallback:failure]];
    });
}

- (void)seekTo:(NSTimeInterval)time success:(SKTimeCallback)success failure:(SKErrorCallback)failure {
    switch (_state) {
        case SKPlayerPlaying: {
            dispatch_async(self.workerQueue, ^{
                [self _seekTo:time success:[self wrappedTimeCallback:success] failure:[self wrappedErrorCallback:failure]];
            });
        }
            break;
            
        default:
            [self notifyIllegalStateException:failure];
            break;
    }
}

#pragma mark - Abstract

- (void)_start:(SKErrorCallback)callback {
    THROW_NOT_OVERRIDE_EXCEPTION
}

- (void)_resume:(SKErrorCallback)callback {
    THROW_NOT_OVERRIDE_EXCEPTION
}

- (void)_pause:(SKErrorCallback)callback {
    THROW_NOT_OVERRIDE_EXCEPTION
}

- (void)_stop:(SKErrorCallback)callback {
    THROW_NOT_OVERRIDE_EXCEPTION
}

- (void)_setSource:(nonnull id)source callback:(nullable SKErrorCallback)callback {
    [self changeSource:source callback:callback];
}

- (void)_getDuration:(SKTimeCallback)success failure:(SKErrorCallback)failure {
    THROW_NOT_OVERRIDE_EXCEPTION
}

- (void)_getProgress:(SKTimeCallback)success failure:(SKErrorCallback)failure {
    THROW_NOT_OVERRIDE_EXCEPTION
}

- (void)_seekTo:(NSTimeInterval)time success:(SKTimeCallback)success failure:(SKErrorCallback)failure {
    THROW_NOT_OVERRIDE_EXCEPTION
}

@end
