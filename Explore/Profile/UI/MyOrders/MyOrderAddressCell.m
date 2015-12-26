//
//  MyOrderAddressCell.m
//  Explore
//
//  Created by Rahul Chaudhari on 08/09/15.
//  Copyright (c) 2015 Rahul. All rights reserved.
//

#import "MyOrderAddressCell.h"

@implementation MyOrderAddressCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        
        separatorView = [[UIView alloc] init];
        [self addSubview:separatorView];
        
        separatorView1 = [[UIView alloc] init];
        [self addSubview:separatorView1];
        
        
        titleLabel = [[UILabel alloc] init];
        [self addSubview:titleLabel];
        
        addressLabel = [[UILabel alloc] init];
        [self addSubview:addressLabel];
        
        cancelButton = [[UIButton alloc] init];
        [self addSubview:cancelButton];
        
        contactUsButton = [[UIButton alloc] init];
        [self addSubview:contactUsButton];
        
        callUSImageView = [[UIImageView alloc] init];
        [contactUsButton addSubview:callUSImageView];
        
        addAddressView = [[UIView alloc] init];
        [self addSubview:addAddressView];
        
        addressTypeLabel = [[UILabel alloc] init];
        [addAddressView addSubview:addressTypeLabel];
        
        verticalSeparatorView = [[UIView alloc] init];
        [addAddressView addSubview:verticalSeparatorView];
        
        timeSlotHeader = [[UILabel alloc] init];
        [addAddressView addSubview:timeSlotHeader];
        
        timeSlotLabel = [[UILabel alloc] init];
        [addAddressView addSubview:timeSlotLabel];
        
        addressName = [[UILabel alloc] init];
        [addAddressView addSubview:addressName];
        
        
    }
    return self;
}

-(void)prepareForReuse{
    [separatorView setFrame:CGRectZero];
    [titleLabel setFrame:CGRectZero];
    [addressLabel setFrame:CGRectZero];
}


