//
//  VSSMenuViewController.m
//  VSS-Vine Share And Save
//
//  Created by Alpesh55 on 12/30/13.
//  Copyright (c) 2013 Creative. All rights reserved.
//

#import "VSSMenuViewController.h"
#import "MFSideMenu.h"
@interface VSSMenuViewController ()

@end

@implementation VSSMenuViewController

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
    menuItemArray=[[NSMutableArray alloc]init];
    menuIconArray=[[NSMutableArray alloc]init];
    [self arrangeMenuItem];
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
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
}

-(IBAction)usernameButtonClick:(id)sender
{
    UIButton *btn=(UIButton *)sender;
    if ([[btn currentTitle] isEqualToString:@"Click here for login"])
    {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Login with Vine User" message:nil delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Login", nil];
        alert.alertViewStyle=UIAlertViewStyleLoginAndPasswordInput;
        alert.tag=10;
        [alert show];
        [alert release];
    }
    else{
        
    }
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
    NSDictionary *tempDict=[[request responseString] JSONValue];
    NSLog(@"temp dict is : %@",tempDict);
    if ([[tempDict valueForKey:@"success"] intValue]== 1)
    {
        NSDictionary *userDict=[tempDict valueForKey:@"data"];
        if (request==userLoginRequest) {
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isLogin"];
        }
        [[NSUserDefaults standardUserDefaults] setObject:[userDict valueForKey:@"key"] forKey:@"apikey"];
        [[NSUserDefaults standardUserDefaults] setObject:[userDict valueForKey:@"userId"] forKey:@"userid"];
        [[NSUserDefaults standardUserDefaults] setObject:[userDict valueForKey:@"username"] forKey:@"username"];
        
    }
    else
    {
        [[NSUserDefaults standardUserDefaults] setObject:@"vishalvaghasiya.90@gmail.com" forKey:@"email"];
        [[NSUserDefaults standardUserDefaults] setObject:@"12345678" forKey:@"password"];
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Error" message:[tempDict valueForKey:@"error"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
    }
    [self arrangeMenuItem];
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    //[HUD hide:YES];
}

