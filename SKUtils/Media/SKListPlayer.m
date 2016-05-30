//
//  SKListPlayer.m
//  SKUtils
//
//  Created by Shin-Kai Chen on 2016/4/25.
//  Copyright © 2016年 SK. All rights reserved.
//

#import "SKListPlayer_Protected.h"

@interface SKListPlayer () <SKPlayerDelegate>

@property(nonatomic, strong, readonly, nonnull) SKPlayer *innerPlayer;

@end

@implementation SKListPlayer

- (nonnull instancetype)initWithPlayer:(SKPlayer *)player {
    self = [super init];
    _innerPlayer = player;
    _innerPlayer.delegate = self;
    return self;
}

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

- (nullable id)current {
    return _innerPlayer.current;
}

- (void)setDataSource:(id)source atIndex:(NSUInteger)index {
    _source = source;
    NSArray *sourceAsArray = (NSArray *)source;
    id singleSource = [sourceAsArray objectAtIndex:index];
    _index = index;
    [_innerPlayer setDataSource:singleSource];
}

- (void)addDataSource:(nonnull id)source {
    [self addDataSource:source atIndex:NSUIntegerMax];
}

- (void)addDataSource:(nonnull id)source atIndex:(NSUInteger)index {
    if(_source) {
        NSArray *originalPlaylist = (NSArray *)_source;
        
        NSMutableArray *sourceToEdit = [[NSMutableArray alloc] initWithArray:originalPlaylist];
        if(index>=originalPlaylist.count) {
            [sourceToEdit addObject:source];
        } else {
            [sourceToEdit insertObject:source atIndex:index];
        }
        
        _source = sourceToEdit;
    } else {
        [self setDataSource:source];
    }
}

- (NSUInteger)randomTarget {
    NSUInteger randomIndex = arc4random() % ([_source count]-1);
    if(randomIndex>=_index) {
        randomIndex++;
    }
    return randomIndex;
}

- (void)previous:(nullable SKErrorCallback)callback {
    if([self hasPrevious]) {
        NSUInteger target = NSNotFound;
        
        if(_random) {
            target = [self randomTarget];
        } else {
            target = _index -1;
            
            if(_index<=0) {
                target = [_source count]-1;
            }
        }
        
        [self go:target callback:callback];
    } else {
        [self notifyErrorMessage:@"Previous not exist" callback:callback];
    }
}

- (void)next:(nullable SKErrorCallback)callback {
    if([self hasNext]) {
        NSUInteger target = NSNotFound;
        
        if(_random) {
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

- (void)go:(NSUInteger)index callback:(nullable SKErrorCallback)callback {
    [_innerPlayer stop:^(NSError * _Nullable error) {
        if(error) {
            [self notifyError:error callback:callback];
        } else {
            _index = index;
            id target = [self.source objectAtIndex:index];
            [_innerPlayer setDataSource:target];
            
            [_innerPlayer start:callback];
        }
    }];
}

- (BOOL)hasPrevious {
    if(_repeat || _random) {
        return YES;
    } else {
        if( (_index!=NSNotFound) && (_index>0) ) {
            return YES;
        }
    }
    
    return NO;
}

- (BOOL)hasNext {
    if(_repeat || _random) {
        return YES;
    } else {
        NSUInteger numberOfSource = [(NSArray *)self.source count];
        
        if( (_index!=NSNotFound) && (_index<(numberOfSource-1)) ) {
            return YES;
        }
    }
    
    return NO;
}

#pragma mark - SKPlayer

- (SKPlayerState)state {
    return _innerPlayer.state;
}

- (BOOL)looping {
    return _innerPlayer.looping;
}

- (void)setLooping:(BOOL)looping {
    _innerPlayer.looping = looping;
}

- (void)setDataSource:(id)source {
    if([source isKindOfClass:[NSArray class]]) {
        [self setDataSource:source atIndex:0];
    } else {
        NSArray *playlist = @[source];
        [self setDataSource:playlist atIndex:0];
    }
}

- (void)prepare:(SKErrorCallback)callback {
    [_innerPlayer prepare:callback];
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

- (BOOL)isPlaying {
    return [_innerPlayer isPlaying];
}

- (void)getCurrentPosition:(SKTimeCallback)success failure:(SKErrorCallback)failure {
    [_innerPlayer getCurrentPosition:success failure:failure];
}

- (void)getDuration:(SKTimeCallback)success failure:(SKErrorCallback)failure {
    [_innerPlayer getDuration:success failure:failure];
}

- (void)seekTo:(NSTimeInterval)time success:(SKTimeCallback)success failure:(SKErrorCallback)failure {
    [_innerPlayer seekTo:time success:success failure:failure];
}

#pragma mark - SKPlayerDelegate for innerPlayer

- (void)player:(SKPlayer *)player didChangeState:(SKPlayerState)newState {
    if([_delegate respondsToSelector:@selector(player:didChangeState:)]) {
        [_delegate player:self didChangeState:newState];
    }
}

- (void)playerDidComplete:(SKPlayer *)player {
    if([self hasNext]) {
        [self next:^(NSError * _Nullable error) {
            if(error) {
                [self notifyError:error callback:nil];
            }
        }];
    } else {
        if([_delegate respondsToSelector:@selector(playerDidComplete:)]) {
            [_delegate playerDidComplete:self];
        }
    }
}

- (void)player:(SKPlayer *)player didReceiveError:(NSError *)error {
    if([_delegate respondsToSelector:@selector(player:didReceiveError:)]) {
        [_delegate player:self didReceiveError:error];
    }
}

@end
