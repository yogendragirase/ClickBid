//
//  CBSearchResultsVC.m
//  ClickBid
//
//  Created by Pushpendra on 09/05/16.
//  Copyright © 2016 Syscraft. All rights reserved.
//

#import "CBSearchResultsVC.h"
#import "CBHeader.h"

@interface CBSearchResultsVC ()
{
    NSMutableArray *CB_ArrayResults;
    NSString *CB_Result;
}
@end

@implementation CBSearchResultsVC
#pragma mark viewDidLoad
- (void)viewDidLoad
{
    [super viewDidLoad];
   
    
}

#pragma mark viewWillAppear

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //Set navigation Bar
    [self CB_ShowNavigationBar];
    //Set Back Buttonm
    [self CB_SetNavigationBackButtonImage];
    //Attributed Text For Header
    [self CB_SetAttributedTextForTitle];
    
    //
     CB_ArrayResults = [NSMutableArray new];
    if (![self CheckNetworkReachability])
    {
        [self GetSearchResultForText:self.strTitle];
        
    }
    else
    {
        [self CB_ShowAlertWithTitle:@"Alert" andMessage:@"Please check your internet connection."];
    }
}

#pragma mark Attributed Title for Navigation Title

-(void)CB_SetAttributedTextForTitle
{
    UILabel *titleLabel = [UILabel new];
    NSDictionary *attrs = @{
                            NSFontAttributeName:[UIFont fontWithName:@"HelveticaNeue-Light" size:18],
                            NSForegroundColorAttributeName:[UIColor darkGrayColor]
                            };
    NSDictionary *subAttrs = @{
                               NSFontAttributeName:[UIFont boldSystemFontOfSize:19.0],
                               NSForegroundColorAttributeName:[UIColor blackColor]
                               };
    const NSRange range = NSMakeRange(12,self.strTitle.length+1);
    NSMutableAttributedString *attributedText =
    [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"Results For: %@",self.strTitle]
                                           attributes:attrs];
    [attributedText setAttributes:subAttrs range:range];
    // Set it in our UILabel and we are done!
    [titleLabel setAttributedText:attributedText];
    [titleLabel sizeToFit];
    self.navigationItem.titleView = titleLabel;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source & Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return CB_ArrayResults.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *array =[CB_ArrayResults objectAtIndex:section];
    return array.count;
}
 // Cell For Row at IndexPath
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0 && ![CB_Result isEqualToString:@"Guest"]) {
        CBBidderCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CBBidderCell" forIndexPath:indexPath];
        if (cell == nil) {
            cell = [[CBBidderCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CBBidderCell"];
        }
          NSArray *array =[CB_ArrayResults objectAtIndex:indexPath.section];
        //Setting properties and Btn Action methods
        NSDictionary *dict = [array objectAtIndex:indexPath.row];
        cell.lblBidderName.text = [NSString stringWithFormat:@"%@-%@ #%@",[dict valueForKey:@"last_name"],[dict valueForKey:@"first_name"],[dict valueForKey:@"bidder_number"]];
        if ([[dict valueForKey:@"has_purchases"] isEqualToString:@"0"]) {
            cell.view_Purchases.hidden = YES;
        }
        else
        {
            cell.view_Purchases.hidden = NO;
        }
        if ([[dict valueForKey:@"has_checkouts"] isEqualToString:@"0"]) {
            cell.view_Cart.hidden = NO;
        }
        else
        {
            cell.view_Cart.hidden = NO;
        }
        
        if ([[dict valueForKey:@"has_bids"] isEqualToString:@"0"]) {
            NSLog(@"Hidden");
            cell.lblPaidItemDesc.hidden = YES;
        }
        else
        {
            NSLog(@"Show");
            cell.lblPaidItemDesc.hidden = NO;
        }
        cell.CB_BtnCart.tag = indexPath.row;
        [cell.CB_BtnCart addTarget:self action:@selector(CB_BtnCartActionWithSender:) forControlEvents:UIControlEventTouchUpInside];
        cell.CB_BtnEdit.tag = indexPath.row;
         [cell.CB_BtnEdit addTarget:self action:@selector(CB_BtnEditActionWithSender:) forControlEvents:UIControlEventTouchUpInside];
        cell.CB_BtnPurchases.tag = indexPath.row;
        [cell.CB_BtnPurchases addTarget:self action:@selector(CB_BtnPurchaseActionWithSender:) forControlEvents:UIControlEventTouchUpInside];
        return cell;
    }
    else
    {
        CBGuestCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CBGuestCell" forIndexPath:indexPath];
        if (cell == nil)
        
        {
            cell = [[CBGuestCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CBGuestCell"];
        }
         //Setting properties and Btn Action methods
        NSArray *array =[CB_ArrayResults objectAtIndex:indexPath.section];
        //Setting properties and Btn Action methods
        NSDictionary *dict = [array objectAtIndex:indexPath.row];
          cell.lblGuestName.text = [NSString stringWithFormat:@"%@-%@",[dict valueForKey:@"last_name"],[dict valueForKey:@"first_name"]];
        cell.Cb_BtnAddGuest.tag = indexPath.row;
        [cell.Cb_BtnAddGuest addTarget:self action:@selector(CB_BtnAddActionWithSender:) forControlEvents:UIControlEventTouchUpInside];
        return cell;
}
}
 //Create header View
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0 && ![CB_Result isEqualToString:@"Guest"]) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 35.0)];
        /* Create custom view to display section header... */
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 2, tableView.frame.size.width, 25)];
        [label setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:18]];
        label.textColor = [UIColor whiteColor];
        NSString *string =@"    BIDDER RESULTS";
        /* Section header is in 0th index... */
        [label setText:string];
        [view addSubview:label];
        [view setBackgroundColor:[UIColor colorWithRed:34/255.0 green:192/255.0 blue:100/255.0 alpha:1.0]];
        return view;
    }
    else
    {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 80.0)];
        /* Create custom view to display section header... */
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 1, tableView.frame.size.width, 35.0)];
        [label setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:18]];
        label.textColor = [UIColor whiteColor];
        NSString *string =@"    REGISTERED GUEST RESULTS";
        label.backgroundColor =[UIColor colorWithRed:34/255.0 green:192/255.0 blue:100/255.0 alpha:1.0];
        /* Section header is in 0th index... */
        UILabel *labelSubTile = [[UILabel alloc] initWithFrame:CGRectMake(0, 36.0, tableView.frame.size.width, 25)];
        [labelSubTile setFont:[UIFont italicSystemFontOfSize:12.0]];
        labelSubTile.textColor = [UIColor lightGrayColor];
        labelSubTile.text =@"   Tap on a plus sign to convert a guest to bidder.";
       // [labelSubTile sizeToFit];
        UIView *viewLine = [[UIView alloc] initWithFrame:CGRectMake(0, 64, tableView.frame.size.width, 1.0)];
        viewLine.backgroundColor =[UIColor colorWithRed:211/255.0 green:211/255.0 blue:211/255.0 alpha:1.0];
        [label setText:string];
        [view addSubview:label];
        [view addSubview:labelSubTile];
        [view addSubview:viewLine];
        [view setBackgroundColor:[UIColor colorWithRed:228/255.0 green:228/255.0 blue:228/255.0 alpha:1.0]];
        return view;
    }
}
//Set header View Height
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0 && ![CB_Result isEqualToString:@"Guest"]) {
        return 35.0;
    }
    else
    {
        return 65.0;
    }
}

