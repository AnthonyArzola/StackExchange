//
//  SECache.h
//  StackExchange
//
//  Created by Anthony Arzola on 6/10/18.
//  Copyright © 2018 Anthony Arzola. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SECache : NSObject

+ (SECache *)sharedInstance;

@property (nonatomic, strong, readonly) NSCache *avatarImages;

@end
