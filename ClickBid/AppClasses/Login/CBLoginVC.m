//
//  CBLoginVC.m
//  ClickBid
//
//  Created by Pushpendra on 06/05/16.
//  Copyright © 2016 Syscraft. All rights reserved.
//

#import "CBLoginVC.h"
#import "CBHeader.h"
#import "CBAPIManager.h"

@interface CBLoginVC ()<CustomKeyboardDelegate,UITextFieldDelegate>
{
    CustomKeyboard *keyBoard;
}
@end

@implementation CBLoginVC
@synthesize CB_TextFeilds;

#pragma mark viewDidLoad

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if ([CB_UserDefault valueForKey:CB_KeyDefaultEventID]!= nil) {
        
        [self gotoHomeViewController];
        return;
    }
    
    [self setKeyBoardTags];
}

#pragma mark viewWillAppear

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

    [self CB_TextFieldsOPlaceHolderColor:CB_TextFeilds];//SetPlaceHolder
    [self CB_HideNavigationBar];

}

#pragma mark KeyBoardTags

-(void)setKeyBoardTags{
    //Custom Keyboard
    keyBoard = [[CustomKeyboard alloc] init];
    keyBoard.delegate = self;
    //TextField Tag
    CB_TxtEventId.tag = 11;
    CB_TxtEventId.delegate = self;
    CB_TxtPaasword.tag = 12;
    CB_TxtPaasword.delegate = self;
}

- (void)didReceiveMemoryWarning{
    
    [super didReceiveMemoryWarning];
   
}

#pragma mark Login Button Action

- (IBAction)BtnLoginAction:(UIButton *)sender{
    
            if ([CBUtility Trim:CB_TxtEventId.text].length==0){
        
        [self CB_ShowAlertWithTitle:@"Alert" andMessage:@"Please enter event id."];
        return;
    }
    else if ([CBUtility Trim:CB_TxtPaasword.text].length==0){
        [self CB_ShowAlertWithTitle:@"Alert" andMessage:@"Please enter password."];
        return;
    }
    else{
        [self.view endEditing:YES];
        CBLog(@"evv--->%@,pasas------>%@",CB_TxtEventId.text,CB_TxtPaasword.text);
        NSDictionary *dict = @{@"id":[NSNumber numberWithInt:[CB_TxtEventId.text intValue]],@"password":CB_TxtPaasword.text};
      
       //
        if (![self CheckNetworkReachability]) {
            [self CB_ShowLoaderOnView];

            [self CB_CallingWebServiceForLoginWithParam:dict];
        }
        else
        {
            [self CB_ShowAlertWithTitle:@"Alert" andMessage:@"Please check your internet connection."];

        }
 //CallWebservice
    }
}

#pragma mark Webservice Calling For Butler Login

-(void)CB_CallingWebServiceForLoginWithParam:(NSDictionary *)Dict {


    NSString *strUrl = [NSString stringWithFormat:@"%@butler-login/%@",BaseUrl,[Dict valueForKey:@"id"]];
    
    [CBAPIManager GetRequestToLoginApiUrl:strUrl withHeader:Dict WithSuccess:^(id response) {
          CBLog(@"Login-->%@",response);
        [self CB_HideLoderOnView];
        if (response!=nil) {
            
            NSDictionary *dictLoginResponce = [response valueForKey:@"data"];
            
            if (![[dictLoginResponce valueForKey:@"ERROR"]isEqualToString:@
                "User id or password is invalid."]) {
                [self textFieldEmpty];
                [CB_UserDefault setValue:[Dict valueForKey:@"id"] forKey:CB_KeyDefaultEventID];
                [CB_UserDefault synchronize];
                [self gotoHomeViewController];
            }
            else{
                [self CB_ShowAlertWithTitle:@"Alert" andMessage:[dictLoginResponce valueForKey:@"ERROR"]];
            }
        }
        else{
            
            [self CB_ShowAlertWithTitle:@"Alert" andMessage:@"Server not getting responce"];
        }
        
    } failure:^(NSError *error) {
         [self CB_HideLoderOnView];
        [self CB_ShowAlertWithTitle:@"Alert" andMessage:@"Something went wrong, please try agin later"];
        CBLog(@"Error-->%@",error);
        
    }];
    
}

#pragma mark Go To HomeViewController
-(void)gotoHomeViewController{
    
    CBHomeVC *obJHome = [self.storyboard instantiateViewControllerWithIdentifier:CBKey_StoryBoardId_Home];
    [self.navigationController pushViewController:obJHome animated:YES];

}


#pragma mark TextField Empty
-(void)textFieldEmpty{
    
    CB_TxtEventId.text = @"";
    CB_TxtPaasword.text = @"";
}

#pragma mark Text Field delegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    
    if (CB_TxtEventId==textField){
        
        [textField setInputAccessoryView:[keyBoard getToolbarWithPrevNextDone:NO :YES]];
        keyBoard.currentSelectedTextboxIndex = textField.tag;
    }
    
    else if (CB_TxtPaasword==textField) {
        
        [textField setInputAccessoryView:[keyBoard getToolbarWithPrevNextDone:YES :NO]];
        keyBoard.currentSelectedTextboxIndex = textField.tag;
    }
    
    return YES;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [textField resignFirstResponder];
    return YES;
}
#pragma mark Custom Keyboard Delegate

- (void)nextClicked:(NSUInteger)sender {
    
    for (int i =0; i<CB_TextFeilds.count; i++)
    
    {
        
        UITextField *text =[CB_TextFeilds objectAtIndex:i];
        
        if (sender == text.tag) {
            
            UITextField *textBecome =[CB_TextFeilds objectAtIndex:i+1];
            [textBecome becomeFirstResponder];
            
        }
    }
}
- (void)previousClicked:(NSUInteger)sender
{
    for (int i =0; i<CB_TextFeilds.count; i++) {
        UITextField *text =[CB_TextFeilds objectAtIndex:i];
        
        if (sender == text.tag) {
            
            UITextField *textBecome =[CB_TextFeilds objectAtIndex:i-1];
            [textBecome becomeFirstResponder];
        }
    }
}
- (void)resignResponder:(NSUInteger)sender {
    
    [self.view endEditing:YES];
}

@end
