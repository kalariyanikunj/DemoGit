//
//  VSSAppDelegate.h
//  VSS-Vine Share And Save
//
//  Created by Alpesh55 on 12/30/13.
//  Copyright (c) 2013 Creative. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import "ASIFormDataRequest.h"
#import "JSON.h"
@class RevealController;

@interface VSSAppDelegate : UIResponder <UIApplicationDelegate>
{
    MBProgressHUD *HUD;
}
@property (strong, nonatomic) RevealController *viewController;
@property (strong, nonatomic) UIWindow *window;

@end
