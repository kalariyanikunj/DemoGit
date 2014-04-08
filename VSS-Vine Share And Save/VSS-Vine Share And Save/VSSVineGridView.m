//
//  VSSVineGridView.m
//  VSS-Vine Share And Save
//
//  Created by Alpesh55 on 12/30/13.
//  Copyright (c) 2013 Creative. All rights reserved.
//

#import "VSSVineGridView.h"
#import "MFSideMenu.h"
@interface VSSVineGridView ()

// Private Methods:
- (IBAction)pushExample:(id)sender;
@end

@implementation VSSVineGridView

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void)viewDidAppear:(BOOL)animated{
    
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.navigationBarHidden=YES;
//    if ([self.navigationController.parentViewController respondsToSelector:@selector(revealGesture:)] && [self.navigationController.parentViewController respondsToSelector:@selector(revealToggle:)])
//	{
//		UIPanGestureRecognizer *navigationBarPanGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self.navigationController.parentViewController action:@selector(revealGesture:)];
//		[self.navigationController.navigationBar addGestureRecognizer:navigationBarPanGestureRecognizer];
//		
//		self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Reveal", @"Reveal") style:UIBarButtonItemStylePlain target:self.navigationController.parentViewController action:@selector(revealToggle:)];
//	}
    videoDataArray=[[NSMutableArray alloc]init];
    [self loadDataFromServer];
   
}
-(IBAction)menuButtonClick:(id)sender{
    //[self.navigationController.parentViewController revealToggle:sender];
    [self.menuContainerViewController toggleLeftSideMenuCompletion:^{
       // [self setupMenuBarButtonItems];
    }];

}
- (IBAction)pushExample:(id)sender
{
    UIViewController *stubController = [[UIViewController alloc] init];
    stubController.view.backgroundColor = [UIColor whiteColor];
    [self.navigationController pushViewController:stubController animated:YES];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)loadDataFromServer
{
    NSString *urlStr=[NSString stringWithFormat:@"https://api.vineapp.com/timelines/popular?page=1&size=21"];
    
    NSString *sessionID=[[NSUserDefaults standardUserDefaults] objectForKey:@"apikey"];
    NSURL *url = [NSURL URLWithString:urlStr];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    
    [request addRequestHeader:@"vine-session-id" value:sessionID];
    [request setTimeOutSeconds:60];
    [request setDelegate:self];
    [request startAsynchronous];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
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
    //[videoDataArray removeAllObjects];
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    
    NSDictionary *tempDict=[[[request responseString] JSONValue] valueForKey:@"data"] ;
    NSArray *dataArray=[tempDict valueForKey:@"records"];
    for (NSDictionary *record in dataArray)
    {
        VideoData *objVideo=[[VideoData alloc] init];
        objVideo.avatarUrl=[record valueForKey:@"avatarUrl"];
        objVideo.commentCount=[[record valueForKey:@"comments"] valueForKey:@"count"];
        objVideo.created=[record valueForKey:@"created"];
        objVideo.description=[record valueForKey:@"description"];
        objVideo.likesCount=[[record valueForKey:@"likes"] valueForKey:@"count"];
        objVideo.likesArray=[[record valueForKey:@"likes"] valueForKey:@"records"];
        objVideo.thumbnailUrl=[record valueForKey:@"thumbnailUrl"];
        objVideo.userId=[record valueForKey:@"userId"];
        objVideo.username=[record valueForKey:@"username"];
        objVideo.videoUrl=[record valueForKey:@"videoLowURL"];
        objVideo.postId=[record valueForKey:@"postId"];
        objVideo.shareURL=[record valueForKey:@"shareUrl"];
        objVideo.liked=[record valueForKey:@"liked"];
        [videoDataArray addObject:objVideo];
        [objVideo release];
    }
    [self ArrangeVideoInGridView];
}

-(void)ArrangeVideoInGridView
{
    for (id sender in [gridScrollView subviews])
    {
        if ([sender isKindOfClass:[UIControl class]])
        {
            UIControl *img=(UIControl *)sender;
            [img removeFromSuperview];
        }
    }

    
    float x=10;
    float y=10;
    int rowCount=1;
    for (int i=1;i<=videoDataArray.count;i++)
    {
        VideoData *objVideo=[videoDataArray objectAtIndex:i-1];
        CGRect rect=CGRectMake(x,y,145 , 145);
        UIControl *viewControl=[[UIControl alloc]initWithFrame:rect];
        viewControl.backgroundColor=[UIColor groupTableViewBackgroundColor];
        viewControl.layer.borderWidth=0.5;
        viewControl.layer.borderColor=[[UIColor colorWithWhite:0.1 alpha:0.2] CGColor];
        viewControl.tag=i;
        [viewControl addTarget:self action:@selector(clickOnVideo:) forControlEvents:UIControlEventTouchUpInside];
        [gridScrollView addSubview:viewControl];
    
        AsyncImageView *asyncimageView = [[AsyncImageView alloc]initWithFrame:CGRectMake(5, 5,135,135)];
        asyncimageView.imageURL=[NSURL URLWithString:[objVideo.thumbnailUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        [viewControl addSubview:asyncimageView];
        [asyncimageView release];
        
        UIView *tnView=[[UIView alloc] initWithFrame:CGRectMake(5, 100, 135,40)];
        [tnView setBackgroundColor:[UIColor colorWithWhite:0.1 alpha:0.5]];
        [viewControl addSubview:tnView];
        AsyncImageView *userAvtar = [[AsyncImageView alloc]initWithFrame:CGRectMake(10,102,35,35)];
        userAvtar.imageURL=[NSURL URLWithString:[objVideo.avatarUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        userAvtar.layer.masksToBounds = YES;
        userAvtar.layer.cornerRadius=17;
        userAvtar.layer.borderColor=[[UIColor colorWithWhite:1.0 alpha:0.5] CGColor];
        userAvtar.layer.borderWidth=2;
        [viewControl addSubview:userAvtar];
        [userAvtar release];
        
        UILabel *usernameLbl=[[UILabel alloc]initWithFrame:CGRectMake(50,100,85,20)];
        usernameLbl.text=objVideo.username;
        usernameLbl.textColor=[UIColor whiteColor];
        usernameLbl.font=[UIFont systemFontOfSize:11];
        [viewControl addSubview:usernameLbl];
        [usernameLbl release];
        
        
        
        x=165;
        if (i%2==0) {
            x=10;
            y=y+155;
            rowCount++;
        }
    }
    if (videoDataArray.count%2==0)
    {
        rowCount=videoDataArray.count/2;
    }
   
    [gridScrollView setContentSize:CGSizeMake(320,155*rowCount+10)];
}
-(void)clickOnVideo:(id)sender
{
    NSLog(@"Tag : %i",[sender tag]);
    VSSVineDetailView *vineDetailView=[[VSSVineDetailView alloc]init];
    vineDetailView.videoIndex=[sender tag]-1;
    vineDetailView.videosArray=videoDataArray;
    [self.navigationController pushViewController:vineDetailView animated:YES];
}
@end
