//
//  SKListPlayerViewController.h
//  SKUtils
//
//  Created by Shin-Kai Chen on 2016/7/13.
//  Copyright © 2016年 SK. All rights reserved.
//

#import <SKUtils/SKUtils.h>

@class SKListPlayer;

@interface SKListPlayerViewController : SKPlayerViewController

NS_ASSUME_NONNULL_BEGIN

@property (weak, nonatomic) IBOutlet UIButton *previousButton;
- (IBAction)onPreviousButtonPressed:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *nextButton;
- (IBAction)onNextButtonPressed:(id)sender;

@property (weak, nonatomic) IBOutlet UISwitch *repeatSwitch;
- (IBAction)onRepeatSwitchValueChanged:(id)sender;

@property (weak, nonatomic) IBOutlet UISwitch *randomSwitch;
- (IBAction)onRandomSwitchValueChanged:(id)sender;

- (SKListPlayer *)listPlayer;

NS_ASSUME_NONNULL_END

@end
