//
//  VSSUserProfileViewController.m
//  VSS-Vine Share And Save
//
//  Created by Alpesh55 on 1/13/14.
//  Copyright (c) 2014 Creative. All rights reserved.
//

#import "VSSUserProfileViewController.h"

@interface VSSUserProfileViewController ()

@end

@implementation VSSUserProfileViewController
@synthesize userID;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewDidAppear:(BOOL)animated{
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://api.vineapp.com/users/profiles/%@",userID]];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    //[request setRequestMethod:@"GET"];
    NSString *apiKey=[[NSUserDefaults standardUserDefaults] objectForKey:@"apikey"];
    [request addRequestHeader:@"vine-session-id" value:apiKey];
    [request setTimeOutSeconds:60];
    [request setDelegate:self];
    [request startAsynchronous];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)requestStarted:(ASIHTTPRequest *)request
{
    
}
- (void)requestFailed:(ASIHTTPRequest *)request
{
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
}
- (void)requestFinished:(ASIHTTPRequest *)request
{
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    NSDictionary *tempDict=[[[request responseString] JSONValue] objectForKey:@"data"];
    NSLog(@"Dict : %@",tempDict);
    AsyncImageView *profileImg = [[AsyncImageView alloc]initWithFrame:CGRectMake(112, 63,96,96)];
    profileImg.layer.masksToBounds = YES;
    profileImg.layer.cornerRadius=48;
    profileImg.imageURL=[NSURL URLWithString:[[tempDict objectForKey:@"avatarUrl"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    [self.view addSubview:profileImg];
    [profileImg release];
    
    [followers_btn setTitle:[NSString stringWithFormat:@"%@",[tempDict objectForKey:@"followerCount"]] forState:UIControlStateNormal];
    [following_btn setTitle:[NSString stringWithFormat:@"%@",[tempDict objectForKey:@"followingCount"]] forState:UIControlStateNormal];
    [posts_btn setTitle:[NSString stringWithFormat:@"%@",[tempDict objectForKey:@"postCount"]] forState:UIControlStateNormal];
    
    username_lbl.text=[tempDict objectForKey:@"username"];
    
//    usernameLbl.text=[tempDict objectForKey:@"username"];
//    emailLbl.text=[tempDict objectForKey:@"email"];
    if (![[tempDict objectForKey:@"description"] isKindOfClass:[NSNull class]]) {
        userdesc_lbl.text=[tempDict objectForKey:@"description"];
    }
//
//    if (![[tempDict objectForKey:@"location"] isKindOfClass:[NSNull class]]) {
//        userLocation.text=[tempDict objectForKey:@"location"];
//    }
    
//    followerLbl.text=[NSString stringWithFormat:@"Followed By %@ people",[tempDict objectForKey:@"followerCount"]];
//    followingLbl.text=[NSString stringWithFormat:@"Follows %@ people",[tempDict objectForKey:@"followingCount"]];
//    postLbl.text=[NSString stringWithFormat:@"Videos %@",[tempDict objectForKey:@"postCount"]];
//    
//    [followingLbl setTextColor:[UIColor orangeColor]];
//    [followingLbl setFont:[UIFont boldSystemFontOfSize:18]];
//    [followingLbl setTextColor:[UIColor darkGrayColor] range:NSMakeRange(0, 7)];
//    [followingLbl setFont:[UIFont systemFontOfSize:18] range:NSMakeRange(0, 7)];
//    [followingLbl setTextColor:[UIColor darkGrayColor] range:NSMakeRange(followingLbl.text.length-6, 6)];
//    [followingLbl setFont:[UIFont systemFontOfSize:18] range:NSMakeRange(followingLbl.text.length-6, 6)];
    
    
//    [followerLbl  setTextColor:[UIColor orangeColor]];
//    [followerLbl setTextColor:[UIColor darkGrayColor] range:NSMakeRange(0, 11)];
//    [followerLbl setTextColor:[UIColor darkGrayColor] range:NSMakeRange(followerLbl.text.length-6, 6)];
//    [followerLbl setFont:[UIFont boldSystemFontOfSize:18]];
//    [followerLbl setFont:[UIFont systemFontOfSize:18] range:NSMakeRange(0, 11)];
//    [followerLbl setFont:[UIFont systemFontOfSize:18] range:NSMakeRange(followerLbl.text.length-6, 6)];
    
    //[postLbl setTextColor:[UIColor orangeColor]];
//    [postLbl  setTextColor:[UIColor orangeColor]];
//    [postLbl setFont:[UIFont boldSystemFontOfSize:18]];
//    [postLbl setFont:[UIFont systemFontOfSize:18] range:NSMakeRange(0, 6)];
//    [postLbl setTextColor:[UIColor darkGrayColor] range:NSMakeRange(0, 6)];
    
}

-(IBAction)FollowerButtonClick:(id)sender
{
    FollowersViewController *objFollowerView=[[[FollowersViewController alloc]init] autorelease];
    objFollowerView.userId=self.userID;
    objFollowerView.titleStr=@"Followers";
    [self.navigationController pushViewController:objFollowerView animated:YES];
    
}
-(IBAction)FollowingButtonClick:(id)sender
{
    FollowersViewController *objFollowerView=[[[FollowersViewController alloc]init] autorelease];
    objFollowerView.userId=self.userID;
    objFollowerView.titleStr=@"Following";
    [self.navigationController pushViewController:objFollowerView animated:YES];
}
-(IBAction)PostButtonClick:(id)sender
{
//    NSLog(@"USER ID : %@",self.userID);
//    VineListingController *objVineListing=[[VineListingController alloc]init];
//    
//    objVineListing.title=usernameLbl.text;
//    objVineListing.idString=[NSString stringWithFormat:@"%@",userID];//@"123";
//    objVineListing.user_id=[NSString stringWithFormat:@"%@",userID];
//    
//    [self.navigationController pushViewController:objVineListing animated:YES];
}

-(IBAction)backButtonPressed:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
