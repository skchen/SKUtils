//
//  SKListPlayer_Protected.h
//  SKUtils
//
//  Created by Shin-Kai Chen on 2016/4/26.
//  Copyright © 2016年 SK. All rights reserved.
//

#import "SKPlayer_Protected.h"
#import "SKListPlayer.h"

@interface SKListPlayer<DataSourceType> (){
@protected
    NSUInteger _index;
    SKPlayer *_innerPlayer;
}

@property(nonatomic, strong, readonly, nonnull) SKPlayer *innerPlayer;

@end
