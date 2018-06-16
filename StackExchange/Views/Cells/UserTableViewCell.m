//
//  UserTableViewCell.m
//  StackExchange
//
//  Created by Anthony Arzola on 6/6/18.
//  Copyright © 2018 Anthony Arzola. All rights reserved.
//

#import "UserTableViewCell.h"

// Models
#import "SEUser.h"
#import "SEBadges.h"

@interface UserTableViewCell ()

@property (nonatomic, strong) NSNumberFormatter *formatter;

@end

@implementation UserTableViewCell

@synthesize user;
@synthesize formatter;

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    formatter = [NSNumberFormatter new];
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
}
    
- (void)layoutSubviews {
    [super layoutSubviews];
    
    // Configure badge/points
    [self configureBadgeView:_viewGold withBorderColor:UIColor.yellowColor];
    [self configureBadgeView:_viewSilver withBorderColor:UIColor.darkGrayColor];
    [self configureBadgeView:_viewBronze withBorderColor:UIColor.brownColor];
    
    // Configure rank
    self.viewRank.clipsToBounds = YES;
    self.viewRank.layer.cornerRadius = 11;
    self.viewRank.layer.borderWidth = 1;
    self.viewRank.layer.borderColor = UIColor.whiteColor.CGColor;
    
    // Configure image view
    [self.activityIndicatorAvatar startAnimating];
    self.activityIndicatorAvatar.hidesWhenStopped = YES;
    
    self.imageViewAvatar.layer.cornerRadius = self.imageViewAvatar.frame.size.width / 2;
    self.imageViewAvatar.layer.masksToBounds = YES;
    self.imageViewAvatar.layer.borderWidth = 1;
    self.imageViewAvatar.layer.borderColor = UIColor.lightGrayColor.CGColor;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - Public methods

- (void)setCellValues {
    
    self.labelUsername.text = self.user.displayName;
    
    if (user.location != nil)
    {
        self.labelLocation.text = [NSString stringWithUTF8String:[self.user.location cStringUsingEncoding:NSUTF8StringEncoding]];
    }
    else {
        self.labelLocation.text = @"User is off the grid.";
    }
    
    self.labelGoldPoints.text = [formatter stringFromNumber:[NSNumber numberWithInt:self.user.badgeCounts.gold]];
    self.labelSilverPoints.text = [formatter stringFromNumber:[NSNumber numberWithInt:self.user.badgeCounts.silver]];
    self.labelBronzePoints.text = [formatter stringFromNumber:[NSNumber numberWithInt:self.user.badgeCounts.bronze]];
}

#pragma mark - Private methods

- (void)configureBadgeView:(UIView *)badgeView withBorderColor:(UIColor *)color {
    badgeView.layer.borderColor = color.CGColor;
    badgeView.layer.borderWidth = 1;
    badgeView.layer.cornerRadius = 7;
}

@end
