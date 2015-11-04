//
//  AFAppDotNetAPIClient.h
//  BarManagement_Venue
//
//  Created by Prankur on 12/09/14.
//  Copyright (c) 2014 Appstudioz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFHTTPSessionManager.h"

@interface AFAppDotNetAPIClient : AFHTTPSessionManager

+ (instancetype)sharedClient;

@end
