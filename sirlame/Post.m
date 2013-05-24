//
//  Post.m
//  sirlame
//
//  Created by Steve Gattuso on 5/19/13.
//  Copyright (c) 2013 Steve Gattuso. All rights reserved.
//

#import "AppDelegate.h"
#import "Post.h"
#import "User.h"


@implementation Post

@dynamic content;
@dynamic id;
@dynamic author;

-(void)syncToServerWithCompletionHandler:(PostSaveCompletionHandler)onCompletion
{
    // We'll need the curren user
    AppDelegate *delegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    
    NSURL *url = [NSURL URLWithString:@"http://lame.stevegattuso.me/api/1/post"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = @"POST";
    NSString *queryString = [NSString stringWithFormat:@"content=%@&sid=%@", self.content, delegate.currentUser.sid];
    request.HTTPBody = [queryString dataUsingEncoding:NSUTF8StringEncoding];
    
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *response, NSData * data, NSError *error)
    {
        if(error != nil) {
            NSLog(@"Local error saving post: %@", [error localizedDescription]);
            return;
        }
        if([data length] == 0) {
            NSLog(@"Local error saving post: Response data is 0");
            return;
        }
        
        if([data length] == 0 || error != nil) {
            dispatch_async(dispatch_get_main_queue(), ^() {
                onCompletion([NSError errorWithDomain:@"Local save error" code:403 userInfo:nil]);
            });
        }
       
        NSDictionary *resp = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
        
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse*)response;
        if([httpResponse statusCode] != 200) {
            NSLog(@"Remote error while saving post [%d]: %@", [httpResponse statusCode], [resp objectForKey:@"message"]);
            dispatch_async(dispatch_get_main_queue(), ^() {
                onCompletion([NSError errorWithDomain:@"Remote save error" code:403 userInfo:nil]);
            });
            return;
        }
        
        self.id = [resp objectForKey:@"id"];
        
        dispatch_async(dispatch_get_main_queue(), ^() {
            onCompletion(nil);
        });
    }];
}

@end
