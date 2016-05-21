//
//  UIViewController+CBHelper.h
//  ClickBid
//
//  Created by Pushpendra on 06/05/16.
//  Copyright © 2016 Syscraft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (CBHelper)

-(void)CB_ShowLoaderOnView;
-(void)CB_HideLoderOnView;

-(void)CB_ShowAlertWithTitle:(NSString *)StrTitle andMessage:(NSString *)StrMsg;
-(void)CB_PUshViewControllerWithStoryBoardID:(NSString *)StrKey andViewController:(UIViewController *)VC;
-(void)CB_POPViewController;
-(void)CB_TextFieldsOPlaceHolderColor:(NSArray *)textCollection;
-(BOOL)CheckNetworkReachability;
-(void)CB_ShowNavigationBar;
-(void)CB_HideNavigationBar;
-(void)CB_SetNavigationBackButtonImage;
-(void)CB_RemoveLeftBackButton;

@end
