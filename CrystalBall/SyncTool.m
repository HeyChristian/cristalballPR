//
//  SyncTool.m
//  CrystalBall
//
//  Created by Christian Vazquez on 5/23/14.
//  Copyright (c) 2014 Christian Vazquez. All rights reserved.
//

#import "SyncTool.h"
#import <Parse/Parse.h>
#import "CoreDataStack.h"
#import "Settings.h"

@implementation SyncTool


- (void) DownloadPhrases{
    //Download all pharses and sync into CoreData
    Settings *config =[[Settings alloc] init];
    
    
    
    if(config.downloadNewContent==1){
    
   CoreDataStack *coreDataStack = [CoreDataStack defaultStack];
   // NSString *uuid;
    
    self.newPhrases=0;
    self.updatePhrases=0;
    self.countPhrases=0;
    self.needUpdate=NO;
    self.exist=NO;
  
  
    
    PFQuery *query = [PFQuery queryWithClassName:@"Phrases"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
          //  NSLog(@"Successfully retrieved %lu scores.", (unsigned long)objects.count);
            
            EntityPhrases *phrase;
            for (PFObject *object in objects) {
               
               self.needUpdate=NO;
               self.exist=NO;
              // NSLog(@"%@ - %@",[object objectForKey:@"uuid"],[object objectForKey:@"needUpdate"]);
             
              NSString *uuid = [[NSString alloc] initWithString:[object objectForKey:@"uuid"]];
                
                phrase= [self getPhraseIfExist:uuid withManagedObjectContext:coreDataStack.managedObjectContext];
                
                if(phrase==nil){
                    phrase = [NSEntityDescription insertNewObjectForEntityForName:@"Phrases" inManagedObjectContext:coreDataStack.managedObjectContext];
                  
                    self.exist=NO;
                    self.newPhrases += 1;
                }else{
                    self.exist=YES;
                    
                    if((bool)[object objectForKey:@"needUpdate"]==1){
                        self.updatePhrases+=1;
                    }
                }
                
                
                if(self.exist==NO || (bool)[object objectForKey:@"needUpdate"]==1){
                    phrase.uuid=[object objectForKey:@"uuid"];
                    phrase.phrase=[object objectForKey:@"phrase"];
                    phrase.syncDate=[NSDate date];
                    phrase.status=[object objectForKey:@"status"];
                    phrase.isMature=[object objectForKey:@"isMature"];
                }
            
                self.countPhrases+=1;
                
                [coreDataStack saveContext];
            }
            
           
           // NSLog(@"NEW: %d",self.newPhrases);
           // NSLog(@"UPD: %d",self.updatePhrases);
            
        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
    }
    else{
        NSLog(@"Dont use additional content");
    }
}

- (EntityPhrases *) getPhraseIfExist:(NSString *)uuid withManagedObjectContext:(NSManagedObjectContext*)context{
    
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:[NSEntityDescription entityForName:@"Phrases" inManagedObjectContext:context]];
    [request setPredicate:[NSPredicate predicateWithFormat:@"uuid = %@", uuid]];
    [request setFetchLimit:1];
  
    NSArray *results = [context executeFetchRequest:request error:nil];
    
    EntityPhrases* phrase = nil;
    
    if ([results count] == 0)
    {
        phrase= nil;
    }
    else
    {
        phrase = (EntityPhrases*)[results objectAtIndex:0];
    }
    
    
    return phrase;
  
}


- (NSArray *) getPhrases{
    CoreDataStack *coreDataStack = [CoreDataStack defaultStack];
    
    
    Settings *config = [[Settings alloc] init];
    
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:[NSEntityDescription entityForName:@"Phrases" inManagedObjectContext:coreDataStack.managedObjectContext]];
    [request setPredicate:[NSPredicate predicateWithFormat:@"status == %d", 1]];
    [request setPredicate:[NSPredicate predicateWithFormat:@"isMature == 0 or isMature == %d",config.useMatureContent]];
 
    NSArray *results = [coreDataStack.managedObjectContext executeFetchRequest:request error:nil];
    
    NSMutableArray *phrases=[[NSMutableArray alloc] init];
    
    for(EntityPhrases *phrase in results){
        [phrases addObject:phrase.phrase];
    }
    
    return phrases;

}

@end
