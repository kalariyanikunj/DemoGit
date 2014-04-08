//
//  VSSVineDetailView.m
//  VSS-Vine Share And Save
//
//  Created by Alpesh55 on 12/30/13.
//  Copyright (c) 2013 Creative. All rights reserved.
//

#import "VSSVineDetailView.h"

@interface VSSVineDetailView ()

@end

@implementation VSSVineDetailView
@synthesize videosArray,videoIndex;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.navigationBarHidden=YES;
    [self changeView];
}

-(void)changeView{
    
    VideoData *currentVideo=[videosArray objectAtIndex:videoIndex];
    nameLbl.text=[NSString stringWithFormat:@"%@",currentVideo.username];
    commentCountLbl.text=[NSString stringWithFormat:@"%@",currentVideo.commentCount];
    likeCountLbl.text=[NSString stringWithFormat:@"%@",currentVideo.likesCount];
    timeLbl.text=[NSString stringWithFormat:@"%@",currentVideo.created];
    if (profileImg) {
        profileImg=nil;
        [profileImg removeFromSuperview];
        [profileImg release];
    }
    profileImg = [[AsyncImageView alloc]initWithFrame:profileImgView.bounds];
    profileImg.imageURL=[NSURL URLWithString:[currentVideo.avatarUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    profileImg.layer.masksToBounds = YES;
    profileImg.layer.cornerRadius=35;
    profileImg.layer.borderColor=[[UIColor colorWithWhite:0.2 alpha:0.3] CGColor];
    profileImg.layer.borderWidth=2;

    [profileImgView addSubview:profileImg];
    [profileImg release];
    if (player) {
        [player.view removeFromSuperview];
        [player release];
        
    }
    player =[[MPMoviePlayerController alloc] initWithContentURL:[NSURL URLWithString:currentVideo.videoUrl]];
    player.controlStyle=MPMovieControlStyleNone;
    [player prepareToPlay];
    player.repeatMode=MPMovieRepeatModeOne;
    [player.view setFrame:CGRectMake(10,150,300,275)];  // player's frame must match parent's
    [self.view addSubview: player.view];
    [player play];
}
///posts/<postId>/likes
-(IBAction)likedUnlikedButtonClick:(id)sender
{
    VideoData *currentVideo=[videosArray objectAtIndex:videoIndex];
    NSString *urlStr=[NSString stringWithFormat:@"https://api.vineapp.com/post/%@/likes",currentVideo.postId];
    NSString *sessionID=[[NSUserDefaults standardUserDefaults] objectForKey:@"apikey"];
    NSURL *url = [NSURL URLWithString:urlStr];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request setRequestMethod:@"POST"];
    [request setPostValue:@"Like" forKey:@"model"];
    [request addRequestHeader:@"vine-session-id" value:sessionID];
    [request setTimeOutSeconds:60];
    [request setDelegate:self];
    [request startAsynchronous];
}

-(IBAction)commentButtonClick:(id)sender
{
    
}

-(IBAction)userButtonClick:(id)sender
{
    VideoData *currentVideo=[videosArray objectAtIndex:videoIndex];
    VSSUserProfileViewController *objUserProfile=[[VSSUserProfileViewController alloc]init];
    objUserProfile.userID=currentVideo.userId;
    [self.navigationController pushViewController:objUserProfile animated:YES];
}

- (void)requestStarted:(ASIHTTPRequest *)request
{
    
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    //[HUD hide:YES];
}

- (void)requestFinished:(ASIHTTPRequest *)request
{
//    [videoDataArray removeAllObjects];
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    
//    NSDictionary *tempDict=[[[request responseString] JSONValue] valueForKey:@"data"];
//    NSLog(@"Responce : %@",[request responseString]);
}
- (IBAction)backButtonPressed:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
