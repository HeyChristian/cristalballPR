//
//  cvCrystalBall.h
//  CrystalBall
//
//  Created by Christian Vazquez on 4/27/14.
//  Copyright (c) 2014 Christian Vazquez. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface cvCrystalBall : NSObject

@property ( strong,nonatomic) NSArray *predictions;

- (NSString*) randomPrediction;
-(void)fillPredictions;
-(NSArray *)getPredictions;
@end
