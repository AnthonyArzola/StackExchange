//
//  SEUser.h
//  StackExchange
//
//  Created by Anthony Arzola on 6/8/18.
//  Copyright © 2018 Anthony Arzola. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SEBadges;

@interface SEUser : NSObject

// Core user properties
@property (nonatomic, assign) int accountId;
@property (nonatomic, assign) int userId;
@property (nonatomic, assign) bool isEmployee;
@property (nonatomic, strong) NSString *displayName;
@property (nonatomic, strong) NSString *userType;
@property (nonatomic, strong) NSString *location;
// Activity
@property (nonatomic, assign) int lastModifiedDate;
@property (nonatomic, assign) int lastAccessDate;
@property (nonatomic, assign) int creationDate;
// Reputation
@property (nonatomic, assign) int reputationChangeYear;
@property (nonatomic, assign) int reputationChangeQuarter;
@property (nonatomic, assign) int reputationChangeMonth;
@property (nonatomic, assign) int reputationChangeWeek;
@property (nonatomic, assign) int reputationChangeDay;
@property (nonatomic, assign) int reputation;
@property (nonatomic, assign) int acceptRate;
@property (nonatomic, strong) SEBadges *badgeCounts;
// External links
@property (nonatomic, strong) NSString *websiteUrl;
@property (nonatomic, strong) NSString *link;
@property (nonatomic, strong) NSString *profileImage;

@end
