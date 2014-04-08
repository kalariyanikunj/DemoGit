//
//  FollowersViewController.m
//  VineApp
//
//  Created by Alpesh55 on 11/30/13.
//  Copyright (c) 2013 Creative Infoway. All rights reserved.
//

#import "FollowersViewController.h"

@interface FollowersViewController ()

@end
int pageNumber=1;
@implementation FollowersViewController
@synthesize userId;
@synthesize titleStr;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(IBAction)backButtonClick:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [userTableView setBackgroundColor:[UIColor clearColor]];
    titleLbl.text=titleStr;
    pageNumber=1;
    userArray=[[NSMutableArray alloc]init];
    app=[[UIApplication sharedApplication]delegate];
    [self loadData:@"1"];
    
}
-(void)loadData:(NSString *)page1
{
    NSString *urlStr;
    
    if ([titleStr isEqualToString:@"Likes"]) {
        urlStr=[NSString stringWithFormat:@"https://api.vineapp.com/posts/%@/likes?page=%i&size=50",userId,pageNumber];
    }
    else if([titleStr isEqualToString:@"Followers"])
    {
        urlStr=[NSString stringWithFormat:@"https://api.vineapp.com/users/%@/followers?page=%i&size=50",userId,pageNumber];
    }
    else{
        urlStr=[NSString stringWithFormat:@"https://api.vineapp.com/users/%@/following?page=%i&size=50",userId,pageNumber];
    }
    
    NSLog(@"URL Str : %@",urlStr);
    
    NSURL *url = [NSURL URLWithString:urlStr];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    //[request setRequestMethod:@"GET"];
    NSString *sessionID=[[NSUserDefaults standardUserDefaults] objectForKey:@"apikey"];
    [request addRequestHeader:@"vine-session-id" value:sessionID];
    [request setTimeOutSeconds:60];
    [request setDelegate:self];
    [request startAsynchronous];
    if (pageNumber==1) {
        HUD = [[MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES] retain];
        HUD.delegate = self;
        HUD.dimBackground=YES;
        //HUD.mode=MBProgressHUDModeAnnularDeterminate;
        HUD.labelText=@"Loading....";
    }
    
    
}

- (void)requestStarted:(ASIHTTPRequest *)request
{
    
}
- (void)requestFailed:(ASIHTTPRequest *)request
{
    [HUD hide:YES];
}
- (void)requestFinished:(ASIHTTPRequest *)request
{
    [HUD hide:YES];
    NSDictionary *tempDict=[[[request responseString] JSONValue] valueForKey:@"data"] ;
    
    if (![[tempDict valueForKey:@"nextPage"] isKindOfClass:[NSNull class]])
    {
        pageNumber=[[tempDict valueForKey:@"nextPage"] intValue];
    }
    else
    {
        pageNumber=0;
    }
    NSArray *dataArray=[tempDict valueForKey:@"records"];

    
    for (NSDictionary *dict in dataArray) {
        UserClass *objUser=[[UserClass alloc]init];
        objUser.userName=[dict objectForKey:@"username"];
        objUser.userId=[dict objectForKey:@"userId"];
        objUser.userImage=[dict objectForKey:@"avatarUrl"];
        [userArray addObject:objUser];
    }
    [userTableView reloadData];

}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    //#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    NSLog(@"Count : %i",userArray.count);
    return userArray.count+1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"UsersCell";
    UILabel *nameLabel;
    //UILabel *dateLabel;
    //UILabel *fullNameLabel;
    AsyncImageView *userImage;
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell ==nil) {
        cell = [[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier]autorelease];
        userImage = [[AsyncImageView alloc]initWithFrame:CGRectMake(5, 5, 50, 50)];
        //userImage.imageURL = [NSURL URLWithString:objUser.userImage];
        userImage.layer.cornerRadius =25.0;
        userImage.clipsToBounds = YES;
        userImage.tag = 1;
        [cell.contentView addSubview:userImage];
        [userImage release];
        
        nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(60.0, 5, 250.0, 50)];
        nameLabel.font=[UIFont boldSystemFontOfSize:14.0];
        nameLabel.backgroundColor=[UIColor clearColor];
        nameLabel.tag = 2;
        [cell.contentView addSubview:nameLabel];
        [nameLabel release];
    }
    else{
        userImage = (AsyncImageView*)[cell.contentView viewWithTag:1];
        userImage.image = nil;
    }
    
    if (indexPath.row==[userArray count]) {
        nameLabel = (UILabel *)[cell.contentView viewWithTag:2];
        if (pageNumber==0) {
            nameLabel.text=@" ";
        }
        else{
            nameLabel.text = @"Load More..";
        }
        userImage = (AsyncImageView*)[cell.contentView viewWithTag:1];
        userImage.image = nil;
        
        return cell;
    }
    //InstagramUser *aUser  = [_totalUsers objectAtIndex:indexPath.row];
    
    UserClass *objUser;
    //if (userArray.count>0)
    {
        objUser=[userArray objectAtIndex:indexPath.row];
    }
    userImage = (AsyncImageView*)[cell.contentView viewWithTag:1];
    userImage.imageURL = [NSURL URLWithString:objUser.userImage];
    
    nameLabel = (UILabel *)[cell.contentView viewWithTag:2];
    nameLabel.text = objUser.userName;
    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    cell.backgroundColor=[UIColor clearColor];
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==[userArray count]) {
        
        if (pageNumber!=0) {
            [self loadData:@"1"];
        }
        
        return;
    }
    
    UserClass *objUser=[userArray objectAtIndex:indexPath.row];
    VSSUserProfileViewController *objProfileView=[[VSSUserProfileViewController alloc] init];
    objProfileView.userID=objUser.userId;
    [self.navigationController pushViewController:objProfileView animated:YES];
}

-(void)dealloc
{
    [super dealloc];
    [userArray release];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}

@end