//Set Row Height
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    if (indexPath.section == 0) {
        
        return 85.0;
    }
    else
    {
        return 65.0;
    }
}

#pragma mark Action Methods For Bidder cell Buttons

-(void)CB_BtnCartActionWithSender:(UIButton *)Sender
{
    NSArray *array = [CB_ArrayResults objectAtIndex:0];
    CBCheckOutVC *obj =[self.storyboard instantiateViewControllerWithIdentifier:CBKey_StoryBoardId_CheckOut];
    obj.dictData =[array objectAtIndex:Sender.tag];
    [self.navigationController pushViewController:obj animated:YES];
}

-(void)CB_BtnPurchaseActionWithSender:(UIButton *)Sender
{
    CBPaidListVC *obj = [self.storyboard instantiateViewControllerWithIdentifier:CBKey_StoryBoardId_PaidItemList];
    [self.navigationController pushViewController:obj animated:YES];
}

-(void)CB_BtnEditActionWithSender:(UIButton *)Sender
{
    NSArray *array = [CB_ArrayResults objectAtIndex:0];
    NSString *strId = [[array objectAtIndex:Sender.tag] valueForKey:@"id"];
    CBAddNewBidderVC *obj = [self.storyboard instantiateViewControllerWithIdentifier:CBKey_StoryBoardId_AddNewBidder];
    obj.strTitle =[NSString stringWithFormat:@"Bidder #%@",strId];
    obj.strID = strId;
    [self.navigationController pushViewController:obj animated:YES];
}
#pragma mark Action Methods For Guest cell Button
-(void)CB_BtnAddActionWithSender:(UIButton *)Sender
{
    NSString *strId;
    if ([CB_Result isEqualToString:@"Both"]) {
        NSArray *array = [CB_ArrayResults objectAtIndex:1];
        strId = [[array objectAtIndex:Sender.tag] valueForKey:@"id"];
    }
    else
    {
        NSArray *array = [CB_ArrayResults objectAtIndex:0];
        strId = [[array objectAtIndex:Sender.tag] valueForKey:@"id"];
    }
    CBAddNewBidderVC *obj = [self.storyboard instantiateViewControllerWithIdentifier:CBKey_StoryBoardId_AddNewBidder];
    obj.strTitle =@"New Bidder";
    obj.strID = strId;
    [self.navigationController pushViewController:obj animated:YES];
}

