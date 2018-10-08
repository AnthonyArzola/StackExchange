//
//  UserCollectionViewCell.m
//  StackExchange
//
//  Created by Anthony Arzola on 7/8/18.
//  Copyright © 2018 Anthony Arzola. All rights reserved.
//

#import "UserCollectionViewCell.h"
// Models
#import "SEUser.h"

@implementation UserCollectionViewCell

@synthesize user;

- (void)layoutSubviews {
    [super layoutSubviews];
 
    self.imageViewAvatar.layer.cornerRadius = self.imageViewAvatar.frame.size.width / 2;
    self.imageViewAvatar.layer.masksToBounds = YES;
    self.imageViewAvatar.layer.borderWidth = 1;
    self.imageViewAvatar.layer.borderColor = UIColor.lightGrayColor.CGColor;
}

#pragma mark - Public methods

+ (NSString *)cellIdentifier {
    return @"StackOverflowCollectionCell";
}

- (void)setCellValues {
    self.labelUsername.text = self.user.displayName;
}

@end
