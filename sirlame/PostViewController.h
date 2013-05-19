//
//  PostViewController.h
//  sirlame
//
//  Created by Steve Gattuso on 5/19/13.
//  Copyright (c) 2013 Steve Gattuso. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Post;

@interface PostViewController : UIViewController

@property (nonatomic, strong) IBOutlet UILabel *postedBy;
@property (nonatomic, strong) IBOutlet UITextView *postContent;
@property (nonatomic, strong) Post *post;

@end
