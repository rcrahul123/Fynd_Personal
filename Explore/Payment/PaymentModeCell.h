//
//  PaymentModeCell.h
//  Explore
//
//  Created by Pranav on 15/10/15.
//  Copyright © 2015 Rahul. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PaymentModes.h"

typedef enum CornerBendType{
    CornerBendTypeNone,
    CornerBendTypeTop,
    CornerBendTypeBottom
}CornerBendType;

@interface PaymentModeCell : UITableViewCell{
    UIBezierPath *maskPath;
    CAShapeLayer *maskLayer;
    UIView *separatorView;
}
@property (nonatomic,strong) PaymentModes *currentPaymentData;
@property (nonatomic, assign) BOOL showBendCorners;
@property (nonatomic, assign) CornerBendType bendType;
@end
