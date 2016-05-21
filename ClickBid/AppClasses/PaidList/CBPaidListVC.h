//
//  CBPaidListVC.h
//  ClickBid
//
//  Created by Pushpendra on 07/05/16.
//  Copyright © 2016 Syscraft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CBPaidListVC : UIViewController
{
    __weak IBOutlet UILabel *CB_lblBidderName;
    __weak IBOutlet UITableView *CB_tblPaidList;
}
@end
