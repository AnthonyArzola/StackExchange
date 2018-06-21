//
//  SECache.m
//  StackExchange
//
//  Created by Anthony Arzola on 6/10/18.
//  Copyright © 2018 Anthony Arzola. All rights reserved.
//

#import "SECache.h"

static SECache * _sharedInstance = nil;

@interface SECache()

@property (nonatomic, strong, readwrite) NSCache *avatarImages;

@end

@implementation SECache

@synthesize avatarImages;

- (id)init {
    if (self = [super init]) {
        self.avatarImages = [NSCache new];
        self.avatarImages.countLimit = 50;
    }
    return self;
}

+ (SECache *)sharedInstance {
    if (!_sharedInstance)
    {
        _sharedInstance = [SECache new];
    }
    
    return _sharedInstance;
}

@end
