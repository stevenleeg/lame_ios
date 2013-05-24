//
//  User.m
//  sirlame
//
//  Created by Steve Gattuso on 5/22/13.
//  Copyright (c) 2013 Steve Gattuso. All rights reserved.
//

#import "AppDelegate.h"
#import "User.h"
#import "Post.h"


@implementation User

@dynamic id;
@dynamic name;
@dynamic sid;
@dynamic posts;

+ (void)authenticateUser:(NSString *)username withPassword:(NSString *)password onFinish:(AuthenticatedBlock)onFinish
{
    NSURL *authURL = [NSURL URLWithString:@"http://lame.stevegattuso.me/api/1/login"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:authURL];
    
    request.HTTPMethod = @"POST";
    NSString *queryString = [NSString stringWithFormat:@"username=%@&password=%@", username, password];
    request.HTTPBody = [queryString dataUsingEncoding:NSUTF8StringEncoding];
    
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *resp, NSData *data, NSError *error) {
        if([data length] > 0 && error == nil) {
            NSDictionary *respData = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
            NSDictionary *userData = [respData objectForKey:@"user"];
            
            // Were their credentials okay?
            BOOL success = [(NSNumber*)[respData objectForKey:@"success"] boolValue];
            if(!success) {
                NSLog(@"Invalid credentials");
                dispatch_async(dispatch_get_main_queue(), ^() {
                    onFinish(nil);
                });
                return;
            }
            
            // Do we have this user already?
            AppDelegate *delegate = [[UIApplication sharedApplication] delegate];
            NSSet *results = [delegate.managedObjectContext fetchObjectsForEntityName:@"User" withPredicate:@"id == %@", [userData objectForKey:@"id"]];
            
            User *user = (User*)[results anyObject];
            if(user == nil) {
                NSLog(@"Creating new user");
                user = [NSEntityDescription insertNewObjectForEntityForName:@"User" inManagedObjectContext:delegate.managedObjectContext];
                user.name = username;
                user.sid = [userData objectForKey:@"sid"];
                
                [delegate.managedObjectContext save:&error];
                delegate.currentUser = user;
            }
            else {
                NSLog(@"Logged in with user %@", user.name);
            }
            
            dispatch_async(dispatch_get_main_queue(), ^() {
                onFinish(user);
            });
        }
    }];
}

@end
