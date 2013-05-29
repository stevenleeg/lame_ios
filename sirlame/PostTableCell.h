//
//  PostTableCell.h
//  sirlame
//
//  Created by Steve Gattuso on 5/24/13.
//  Copyright (c) 2013 Steve Gattuso. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol PostTableCellDelegate

-(void)pushViewPost;

@end

@class PostTableViewController;

@interface PostTableCell : UITableViewCell <UIWebViewDelegate>

@property (strong, nonatomic) IBOutlet UIWebView *postContent;
@property (strong, nonatomic) IBOutlet UILabel *postedBy;
@property (strong, nonatomic) IBOutlet UIButton *viewPostButton;
@property (strong, nonatomic) NSString *postText;
@property (weak, nonatomic) id<PostTableCellDelegate> delegate;

-(void)setContent:(NSString*)content;
-(void)setAuthor:(NSString*)author;
-(IBAction)pushViewPost:(id)sender;

@end
