//
//  Utility.h
//  
//
//  Created by Sunil Maurya on 9/29/15.
//  Copyright © 2015 CodeBrew. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
@interface Utility : NSObject
{
    NSManagedObjectContext *managedObjectContext;
    NSManagedObject *managedObject;
}
@property NSManagedObjectContext *_managedObjectContext;
@property NSManagedObject *_managedObject;
+(Utility *) getUtilityObject;
-(NSManagedObject *)getManagedObject;
-(NSEntityDescription *) getEntityDescription:(NSString *)tableName;
-(BOOL) insertData:(NSDictionary *)dictionary inTable:(NSString *)tableName withArray:(NSArray *)array;
-(BOOL) isDataAvailableInTable:(NSString *) tableName forPredicate:(NSPredicate *)predicate;
-(NSArray *) getAllDataFromTable:(NSString *) tableName forPredicate:(NSPredicate *) predicate withDescriptor:(NSArray *)sortDescriptors;
-(BOOL) deleteRecordsFromTable:(NSString *)tableName withRecord:(NSManagedObject *)managedObject;
-(BOOL) updateRecordsFromTable:(NSString *)tableName withRecord:(NSDictionary *)dictionary andArray:(NSArray *) arrDetails onObject:(NSManagedObject *)managedObject;
-(NSNumber *) getMaxID:(NSString *) tableName;
-(BOOL) deleteAllRecordsFromTable:(NSString *)tableName;
-(void) updateMutilpleRecordsSimultaniouslyOfTableName:(NSString *)tableName withRecord:(NSDictionary *)dict andArray:(NSArray *)arr;
@end
