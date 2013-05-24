//
//  LoginViewController.h
//  sirlame
//
//  Created by Steve Gattuso on 5/22/13.
//  Copyright (c) 2013 Steve Gattuso. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginViewController : UIViewController

@property (strong, nonatomic) IBOutlet UITextField *usernameField;
@property (strong, nonatomic) IBOutlet UITextField *passwordField;

-(IBAction)pressLogin:(id)sender;

@end
