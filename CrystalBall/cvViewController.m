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
#import <iAd/iAd.h>

@interface cvViewController ()

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
    
    
//UIImage *backgroundImage = [UIImage imageNamed:@"background"];
   // UIImageView *imageView = [[UIImageView alloc] initWithImage:backgroundImage];
    
   // [self.view insertSubview:imageView atIndex:0];
    
    self.predictLabel.text = nil;
    
    NSMutableArray *animationImages = [[NSMutableArray alloc] init];
   // NSNumber *i = [[NSNumber alloc] initWithInt:1];
    NSString *imageName = [[NSString alloc] init];
   int i=1;
   while (i < 61){
        
   //     NSLog(@" i is %d",i);
        
        if( i < 10){
           imageName = [@"CB0000" stringByAppendingString:[NSString stringWithFormat:@"%i",i]];
        }else{
            imageName = [@"CB000" stringByAppendingString:[NSString stringWithFormat:@"%i",i]];
            
        }
     
       [animationImages addObject:[UIImage imageNamed:imageName]];
       i++;
       NSLog(@" >> %@",imageName);
   }
    
  self.backgroundImageView.animationImages = animationImages;
  self.backgroundImageView.animationDuration=2.5f;
  self.backgroundImageView.animationRepeatCount = 1;
    
    
    
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    ADBannerView *adView = [[ADBannerView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 50, 320, 50)];
    [self.view addSubview:adView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
