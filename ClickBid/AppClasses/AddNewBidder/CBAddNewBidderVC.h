//
//  CBAddNewBidderVC.h
//  ClickBid
//
//  Created by Pushpendra on 06/05/16.
//  Copyright © 2016 Syscraft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CBHeader.h"
#import "CustomKeyboard.h"
#import "CHRTextFieldFormatter.h"
#import "LTHMonthYearPickerView.h"


@interface CBAddNewBidderVC : UITableViewController {
    //TextField Outlet
    CustomKeyboard *keyBoard;
    LTHMonthYearPickerView *monthYearPicker;
    __weak IBOutlet UITextField *CB_txtFirstName;
    __weak IBOutlet UITextField *CB_TxtLastName;
    __weak IBOutlet UITextField *CB_TextPhone;
    __weak IBOutlet UITextField *CB_TextEmail;
    __weak IBOutlet UITextField *CB_TextCompany;
    __weak IBOutlet UITextField *CB_TxtTableNameNo;
    __weak IBOutlet UITextField *CB_TxtCardNo;
    __weak IBOutlet UITextField *CB_TxtCVV;
    __weak IBOutlet UIButton *CB_BtnExpiryDate;
    __weak IBOutlet UITextField *CB_TxtExpirayDate;
    __weak IBOutlet UIButton *CB_BtnEditUpdate;
    CHRTextFieldFormatter *phoneNumberFormatter,*cardNumberFormatter;
    __weak IBOutlet UIImageView *CB_imgCheckUncheckWelcomeText;
    __weak IBOutlet UIImageView *CB_ImgCheckUncheckPasswordRequired;
    __weak IBOutlet UITextField *CB_TxtPassword;
    __weak IBOutlet UITextField *Cb_TextPasswordAgain;
}
@property (strong,nonatomic)IBOutletCollection(UITextField)NSArray *CB_textFields;
@property (strong,nonatomic)IBOutletCollection(UITextField)NSArray *CB_textFieldsPassword;

@property (strong,nonatomic)IBOutletCollection(UITableViewCell)NSArray *CB_TableViewCells;


@property(strong,nonatomic)NSString *strTitle;
@property(strong,nonatomic)NSString *strID;
- (IBAction)CB_ActionBtnForWelcomeTextCheckUncheck:(id)sender;
- (IBAction)Cb_ActionBtnForCheckUnCheckForIsPasswordRequired:(id)sender;

@end
