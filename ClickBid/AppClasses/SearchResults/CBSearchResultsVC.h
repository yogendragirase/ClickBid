//
//  CBSearchResultsVC.h
//  ClickBid
//
//  Created by Pushpendra on 09/05/16.
//  Copyright © 2016 Syscraft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CBSearchResultsVC : UITableViewController
@property (strong,nonatomic)NSString *strTitle;
@end

@interface CBResponseArray : NSObject

@property (nonatomic,weak)NSString *strBeanstream_id;
@property (nonatomic,weak)NSString *strBeanstream_last_four;
@property (nonatomic,weak)NSString *strBidder_number;
@property (nonatomic,weak)NSString *strCcs_last_four;
@property (nonatomic,weak)NSString *strCompany;
@property (nonatomic,weak)NSString *strCustomer_profile_id;
@property (nonatomic,weak)NSString *strEmail;
@property (nonatomic,weak)NSString *strFirst_name;
@property (nonatomic,weak)NSString *strHas_bids;
@property (nonatomic,weak)NSString *strHas_checkouts;
@property (nonatomic,weak)NSString *strHas_purchases;
@property (nonatomic,weak)NSString *strId;
@property (nonatomic,weak)NSString *strLast_name;
@property (nonatomic,weak)NSString *strPayment_profile_id;
@property (nonatomic,weak)NSString *strPhone;
@property (nonatomic,weak)NSString *strTable_name;

//For Guest

@property (nonatomic,weak)NSString *strGId;
@property (nonatomic,weak)NSString *strGfirst_name;
@property (nonatomic,weak)NSString *strGlast_name;
@property (nonatomic,weak)NSString *strGemail;
@property (nonatomic,weak)NSString *strGphone;
@property (nonatomic,weak)NSString *strGtable_name;
@property (nonatomic,weak)NSString *strGreceipt;
@property (nonatomic,weak)NSString *strGregistration_id;


-(NSMutableDictionary *)DictinitWithResponseDictionary:(NSDictionary *)Dict;
-(NSMutableDictionary *)DictResponseForGuestDictionary:(NSDictionary *)Dict;


@end
