//
//  MyOrderAddressCell.h
//  Explore
//
//  Created by Rahul Chaudhari on 08/09/15.
//  Copyright (c) 2015 Rahul. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyOrderModel.h"
@protocol MyOrderAddressCellDelegate <NSObject>

@optional
-(void)cancelItem:(NSString *)itemOrderID cost:(NSString *)cost;
-(void)callus:(id)sender;

@end
@interface MyOrderAddressCell : UITableViewCell{
    UIView *separatorView;
    UIView *separatorView1;
    UIView *verticalSeparatorView;

    UILabel *titleLabel;
    UILabel *addressLabel;
    
    
    UIButton *cancelButton;
    UIButton *contactUsButton;
    UIImageView *callUSImageView;
    
    UILabel *addressTypeLabel;
    UILabel *addressName;
    UIView *addAddressView;
    
    UILabel *timeSlotHeader;
    UILabel *timeSlotLabel;
}

@property (nonatomic, strong) MyOrderModel *orderModel;
@property (nonatomic, strong) id<MyOrderAddressCellDelegate> delegate;
@end
