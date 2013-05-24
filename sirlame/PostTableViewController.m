//
//  PostTableViewController.m
//  sirlame
//
//  Created by Steve Gattuso on 5/18/13.
//  Copyright (c) 2013 Steve Gattuso. All rights reserved.
//

#import "PostTableViewController.h"
#import "AppDelegate.h"
#import "Post.h"
#import "User.h"
#import "PostViewController.h"
#import <MBProgressHUD/MBProgressHUD.h>

@interface PostTableViewController ()

@end

@implementation PostTableViewController

@synthesize posts;
@synthesize managedObjectContext;
@synthesize logoutButton;
@synthesize navBar;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
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
    
    // Change some elements around
    [self checkLogoutAnimated: NO];
    
    self.title = @"recent posts";
    
    // Try to load posts
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    [Post loadNewPostsWithCompletionHandler:^(NSError *error) {
        if(error != nil) {
            NSLog(@"Error loading posts");
            return;
        }
        
        [hud hide:YES];
        [self loadPosts];
    }];
}

-(void)loadPosts
{
    NSSortDescriptor *sort = [[NSSortDescriptor alloc] initWithKey:@"id" ascending:NO];
    NSArray *sorters = [[NSArray alloc] initWithObjects:sort, nil];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setSortDescriptors:sorters];
    NSEntityDescription *postDesc = [NSEntityDescription entityForName:@"Post" inManagedObjectContext:self.managedObjectContext];
    
    request.entity = postDesc;
    NSError *error;
    self.posts = [self.managedObjectContext executeFetchRequest:request error:&error];
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [posts count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    Post *post = [self.posts objectAtIndex:indexPath.row];
    if(post.author != nil) {
        cell.textLabel.text = post.author.name;
    }
    else {
        cell.textLabel.text = @"anonymous";
    }
    cell.detailTextLabel.text = post.content;
    
    return cell;
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([[segue identifier] isEqualToString:@"showPostDetails"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        PostViewController *next = (PostViewController*)segue.destinationViewController;
        
        Post *post = [self.posts objectAtIndex: indexPath.row];
        next.post = post;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

-(void)savedPost
{
    [self loadPosts];
    [self checkLogout];
    [self.tableView reloadData];
}

-(void)cancelledPost
{
    [self checkLogout];
}

-(IBAction)pressNew:(id)sender {
    CreatePostViewController *createView = (CreatePostViewController*)[self.storyboard instantiateViewControllerWithIdentifier:@"createPost"];
    createView.delegate = self;
    [self presentViewController:createView animated:YES completion:nil];
}

-(void)checkLogoutAnimated:(BOOL)animated
{
    AppDelegate *delegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    NSMutableArray *navBarItems = [[self.navBar leftBarButtonItems] mutableCopy];
    if(delegate.currentUser == nil) {
        [navBarItems removeObject:self.logoutButton];
    } else if(![navBarItems containsObject:self.logoutButton]) {
        [navBarItems addObject:self.logoutButton];
    }
    [self.navBar setLeftBarButtonItems:navBarItems animated:animated];
}

-(void)checkLogout
{
    [self checkLogoutAnimated:YES];
}

-(IBAction)pressLogout:(id)sender
{
    AppDelegate *delegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    delegate.currentUser = nil;
    
    // Remove the SID from defaults
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    [prefs removeObjectForKey:@"currentUserSID"];
    [prefs synchronize];
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeCustomView;
    hud.customView = [[UIImageView alloc] initWithImage: [UIImage imageNamed:@"37x-Checkmark.png"]];
    [hud hide:YES afterDelay:1.75];
    
    [self checkLogout];
}

@end