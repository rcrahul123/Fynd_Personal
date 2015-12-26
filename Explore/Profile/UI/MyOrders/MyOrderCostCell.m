//
//  MyOrderCostCell.m
//  Explore
//
//  Created by Rahul Chaudhari on 08/09/15.
//  Copyright (c) 2015 Rahul. All rights reserved.
//

#import "MyOrderCostCell.h"

@implementation MyOrderCostCell


-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        titleLabel = [[UILabel alloc] init];
        [self addSubview:titleLabel];
        
        costLable = [[UILabel alloc] init];
        [self addSubview:costLable];
    }
    return self;
}


-(void)prepareForReuse{
    [separatorView setFrame:CGRectZero];
    [titleLabel setFrame:CGRectZero];
    [cancelButton setFrame:CGRectZero];
    [contactUsButton setFrame:CGRectZero];
}

-(void)layoutSubviews{
    
    NSMutableAttributedString *costString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@ %@", kRupeeSymbol, self.orderModel.totalCost] attributes:@{NSFontAttributeName : [UIFont fontWithName:kMontserrat_Light size:14.0]}];
    
    NSString *paymentMode = [self.orderModel.modeOfPayment uppercaseString];

    if([paymentMode rangeOfString:@"COD"].length > 0 || [paymentMode rangeOfString:@"CDOD"].length > 0 || [paymentMode rangeOfString:@"ON DELIVERY"].length > 0){
        [costString addAttributes:@{NSForegroundColorAttributeName : UIColorFromRGB(kGreenColor)} range:NSMakeRange(0, costString.length)];
    }else{
        [costString addAttributes:@{NSForegroundColorAttributeName : UIColorFromRGB(kSignUpColor)} range:NSMakeRange(0, costString.length)];
    }
    
    
    CGRect costRect = [costString boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesFontLeading context:NULL];
    
    [costLable setFrame:CGRectMake(self.frame.size.width - RelativeSize(15, 375) - costRect.size.width, self.frame.size.height/2 - costRect.size.height/2, costRect.size.width, costRect.size.height)];
    [costLable setAttributedText:costString];
    
    NSMutableAttributedString *payString;
    NSAttributedString *modeString;
    if([paymentMode rangeOfString:@"COD"].length > 0 || [paymentMode rangeOfString:@"CDOD"].length > 0 || [paymentMode rangeOfString:@"ON DELIVERY"].length > 0){
        payString = [[NSMutableAttributedString alloc] initWithString:@"PAYABLE" attributes:@{NSFontAttributeName : [UIFont fontWithName:kMontserrat_Regular size:14.0], NSForegroundColorAttributeName : UIColorFromRGB(kSignUpColor)}];
    }else{
        payString = [[NSMutableAttributedString alloc] initWithString:@"PAID" attributes:@{NSFontAttributeName : [UIFont fontWithName:kMontserrat_Regular size:14.0], NSForegroundColorAttributeName : UIColorFromRGB(kSignUpColor)}];
    }
    modeString = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@" (by %@)", self.orderModel.modeOfPayment] attributes:@{NSFontAttributeName : [UIFont fontWithName:kMontserrat_Light size:14.0], NSForegroundColorAttributeName : UIColorFromRGB(kSignUpColor)}];
    [payString appendAttributedString:modeString];

    [titleLabel setFrame:CGRectMake(RelativeSize(15, 375), 12, costLable.frame.origin.x - RelativeSize(15, 375) - 5, 15)];
    [titleLabel setAttributedText:payString];
    [titleLabel setCenter:CGPointMake(titleLabel.center.x, self.frame.size.height/2)];
}


-(void)cancelButtonTapped:(id)sender{
    if(self.delegate && [self.delegate respondsToSelector:@selector(cancelOrder)]){
        [self.delegate cancelOrder];
    }
}

-(void)contactUsButtonTapped:(id)sender{
    if(self.delegate && [self.delegate respondsToSelector:@selector(contactUs)]){
        [self.delegate contactUs];
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
