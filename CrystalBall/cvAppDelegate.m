//
//  cvAppDelegate.m
//  CrystalBall
//
//  Created by Christian Vazquez on 4/27/14.
//  Copyright (c) 2014 Christian Vazquez. All rights reserved.
//

#import "cvAppDelegate.h"
#import <Parse/Parse.h>
#import "SyncTool.h"
#import "Settings.h"
#import "ASReviewPopup.h"

@implementation cvAppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes: (UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)];
   
    application.applicationIconBadgeNumber = 0;
    
    /*
    //Registration Push Notifications
    [application registerForRemoteNotificationTypes:
     UIRemoteNotificationTypeBadge |
     UIRemoteNotificationTypeAlert |
     UIRemoteNotificationTypeSound];
    */
    
    [Parse setApplicationId:@"aLkAwDmQF71fdog3WEEpuW1dZ3QXJuFPWcgsdmRB"
                  clientKey:@"qLim1zRzLkCvupbgNiE2Kt2lUwSpWHduLVPVY1sh"];
    
    
    [PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
    
    
  
    SyncTool *tool = [[SyncTool alloc] init];
    [tool DownloadPhrases];
        
    [NSThread sleepForTimeInterval:3.0];
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    
    SyncTool *tool = [[SyncTool alloc] init];
    [tool DownloadPhrases];
    
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    
    // Show the popup for every major update of the app
    [[ASReviewPopup sharedPopup] setPopupFrequency:ASReviewPopupFrequencyMajorVersion];     // You can set this to ASReviewPopupFrequencyAlways to force the alert to always show when testing
    
    // Set the number of days to wait before showing the alert
    [[ASReviewPopup sharedPopup] setNumberOfDaysBeforeShowingPopup:2];
    
    // Set the App Store URL -
    [[ASReviewPopup sharedPopup] setAppStoreURL:[NSURL URLWithString:@"itms-apps://ax.itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=882117059"]];
    
    // Call to trigger
    [[ASReviewPopup sharedPopup] showAlertReminderAfterDaysHaveElapsed];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}



- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    PFInstallation *currentInstallation = [PFInstallation currentInstallation];
    [currentInstallation setDeviceTokenFromData:deviceToken];
    currentInstallation.channels = @[@"global"];
    [currentInstallation saveInBackground];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    if (error.code == 3010) {
        NSLog(@"Push notifications are not supported in the iOS Simulator.");
    } else {
        // show some alert or otherwise handle the failure to register.
        NSLog(@"application:didFailToRegisterForRemoteNotificationsWithError: %@", error);
    }
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    [PFPush handlePush:userInfo];
}

@end
