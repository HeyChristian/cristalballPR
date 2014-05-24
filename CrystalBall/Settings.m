//
//  Settings.m
//  CrystalBall
//
//  Created by Christian Vazquez on 5/23/14.
//  Copyright (c) 2014 Christian Vazquez. All rights reserved.
//

#import "Settings.h"
#import "CoreDataStack.h"
#import "EntityAppConfig.h"


@implementation Settings



-(id) init{
    
    self.config = [self getAppConfiguration];
    NSLog(@">> %@",[self.config newContent]);
    

    return self;
}

-(EntityAppConfig *) getAppConfiguration{
    
    CoreDataStack *coreDataStack = [CoreDataStack defaultStack];
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:[NSEntityDescription entityForName:@"AppConfig" inManagedObjectContext: coreDataStack.managedObjectContext]];
    [request setFetchLimit:1];
    
    NSArray *results = [coreDataStack.managedObjectContext executeFetchRequest:request error:nil];
    EntityAppConfig *appconfig;
    
    if ([results count] == 0)
    {
        appconfig  = [NSEntityDescription insertNewObjectForEntityForName:@"AppConfig" inManagedObjectContext:coreDataStack.managedObjectContext];
        appconfig.newContent = [[NSNumber alloc] initWithInt:1];
        appconfig.isMature = [[NSNumber alloc] initWithInt:0];
        [coreDataStack saveContext];
        
    }
    else
    {
        appconfig = (EntityAppConfig*)[results objectAtIndex:0];
        self.downloadNewContent =  appconfig.newContent.intValue;
        self.useMatureContent =  appconfig.isMature.intValue;
        
    }
    return appconfig;
}

-(void) SaveAppConfig{
    
    CoreDataStack *coreDataStack = [CoreDataStack defaultStack];
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:[NSEntityDescription entityForName:@"AppConfig" inManagedObjectContext: coreDataStack.managedObjectContext]];
    [request setFetchLimit:1];
    
    NSArray *results = [coreDataStack.managedObjectContext executeFetchRequest:request error:nil];
    EntityAppConfig *appconfig;
    
    if ([results count] == 0)
    {
         appconfig  = [NSEntityDescription insertNewObjectForEntityForName:@"AppConfig" inManagedObjectContext:coreDataStack.managedObjectContext];
    }
    else
    {
        appconfig = (EntityAppConfig*)[results objectAtIndex:0];
    }
    
    
    appconfig.newContent = [[NSNumber alloc] initWithInt:self.downloadNewContent];
    appconfig.isMature = [[NSNumber alloc] initWithInt:self.useMatureContent];
    
    [coreDataStack saveContext];
    
    
}


-(id)initWithDefaults {
    
  
    NSMutableDictionary *settings = [self getConfiguationFile];
    
    self.downloadNewContent =  [self castStringToInt:[settings objectForKey:@"downloadContent"] andDefaultValue:1];
    self.useMatureContent =  [self castStringToInt:[settings objectForKey:@"matureContent"] andDefaultValue:0];
    NSLog(@"data: %@",settings);
    
    return self;
}
-(int) castStringToInt:(NSString *)property andDefaultValue:(int) defaultValue{
   
    if(property != nil ){
        return property.intValue;
    }else{
        return defaultValue;
    }
}

-(NSMutableDictionary *) getConfiguationFile{
 
    NSString *settingsPath = [self path];
    NSMutableDictionary *settings = [NSMutableDictionary dictionary];
    if([[NSFileManager defaultManager] fileExistsAtPath:settingsPath]){
        settings = [NSMutableDictionary dictionaryWithContentsOfFile:settingsPath];
        
     //   NSLog(@"exist config file");
    }
    return settings;
}

-(NSString *) path{
    return  [[NSBundle mainBundle] pathForResource:@"appConfig" ofType:@"plist"];
}

-(void) saveSettings{
    
    NSMutableDictionary *data = [self getConfiguationFile];
    
    //[[NSMutableDictionary alloc] initWithContentsOfFile: [self path]];
    
   // NSLog(@"path: %@,",[self path]);
    [data setObject:[NSNumber numberWithInt:self.downloadNewContent] forKey:@"downloadContent"];
    [data setObject:[NSNumber numberWithInt:self.useMatureContent] forKey:@"matureContent"];
    
     NSLog(@"data: %@,",data);
    
    [self writePlist:data];
    
}

- (id)readPlist {
    NSData *plistData;
    NSString *error;
    NSPropertyListFormat format;
    id plist;
    
    NSString *localizedPath = [[NSBundle mainBundle] pathForResource:@"appConfig" ofType:@"plist"];
    plistData = [NSData dataWithContentsOfFile:localizedPath];
    
    plist = [NSPropertyListSerialization propertyListFromData:plistData mutabilityOption:NSPropertyListImmutable format:&format errorDescription:&error];
    if (!plist) {
        NSLog(@"Error reading plist from file '%s', error = '%s'", [localizedPath UTF8String], [error UTF8String]);
       
    }
    
    return plist;
}
- (NSArray *)getArray {
    return (NSArray *)[self readPlist];
}

- (NSMutableDictionary *)getDictionary {
    return (NSMutableDictionary *)[self readPlist];
}
- (void)writePlist:(id)plist  {
    NSData *xmlData;
    NSString *error;
    
    
    
    NSString *localizedPath = [self path]; //[[NSBundle mainBundle] pathForResource:fileName ofType:@"plist"];
    xmlData = [NSPropertyListSerialization dataFromPropertyList:plist format:NSPropertyListXMLFormat_v1_0 errorDescription:&error];
    if (xmlData) {
        [xmlData writeToFile:localizedPath atomically:YES];
    
    } else {
        NSLog(@"Error writing plist to file '%s', error = '%s'", [localizedPath UTF8String], [error UTF8String]);
    
    }
}

@end
