//
//  Service.h
//  YoptiApplication
//
//  Created by Jyoti Sharma on 19/11/13.
//  Copyright (c) 2013 Jyoti Sharma. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Service : NSObject<UIAlertViewDelegate>
{
    
}

+ (Service*) sharedInstance;
-(void)getLocationDetails:(NSMutableDictionary *)dict;
@end
