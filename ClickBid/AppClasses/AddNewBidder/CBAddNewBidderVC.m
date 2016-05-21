//
//  CBAddNewBidderVC.m
//  ClickBid
//
//  Created by Pushpendra on 06/05/16.
//  Copyright © 2016 Syscraft. All rights reserved.
//
#import "CBAddNewBidderVC.h"
#import "CBHeader.h"

@interface CBAddNewBidderVC ()<IQActionSheetPickerViewDelegate,CustomKeyboardDelegate,UITextFieldDelegate,LTHMonthYearPickerViewDelegate>
{
    NSDictionary *dictForUse;
    NSString *strCheckWelcome,*strCheckPassword;
}
/*
 For Secure Card Number Entry
  @property NSString * theActualText;
 @property NSInteger numberOfCharactersToObscure;
 numberOfCharactersToObscure = 15;
 - (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
 {
 NSLog(@"%@",self.theActualText);
 self.theActualText = textField.text;
 self.theActualText = [self.theActualText stringByReplacingCharactersInRange:range withString:string];
 NSInteger obscureLength = self.theActualText.length > self.numberOfCharactersToObscure ? self.numberOfCharactersToObscure : self.theActualText.length;
 NSRange replaceRange = NSMakeRange(0, obscureLength);
 NSMutableString * replacementString = [NSMutableString new];
  for (int i = 0; i < obscureLength; i++) {
 [replacementString appendString:@"X"];
 }
  textField.text = [self.theActualText stringByReplacingCharactersInRange:replaceRange withString:replacementString];
 NSLog(@"%@",self.theActualText);
  return NO;
 }
 */
@end

@implementation CBAddNewBidderVC
@synthesize CB_textFields,CB_TableViewCells,CB_textFieldsPassword;

#pragma mark viewDidLoad
- (void)viewDidLoad {
    [super viewDidLoad];
    //Set Validation For Phone and Card Number
    cardNumberFormatter = [[CHRTextFieldFormatter alloc] initWithTextField:CB_TxtCardNo mask:[CHRCardNumberMask new]];
    [self setTextFieldTag];
}

