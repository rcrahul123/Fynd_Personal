//
//  WelcomeCardCell.m
//  Explore
//
//  Created by Amboj Goyal on 11/24/15.
//  Copyright © 2015 Rahul. All rights reserved.
//

#import "WelcomeCardCell.h"
#import "UIFont+FontWithNameAndSize.h"

@interface WelcomeCardCell(){
    CGSize headerSize;
    CGSize descriptionSize;
    UITapGestureRecognizer *tapOnCell;
}

@end

@implementation WelcomeCardCell
-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        
        container = [[UIButton alloc] init];
        [self addSubview:container];
        
        cardImageView = [[UIImageView alloc] init];
        [container addSubview:cardImageView];
        
        headerLabel = [[UILabel alloc] init];
        [container addSubview:headerLabel];
        
        descriptionLabel = [[UILabel alloc] init];
        [container addSubview:descriptionLabel];
        
        trackOrderButton = [[UIButton alloc] init];
        trackOrderButton.hidden = TRUE;
//        [container addSubview:trackOrderButton];
        
//        tapOnCell = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(trackOrder:)];
//        [container addGestureRecognizer:tapOnCell];
    }
    return self;
}

-(void)prepareForReuse{
    headerSize = CGSizeZero;

    descriptionSize = CGSizeZero;
    [container setFrame:CGRectZero];
    [cardImageView setFrame:CGRectZero];
    [headerLabel setFrame:CGRectZero];
    [descriptionLabel setFrame:CGRectZero];
    [trackOrderButton setFrame:CGRectZero];
}


-(void)layoutSubviews{
    if (self.isOrderCard) {
        [trackOrderButton setHidden:FALSE];
    }
    [container setFrame:CGRectMake(RelativeSize(3, 320), RelativeSize(4, 320), self.frame.size.width - RelativeSize(6, 320), self.frame.size.height - RelativeSize(8, 320))];
    container.layer.cornerRadius = 3.0;
    [container setBackgroundColor:[UIColor whiteColor]];
    container.layer.shadowColor = UIColorFromRGB(kShadowColor).CGColor;
    [container.layer setShadowOpacity:0.1];
    [container.layer setShadowOffset:CGSizeMake(0.0, 1.0)];
    [container setClipsToBounds:TRUE];

    
    
    
    [container setBackgroundImage:[SSUtility imageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
    [container setBackgroundImage:[SSUtility imageWithColor:UIColorFromRGB(0xf2f2f2)] forState:UIControlStateHighlighted];
    [cardImageView setFrame:CGRectMake(2, 4, 80, 80)];
    cardImageView.layer.cornerRadius = 3.0;
    [cardImageView setBackgroundColor:[UIColor clearColor]];

    
    NSString *headerString = nil;
    if (_isOrderCard) {
        headerString = @"YAY! ORDER PLACED";
        [cardImageView setImage:[UIImage imageNamed:@"OrderCard"]];
        [container addTarget:self action:@selector(trackOrder:) forControlEvents:UIControlEventTouchUpInside];
    }else
    {
        [cardImageView setImage:[UIImage imageNamed:@"WelcomeCard"]];
        headerString = [NSString stringWithFormat:@"Hey %@!",(NSMutableString *)[[SSUtility loadUserObjectWithKey:kFyndUserKey] firstName]];
    }
    
    
    headerSize = [SSUtility getLabelDynamicSize:headerString withFont:[UIFont fontWithName:kMontserrat_Regular size:14.0f] withSize:CGSizeMake(MAXFLOAT, 30)];
    
    if(DeviceWidth >= 375){
        [headerLabel setFrame:CGRectMake(cardImageView.frame.size.width +cardImageView.frame.origin.x + 15,5, headerSize.width, 30)];
    }else if(DeviceWidth == 320){
        [headerLabel setFrame:CGRectMake(cardImageView.frame.size.width +cardImageView.frame.origin.x + 15, 3, headerSize.width, 30)];
    }
    


    [headerLabel setText:headerString];
    [headerLabel setFont:[UIFont fontWithName:kMontserrat_Regular size:14.0f]];
    [headerLabel setTextColor:UIColorFromRGB(kPinkColor)];
    
    NSString *detailedText = nil;
    if (_isOrderCard) {
      detailedText = @"Thank you for Fynding! Tap to see order details.";
    }else
    {
        detailedText = @"Discover a whole new way to shop with Fynd. #HappyFynding";
    }
    //adding Description View
    descriptionSize = [SSUtility getDynamicSizeWithSpacing:detailedText withFont:[UIFont fontWithName:kMontserrat_Light size:14.0f] withSize:CGSizeMake(container.frame.size.width - headerLabel.frame.origin.x-RelativeSize(10, 320), MAXFLOAT) spacing:3.0];


    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];

    if(DeviceWidth >= 375){
        paragraphStyle.lineSpacing = 3.0f;
    }else if(DeviceWidth == 320){
        paragraphStyle.lineSpacing = 2.0f;
    }
    
    NSDictionary *tempDict = @{NSFontAttributeName:[UIFont fontWithName:kMontserrat_Light size:14.0f]
                               ,NSParagraphStyleAttributeName:paragraphStyle};
    
//    [descriptionLabel setFrame:CGRectMake(headerLabel.frame.origin.x, headerLabel.frame.size.height + headerLabel.frame.origin.y, container.frame.size.width - (cardImageView.frame.origin.x + cardImageView.frame.size.width), descriptionSize.height)];
    
    [descriptionLabel setFrame:CGRectMake(headerLabel.frame.origin.x, headerLabel.frame.size.height + headerLabel.frame.origin.y, descriptionSize.width, descriptionSize.height)];
    [descriptionLabel setNumberOfLines:0];
    descriptionLabel.lineBreakMode = NSLineBreakByWordWrapping;

    [descriptionLabel setAttributedText:[[NSAttributedString alloc]initWithString:detailedText attributes:tempDict]];
    [descriptionLabel setFont:[UIFont fontWithName:kMontserrat_Light size:14.0f]];

    [descriptionLabel setTextColor:UIColorFromRGB(kLightGreyColor)];
    
    
    
//    NSAttributedString *trackOrder = [[NSAttributedString alloc] initWithString : @"View Order Details"
//                                                                     attributes : @{
//                                                                                    NSFontAttributeName : [UIFont fontWithName:kMontserrat_Regular size:14.0],
//                                                                                    NSForegroundColorAttributeName : UIColorFromRGB(kTurquoiseColor)
//                                                                                    }];
//    
//    NSAttributedString *trackOrderTouch = [[NSAttributedString alloc] initWithString : @"View Order Details"
//                                                                          attributes : @{
//                                                                                         NSFontAttributeName : [UIFont fontWithName:kMontserrat_Regular size:14.0],
//                                                                                         NSForegroundColorAttributeName : UIColorFromRGB(kButtonTouchStateColor)
//                                                                                         }];
//    
//    
//    
//    
//    [trackOrderButton setFrame:CGRectMake(descriptionLabel.frame.origin.x, descriptionLabel.frame.origin.y + descriptionLabel.frame.size.height, descriptionLabel.frame.size.width, 30)];
//    trackOrderButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
//    [trackOrderButton setAttributedTitle:trackOrder forState:UIControlStateNormal];
//    [trackOrderButton setAttributedTitle:trackOrderTouch forState:UIControlStateHighlighted];
//    [trackOrderButton addTarget:self action:@selector(trackOrder:) forControlEvents:UIControlEventTouchUpInside];
}

-(void)trackOrder:(id)sender{
    self.theCallBackBlock(@"trackorder");
}

@end
