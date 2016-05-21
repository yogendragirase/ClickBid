//
//  UIViewController+CBHelper.m
//  ClickBid
//
//  Created by Pushpendra on 06/05/16.
//  Copyright © 2016 Syscraft. All rights reserved.
//

#import "UIViewController+CBHelper.h"
#import "CBHeader.h"

@implementation UIViewController (CBHelper)

-(void)CB_ShowLoaderOnView
{
    [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
    [SVProgressHUD show];
    
}
-(void)CB_HideLoderOnView
{
    [[UIApplication sharedApplication] endIgnoringInteractionEvents];

    [SVProgressHUD dismiss];

}
-(void)CB_ShowAlertWithTitle:(NSString *)StrTitle andMessage:(NSString *)StrMsg
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:StrTitle message:StrMsg preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
    [alertController addAction:ok];
    
    [self presentViewController:alertController animated:YES completion:nil];
    
}

-(void)CB_PUshViewControllerWithStoryBoardID:(NSString *)StrKey andViewController:(UIViewController *)VC
{
    [self.navigationController pushViewController:VC animated:YES];
}

-(void)CB_POPViewController
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)CB_TextFieldsOPlaceHolderColor:(NSArray *)textCollection
{
    for (UITextField *text in textCollection) {
        
        [text setValue:[UIColor blackColor]
            forKeyPath:@"_placeholderLabel.textColor"];
    }

}
-(BOOL)CheckNetworkReachability
{
    Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
    if (networkStatus == NotReachable) {
        NSLog(@"There IS NO internet connection");
        return YES;
    } else {
        NSLog(@"There IS internet connection");
        return NO;
    }
}
-(void)CB_ShowNavigationBar
{
    [self.navigationController setNavigationBarHidden:NO];
    
}

-(void)CB_HideNavigationBar
{
    [self.navigationController setNavigationBarHidden:YES];

}

-(void)CB_SetNavigationBackButtonImage
{
    UIImage *myImage = [UIImage imageNamed:@"CB_IconBack"];
    UIImage *backButtonImage = [myImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];

    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithImage:backButtonImage style:UIBarButtonItemStylePlain target:self action:@selector(CB_POPViewController)];
    [self.navigationItem setLeftBarButtonItem:barButtonItem];
    
}

-(void)CB_RemoveLeftBackButton
{
    self.navigationItem.hidesBackButton = YES;

}


@end
