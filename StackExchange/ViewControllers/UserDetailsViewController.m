//
//  UserDetailsViewController.m
//  StackExchange
//
//  Created by Anthony Arzola on 6/9/18.
//  Copyright © 2018 Anthony Arzola. All rights reserved.
//

#import "UserDetailsViewController.h"

// Models
#import "SEUser.h"

// Classes
#import "SECache.h"

@implementation UserDetailsViewController

@synthesize user;
@synthesize imageAvatar;

@synthesize labelDisplayName;
@synthesize labelJoinDate;
@synthesize labelLastActive;
@synthesize labelReputation;

#pragma mark - UIViewController methods

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.imageAvatar.layer.cornerRadius = self.imageAvatar.frame.size.width / 2;
    self.imageAvatar.layer.masksToBounds = YES;
    self.imageAvatar.layer.borderWidth = 1;
    self.imageAvatar.layer.borderColor = UIColor.lightGrayColor.CGColor;

    self.labelDisplayName.text = user.displayName;
    
    // Let's leverage the cache!
    UIImage *cachedImage = [[SECache sharedInstance].avatarImages objectForKey:[NSNumber numberWithInt:user.userId]];
    self.imageAvatar.image = cachedImage;
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"MMM dd, yyyy"];
    
    NSTimeInterval interval = (NSTimeInterval)user.creationDate;
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:interval];
    self.labelJoinDate.text = [NSString stringWithFormat:@"%@", [dateFormat stringFromDate:date]];
    
    interval = (NSTimeInterval)user.lastAccessDate;
    date = [NSDate dateWithTimeIntervalSince1970:interval];
    self.labelLastActive.text = [NSString stringWithFormat:@"%@", [dateFormat stringFromDate:date]];
    
    NSNumberFormatter *formatter = [NSNumberFormatter new];
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    self.labelReputation.text = [formatter stringFromNumber:[NSNumber numberWithInt:user.reputation]];
}

@end
