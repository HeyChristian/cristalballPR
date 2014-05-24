//
//  Settings.h
//  CrystalBall
//
//  Created by Christian Vazquez on 5/23/14.
//  Copyright (c) 2014 Christian Vazquez. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EntityAppConfig.h"


@interface Settings : NSObject

@property(nonatomic,strong) EntityAppConfig *config;
@property(nonatomic)int useMatureContent;
@property(nonatomic)int downloadNewContent;

-(id) init;
-(void) SaveAppConfig;
//-(id)initWithDefaults;
//-(void) saveSettings;

@end
