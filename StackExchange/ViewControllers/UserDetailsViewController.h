//
//  UserDetailsViewController.h
//  StackExchange
//
//  Created by Anthony Arzola on 6/9/18.
//  Copyright © 2018 Anthony Arzola. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SEUser;

@interface UserDetailsViewController : UIViewController

// Models
@property (weak, nonatomic) SEUser *user;

// UI
@property (weak, nonatomic) IBOutlet UIImageView *imageAvatar;

@property (weak, nonatomic) IBOutlet UILabel *labelDisplayName;
@property (weak, nonatomic) IBOutlet UILabel *labelJoinDate;
@property (weak, nonatomic) IBOutlet UILabel *labelLastActive;
@property (weak, nonatomic) IBOutlet UILabel *labelReputation;

@end