#pragma mark viewWillAppear
-(void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    self.title = self.strTitle;
    if ([self.strTitle isEqualToString:@"New Bidder"]) {
        [CB_BtnEditUpdate setTitle:@"ADD" forState:UIControlStateNormal];
        if (self.strID != nil) {
             phoneNumberFormatter = [[CHRTextFieldFormatter alloc] initWithTextField:CB_TextPhone mask:[CHRPhoneNumberMask new]];
            [self CB_CallWebserviceForGuestId:self.strID];
        }
        strCheckWelcome = @"1";
        strCheckPassword = @"0";
        CB_imgCheckUncheckWelcomeText.image = [UIImage imageNamed:@"CB_iconCheck"];
        CB_ImgCheckUncheckPasswordRequired.image = [UIImage imageNamed:@"CB_iconUnCheck"];
    }
    else{
        [CB_BtnEditUpdate setTitle:@"UPDATE" forState:UIControlStateNormal];
        if (self.strID != nil) {
          
            [self CB_CallWebserviceForBidderId:self.strID];
        }
    }
    if (self.strID == nil) {
        phoneNumberFormatter = [[CHRTextFieldFormatter alloc] initWithTextField:CB_TextPhone mask:[CHRPhoneNumberMask new]];
    }
    else
    {
        CB_TextPhone.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    }
    [CB_TxtCardNo addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];

    //Set navigation Bar
    [self CB_ShowNavigationBar];
    //Set Back Buttonm
    [self CB_SetNavigationBackButtonImage];
    //TextField Place Holder Color
    [self CB_TextFieldsOPlaceHolderColor:CB_textFieldsPassword];
}
- (void)textFieldDidChange:(UITextField *)sender
{
    NSLog(@"%@",sender.text);
}
#pragma mark setTextFieldTag
-(void)setTextFieldTag{
    //Custom KeyBoard
    keyBoard = [[CustomKeyboard alloc] init];
    keyBoard.delegate = self;
    //TextField Tag
    CB_txtFirstName.tag = 11;
    CB_TxtLastName.tag = 12;
    CB_TextPhone.tag =13;
    CB_TextEmail.tag = 14;
    CB_TextCompany.tag = 15;
    CB_TxtTableNameNo.tag = 16;
    if ([strCheckPassword isEqualToString:@"1"]) {
        CB_TxtPassword.tag = 17;
        Cb_TextPasswordAgain.tag = 18;
        CB_TxtCardNo.tag = 19;
        CB_TxtCVV.tag = 20;
    }
    else
    {
        CB_TxtCardNo.tag = 17;
        CB_TxtCVV.tag = 18;
    }
    if ([strCheckPassword isEqualToString:@"1"]) {
        for (UITextField *text in CB_textFieldsPassword) {
            text.delegate = self;
        }
    }
    else
    {
        for (UITextField *text in CB_textFields) {
            text.delegate = self;
        }
    }
   
}
#pragma mark Set OutLet Values
-(void)CB_SetValueForOutlets:(NSDictionary *)Dict
{
    if ([CBUtility CB_CheckStringForNullValue:[Dict valueForKey:@"first_name"]]) {
        CB_txtFirstName.text =[Dict valueForKey:@"first_name"];
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
            CB_TextPhone.text = strPhone;
        }
        else
        {
            if (![[Dict valueForKey:@"phone"] isEqualToString:@""]) {
                NSString *strPhone = [CBUtility CB_StringToPhoneformat:[Dict valueForKey:@"phone"]];
                CB_TextPhone.text =strPhone;
            }
        }
    }
     if ([CBUtility CB_CheckStringForNullValue:[Dict valueForKey:@"email"]])
    {
        if ([[Dict valueForKey:@"email"] isKindOfClass:[NSArray class]])
        {
            NSMutableArray *array = [Dict valueForKey:@"email"];
            NSString *strEmail= [array componentsJoinedByString:@", "];
            CB_TextEmail.text = strEmail;

        }else
        {
             if (![[Dict valueForKey:@"email"] isEqualToString:@""])
             {
                 CB_TextEmail.text =[NSString stringWithFormat:@"%@",[Dict valueForKey:@"email"]];
             }
        }
    }
     if ([CBUtility CB_CheckStringForNullValue:[Dict valueForKey:@"company"]])
    {
        CB_TextCompany.text =[Dict valueForKey:@"company"];
    }
     if ([CBUtility CB_CheckStringForNullValue:[Dict valueForKey:@"table_name"]])
    {
        CB_TxtTableNameNo.text =[Dict valueForKey:@"table_name"];
    }
    /*
    else if ([self.strLast_name isKindOfClass:[NSNull class]]|| self.strLast_name==nil || [self.strLast_name isEqualToString:@"<null>"])
    {
        CB_TxtCardNo.text =[Dict valueForKey:@""];
    }
    else if ([self.strLast_name isKindOfClass:[NSNull class]]|| self.strLast_name==nil || [self.strLast_name isEqualToString:@"<null>"])
    {
        CB_TxtCVV.text =[Dict valueForKey:@""];
    }
     */
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark btnSwipeAction
- (IBAction)btnSwipeAction:(id)sender {
}

