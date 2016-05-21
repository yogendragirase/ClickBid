//
//  AppDelegate.h
//  ClickBid
//
//  Created by Pushpendra on 06/05/16.
//  Copyright © 2016 Syscraft. All rights reserved.
//

#import <UIKit/UIKit.h>
#define IS_IPHONE4 (([[UIScreen mainScreen] bounds].size.height-420)?NO:YES)

#define IS_IPHONE5 (([[UIScreen mainScreen] bounds].size.height-568)?NO:YES)

#define IS_IPHONE6 (([[UIScreen mainScreen] bounds].size.height-667)?NO:YES)

#define IS_IPHONE6plus (([[UIScreen mainScreen] bounds].size.height-736)?NO:YES)

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;


@end

