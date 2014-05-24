//
//  cvViewController.h
//  CrystalBall
//
//  Created by Christian Vazquez on 4/27/14.
//  Copyright (c) 2014 Christian Vazquez. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <iAd/iAd.h>

@class cvCrystalBall;

@interface cvViewController : UIViewController
@property (strong, nonatomic) IBOutlet UILabel *predictLabel;
@property(strong,nonatomic) cvCrystalBall *crystalBall;
@property (strong, nonatomic) IBOutlet UIImageView *backgroundImageView;

@property(strong,nonatomic)ADBannerView *adView;

- (IBAction)buttonPressed;

-(void) makePrediction;

- (IBAction)showSettingsView:(id)sender;

@end
