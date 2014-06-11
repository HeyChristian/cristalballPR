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

@interface cvViewController ()<ADBannerViewDelegate,AVSpeechSynthesizerDelegate>

@property (readwrite, nonatomic, copy) NSString *utteranceString;
@property (readwrite, nonatomic, strong) AVSpeechSynthesizer *speechSynthesizer;

@end



@implementation cvViewController{
    SystemSoundID soundEffect;
}



- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //Speech Delegate
    //self.utteranceString = SpeechUtterancesByLanguage[Spanish]; //randomLanguage
    self.speechSynthesizer = [[AVSpeechSynthesizer alloc] init];
    self.speechSynthesizer.delegate = self;
    
    
    self.adView = [[ADBannerView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 50, 320, 50)];
    self.adView.delegate = self;
    self.adView.hidden = YES;
    [self.view addSubview:self.adView];
    
    
    self.crystalBall = [[cvCrystalBall alloc] init];
    NSString *soundPath = [[NSBundle mainBundle] pathForResource:@"crystal_ball" ofType:@"mp3"];
    NSURL *soundURL = [NSURL fileURLWithPath:soundPath];
    AudioServicesCreateSystemSoundID(CFBridgingRetain(soundURL),&soundEffect);

    
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
    


    
    [self.crystalBall fillPredictions];
    
}
#pragma mark ADBannerViewDelegate


- (void)bannerViewDidLoadAd:(ADBannerView *)banner {
    self.adView.hidden = NO;
}

- (void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error {
    self.adView.hidden = YES;
}


- (IBAction)buttonPressed {
    
          [self makePrediction];
}

#pragma mark - Prediction
-(void) makePrediction{
    [self.backgroundImageView startAnimating];
    
    self.utteranceString =[self.crystalBall randomPrediction];
    
    
    NSString *soundPath = [[NSBundle mainBundle] pathForResource:@"crystal_ball" ofType:@"mp3"];
    NSURL *soundURL = [NSURL fileURLWithPath:soundPath];
    AudioServicesCreateSystemSoundID(CFBridgingRetain(soundURL),&soundEffect);
    AudioServicesPlaySystemSound(soundEffect);
    
    
    [UIView animateWithDuration:6.0f animations:^{
        self.predictLabel.alpha = 1.0f;
        
    }];
    self.predictLabel.attributedText = [[NSAttributedString alloc] initWithString:self.utteranceString];
    
  //  NSMutableString *mutableString = [self.utteranceString mutableCopy];
    //CFStringTransform((__bridge CFMutableStringRef)mutableString, NULL, kCFStringTransformToLatin, NO);
  //  CFStringTransform((__bridge CFMutableStringRef)mutableString, NULL, kCFStringTransformStripCombiningMarks, NO);
   // self.transliterationLabel.text = mutableString;
    
    AVSpeechUtterance *utterance = [[AVSpeechUtterance alloc] initWithString:self.utteranceString];
   // NSLog(@"BCP-47 Language Code: %@", BCP47LanguageCodeForString(utterance.speechString));
    
    #define MY_SPEECH_RATE  0.1666 //0.1666
    #define MY_SPEECH_MPX  1.55 //1.55
    
    //es-MX
    utterance.voice = [AVSpeechSynthesisVoice voiceWithLanguage:@"es-MX"]; //@"es-ES"];
    utterance.pitchMultiplier = MY_SPEECH_MPX; //0.5f;
    utterance.rate = MY_SPEECH_RATE;  //AVSpeechUtteranceMinimumSpeechRate;
    utterance.preUtteranceDelay = 0.9f;
    utterance.postUtteranceDelay = 0.9f;
    
    [self.speechSynthesizer speakUtterance:utterance];
    
    
    

    
   // self.predictLabel.text = [self.crystalBall randomPrediction];
    
   

}

- (IBAction)showSettingsView:(id)sender {
      [self performSegueWithIdentifier:@"settings" sender:self];
}


#pragma mark - Motion Events
-(void) motionBegan:(UIEventSubtype)motion withEvent:(UIEvent *)event{
    self.predictLabel.alpha=0.0f;
    self.predictLabel.text = nil;
    
}



-(void) motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event{
   // NSLog(@"Motion ended");
    if (motion == UIEventSubtypeMotionShake){
        [self makePrediction];
    }
    
}

#pragma  mark - Touch Event
-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    self.predictLabel.text = nil;
    self.predictLabel.alpha=0.0f;
}

-(void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
      [self makePrediction];
}


#pragma mark - AVSpeechSynthesizerDelegate
- (void)speechSynthesizer:(AVSpeechSynthesizer *)synthesizer
willSpeakRangeOfSpeechString:(NSRange)characterRange
                utterance:(AVSpeechUtterance *)utterance
{
    @try {
   // NSLog(@"%@ %@", [self class], NSStringFromSelector(_cmd));
    
    NSMutableAttributedString *mutableAttributedString = [[NSMutableAttributedString alloc] initWithString:self.utteranceString];
    [mutableAttributedString addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:characterRange];
    self.predictLabel.attributedText = mutableAttributedString;

    
        
    }
    @catch (NSException * e) {
      //  NSLog(@"Exception: %@", e);
    }
    
}

- (void)speechSynthesizer:(AVSpeechSynthesizer *)synthesizer
  didStartSpeechUtterance:(AVSpeechUtterance *)utterance
{
  //  NSLog(@"%@ %@", [self class], NSStringFromSelector(_cmd));
    
    self.predictLabel.attributedText = [[NSAttributedString alloc] initWithString:self.utteranceString];
}

- (void)speechSynthesizer:(AVSpeechSynthesizer *)synthesizer
 didFinishSpeechUtterance:(AVSpeechUtterance *)utterance
{
   // NSLog(@"%@ %@", [self class], NSStringFromSelector(_cmd));
    
    self.predictLabel.attributedText = [[NSAttributedString alloc] initWithString:self.utteranceString];
}


@end