-(void)arrangeMenuItem
{
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"isLogin"])
    {
        [usernameBtn setTitle:[[NSUserDefaults standardUserDefaults] valueForKey:@"username"] forState:UIControlStateNormal];
        [menuItemArray removeAllObjects];
        [menuIconArray removeAllObjects];
        
        [menuItemArray addObject:@"Feed"];
        [menuIconArray addObject:@"feed_icon"];
        [menuItemArray addObject:@"Popular"];
        [menuIconArray addObject:@"popular_icon"];
        [menuItemArray addObject:@"Promoted"];
        [menuIconArray addObject:@"promoted_icon"];
        [menuItemArray addObject:@"Setting"];
        [menuIconArray addObject:@"setting_icon"];
        [menuItemArray addObject:@"Sign Out"];
        [menuIconArray addObject:@"signout_icon"];

    }
    else{
        [usernameBtn setTitle:@"Click here for login" forState:UIControlStateNormal];
        [menuItemArray removeAllObjects];
        [menuIconArray removeAllObjects];
        
        [menuItemArray addObject:@"Popular"];
        [menuIconArray addObject:@"popular_icon"];
        [menuItemArray addObject:@"Promoted"];
        [menuIconArray addObject:@"promoted_icon"];
        [menuItemArray addObject:@"Setting"];
        [menuIconArray addObject:@"setting_icon"];
    }
    CGRect rect=menuTableView.frame;
    rect.size.height=menuItemArray.count * 45;
    menuTableView.frame=rect;
    [menuTableView reloadData];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 45.0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return menuItemArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"UsersCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell ==nil)
    {
        cell = [[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier]autorelease];
    
    }
    if (indexPath.row==0) {
        cell.backgroundView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"cell1.png"]];
        cell.selectedBackgroundView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"cell1_selected.png"]];
    }
    else{
        cell.backgroundView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"cell2.png"]];
        cell.selectedBackgroundView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"cell2_selected.png"]];
    }
    cell.textLabel.text=[menuItemArray objectAtIndex:indexPath.row];
    cell.textLabel.textColor=[UIColor whiteColor];
    cell.imageView.image=[UIImage imageNamed:[menuIconArray objectAtIndex:indexPath.row]];
   // cell.backgroundView=
    cell.backgroundColor=[UIColor clearColor];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"isLogin"])
    {
        
        
        if (indexPath.row == 0)
        {
            VSSVineGridView *demoController = [[VSSVineGridView alloc] initWithNibName:@"VSSVineGridView" bundle:nil];
            demoController.title = [NSString stringWithFormat:@"Demo #%d-%d", indexPath.section, indexPath.row];
            
            UINavigationController *navigationController = self.menuContainerViewController.centerViewController;
            NSArray *controllers = [NSArray arrayWithObject:demoController];
            navigationController.viewControllers = controllers;
            [self.menuContainerViewController setMenuState:MFSideMenuStateClosed];
        }
        else if (indexPath.row == 1)
        {
            VSSVineGridView *demoController = [[VSSVineGridView alloc] initWithNibName:@"VSSVineGridView" bundle:nil];
            demoController.title = [NSString stringWithFormat:@"Demo #%d-%d", indexPath.section, indexPath.row];
            
            UINavigationController *navigationController = self.menuContainerViewController.centerViewController;
            NSArray *controllers = [NSArray arrayWithObject:demoController];
            navigationController.viewControllers = controllers;
            [self.menuContainerViewController setMenuState:MFSideMenuStateClosed];
        }

        
        
        
    }
    else{
        
        if (indexPath.row == 0)
        {
            VSSVineGridView *demoController = [[VSSVineGridView alloc] initWithNibName:@"VSSVineGridView" bundle:nil];
            demoController.title = [NSString stringWithFormat:@"Demo #%d-%d", indexPath.section, indexPath.row];
            
            UINavigationController *navigationController = self.menuContainerViewController.centerViewController;
            NSArray *controllers = [NSArray arrayWithObject:demoController];
            navigationController.viewControllers = controllers;
            [self.menuContainerViewController setMenuState:MFSideMenuStateClosed];
        }
        else if (indexPath.row == 1)
        {
            VSSVineGridView *demoController = [[VSSVineGridView alloc] initWithNibName:@"VSSVineGridView" bundle:nil];
            demoController.title = [NSString stringWithFormat:@"Demo #%d-%d", indexPath.section, indexPath.row];
            
            UINavigationController *navigationController = self.menuContainerViewController.centerViewController;
            NSArray *controllers = [NSArray arrayWithObject:demoController];
            navigationController.viewControllers = controllers;
            [self.menuContainerViewController setMenuState:MFSideMenuStateClosed];
        }
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag==11 && buttonIndex==1)
    {
        //[[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"back"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"isLogin"];
        [[NSUserDefaults standardUserDefaults] setObject:@"vishalvaghasiya.90@gmail.com" forKey:@"email"];
        [[NSUserDefaults standardUserDefaults] setObject:@"12345678" forKey:@"password"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        NSURL *url = [NSURL URLWithString:@"https://api.vineapp.com/users/authenticate"];
        ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
        [request setRequestMethod:@"POST"];
        [request setPostValue:@"vishalvaghasiya.90@gmail.com" forKey:@"username"];
        [request setPostValue:@"12345678" forKey:@"password"];
        [request setTimeOutSeconds:60];
        [request setDelegate:self];
        [request startAsynchronous];
        
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    }
    else if (alertView.tag==10 && buttonIndex==1)
    {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"back"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [[NSUserDefaults standardUserDefaults] setObject:[alertView textFieldAtIndex:0].text forKey:@"email"];
        [[NSUserDefaults standardUserDefaults] setObject:[alertView textFieldAtIndex:1].text forKey:@"password"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        NSURL *url = [NSURL URLWithString:@"https://api.vineapp.com/users/authenticate"];
        userLoginRequest = [ASIFormDataRequest requestWithURL:url];
        [userLoginRequest setRequestMethod:@"POST"];
        [userLoginRequest setPostValue:[alertView textFieldAtIndex:0].text forKey:@"username"];
        [userLoginRequest setPostValue:[alertView textFieldAtIndex:1].text forKey:@"password"];
        [userLoginRequest setTimeOutSeconds:60];
        [userLoginRequest setDelegate:self];
        [userLoginRequest startAsynchronous];
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
