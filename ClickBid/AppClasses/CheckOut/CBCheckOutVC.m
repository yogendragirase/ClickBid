//
//  CBCheckOutVC.m
//  ClickBid
//
//  Created by Pushpendra on 07/05/16.
//  Copyright © 2016 Syscraft. All rights reserved.
//

#import "CBCheckOutVC.h"
#import "CBHeader.h"
#import "CustomKeyboard.h"
#import "BraintreeUI.h"


@interface CBCheckOutVC ()<IQActionSheetPickerViewDelegate,CustomKeyboardDelegate,UITextFieldDelegate,LTHMonthYearPickerViewDelegate,BTDropInViewControllerDelegate,AuthNetDelegate>
{
    CustomKeyboard *keyBoard;
    LTHMonthYearPickerView *monthYearPicker;
    NSDictionary *dictForUse;
}
@end

@implementation CBCheckOutVC
@synthesize CB_textFields;

#pragma mark viewDidLoad

- (void)viewDidLoad {
    [super viewDidLoad];
    
    phoneNumberFormatter = [[CHRTextFieldFormatter alloc] initWithTextField:CB_TxtPhone mask:[CHRPhoneNumberMask new]];
    cardNumberFormatter = [[CHRTextFieldFormatter alloc] initWithTextField:CB_TxtCardNo mask:[CHRCardNumberMask new]];
    [self CB_CallWebserviceForBidderId:[self.dictData valueForKey:@"id"]];

}

#pragma mark viewWillAppear
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //Set navigation Bar
    [self CB_ShowNavigationBar];
    //Set Back Buttonm
    [self CB_SetNavigationBackButtonImage];
    [self CB_TextFieldsOPlaceHolderColor:CB_textFields];
    [self CB_TextFieldsOPlaceHolderColor:@[CB_TxtExpirayDate,CB_TxtPaymentType]];
    self.title = @"CheckOut";
    [self setTextFieldTag];
}
#pragma mark WebService Call For Bidder Detail
-(void)CB_CallWebserviceForBidderId:(NSString *)strID
{
    [self CB_ShowLoaderOnView];
    NSString *strUrl = [NSString stringWithFormat:@"http://clickbid.cc/cbapi/butler-bidder/%@",strID];
    [CBAPIManager GetRequestToApiUrl:strUrl WithSuccess:^(id response) {
        NSLog(@"response---->%@",response);
        [self CB_HideLoderOnView];
        if (response!=nil)
        {
            dictForUse = [response valueForKey:@"data"];
            [self CB_SetValueForOutlets:dictForUse];
        }else
        {
            [self CB_ShowAlertWithTitle:@"Alert" andMessage:@"Server not getting responce"];
        }
        
    } failure:^(NSError *error) {
        [self CB_HideLoderOnView];
        [self CB_ShowAlertWithTitle:@"Alert" andMessage:@"Something went wrong, please try agin later"];
        NSLog(@"Reason---->%@",error.localizedFailureReason);
        NSLog(@"Suggestion---->%@",error.localizedRecoverySuggestion);
        NSLog(@"Desc---->%@",error.localizedDescription);
    }];
}

#pragma mark Set Value For Outlets
-(void)CB_SetValueForOutlets:(NSDictionary *)Dict
{
    NSLog(@"%@",self.dictData);
    if ([CBUtility CB_CheckStringForNullValue:[Dict valueForKey:@"first_name"]]) {
        CB_TxtFirstName.text =[Dict valueForKey:@"first_name"];
    }
    if ([CBUtility CB_CheckStringForNullValue:[Dict valueForKey:@"last_name"]])
    {
        CB_TxtLastName.text =[Dict valueForKey:@"last_name"];
    }
    if ([CBUtility CB_CheckStringForNullValue:[Dict valueForKey:@"phone"]])
    {
        if ([[Dict valueForKey:@"phone"] isKindOfClass:[NSArray class]])
        {
            NSString *strPhone= [CBUtility CB_StringToPhoneformatArray:[Dict valueForKey:@"phone"]];
            CB_TxtPhone.text = strPhone;
        }
        else
        {
            if (![[Dict valueForKey:@"phone"] isEqualToString:@""]) {
                NSString *strPhone = [CBUtility CB_StringToPhoneformat:[Dict valueForKey:@"phone"]];
                CB_TxtPhone.text =strPhone;
            }
        }
    }
    if ([CBUtility CB_CheckStringForNullValue:[Dict valueForKey:@"email"]])
    {
        if ([[Dict valueForKey:@"email"] isKindOfClass:[NSArray class]])
        {
            NSMutableArray *array = [Dict valueForKey:@"email"];
            NSString *strEmail= [array componentsJoinedByString:@", "];
            Cb_TxtEmail.text = strEmail;
            
        }else
        {
            if (![[Dict valueForKey:@"email"] isEqualToString:@""])
            {
                Cb_TxtEmail.text =[NSString stringWithFormat:@"%@",[Dict valueForKey:@"email"]];
            }
        }
    }
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated]; CGFloat height = 0.0;
    CGRect rect = CB_ViewFooter.frame;
    
    if(IS_IPHONE4)
    {
    height = rect.size.height;
    }
   else if(IS_IPHONE5)
    {
        height = rect.size.height;
    }
   else  if(IS_IPHONE6)
    {
        height = rect.size.height+140;
    }
   else if(IS_IPHONE6plus)
    {
        height = rect.size.height+220;
    }
    CGRect newFrame = CGRectMake(rect.origin.x, rect.origin.y, rect.size.width,height);
    CB_ViewFooter.frame = newFrame;
    NSLog(@"%@",NSStringFromCGRect(CB_ViewFooter.frame));
    self.tableView.tableFooterView = CB_ViewFooter;
}

