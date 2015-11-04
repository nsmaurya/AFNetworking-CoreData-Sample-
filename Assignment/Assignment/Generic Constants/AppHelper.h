//
//  AppHelper.h
//  IntroduceThem
//
//  Created by Jitendra Singh on 13/06/11.
//  Copyright 2011 Tata Consultant Services. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
@interface AppHelper : NSObject <UIAlertViewDelegate>
{

}
+(id)userDefaultsForAny:(NSString*)key;
+(void)saveToUserDefaults:(id)value withKey:(NSString*)key;
+(NSString*)userDefaultsForKey:(NSString*)key;
+(NSArray*)userDefaultsForArray:(NSString*)key;
+(void)removeFromUserDefaultsWithKey:(NSString*)key;
+ (void) showAlertViewWithTag:(NSInteger)tag title:(NSString*)title message:(NSString*)msg delegate:(id)delegate 
            cancelButtonTitle:(NSString*)CbtnTitle otherButtonTitles:(NSString*)otherBtnTitles;
+(id)jsonValue:(NSData *)data;

+(void)saveDictToUserDefaults:(id)value withKey:(NSString*)key;
+(NSDictionary*)dictDefaultsForKey:(NSString*)key;

@end
