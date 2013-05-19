//
//  MasterViewController.h
//  sirlame
//
//  Created by Steve Gattuso on 5/18/13.
//  Copyright (c) 2013 Steve Gattuso. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MasterViewController : UINavigationController

@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong) NSArray *posts;

@end