#pragma mark TextFieldTag
-(void)setTextFieldTag
{
    keyBoard = [[CustomKeyboard alloc] init];
    keyBoard.delegate = self;
    //TextField Tag
    CB_TxtFirstName.tag = 11;
    CB_TxtLastName.tag = 12;
    CB_TxtCardNo.tag =13;
    CB_TxtCVV.tag = 14;
    CB_TxtPhone.tag = 15;
     Cb_TxtEmail.tag = 16;
    for (UITextField *text in CB_textFields) {
        text.delegate = self;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
#pragma mark PaymentTypeAction
- (IBAction)CB_BtnPaymentTypeAction:(UIButton *)sender {
    [self.view endEditing:YES];
    IQActionSheetPickerView *picker = [[IQActionSheetPickerView alloc] initWithTitle:@"Select Payment Type" delegate:self];
    picker.backgroundColor = [UIColor lightGrayColor];
    picker.titleFont = [UIFont systemFontOfSize:12];
    picker.titleColor = [UIColor redColor];
    [picker setTag:1];
    [picker setTitlesForComponents:@[@[@"Credit Card", @"Debit Card"]]];
    [picker show];
}
#pragma mark SwipeAction
- (IBAction)BtnSwipeAction:(id)sender {
}
#pragma mark Authorize.net Swipe Credit Card And get Data
-(void)CB_SwipeCreditCardAuthorize
{
    AuthNet *an = [AuthNet getInstance];
    [an setDelegate:self];
    SwiperDataType *st = [SwiperDataType swiperDataType];
    st.encryptedValue = @"02f700801f4725008383252a343736312a2a2a2a2a2a2a2a303031305e56495341204143515549524552205445535420434152442030355e313531322a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a3f2a3b343736312a2a2a2a2a2a2a2a303031303d313531322a2a2a2a2a2a2a2a2a2a2a2a2a3f2aef80a083368880ae9515cdef8bb2ac7991d781a76f02939576605a6709762b6972b2be3a5b744f7dacffe1b276c18ba266040e749f717e2e80fdbe60164200fb056bcee846947adc9a7dd10c0a81be0c90b2674a61bbb6d3f3167170c97ed30ead1215ea1636fb8fd1e2e7e594c44aa95431323438303237373162994901000003e00181394903";
    st.deviceDescription = @"4649443d4944544543482e556e694d61672e416e64726f69642e53646b7631";
    st.encryptionType = @"TDES";
    PaymentType *paymentType = [PaymentType paymentType];
    paymentType.swiperData = st;
    TransRetailInfoType *retailInfo = [TransRetailInfoType transRetailInfoType];
    retailInfo.marketType = @"2";
    retailInfo.deviceType = @"7";
        ExtendedAmountType *extendedAmountTypeTax = [ExtendedAmountType extendedAmountType];
    extendedAmountTypeTax.amount = @"0";
    extendedAmountTypeTax.name = @"Tax";
    
    ExtendedAmountType *extendedAmountTypeShipping = [ExtendedAmountType extendedAmountType];
    extendedAmountTypeShipping.amount = @"0";
    extendedAmountTypeShipping.name = @"Shipping";
    
    LineItemType *lineItem = [LineItemType lineItem];
    lineItem.itemName = @"Soda";
    lineItem.itemDescription = @"Soda";
    lineItem.itemQuantity = @"1";
    lineItem.itemPrice = @"1.00";
    lineItem.itemID = @"1";
    
    TransactionRequestType *requestType = [TransactionRequestType transactionRequest];
    requestType.lineItems = [NSMutableArray arrayWithObject:lineItem];
    requestType.amount = @"20.00";
    requestType.tax = extendedAmountTypeTax;
    requestType.payment = paymentType;
    requestType.shipping = extendedAmountTypeShipping;
    requestType.retail = retailInfo;
    
    
    CreateTransactionRequest *request = [CreateTransactionRequest createTransactionRequest];
    request.transactionRequest = requestType;
    request.anetApiRequest.merchantAuthentication.mobileDeviceId = @"358347040811237";
    request.anetApiRequest.merchantAuthentication.sessionToken = _sessionToken;
    
    [an purchaseWithRequest:request];
}
#pragma mark ActionExpiryDate
- (IBAction)CB_BtnActionExpiryDate:(id)sender {
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    [dateFormatter setDateFormat:@"MM / yyyy"];
    NSDate *initialDate = [dateFormatter dateFromString:[NSString stringWithFormat: @"%i / %i", 3, 2015]];
    NSDate *maxDate = [dateFormatter dateFromString:[NSString stringWithFormat: @"%i / %i", 3, 2115]];
        monthYearPicker = [[LTHMonthYearPickerView alloc]
                       initWithDate: initialDate
                       shortMonths: NO
                       numberedMonths: NO
                       andToolbar: YES
                       minDate:[NSDate date]
                       andMaxDate:maxDate];
    monthYearPicker.delegate = self;
    CB_TxtExpirayDate.inputView = monthYearPicker;
    [CB_TxtExpirayDate becomeFirstResponder];
}
#pragma mark PayNowAction
- (IBAction)CB_BtnPayNowAction:(id)sender {
    //[self CB_getBraintreeClientTokenFromServer];
    if ([CBUtility Trim:CB_TxtPaymentType.text].length ==0) {
        [self CB_ShowAlertWithTitle:@"Alert" andMessage:@"Please select payment type."];
        return;
    }else if ([CBUtility Trim:CB_TxtFirstName.text].length == 0)
    {
        [self CB_ShowAlertWithTitle:@"Alert" andMessage:@"Please enter first name."];
        return;
    }
    else if ([CBUtility Trim:CB_TxtLastName.text].length == 0)
    {
        [self CB_ShowAlertWithTitle:@"Alert" andMessage:@"Please enter last name."];
        return;
    }
    else if ([CBUtility Trim:CB_TxtCardNo.text].length == 0)
    {
        [self CB_ShowAlertWithTitle:@"Alert" andMessage:@"Please enter card number."];
        return;
    }
    else if ([CBUtility Trim:CB_TxtCVV.text].length == 0)
    {
        [self CB_ShowAlertWithTitle:@"Alert" andMessage:@"Please enter CVV number."];
        return;
    }
    else if ([CBUtility Trim:CB_TxtExpirayDate.text].length == 0)
    {
        [self CB_ShowAlertWithTitle:@"Alert" andMessage:@"Please select expiry date."];
        return;
    }
    else if ([CBUtility Trim:CB_TxtPhone.text].length == 0)
    {
        [self CB_ShowAlertWithTitle:@"Alert" andMessage:@"Please enter phone number."];
        return;
    }
    else if ([CBUtility Trim:Cb_TxtEmail.text].length == 0)
    {
        [self CB_ShowAlertWithTitle:@"Alert" andMessage:@"Please enter email."];
        return;
    }
    else if (![CBUtility CB_ValidateEmailSting:Cb_TxtEmail.text])
    {
        [self CB_ShowAlertWithTitle:@"Alert" andMessage:@"Please enter a valid email."];
        return;
    }
else
{
    NSString *strPhone=[CB_TxtPhone.text stringByReplacingOccurrencesOfString:@"-" withString:@""];
    NSString *newString = [strPhone stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSString *strEmail= Cb_TxtEmail.text;
    NSString *trimmedString=[CB_TxtCardNo.text substringFromIndex:MAX((int)[CB_TxtCardNo.text length]-4, 0)];
    
    NSDictionary *dictParam = @{@"first_name":CB_TxtFirstName.text,@"last_name":CB_TxtLastName.text,@"phone":newString,@"email":strEmail,@"company":[dictForUse valueForKey:@"company"],@"table_name":[dictForUse valueForKey:@"table_name"],@"ccs_last_four":trimmedString,@"customer_profile_id":[dictForUse valueForKey:@"customer_profile_id"],@"customer_payment_id":@"0",@"beanstream_id":@"",@"last_four":@"",@"pay_type_id":@"1"};
    [self CB_CallWebserviceForPayment:dictParam];
    
}
}

#pragma mark Call Webservice For Payment
-(void)CB_CallWebserviceForPayment:(NSDictionary *)DictParam
{
    [self CB_ShowLoaderOnView];
    NSString *strUrl = [NSString stringWithFormat:@"https://clickbid.cc/cbapi/butler-biddercheckout/%@/%@",[CB_UserDefault valueForKey:CB_KeyDefaultEventID],[self.dictData valueForKey:@"bidder_number"]];
    [CBAPIManager PostRequestToApiUrl:strUrl WithParam:DictParam WithSuccess:^(id response) {
        [self CB_HideLoderOnView];
        NSDictionary *dictRes = [response valueForKey:@"data"];
        if ([dictRes valueForKey:@"ERROR"] != nil) {
        [self CB_ShowAlertWithTitle:@"Alert" andMessage:[dictRes valueForKey:@"ERROR"]];
        }
        else
        {
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Message" message:[dictRes valueForKey:@"SUCCESS"] preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                CBSearchResultsVC *obj = [self.storyboard instantiateViewControllerWithIdentifier:CBKey_StoryBoardId_SearchResult];
                [self.navigationController pushViewController:obj animated:YES];
            }];
            [alertController addAction:ok];
            [self presentViewController:alertController animated:YES completion:nil];
        }
        NSLog(@"%@",response);
    } failure:^(NSError *error) {
        [self CB_HideLoderOnView];
        NSLog(@"%@",error.localizedDescription);
    }];
    
}
#pragma  mark  Text Field Delegate methods

#pragma mark UITextField Delegate With @"MM/YYYY"
static NSString* __placeholderText = @"MM/YYYY";
static NSCharacterSet* __nonNumbersSet;
- (BOOL) textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField==CB_TxtExpirayDate)
    {
        // Make sure that the non number set is lazily initialized
        if (__nonNumbersSet == nil)
            __nonNumbersSet = [[NSCharacterSet characterSetWithCharactersInString:@"0123456789"] invertedSet];
        NSString* preEditString = textField.text;
        __block NSInteger activeLength = 0;
        NSAttributedString* attributedString = CB_TxtExpirayDate.attributedText;
        [attributedString enumerateAttribute:NSForegroundColorAttributeName inRange:NSMakeRange(0, attributedString.length) options:NSAttributedStringEnumerationLongestEffectiveRangeNotRequired usingBlock:^(id value, NSRange range, BOOL *stop) {
            if ([value isKindOfClass:[UIColor class]])
            {
                CGFloat white;
                [((UIColor*)value) getWhite:&white alpha:nil];
                if (white != 1.0f)
                    activeLength = range.location;
            }
        }];
        // If there is no pseudo placeholder text then that means it has reached the end
        if (activeLength == 0 &&
            CB_TxtExpirayDate.text.length == 7 &&
            ![CB_TxtExpirayDate.text isEqualToString:__placeholderText])
        {
            activeLength = CB_TxtExpirayDate.text.length;
        }
        // Perform the edits as long as the birthday text length limit hasnt been reached
        if (!(activeLength == 7 && string.length > 0))
        {
            if (string.length <= 0)
            {
                if (textField.text.length > 0)
                {
                    NSInteger deleteDelta = [[textField.text substringWithRange:NSMakeRange(activeLength-1, 1)] isEqualToString:@"/"] ? 2 : 1;
                    if (activeLength <= deleteDelta)
                    {
                        [CB_TxtExpirayDate setText:@""];
                        return NO;
                    }
                    else
                        [CB_TxtExpirayDate setText:[NSString stringWithFormat:@"%@", [CB_TxtExpirayDate.text substringToIndex:(activeLength - deleteDelta)]]];
                }
            }
            
            else if ([string rangeOfCharacterFromSet:__nonNumbersSet].location == NSNotFound)
            {
                if (activeLength < 3)
                {
                    // Handle the day aspect of the birthday input
                    if (activeLength == 0)
                    {
                        if ([string isEqualToString:@"0"] || [string isEqualToString:@"1"])
                        {
                            [CB_TxtExpirayDate setText:[NSString stringWithFormat:@"%@%@", [CB_TxtExpirayDate.text substringToIndex:activeLength], string]];
                        }
                        else
                        {
                            [CB_TxtExpirayDate setText:[NSString stringWithFormat:@"%@0%@/", [CB_TxtExpirayDate.text substringToIndex:activeLength], string]];
                        }
                    }
                    else if (activeLength == 1)
                    {
                        [CB_TxtExpirayDate setText:[NSString stringWithFormat:@"%@%@/", [CB_TxtExpirayDate.text substringToIndex:activeLength], string]];
                    }
                }
                else if (activeLength < 8)
                {
                    // Handle the year aspect of the birthday input
                    BOOL addText;
                    if (activeLength == 3)
                    {
                        // Only allow for 19XX or 2XXX dates
                        // addText = ([string isEqualToString:@"2"]) ? YES : NO;
                        addText =YES;
                    }
                    
                    else
                        addText = YES;
                    
                    if (addText)
                        [CB_TxtExpirayDate setText:[NSString stringWithFormat:@"%@%@", [CB_TxtExpirayDate.text substringToIndex:activeLength], string]];
                }
            }
            
            if (![textField.text isEqualToString:preEditString])
            {
                NSInteger offset = textField.text.length;
                NSMutableAttributedString* pseudoPlaceholder = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@%@", textField.text, [__placeholderText substringFromIndex:(__placeholderText.length-(__placeholderText.length-textField.text.length))]] attributes:nil];
                
                [pseudoPlaceholder addAttribute:NSForegroundColorAttributeName
                                          value:[UIColor colorWithWhite:.7843 alpha:1.0f]
                                          range:NSMakeRange(textField.text.length, pseudoPlaceholder.string.length - textField.text.length)];
                
                [textField setAttributedText:pseudoPlaceholder];
                [textField setSelectedTextRange:[textField textRangeFromPosition:[textField positionFromPosition:textField.beginningOfDocument offset:offset] toPosition:[textField positionFromPosition:textField.beginningOfDocument offset:offset]]];
            }
        }
        return NO;
    }
    else if (textField == CB_TxtPhone) {
        
        return [phoneNumberFormatter textField:textField shouldChangeCharactersInRange:range replacementString:string];
        
    } else if (textField == CB_TxtCardNo) {
        NSString *searchText = [textField.text stringByReplacingCharactersInRange:range withString:string];
        if (searchText.length<=19){
            
            return [cardNumberFormatter textField:textField shouldChangeCharactersInRange:range replacementString:string];
        }
        else{
            
            return NO;
        }
        
    }
    else if (textField==CB_TxtCVV){
        NSString *searchText = [textField.text stringByReplacingCharactersInRange:range withString:string];
        
        if (searchText.length<=4)
        {
            CBLog(@"%lu",(unsigned long)searchText.length);
        }
        else{
            CBLog(@"%lu",(unsigned long)searchText.length);
            return NO;
        }
    }
    return YES;
}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    
    if (CB_TxtFirstName==textField){
        
        [textField setInputAccessoryView:[keyBoard getToolbarWithPrevNextDone:NO :YES]];
        keyBoard.currentSelectedTextboxIndex = textField.tag;
    }
    else if (CB_TxtLastName==textField) {
        
        [textField setInputAccessoryView:[keyBoard getToolbarWithPrevNextDone:YES :YES]];
        keyBoard.currentSelectedTextboxIndex = textField.tag;
    }
    else if (CB_TxtCardNo==textField) {
        
        [textField setInputAccessoryView:[keyBoard getToolbarWithPrevNextDone:YES :YES]];
        keyBoard.currentSelectedTextboxIndex = textField.tag;
    }
    else if (CB_TxtCVV==textField)
    {
        [textField setInputAccessoryView:[keyBoard getToolbarWithPrevNextDone:YES :YES]];
        keyBoard.currentSelectedTextboxIndex = textField.tag;
    }
    else if (CB_TxtPhone==textField)
    {
        [textField setInputAccessoryView:[keyBoard getToolbarWithPrevNextDone:YES :YES]];
        keyBoard.currentSelectedTextboxIndex = textField.tag;
    }
    else if (Cb_TxtEmail==textField)
    {
        [textField setInputAccessoryView:[keyBoard getToolbarWithPrevNextDone:YES :NO]];
        keyBoard.currentSelectedTextboxIndex = textField.tag;
    }
    
    return YES;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark Custom Keyboard Delegate

