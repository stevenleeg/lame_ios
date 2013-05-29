//
//  PostTableCell.m
//  sirlame
//
//  Created by Steve Gattuso on 5/24/13.
//  Copyright (c) 2013 Steve Gattuso. All rights reserved.
//

#import "PostTableCell.h"
#import "SLColors.h"
#import "PostTableViewController.h"
#import <QuartzCore/QuartzCore.h>

@implementation PostTableCell
@synthesize postContent;
@synthesize postedBy;
@synthesize postText;
@synthesize delegate;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
    }
    return self;
}

-(void)setContent:(NSString*)content
{
    // Parse the content for @replies
    NSError *error;
    NSRegularExpression *regex = [[NSRegularExpression alloc] initWithPattern:@"@([0-9]*)" options:NSRegularExpressionCaseInsensitive error:&error];
    content = [regex stringByReplacingMatchesInString:content options:0 range:NSMakeRange(0, [content length]) withTemplate:@"<a href=\"#\">@$1</a>"];
    
    NSString *path = [[NSBundle mainBundle] bundlePath];
    NSURL *baseURL = [NSURL fileURLWithPath:path];
    
    content = [NSString stringWithFormat:@"<link rel=\"stylesheet\" type=\"text/css\" href=\"style.css\" />"
        "%@", content];
    
    [self.postContent loadHTMLString:content baseURL:baseURL];
    [self.postContent setDelegate: self];
    self.postContent.backgroundColor = [UIColor clearColor];
    self.postContent.opaque = NO;
    self.postText = content;
}

-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    CGRect frame = webView.frame;
    frame.size.height = 1;
    webView.frame = frame;
    CGSize size = [webView sizeThatFits:CGSizeZero];
    frame.size = size;
    frame.size.height += 5;
    webView.frame = frame;
    
    // Now setup the buttons
    frame = CGRectMake(frame.origin.x + 9, frame.origin.y + frame.size.height, self.viewPostButton.frame.size.width, self.viewPostButton.frame.size.height);
    self.viewPostButton.frame = frame;
}

-(IBAction)pushViewPost:(id)sender
{
    [self.delegate pushViewPost];
}

-(void)setAuthor:(NSString *)author
{
    self.postedBy.text = [NSString stringWithFormat:@"posted by %@", author];
    [self.postedBy sizeToFit];
}

-(void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    if(self.selected == selected) return;
    [super setSelected:selected animated:animated];
    
    if(selected) {
        self.viewPostButton.alpha = 1;
    } else {
        self.viewPostButton.alpha = 0;
    }
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    /*
    CGSize size = [self.postText sizeWithFont:[UIFont systemFontOfSize:18.0] constrainedToSize:CGSizeMake(self.frame.size.width, 1000.0)];
    CGRect frame = self.postContent.frame;
    frame.size.height = size.height + 5;
    self.postContent.frame = frame;
    */
    
    [self.postedBy sizeToFit];
    
    /*
    // Position the view post button
    CGRect btnFrame = self.viewPostButton.frame;
    self.viewPostButton.frame = CGRectMake(btnFrame.origin.x, frame.origin.y + frame.size.height + 10, btnFrame.size.width, btnFrame.size.height);
    */
}

@end
