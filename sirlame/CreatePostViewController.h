//
//  CreatePostViewController.h
//  sirlame
//
//  Created by Steve Gattuso on 5/19/13.
//  Copyright (c) 2013 Steve Gattuso. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CreatePostViewController : UIViewController <UITextViewDelegate>

@property (strong, nonatomic) IBOutlet UITextView *postContent;

@end
