//
//  SKNestedListPlayer.h
//  SKUtils
//
//  Created by Shin-Kai Chen on 2016/7/14.
//  Copyright © 2016年 SK. All rights reserved.
//

#import <SKUtils/SKUtils.h>

@interface SKNestedListPlayer : SKListPlayer <SKPlayerDelegate>{
    @protected
    SKPlayer *_innerPlayer;
}

@property(nonatomic, strong, readonly, nonnull) SKPlayer *innerPlayer;

- (nonnull instancetype)initWithPlayer:(nonnull SKPlayer *)player;

@end
