//
//  SKPlayerViewController.h
//  SKUtils
//
//  Created by Shin-Kai Chen on 2016/7/13.
//  Copyright © 2016年 SK. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "SKPlayer.h"

@interface SKPlayerViewController : UIViewController<SKPlayerDelegate>

NS_ASSUME_NONNULL_BEGIN

@property (weak, nonatomic, nullable) IBOutlet UIButton *playPauseButton;
- (IBAction)onPlayPauseButtonPressed:(id)sender;
@property (weak, nonatomic, nullable) IBOutlet UIButton *stopButton;
- (IBAction)onStopButtonPressed:(id)sender;

@property (weak, nonatomic, nullable) IBOutlet UILabel *progressLabel;
@property (weak, nonatomic, nullable) IBOutlet UILabel *durationLabel;
@property (weak, nonatomic, nullable) IBOutlet UISlider *progressSlider;
- (IBAction)onProgressSliderValueChanged:(id)sender;

@property (weak, nonatomic, nullable) IBOutlet UISwitch *loopSwitch;
- (IBAction)onLoopSwitchValueChanged:(id)sender;

@property (strong, nonatomic, nullable) IBOutlet UIActivityIndicatorView *loadingView;

@property (nonatomic, strong, nonnull) SKPlayer *player;

#pragma mark - Protected

- (void)updateState;
- (void)updateMode;

NS_ASSUME_NONNULL_END

@end
