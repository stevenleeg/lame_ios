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

+(void)loadNewPostsWithCompletionHandler:(PostLoadedCompletionHandler)onCompletion
{
    NSURL *url = [NSURL URLWithString:@"http://lame.stevegattuso.me/api/1/post"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = @"GET";
    
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        if(error != nil) {
            NSLog(@"Error loading posts: %@", [error localizedDescription]);
        }
        
        NSDictionary *resp = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
        NSArray *posts = (NSArray*)[resp objectForKey:@"posts"];
        NSArray *users = (NSArray*)[resp objectForKey:@"users"];
        
        // We're going to be storing this data, so let's get the MOC
        AppDelegate *delegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
        NSManagedObjectContext *context = delegate.managedObjectContext;
        
        for(NSDictionary *userData in users) {
            User *user = [[context fetchObjectsForEntityName:@"User" withPredicate:@"id == %i", [userData objectForKey:@"id"]] anyObject];
            if(user != nil) {
                continue;
            }
            
            user = [NSEntityDescription insertNewObjectForEntityForName:@"User" inManagedObjectContext:context];
            user.name = [userData objectForKey:@"name"];
            user.id = [userData objectForKey:@"id"];
            
            if(![context save:&error]) {
                NSLog(@"Error saving user %@", user.name);
                return;
            }
        }
        
        for(NSDictionary *postData in posts) {
            // Try to find the post
            Post *post = [[context fetchObjectsForEntityName:@"Post" withPredicate:@"id == %@", [postData objectForKey:@"id"]] anyObject];
            
            // Post already exists in our cache, so let's move on
            if(post != nil) {
                continue;
            }
            
            post = [NSEntityDescription insertNewObjectForEntityForName:@"Post" inManagedObjectContext:context];
            post.content = [postData objectForKey:@"content"];
            post.id = [postData objectForKey:@"id"];
     
            if(![[postData objectForKey:@"author_id"] isKindOfClass:[NSNull class]]) {
                User *user = [[context fetchObjectsForEntityName:@"User" withPredicate:@"id == %@", [postData objectForKey:@"author_id"]] anyObject];
                if(user == nil) {
                    NSLog(@"Error: reached an uncached user.");
                    return;
                }
                
                post.author = user;
            }
            
            if(![context save:&error]) {
                NSLog(@"Error saving post %@", post.id);
            }
        }
        
        dispatch_async(dispatch_get_main_queue(), ^() {
            onCompletion(nil);
        });
    }];
}

@end