-(void)layoutSubviews{
    [separatorView setFrame:CGRectMake(0, 0, self.frame.size.width, 1)];
    [separatorView setBackgroundColor:UIColorFromRGB(kBackgroundGreyColor)];
    
    [addAddressView setFrame: CGRectMake(RelativeSize(15, 375), 2, self.frame.size.width - 2 * RelativeSize(15, 375), 50)];
    [addAddressView setBackgroundColor:[UIColor clearColor]];
    
    //TODO : Set address from model
    NSString *type =nil;
    if ([self.orderModel.deliveryAddressType isKindOfClass:[NSNull class]]) {
        type = @"HOME";
    }else{
     type = [self.orderModel.deliveryAddressType uppercaseString];

    }

    NSString *detail = [NSString stringWithFormat:@"%@", self.orderModel.deliveryAddress];
    
    NSAttributedString *addressTypeString = [[NSAttributedString alloc] initWithString:type attributes:@{NSFontAttributeName : [UIFont variableFontWithName:kMontserrat_Light size:12.0], NSForegroundColorAttributeName : UIColorFromRGB(kLightGreyColor)}];
    CGRect addrTypeRect = [addressTypeString boundingRectWithSize:CGSizeMake(addAddressView.frame.size.width/2 - 1, addAddressView.frame.size.height/2) options:NSStringDrawingUsesFontLeading context:NULL];
    
    [addressTypeLabel setFrame:CGRectMake(0, 0, addrTypeRect.size.width, addrTypeRect.size.height)];
    [addressTypeLabel setCenter:CGPointMake(addAddressView.frame.size.width/4, addAddressView.frame.size.height/4)];
    [addressTypeLabel setAttributedText:addressTypeString];
    [addAddressView addSubview:addressTypeLabel];
    
    NSMutableParagraphStyle *paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    [paragraphStyle setLineBreakMode:NSLineBreakByTruncatingMiddle];
    
    NSMutableAttributedString *addressString = [[NSMutableAttributedString alloc] initWithString:detail attributes:@{NSFontAttributeName : [UIFont variableFontWithName:kMontserrat_Light size:12.0], NSForegroundColorAttributeName : UIColorFromRGB(kDarkPurpleColor), NSParagraphStyleAttributeName : paragraphStyle}];
    CGRect addrStringRect = [addressString boundingRectWithSize:CGSizeMake(addAddressView.frame.size.width/2 - 5, addAddressView.frame.size.height/2) options:NSStringDrawingUsesLineFragmentOrigin context:NULL];
    
    [addressName setFrame:CGRectMake(5, addAddressView.frame.size.width/2, addrStringRect.size.width, addrStringRect.size.height)];
    [addressName setAttributedText:addressString];

    [addressName setCenter:CGPointMake(addAddressView.frame.size.width/4, addAddressView.frame.size.height/2 + addAddressView.frame.size.height/4-4)];

    
    [verticalSeparatorView setFrame:CGRectMake(addAddressView.frame.size.width/2, 5, 1, addAddressView.frame.size.height-10)];
    [verticalSeparatorView setBackgroundColor:UIColorFromRGB(kBackgroundGreyColor)];
    
    NSString *header = [self.orderModel.deliveryDate uppercaseString];
    NSString *time = self.orderModel.deliveryTime;

    NSAttributedString *timeHeaderString = [[NSAttributedString alloc] initWithString:header attributes:@{NSFontAttributeName : [UIFont variableFontWithName:kMontserrat_Light size:12.0], NSForegroundColorAttributeName : UIColorFromRGB(kLightGreyColor)}];
    CGRect timeHeaderRect = [timeHeaderString boundingRectWithSize:CGSizeMake(addAddressView.frame.size.width/2 - 1, addAddressView.frame.size.height/2) options:NSStringDrawingUsesFontLeading context:NULL];
    [timeSlotHeader setFrame:CGRectMake(1, 0, timeHeaderRect.size.width, timeHeaderRect.size.height)];
    [timeSlotHeader setCenter:CGPointMake(1 + addAddressView.frame.size.width/2 + addAddressView.frame.size.width/4, addAddressView.frame.size.height/4)];
    [timeSlotHeader setAttributedText:timeHeaderString];
    [addAddressView addSubview:timeSlotHeader];
    
    NSAttributedString *timeValueString = [[NSAttributedString alloc] initWithString:time attributes:@{NSFontAttributeName : [UIFont variableFontWithName:kMontserrat_Light size:12.0], NSForegroundColorAttributeName : UIColorFromRGB(kDarkPurpleColor)}];
    CGRect timeValueRect = [timeValueString boundingRectWithSize:CGSizeMake(addAddressView.frame.size.width/2 - 1, addAddressView.frame.size.height/2) options:NSStringDrawingTruncatesLastVisibleLine context:NULL];
    [timeSlotLabel setFrame:CGRectMake(1, addAddressView.frame.size.width/2, timeValueRect.size.width, timeValueRect.size.height)];
    [timeSlotLabel setCenter:CGPointMake(1 + addAddressView.frame.size.width/2 + addAddressView.frame.size.width/4, addAddressView.frame.size.height/2 + addAddressView.frame.size.height/4-4)];
    [timeSlotLabel setAttributedText:timeValueString];
    [timeSlotLabel setLineBreakMode:NSLineBreakByTruncatingTail];
    [addAddressView addSubview:timeSlotLabel];

    [separatorView1 setFrame:CGRectMake(0, addAddressView.frame.origin.y + addAddressView.frame.size.height, self.frame.size.width, 1)];
    [separatorView1 setBackgroundColor:UIColorFromRGB(kBackgroundGreyColor)];
    
    
    if(self.orderModel.canCancel){
        
        NSAttributedString *cancelString = [[NSAttributedString alloc] initWithString:@"CANCEL ORDER" attributes:@{NSFontAttributeName : [UIFont fontWithName:kMontserrat_Regular size:12.0], NSForegroundColorAttributeName : UIColorFromRGB(kSignUpColor)}];
        NSAttributedString *cancelStringTouch = [[NSAttributedString alloc] initWithString:@"CANCEL ORDER" attributes:@{NSFontAttributeName : [UIFont fontWithName:kMontserrat_Regular size:12.0], NSForegroundColorAttributeName : UIColorFromRGB(kSignUpTouchColor)}];
        
        [cancelButton setFrame:CGRectMake(RelativeSize(15, 375), self.frame.size.height - 42 - RelativeSize(15, 375), self.frame.size.width/2 - RelativeSize(15, 375) - RelativeSize(5, 375), 42)];
        [cancelButton setAttributedTitle:cancelString forState:UIControlStateNormal];
        [cancelButton setAttributedTitle:cancelStringTouch forState:UIControlStateHighlighted];
        [cancelButton setBackgroundColor:[UIColor clearColor]];
        [cancelButton.layer setBorderColor:UIColorFromRGB(kSignUpColor).CGColor];
        [cancelButton.layer setBorderWidth:1.0];
        cancelButton.layer.cornerRadius = 3.0;
        cancelButton.clipsToBounds = YES;
        [cancelButton addTarget:self action:@selector(cancelButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
        
        NSAttributedString *contactString = [[NSAttributedString alloc] initWithString:@"CALL US" attributes:@{NSFontAttributeName : [UIFont fontWithName:kMontserrat_Regular size:12.0], NSForegroundColorAttributeName : UIColorFromRGB(kSignUpColor)}];
        NSAttributedString *contactStringTouch = [[NSAttributedString alloc] initWithString:@"CALL US" attributes:@{NSFontAttributeName : [UIFont fontWithName:kMontserrat_Regular size:12.0], NSForegroundColorAttributeName : UIColorFromRGB(kSignUpTouchColor)}];
        
        [contactUsButton setFrame:CGRectMake
         (self.frame.size.width/2 + RelativeSize(5, 375), self.frame.size.height - 42 - RelativeSize(15, 375), self.frame.size.width/2 - RelativeSize(15, 375) - RelativeSize(5, 375), 42)];
        [contactUsButton setAttributedTitle:contactString forState:UIControlStateNormal];
        [contactUsButton setAttributedTitle:contactStringTouch forState:UIControlStateHighlighted];
        [contactUsButton setBackgroundColor:[UIColor clearColor]];
        [contactUsButton.layer setBorderColor:UIColorFromRGB(kSignUpColor).CGColor];
        [contactUsButton.layer setBorderWidth:1.0];
        contactUsButton.layer.cornerRadius = 3.0;
        contactUsButton.clipsToBounds = YES;
        [contactUsButton addTarget:self action:@selector(callusButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
        
        if(SYSTEM_VERSION_LESS_THAN(@"8")){
            [callUSImageView setFrame:CGRectMake(contactUsButton.titleLabel.frame.origin.x - RelativeSize(35, 375), 6, 30, 30)];
            
        }else{
            [callUSImageView setFrame:CGRectMake(contactUsButton.titleLabel.frame.origin.x - RelativeSize(65, 375), 6, 30, 30)];
        }
//        [callUSImageView setFrame:CGRectMake(contactUsButton.titleLabel.frame.origin.x - RelativeSize(40, 375), 6, 30, 30)];

        [callUSImageView setImage:[UIImage imageNamed:@"CallUs"]];
        [callUSImageView setBackgroundColor:[UIColor clearColor]];
        [contactUsButton addSubview:callUSImageView];
        [contactUsButton bringSubviewToFront:callUSImageView];
    }
    
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds
                                                   byRoundingCorners:UIRectCornerBottomLeft|UIRectCornerBottomRight
                                                         cornerRadii:CGSizeMake(3.0, 3.0)];
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.frame = self.bounds;
    maskLayer.path = maskPath.CGPath;
    self.layer.mask = maskLayer;
}

-(void)cancelButtonTapped:(id)sender{
    if(self.delegate && [self.delegate respondsToSelector:@selector(cancelItem:cost:)]){
        [self.delegate cancelItem:self.orderModel.orderId cost:self.orderModel.totalCost];
    }
}

-(void)callusButtonTapped:(id)sender{
    if(self.delegate && [self.delegate respondsToSelector:@selector(callus:)]){
        [self.delegate callus:nil];
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
