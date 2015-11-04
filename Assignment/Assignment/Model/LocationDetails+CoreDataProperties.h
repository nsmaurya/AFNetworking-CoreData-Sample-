//
//  LocationDetails+CoreDataProperties.h
//  Assignment
//
//  Created by Sunil Maurya on 9/30/15.
//  Copyright © 2015 CodeBrew. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "LocationDetails.h"

NS_ASSUME_NONNULL_BEGIN

@interface LocationDetails (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *address;
@property (nullable, nonatomic, retain) NSString *location;
@property (nullable, nonatomic, retain) NSString *distance;
@property (nullable, nonatomic, retain) NSData *g_img_1_200_image;
@property (nullable, nonatomic, retain) NSString *g_img_1_200;

@end

NS_ASSUME_NONNULL_END
