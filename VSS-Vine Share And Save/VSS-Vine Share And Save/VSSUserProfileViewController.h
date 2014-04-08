//
//  VSSUserProfileViewController.h
//  VSS-Vine Share And Save
//
//  Created by Alpesh55 on 1/13/14.
//  Copyright (c) 2014 Creative. All rights reserved.
//
#import "FollowersViewController.h"
#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import "ASIHTTPRequest.h"
#import "JSON.h"
#import "AsyncImageView.h"
@interface VSSUserProfileViewController : UIViewController
{
    IBOutlet UIButton *followers_btn;
    IBOutlet UIButton *following_btn;
    IBOutlet UIButton *posts_btn;
    
    IBOutlet UILabel *username_lbl;
    IBOutlet UILabel *userdesc_lbl;
}
@property (nonatomic,retain)NSString *userID;
-(IBAction)backButtonPressed:(id)sender;
-(IBAction)FollowerButtonClick:(id)sender;
-(IBAction)FollowingButtonClick:(id)sender;
-(IBAction)PostButtonClick:(id)sender;
@end
