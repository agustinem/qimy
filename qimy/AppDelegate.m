//
//  AppDelegate.m
//  qimy
//
//  Created by Agustín Embuena on 2/6/15.
//  Copyright (c) 2015 Agustín Embuena. All rights reserved.
//

#import "AppDelegate.h"
#import "Util.h"
#import "Constants.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginButton.h>
#import <BMASliders/BMASlider.h>
#import <BMASliders/BMARangeSlider.h>
#import "RangeStyle.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    if (IS_IPHONE_4_OR_LESS || IS_IPHONE_5 ){
        [[UILabel appearance] setFont:[UIFont fontWithName:@"Helvetica" size:14.0]];
        [[UITextField appearance] setFont:[UIFont fontWithName:@"Helvetica" size:14.0]];
        [[UITextView appearance] setFont:[UIFont fontWithName:@"Helvetica" size:14.0]];

    }
    [FBSDKLoginButton class];
    RangeStyle *range =[[RangeStyle alloc] init];
    [BMARangeSlider appearance].style =range;
    [BMASlider appearance].style = range;
    
    [[UINavigationBar appearance] setTintColor:[Util colorFromHexString:@"257d34"]];
    if ([application respondsToSelector:@selector(registerUserNotificationSettings:)]) {
        
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeBadge|UIUserNotificationTypeSound|UIUserNotificationTypeAlert) categories:nil];
        [application registerUserNotificationSettings:settings];
    }
    
    UILocalNotification *notification = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
    if (notification) {
        NSLog(@"app recieved notification from remote%@",notification);
        [self application:application didReceiveRemoteNotification:(NSDictionary*)notification];
    }else{
        NSLog(@"app did not recieve notification");
    }
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber: 0];
    [FBSDKProfile enableUpdatesOnAccessTokenChange:YES];
    
    

    return [[FBSDKApplicationDelegate sharedInstance] application:application
                                    didFinishLaunchingWithOptions:launchOptions];

}

- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings
{
    //register to receive notifications
    [application registerForRemoteNotifications];
}


- (void)application:(UIApplication *)application handleActionWithIdentifier:(NSString *)identifier forRemoteNotification:(NSDictionary *)userInfo completionHandler:(void(^)())completionHandler
{
    //handle the actions
    if ([identifier isEqualToString:@"declineAction"]){
    }
    else if ([identifier isEqualToString:@"answerAction"]){
    }
}

-(void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken{
    NSString *devToken = [[[[deviceToken description] stringByReplacingOccurrencesOfString:@"<"withString:@""] stringByReplacingOccurrencesOfString:@">" withString:@""] stringByReplacingOccurrencesOfString: @" " withString: @""];
    [[NSUserDefaults standardUserDefaults] setObject:devToken forKey:@"token"];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"notif_error_title", nil) message:NSLocalizedString(@"notif_error_mess", nil) delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    [alert show];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber: 0];
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    [[[UIAlertView alloc]initWithTitle:[NSString stringWithFormat:@"%@",[[userInfo objectForKey:@"titulo"] objectAtIndex:0]] message:[NSString stringWithFormat:@"%@",[[userInfo objectForKey:@"texto"] objectAtIndex:0]] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil] show];
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    [FBSDKAppEvents activateApp];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}


- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    return [[FBSDKApplicationDelegate sharedInstance] application:application
                                                          openURL:url
                                                sourceApplication:sourceApplication
                                                       annotation:annotation];
}

#pragma mark - Core Data stack

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (NSURL *)applicationDocumentsDirectory {
    // The directory the application uses to store the Core Data store file. This code uses a directory named "com.kometasoft.qimy" in the application's documents directory.
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)managedObjectModel {
    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"quimy" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    // The persistent store coordinator for the application. This implementation creates and return a coordinator, having added the store for the application to it.
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    // Create the coordinator and store
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"qimy.sqlite"];
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        // Report any error we got.
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        // Replace this with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}


- (NSManagedObjectContext *)managedObjectContext {
    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] init];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    return _managedObjectContext;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

@end
