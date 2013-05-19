//
//  CreatePostViewController.h
//  sirlame
//
//  Created by Steve Gattuso on 5/19/13.
//  Copyright (c) 2013 Steve Gattuso. All rights reserved.
//

#import <UIKit/UIKit.h>

@class User;

@protocol CreatePostViewControllerDelegate

-(void)savedPost;

@end

@interface CreatePostViewController : UIViewController <UITextViewDelegate>

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) IBOutlet UITextView *postContent;
@property (strong, nonatomic) User *currentUser;
@property (strong, nonatomic) id<CreatePostViewControllerDelegate> delegate;

-(IBAction)pressCancel:(id)sender;
-(IBAction)pressSave:(id)sender;

@end
