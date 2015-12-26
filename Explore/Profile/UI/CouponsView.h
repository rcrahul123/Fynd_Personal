//
//  CouponsView.h
//  Explore
//
//  Created by Pranav on 12/08/15.
//  Copyright (c) 2015 Rahul. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CouponData : NSObject
@property (nonatomic,copy) NSString *coupanName;
@property (nonatomic,copy) NSString *discountAmount;
@property (nonatomic,copy) NSString *coupanDescription;
@end

@interface CouponsView : UIView
{
    NSArray *couponDataArray;
}
- (id)initWithFrame:(CGRect)frame andCouponData:(NSArray *)data;
@end
