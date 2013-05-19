//
//  PostViewController.m
//  sirlame
//
//  Created by Steve Gattuso on 5/19/13.
//  Copyright (c) 2013 Steve Gattuso. All rights reserved.
//

#import "PostViewController.h"
#import "CreatePostViewController.h"
#import "Post.h"
#import "User.h"

@interface PostViewController ()

@end

@implementation PostViewController

@synthesize postContent;
@synthesize postedBy;

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
    
    self.postedBy.text = [NSString stringWithFormat:@"Posted by: %@", self.post.author.name];
    self.postContent.text = self.post.content;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
