//
//  CreatePostViewController.m
//  sirlame
//
//  Created by Steve Gattuso on 5/19/13.
//  Copyright (c) 2013 Steve Gattuso. All rights reserved.
//

#import "CreatePostViewController.h"
#import "LoginViewController.h"
#import "AppDelegate.h"
#import "Post.h"
#import "User.h"

@interface CreatePostViewController ()

@end

@implementation CreatePostViewController

@synthesize postContent;
@synthesize managedObjectContext;
@synthesize appDelegate;
@synthesize delegate;
@synthesize postAnon;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.appDelegate = [[UIApplication sharedApplication] delegate];
    self.managedObjectContext = self.appDelegate.managedObjectContext;
    
    [self.postContent setDelegate: self];
}

-(BOOL) textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if([text isEqualToString:@"\n"]) {
        [self.view endEditing: YES];
        return NO;
    }
    else {
        return YES;
    }
}

-(BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    if([textView.text isEqualToString:@"What would you like to say to the world?"]) {
        textView.text = @"";
    }
    
    return YES;
}

-(IBAction)changeAnonymousSwitch:(UISwitch*)sender
{
    if(!sender.isOn && self.appDelegate.currentUser == nil) {
        LoginViewController *loginView = (LoginViewController*)[self.storyboard instantiateViewControllerWithIdentifier:@"login"];
        [self presentViewController:loginView animated:YES completion:nil];
    }
}

-(IBAction)pressCancel:(id)sender {
    [self dismissViewControllerAnimated:YES completion: nil];
}

-(IBAction)pressSave:(id)sender {
    Post *post = [NSEntityDescription insertNewObjectForEntityForName:@"Post" inManagedObjectContext:self.managedObjectContext];
    post.content = [self.postContent text];
    
    if([self.postAnon isOn]) {
        post.author = nil;
    } else {
        post.author = self.appDelegate.currentUser;
    }
    post.id = [NSNumber numberWithInt:1];
    
    NSError *error;
    if(![self.managedObjectContext save:&error]) {
        NSLog(@"Error while saving post to local db: %@", [error localizedDescription]);
    }
    
    [post syncToServer];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)viewDidDisappear:(BOOL)animated
{
    [self.delegate savedPost];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
