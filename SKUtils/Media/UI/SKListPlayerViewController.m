//
//  SKListPlayerViewController.m
//  SKUtils
//
//  Created by Shin-Kai Chen on 2016/7/13.
//  Copyright © 2016年 SK. All rights reserved.
//

#import "SKListPlayerViewController.h"

@implementation SKListPlayerViewController

- (void)updateState {
    [super updateState];
    [self updatePrevNext];
}

- (void)updateMode {
    [super updateMode];
    
    [_repeatSwitch setOn:self.listPlayer.repeat];
    [_randomSwitch setOn:self.listPlayer.random];
    
    [self updatePrevNext];
}

- (void)updatePrevNext {
    BOOL hasPrevious = [self.listPlayer hasPrevious];
    [_previousButton setEnabled:hasPrevious];
    
    BOOL hasNext = [self.listPlayer hasNext];
    [_nextButton setEnabled:hasNext];
}

- (IBAction)onPreviousButtonPressed:(id)sender {
    [self.loadingView startAnimating];
    
    [self.listPlayer previous:^(NSError * _Nullable error) {
        if(error) {
            NSLog(@"Unable to go previous: %@", error);
        }
    }];
}

- (IBAction)onNextButtonPressed:(id)sender {
    [self.loadingView startAnimating];
    
    [self.listPlayer next:^(NSError * _Nullable error) {
        if(error) {
            NSLog(@"Unable to go next: %@", error);
        }
    }];
}

- (IBAction)onRepeatSwitchValueChanged:(id)sender {
    [self.listPlayer setRepeat:_repeatSwitch.isOn callback:^(NSError * _Nullable error) {
        NSLog(@"setRepeat: %@", error);
    }];
}

- (IBAction)onRandomSwitchValueChanged:(id)sender {
    [self.listPlayer setRandom:_randomSwitch.isOn callback:^(NSError * _Nullable error) {
        NSLog(@"setRandom: %@", error);
    }];
}

- (SKListPlayer *)listPlayer {
    return (SKListPlayer *)self.player;
}

@end
