//
//  NetBankingViewController.h
//  Explore
//
//  Created by Amboj Goyal on 12/7/15.
//  Copyright © 2015 Rahul. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PaymentModes.h"

@interface NetBankingViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>{
    
}
@property (nonatomic,strong) UITableView *netBankingTableView;
@property (nonatomic,strong) NSMutableArray *theNetBankingData;
@property (nonatomic,strong) NSMutableArray *moreOptionsData;
@end
