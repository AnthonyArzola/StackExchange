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

@property (nonatomic, strong, readwrite) NSMutableDictionary *avatarImages;

@end

@implementation SECache

@synthesize avatarImages;

- (id)init {
    if (self = [super init]) {
        self.avatarImages = [NSMutableDictionary new];
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
