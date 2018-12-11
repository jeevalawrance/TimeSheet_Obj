//
//  AppDelegate.h
//  Template
//
//  Created by Anthony on 11/1/17.
//  Copyright © 2017 CPD. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;

-(void)mainViewController;
@end

