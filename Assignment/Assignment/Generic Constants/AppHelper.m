//
//  AppHelper.m
//  IntroduceThem
//
//  Created by Jitendra Singh on 13/06/11.
//  Copyright 2011 Tata Consultant Services. All rights reserved.
//

#import "AppHelper.h"
#import "Defines.h"
#import "AppDelegate.h"


@implementation AppHelper

//MARK:- Apphelper values


+(void)saveToUserDefaults:(id)value withKey:(NSString*)key
{
	NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
    
	if (standardUserDefaults) {
		[standardUserDefaults setObject:value forKey:key];
		[standardUserDefaults synchronize];
	}
}


+(NSString*)userDefaultsForKey:(NSString*)key
{
	NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
	NSString *val = nil;
	
	if (standardUserDefaults) 
		val = [standardUserDefaults objectForKey:key];
	
	return val;
}
+(id)userDefaultsForAny:(NSString*)key
{
	NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
	id val = nil;
	
	if (standardUserDefaults)
		val = [standardUserDefaults objectForKey:key];
	
	return val;
}
+(NSArray*)userDefaultsForArray:(NSString*)key
{
	NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
	NSArray *val = nil;
	
	if (standardUserDefaults) 
		val = [standardUserDefaults objectForKey:key];
	
	return val;
}
+(void)removeFromUserDefaultsWithKey:(NSString*)key
{
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
    
    [standardUserDefaults removeObjectForKey:key];
    [standardUserDefaults synchronize];
}


+(void)saveDictToUserDefaults:(id)value withKey:(NSString*)key
{
    NSData* data=[NSKeyedArchiver archivedDataWithRootObject:value];
    
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
    
    if (standardUserDefaults) {
        [standardUserDefaults setObject:data forKey:key];
        [standardUserDefaults synchronize];
    }
}

+(NSDictionary*)dictDefaultsForKey:(NSString*)key
{
     NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
    
    NSData* data = [standardUserDefaults objectForKey:key];
    NSDictionary* json = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    
    return json;
}

+ (id)jsonValue:(NSData *)data
{
    NSError *error;
    id result;
    result = [NSJSONSerialization JSONObjectWithData:data
                                             options:0
                                               error:&error];
    return result;
}

#pragma mark- Alert view

+ (void) showAlertViewWithTag:(NSInteger)tag title:(NSString*)title message:(NSString*)msg delegate:(id)delegate 
            cancelButtonTitle:(NSString*)CbtnTitle otherButtonTitles:(NSString*)otherBtnTitles
{
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:msg delegate:delegate 
										  cancelButtonTitle:CbtnTitle otherButtonTitles:otherBtnTitles, nil];
    alert.tag = tag;
	[alert show];
}

@end
