//
//  ShippingListTableViewCell.m
//  Explore
//
//  Created by Amboj Goyal on 8/13/15.
//  Copyright (c) 2015 Rahul. All rights reserved.
//

#import "ShippingListTableViewCell.h"
#import "SSUtility.h"
#import "PopOverlayHandler.h"

@interface ShippingListTableViewCell ()<PopOverlayHandlerDelegate>
@property (nonatomic,strong) PopOverlayHandler *overlayHandler;
@end

@implementation ShippingListTableViewCell


-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
//        selectorImage = [[UIButton alloc] init];
//        [self addSubview:selectorImage];
        
        theNameLabel = [[UILabel alloc] init];
        [self addSubview:theNameLabel];
        
        theAddressLabel = [[UILabel alloc] init];
        [self addSubview:theAddressLabel];
        
        theMobileNo = [[UILabel alloc] init];
        [self addSubview:theMobileNo];
        
        theEditButton = [[UIButton alloc] init];
        [self addSubview:theEditButton];
        
        theDeleteButton = [[UIButton alloc] init];
        [self addSubview:theDeleteButton];
        
        theHorizontalLine = [[SSLine alloc] init];
        [self addSubview:theHorizontalLine];
        
        theVerticalLine = [[UIView alloc] init];
        [self addSubview:theVerticalLine];
        
        [self setBackgroundColor:[UIColor whiteColor]];
    }
    return self;
}


-(void)prepareForReuse{
//    [selectorImage setFrame:CGRectZero];
    [theNameLabel setFrame:CGRectZero];
    [theAddressLabel setFrame:CGRectZero];
    [theMobileNo setFrame:CGRectZero];
    [theEditButton setFrame:CGRectZero];
    [theDeleteButton setFrame:CGRectZero];
    [theVerticalLine setFrame:CGRectZero];
    [theHorizontalLine setFrame:CGRectZero];
    self.theShippingModel = nil;
    labelFont = nil;
    labelFontLight = nil;
    mobileFont = nil;
    buttonFont = nil;

}

