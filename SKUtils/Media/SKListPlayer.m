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

- (nullable id)current {
    return [_source objectAtIndex:_index];
}

- (nullable NSError *)setDataSource:(id)source atIndex:(NSUInteger)index {
    _source = source;
    NSArray *sourceAsArray = (NSArray *)source;
    id singleSource = [sourceAsArray objectAtIndex:index];
    _index = index;
    return [_innerPlayer setDataSource:singleSource];
}

- (NSUInteger)randomTarget {
    NSUInteger randomIndex = arc4random() % ([_source count]-1);
    if(randomIndex>=_index) {
        randomIndex++;
    }
    return randomIndex;
}

- (nullable NSError *)previous {
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
        
        return [self go:target];
    } else {
        return [NSError errorWithDomain:@"Previous not exist" code:0 userInfo:nil];
    }
}

- (nullable NSError *)next {
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
        
        return [self go:target];
    } else {
        return [NSError errorWithDomain:@"Next not exist" code:0 userInfo:nil];
    }
}

- (nullable NSError *)go:(NSUInteger)index {
    NSError *stopError = [_innerPlayer stop];
    if(stopError) return stopError;
    
    [self notifyStopped];
    
    id target = [self.source objectAtIndex:index];
    
    NSError *setDataSourceError = [_innerPlayer setDataSource:target];
    if(setDataSourceError) return setDataSourceError;
    
    _index = index;
    
    NSError *prepareError = [_innerPlayer prepare];
    if(prepareError) return prepareError;
    
    [self notifyPrepared];
    
    NSError *startError = [_innerPlayer start];
    if(startError) return startError;
    
    [self notifyStarted];
    
    return nil;
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

- (BOOL)looping {
    return _innerPlayer.looping;
}

- (void)setLooping:(BOOL)looping {
    _innerPlayer.looping = looping;
}

- (nullable NSError *)setDataSource:(id)source {
    if([source isKindOfClass:[NSArray class]]) {
        return [self setDataSource:source atIndex:0];
    } else {
        NSArray *playlist = @[source];
        return [self setDataSource:playlist atIndex:0];
    }
}

- (nullable NSError *)prepare {
    return [_innerPlayer prepare];
}

- (void)prepareAsync {
    [_innerPlayer prepareAsync];
}

- (nullable NSError *)start {
    return [_innerPlayer start];
}

- (nullable NSError *)pause {
    return [_innerPlayer pause];
}

- (nullable NSError *)stop {
    return [_innerPlayer stop];
}

- (BOOL)isPlaying {
    return [_innerPlayer isPlaying];
}

- (int)getCurrentPosition {
    return [_innerPlayer getCurrentPosition];
}

- (int)getDuration {
    return [_innerPlayer getDuration];
}

- (nullable NSError *)seekTo:(int)msec {
    return [_innerPlayer seekTo:msec];
}

#pragma mark - SKPlayerDelegate for innerPlayer

- (void)onPlayerPrepared:(nonnull SKPlayer *)player {
    if([_delegate respondsToSelector:@selector(onPlayerPrepared:)]) {
        [_delegate onPlayerPrepared:self];
    }
}

- (void)onPlayerStarted:(nonnull SKPlayer *)player atPosition:(int)position {
    [self notifyStarted];
}

- (void)onPlayerPaused:(nonnull SKPlayer *)player {
    [self notifyPaused];
}

- (void)onPlayerStopped:(nonnull SKPlayer *)player {
    [self notifyStopped];
}

- (void)onPlayerCompletion:(nonnull SKPlayer *)player {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        if([self hasNext]) {
            [self next];
        } else {
            [self notifyCompletion];
        }
    });
}

- (void)onPlayer:(nonnull SKPlayer *)player error:(nonnull NSError *)error {
    [self notifyError:error];
}

@end
