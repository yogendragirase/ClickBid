//
//  CBHeader.h
//  ClickBid
//
//  Created by Pushpendra on 06/05/16.
//  Copyright © 2016 Syscraft. All rights reserved.
//

#ifndef CBHeader_h
#define CBHeader_h

#import "AppDelegate.h"
#import "CBLoginVC.h"
#import "CBAPIManager.h"
#import "UIViewController+CBHelper.h"
#import "UITableViewController+CBHelper.h"
#import "CBHomeVC.h"
#import "CBAddNewBidderVC.h"
#import "CBCheckOutVC.h"
#import "CBPaidListVC.h"
#import "CBSearchResultsVC.h"
#import "CBGuestCell.h"
#import "CBBidderCell.h"
#import "CBPaidCell.h"
#import "CBCheckOutCell.h"

//Library and SDK
#import "AFNetworking.h"
#import "SVProgressHUD.h"
#import "Reachability.h"
#import "CBUtility.h"
#import "IQActionSheetPickerView.h"
#import "CustomKeyboard.h"
#import "CHRTextMask.h"
#import "CHRTextFieldFormatter.h"
#import "CHRCardNumberMask.h"
#import "CHRPhoneNumberMask.h"
#import "LTHMonthYearPickerView.h"
#import "BraintreeCore.h"//Braintree
#import "AuthNet.h"//Authorize.net
#import "EselectDelegate.h"//Moneris
#import "TerminaliOS.h"//Moneris

// StoryBoard_Id:-
#define CBKey_StoryBoardId_Home @"CBHomeVC"
#define CBKey_StoryBoardId_AddNewBidder @"CBAddNewBidderVC"
#define CBKey_StoryBoardId_CheckOut @"CBCheckOutVC"
#define CBKey_StoryBoardId_PaidItemList @"CBPaidListVC"
#define CBKey_StoryBoardId_SearchResult @"CBSearchResultsVC"

#define CB_STORYBOARD_MAIN ([UIStoryboard storyboardWithName:@"Main" bundle:nil])

// UserDefult
#define CB_UserDefault ([NSUserDefaults standardUserDefaults])
//AppDelegate Object
#define CB_ObjAppdelegate ((AppDelegate *)[[UIApplication sharedApplication]delegate])
#define CB_ROOTVIEW [[[UIApplication sharedApplication] keyWindow] rootViewController]

//UserDefaults key:-
#define CB_KeyDefaultEventID @"LoginUserEventId"

//Nslog and Check Debug
#ifdef DEBUG
#define CBLog(...) NSLog(__VA_ARGS__)
#else
#define CBLog(...)
#endif

//BaseUrl
#define BaseUrl @"http://clickbid.cc/zendapp/public/"

//Authorize.Net
#define kSlash @"/"
#define kCardNumberErrorAlert 1001
#define kCardExpirationErrorAlert 1002
#endif /* CBHeader_h */
