//
//  CBBidderCell.h
//  ClickBid
//
//  Created by Pushpendra on 09/05/16.
//  Copyright © 2016 Syscraft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CBBidderCell : UITableViewCell
@property (strong,nonatomic)IBOutlet UILabel *lblBidderName;
@property (strong,nonatomic)IBOutlet UILabel *lblCardDesc;
@property (strong,nonatomic)IBOutlet UILabel *lblPaidItemDesc;
@property (strong,nonatomic)IBOutlet UIView *view_Cart;
@property (strong,nonatomic)IBOutlet UIView *view_Purchases;
@property (strong,nonatomic)IBOutlet UIButton *CB_BtnCart;
@property (strong,nonatomic)IBOutlet UIButton *CB_BtnPurchases;
@property (strong,nonatomic)IBOutlet UIButton *CB_BtnEdit;

@end
