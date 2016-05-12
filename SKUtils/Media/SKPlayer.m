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
        _looping = NO;
    }
    return self;
}

- (nullable id)current {
    return _source;
}

- (nullable NSError *)setDataSource:(nonnull id)source {
    switch (_state) {
        case SKPlayerIdle:
        case SKPlayerStopped: {
            NSError *setDataSourceError = [self _setDataSource:source];
            if(!setDataSourceError) {
                _source = source;
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
        case SKPlayerPaused: {
            NSError *startError = [self _start];
            if(!startError) {
                [self notifyStarted];
            }
            return startError;
        }
            
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
        case SKPlayerStarted: {
            NSError *pauseError = [self _pause];
            if(!pauseError) {
                [self notifyPaused];
            }
            return pauseError;
        }
            
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

- (void)notifyStarted {
    _state = SKPlayerStarted;
    int position = [self getCurrentPosition];
    
    if([_delegate respondsToSelector:@selector(onPlayerStarted:atPosition:)]) {
        [_delegate onPlayerStarted:self atPosition:position];
    }
}

- (void)notifyPaused {
    _state = SKPlayerPaused;
    
    if([_delegate respondsToSelector:@selector(onPlayerPaused:)]) {
        [_delegate onPlayerPaused:self];
    }
}

- (void)notifyStopped {
    _state = SKPlayerStopped;
    
    if([_delegate respondsToSelector:@selector(onPlayerStopped:)]) {
        [_delegate onPlayerStopped:self];
    }
}

- (void)notifyCompletion {
    if(_looping) {
        [self _stop];
        [self _start];
    } else {
        _state = SKPlayerPlaybackCompleted;
        
        if([_delegate respondsToSelector:@selector(onPlayerCompletion:)]) {
            [_delegate onPlayerCompletion:self];
        }
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
