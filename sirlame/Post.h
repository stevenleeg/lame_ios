//
//  Post.h
//  sirlame
//
//  Created by Steve Gattuso on 5/19/13.
//  Copyright (c) 2013 Steve Gattuso. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class User;

typedef void (^PostSaveCompletionHandler)(NSError*);

@interface Post : NSManagedObject

@property (nonatomic, retain) NSString * content;
@property (nonatomic, retain) NSNumber * id;
@property (nonatomic, retain) User *author;

-(void)syncToServerWithCompletionHandler:(PostSaveCompletionHandler)onCompletion;

@end
