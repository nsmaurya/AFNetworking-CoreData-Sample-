//
//  Utility.m
//
//  Created by Sunil Maurya on 9/29/15.
//  Copyright © 2015 CodeBrew. All rights reserved.
//

#import "Utility.h"
#import "AppDelegate.h"
#import "LocationDetails+CoreDataProperties.h"
#import "LocationDetails.h"
#import "AppHelper.h"
#import "Defines.h"
@implementation Utility
@synthesize _managedObjectContext=managedObjectContext;
@synthesize _managedObject=managedObject;
-(id) init
{
    self=[super init];
    if(self)
    {
        self._managedObjectContext=[[AppDelegate getAppDelegate] managedObjectContext];
        self._managedObject=nil;
    }
    return self;
}
//MARK:- Retrieve Singleton Object
+(Utility *) getUtilityObject
{
    static Utility *singleton=nil;
    if(!singleton)
    {
        singleton=[[Utility alloc]init];
    }
    return singleton;
}
-(NSManagedObject *)getManagedObject
{
    return self._managedObject;
}
#pragma mark - Core Data Operation
#pragma mark -
-(NSEntityDescription *) getEntityDescription:(NSString *)tableName
{
    NSEntityDescription *entity = [NSEntityDescription entityForName:tableName inManagedObjectContext:self._managedObjectContext];
    return entity;
}

-(BOOL) insertData:(NSDictionary *)dictionary inTable:(NSString *)tableName withArray:(NSArray *)array
{
    if([tableName isEqualToString:@"LocationDetails"])
    {
                //new entry
        LocationDetails *newEntry = [[LocationDetails alloc] initWithEntity:[self getEntityDescription:tableName] insertIntoManagedObjectContext:self._managedObjectContext];
        
        if([dictionary valueForKey:@"address"])
            [newEntry setValue:[dictionary valueForKey:@"address"] forKey:@"address"];
        if([dictionary valueForKey:@"location"])
            [newEntry setValue:[dictionary valueForKey:@"location"] forKey:@"location"];
        if([dictionary valueForKey:@"distance"])
            [newEntry setValue:[dictionary valueForKey:@"distance"] forKey:@"distance"];
        if([dictionary valueForKey:@"g_img_1_200"])
        {
            [newEntry setValue:[dictionary valueForKey:@"g_img_1_200"] forKey:@"g_img_1_200"];
            if(![[dictionary valueForKey:@"g_img_1_200"] isEqualToString:@""])
            {
                NSData * data = [NSData dataWithContentsOfURL:[NSURL URLWithString:[dictionary objectForKey:@"g_img_1_200"]]];
                if(data)
                   [newEntry setValue:data forKey:@"g_img_1_200_image"];
            }
        }
    }
    NSError *error=nil;
    if (![self._managedObjectContext save:&error]) {
        NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
        return FALSE;
    }
    return TRUE;
}

-(BOOL) isDataAvailableInTable:(NSString *) tableName forPredicate:(NSPredicate *)predicate
{
    // initializing NSFetchRequest
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    if(predicate!=nil)
    {
        fetchRequest.predicate=predicate;
    }
    fetchRequest.fetchLimit = 1;
    
    //Setting Entity to be Queried
    NSEntityDescription *entity = [self getEntityDescription:tableName];
    [fetchRequest setEntity:entity];
    NSError* error;
    
    // Query on managedObjectContext With Generated fetchRequest
    NSArray *fetchedRecords = [self._managedObjectContext executeFetchRequest:fetchRequest error:&error];
    if(error)
    {
        NSLog(@"Error: %@",error);
        return FALSE;
    }
    else
    {
        if(fetchedRecords!=nil)
        {
            if(fetchedRecords.count>0)
            {
                self._managedObject=(NSManagedObject *)[fetchedRecords objectAtIndex:0];
                return TRUE;
            }
        }
    }
    
    return FALSE;
}
-(NSArray *) getAllDataFromTable:(NSString *) tableName forPredicate:(NSPredicate *) predicate withDescriptor:(NSArray *)sortDescriptors
{
    // initializing NSFetchRequest
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    if(predicate!=nil)
    {
        fetchRequest.predicate=predicate;
    }
    if(sortDescriptors!=nil)
    {
        [fetchRequest setSortDescriptors:sortDescriptors];
    }
    //Setting Entity to be Queried
    NSEntityDescription *entity = [self getEntityDescription:tableName];
    [fetchRequest setEntity:entity];
    NSError* error;
    
    // Query on managedObjectContext With Generated fetchRequest
    NSArray *fetchedRecords = [self._managedObjectContext executeFetchRequest:fetchRequest error:&error];
    if(self._managedObject==nil)
    {
        if(fetchedRecords.count>0)
            self._managedObject=(NSManagedObject *)[fetchedRecords objectAtIndex:0];
    }
    // Returning Fetched Records
    return fetchedRecords;
}

-(BOOL) deleteRecordsFromTable:(NSString *)tableName withRecord:(NSManagedObject *)managedObj
{
    NSError* error;
    [self._managedObjectContext deleteObject:managedObj];
    if (![self._managedObjectContext save:&error]) {
        NSLog(@"Whoops, couldn't delete: %@", [error localizedDescription]);
        return FALSE;
    }
    return TRUE;
}
-(BOOL) updateRecordsFromTable:(NSString *)tableName withRecord:(NSDictionary *)dictionary andArray:(NSArray *) arrDetails onObject:(NSManagedObject *)managedObj
{
    if([tableName isEqualToString:@"User_User_Contacts"] && dictionary!=nil)
    {
        //LocationDetails *updateEntry = (LocationDetails *)managedObj;
    }
    NSError *error=nil;
    if (![self._managedObjectContext save:&error])
    {
        NSLog(@"Whoops, couldn't update: %@", [error localizedDescription]);
        return FALSE;
    }
    return TRUE;
}

-(NSNumber *) getMaxID:(NSString *)tableName
{
    //getting max annotation id from core-data
    BOOL flag=[self isDataAvailableInTable:tableName forPredicate:nil];
    NSInteger ID=0;
    if(flag)
    {
        //getting last id & assign it to ID
    }
    ID++;
    
    return [NSNumber numberWithInteger:ID];
}

-(BOOL) deleteAllRecordsFromTable:(NSString *)tableName
{
    NSArray *arr=[self getAllDataFromTable:tableName forPredicate:nil withDescriptor:nil];
    for(NSManagedObject *managedObj in arr)
    {
        [self._managedObjectContext deleteObject:managedObj];
    }
    NSError* error;
    if (![self._managedObjectContext save:&error]) {
        NSLog(@"Whoops, couldn't delete: %@", [error localizedDescription]);
        return FALSE;
    }
    return TRUE;
}

-(void) updateMutilpleRecordsSimultaniouslyOfTableName:(NSString *)tableName withRecord:(NSDictionary *)dict andArray:(NSArray *)arr
{
    
}

@end
