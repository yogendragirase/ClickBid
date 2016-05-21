//
//  CBLoginVC.h
//  ClickBid
//
//  Created by Pushpendra on 06/05/16.
//  Copyright © 2016 Syscraft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CBLoginVC : UIViewController

{
    __weak IBOutlet UITextField *CB_TxtEventId;
    __weak IBOutlet UITextField *CB_TxtPaasword;
    __weak IBOutlet UIButton *CB_BtnLogin;

}
@property (strong,nonatomic)IBOutletCollection(UITextField) NSArray *CB_TextFeilds;


@end
