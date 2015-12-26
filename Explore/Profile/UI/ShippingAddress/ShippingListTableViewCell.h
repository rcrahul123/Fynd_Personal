//
//  ShippingListTableViewCell.h
//  Explore
//
//  Created by Amboj Goyal on 8/13/15.
//  Copyright (c) 2015 Rahul. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShippingAddressModel.h"
#import "SSLine.h"

typedef void (^EditAddress)(ShippingAddressModel *theEditModel);
typedef void (^DeleteAddress)(ShippingAddressModel *theDeleteModel,UITouch *theTouch);
typedef void (^SelectAddress)(ShippingAddressModel *theSelectedAddModel,UITouch *theTouch);

@interface ShippingListTableViewCell : UITableViewCell<UIAlertViewDelegate>{
    UILabel *theNameLabel;
    UILabel *theAddressLabel;
    UILabel *theMobileNo;
    UIButton *theEditButton;
    UIButton *theDeleteButton;
    UIFont *labelFont;
    UIFont *labelFontLight;
    UIFont *mobileFont;
    UIFont *buttonFont;
    SSLine *theHorizontalLine;
    UIView *theVerticalLine;
    UIAlertView *deleteConfirmation;
    UITouch *touch;
    UIButton *selectorImage;
}
@property (nonatomic,strong) ShippingAddressModel *theShippingModel;
@property (nonatomic,copy) EditAddress theEditAddressBlock;
@property (nonatomic,copy) DeleteAddress theDeleteAddressBlock;
@property (nonatomic,copy) SelectAddress theSelectedAddressBlock;
@property (nonatomic,assign) ShippingAddressType theShippingTypeEnum;
@property (nonatomic,strong)     NSMutableArray *shippingDetailsArray;
@end
