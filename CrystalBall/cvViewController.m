//
//  cvViewController.m
//  CrystalBall
//
//  Created by Christian Vazquez on 4/27/14.
//  Copyright (c) 2014 Christian Vazquez. All rights reserved.
//

#import "cvViewController.h"
#import "cvCrystalBall.h"
#import "AudioToolbox/AudioToolbox.h"
#import <AudioUnit/AudioUnit.h>
#import <iAd/iAd.h>
#import "SyncTool.h"
#import "SettingTableViewController.h"

@interface cvViewController ()<ADBannerViewDelegate>

@end



@implementation cvViewController{
    SystemSoundID soundEffect;
}




- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSString *soundPath = [[NSBundle mainBundle] pathForResource:@"crystal_ball" ofType:@"mp3"];
    NSURL *soundURL = [NSURL fileURLWithPath:soundPath];
    AudioServicesCreateSystemSoundID(CFBridgingRetain(soundURL),&soundEffect);
    self.crystalBall = [[cvCrystalBall alloc] init];
    
    

    
    self.predictLabel.text = nil;
    
    NSMutableArray *animationImages = [[NSMutableArray alloc] init];
    NSString *imageName = [[NSString alloc] init];
   int i=1;
   while (i < 61){
        
      
        if( i < 10){
           imageName = [@"CB0000" stringByAppendingString:[NSString stringWithFormat:@"%i",i]];
        }else{
            imageName = [@"CB000" stringByAppendingString:[NSString stringWithFormat:@"%i",i]];
            
        }
     
       [animationImages addObject:[UIImage imageNamed:imageName]];
       i++;
   }
    
  self.backgroundImageView.animationImages = animationImages;
  self.backgroundImageView.animationDuration=2.5f;
  self.backgroundImageView.animationRepeatCount = 1;
    
    
    
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
   // [self.navigationController.navigationBar setHidden:YES];
    
    SyncTool *tool = [[SyncTool alloc] init];
    [tool DownloadPhrases];
    
    
    self.adView = [[ADBannerView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 50, 320, 50)];
    // [self.adView setHidden:YES];
    [self.view addSubview:self.adView];
    
   // SyncTool *sync = [[SyncTool alloc] init];
    //[sync DownloadPhrases];
    
    [self.crystalBall fillPredictions];
    
}
#pragma mark ADBannerViewDelegate

- (void)bannerViewDidLoadAd:(ADBannerView *)banner {
    [banner setHidden:NO];
   // [self.view addSubview:banner];
    
}


- (IBAction)buttonPressed {
    
          [self makePrediction];
}

#pragma mark - Prediction
-(void) makePrediction{
    [self.backgroundImageView startAnimating];
    self.predictLabel.text = [self.crystalBall randomPrediction];
    AudioServicesPlaySystemSound(soundEffect);
    
    [UIView animateWithDuration:6.0f animations:^{
        self.predictLabel.alpha = 1.0f;
    
    }];

}

- (IBAction)showSettingsView:(id)sender {
    
    
      [self performSegueWithIdentifier:@"settings" sender:self];
  // SettingTableViewController *modalViewController=[[SettingTableViewController alloc] init];
   //[self presentViewController:modalViewController animated:YES completion:nil];
    
}


#pragma mark - Motion Events
-(void) motionBegan:(UIEventSubtype)motion withEvent:(UIEvent *)event{
    self.predictLabel.alpha=0.0f;
    self.predictLabel.text = nil;
    
}



-(void) motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event{
    NSLog(@"Motion ended");
    
    if (motion == UIEventSubtypeMotionShake){
        [self makePrediction];
    }
    
}
-(void) motionCancelled:(UIEventSubtype)motion withEvent:(UIEvent *)event{
    NSLog(@"motion cancelled");
}

#pragma  mark - Touch Event
-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    self.predictLabel.text = nil;
    self.predictLabel.alpha=0.0f;
}

-(void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
      [self makePrediction];
}
-(void) touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event{
    NSLog(@"touch cancelled");
}

@end
