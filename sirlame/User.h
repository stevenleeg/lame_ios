//
//  User.h
//  sirlame
//
//  Created by Steve Gattuso on 5/22/13.
//  Copyright (c) 2013 Steve Gattuso. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@class Post;

@interface User : NSManagedObject

@property (nonatomic, retain) NSNumber * id;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * sid;
@property (nonatomic, retain) NSSet *posts;
@end

typedef void (^AuthenticatedBlock)(User*);

@interface User (CoreDataGeneratedAccessors)

- (void)addPostsObject:(Post *)value;
- (void)removePostsObject:(Post *)value;
- (void)addPosts:(NSSet *)values;
- (void)removePosts:(NSSet *)values;

+ (void)authenticateUser:(NSString *)username withPassword:(NSString *)password onFinish:(AuthenticatedBlock)onFinish;

@end
