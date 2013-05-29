//
//  PostTableViewController.h
//  sirlame
//
//  Created by Steve Gattuso on 5/18/13.
//  Copyright (c) 2013 Steve Gattuso. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CreatePostViewController.h"
#import "PostTableCell.h"

@interface PostTableViewController : UITableViewController <CreatePostViewControllerDelegate, PostTableCellDelegate> {
    NSMutableDictionary *rowHeights;
    NSIndexPath *currentlySelectedIndexPath;
}

@property (strong, nonatomic) NSArray *posts;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *logoutButton;
@property (strong, nonatomic) IBOutlet UINavigationItem *navBar;

-(IBAction)pressNew:(id)sender;
-(IBAction)pressLogout:(id)sender;
-(void)checkLogout;
-(void)checkLogoutAnimated:(BOOL)animated;

@end
