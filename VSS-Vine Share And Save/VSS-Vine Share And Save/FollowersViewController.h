//
//  FollowersViewController.h
//  VineApp
//
//  Created by Alpesh55 on 11/30/13.
//  Copyright (c) 2013 Creative Infoway. All rights reserved.
//
#import "VSSUserProfileViewController.h"
#import "JSON.h"
#import <UIKit/UIKit.h>
#import "VSSAppDelegate.h"
#import "MBProgressHUD.h"
#import "ASIHTTPRequest.h"
#import "UserClass.h"
#import "AsyncImageView.h"
@interface FollowersViewController : UIViewController<MBProgressHUDDelegate>
{
    MBProgressHUD *HUD;
    VSSAppDelegate *app;
    NSMutableArray *userArray;
    IBOutlet UITableView *userTableView;
    
    IBOutlet UILabel *titleLbl;
}
@property (nonatomic,retain)NSString *userId;
@property (nonatomic,retain)NSString *titleStr;
-(IBAction)backButtonClick:(id)sender;
@end
