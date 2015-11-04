//
//  Service.m
//  YoptiApplication
//
//  Created by Jyoti Sharma on 19/11/13.
//  Copyright (c) 2013 Jyoti Sharma. All rights reserved.
//

#import "Service.h"
#import "AFHTTPRequestOperationManager.h"
#import "Defines.h"
#import "AFHTTPRequestOperation.h"
#import "AppDelegate.h"
#import <CoreData/CoreData.h>
#import "AFAppDotNetAPIClient.h"
#import "NSString+SBJSON.h"
#import "AppHelper.h"
#import "Utility.h"
#define SERVICE_REPEAT 2   // means 0,1,2 three times

@implementation Service


NSMutableDictionary *resultDict;

+ (Service*) sharedInstance
{
    static Service* singleton;
	if (!singleton)
	{
		singleton = [[Service alloc] init];
	}
	return singleton;
}

- (id)init
{
    self = [super init];
    if (self) {
    }
    return self;
}

//MARK:- Sometimes fails to get response
-(void) showRequestTimeOutAlert:(NSString *)method
{
    //NSLog(@"Request time out from method:%@",method);
    [[AppDelegate getAppDelegate] hideActivityViewer];
    [AppHelper showAlertViewWithTag:0 title:APP_NAME message:ERROR_TIMEOUT delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
}


#pragma mark - CheckForUserName
-(void)getLocationDetails:(NSMutableDictionary *)dict
{
    NSInteger count = 0;
    if([AppHelper userDefaultsForKey:@"getLocationDetailsCount"])
    {
        count = [[AppHelper userDefaultsForKey:@"getLocationDetailsCount"] integerValue];
        if(count == SERVICE_REPEAT)
        {
            [AppHelper removeFromUserDefaultsWithKey:@"getLocationDetailsCount"];
            [[NSNotificationCenter defaultCenter]removeObserver:self name:Notification_GetDetails object:nil];
            [self showRequestTimeOutAlert:@"getLocationDetailsCount:"];
            return;
        }
    }
    if(count <=SERVICE_REPEAT-1)
    {
        
        [[AFAppDotNetAPIClient sharedClient] GET:[NSString stringWithFormat:@"%@\%@?lat=%@&lng=%@",BaseUrl11,[dict valueForKey:@"method"],[dict valueForKey:@"lat"],[dict valueForKey:@"lng"]] parameters:nil success:^(NSURLSessionDataTask *task, id responseObject)
         {
             [AppHelper removeFromUserDefaultsWithKey:@"getLocationDetailsCount"];
             NSString *decodedString = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding] ;
             
             //NSLog(@"%@",decodedString);
             
             NSDictionary *jsonDictD= [decodedString JSONValue];
             [[NSNotificationCenter defaultCenter]postNotificationName:Notification_GetDetails object:nil userInfo:jsonDictD];
             
         }
        failure:^(NSURLSessionDataTask *task, NSError *error)
         {
             int counter = 0;
             if([AppHelper userDefaultsForKey:@"getLocationDetailsCount"])
             {
                 counter = [[AppHelper userDefaultsForKey:@"getLocationDetailsCount"] intValue];
                 counter ++;
             }
             [AppHelper saveToUserDefaults:[NSNumber numberWithInt:counter] withKey:@"getLocationDetailsCount"];
             [self getLocationDetails:dict];
         }];
    }
}


//MARK:- AlertView delegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView.tag == 2)
    {
        if(buttonIndex == 0)
        {
            //load local db data
            
        }
    }
}
@end