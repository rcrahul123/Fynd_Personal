//
//  MyOrderProductCell.m
//  Explore
//
//  Created by Rahul Chaudhari on 07/09/15.
//  Copyright (c) 2015 Rahul. All rights reserved.
//

#import "MyOrderProductCell.h"

@implementation MyOrderProductCell

- (void)awakeFromNib {
    // Initialization code
}

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
     
        separatorView = [[UIView alloc] init];
        [self addSubview:separatorView];
        
        productImageView = [[UIImageView alloc] init];
        [self addSubview:productImageView];
        
        productNameLabel = [[UILabel alloc] init];
        [self addSubview:productNameLabel];
        
        tryAtHomeLabel = [[UILabel alloc] init];
        [self addSubview:tryAtHomeLabel];
        
        priceSizeLabel = [[UILabel alloc] init];
        [self addSubview:priceSizeLabel];
        
        statusLabel = [[UILabel alloc] init];
        [self addSubview:statusLabel];
        
        timeStampLabel = [[UILabel alloc] init];
        [self addSubview:timeStampLabel];
        
        returnItemButton = [[UIButton alloc] init];
        [self addSubview:returnItemButton];
        
        exchangeItemButton = [[UIButton alloc] init];
        [self addSubview:exchangeItemButton];
    }
    return self;
}

