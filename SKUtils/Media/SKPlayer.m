//
//  SKPlayer.m
//  SKUtils
//
//  Created by Shin-Kai Chen on 2016/4/19.
//  Copyright © 2016年 SK. All rights reserved.
//

#import "SKPlayer_Protected.h"

//#define SKLog(__FORMAT__, ...) NSLog((@"%s [Line %d] " __FORMAT__), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)
#define SKLog(__FORMAT__, ...)

static NSString * const kErrorMessageIllegalState = @"IllegalState";

@implementation SKPlayer

- (instancetype)init {
    self = [super init];
    if (self) {
        _state = SKPlayerStopped;
        _looping = NO;
    }
    return self;
}

- (nullable id)current {
    return _source;
}

- (void)setDataSource:(nonnull id)source {
    if(![source isEqual:_source]) {
        [self changeState:SKPlayerStopped callback:nil];
    }
    
    _source = source;
    
    [self _setDataSource:source];
}

- (void)_setDataSource:(nonnull id)source {
    @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                   reason:[NSString stringWithFormat:@"You must override %@ in a subclass", NSStringFromSelector(_cmd)]
                                 userInfo:nil];
}

- (void)prepare:(nullable SKErrorCallback)callback {
    switch (_state) {
        case SKPlayerStopped: {
            [self changeState:SKPlayerPreparing callback:nil];
            
            dispatch_async(self.workerQueue, ^{
                [self _prepare:^(NSError * _Nullable error) {
                    if(error) {
                        [self notifyError:error callback:callback];
                    } else {
                        [self changeState:SKPlayerPrepared callback:callback];
                    }
                }];
            });
        }
            break;
            
        default:
            [self notifyIllegalStateException:callback];
            break;
    }
}

- (void)_prepare:(nullable SKErrorCallback)callback {
    @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                   reason:[NSString stringWithFormat:@"You must override %@ in a subclass", NSStringFromSelector(_cmd)]
                                 userInfo:nil];
}

- (void)start:(nullable SKErrorCallback)callback {
    SKLog(@"start @ %@", @(_state));
    
    switch (_state) {
        case SKPlayerStopped: {
            [self prepare:^(NSError * _Nullable error) {
                if(error) {
                    [self notifyError:error callback:callback];
                } else {
                    [self start:callback];
                }
            }];
        }
            break;
            
        case SKPlayerPrepared:
        case SKPlayerPaused: {
            dispatch_async(self.workerQueue, ^{
                [self _start:^(NSError * _Nullable error) {
                    if(error) {
                        [self notifyError:error callback:callback];
                    } else {
                        [self changeState:SKPlayerStarted callback:callback];
                    }
                }];
            });
        }
            break;
            
        default:
            [self notifyIllegalStateException:callback];
            break;
    }
}

- (void)_start:(nullable SKErrorCallback)callback {
    @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                   reason:[NSString stringWithFormat:@"You must override %@ in a subclass", NSStringFromSelector(_cmd)]
                                 userInfo:nil];
}

- (void)pause:(nullable SKErrorCallback)callback {
    SKLog(@"pause @ %@", @(_state));
    
    switch (_state) {
        case SKPlayerStarted: {
            dispatch_async(self.workerQueue, ^{
                [self _pause:^(NSError * _Nullable error) {
                    if(error) {
                        [self notifyError:error callback:callback];
                    } else {
                        [self changeState:SKPlayerPaused callback:callback];
                    }
                }];
            });
        }
            break;
            
        default:
            [self notifyIllegalStateException:callback];
            break;
    }
}

- (void)_pause:(nullable SKErrorCallback)callback {
    @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                   reason:[NSString stringWithFormat:@"You must override %@ in a subclass", NSStringFromSelector(_cmd)]
                                 userInfo:nil];
}

