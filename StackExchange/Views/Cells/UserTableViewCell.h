//
//  UserTableViewCell.h
//  StackExchange
//
//  Created by Anthony Arzola on 6/6/18.
//  Copyright © 2018 Anthony Arzola. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SEUser;

@interface UserTableViewCell : UITableViewCell

// Model
@property (nonatomic, weak) SEUser *user;

// UI
@property (weak, nonatomic) IBOutlet UIImageView *imageViewAvatar;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicatorAvatar;

@property (weak, nonatomic) IBOutlet UILabel *labelRank;
@property (weak, nonatomic) IBOutlet UIView *viewRank;

@property (weak, nonatomic) IBOutlet UILabel *labelUsername;
@property (weak, nonatomic) IBOutlet UILabel *labelLocation;

@property (weak, nonatomic) IBOutlet UIView *viewGold;
@property (weak, nonatomic) IBOutlet UIView *viewSilver;
@property (weak, nonatomic) IBOutlet UIView *viewBronze;

@property (weak, nonatomic) IBOutlet UILabel *labelGoldPoints;
@property (weak, nonatomic) IBOutlet UILabel *labelSilverPoints;
@property (weak, nonatomic) IBOutlet UILabel *labelBronzePoints;

- (void)setCellValues;

@end
