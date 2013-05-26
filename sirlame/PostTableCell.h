//
//  PostTableCell.h
//  sirlame
//
//  Created by Steve Gattuso on 5/24/13.
//  Copyright (c) 2013 Steve Gattuso. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PostTableCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UITextView *postContent;
@property (strong, nonatomic) IBOutlet UILabel *postedBy;

-(void)setContent:(NSString*)content;
-(void)setAuthor:(NSString*)author;

@end
