//
//  CreatePostViewController.h
//  sirlame
//
//  Created by Steve Gattuso on 5/19/13.
//  Copyright (c) 2013 Steve Gattuso. All rights reserved.
//

#import <UIKit/UIKit.h>

@class User;
@class AppDelegate;

@protocol CreatePostViewControllerDelegate

-(void)savedPost;

@end

@interface CreatePostViewController : UIViewController <UITextViewDelegate>

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) IBOutlet UITextView *postContent;
@property (strong, nonatomic) IBOutlet UISwitch *postAnon;
@property (strong, nonatomic) AppDelegate *appDelegate;
@property (strong, nonatomic) id<CreatePostViewControllerDelegate> delegate;

-(IBAction)pressCancel:(id)sender;
-(IBAction)pressSave:(id)sender;

@end