-(void)layoutSubviews{
    CGFloat widthForText = self.frame.size.width; //110
    
    CGFloat theOrigin = 15.0f;
    
//    if (self.theShippingTypeEnum == ShippingAddressCart) {
//        [selectorImage setFrame:CGRectMake(2, 8, 25, 25)];
//        [selectorImage setBackgroundColor:[UIColor clearColor]];
//        if (self.theShippingModel.isDefaultAddress) {
//            [selectorImage setBackgroundImage:[UIImage imageNamed:@"OptionSelected"] forState:UIControlStateNormal];
//        }else{
//            [selectorImage setBackgroundImage:[UIImage imageNamed:@"Option"] forState:UIControlStateNormal];
//        }
//
//        [selectorImage addTarget:self action:@selector(addressSelected:forEvent:) forControlEvents:UIControlEventTouchUpInside];
//    }
    
    labelFont = [UIFont fontWithName:kMontserrat_Light size:14.0];
    labelFontLight = [UIFont fontWithName:kMontserrat_Light size:12.0];
    
    mobileFont = [UIFont fontWithName:kMontserrat_Regular size:14.0];
    buttonFont = [UIFont fontWithName:kMontserrat_Regular size:14.0];
//    theNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(8, 8, widthForText, 30)];
    [theNameLabel setFrame:CGRectMake(theOrigin, 5, widthForText, 30)];
    [theNameLabel setFont:labelFont];
    [theNameLabel setText:[NSString stringWithFormat:@"%@ - %@",[self.theShippingModel.theAddressType capitalizedString],self.theShippingModel.theFirstName]];
    [theNameLabel setBackgroundColor:[UIColor clearColor]];
    [theNameLabel setTextColor:UIColorFromRGB(kDarkPurpleColor)];

    
    NSString *finalAddressString = [NSString stringWithFormat:@"%@, %@ - %@",self.theShippingModel.theFlatNBuildingName,self.theShippingModel.theStreetName, self.theShippingModel.thePincode];
    
    
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineBreakMode = NSLineBreakByTruncatingMiddle;
    paragraphStyle.lineSpacing = 3.0f;
    
    NSDictionary *tempDict = @{NSFontAttributeName:labelFontLight
                               ,NSParagraphStyleAttributeName:paragraphStyle};
    

//    CGSize addressSize = [SSUtility getDynamicSizeWithSpacing:finalAddressString withFont:labelFontLight withSize:CGSizeMake(widthForText-20, MAXFLOAT) spacing:3.0f];
    
    CGSize addressSize = [SSUtility getLabelDynamicSize:finalAddressString withFont:labelFontLight withSize:CGSizeMake(widthForText-30, 20)];

    
    theAddressLabel = [SSUtility generateLabel:theAddressLabel.text withRect:CGRectMake(theOrigin, theNameLabel.frame.origin.y + theNameLabel.frame.size.height, addressSize.width, addressSize.height) withFont:labelFontLight];

//    theAddressLabel.lineBreakMode = NSLineBreakByWordWrapping;

//    theAddressLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    [theAddressLabel setTextAlignment:NSTextAlignmentLeft];
    [theAddressLabel setFont:labelFontLight];
    [theAddressLabel setTextColor:UIColorFromRGB(kGenderSelectorTintColor)];
    [theAddressLabel setAttributedText:[[NSAttributedString alloc]initWithString:finalAddressString attributes:tempDict]];
    /*
    [theMobileNo setFrame:CGRectMake(theOrigin, theAddressLabel.frame.origin.y + theAddressLabel.frame.size.height , widthForText, 30)];
    [theMobileNo setFont:mobileFont];
    [theMobileNo setTextColor:UIColorFromRGB(kGenderSelectorTintColor)];
    [theMobileNo setText:[NSString stringWithFormat:@"Mob: +91 %@",self.theShippingModel.theMobileNo]];
    
    [theHorizontalLine setFrame:CGRectMake(10, theMobileNo.frame.origin.y + theMobileNo.frame.size.height+2, self.frame.size.width - 20, 1)];
    
    NSAttributedString * editString = [[NSAttributedString alloc] initWithString : @"Edit"
                                                 attributes : @{
                                                                NSFontAttributeName : buttonFont,
                                                                NSForegroundColorAttributeName : UIColorFromRGB(kTurquoiseColor)
                                                                }];
    NSAttributedString * highlightedEditString = [[NSAttributedString alloc] initWithString : @"Edit"
                                                                      attributes : @{
                                                                                     NSFontAttributeName : buttonFont,
                                                                                     NSForegroundColorAttributeName : UIColorFromRGB(kLightGreyColor)
                                                                                     }];
    [theEditButton setFrame:CGRectMake(8 , theHorizontalLine.frame.origin.y + 5, theHorizontalLine.frame.size.width/2 - 5, 32)];
    [theEditButton setAttributedTitle:editString forState:UIControlStateNormal];
    [theEditButton setAttributedTitle:highlightedEditString forState:UIControlStateHighlighted];
    [theEditButton setTitleColor:UIColorFromRGB(kLightGreyColor) forState:UIControlStateHighlighted];

//    [theEditButton setBackgroundColor:[UIColor redColor]];
    [theEditButton setTag:3348];
    [theEditButton addTarget:self action:@selector(buttonAction: forEvent:) forControlEvents:UIControlEventTouchUpInside];
    
    [theVerticalLine setFrame:CGRectMake(theEditButton.frame.size.width + theEditButton.frame.origin.x + 5, theHorizontalLine.frame.origin.y + 7, 1, 28)];
    [theVerticalLine setBackgroundColor:UIColorFromRGB(0xC2C2C2)];
    
    NSAttributedString * deleteString = [[NSAttributedString alloc] initWithString : @"Remove"
                                                                      attributes : @{
                                                                                     NSFontAttributeName : buttonFont,
                                                                                     NSForegroundColorAttributeName : UIColorFromRGB(kTurquoiseColor)
                                                                                     }];

    NSAttributedString * highlightedDeleteString = [[NSAttributedString alloc] initWithString : @"Remove"
                                                                        attributes : @{
                                                                                       NSFontAttributeName : buttonFont,
                                                                                       NSForegroundColorAttributeName : UIColorFromRGB(kLightGreyColor)
                                                                                       }];
    
    [theDeleteButton setFrame:CGRectMake( theVerticalLine.frame.origin.x + 5 , theEditButton.frame.origin.y, theHorizontalLine.frame.size.width/2 - 5, 32)];
    [theDeleteButton setAttributedTitle:deleteString forState:UIControlStateNormal];
    [theDeleteButton setAttributedTitle:highlightedDeleteString forState:UIControlStateHighlighted];
    [theDeleteButton addTarget:self action:@selector(buttonAction: forEvent:) forControlEvents:UIControlEventTouchUpInside];
    
    */
//    [theDeleteButton setBackgroundColor:[UIColor yellowColor]];

    [self addSubview:theAddressLabel];
    
//    [theHorizontalLine setFrame:CGRectMake(10, theAddressLabel.frame.origin.y + theAddressLabel.frame.size.height+2, self.frame.size.width - 20, 1)];

    
    
    CGRect frame = self.frame;
    frame.size.height = 20 + theNameLabel.frame.size.height + theAddressLabel.frame.size.height;

    [self setFrame:frame];
    
        if (self.tag == 1) {
             CGRect frm =CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
            UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:frm
                                                           byRoundingCorners:UIRectCornerTopLeft|UIRectCornerTopRight
                                                                 cornerRadii:CGSizeMake(3.0, 3.0)];
            CAShapeLayer *maskLayer = [CAShapeLayer layer];
            maskLayer.frame = frm;
            maskLayer.path = maskPath.CGPath;
            self.layer.mask = maskLayer;
            
        }
    
        if(self.tag == [self.shippingDetailsArray count]){
             CGRect frm =CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
            UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:frm
                                                           byRoundingCorners:UIRectCornerBottomLeft|UIRectCornerBottomRight
                                                                 cornerRadii:CGSizeMake(3.0, 3.0)];
            CAShapeLayer *maskLayer = [CAShapeLayer layer];
            maskLayer.frame = frm;
            maskLayer.path = maskPath.CGPath;
            self.layer.mask = maskLayer;
        }
        if ([self.shippingDetailsArray count] == 1) {
            CGRect frm =CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
            UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:frm
                                                           byRoundingCorners:UIRectCornerBottomLeft|UIRectCornerBottomRight | UIRectCornerTopLeft|UIRectCornerTopRight
                                                                 cornerRadii:CGSizeMake(3.0, 3.0)];
            CAShapeLayer *maskLayer = [CAShapeLayer layer];
            maskLayer.frame = frm;
            maskLayer.path = maskPath.CGPath;
            self.layer.mask = maskLayer;

        }

}