- (void)stop:(nullable SKErrorCallback)callback {
    SKLog(@"stop @ %@", @(_state));
    
    switch (_state) {
        case SKPlayerStarted:
        case SKPlayerPaused:
        case SKPlayerStopped: {
            dispatch_async(self.workerQueue, ^{
                [self _stop:^(NSError * _Nullable error) {
                    if(error) {
                        [self notifyError:error callback:callback];
                    } else {
                        [self changeState:SKPlayerPrepared callback:callback];
                    }
                }];
            });
        }
            break;
            
        default:
            [self notifyIllegalStateException:callback];
            break;
    }
}

- (void)_stop:(nullable SKErrorCallback)callback {
    @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                   reason:[NSString stringWithFormat:@"You must override %@ in a subclass", NSStringFromSelector(_cmd)]
                                 userInfo:nil];
}

- (BOOL)isPlaying {
    return (_state==SKPlayerStarted);
}

- (void)getCurrentPosition:(nonnull SKTimeCallback)success failure:(nullable SKErrorCallback)failure {
    dispatch_async(self.workerQueue, ^{
        [self _getCurrentPosition:[self wrappedTimeCallback:success] failure:[self wrappedErrorCallback:failure]];
    });
}

- (void)_getCurrentPosition:(nonnull SKTimeCallback)success failure:(nullable SKErrorCallback)failure {
    @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                   reason:[NSString stringWithFormat:@"You must override %@ in a subclass", NSStringFromSelector(_cmd)]
                                 userInfo:nil];
}

- (void)getDuration:(nonnull SKTimeCallback)success failure:(nullable SKErrorCallback)failure {
    dispatch_async(self.workerQueue, ^{
        [self _getDuration:[self wrappedTimeCallback:success] failure:[self wrappedErrorCallback:failure]];
    });
}

- (void)_getDuration:(nonnull SKTimeCallback)success failure:(nullable SKErrorCallback)failure {
    @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                   reason:[NSString stringWithFormat:@"You must override %@ in a subclass", NSStringFromSelector(_cmd)]
                                 userInfo:nil];
}

- (void)seekTo:(NSTimeInterval)time success:(nonnull SKTimeCallback)success failure:(nullable SKErrorCallback)failure {
    SKLog(@"seekTo @ %@", @(_state));
    
    switch (_state) {
        case SKPlayerStarted: {
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

- (void)_seekTo:(NSTimeInterval)time success:(nonnull SKTimeCallback)success failure:(nullable SKErrorCallback)failure {
    @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                   reason:[NSString stringWithFormat:@"You must override %@ in a subclass", NSStringFromSelector(_cmd)]
                                 userInfo:nil];
}

- (void)changeState:(SKPlayerState)newState callback:(nullable SKErrorCallback)callback {
    SKLog(@"changeState:%@", @(newState));
    
    BOOL changeState = (_state!=newState);
    _state = newState;
    
    dispatch_async(self.callbackQueue, ^{
        if(changeState) {
            if([_delegate respondsToSelector:@selector(player:didChangeState:)]) {
                [_delegate player:self didChangeState:newState];
            }
        }
        
        if(callback) {
            callback(nil);
        }
    });
}

- (void)notifyCompletion:(nullable SKErrorCallback)callback {
    if(_looping) {
        [self _stop:nil];
        [self _start:nil];
    } else {
        [self changeState:SKPlayerPrepared callback:callback];
        
        dispatch_async(self.callbackQueue, ^{
            if([_delegate respondsToSelector:@selector(playerDidComplete:)]) {
                [_delegate playerDidComplete:self];
            }
        });
    }
}

- (void)notifyError:(nonnull NSError *)error callback:(nullable SKErrorCallback)callback {
    
    [self changeState:SKPlayerStopped callback:callback];
    
    dispatch_async(self.callbackQueue, ^{
        if([_delegate respondsToSelector:@selector(player:didReceiveError:)]) {
            [_delegate player:self didReceiveError:error];
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