-(void)prepareForReuse{
    [productImageView setImage:nil];
    
    [separatorView setFrame:CGRectZero];
    [productNameLabel setFrame:CGRectZero];
    [priceSizeLabel setFrame:CGRectZero];
    [statusLabel setFrame:CGRectZero];
    [timeStampLabel setFrame:CGRectZero];
    [returnItemButton setFrame:CGRectZero];
    [exchangeItemButton setFrame:CGRectZero];
    
    productImage = nil;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    placeHolderImage = [UIImage imageNamed:@"ImagePlaceholder"];
    
    CGFloat imageHeight = [SSUtility getProductsAspectRatio:self.orderItem.aspectRatio andWidth:70];

    [productImageView setFrame:CGRectMake(RelativeSize(15, 375), self.frame.size.height/2 - imageHeight/2, 70, imageHeight)];

    if(self.orderItem.canExchange || self.orderItem.canReturn){
        [productImageView setFrame:CGRectMake(RelativeSize(15, 375), self.frame.size.height/2 - imageHeight/2 - 30, 70, imageHeight)];
    }
    
    [productImageView sd_setImageWithURL:[NSURL URLWithString:[self.orderItem.productImageURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        [productImageView setFrame:CGRectMake(RelativeSize(15, 375), self.frame.size.height/2 - imageHeight/2, 70, imageHeight)];
        
        if(self.orderItem.canExchange || self.orderItem.canReturn){
            [productImageView setFrame:CGRectMake(RelativeSize(15, 375), self.frame.size.height/2 - imageHeight/2 - 30, 70, imageHeight)];
        }
        self.isImageDownloaded = true;
    }];
    
    
    NSAttributedString *productNameString = [[NSAttributedString alloc] initWithString:[self.orderItem.productName  capitalizedString] attributes:@{NSFontAttributeName : [UIFont fontWithName:kMontserrat_Light size:14.0]}];
    CGRect nameRect = [productNameString boundingRectWithSize:CGSizeMake((separatorView.frame.origin.x + separatorView.frame.size.width - productImageView.frame.origin.x - productImageView.frame.size.width - RelativeSize(13, 375)), MAXFLOAT) options:NSStringDrawingTruncatesLastVisibleLine context:NULL];
    
    [productNameLabel setFrame:CGRectMake(productImageView.frame.origin.x + productImageView.frame.size.width + RelativeSize(13, 375), productImageView.frame.origin.y + 3, nameRect.size.width, nameRect.size.height)];
    [productNameLabel setAttributedText:productNameString];
    [productNameLabel setTextColor:UIColorFromRGB(kGenderSelectorTintColor)];
    [productNameLabel setTextAlignment:NSTextAlignmentLeft];

    [productNameLabel setBackgroundColor:[UIColor clearColor]];
    
    NSMutableAttributedString *rupee = [[NSMutableAttributedString alloc] initWithString:kRupeeSymbol attributes:@{NSFontAttributeName : [UIFont fontWithName:kMontserrat_Regular size:12.0], NSForegroundColorAttributeName : UIColorFromRGB(kGenderSelectorTintColor)}];

    priceSizeString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@" %@ | %@", self.orderItem.price, self.orderItem.sizeString] attributes:@{NSFontAttributeName : [UIFont fontWithName:kMontserrat_Regular size:14.0], NSForegroundColorAttributeName : UIColorFromRGB(kGenderSelectorTintColor)}];
    [rupee appendAttributedString:priceSizeString];
    CGRect priceRect = [rupee boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:0 context:NULL];
    [priceSizeLabel setFrame:CGRectMake(productNameLabel.frame.origin.x, productNameLabel.frame.origin.y + productNameLabel.frame.size.height + 5, priceRect.size.width, priceRect.size.height)];
    [priceSizeLabel setAttributedText:rupee];
 
    if(self.orderItem.isTryAtHome){
        [tryAtHomeLabel setFrame:CGRectMake(priceSizeLabel.frame.origin.x + priceSizeLabel.frame.size.width + 3, priceSizeLabel.frame.origin.y, self.frame.size.width - (priceSizeLabel.frame.origin.x + priceSizeLabel.frame.size.width + 3) - RelativeSize(15, 375), priceRect.size.height)];
        [tryAtHomeLabel setText:@"FYND A FIT"];
        [tryAtHomeLabel setTextColor:UIColorFromRGB(kButtonPurpleColor)];
        [tryAtHomeLabel setFont:[UIFont fontWithName:kMontserrat_Regular size:13.0]];
    }
    
    NSAttributedString *timestampString;
    NSString *timeString;
    timeString = self.orderItem.actionTime;
    timestampString = [[NSAttributedString alloc] initWithString:timeString attributes:@{NSFontAttributeName : [UIFont fontWithName:kMontserrat_Light size:12.0], NSForegroundColorAttributeName : UIColorFromRGB(kSignUpColor)}];

    CGRect timeRect = [timestampString boundingRectWithSize:CGSizeMake(self.frame.size.width - (productImageView.frame.origin.x + productImageView.frame.size.width + 5) - 10, MAXFLOAT) options:NSStringDrawingTruncatesLastVisibleLine context:NULL];
    [timeStampLabel setFrame:CGRectMake(productNameLabel.frame.origin.x, productImageView.frame.origin.y + productImageView.frame.size.height - 20 - 3, timeRect.size.width, timeRect.size.height)];
    [timeStampLabel setAttributedText:timestampString];
    
    
    [statusLabel setFrame:CGRectMake(timeStampLabel.frame.origin.x, timeStampLabel.frame.origin.y - 20 - 3, self.frame.size.width - (productImageView.frame.origin.x + productImageView.frame.size.width + 5) - RelativeSize(15, 375), 20)];
    [statusLabel setText:[self.orderItem.deliveryStatus uppercaseString]];
    [statusLabel setFont:[UIFont fontWithName:kMontserrat_Regular size:12.0]];
    
    if(self.orderItem.hexCode.length > 0){
//    if(self.orderItem.hexCode){
        [statusLabel setTextColor:[SSUtility colorFromHexString:self.orderItem.hexCode]];
    }else{
        [statusLabel setTextColor:UIColorFromRGB(kSignUpColor)];
    }

    
    if(self.orderItem.canReturn){
        
        NSAttributedString *returnString = [[NSAttributedString alloc] initWithString:@"RETURN ITEM" attributes:@{NSFontAttributeName : [UIFont fontWithName:kMontserrat_Regular size:12.0], NSForegroundColorAttributeName : UIColorFromRGB(kSignUpColor)}];
        NSAttributedString *returnStringTouch = [[NSAttributedString alloc] initWithString:@"RETURN ITEM" attributes:@{NSFontAttributeName : [UIFont fontWithName:kMontserrat_Regular size:12.0], NSForegroundColorAttributeName : UIColorFromRGB(kSignUpTouchColor)}];


        if(self.orderItem.canExchange){
            
            NSAttributedString *exchangeString = [[NSAttributedString alloc] initWithString:@"EXCHANGE ITEM" attributes:@{NSFontAttributeName : [UIFont fontWithName:kMontserrat_Regular size:12.0], NSForegroundColorAttributeName : UIColorFromRGB(kSignUpColor)}];
            NSAttributedString *exchangeStringTouch = [[NSAttributedString alloc] initWithString:@"EXCHANGE ITEM" attributes:@{NSFontAttributeName : [UIFont fontWithName:kMontserrat_Regular size:12.0], NSForegroundColorAttributeName : UIColorFromRGB(kSignUpTouchColor)}];

            [exchangeItemButton setFrame:CGRectMake(self.frame.size.width/2 + RelativeSize(5, 375), productImageView.frame.origin.y + productImageView.frame.size.height + 10, self.frame.size.width/2 - RelativeSize(15, 375) - RelativeSize(5, 375), 42)];
            [exchangeItemButton setBackgroundColor:[UIColor clearColor]];
            [exchangeItemButton.layer setBorderColor:UIColorFromRGB(kSignUpColor).CGColor];
            [exchangeItemButton.layer setBorderWidth:1.0];
            [exchangeItemButton setAttributedTitle:exchangeString forState:UIControlStateNormal];
            [exchangeItemButton setAttributedTitle:exchangeStringTouch forState:UIControlStateHighlighted];
            [exchangeItemButton addTarget:self action:@selector(exchangeButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
            exchangeItemButton.layer.cornerRadius = 3.0;
            exchangeItemButton.clipsToBounds = YES;
            
            [returnItemButton setFrame:CGRectMake(RelativeSize(15, 375), productImageView.frame.origin.y + productImageView.frame.size.height + 10, self.frame.size.width/2 - RelativeSize(15, 375) - RelativeSize(5, 375), 42)];
        }else{
            [returnItemButton setFrame:CGRectMake(RelativeSize(15, 375), productImageView.frame.origin.y + productImageView.frame.size.height + 10, self.frame.size.width - 2 * RelativeSize(15, 375), 42)];
        }
        [returnItemButton setBackgroundColor:[UIColor clearColor]];
        [returnItemButton.layer setBorderColor:UIColorFromRGB(kSignUpColor).CGColor];
        [returnItemButton.layer setBorderWidth:1.0];
        [returnItemButton setAttributedTitle:returnString forState:UIControlStateNormal];
        [returnItemButton setAttributedTitle:returnStringTouch forState:UIControlStateHighlighted];
        [returnItemButton addTarget:self action:@selector(returnButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
        returnItemButton.layer.cornerRadius = 3.0;
        returnItemButton.clipsToBounds = YES;
    }
    
    if(!self.isImageDownloaded){
        NSString *colorStr = @"#C4DDE0";
        [productImageView setBackgroundColor:[SSUtility colorFromHexString:colorStr withAlpha:0.2]];
    }
    
    [separatorView setFrame:CGRectMake(RelativeSize(15, 375), self.frame.size.height - 1, self.frame.size.width - 2 * RelativeSize(15, 375), 1)];
    [separatorView setBackgroundColor:UIColorFromRGB(kBackgroundGreyColor)];

}


-(void)exchangeButtonTapped:(id)sender{
    if(self.delegate && [self.delegate respondsToSelector:@selector(exchangeItem:)]){
        [self.delegate exchangeItem:self.orderItem];
    }
}

-(void)returnButtonTapped:(id)sender{
    if(self.delegate && [self.delegate respondsToSelector:@selector(returnItem:)]){
        [self.delegate returnItem:self.orderItem];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
