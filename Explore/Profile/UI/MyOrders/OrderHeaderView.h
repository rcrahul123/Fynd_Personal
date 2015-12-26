//
//  OrderHeaderView.h
//  Explore
//
//  Created by Rahul Chaudhari on 07/09/15.
//  Copyright (c) 2015 Rahul. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface OrderHeaderView : UIButton{
    UILabel *orderIDLabel;
    UILabel *orderTimeLabel;
    UILabel *orderCostLabel;
    NSDateFormatter *formatter;
    NSDate *date;
    NSString *formattedDateString;
    
    UILabel *orderStatusLabel;
    UILabel *numberOfItemsLabel;
    
    UIView *separatorView;
}

@property (nonatomic, strong) NSString *orderID;
@property (nonatomic, strong) NSString *orderTime;
@property (nonatomic, strong) NSString *totalCost;
@property (nonatomic, assign) BOOL isActive;
@property (nonatomic, strong) NSString *orderStatus;

@property (nonatomic, assign) NSInteger numberOfItems;
@end
