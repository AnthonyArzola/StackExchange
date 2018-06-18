//
//  AppDelegate.m
//  StackExchange
//
//  Created by Anthony Arzola on 6/6/18.
//  Copyright © 2018 Anthony Arzola. All rights reserved.
//

#import "AppDelegate.h"
#import "SEConstants.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    // Override point for customization after application launch.
    
    // Create 'Avatars' directory if it doesn't exist
    NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docDirectory = [path objectAtIndex:0];
    NSString *avatarPath = [docDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@", @"Avatars"]];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if (![fileManager fileExistsAtPath:avatarPath])
    {
        NSLog(@"Creating directory:%@", avatarPath);
        
        NSError *error;
        @try {
            [fileManager createDirectoryAtPath:avatarPath withIntermediateDirectories:NO attributes:nil error:&error];
        }
        @catch (NSException *exception) {
            NSLog(@"Error attempting to create directory %@. Error is:%@. Exception is: %@.", avatarPath, error.localizedDescription, exception);
        }
    }
    
    // Ensure user settings has safe default
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if ([userDefaults objectForKey:SETTINGS_FORCE_DOWNLOAD] == nil)
    {
        [userDefaults setBool:NO forKey:SETTINGS_FORCE_DOWNLOAD];
        [userDefaults synchronize];
    }
    
    // In general, you shouldn't send sleep commands. In this case, I just want
    // the launch screen to stay up a bit longer.
    [NSThread sleepForTimeInterval:0.5f];
    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
