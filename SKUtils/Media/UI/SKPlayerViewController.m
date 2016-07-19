//
//  SKPlayerViewController.m
//  SKUtils
//
//  Created by Shin-Kai Chen on 2016/7/13.
//  Copyright © 2016年 SK. All rights reserved.
//

#import "SKPlayerViewController.h"

#import "SKPlayer.h"

#import "SKLog.h"

#undef SKLog
#define SKLog(__FORMAT__, ...)

@implementation SKPlayerViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    _player.delegate = self;
    
    [self resetProgress];
    [self updateState];
    [self updateMode];
    
    [_loadingView startAnimating];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [_player stop:^(NSError * _Nullable error) {
        NSLog(@"stop error: %@", error);
    }];
}

- (IBAction)onPlayPauseButtonPressed:(id)sender {
    SKErrorCallback callback = ^(NSError * _Nullable error) {
        if(error) {
            NSLog(@"play/pause error: %@", error);
        }
    };
    
    if(_player.state==SKPlayerPlaying) {
        [_player pause:callback];
    } else {
        [_player start:callback];
    }
}

- (IBAction)onStopButtonPressed:(id)sender {
    SKErrorCallback callback = ^(NSError * _Nullable error) {
        if(error) {
            NSLog(@"stop error: %@", error);
        }
    };
    
    [_player stop:callback];
}

- (IBAction)onProgressSliderValueChanged:(id)sender {
    [_player seekTo:_progressSlider.value success:^(NSTimeInterval interval) {
        SKLog(@"seek success");
    } failure:^(NSError * _Nullable error) {
        NSLog(@"seek error: %@", error);
    }];
}

- (void)updateState {
    if(_player.state==SKPlayerPlaying) {
        [_playPauseButton setTitle:@"Pause" forState:UIControlStateNormal];
        [self updateProgressLater];
    } else {
        [_playPauseButton setTitle:@"Play" forState:UIControlStateNormal];
    }
    
    [_playPauseButton setEnabled:YES];
    [_stopButton setEnabled:YES];
}

- (void)updateMode {
    [_loopSwitch setOn:_player.looping];
}

- (void)resetProgress {
    [_progressSlider setValue:0];
    [_progressLabel setText:@"-"];
}

- (void)updateProgress {
    [_player getProgress:^(NSTimeInterval interval) {
        int progress = (int)round(interval);
        [_progressSlider setValue:progress];
        [_progressLabel setText:[NSString stringWithFormat:@"%@", @(progress)]];
    } failure:^(NSError * _Nullable error) {
        NSLog(@"Unable to get progress: %@", error);
    }];
}

- (void)updateDuration {
    [_player getDuration:^(NSTimeInterval interval) {
        int duration = (int)round(interval);
        [_progressSlider setMaximumValue:duration];
        [_durationLabel setText:[NSString stringWithFormat:@"%@", @(duration)]];
    } failure:^(NSError * _Nullable error) {
        NSLog(@"Unable to get duration: %@", error);
    }];
}

- (void)updateProgressLater {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        if(_player.state==SKPlayerPlaying) {
            [self updateProgress];
            [self updateProgressLater];
        }
    });
}

- (IBAction)onLoopSwitchValueChanged:(id)sender {
    [_player setLooping:_loopSwitch.isOn callback:^(NSError * _Nullable error) {
        if(error) {
            NSLog(@"setLooping error: %@", error);
        } else {
            SKLog(@"setLooping:%@", @(_loopSwitch.isOn));
        }
    }];
}

#pragma mark - SKPlayerDelegate

- (void)playerDidChangeState:(SKPlayer *)player {
    SKPlayerState state = player.state;
    
    switch (state) {
        case SKPlayerPlaying:
            [_loadingView stopAnimating];
            [self updateDuration];
            break;
            
        case SKPlayerStopped:
            [self resetProgress];
            break;
            
        default:
            break;
    }
    
    [self updateState];
}

- (void)playerDidChangeSource:(SKPlayer *)player {
    
}

- (void)playerDidChangeMode:(SKPlayer *)player {
    [self updateMode];
}

@end
