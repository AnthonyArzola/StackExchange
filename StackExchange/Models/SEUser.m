//
//  SEUser.m
//  StackExchange
//
//  Created by Anthony Arzola on 6/8/18.
//  Copyright © 2018 Anthony Arzola. All rights reserved.
//

#import "SEUser.h"

#import "SEBadges.h"

@implementation SEUser

// Core user properties
@synthesize accountId;
@synthesize userId;
@synthesize isEmployee;
@synthesize displayName;
@synthesize userType;
@synthesize location;
// Activity
@synthesize lastModifiedDate;
@synthesize lastAccessDate;
@synthesize creationDate;
// Reputation
@synthesize reputationChangeYear;
@synthesize reputationChangeQuarter;
@synthesize reputationChangeMonth;
@synthesize reputationChangeWeek;
@synthesize reputationChangeDay;
@synthesize reputation;
@synthesize acceptRate;
@synthesize badgeCounts;
// External links
@synthesize websiteUrl;
@synthesize link;
@synthesize profileImage;

#pragma mark - Constructors

- (id)init
{
    if (self = [super init])
    {
        badgeCounts = [SEBadges new];
    }
    return self;
}

@end
