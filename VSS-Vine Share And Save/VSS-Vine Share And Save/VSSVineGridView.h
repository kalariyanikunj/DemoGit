//
//  VSSVineGridView.h
//  VSS-Vine Share And Save
//
//  Created by Alpesh55 on 12/30/13.
//  Copyright (c) 2013 Creative. All rights reserved.
//
#import "ASIHTTPRequest.h"
#import "MBProgressHUD.h"
#import "JSON.h"
#import <UIKit/UIKit.h>
#import "ZUUIRevealController.h"
#import "VideoData.h"
#import "AsyncImageView.h"
#import "VSSVineDetailView.h"
@interface VSSVineGridView : UIViewController
{
    NSMutableArray *videoDataArray;
    IBOutlet UIScrollView *gridScrollView;
    IBOutlet UIButton *menuButton;
}
-(IBAction)menuButtonClick:(id)sender;
@end
