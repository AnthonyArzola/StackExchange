//
//  SEWebService.m
//  StackExchange
//
//  Created by Anthony Arzola on 6/8/18.
//  Copyright © 2018 Anthony Arzola. All rights reserved.
//

#import "SEWebService.h"
#import "SEConstants.h"

#import "AFNetworking.h"

@interface SEWebService()

@property (nonatomic, strong) AFHTTPSessionManager *AFSessionManager;

@end

@implementation SEWebService

@synthesize AFSessionManager;

- (id)init
{
    if (self = [super init])
    {
        // Configure AF Networking session manager
        AFSessionManager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:API_BASE_URL]
                                                     sessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
        AFSessionManager.requestSerializer = [AFJSONRequestSerializer serializer];
    }
    
    return self;
}

- (void)requestUsers:(void (^)(id responseObject))success
         withFailure:(void (^)(NSError *error))failure
{
    // GET https://api.stackexchange.com/2.2/users?site=stackoverflow
    
    NSMutableDictionary *parameters = [NSMutableDictionary new];
    [parameters setValue:STACK_OVERFLOW forKey:PARAMETER_SITE];
    
    [AFSessionManager GET:API_PATH_USERS
               parameters:parameters
                 progress:nil
                  success:^(NSURLSessionDataTask * _Nonnull task, id _Nullable responseObject) {
                       success(responseObject);
                  } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                      failure(error);
                  }
     ];
}



@end