-(void)buttonAction:(id)sender forEvent:(UIEvent *)theEvent{
    UIButton *actionButton = (UIButton *)sender;
    touch = [[theEvent touchesForView:actionButton] anyObject];
    if (actionButton.tag == 3348) {
        if (self.theEditAddressBlock) {
            self.theEditAddressBlock(self.theShippingModel);
        }
    }else{
        /*
        deleteConfirmation = [[UIAlertView alloc] initWithTitle:@"" message:@"Are you really sure you wanna remove the address?" delegate:self cancelButtonTitle:@"NO" otherButtonTitles:@"YES", nil];
        [deleteConfirmation show];
         */
        
        if(self.overlayHandler == nil)
            self.overlayHandler = [[PopOverlayHandler alloc] init];
        
        self.overlayHandler.overlayDelegate = self;
        
        NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
        [parameters setObject:@"Delete Address" forKey:@"Alert Title"];
        [parameters setObject:@"NO" forKey:@"LeftButtonTitle"];
        [parameters setObject:@"YES" forKey:@"RightButtonTitle"];
        [parameters setObject:[NSNumber numberWithInt:CustomAlertShippingAddress] forKey:@"PopUpType"];
        [parameters setObject:@"Are you sure you want to remove this address?" forKey:@"Alert Message"];
        [parameters setObject:[NSNumber numberWithInteger:SelectSizeFromEditSize] forKey:@"TryAtHomAction"];
        [self.overlayHandler presentOverlay:CustomAlertShippingAddress rootView:self enableAutodismissal:TRUE withUserInfo:parameters];
        
    }
}

- (void)performActionOnOverlay:(NSInteger)tag andPopType:(RPWOverlayType )type andInputDictionary:(NSMutableDictionary *)dictionary{
    
    if(tag==-1){ //If user click on cancel then this will execute
        [self.overlayHandler dismissOverlay];
        return;
    }
    switch (type) {
        case CustomAlertShippingAddress:
            [self.overlayHandler dismissOverlay];
            if (self.theDeleteAddressBlock) {
                self.theDeleteAddressBlock(self.theShippingModel,touch);
            }
            break;
            default:
            break;
    }
}


-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {
        [alertView dismissWithClickedButtonIndex:0 animated:TRUE];
    }
    if (buttonIndex == 1) {
        if (self.theDeleteAddressBlock) {
            self.theDeleteAddressBlock(self.theShippingModel,touch);
        }
    }
}

-(void)addressSelected:(id)sender forEvent:(UIEvent *)touchEvent{
    UIButton *theCell = (UIButton *)sender;
    
    if (!self.theShippingModel.isDefaultAddress) {
        [self.theShippingModel setIsDefaultAddress:TRUE];
        [theCell setBackgroundImage:[UIImage imageNamed:@"OptionSelected"] forState:UIControlStateNormal];
    }
    
    UITouch *buttonTouch = [[touchEvent touchesForView:theCell] anyObject];
    if (self.theShippingTypeEnum == ShippingAddressCart) {
        if (self.theSelectedAddressBlock) {
            self.theSelectedAddressBlock(self.theShippingModel,buttonTouch);
        }
    }
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