#pragma mark Webservice Call for Get Results
-(void)GetSearchResultForText:(NSString *)strText
{
    // butlerLookup/EVENT ID/CRITERIA
    [self CB_ShowLoaderOnView];
    NSString *strID;
    if ([CB_UserDefault valueForKey:CB_KeyDefaultEventID]== nil) {
        strID = @"";
        [CB_UserDefault setValue:strID forKey:CB_KeyDefaultEventID];
    }
    //  http://clickbid.cc/cbapi/butler-landing/10
    NSString *strUrl = [NSString stringWithFormat:@"http://clickbid.cc/cbapi/butler-landing/%@/%@",[CB_UserDefault valueForKey:CB_KeyDefaultEventID],strText];
    strUrl = [strUrl stringByReplacingOccurrencesOfString:@" " withString:@""];
    [CBAPIManager GetRequestToApiUrl:strUrl WithSuccess:^(id response) {
        CBLog(@"Search-->%@",response);
        [self CB_HideLoderOnView];
        if (response!=nil) {
            NSMutableArray *arrayRes = [NSMutableArray new];
            NSDictionary *dict = [response valueForKey:@"data"];
            if ([[dict valueForKey:@"bidders"] count] == 0 && [[dict valueForKey:@"guests"] count]==0) {
                [self CB_ShowAlertWithTitle:@"Alert" andMessage:@"No results found."];
            }
            else
            {
                if ([[dict valueForKey:@"bidders"] count]!=0 && [[dict valueForKey:@"guests"] count]!=0) {
                    CB_Result = @"Both";
                     [arrayRes addObject:[[response valueForKey:@"data"] valueForKey:@"bidders"]];
                    [arrayRes addObject:[[response valueForKey:@"data"] valueForKey:@"guests"]];
                }
                else if ([[dict valueForKey:@"bidders"] count]!=0)
                {
                    [arrayRes addObject:[[response valueForKey:@"data"] valueForKey:@"bidders"]];
                     CB_Result = @"Bidders";
                }
                else
                {
                    CB_Result = @"Guest";
                    [arrayRes addObject:[[response valueForKey:@"data"] valueForKey:@"guests"]];
                }
                CBResponseArray *objRes = [[CBResponseArray alloc] init];
                NSMutableArray *arrayTemp  = [NSMutableArray new];
                for (int i =0; i<[[arrayRes objectAtIndex:0] count]; i++) {
                    NSDictionary *dictData = [[arrayRes objectAtIndex:0] objectAtIndex:i];
                    NSMutableDictionary *dictValue = [objRes DictinitWithResponseDictionary:dictData];
                    [arrayTemp addObject:dictValue];
                }
                
                if (arrayTemp.count != 0) {
                    [CB_ArrayResults addObject:arrayTemp];
                }
                if (arrayRes.count>1) {
                    NSMutableArray *arrayTempGuest  = [NSMutableArray new];
                    for (int i =0; i<[[arrayRes objectAtIndex:1] count]; i++) {
                        NSDictionary *dictData = [[arrayRes objectAtIndex:1] objectAtIndex:i];
                        NSMutableDictionary *dictValue = [objRes DictResponseForGuestDictionary:dictData];
                        [arrayTempGuest addObject:dictValue];
                    }
                    if (arrayTempGuest.count != 0) {
                        [CB_ArrayResults addObject:arrayTempGuest];
                    }
                }
                [self.tableView reloadData];
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

@end

#pragma mark Object Class To Manage Response Of Results

@interface CBResponseArray ()

@end
@implementation CBResponseArray
-(NSMutableDictionary *)DictinitWithResponseDictionary:(NSDictionary *)Dict;
{
    NSMutableDictionary *dictValue = [NSMutableDictionary new];
    dictValue = [Dict mutableCopy];
    self.strBeanstream_id = [Dict valueForKey:@"beanstream_id"];
    if ([self.strBeanstream_id isKindOfClass:[NSNull class]]|| self.strBeanstream_id==nil || [self.strBeanstream_id isEqualToString:@"<null>"]) {
         self.strBeanstream_id = @"";
    }
     [dictValue setValue:self.strBeanstream_id forKey:@"beanstream_id"];
    self.strBeanstream_last_four = [Dict valueForKey:@"beanstream_last_four"];
    if ([self.strBeanstream_last_four isKindOfClass:[NSNull class]]|| self.strBeanstream_last_four==nil || [self.strBeanstream_last_four isEqualToString:@"<null>"]) {
        self.strBeanstream_last_four = @"";
    }
    [dictValue setValue:self.strBeanstream_last_four forKey:@"beanstream_last_four"];

    self.strBidder_number = [Dict valueForKey:@"bidder_number"];
    if ([self.strBidder_number isKindOfClass:[NSNull class]]|| self.strBidder_number==nil || [self.strBidder_number isEqualToString:@"<null>"]) {
        self.strBidder_number = @"";
    }
    [dictValue setValue:self.strBidder_number forKey:@"bidder_number"];
    
    self.strCcs_last_four = [Dict valueForKey:@"ccs_last_four"];
    if ([self.strCcs_last_four isKindOfClass:[NSNull class]]|| self.strCcs_last_four==nil || [self.strCcs_last_four isEqualToString:@"<null>"]) {
        self.strCcs_last_four = @"";
    }
    [dictValue setValue:self.strCcs_last_four forKey:@"ccs_last_four"];

    self.strCompany = [Dict valueForKey:@"company"];
    if ([self.strCompany isKindOfClass:[NSNull class]]|| self.strCompany==nil || [self.strCompany isEqualToString:@"<null>"]) {
        self.strCompany = @"";
    }
    [dictValue setValue:self.strCompany forKey:@"company"];
    
    self.strCustomer_profile_id = [Dict valueForKey:@"customer_profile_id"];
    if ([self.strCustomer_profile_id isKindOfClass:[NSNull class]]|| self.strCustomer_profile_id==nil || [self.strCustomer_profile_id isEqualToString:@"<null>"]) {
        self.strCustomer_profile_id = @"";
    }
    [dictValue setValue:self.strCustomer_profile_id forKey:@"customer_profile_id"];

        self.strEmail = [Dict valueForKey:@"email"];
    if ([self.strEmail isKindOfClass:[NSString class]]) {
        if ([self.strEmail isKindOfClass:[NSNull class]]|| self.strEmail==nil || [self.strEmail isEqualToString:@"<null>"]) {
            self.strEmail = @"";
        }
        
        [dictValue setValue:self.strEmail forKey:@"email"];
    }
        self.strFirst_name = [Dict valueForKey:@"first_name"];
    if ([self.strFirst_name isKindOfClass:[NSNull class]]|| self.strFirst_name==nil || [self.strFirst_name isEqualToString:@"<null>"]) {
        self.strFirst_name = @"";
    }
    [dictValue setValue:self.strFirst_name forKey:@"first_name"];
    
    self.strHas_bids = [Dict valueForKey:@"has_bids"];
    if ([self.strHas_bids isKindOfClass:[NSNull class]]|| self.strHas_bids==nil || [self.strHas_bids isEqualToString:@"<null>"]) {
        self.strHas_bids = @"";
    }
    [dictValue setValue:self.strHas_bids forKey:@"has_bids"];

    self.strHas_checkouts = [Dict valueForKey:@"has_checkouts"];
    if ([self.strHas_checkouts isKindOfClass:[NSNull class]]|| self.strHas_checkouts==nil || [self.strHas_checkouts isEqualToString:@"<null>"]) {
        self.strHas_checkouts = @"";
    }
    [dictValue setValue:self.strHas_checkouts forKey:@"has_checkouts"];

    
    self.strHas_purchases = [Dict valueForKey:@"has_purchases"];
    if ([self.strHas_purchases isKindOfClass:[NSNull class]]|| self.strHas_purchases==nil || [self.strHas_purchases isEqualToString:@"<null>"]) {
        self.strHas_purchases = @"";
    }
    [dictValue setValue:self.strHas_purchases forKey:@"has_purchases"];
    self.strId = [Dict valueForKey:@"id"];
    if ([self.strId isKindOfClass:[NSNull class]]|| self.strId==nil || [self.strId isEqualToString:@"<null>"]) {
        self.strId = @"";
    }
    [dictValue setValue:self.strId forKey:@"id"];

    self.strLast_name = [Dict valueForKey:@"last_name"];
    if ([self.strLast_name isKindOfClass:[NSNull class]]|| self.strLast_name==nil || [self.strLast_name isEqualToString:@"<null>"]) {
        self.strLast_name = @"";
    }
    [dictValue setValue:self.strLast_name forKey:@"last_name"];

    self.strPayment_profile_id = [Dict valueForKey:@"payment_profile_id"];
    if ([self.strPayment_profile_id isKindOfClass:[NSNull class]]|| self.strPayment_profile_id==nil || [self.strPayment_profile_id isEqualToString:@"<null>"]) {
        self.strPayment_profile_id = @"";
    }
    [dictValue setValue:self.strPayment_profile_id forKey:@"payment_profile_id"];

    self.strPhone = [Dict valueForKey:@"phone"];
    if ([self.strPhone isKindOfClass:[NSString class]]) {
        if ([self.strPhone isKindOfClass:[NSNull class]]|| self.strPhone==nil || [self.strPhone isEqualToString:@"<null>"]) {
            self.strPhone = @"";
        }
        [dictValue setValue:self.strPhone forKey:@"phone"];
    }

    self.strTable_name = [Dict valueForKey:@"table_name"];
    if ([self.strTable_name isKindOfClass:[NSNull class]]|| self.strTable_name==nil || [self.strTable_name isEqualToString:@"<null>"]) {
        self.strTable_name = @"";
    }
    [dictValue setValue:self.strTable_name forKey:@"table_name"];
    return dictValue;
}

-(NSMutableDictionary *)DictResponseForGuestDictionary:(NSDictionary *)Dict
{
    NSMutableDictionary *dictValue = [NSMutableDictionary new];
    dictValue = [Dict mutableCopy];
    self.strGphone = [Dict valueForKey:@"phone"];
     if ([self.strGphone isKindOfClass:[NSString class]])
     {
         if ([self.strGphone isKindOfClass:[NSNull class]]|| self.strGphone==nil || [self.strGphone isEqualToString:@"<null>"]) {
             self.strGphone = @"";
         }
         [dictValue setValue:self.strGphone forKey:@"phone"];
     }
    self.strGtable_name = [Dict valueForKey:@"table_name"];
    if ([self.strGtable_name isKindOfClass:[NSNull class]]|| self.strGtable_name==nil || [self.strGtable_name isEqualToString:@"<null>"]) {
        self.strGtable_name = @"";
    }
    [dictValue setValue:self.strGtable_name forKey:@"table_name"];
    self.strGfirst_name = [Dict valueForKey:@"first_name"];
    if ([self.strGfirst_name isKindOfClass:[NSNull class]]|| self.strGfirst_name==nil || [self.strGfirst_name isEqualToString:@"<null>"]) {
        self.strGfirst_name = @"";
    }
    [dictValue setValue:self.strGfirst_name forKey:@"first_name"];
    self.strGId = [Dict valueForKey:@"id"];
    if ([self.strGId isKindOfClass:[NSNull class]]|| self.strGId==nil || [self.strGId isEqualToString:@"<null>"]) {
        self.strGId = @"";
    }
    [dictValue setValue:self.strGId forKey:@"id"];
    self.strGlast_name = [Dict valueForKey:@"last_name"];
    if ([self.strGlast_name isKindOfClass:[NSNull class]]|| self.strGlast_name==nil || [self.strGlast_name isEqualToString:@"<null>"]) {
        self.strGlast_name = @"";
    }
    [dictValue setValue:self.strGlast_name forKey:@"last_name"];
    self.strGemail = [Dict valueForKey:@"email"];
    if ([self.strGemail isKindOfClass:[NSString class]])
    {
        if ([self.strGemail isKindOfClass:[NSNull class]]|| self.strGemail==nil || [self.strGemail isEqualToString:@"<null>"]) {
            self.strGemail = @"";
        }
        [dictValue setValue:self.strGemail forKey:@"email"];
    }
    self.strGreceipt = [Dict valueForKey:@"receipt"];
    if ([self.strGreceipt isKindOfClass:[NSNull class]]|| self.strGreceipt==nil || [self.strGreceipt isEqualToString:@"<null>"]) {
        self.strGreceipt = @"";
    }
    [dictValue setValue:self.strGreceipt forKey:@"receipt"];
    self.strGregistration_id = [Dict valueForKey:@"registration_id"];
    if ([self.strGregistration_id isKindOfClass:[NSNull class]]|| self.strGregistration_id==nil || [self.strGregistration_id isEqualToString:@"<null>"]) {
        self.strGregistration_id = @"";
    }
    [dictValue setValue:self.strGregistration_id forKey:@"registration_id"];
    
    return dictValue;

}

@end