//
//  PinCodePopUp.h
//  Explore
//
//  Created by Pranav on 17/07/15.
//  Copyright (c) 2015 Rahul. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PopHeaderView.h"
#import "TextFieldWithImage.h"
typedef void (^DidTapCancel)();
typedef void (^UpdatePinCodeLayOut)(CGSize size);

@interface PinCodePopUp : UIView

@property(nonatomic,strong) UITextField     *pinCodeTextField;
@property(nonatomic,strong) TextFieldWithImage     *pinCodeTextField1;
@property (nonatomic,strong) UIImageView    *locationIcon;
@property (nonatomic,strong) UIButton       *pinCodeButton;
@property (nonatomic,strong) UIButton       *checkButton;
@property (nonatomic,strong) UIImageView    *availabilityIcon;
@property (nonatomic,strong) UILabel    *messageLabel;
@property (nonatomic, strong) UIActivityIndicatorView *loadingSymbol;
@property (nonatomic,copy) DidTapCancel         tappedOnCancel;
@property (nonatomic,copy) UpdatePinCodeLayOut  updatePinCodeLayPutBlock;
@property (nonatomic,strong) NSString          *productId;
- (void)configurePopUp;
@end