- (void)nextClicked:(NSUInteger)sender{
    
    for (int i =0; i<CB_textFields.count; i++) {
        UITextField *text =[CB_textFields objectAtIndex:i];
        if (sender == text.tag) {
            UITextField *textBecome =[CB_textFields objectAtIndex:i+1];
            [textBecome becomeFirstResponder];
        }
    }
}
- (void)previousClicked:(NSUInteger)sender{
    
    for (int i =0; i<CB_textFields.count; i++) {
        UITextField *text =[CB_textFields objectAtIndex:i];
        
        if (sender == text.tag) {
            
            UITextField *textBecome =[CB_textFields objectAtIndex:i-1];
            [textBecome becomeFirstResponder];
        }
    }
}
- (void)resignResponder:(NSUInteger)sender{
    
    [self.view endEditing:YES];
}
#pragma mark - LTHMonthYearPickerView Delegate
- (void)pickerDidPressCancelWithInitialValues:(NSDictionary *)initialValues {
    [CB_TxtExpirayDate resignFirstResponder];
}
- (void)pickerDidPressDoneWithMonth:(NSString *)month andYear:(NSString *)year {
   CB_TxtExpirayDate.text = [NSString stringWithFormat: @"%@ - %@", month, year];
    [CB_TxtExpirayDate resignFirstResponder];
}
- (void)pickerDidPressCancel {
    [self.view endEditing:YES];
    [CB_TxtExpirayDate resignFirstResponder];
}

