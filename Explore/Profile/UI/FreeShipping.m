//
//  FreeShipping.m
//  Explore
//
//  Created by Pranav on 13/08/15.
//  Copyright (c) 2015 Rahul. All rights reserved.
//

#import "FreeShipping.h"
#import "SSUtility.h"

@interface FreeShipping()
{
    UIView      *shippingContainerView;
    UIButton    *shareCode;
    UIButton    *termsAndCondition;
}
@end

@implementation FreeShipping


- (id)initWithFrame:(CGRect)frame{
    
    if(self == [super initWithFrame:frame]){
        [self setBackgroundColor:UIColorFromRGB(kBackgroundGreyColor)];
    }
    return self;
}

- (void)configureFreeShipping{
    shippingContainerView = [[UIView alloc] initWithFrame:CGRectMake(10, 74, self.frame.size.width-20, 200)];
    [shippingContainerView setBackgroundColor:[UIColor whiteColor]];
    
    UIImageView *shareCodeImage = [[UIImageView alloc] initWithFrame:CGRectMake(shippingContainerView.frame.size.width/2 -20, 10, 40, 40)];
    [shareCodeImage setBackgroundColor:[UIColor clearColor]];
    [shareCodeImage setImage:[UIImage imageNamed:@"discount"]];
    [shippingContainerView addSubview:shareCodeImage];
    
    NSString *codeString = [self.shippingDataDict objectForKey:@"ShippingCode"];
    CGSize codeSize = [SSUtility getLabelDynamicSize:codeString withFont:[UIFont fontWithName:kMontserrat_Bold size:15.0f] withSize:CGSizeMake(shippingContainerView.frame.size.width,MAXFLOAT)];
    UILabel *codeLabel = [SSUtility generateLabel:codeString withRect:CGRectMake(self.frame.size.width/2 - codeSize.width/2, shareCodeImage.frame.origin.y + shareCodeImage.frame.size.height +5, codeSize.width, codeSize.height) withFont:[UIFont fontWithName:kMontserrat_Bold size:15.0f]];
    [codeLabel setTextColor:UIColorFromRGB(kRedColor)];
    [codeLabel setTextAlignment:NSTextAlignmentLeft];
    [shippingContainerView addSubview:codeLabel];
    [self addSubview:shippingContainerView];
    
    
    NSString *codeDescription = [self.shippingDataDict objectForKey:@"ShippingCodeDescription"];
    CGSize descriptionSize = [SSUtility getLabelDynamicSize:codeDescription withFont:[UIFont fontWithName:kMontserrat_Light size:14.0f] withSize:CGSizeMake(shippingContainerView.frame.size.width-20, MAXFLOAT)];
    UILabel *codeDescriptionLabel = [SSUtility generateLabel:codeDescription withRect:CGRectMake(shippingContainerView.frame.size.width/2 - descriptionSize.width/2, codeLabel.frame.origin.y + codeLabel.frame.size.height +5, descriptionSize.width, descriptionSize.height) withFont:[UIFont fontWithName:kMontserrat_Light size:14.0f]];
    [codeDescriptionLabel setTextAlignment:NSTextAlignmentLeft];
    [codeDescriptionLabel setNumberOfLines:0];
    [shippingContainerView addSubview:codeDescriptionLabel];
    
    shareCode = [UIButton buttonWithType:UIButtonTypeCustom];
    shareCode.layer.cornerRadius = 3.0f;
    [shareCode setFrame:CGRectMake(shippingContainerView.frame.size.width/2 - 100 , codeDescriptionLabel.frame.origin.y + codeDescriptionLabel.frame.size.height + 10, 200, 50)];
    
    [shareCode setBackgroundColor:UIColorFromRGB(kRedColor)];
    [shareCode setTitle:@"Share Code" forState:UIControlStateNormal];
    [shareCode setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    shareCode.titleLabel.font = [UIFont fontWithName:kMontserrat_Bold size:13.0f];
    [shippingContainerView addSubview:shareCode];
    
    termsAndCondition = [UIButton buttonWithType:UIButtonTypeCustom];
    termsAndCondition.layer.cornerRadius = 3.0f;
    [termsAndCondition setFrame:CGRectMake(shippingContainerView.frame.size.width/2 - 100 , shareCode.frame.origin.y + shareCode.frame.size.height, 200, 30)];
    [termsAndCondition setBackgroundColor:[UIColor clearColor]];
//    [termsAndCondition setBackgroundColor:UIColorFromRGB(kBlueColor)];
    [termsAndCondition setTitle:@"Terms and Condition" forState:UIControlStateNormal];
    [termsAndCondition setTitleColor:UIColorFromRGB(kBlueColor) forState:UIControlStateNormal];
    termsAndCondition.titleLabel.font = [UIFont fontWithName:kMontserrat_Bold size:13.0f];
    [shippingContainerView addSubview:termsAndCondition];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
