//
//  VSSVineDetailView.h
//  VSS-Vine Share And Save
//
//  Created by Alpesh55 on 12/30/13.
//  Copyright (c) 2013 Creative. All rights reserved.
//
#import <MediaPlayer/MediaPlayer.h>
#import <UIKit/UIKit.h>
#import "AsyncImageView.h"
#import "MBProgressHUD.h"
#import "VideoData.h"
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
#import "VSSUserProfileViewController.h"
#import "JSON.h"
@interface VSSVineDetailView : UIViewController
{
    AsyncImageView *profileImg;
    IBOutlet UIView *profileImgView;
    MPMoviePlayerController *player;
    
    IBOutlet UILabel *likeCountLbl;
    IBOutlet UIButton *likeBtn;
    IBOutlet UIButton *commentBtn;
    IBOutlet UILabel *commentCountLbl;
    IBOutlet UILabel *nameLbl;
    IBOutlet UILabel *timeLbl;
}
@property (nonatomic)int videoIndex;
@property (nonatomic,retain)NSArray *videosArray;
-(IBAction)likedUnlikedButtonClick:(id)sender;
-(IBAction)commentButtonClick:(id)sender;
-(IBAction)backButtonPressed:(id)sender;
-(IBAction)userButtonClick:(id)sender;
@end
