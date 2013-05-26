//
//  PostTableCell.m
//  sirlame
//
//  Created by Steve Gattuso on 5/24/13.
//  Copyright (c) 2013 Steve Gattuso. All rights reserved.
//

#import "PostTableCell.h"
#import "SLColors.h"
#import <QuartzCore/QuartzCore.h>

@implementation PostTableCell
@synthesize postContent;
@synthesize postedBy;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setContent:(NSString*)content
{
    self.postContent.text = content;
}

-(void)setAuthor:(NSString *)author
{
    self.postedBy.text = [NSString stringWithFormat:@"posted by %@", author];
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    CGSize size = [self.postContent.text sizeWithFont:[UIFont systemFontOfSize:18.0] constrainedToSize:CGSizeMake(self.superview.frame.size.width - 20, 1000.0)];
    CGRect frame = self.postContent.frame;
    frame.size.height = size.height + 15;
    self.postContent.frame = frame;
    
    [self.postedBy sizeToFit];
}

@end
