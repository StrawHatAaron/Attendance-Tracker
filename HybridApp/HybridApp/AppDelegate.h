//
//  AppDelegate.h
//  HybridApp
//
//  Created by Aaron Miller on 1/16/18.
//  Copyright © 2018 Aaron Miller. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong) NSPersistentContainer *persistentContainer;

- (void)saveContext;


@end

