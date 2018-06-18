//
//  AppSettingsViewController.h
//  StackExchange
//
//  Created by Anthony Arzola on 6/17/18.
//  Copyright © 2018 Anthony Arzola. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppSettingsViewController : UIViewController

// UI properties
@property (weak, nonatomic) IBOutlet UISwitch *downloadDataSwitch;

// Events
- (IBAction)closeView:(id)sender;

- (IBAction)changedSwitch:(id)sender;

@end
