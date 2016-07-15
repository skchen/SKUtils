//
//  SKNestedListPlayer.m
//  SKUtils
//
//  Created by Shin-Kai Chen on 2016/7/14.
//  Copyright © 2016年 SK. All rights reserved.
//

#import "SKNestedListPlayer.h"

@implementation SKNestedListPlayer

- (instancetype)initWithPlayer:(nonnull SKPlayer *)player {
    self = [super init];
    _innerPlayer = player;
    _innerPlayer.delegate = self;
    return self;
}

#pragma mark - Property

- (dispatch_queue_t)workerQueue {
    return _innerPlayer.workerQueue;
}

- (dispatch_queue_t)callbackQueue {
    return _innerPlayer.callbackQueue;
}

- (void)setWorkerQueue:(dispatch_queue_t)workerQueue {
    _innerPlayer.workerQueue = workerQueue;
}

- (void)setCallbackQueue:(dispatch_queue_t)callbackQueue {
    _innerPlayer.callbackQueue = callbackQueue;
}

- (SKPlayerState)state {
    return _innerPlayer.state;
}

- (BOOL)looping {
    return _innerPlayer.looping;
}

#pragma mark - Source

- (void)setSource:(nonnull id)source atIndex:(NSUInteger)index callback:(nullable SKErrorCallback)callback {
    if([source isKindOfClass:[NSArray class]]) {
        _source = source;
        
        if( (index!=NSNotFound) && (index<[source count]) ) {
            id selectedSource = [source objectAtIndex:index];
            [_innerPlayer setSource:selectedSource callback:callback];
        } else {
            callback(nil);
        }
    } else {
        callback([NSError errorWithDomain:@"Unable to set source, source must be array" code:0 userInfo:nil]);
    }
}

- (void)addSource:(nonnull id)source callback:(nullable SKErrorCallback)callback {
    [self insertSource:source atIndex:NSUIntegerMax callback:callback];
}

- (void)insertSource:(nonnull id)source atIndex:(NSUInteger)index callback:(nullable SKErrorCallback)callback {
    if(_source) {
        NSArray *originalPlaylist = (NSArray *)_source;
        
        NSMutableArray *sourceToEdit = [[NSMutableArray alloc] initWithArray:originalPlaylist];
        if(index>=originalPlaylist.count) {
            [sourceToEdit addObject:source];
        } else {
            [sourceToEdit insertObject:source atIndex:index];
        }
        
        [self changeSource:sourceToEdit callback:callback];
    } else {
        [self setSource:source atIndex:index callback:callback];
    }
}

- (void)go:(NSUInteger)index callback:(SKErrorCallback)callback {
    id target = [self.source objectAtIndex:index];
    [_innerPlayer setSource:target callback:callback];
}

- (void)previous:(nullable SKErrorCallback)callback {
    if([self _hasPrevious]) {
        NSUInteger target = NSNotFound;
        
        if(self.random) {
            target = [self randomTarget];
        } else {
            target = self.index -1;
            
            if(self.index<=0) {
                target = [_source count]-1;
            }
        }
        
        [self go:target callback:callback];
    } else {
        [self notifyErrorMessage:@"Previous not exist" callback:callback];
    }
}

- (void)next:(nullable SKErrorCallback)callback {
    if([self _hasNext]) {
        NSUInteger target = NSNotFound;
        
        if(self.random) {
            target = [self randomTarget];
        } else {
            target = _index + 1;
            
            if(target>=[_source count]) {
                target = 0;
            }
        }
        
        [self go:target callback:callback];
    } else {
        [self notifyErrorMessage:@"Previous not exist" callback:callback];
    }
}

- (void)hasPrevious:(SKBooleanCallback)success failure:(SKErrorCallback)failure {
    dispatch_async(self.workerQueue, ^{
        BOOL hasPrevious = [self _hasPrevious];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            success(hasPrevious);
        });
    });
}

- (void)hasNext:(SKBooleanCallback)success failure:(SKErrorCallback)failure {
    dispatch_async(self.workerQueue, ^{
        BOOL hasNext = [self _hasNext];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            success(hasNext);
        });
    });
}

- (BOOL)_hasPrevious {
    if(self.repeat || self.random) {
        return YES;
    } else {
        if( (_index!=NSNotFound) && (_index>0) ) {
            return YES;
        }
    }
    
    return NO;
}

- (BOOL)_hasNext {
    if(self.repeat || self.random) {
        return YES;
    } else {
        NSUInteger numberOfSource = [(NSArray *)self.source count];
        
        if( (_index!=NSNotFound) && (_index<(numberOfSource-1)) ) {
            return YES;
        }
    }
    
    return NO;
}

#pragma mark - Mode

- (void)setLooping:(BOOL)looping callback:(SKErrorCallback)callback {
    [_innerPlayer setLooping:looping callback:callback];
}

#pragma mark - SKPlayer

- (void)setSource:(nonnull id)source callback:(SKErrorCallback)callback {
    if([source isKindOfClass:[NSArray class]]) {
        [self setSource:source atIndex:0 callback:callback];
    } else {
        [self setSource:@[source] atIndex:0 callback:callback];
    }
}

- (void)start:(SKErrorCallback)callback {
    [_innerPlayer start:callback];
}

- (void)pause:(SKErrorCallback)callback {
    [_innerPlayer pause:callback];
}

- (void)stop:(SKErrorCallback)callback {
    [_innerPlayer stop:callback];
}

- (void)getProgress:(SKTimeCallback)success failure:(SKErrorCallback)failure {
    [_innerPlayer getProgress:success failure:failure];
}

- (void)getDuration:(SKTimeCallback)success failure:(SKErrorCallback)failure {
    [_innerPlayer getDuration:success failure:failure];
}

- (void)seekTo:(NSTimeInterval)time success:(SKTimeCallback)success failure:(SKErrorCallback)failure {
    [_innerPlayer seekTo:time success:success failure:failure];
}

#pragma mark - SKPlayerDelegate for innerPlayer

- (void)playerDidChangeState:(SKPlayer *)player {
    if([_delegate respondsToSelector:@selector(playerDidChangeState:)]) {
        [_delegate playerDidChangeState:self];
    }
}

- (void)playerDidChangeSource:(SKPlayer *)player {
    id singleSource = player.source;
    
    if(singleSource) {
        _index = [_source indexOfObject:singleSource];
    } else {
        _index = NSNotFound;
    }
    
    if([_delegate respondsToSelector:@selector(playerDidChangeSource:)]) {
        [_delegate playerDidChangeSource:self];
    }
}

- (void)playerDidComplete:(SKPlayer *)player playback:(id)playback {
    if([_delegate respondsToSelector:@selector(player:didCompletePlayback:)]) {
        [_delegate player:self didCompletePlayback:playback];
    }
    
    if([self _hasNext]) {
        [self next:^(NSError * _Nullable error) {
            if(error) {
                [self notifyError:error callback:nil];
            } else {
                [self start:^(NSError * _Nullable error) {
                    if(error) {
                        [self notifyError:error callback:nil];
                    } else {
                        NSLog(@"play item changed");
                    }
                }];
            }
        }];
    }
}

- (void)player:(SKPlayer *)player didReceiveError:(NSError *)error {
    if([_delegate respondsToSelector:@selector(player:didReceiveError:)]) {
        [_delegate player:self didReceiveError:error];
    }
}

#pragma mark - Misc

- (NSUInteger)randomTarget {
    NSUInteger randomIndex = arc4random() % ([_source count]-1);
    if(randomIndex>=_index) {
        randomIndex++;
    }
    return randomIndex;
}

@end
