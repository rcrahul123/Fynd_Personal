//
//  PaymentOption.h
//  Explore
//
//  Created by Amboj Goyal on 8/16/15.
//  Copyright (c) 2015 Rahul. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PaymentOption : UIView<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) UITableView *thePaymentOptionTableView;
-(id)initWithFrame:(CGRect)frame dataDictionary:(NSDictionary *)dataDict;


@end
