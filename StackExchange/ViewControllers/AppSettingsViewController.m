//
//  AppSettingsViewController.m
//  StackExchange
//
//  Created by Anthony Arzola on 6/17/18.
//  Copyright © 2018 Anthony Arzola. All rights reserved.
//

#import "AppSettingsViewController.h"
#import "SEConstants.h"

@interface AppSettingsViewController ()

@end

@implementation AppSettingsViewController

@synthesize downloadDataSwitch;

#pragma mark - View life cycle methods

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    if ([userDefaults objectForKey:SETTINGS_FORCE_DOWNLOAD] != nil)
    {
        downloadDataSwitch.on = [userDefaults boolForKey:SETTINGS_FORCE_DOWNLOAD];
    }
    else {
        downloadDataSwitch.on = NO;
    }
}

#pragma mark - Button events

- (IBAction)closeView:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)changedSwitch:(id)sender {

    // Update user's settings
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    if([sender isOn]) {
        [userDefaults setBool:YES forKey:SETTINGS_FORCE_DOWNLOAD];
    } else{
        [userDefaults setBool:NO forKey:SETTINGS_FORCE_DOWNLOAD];
    }
    
    [userDefaults synchronize];
}

@end
