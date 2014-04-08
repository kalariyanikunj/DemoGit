//
//  VSSAppDelegate.m
//  VSS-Vine Share And Save
//
//  Created by Alpesh55 on 12/30/13.
//  Copyright (c) 2013 Creative. All rights reserved.
//
#import "MFSideMenuContainerViewController.h"
#import "VSSAppDelegate.h"
#import "RevealController.h"
#import "VSSMenuViewController.h"
#import "VSSVineGridView.h"
@implementation VSSAppDelegate
@synthesize viewController = _viewController;
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    /*
    UIWindow *window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
	self.window = window;
	
	FrontViewController *frontViewController = [[FrontViewController alloc] init];
	RearViewController *rearViewController = [[RearViewController alloc] init];
	
	UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:frontViewController];
	
	RevealController *revealController = [[RevealController alloc] initWithFrontViewController:navigationController rearViewController:rearViewController];
	self.viewController = revealController;
	
	self.window.rootViewController = self.viewController;
	[self.window makeKeyAndVisible];
	return YES;
     */
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    if (![[NSUserDefaults standardUserDefaults] objectForKey:@"first"])
    {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"first"];
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"isLogin"];
        [[NSUserDefaults standardUserDefaults] setObject:@"vishalvaghasiya.90@gmail.com" forKey:@"email"];
        [[NSUserDefaults standardUserDefaults] setObject:@"12345678" forKey:@"password"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    [self userLogin];
    return YES;
}
-(void)userLogin
{
    NSString *userName=[[NSUserDefaults standardUserDefaults] objectForKey:@"email"];
    NSString *password=[[NSUserDefaults standardUserDefaults] objectForKey:@"password"];
    NSURL *url = [NSURL URLWithString:@"https://api.vineapp.com/users/authenticate"];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request setRequestMethod:@"POST"];
    [request setPostValue:userName forKey:@"username"];
    [request setPostValue:password forKey:@"password"];
    [request setTimeOutSeconds:60];
    [request setDelegate:self];
    [request startAsynchronous];
    
    HUD = [[MBProgressHUD showHUDAddedTo:self.window animated:YES] retain];
   // HUD.delegate = self;
    //HUD.dimBackground=YES;
   // HUD.mode=MBProgressHUDMode;
    HUD.labelText=@"Loading....";
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
    //    NSLog(@"Response %d ==> %@", request.responseStatusCode, [request responseString]);
    NSDictionary *tempDict=[[request responseString] JSONValue];
    NSLog(@"temp dict is : %@",tempDict);
    if ([[tempDict valueForKey:@"success"] intValue]== 1)
    {
        NSDictionary *userDict=[tempDict valueForKey:@"data"];
        [[NSUserDefaults standardUserDefaults] setObject:[userDict valueForKey:@"key"] forKey:@"apikey"];
        [[NSUserDefaults standardUserDefaults] setObject:[userDict valueForKey:@"userId"] forKey:@"userid"];
        [[NSUserDefaults standardUserDefaults] setObject:[userDict valueForKey:@"username"] forKey:@"username"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
//        VSSVineGridView *frontViewController = [[VSSVineGridView alloc] init];
//        VSSMenuViewController *rearViewController = [[VSSMenuViewController alloc] init];
//        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:frontViewController];
//        RevealController *revealController = [[RevealController alloc] initWithFrontViewController:navigationController rearViewController:rearViewController];
//        self.viewController = revealController;
//        self.window.rootViewController = self.viewController;
//        // Override point for customization after application launch.
        
        
        self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
        
        VSSMenuViewController *leftViewController = [[VSSMenuViewController alloc] init];
        VSSMenuViewController *rightViewController = [[VSSMenuViewController alloc] init];
        
        MFSideMenuContainerViewController *container = [MFSideMenuContainerViewController
                                                        containerWithCenterViewController:[self navigationController]
                                                        leftMenuViewController:leftViewController
                                                        rightMenuViewController:rightViewController];
        self.window.rootViewController = container;
        [self.window makeKeyAndVisible];
        

        
    }
    else
    {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Error" message:[tempDict valueForKey:@"error"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
    }
    [HUD hide:YES];
    
}
- (VSSVineGridView *)demoController {
    return [[VSSVineGridView alloc] initWithNibName:@"VSSVineGridView" bundle:nil];
}

- (UINavigationController *)navigationController {
    return [[UINavigationController alloc]
            initWithRootViewController:[self demoController]];
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