#pragma mark btnExpiryDateAction
- (IBAction)btnExpiryDateAction:(id)sender {
    // [self.view endEditing:YES];
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

#pragma mark btnAddAction

- (IBAction)btnAddAction:(id)sender {
    
    if ([CBUtility Trim:CB_txtFirstName.text].length==0){
        
        [self CB_ShowAlertWithTitle:@"Alert" andMessage:@"Please enter first name."];
        return;
    }
    else if ([CBUtility Trim:CB_TxtLastName.text].length==0){
        
        [self CB_ShowAlertWithTitle:@"Alert" andMessage:@"Please enter last name."];
        return;
    }
    else if ([CBUtility Trim:CB_TextPhone.text].length==0){
        
        [self CB_ShowAlertWithTitle:@"Alert" andMessage:@"Please enter phone number."];
        return;
    }
    else if ([CBUtility Trim:CB_TextEmail.text].length==0){
        
        [self CB_ShowAlertWithTitle:@"Alert" andMessage:@"Please enter email."];
        return;
    }
    else if (![CBUtility CB_ValidateEmailSting:CB_TextEmail.text])
    {
        [self CB_ShowAlertWithTitle:@"Alert" andMessage:@"Please enter a valid email."];
        return;
    }
    else if ([CBUtility Trim:CB_TextCompany.text].length==0){
        
        [self CB_ShowAlertWithTitle:@"Alert" andMessage:@"Please enter company."];
        return;
    }
    else if ([CBUtility Trim:CB_TxtTableNameNo.text].length==0){
        
        [self CB_ShowAlertWithTitle:@"Alert" andMessage:@"Please enter table name or number."];
        return;
    }
    else if ([self.strTitle isEqualToString:@"New Bidder"]&& [strCheckPassword isEqualToString:@"1"]&&[CBUtility Trim:CB_TxtPassword.text].length==0)
    {
         [self CB_ShowAlertWithTitle:@"Alert" andMessage:@"Please enter password."];
        return;
    }
        else if ([self.strTitle isEqualToString:@"New Bidder"]&& [strCheckPassword isEqualToString:@"1"]&&[CBUtility Trim:Cb_TextPasswordAgain.text].length==0)
        {
            [self CB_ShowAlertWithTitle:@"Alert" andMessage:@"Please enter password again."];

        }
        else if ([self.strTitle isEqualToString:@"New Bidder"]&& [strCheckPassword isEqualToString:@"1"]&&![Cb_TextPasswordAgain.text isEqualToString:CB_TxtPassword.text])
        {
            [self CB_ShowAlertWithTitle:@"Alert" andMessage:@"Password and again entered password should be same."];
            
        }
    else if ([CBUtility Trim:CB_TxtCardNo.text].length==0){
        
        [self CB_ShowAlertWithTitle:@"Alert" andMessage:@"Please enter card number."];
        return;
    }
    else if ([CBUtility Trim:CB_TxtCVV.text].length==0){
        
        [self CB_ShowAlertWithTitle:@"Alert" andMessage:@"Please enter CVV number."];
        return;
    }
    else if ([CBUtility Trim:CB_TxtExpirayDate.text].length==0){
        
        [self CB_ShowAlertWithTitle:@"Alert" andMessage:@"Please select expiray date."];
        return;
    }
    else{
         if ([self.strTitle isEqualToString:@"New Bidder"]) {
             if (self.strID != nil) {
                 NSString *strPhone=[CB_TextPhone.text stringByReplacingOccurrencesOfString:@"-" withString:@""];
                 NSString *newString = [strPhone stringByReplacingOccurrencesOfString:@" " withString:@""];
                 NSString *strEmail= CB_TextEmail.text;
                 NSString *trimmedString=[CB_TxtCardNo.text substringFromIndex:MAX((int)[CB_TxtCardNo.text length]-4, 0)];
                 NSDictionary *dictParam = @{@"guest":self.strID,@"first_name":[NSString stringWithFormat:@"%@",CB_txtFirstName.text],@"last_name":[NSString stringWithFormat:@"%@",CB_TxtLastName.text],@"accept_texts":strCheckWelcome,@"table_name":[NSString stringWithFormat:@"%@",CB_TxtTableNameNo.text],@"password_required":strCheckPassword,@"password":[NSString stringWithFormat:@"%@",CB_TxtPassword.text],@"ccs_last_four":trimmedString,@"company":[NSString stringWithFormat:@"%@",CB_TextCompany.text],@"phone":newString,@"email":strEmail,@"customer_profile_id":@"",@"payment_profile_id":@"",@"beanstream_id":@"",@"last_four":@""};
                                            // @"cvv":[NSString stringWithFormat:@"%@",CB_TxtCVV.text],@"expiration_date":[NSString stringWithFormat:@"%@",CB_TxtExpirayDate.text]};
                 [self CB_UpdateGuestButlerBidderInformationWithParams:dictParam];
             }
             else{
                 //Come from ADD Button New Bidder
                     NSString *strPhone=[CB_TextPhone.text stringByReplacingOccurrencesOfString:@"-" withString:@""];
                     NSString *newString = [strPhone stringByReplacingOccurrencesOfString:@" " withString:@""];
                     NSString *strEmail= CB_TextEmail.text;
                     NSString *trimmedString=[CB_TxtCardNo.text substringFromIndex:MAX((int)[CB_TxtCardNo.text length]-4, 0)];
                     NSDictionary *dictParam = @{@"first_name":[NSString stringWithFormat:@"%@",CB_txtFirstName.text],@"last_name":[NSString stringWithFormat:@"%@",CB_TxtLastName.text],@"accept_texts":strCheckWelcome,@"table_name":[NSString stringWithFormat:@"%@",CB_TxtTableNameNo.text],@"password_required":strCheckPassword,@"password":[NSString stringWithFormat:@"%@",CB_TxtPassword.text],@"ccs_last_four":trimmedString,@"company":[NSString stringWithFormat:@"%@",CB_TextCompany.text],@"phone":newString,@"email":strEmail,@"customer_profile_id":@"",@"payment_profile_id":@"",@"beanstream_id":@"",@"last_four":@""};
                     // @"cvv":[NSString stringWithFormat:@"%@",CB_TxtCVV.text],@"expiration_date":[NSString stringWithFormat:@"%@",CB_TxtExpirayDate.text]};
                     [self CB_UpdateGuestButlerBidderInformationWithParams:dictParam];
                 }
             
         }
        else
        {
           
            NSString *strPhone=[CB_TextPhone.text stringByReplacingOccurrencesOfString:@"-" withString:@""];
            NSString *newString = [strPhone stringByReplacingOccurrencesOfString:@" " withString:@""];
            NSString *strEmail= CB_TextEmail.text;
            NSString *trimmedString=[CB_TxtCardNo.text substringFromIndex:MAX((int)[CB_TxtCardNo.text length]-4, 0)];
            NSDictionary *dictParam = @{@"first_name":[NSString stringWithFormat:@"%@",CB_txtFirstName.text],@"last_name":[NSString stringWithFormat:@"%@",CB_TxtLastName.text],@"company":[NSString stringWithFormat:@"%@",CB_TextCompany.text],@"table_name":[NSString stringWithFormat:@"%@",CB_TxtTableNameNo.text],@"phone":newString,@"email":strEmail,@"ccs_last_four":trimmedString,@"customer_profile_id":@"",@"payment_profile_id":@"",@"beanstream_id":@"",@"last_four":@""};
            [self CB_UpdateButlerBidderInformationWithParams:dictParam];
        }
    }

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
    else if (textField == CB_TextPhone) {
         if (self.strID == nil)
         {
             return [phoneNumberFormatter textField:textField shouldChangeCharactersInRange:range replacementString:string];
         }
        
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
        
        if (searchText.length<=4){
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
    if (CB_txtFirstName==textField){
        [textField setInputAccessoryView:[keyBoard getToolbarWithPrevNextDone:NO :YES]];
        keyBoard.currentSelectedTextboxIndex = textField.tag;
    }
    else if (CB_TxtLastName==textField) {
        [textField setInputAccessoryView:[keyBoard getToolbarWithPrevNextDone:YES :YES]];
        keyBoard.currentSelectedTextboxIndex = textField.tag;
    }
    else if (CB_TextPhone==textField) {
        [textField setInputAccessoryView:[keyBoard getToolbarWithPrevNextDone:YES :YES]];
        keyBoard.currentSelectedTextboxIndex = textField.tag;
    }
    else if (CB_TextEmail==textField)
    {
        [textField setInputAccessoryView:[keyBoard getToolbarWithPrevNextDone:YES :YES]];
        keyBoard.currentSelectedTextboxIndex = textField.tag;
    }
    else if (CB_TextCompany==textField)
    {
        [textField setInputAccessoryView:[keyBoard getToolbarWithPrevNextDone:YES :YES]];
        keyBoard.currentSelectedTextboxIndex = textField.tag;
    }
    else if (CB_TxtTableNameNo==textField)
    {
        [textField setInputAccessoryView:[keyBoard getToolbarWithPrevNextDone:YES :YES]];
        keyBoard.currentSelectedTextboxIndex = textField.tag;
    }
    else if (CB_TxtPassword==textField && [strCheckPassword isEqualToString:@"1"])
    {
        [textField setInputAccessoryView:[keyBoard getToolbarWithPrevNextDone:YES :YES]];
        keyBoard.currentSelectedTextboxIndex = textField.tag;
    }
    else if (Cb_TextPasswordAgain==textField && [strCheckPassword isEqualToString:@"1"])
    {
        [textField setInputAccessoryView:[keyBoard getToolbarWithPrevNextDone:YES :YES]];
        keyBoard.currentSelectedTextboxIndex = textField.tag;
    }
    else if (CB_TxtCardNo==textField)
    {
        [textField setInputAccessoryView:[keyBoard getToolbarWithPrevNextDone:YES :YES]];
        keyBoard.currentSelectedTextboxIndex = textField.tag;
    }
    else if (CB_TxtCVV==textField)
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
    if ([strCheckPassword isEqualToString:@"1"]) {
        for (int i =0; i<CB_textFieldsPassword.count; i++) {
            UITextField *text =[CB_textFieldsPassword objectAtIndex:i];
            if (sender == text.tag) {
                UITextField *textBecome =[CB_textFieldsPassword objectAtIndex:i+1];
                [textBecome becomeFirstResponder];
            }
        }
    }
    else
    {
        for (int i =0; i<CB_textFields.count; i++) {
            UITextField *text =[CB_textFields objectAtIndex:i];
            if (sender == text.tag) {
                UITextField *textBecome =[CB_textFields objectAtIndex:i+1];
                [textBecome becomeFirstResponder];
            }
        }
    }
  }
- (void)previousClicked:(NSUInteger)sender{
    if ([strCheckPassword isEqualToString:@"1"]) {
        for (int i =0; i<CB_textFieldsPassword.count; i++) {
            UITextField *text =[CB_textFieldsPassword objectAtIndex:i];
            if (sender == text.tag) {
                UITextField *textBecome =[CB_textFieldsPassword objectAtIndex:i-1];
                [textBecome becomeFirstResponder];
            }
        }
    }
    else
    {
        for (int i =0; i<CB_textFields.count; i++) {
            UITextField *text =[CB_textFields objectAtIndex:i];
            if (sender == text.tag) {
                UITextField *textBecome =[CB_textFields objectAtIndex:i-1];
                [textBecome becomeFirstResponder];
            }
        }
    }
   }
- (void)resignResponder:(NSUInteger)sender{
    [self.view endEditing:YES];
}

#pragma mark - LTHMonthYearPickerView Delegate
- (void)pickerDidPressCancelWithInitialValues:(NSDictionary *)initialValues {
    //    _dateTextField.text = [NSString stringWithFormat:
    //                           @"%@ / %@",
    //                           initialValues[@"month"],
    //                           initialValues[@"year"]];
        [CB_TxtExpirayDate resignFirstResponder];
}


- (void)pickerDidPressDoneWithMonth:(NSString *)month andYear:(NSString *)year
{
    CB_TxtExpirayDate.text = [NSString stringWithFormat: @"%@ - %@", month, year];
    [CB_TxtExpirayDate resignFirstResponder];
}

- (void)pickerDidPressCancel {
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
#pragma mark WebService Call For Get Guest Detail
-(void)CB_CallWebserviceForGuestId:(NSString *)strID
{
    [self CB_ShowLoaderOnView];
    NSString *strUrl = [NSString stringWithFormat:@"http://clickbid.cc/cbapi/butler-guest/%@",strID];
    [CBAPIManager GetRequestToApiUrl:strUrl WithSuccess:^(id response) {
        NSLog(@"response---->%@",response);
        [self CB_HideLoderOnView];
         if (response!=nil)
         {
             dictForUse= [response valueForKey:@"data"];
             [self CB_SetValueForOutlets:dictForUse];
         }else
         {
             [self CB_ShowAlertWithTitle:@"Alert" andMessage:@"Server not getting responce"];
         }
    } failure:^(NSError *error) {
        [self CB_HideLoderOnView];
        [self CB_ShowAlertWithTitle:@"Alert" andMessage:@"Something went wrong, please try agin later"];
        NSLog(@"response---->%@",error.localizedDescription);
    }];
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
#pragma mark Webservice Calling For Update Butler Information
-(void)CB_UpdateButlerBidderInformationWithParams:(NSDictionary *)DictParam
{
     [self CB_ShowLoaderOnView];
    NSString *strUrl = [NSString stringWithFormat:@"https://clickbid.cc/cbapi/butler-updatebidder/%@/%@",[CB_UserDefault valueForKey:CB_KeyDefaultEventID],self.strID];
    [CBAPIManager PUTRequestToApiUrl:strUrl WithParam:DictParam WithSuccess:^(id response) {
        NSLog(@"%@",response);
        if (response!=nil) {
            NSDictionary *dict = [response valueForKey:@"data"];
            if ([dict valueForKey:@"SUCCESS"]!= nil) {
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Message" message:[dict valueForKey:@"SUCCESS"] preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    [self.navigationController popViewControllerAnimated:YES];
                }];
                [alertController addAction:ok];
                [self presentViewController:alertController animated:YES completion:nil];
            }
            else if ([dict valueForKey:@"ERROR"] != nil)
            {
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Alert" message:[dict valueForKey:@"ERROR"] preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                   // [self.navigationController popViewControllerAnimated:YES];
                }];
                [alertController addAction:ok];
                [self presentViewController:alertController animated:YES completion:nil];
            }
        }
    [self CB_HideLoderOnView];
    } failure:^(NSError *error) {
        NSLog(@"Reason---->%@",error.localizedFailureReason);
        NSLog(@"Suggestion---->%@",error.localizedRecoverySuggestion);
        NSLog(@"Desc---->%@",error.localizedDescription);
        [self CB_HideLoderOnView];
    }];
}

-(void)CB_UpdateGuestButlerBidderInformationWithParams:(NSDictionary *)DictParam
{
     [self CB_ShowLoaderOnView];
 
    NSString *strUrl = [NSString stringWithFormat:@"https://clickbid.cc/cbapi/butler-updatebidder/%@",[CB_UserDefault valueForKey:CB_KeyDefaultEventID]];
    [CBAPIManager PostRequestToApiUrl:strUrl WithParam:DictParam WithSuccess:^(id response) {
        NSLog(@"%@",response);
        if (response!=nil) {
            NSDictionary *dict = [response valueForKey:@"data"];
            if ([dict valueForKey:@"SUCCESS"]!= nil) {
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Message" message:[dict valueForKey:@"SUCCESS"] preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    [self.navigationController popViewControllerAnimated:YES];
                }];
                [alertController addAction:ok];
                [self presentViewController:alertController animated:YES completion:nil];
            }
            else if ([dict valueForKey:@"ERROR"] != nil)
            {
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Alert" message:[dict valueForKey:@"ERROR"] preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    //[self.navigationController popViewControllerAnimated:YES];
                }];
                [alertController addAction:ok];
                [self presentViewController:alertController animated:YES completion:nil];
            }
        }
        [self CB_HideLoderOnView];
    } failure:^(NSError *error) {
        
        NSLog(@"Reason---->%@",error.localizedFailureReason);
        NSLog(@"Suggestion---->%@",error.localizedRecoverySuggestion);
        NSLog(@"Desc---->%@",error.localizedDescription);
        [self CB_HideLoderOnView];
    }];
}
#pragma mark Welcome text check Uncheck Action
- (IBAction)CB_ActionBtnForWelcomeTextCheckUncheck:(id)sender {
    if ([[NSUserDefaults standardUserDefaults]boolForKey:@"DontShow"]==NO)
    {
        strCheckWelcome= @"0";
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"DontShow"];
        CB_imgCheckUncheckWelcomeText.image = [UIImage imageNamed:@"CB_iconUnCheck"];
        
    }
    else
    {
        strCheckWelcome = @"1";
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"DontShow"];
        CB_imgCheckUncheckWelcomeText.image = [UIImage imageNamed:@"CB_iconCheck"];
    }

}
#pragma mark Password Required check Uncheck Button Action
- (IBAction)Cb_ActionBtnForCheckUnCheckForIsPasswordRequired:(id)sender {
    
    if ([[NSUserDefaults standardUserDefaults]boolForKey:@"PasswordReqiured"]==NO)
    {strCheckPassword = @"1";
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"PasswordReqiured"];
        CB_ImgCheckUncheckPasswordRequired.image = [UIImage imageNamed:@"CB_iconCheck"];
        [self.tableView reloadData];
    }
    else
    {strCheckPassword = @"0";
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"PasswordReqiured"];
        CB_ImgCheckUncheckPasswordRequired.image = [UIImage imageNamed:@"CB_iconUnCheck"];
        [self.tableView reloadData];
    }
    [self setTextFieldTag];

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return CB_TableViewCells.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return CB_TableViewCells[indexPath.row];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* cell = [super tableView:tableView cellForRowAtIndexPath:indexPath];
    if (![self.strTitle isEqualToString:@"New Bidder"])
    {
        if (cell.tag == 45450 || cell.tag == 121211) //BOOL saying cell should be hidden
            return 0.0;
        
        else
            return [super tableView:tableView heightForRowAtIndexPath:indexPath];
    }
    else if ([strCheckPassword isEqualToString:@"0"]&&cell.tag == 45450)
    {
         return 0.0;
    }
    else
    {
        return [super tableView:tableView heightForRowAtIndexPath:indexPath];
    }
}

@end
