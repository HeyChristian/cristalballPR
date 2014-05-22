//
//  cvCrystalBall.h
//  CrystalBall
//
//  Created by Christian Vazquez on 4/27/14.
//  Copyright (c) 2014 Christian Vazquez. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface cvCrystalBall : NSObject{
    NSArray *_predictions;
    
}

@property ( strong,nonatomic, readonly) NSArray *predictions;

- (NSString*) randomPrediction;

@end
