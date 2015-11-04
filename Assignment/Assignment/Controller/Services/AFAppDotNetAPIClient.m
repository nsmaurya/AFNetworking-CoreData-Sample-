//
//  AFAppDotNetAPIClient.m
//  BarManagement_Venue
//
//  Created by Prankur on 12/09/14.
//  Copyright (c) 2014 Appstudioz. All rights reserved.
//

#import "AFAppDotNetAPIClient.h"
#import "Defines.h"
@implementation AFAppDotNetAPIClient

+ (instancetype)sharedClient {
    static AFAppDotNetAPIClient *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[AFAppDotNetAPIClient alloc] initWithBaseURL:[NSURL URLWithString:BaseUrl11]];
        _sharedClient.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    });
    return _sharedClient;
}


@end
