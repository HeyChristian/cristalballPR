//
//  EntityPhrases.h
//  CrystalBall
//
//  Created by Christian Vazquez on 5/23/14.
//  Copyright (c) 2014 Christian Vazquez. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface EntityPhrases : NSManagedObject

@property (nonatomic, retain) NSString * uuid;
@property (nonatomic, retain) NSString * phrase;
@property (nonatomic, retain) NSDate * syncDate;
@property (nonatomic, retain) NSNumber * status;
@property (nonatomic, retain) NSNumber * isMature;

@end
