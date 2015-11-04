//
//  AppDelegate.h
//  Assignment
//
//  Created by Sunil Maurya on 9/29/15.
//  Copyright © 2015 CodeBrew. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;
-(void)showActivityViewer:(NSString* )msg;
-(void)hideActivityViewer;
+(AppDelegate *)getAppDelegate;
- (BOOL) checkInternetConnection;
@end

