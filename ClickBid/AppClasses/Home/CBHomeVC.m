//
//  CBHomeVC.m
//  ClickBid
//
//  Created by Pushpendra on 06/05/16.
//  Copyright © 2016 Syscraft. All rights reserved.
//

#import "CBHomeVC.h"
#import "CBHeader.h"

@interface CBHomeVC ()<UITextFieldDelegate>

@end

@implementation CBHomeVC

#pragma mark viewDidLoad

- (void)viewDidLoad {
  [super viewDidLoad];
    
}

#pragma mark viewWillAppear

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, imgSearchIcon.frame.size.width+10, CB_TxtSearchField.frame.size.height)];
    
    CB_TxtSearchField.leftView = paddingView;
    
    CB_TxtSearchField.leftViewMode = UITextFieldViewModeAlways;
    
    [self CB_ShowNavigationBar];
    
    [self CB_RemoveLeftBackButton];
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}.
*/

#pragma mark Button Action Methods
#pragma mark btnSearchAction

- (IBAction)btnSearchAction:(id)sender {
    [self.view endEditing:YES];
    if ([CBUtility Trim:CB_TxtSearchField.text].length==0){
        
        [self CB_ShowAlertWithTitle:@"Alert" andMessage:@"Please enter last name or bidder number of company."];
        return;
    }
    else
    {
    CBSearchResultsVC *obj = [self.storyboard instantiateViewControllerWithIdentifier:CBKey_StoryBoardId_SearchResult];
        obj.strTitle = CB_TxtSearchField.text;
        [self.navigationController pushViewController:obj animated:YES];
        
    }
}
#pragma mark Webservice Calling For Butler searching


#pragma mark btnAddNewBidderAction

- (IBAction)btnAddNewBidderAction:(id)sender{
    [self.view endEditing:YES];
    CBAddNewBidderVC *objAdd = [self.storyboard instantiateViewControllerWithIdentifier:CBKey_StoryBoardId_AddNewBidder];
    objAdd.strTitle = @"New Bidder";
    [self.navigationController pushViewController:objAdd animated:YES];
}
#pragma mark BtnLogOutAction

- (IBAction)BtnLogOutAction:(id)sender {
    [self.view endEditing:YES];

    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Message" message:@"Do you want to logout ?" preferredStyle:UIAlertControllerStyleAlert];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [CB_UserDefault setValue:nil forKey:CB_KeyDefaultEventID];
        [CB_UserDefault synchronize];
         [self.navigationController popToRootViewControllerAnimated:YES];
       
    }]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
         [self dismissViewControllerAnimated:YES completion:nil];
    }]];
    dispatch_async(dispatch_get_main_queue(), ^ {
        [self presentViewController:alertController animated:YES completion:nil];
    });
}

#pragma mark TextField Delegate methods
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

@end
