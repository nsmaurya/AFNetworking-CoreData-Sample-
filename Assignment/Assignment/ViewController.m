//
//  ViewController.m
//  Assignment
//
//  Created by Sunil Maurya on 9/29/15.
//  Copyright © 2015 CodeBrew. All rights reserved.
//

#import "ViewController.h"
#import "Service.h"
#import "AppHelper.h"
#import "Defines.h"
#import "AppDelegate.h"
#import "UIImageView+AFNetworking.h"
#import "Utility.h"
@interface ViewController ()<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>
{
    NSMutableArray *arrInfo;
}
@end

@implementation ViewController
//MARK:- View Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    arrInfo = [[NSMutableArray alloc] init];
    [self.tableView setTableFooterView:[[UIView alloc]initWithFrame:CGRectZero]];
    [self getLocDetailsService];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//MARK:- Table View DataSource/Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return arrInfo.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DetailCell" forIndexPath:indexPath];
    cell.backgroundColor=[UIColor clearColor];
    cell.contentView.backgroundColor=[UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSDictionary *dict = [arrInfo objectAtIndex:indexPath.row];
    if(dict)
    {
        //setting image
        __weak UIImageView *imgV = (UIImageView *)[cell.contentView viewWithTag:1001];
        if([dict valueForKey:@"g_img_1_200_image"])
        {
            imgV.image = [UIImage imageWithData:[dict valueForKey:@"g_img_1_200_image"]];
        }
        else
        {
            imgV.image = [UIImage imageNamed:@"placeholder.png"];
            if([dict valueForKey:@"g_img_1_200"])
            {
                NSURL *imgURL=[NSURL URLWithString:[dict valueForKey:@"g_img_1_200"]];
                [imgV setImageWithURLRequest:[NSURLRequest requestWithURL:imgURL] placeholderImage:nil
                                     success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                         if(image)
                                         {
                                             imgV.image=image;
                                         }
                                         else
                                             imgV.image=[UIImage imageNamed:@"placeholder.png"];
                                         
                                     } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error){
                                         
                                         imgV.image=[UIImage imageNamed:@"placeholder.png"];
                                     }];
            }
        }
        
        //setting address
        UILabel *lblAddress=(UILabel *)[cell.contentView viewWithTag:1002];
        if([dict valueForKey:@"address"])
            lblAddress.text = [dict valueForKey:@"address"];
        //setting location
        UILabel *lblLocation=(UILabel *)[cell.contentView viewWithTag:1003];
        if([dict valueForKey:@"location"])
            lblLocation.text = [dict valueForKey:@"location"];
        //setting distance
        UILabel *lblDistance=(UILabel *)[cell.contentView viewWithTag:1004];
        if([dict valueForKey:@"distance"])
            lblDistance.text = [dict valueForKey:@"distance"];
    }
    
    return cell;
}
//MARK:- Hit service
-(void) getLocDetailsService
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [[AppDelegate getAppDelegate] showActivityViewer:@"Loading"];
    });
    
    NSLog(@"sunilhere..");
    if ([[AppDelegate getAppDelegate] checkInternetConnection])
    {
        //http://52.24.182.54/apiV2/feeds_mixed_raju.php?lat=30.7500&lng=76.7800
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getLocDetailsServiceResponse:) name:Notification_GetDetails object:nil];
        NSMutableDictionary *dictParams = [[NSMutableDictionary alloc]init];
        [dictParams setValue:@"30.7500" forKey:@"lat"];
        [dictParams setValue:@"76.7800" forKey:@"lng"];
        [dictParams setValue:@"feeds_mixed_raju.php" forKey:@"method"];
        [[Service sharedInstance]getLocationDetails:dictParams];
    }
    else
    {
        //hide activity indicator
        [[AppDelegate getAppDelegate]hideActivityViewer];
        [[NSNotificationCenter defaultCenter] removeObserver:self name:Notification_GetDetails object:nil];
        [AppHelper showAlertViewWithTag:1 title:APP_NAME message:ERROR_INTERNET delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    }
}
//MARK:- Service response
-(void)getLocDetailsServiceResponse:(NSNotification*)note
{
    [[AppDelegate getAppDelegate]hideActivityViewer];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:Notification_GetDetails object:nil];
    if (note.userInfo)
    {
        if ([[[note userInfo] valueForKey:@"success"]intValue]== 1)
        {
            arrInfo = [[note userInfo]valueForKey:@"data"];
            [self.tableView reloadData];
            if(arrInfo.count == 0)
            {
                [AppHelper showAlertViewWithTag:0 title:APP_NAME message:@"No record found." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            }
            else
            {
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
                    NSLog(@"sunil1...");
                    if([[Utility getUtilityObject] isDataAvailableInTable:@"LocationDetails" forPredicate:nil])
                    {
                        NSLog(@"sunil12...");
                        dispatch_async(dispatch_get_main_queue(), ^{
                            
                            [AppHelper showAlertViewWithTag:3 title:APP_NAME message:@"You have latest data, do you want to refresh local data?" delegate:self cancelButtonTitle:@"Yes" otherButtonTitles:@"No"];
                        });
                        
                    }
                    else
                    {
                        NSLog(@"sunil11...");
                        [self storingAllLocationDetailsInCoreDB:NO];
                    }
                });
            }
            
        }
    }
}

//MARK:- Get local DB data to load
-(void) getAllLocalDataFromLocationDetailsTable
{
    [arrInfo addObjectsFromArray:[[Utility getUtilityObject] getAllDataFromTable:@"LocationDetails" forPredicate:nil withDescriptor:nil]];
    if(arrInfo.count == 0)
        [AppHelper showAlertViewWithTag:0 title:APP_NAME message:@"No record found." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    else
    {
        [self.tableView reloadData];
    }
}
//MARK:- AlertView delegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView.tag == 1)
    {
        //if no internet available
        [self showConfirmationMessageForShowingLocalData];
    }
    else if(alertView.tag == 2)
    {
        if(buttonIndex == 0)
        {
            //load local db data
            [self getAllLocalDataFromLocationDetailsTable];
        }
    }
    else if(alertView.tag == 3)
    {
        if(buttonIndex == 0)
        {
            //load local db data
            [self storingAllLocationDetailsInCoreDB:YES];
        }
    }
}
-(void) showConfirmationMessageForShowingLocalData
{
    [AppHelper showAlertViewWithTag:2 title:APP_NAME message:@"Do you want to load local DB data?" delegate:self cancelButtonTitle:@"Yes" otherButtonTitles:@"No"];
}

//MARK:- Local DB updates with latest data
-(void) storingAllLocationDetailsInCoreDB:(BOOL) isDeletePrevData
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        
        if(isDeletePrevData)
        {
            [[Utility getUtilityObject] deleteAllRecordsFromTable:@"LocationDetails"];
        }
        Utility *ut = [Utility getUtilityObject];
        for(NSDictionary *dict in arrInfo)
        {
            [ut insertData:dict inTable:@"LocationDetails" withArray:nil];
            NSLog(@"sunil4...");
        }
    });
}


@end
