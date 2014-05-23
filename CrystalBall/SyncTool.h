//
//  SyncTool.h
//  CrystalBall
//
//  Created by Christian Vazquez on 5/23/14.
//  Copyright (c) 2014 Christian Vazquez. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EntityPhrases.h"
@interface SyncTool : NSObject


@property(nonatomic)int newPhrases;
@property(nonatomic)int updatePhrases;
@property(nonatomic)int countPhrases;
@property(nonatomic)bool exist;
@property(nonatomic)bool needUpdate;





- (void) DownloadPhrases;
- (EntityPhrases *) getPhraseIfExist:(NSString *)uuid withManagedObjectContext:(NSManagedObjectContext*)context;
- (NSArray *) getPhrases;


@end
