//
//  OrderHeaderView.m
//  Explore
//
//  Created by Rahul Chaudhari on 07/09/15.
//  Copyright (c) 2015 Rahul. All rights reserved.
//

#import "OrderHeaderView.h"

@implementation OrderHeaderView

-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
     
        orderIDLabel = [[UILabel alloc] init];
        [self addSubview:orderIDLabel];
        
        orderStatusLabel = [[UILabel alloc] init];
        [self addSubview:orderStatusLabel];
        
        orderTimeLabel = [[UILabel alloc] init];
        [self addSubview:orderTimeLabel];
        
        orderCostLabel = [[UILabel alloc] init];
        [self addSubview:orderCostLabel];
        
        formatter = [[NSDateFormatter alloc] init];
        
        numberOfItemsLabel = [[UILabel alloc] init];
        [self addSubview:numberOfItemsLabel];
        
        separatorView = [[UIView alloc] init];
        [self addSubview:separatorView];
        
    }
    return self;
}


-(void)layoutSubviews{
    self.clipsToBounds = TRUE;
    [self setBackgroundColor:[UIColor whiteColor]];
    
    //order Id
    NSMutableAttributedString *idString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"ID: %@", self.orderID] attributes:@{NSFontAttributeName : [UIFont fontWithName:kMontserrat_Regular size:13.0], NSForegroundColorAttributeName :UIColorFromRGB(kSignUpColor)}];
    CGRect idRect = [idString boundingRectWithSize:CGSizeMake(self.frame.size.width/2 - 2 * RelativeSize(10, 375), self.frame.size.height) options:NSStringDrawingTruncatesLastVisibleLine context:NULL];
    if(self.isActive){
        [orderIDLabel setFrame:CGRectMake(RelativeSize(15, 375), self.frame.size.height/2 - idRect.size.height/2, idRect.size.width, idRect.size.height)];
    }else{
        [orderIDLabel setFrame:CGRectMake(RelativeSize(15, 375), self.frame.size.height/2 - idRect.size.height - 5, idRect.size.width, idRect.size.height)];
    }
    [orderIDLabel setAttributedText:idString];
    
    
    //order date
    NSMutableAttributedString *dateString = [[NSMutableAttributedString alloc] initWithString:self.orderTime attributes:@{NSFontAttributeName : [UIFont fontWithName:kMontserrat_Light size:12.0], NSForegroundColorAttributeName :UIColorFromRGB(kLightGreyColor)}];
    CGRect timeRect = [dateString boundingRectWithSize:CGSizeMake(self.frame.size.width/2 - orderCostLabel.frame.size.width - orderCostLabel.frame.origin.x, self.frame.size.height - 10) options:NSStringDrawingTruncatesLastVisibleLine context:NULL];
    [orderTimeLabel setAttributedText:dateString];
    [orderTimeLabel setFrame:CGRectMake(self.frame.size.width - RelativeSize(15, 375) - timeRect.size.width - 5, self.frame.size.height/2 - timeRect.size.height/2, timeRect.size.width, timeRect.size.height)];
    [orderTimeLabel setCenter:CGPointMake(orderTimeLabel.center.x, orderIDLabel.center.y)];
    
    
    if(!self.isActive){
        
        //number of items
        NSString *tempString ;
        if(self.numberOfItems == 1){
            tempString = @"Item";
        }else{
            tempString = @"Items";
        }
        
        NSMutableAttributedString *numberOfItemsString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%ld %@", (long)self.numberOfItems, tempString] attributes:@{NSFontAttributeName : [UIFont fontWithName:kMontserrat_Light size:12.0], NSForegroundColorAttributeName : UIColorFromRGB(kLightGreyColor)}];
        CGRect numberRect = [numberOfItemsString boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesFontLeading context:NULL];
        [numberOfItemsLabel setFrame:CGRectMake(RelativeSize(15, 375), self.frame.size.height/2 + 5, numberRect.size.width, numberRect.size.height)];
        [numberOfItemsLabel setAttributedText:numberOfItemsString];
        
        
        //total cost
        NSMutableAttributedString *costString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@" | %@ %@", kRupeeSymbol,self.totalCost] attributes:@{NSFontAttributeName : [UIFont fontWithName:kMontserrat_Light size:12.0], NSForegroundColorAttributeName :UIColorFromRGB(kLightGreyColor)}];
        CGRect costRect = [costString boundingRectWithSize:CGSizeMake(self.frame.size.width/4 - RelativeSize(15, 375), self.frame.size.height - 10) options:NSStringDrawingTruncatesLastVisibleLine context:NULL];
        [orderCostLabel setFrame:CGRectMake(numberOfItemsLabel.frame.origin.x + numberOfItemsLabel.frame.size.width, self.frame.size.height/2 + 5, costRect.size.width, costRect.size.height)];
        [orderCostLabel setAttributedText:costString];
        [orderCostLabel setCenter:CGPointMake(orderCostLabel.center.x, numberOfItemsLabel.center.y)];
        
        //odrder status
        if([[self.orderStatus uppercaseString] rangeOfString:@"CANCEL"].length > 0){
            NSMutableAttributedString *statusString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@" %@", self.orderStatus] attributes:@{NSFontAttributeName : [UIFont fontWithName:kMontserrat_Light size:13.0], NSForegroundColorAttributeName :UIColorFromRGB(kRedColor)}];
            CGRect statusRect = [statusString boundingRectWithSize:CGSizeMake(self.frame.size.width/2 - 2 * RelativeSize(15, 375), self.frame.size.height) options:NSStringDrawingTruncatesLastVisibleLine context:NULL];
            [orderStatusLabel setAttributedText:statusString];
            [orderStatusLabel setFrame:CGRectMake(orderCostLabel.frame.origin.x + orderCostLabel.frame.size.width, self.frame.size.height/2 + 5, statusRect.size.width, statusRect.size.height)];
        }

    }else{
        
        //total cost
        [orderCostLabel setFrame:CGRectMake(self.frame.size.width - RelativeSize(15, 375), 5, 0, 0)];
        [orderCostLabel setText:@""];
    }
    
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds
                                                   byRoundingCorners:UIRectCornerTopLeft|UIRectCornerTopRight
                                                         cornerRadii:CGSizeMake(3.0, 3.0)];
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.frame = self.bounds;
    maskLayer.path = maskPath.CGPath;
    self.layer.mask = maskLayer;
    
    [separatorView setFrame:CGRectMake(RelativeSize(0, 375), self.frame.size.height - 1, self.frame.size.width - 2 * RelativeSize(0, 375), 1)];
    [separatorView setBackgroundColor:UIColorFromRGB(0xD0D0D0)];

}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
