//
//  MyOrderCostCell.h
//  Explore
//
//  Created by Rahul Chaudhari on 08/09/15.
//  Copyright (c) 2015 Rahul. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyOrderModel.h"

@protocol MyOrderDelegate <NSObject>

@optional
-(void)cancelOrder;
-(void)contactUs;

@end

@interface MyOrderCostCell : UITableViewCell{
    UIView *separatorView;
    UILabel *titleLabel;
    UIButton *cancelButton;
    UIButton *contactUsButton;
    
    UILabel *costLable;
    UILabel *modeLabel;
}

@property (nonatomic, strong) MyOrderModel *orderModel;
@property (nonatomic, strong) id<MyOrderDelegate> delegate;

@end
