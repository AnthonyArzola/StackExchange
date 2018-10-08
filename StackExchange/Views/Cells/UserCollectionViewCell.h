//
//  UserCollectionViewCell.h
//  StackExchange
//
//  Created by Anthony Arzola on 7/8/18.
//  Copyright © 2018 Anthony Arzola. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SEUser;

@interface UserCollectionViewCell : UICollectionViewCell

// Model
@property (weak, nonatomic) SEUser *user;

// UI
@property (weak, nonatomic) IBOutlet UIImageView *imageViewAvatar;
@property (strong, nonatomic) IBOutlet UILabel *labelUsername;

+ (NSString *)cellIdentifier;

- (void)setCellValues;

@end
