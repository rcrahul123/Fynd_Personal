//
//  CouponsView.m
//  Explore
//
//  Created by Pranav on 12/08/15.
//  Copyright (c) 2015 Rahul. All rights reserved.
//

#import "CouponsView.h"
#import "MyCoupons.h"
#import "SSUtility.h"

@interface CouponsView()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *couponsTable;
}
- (void)setUpCouponView;
@end

@implementation CouponsView

- (id)initWithFrame:(CGRect)frame andCouponData:(NSArray *)data{
    
    if(self == [super initWithFrame:frame]){
        couponDataArray = data;
        [self setUpCouponView];
    }
    return self;
}



- (void)setUpCouponView{
    couponsTable = [[UITableView alloc] initWithFrame:CGRectMake(10, 10, self.frame.size.width-20, self.frame.size.height) style:UITableViewStylePlain];
    [couponsTable setBackgroundColor:[UIColor clearColor]];
    
    couponsTable.dataSource = self;
    couponsTable.delegate = self;
    
    [self addSubview:couponsTable];
}

#pragma mark UITableView Delegate Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
//    return 5;
    return [couponDataArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 120.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10.0f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier = @"CouponCell";
    UITableViewCell *couponCell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    [couponCell setSelectionStyle:UITableViewCellSelectionStyleBlue];
    if(couponCell == nil){
        couponCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
//    couponCell.textLabel.text = [NSString stringWithFormat:@"Coupon %ld",indexPath.section];
    [self couponDataView:couponCell withCouponData:[couponDataArray objectAtIndex:indexPath.section]];
    
    couponCell.layer.cornerRadius = 5.0f;
    [couponCell setBackgroundColor:[UIColor whiteColor]];
    return couponCell;
}

- (void)couponDataView:(UITableViewCell *)couponCell withCouponData:(MyCoupons *)oneCouponData{
//    UIView *aView = [[UIView alloc] initWithFrame:couponCell.contentView.frame];
    
    UIImageView *couponImage = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, 32, 32)];
    [couponImage setBackgroundColor:[UIColor clearColor]];
    [couponImage setImage:[UIImage imageNamed:@"Coupons"]];
    [couponCell.contentView addSubview:couponImage];
    
    UILabel *couponCode = [[UILabel alloc] initWithFrame:CGRectMake(couponImage.frame.origin.x + couponImage.frame.size.width+5, couponImage.frame.origin.y, 100, 30)];
    [couponCode setBackgroundColor:[UIColor clearColor]];
    [couponCode setTextColor:UIColorFromRGB(kRedColor)];
    [couponCode setFont:[UIFont fontWithName:kMontserrat_Bold size:16.0f]];
    [couponCode setText:oneCouponData.coupanName];
    [couponCell.contentView addSubview:couponCode];
    
    CGSize size = [SSUtility getLabelDynamicSize:oneCouponData.coupanDescription withFont:[UIFont fontWithName:kMontserrat_Regular size:15.0f] withSize:CGSizeMake(couponCell.contentView.frame.size.width-20, MAXFLOAT)];
    UILabel *description = [SSUtility generateLabel:oneCouponData.coupanDescription withRect:CGRectMake(couponCode.frame.origin.x, couponImage.frame.origin.y + couponImage.frame.size.height + 5, size.width, size.height) withFont:[UIFont fontWithName:kMontserrat_Regular size:15.0f]];
    [description setTextAlignment:NSTextAlignmentLeft];
    [description setNumberOfLines:0];
    [couponCell.contentView addSubview:description];
    
//    UILabel *expiry = [[UILabel alloc] initWithFrame:CGRectMake(description.frame.origin.x, description.frame.origin.y + description.frame.size.height+5, couponCell.contentView.frame.size.width, 20)];
    UILabel *expiry = [SSUtility generateLabel:[NSString stringWithFormat:@"Expires on %@",oneCouponData.coupanExpiry] withRect:CGRectMake(description.frame.origin.x, description.frame.origin.y + description.frame.size.height+5, couponCell.contentView.frame.size.width, 20) withFont:[UIFont fontWithName:kMontserrat_Light size:13.0f]];
    [expiry setTextAlignment:NSTextAlignmentLeft];
    [couponCell.contentView addSubview:expiry];
                       
    
//    return aView;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
