//
//  CBCheckOutVC.h
//  ClickBid
//
//  Created by Pushpendra on 07/05/16.
//  Copyright © 2016 Syscraft. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "CBHeader.h"
#import "CHRTextFieldFormatter.h"
#import "BraintreeCore.h"
#import "uniMag.h"

@interface CBCheckOutVC : UITableViewController
{
    __weak IBOutlet UITextField *CB_TxtPaymentType;
    __weak IBOutlet UITextField *CB_TxtFirstName;
    __weak IBOutlet UITextField *CB_TxtLastName;
    __weak IBOutlet UITextField *CB_TxtCardNo;
    __weak IBOutlet UITextField *CB_TxtCVV;
    __weak IBOutlet UITextField *CB_TxtExpirayDate;
    __weak IBOutlet UITextField *CB_TxtPhone;
    __weak IBOutlet UITextField *Cb_TxtEmail;
    __weak IBOutlet UIView *CB_ViewFooter;
    __weak IBOutlet UILabel *CB_lblTotal;
    CHRTextFieldFormatter *phoneNumberFormatter,*cardNumberFormatter;
    uniMag *uniReader;//UNiMag For Card Swapping
}
@property(strong,nonatomic)NSDictionary *dictData;
@property (strong,nonatomic)IBOutletCollection(UITextField)NSArray *CB_textFields;
- (IBAction)CB_BtnPaymentTypeAction:(UIButton *)sender;
- (IBAction)BtnSwipeAction:(id)sender;
- (IBAction)CB_BtnActionExpiryDate:(id)sender;
- (IBAction)CB_BtnPayNowAction:(id)sender;
@property (nonatomic, strong) BTAPIClient *braintreeClient;//BrainTree
//Authorize.net
@property (nonatomic, strong) NSString *sessionToken;
@property (nonatomic, strong) NSString *creditCardBuf;
@property (nonatomic, strong) NSString *expirationBuf;
//UniMag
@property (readonly, nonatomic) uniMag *uniReader;
@end
