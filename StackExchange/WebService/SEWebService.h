//
//  SEWebService.h
//  StackExchange
//
//  Created by Anthony Arzola on 6/8/18.
//  Copyright © 2018 Anthony Arzola. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SEWebService : NSObject

/*!
 @abstract Get users
 @param success block
 @param failure block
 */
- (void)requestUsers:(void (^)(id responseObject))success
         withFailure:(void (^)(NSError *error))failure;

@end
