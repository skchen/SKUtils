//
//  SKPlayer.m
//  SKUtils
//
//  Created by Shin-Kai Chen on 2016/4/19.
//  Copyright © 2016年 SK. All rights reserved.
//

#import "SKPlayer_Protected.h"

@implementation SKPlayer

- (instancetype)init {
    self = [super init];
    if (self) {
        _state = SKPlayerIdle;
    }
    return self;
}

- (nullable NSError *)setDataSource:(nonnull id)source {
    switch (_state) {
        case SKPlayerIdle: {
            NSError *setDataSourceError = [self _setDataSource:source];
            if(!setDataSourceError) {
                _state = SKPlayerInitialized;
            }
            return setDataSourceError;
        }
            
        default:
            return [self illegalStateExceptionError];
    }
}

- (nullable NSError *)_setDataSource:(id)source {
    @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                   reason:[NSString stringWithFormat:@"You must override %@ in a subclass", NSStringFromSelector(_cmd)]
                                 userInfo:nil];
}

- (NSError *)prepare {
    switch (_state) {
        case SKPlayerInitialized:
        case SKPlayerStopped: {
            _state = SKPlayerPreparing;
            NSError *prepareError = [self _prepare];
            if(!prepareError) {
                [self notifyPrepared];
            }
            return prepareError;
        }
            
        default:
            return [self illegalStateExceptionError];
    }
}

- (void)prepareAsync {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self prepare];
    });
}

- (nullable NSError *)_prepare {
    @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                   reason:[NSString stringWithFormat:@"You must override %@ in a subclass", NSStringFromSelector(_cmd)]
                                 userInfo:nil];
}

- (NSError *)start {
    switch (_state) {
        case SKPlayerPlaybackCompleted: {
            NSError *stopError = [self stop];
            if(stopError) {
                return stopError;
            }
        }
            // Do not break here
            
        case SKPlayerStopped:
        case SKPlayerPrepared:
        case SKPlayerPaused:
            _state = SKPlayerStarted;
            return [self _start];
            
        default:
            return [self illegalStateExceptionError];
    }
}

- (nullable NSError *)_start {
    @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                   reason:[NSString stringWithFormat:@"You must override %@ in a subclass", NSStringFromSelector(_cmd)]
                                 userInfo:nil];
}

- (NSError *)pause {
    switch (_state) {
        case SKPlayerStarted:
            _state = SKPlayerPaused;
            return [self _pause];
            
        default:
            return [self illegalStateExceptionError];
    }
}

- (nullable NSError *)_pause {
    @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                   reason:[NSString stringWithFormat:@"You must override %@ in a subclass", NSStringFromSelector(_cmd)]
                                 userInfo:nil];
}

- (NSError *)stop {
    switch (_state) {
        case SKPlayerStarted:
        case SKPlayerPaused:
        case SKPlayerPlaybackCompleted:
        case SKPlayerStopped:
            _state = SKPlayerStopped;
            return [self _stop];
            
        default:
            return [self illegalStateExceptionError];
    }
}

- (nullable NSError *)_stop {
    @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                   reason:[NSString stringWithFormat:@"You must override %@ in a subclass", NSStringFromSelector(_cmd)]
                                 userInfo:nil];
}

- (BOOL)isPlaying {
    return (_state==SKPlayerStarted);
}

- (int)getCurrentPosition {
    @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                   reason:[NSString stringWithFormat:@"You must override %@ in a subclass", NSStringFromSelector(_cmd)]
                                 userInfo:nil];
}

- (int)getDuration {
    @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                   reason:[NSString stringWithFormat:@"You must override %@ in a subclass", NSStringFromSelector(_cmd)]
                                 userInfo:nil];
}

- (NSError *)seekTo:(int)msec {
    switch (_state) {
        case SKPlayerStarted:
            return [self _seekTo:msec];
            break;
            
        default:
            return [self illegalStateExceptionError];
    }
}

- (nullable NSError *)_seekTo:(int)msec {
    @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                   reason:[NSString stringWithFormat:@"You must override %@ in a subclass", NSStringFromSelector(_cmd)]
                                 userInfo:nil];
}

- (void)notifyPrepared {
    _state = SKPlayerPrepared;
    
    if([_delegate respondsToSelector:@selector(onPlayerPrepared:)]) {
        [_delegate onPlayerPrepared:self];
    }
}

- (void)notifyCompletion {
    _state = SKPlayerPlaybackCompleted;
    
    if([_delegate respondsToSelector:@selector(onPlayerCompletion:)]) {
        [_delegate onPlayerCompletion:self];
    }
}

- (void)notifyError:(NSError *)error {
    _state = SKPlayerError;
    
    if([_delegate respondsToSelector:@selector(onPlayer:error:)]) {
        [_delegate onPlayer:self error:error];
    }
}

- (void)notifyErrorMessage:(NSString *)message {
    [self notifyError:[NSError errorWithDomain:message code:0 userInfo:nil]];
}

- (void)notifyIllegalStateException {
    [self notifyErrorMessage:@"IllegalStateException"];
}

- (NSError *)illegalStateExceptionError {
    return [NSError errorWithDomain:@"IllegalStateException" code:0 userInfo:nil];
}

@end
