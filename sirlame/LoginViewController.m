//
//  LoginViewController.m
//  sirlame
//
//  Created by Steve Gattuso on 5/22/13.
//  Copyright (c) 2013 Steve Gattuso. All rights reserved.
//

#import "LoginViewController.h"
#import "AppDelegate.h"
#import "User.h"
#import <MBProgressHUD/MBProgressHUD.h>

@interface LoginViewController ()

@end

@implementation LoginViewController

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
	// Do any additional setup after loading the view.
}

- (void)pressLogin:(id)sender
{
    [self.view endEditing:YES];
    
    
    [User authenticateUser:self.usernameField.text withPassword:self.passwordField.text onFinish:^(User *user) {
        if(user != nil) {
            AppDelegate *delegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
            delegate.currentUser = user;
            
            NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
            [prefs setObject:user.sid forKey:@"currentUserSID"];
            [prefs synchronize];
            
            [self dismissViewControllerAnimated:YES completion:nil];
        }
        else {
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.mode = MBProgressHUDModeText;
            hud.labelText = @"Invalid credentials";
            hud.userInteractionEnabled = NO;
            [hud hide:YES afterDelay:1.75];
            self.passwordField.text = @"";
        }
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