- (void)pickerDidSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    CBLog(@"row: %zd in component: %zd", row, component);
}
- (void)pickerDidSelectMonth:(NSString *)month {
    CBLog(@"month: %@ ", month);
}
- (void)pickerDidSelectYear:(NSString *)year {
    CBLog(@"year: %@ ", year);
}
- (void)pickerDidSelectMonth:(NSString *)month andYear:(NSString *)year {
    //  _dateTextField.text = [NSString stringWithFormat: @"%@ / %@", month, year];
}
#pragma mark IQActionpickerview Delegate Methods

- (void)actionSheetPickerView:(IQActionSheetPickerView *)pickerView didSelectTitles:(NSArray*)titles{
    
    CB_TxtPaymentType.text = [titles componentsJoinedByString:@" - "];
    
}
- (void)actionSheetPickerView:(IQActionSheetPickerView *)pickerView didSelectDate:(NSDate*)date{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterNoStyle];
    //CB_TxtExpirayDate.text =[formatter stringFromDate:date];
    
}
- (void)actionSheetPickerView:(IQActionSheetPickerView *)pickerView didChangeRow:(NSInteger)row inComponent:(NSInteger)component{
    
}
- (void)actionSheetPickerViewDidCancel:(IQActionSheetPickerView *)pickerView{
    
}

