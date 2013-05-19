//
//  MasterViewController.m
//  sirlame
//
//  Created by Steve Gattuso on 5/18/13.
//  Copyright (c) 2013 Steve Gattuso. All rights reserved.
//

#import "MasterViewController.h"
#import "AppDelegate.h"

@interface MasterViewController ()

@end

@implementation MasterViewController

@synthesize managedObjectContext;
@synthesize posts;

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
    
    AppDelegate *delegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    self.managedObjectContext = delegate.managedObjectContext;
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Post" inManagedObjectContext:self.managedObjectContext];
    [request setEntity: entity];
    
    NSError *error;
    self.posts = [self.managedObjectContext executeFetchRequest:request error:&error];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
