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
#import "SLColors.h"
#import "PostTableCell.h"
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
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    AppDelegate *delegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    self.managedObjectContext = delegate.managedObjectContext;
    
    rowHeights = [[NSMutableDictionary alloc] init];
    currentlySelectedIndexPath = -1;
    
    // UI customization
    [self checkLogoutAnimated: NO];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
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
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [posts count] * 2 - 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *NormalCellIdentifier = @"Cell";
    static NSString *SpacingCellIdentifier = @"SpacingCell";
    
    if(indexPath.row % 2 == 1) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SpacingCellIdentifier forIndexPath:indexPath];
        CGRect rect = [self.tableView rectForRowAtIndexPath:indexPath];
        UIView *backgroundView = [[UIView alloc] initWithFrame:rect];
        backgroundView.backgroundColor = [SLColors background];
        cell.backgroundView = backgroundView;
        
        return cell;
    }
    
    PostTableCell *cell = [tableView dequeueReusableCellWithIdentifier:NormalCellIdentifier forIndexPath:indexPath];
    
    Post *post = [self.posts objectAtIndex:indexPath.row / 2];
    if(post.author != nil) {
        [cell setAuthor:post.author.name];
    }
    else {
        [cell setAuthor:@"anonymous"];
    }
    [cell setContent:post.content];
    
    // Do some styling
    CGRect rect = [self.tableView rectForRowAtIndexPath:indexPath];
    UIView *backgroundView = [[UIView alloc] initWithFrame:rect];
    backgroundView.backgroundColor = [SLColors white];
    cell.backgroundView = backgroundView;
    
    // Set the selectedBackgroundView
    UIView *selectedBackgroundView = [[UIView alloc] initWithFrame: cell.frame];
    selectedBackgroundView.backgroundColor = [SLColors tan];
    cell.selectedBackgroundView = selectedBackgroundView;
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // This is the padding row
    if(indexPath.row % 2 == 1) {
        return 10;
    }
    
    // Check the cache
    NSString *cacheKey = [NSString stringWithFormat:@"%d", indexPath.row];
    NSNumber *height = [rowHeights objectForKey:cacheKey];
    if(height != nil) {
        return [height integerValue];
    }
    
    // Otherwise, let's size it relative to the content of the textView
    Post *post = [self.posts objectAtIndex:indexPath.row / 2];
    CGSize size = [post.content sizeWithFont:[UIFont systemFontOfSize:18.0] constrainedToSize:CGSizeMake(self.tableView.frame.size.width - 20, 1000.0)];
    height = [NSNumber numberWithInt: size.height + 32];
    
    [rowHeights setObject:height forKey:cacheKey];
    
    return size.height + 32;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    int addToHeight = 30;
    if(currentlySelectedIndexPath == indexPath.row) {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        addToHeight = -30;
        currentlySelectedIndexPath = -1;
    }
    else {
        currentlySelectedIndexPath = indexPath.row;
    }
    
    // Change the height to add the new views (the inefficiency here kills me)
    NSString *key = [NSString stringWithFormat:@"%d", indexPath.row];
    NSNumber *height = [rowHeights objectForKey:key];
    height = [NSNumber numberWithInt: ([height integerValue] + addToHeight)];
    [rowHeights setObject:height forKey:key];
    
    [tableView beginUpdates];
    [tableView endUpdates];
    
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