- (void)actionSheetPickerViewWillCancel:(IQActionSheetPickerView *)pickerView{
    
}
#pragma mark:-Table view Delegate and DataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 8;
}
// Cell For Row at IndexPath
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CBCheckOutCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CBCheckOutCell" forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[CBCheckOutCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CBCheckOutCell"];
    }
    cell.lblItem.text = [NSString stringWithFormat:@"Bidder #%ld",(long)indexPath.row];
    cell.lblPrice.text = @"$50";
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    //Setting properties and Btn Action methods
    return cell;
}
#pragma mark BrainTree :-
#pragma mark Get Client Token from Server
-(void)CB_getBraintreeClientTokenFromServer
{
    NSString *strUrl = [NSString stringWithFormat:@"https://clickbid.cc/cbapi/butler-biddercheckout/%@/%@",[CB_UserDefault valueForKey:CB_KeyDefaultEventID],[self.dictData valueForKey:@"id"]];
    [CBAPIManager GetRequestToApiUrl:strUrl WithSuccess:^(id response) {
        NSLog(@"%@",response);
        if (response != nil ) {
            NSDictionary *dictRes = [response valueForKey:@"data"];
            if ([dictRes valueForKey:@"braintree_token"]!= nil) {
                [self CB_InitializeBraintreeAndNavigatePaymentWindow:[dictRes valueForKey:@"braintree_token"]];
            }
        }
    } failure:^(NSError *error) {
        NSLog(@"errrorr---->%@",error.localizedDescription);
        
    }];
}
#pragma mark Initialize Client Token And Open Braintree Window
-(void)CB_InitializeBraintreeAndNavigatePaymentWindow:(NSString *)StrToken
{
    self.braintreeClient = [[BTAPIClient alloc] initWithAuthorization:StrToken];
    BTDropInViewController *dropInViewController = [[BTDropInViewController alloc]
                                                    initWithAPIClient:self.braintreeClient];
    dropInViewController.delegate = self;
    // This is where you might want to customize your view controller (see below)
    // The way you present your BTDropInViewController instance is up to you.
    // In this example, we wrap it in a new, modally-presented navigation controller:
    UIBarButtonItem *item = [[UIBarButtonItem alloc]
                             initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                             target:self
                             action:@selector(userDidCancelPayment)];
    dropInViewController.navigationItem.leftBarButtonItem = item;
    UINavigationController *navigationController = [[UINavigationController alloc]
                                                    initWithRootViewController:dropInViewController];
    [self presentViewController:navigationController animated:YES completion:nil];
}
#pragma mark Braintree Cancel Window
- (void)userDidCancelPayment {
    [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark Braintree Delegate Method
- (void)dropInViewController:(BTDropInViewController *)viewController
  didSucceedWithTokenization:(BTPaymentMethodNonce *)paymentMethodNonce {
    // Send payment method nonce to your server for processing
    [self CB_PostNonceToServer:paymentMethodNonce.nonce];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)dropInViewControllerDidCancel:(__unused BTDropInViewController *)viewController {
    [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark Post Nonce to the Server
-(void)CB_PostNonceToServer:(NSString *)StrNonce
{
    
}
#pragma mark Authorize.Net:-
#pragma mark Initialize Authorize SDK
-(void)CB_IniTializeAuthorizeSDKAndLoginGateway
{
    [AuthNet authNetWithEnvironment:ENV_TEST];
    MobileDeviceLoginRequest *mobileDeviceLoginRequest = [MobileDeviceLoginRequest mobileDeviceLoginRequest];
    UIDevice *device = [UIDevice currentDevice];
    NSString  *currentDeviceId = [[device identifierForVendor]UUIDString];
    mobileDeviceLoginRequest.anetApiRequest.merchantAuthentication.mobileDeviceId =currentDeviceId;
    mobileDeviceLoginRequest.anetApiRequest.merchantAuthentication.name =@"pushpendra123";
    mobileDeviceLoginRequest.anetApiRequest.merchantAuthentication.password =@"Pushpendra@123";
    AuthNet *an = [AuthNet getInstance];
    [an setDelegate:self];
    [an mobileDeviceLoginRequest: mobileDeviceLoginRequest];
}

#pragma mark Pay Amount By Authorize SDK With Detail
-(void)CB_PayByAuthorizeSdk
{
    if (![CreditCardType isValidCreditCardNumber:self.creditCardBuf]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                        message:NSLocalizedString(@"Please enter a valid card number.", @"")
                                                       delegate:self
                                              cancelButtonTitle:NSLocalizedString(@"OK", @"")
                                              otherButtonTitles:nil];
        [alert setTag:kCardNumberErrorAlert];
        [alert show];
        
        return;
    }

}
#pragma mark Save Card Info For Authorize.net
- (void) saveCreditCardInfo {
    AuthNet *an = [AuthNet getInstance];
    [an setDelegate:self];
    CreditCardType *c = [CreditCardType creditCardType];
    c.cardNumber = self.creditCardBuf;
    c.expirationDate = [CB_TxtExpirayDate.text stringByReplacingOccurrencesOfString:kSlash withString:@""];
    if ([CB_TxtCVV.text length]) {
        c.cardCode = [NSString stringWithString:CB_TxtCVV.text];
    }
   // CustomerAddressType *b = [CustomerAddressType customerAddressType];
//    if ([self.zipTextField.text length]) {
//        b.zip = [NSString stringWithString:self.zipTextField.text];
//    }
//    
    PaymentType *paymentType = [PaymentType paymentType];
    paymentType.creditCard = c;
    ExtendedAmountType *extendedAmountTypeTax = [ExtendedAmountType extendedAmountType];
    extendedAmountTypeTax.amount = @"0";
    extendedAmountTypeTax.name = @"Tax";
    ExtendedAmountType *extendedAmountTypeShipping = [ExtendedAmountType extendedAmountType];
    extendedAmountTypeShipping.amount = @"0";
    extendedAmountTypeShipping.name = @"Shipping";
    LineItemType *lineItem = [LineItemType lineItem];
    lineItem.itemName = @"Soda";
    lineItem.itemDescription = @"Soda";
    lineItem.itemQuantity = @"1";
    lineItem.itemPrice = @"1.00";
    lineItem.itemID = @"1";
    TransactionRequestType *requestType = [TransactionRequestType transactionRequest];
    requestType.lineItems = [NSMutableArray arrayWithObject:lineItem];
    requestType.amount = @"20.00";
    requestType.payment = paymentType;
    requestType.tax = extendedAmountTypeTax;
    requestType.shipping = extendedAmountTypeShipping;
    CreateTransactionRequest *request = [CreateTransactionRequest createTransactionRequest];
    request.transactionRequest = requestType;
    UIDevice *device = [UIDevice currentDevice];
    NSString  *currentDeviceId = [[device identifierForVendor]UUIDString];
    request.anetApiRequest.merchantAuthentication.mobileDeviceId = currentDeviceId;
    request.anetApiRequest.merchantAuthentication.sessionToken = _sessionToken;
    [an purchaseWithRequest:request];
}

#pragma mark -
#pragma mark - AuthNetDelegate Methods
- (void)paymentSucceeded:(CreateTransactionResponse*)response {
    
    NSLog(@"Payment Success ********************** ");
    
    NSString *title = @"Successfull Transaction";
    NSString *alertMsg = nil;
    UIAlertView *PaumentSuccess = nil;
    
    TransactionResponse *transResponse = response.transactionResponse;
    
    alertMsg = [response responseReasonText];
    NSLog(@"%@",response.responseReasonText);
    
    if ([transResponse.responseCode isEqualToString:@"4"])
    {
        PaumentSuccess = [[UIAlertView alloc] initWithTitle:title message:alertMsg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:@"LOGOUT",nil];
    }
    else
    {
        PaumentSuccess = [[UIAlertView alloc] initWithTitle:title message:@"Message" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil,nil];
    }
    [PaumentSuccess show];
    
}

- (void)paymentCanceled {
    
    NSLog(@"Payment Canceled ********************** ");
}

-(void) requestFailed:(AuthNetResponse *)response {
    
    NSLog(@"Request Failed ********************** ");
    
    NSString *title = nil;
    NSString *alertErrorMsg = nil;
    UIAlertView *alert = nil;
    
    
    if ( [response errorType] == SERVER_ERROR)
    {
        title = NSLocalizedString(@"Server Error", @"");
        alertErrorMsg = [response responseReasonText];
    }
    else if([response errorType] == TRANSACTION_ERROR)
    {
        title = NSLocalizedString(@"Transaction Error", @"");
        alertErrorMsg = [response responseReasonText];
    }
    else if([response errorType] == CONNECTION_ERROR)
    {
        title = NSLocalizedString(@"Connection Error", @"");
        alertErrorMsg = [response responseReasonText];
    }
    
    Messages *ma = response.anetApiResponse.messages;
    
    AuthNetMessage *m = [ma.messageArray objectAtIndex:0];
    
    NSLog(@"Response Msg Array Count: %lu", (unsigned long)[ma.messageArray count]);
    
    NSLog(@"Response Msg Code %@ ", m.code);
    
    NSString *errorCode = [NSString stringWithFormat:@"%@",m.code];
    NSString *errorText = [NSString stringWithFormat:@"%@",m.text];
    
    NSString *errorMsg = [NSString stringWithFormat:@"%@ : %@", errorCode, errorText];
    
    if (alertErrorMsg == nil) {
        alertErrorMsg = errorText;
    }
    
    NSLog(@"Error Code and Msg %@", errorMsg);
    
    
    if ( ([m.code isEqualToString:@"E00027"]) || ([m.code isEqualToString:@"E00007"]) || ([m.code isEqualToString:@"E00096"]))
    {
        
        alert = [[UIAlertView alloc] initWithTitle:title
                                           message:alertErrorMsg
                                          delegate:self
                                 cancelButtonTitle:NSLocalizedString(@"OK", @"")
                                 otherButtonTitles:nil];
    }
    else if ([m.code isEqualToString:@"E00008"]) // Finger Print Value is not valid.
    {
        alert = [[UIAlertView alloc] initWithTitle:@"Authentication Error"
                                           message:errorText
                                          delegate:self
                                 cancelButtonTitle:NSLocalizedString(@"OK", @"")
                                 otherButtonTitles:nil];
    }
    else
    {
        alert = [[UIAlertView alloc] initWithTitle:title
                                           message:alertErrorMsg
                                          delegate:self
                                 cancelButtonTitle:NSLocalizedString(@"OK", @"")
                                 otherButtonTitles:nil];
    }
    [alert show];
    return;
}

- (void) connectionFailed:(AuthNetResponse *)response {
    NSLog(@"%@", response.responseReasonText);
    NSLog(@"Connection Failed");
        NSString *title = nil;
    NSString *message = nil;
    
    if ([response errorType] == NO_CONNECTION_ERROR)
    {
        title = NSLocalizedString(@"No Signal", @"");
        message = NSLocalizedString(@"Unable to complete your request. No Internet connection.", @"");
    }
    else
    {
        title = NSLocalizedString(@"Connection Error", @"");
        message = NSLocalizedString(@"A connection error occurred.  Please try again.", @"");
    }
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                    message:message
                                                   delegate:nil cancelButtonTitle:NSLocalizedString(@"OK",@"") otherButtonTitles:nil];
    alert.delegate = self;
    [alert show];
    
}

-(void)logoutSucceeded:(LogoutResponse *)response{
    NSLog(@"Logout Success ********************** ");
}

// MOBILE DELEGATE METHODS
/**
 * Optional delegate: method is called when a MobileDeviceLoginResponse response is returned from the server,
 * including MobileDeviceLoginResponse error responses.
 */
- (void) mobileDeviceLoginSucceeded:(MobileDeviceLoginResponse *)response{
    NSLog(@"ViewController : mobileDeviceLoginSucceeded - %@",response);
    _sessionToken = response.sessionToken;
    //    CardVC *creditCardView = (CardVC *)[self.storyboard instantiateViewControllerWithIdentifier:@"CardVC"];
    //    creditCardView.sessionToken = _sessionToken;
    //    [self presentViewController:creditCardView animated:YES completion:nil];
}


@end
