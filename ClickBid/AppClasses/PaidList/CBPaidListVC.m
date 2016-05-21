//
//  CBPaidListVC.m
//  ClickBid
//
//  Created by Pushpendra on 07/05/16.
//  Copyright © 2016 Syscraft. All rights reserved.
//

#import "CBPaidListVC.h"
#import "CBHeader.h"

@interface CBPaidListVC ()
{
    NSMutableArray *CB_ArrayPaidList;
}
@end

@implementation CBPaidListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"PAID ITEM LIST";
    CB_ArrayPaidList = [NSMutableArray new];
    [CB_tblPaidList reloadData];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self CB_ShowNavigationBar];
    //Set Back Buttonm
    [self CB_SetNavigationBackButtonImage];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source & Delegate



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}
// Cell For Row at IndexPath
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CBPaidCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CBPaidCell" forIndexPath:indexPath];
        if (cell == nil) {
            cell = [[CBPaidCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CBBidderCell"];
        }
    cell.lblPaidItem.text = [NSString stringWithFormat:@"Bidder #%ld",indexPath.row];
        //Setting properties and Btn Action methods
    
        return cell;
    
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
