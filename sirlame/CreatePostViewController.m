//
//  CreatePostViewController.m
//  sirlame
//
//  Created by Steve Gattuso on 5/19/13.
//  Copyright (c) 2013 Steve Gattuso. All rights reserved.
//

#import "CreatePostViewController.h"

@interface CreatePostViewController ()

@end

@implementation CreatePostViewController

@synthesize postContent;

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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
