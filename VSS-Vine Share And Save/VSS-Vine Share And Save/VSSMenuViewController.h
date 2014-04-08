//
//  VSSMenuViewController.h
//  VSS-Vine Share And Save
//
//  Created by Alpesh55 on 12/30/13.
//  Copyright (c) 2013 Creative. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASIFormDataRequest.h"
#import "MBProgressHUD.h"
#import "JSON.h"
#import "VSSVineGridView.h"
#import "RevealController.h"
@interface VSSMenuViewController : UIViewController<MBProgressHUDDelegate>
{
    MBProgressHUD *HUD;
    NSMutableArray *menuItemArray;
    NSMutableArray *menuIconArray;
    
    IBOutlet UIButton *usernameBtn;
    IBOutlet UITableView *menuTableView;
    ASIFormDataRequest *userLoginRequest;
}

-(IBAction)usernameButtonClick:(id)sender;
-(void)arrangeMenuItem;

@end
