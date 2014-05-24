//
//  EntityAppConfig.h
//  CrystalBall
//
//  Created by Christian Vazquez on 5/23/14.
//  Copyright (c) 2014 Christian Vazquez. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface EntityAppConfig : NSManagedObject

@property (nonatomic, retain) NSNumber * isMature;
@property (nonatomic, retain) NSNumber * newContent;

@end
