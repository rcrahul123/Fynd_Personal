//
//  ProductCell.m
//  FreshSample
//
//  Created by Rahul on 6/17/15.
//  Copyright (c) 2015 Rahul. All rights reserved.
//

#import "ProductCell.h"


@implementation ProductCell

-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        
        container = [[UIView alloc] init];
        [self addSubview:container];
        
        imgView = [[UIImageView alloc] init];
        [container addSubview:imgView];
    
        brandLogo = [[UIImageView alloc] init];
        [container addSubview:brandLogo];
        
        nameLabel = [[UILabel alloc] init];
        [container addSubview:nameLabel];
        
        priceLabel = [[UILabel alloc] init];
        [container addSubview:priceLabel];
        
        markedDownPriceLabel = [[UILabel alloc] init];
        [container addSubview:markedDownPriceLabel];
        
        deleteButton = [[UIButton alloc] init];
        [container addSubview:deleteButton];
        likeButton = [[UIButton alloc] init];
        [container addSubview:likeButton];

        addToCartButton = [[UIButton alloc] init];
        [container addSubview:addToCartButton];
        addToCartFont = [UIFont fontWithName:kMontserrat_Bold size:12.0];
        
        outOfStockLabel = [[UILabel alloc] init];
        [container addSubview:outOfStockLabel];
        outOfStockFont = [UIFont fontWithName:kMontserrat_Bold size:16.0];
        
        badgeLabel = [[UILabel alloc] init];
        [container addSubview:badgeLabel];
        
        imageSize = CGSizeZero;
        
        
        
        discountContainerView = [[UIView alloc] init];
        [container addSubview:discountContainerView];
        
        discountLabel = [[UILabel alloc] init];
        [discountContainerView addSubview:discountLabel];
        
        discountImageView = [[UIImageView alloc] init];
        [discountContainerView addSubview:discountImageView];
    }
    return self;
}


-(void)prepareForReuse{
    [super prepareForReuse];
    
    imageSize = CGSizeZero;
    session = nil;
    imgView.image = nil;
    
    brandLogo.image = nil;
    [brandLogo setFrame:CGRectZero];

    [container setFrame:CGRectZero];
    [imgView setFrame:CGRectZero];
    self.cellModel = nil;
    [nameLabel setFrame:CGRectZero];
    nameLabel.text = nil;
    
    selectedLikeImage = nil;
    unselectedLikeImage = nil;
    placeHolderImage = nil;
    markedPriceString = nil;
    markedPriceAttributedString = nil;
    effectivePriceString = nil;
    
    productImage = nil;
    brandLogoImage = nil;
    
    nameLabelFont = nil;
    priceLabelFont = nil;
    priceLabelRect = CGRectZero;
    
    effectivePriceFont = nil;
    effectivePriceRect = CGSizeZero;
    
    addToCartButton = nil;
    addToCartString = nil;
    
    outOfStockLabel = nil;
    outOfStockString = nil;
    
    self.isImageDownloaded = false;
    
    [badgeLabel setFrame:CGRectZero];
    
    discountImageView.image = nil;
    [discountLabel setFrame:CGRectZero];
    [discountContainerView setFrame:CGRectZero];
}
/*
-(void)layoutSubviews{
    
    [super layoutSubviews];
    selectedLikeImage = [UIImage imageNamed:@"WishListFilled"];
    unselectedLikeImage = [UIImage imageNamed:@"WishList"];
    placeHolderImage = [UIImage imageNamed:@"ImagePlaceholder"];
    [container setFrame:CGRectMake(RelativeSize(3, 320), RelativeSize(4, 320), self.frame.size.width - RelativeSize(6, 320), self.frame.size.height - RelativeSize(8, 320))];
    container.layer.cornerRadius = 3.0;
    [container setBackgroundColor:[UIColor whiteColor]];
    container.layer.shadowColor = UIColorFromRGB(kShadowColor).CGColor;
    [container.layer setShadowOpacity:0.1];
    [container.layer setShadowOffset:CGSizeMake(0.0, 1.0)];
    
    if(self.cellModel.tileType == ProductTileAddToCartFromWishlist || self.cellModel.tileType == ProductTileWishList){
        [imgView setFrame:CGRectMake(RelativeSize(4, 320), RelativeSize(4, 320), container.frame.size.width - RelativeSize(8, 320), container.frame.size.height - 56 - RelativeSizeHeight(50, 667))];
    }else{
        [imgView setFrame:CGRectMake(RelativeSize(4, 320), RelativeSize(4, 320), container.frame.size.width - RelativeSize(8, 320), container.frame.size.height - 56)];
    }
    if(self.cellModel.tileType == ProductTileAddToCartFromWishlist || self.cellModel.tileType == ProductTileWishList){
        [brandLogo setFrame:CGRectMake(imgView.frame.origin.x, imgView.frame.origin.y + imgView.frame.size.height + RelativeSizeHeight(10, 667), RelativeSize(28, 320),RelativeSize(28, 320))];
    }else{
        [brandLogo setFrame:CGRectMake(imgView.frame.origin.x, imgView.frame.origin.y + imgView.frame.size.height + (container.frame.size.height - (imgView.frame.origin.y + imgView.frame.size.height + RelativeSize(28, 320)))/2, RelativeSize(28, 320),RelativeSize(28, 320))];
    }
    [brandLogo.layer setBorderColor:UIColorFromRGB(kBorderColor).CGColor];
    [brandLogo.layer setCornerRadius:3.0f];
    [brandLogo.layer setBorderWidth:1];
    brandLogo.clipsToBounds = YES;
    
    [brandLogo sd_setImageWithURL:[NSURL URLWithString:[self.cellModel.productLogo stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
    
//    [brandLogo sd_setImageWithURL:[NSURL URLWithString:[self.cellModel.productLogo stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
//        
//    }];
    
    if (self.cellModel.tileType == ProductTileWishList) {
        [deleteButton setFrame:CGRectMake(container.frame.origin.x + container.frame.size.width - 40, brandLogo.frame.origin.y, 32, 32)];
        [deleteButton setBackgroundImage:(self.cellModel.is_bookmarked ? selectedLikeImage : unselectedLikeImage) forState:UIControlStateNormal];
        [deleteButton setCenter:CGPointMake(deleteButton.center.x, brandLogo.center.y)];
        [deleteButton addTarget:self action:@selector(deleteProduct: forEvent:) forControlEvents:UIControlEventTouchUpInside];
        [nameLabel setFrame:CGRectMake(brandLogo.frame.origin.x + brandLogo.frame.size.width + RelativeSize(5, 320), brandLogo.frame.origin.y + brandLogo.frame.size.height/2 - RelativeSize(15, 320), deleteButton.frame.origin.x - RelativeSize(5, 320) - (brandLogo.frame.origin.x + brandLogo.frame.size.width + RelativeSize(5, 320)), RelativeSize(15, 320))];
    }else if (self.cellModel.tileType == ProductTilePlain){
        [likeButton setFrame:CGRectMake(container.frame.origin.x + container.frame.size.width - RelativeSize(36, 320), brandLogo.frame.origin.y, RelativeSize(32, 320), RelativeSize(32, 320))];
        [likeButton setBackgroundImage:(self.cellModel.is_bookmarked ? selectedLikeImage : unselectedLikeImage) forState:UIControlStateNormal];
        [likeButton setCenter:CGPointMake(likeButton.center.x, brandLogo.center.y)];
        [likeButton addTarget:self action:@selector(toggleLike) forControlEvents:UIControlEventTouchUpInside];
        [nameLabel setFrame:CGRectMake(brandLogo.frame.origin.x + brandLogo.frame.size.width + RelativeSize(5, 320), brandLogo.frame.origin.y + brandLogo.frame.size.height/2 - RelativeSize(15, 320), likeButton.frame.origin.x - RelativeSize(5, 320) - (brandLogo.frame.origin.x + brandLogo.frame.size.width + RelativeSize(5, 320)), RelativeSize(15, 320))];
    }else if (self.cellModel.tileType == ProductTileAddToCartFromWishlist){
        [likeButton setFrame:CGRectMake(container.frame.origin.x + container.frame.size.width, brandLogo.frame.origin.y, 0, 0)];
        [likeButton setBackgroundImage:(self.cellModel.is_bookmarked ? selectedLikeImage : unselectedLikeImage) forState:UIControlStateNormal];
        [likeButton setCenter:CGPointMake(likeButton.center.x, brandLogo.center.y)];
        [nameLabel setFrame:CGRectMake(brandLogo.frame.origin.x + brandLogo.frame.size.width + RelativeSize(5, 320), brandLogo.frame.origin.y + brandLogo.frame.size.height/2 - RelativeSize(15, 320), likeButton.frame.origin.x - RelativeSize(5, 320) - (brandLogo.frame.origin.x + brandLogo.frame.size.width + RelativeSize(5, 320)), RelativeSize(15, 320))];
    }
    
    nameLabelFont = [UIFont fontWithName:kMontserrat_Light size:12.0f];
    [nameLabel setFont:nameLabelFont];
    [nameLabel setTextColor:UIColorFromRGB(kDarkPurpleColor)];
    [nameLabel setText:self.cellModel.product_name];
    
    if(self.cellModel.shouldShowMarkedPrice){
        markedPriceString = [NSString stringWithFormat:@"%@", self.cellModel.price_marked];
        NSMutableAttributedString *rupee1 = [[NSMutableAttributedString alloc] initWithString:kRupeeSymbol attributes:@{NSFontAttributeName : [UIFont fontWithName:kMontserrat_Regular size:10.0], NSForegroundColorAttributeName : UIColorFromRGB(kDarkPurpleColor)}];
        NSAttributedString *name1 = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@" %@ ", markedPriceString] attributes:@{NSFontAttributeName : [UIFont fontWithName:kMontserrat_Regular size:12.0], NSForegroundColorAttributeName : UIColorFromRGB(kDarkPurpleColor)}];

        [rupee1 appendAttributedString:name1];
        
        if([self.cellModel.price_marked isEqualToString:self.cellModel.price_effective]){
            rupee1 = [[NSMutableAttributedString alloc] init];
        }

        [rupee1 addAttributes:@{NSStrikethroughStyleAttributeName: @(NSUnderlineStyleSingle)
                                                     , NSStrikethroughColorAttributeName: [UIColor redColor]
                                                     } range:NSMakeRange(0, rupee1.length)];
        
        priceLabelRect = [rupee1 boundingRectWithSize:CGSizeMake(45, 25) options:NSStringDrawingTruncatesLastVisibleLine context:NULL];
        
        [priceLabel setFrame:CGRectMake(nameLabel.frame.origin.x, brandLogo.frame.origin.y + brandLogo.frame.size.height/2, priceLabelRect.size.width, priceLabelRect.size.height)];
        [priceLabel setAttributedText:rupee1];
        [priceLabel setBackgroundColor:[UIColor clearColor]];
        [priceLabel setTextColor:UIColorFromRGB(kDarkPurpleColor)];
    }
    
    NSMutableAttributedString *rupee = [[NSMutableAttributedString alloc] initWithString:kRupeeSymbol attributes:@{NSFontAttributeName : [UIFont fontWithName:kMontserrat_Regular size:10.0], NSForegroundColorAttributeName : UIColorFromRGB(kDarkPurpleColor)}];
    NSAttributedString *name = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@" %@", self.cellModel.price_effective] attributes:@{NSFontAttributeName : [UIFont fontWithName:kMontserrat_Regular size:12.0], NSForegroundColorAttributeName : UIColorFromRGB(kDarkPurpleColor)}];

    [rupee appendAttributedString:name];
    
    effectivePriceString = [NSString stringWithFormat:@"%@ %@",kRupeeSymbol, self.cellModel.price_effective];
    effectivePriceFont = [UIFont fontWithName:kMontserrat_Regular size:12.0];
    effectivePriceRect = [effectivePriceString sizeWithAttributes:@{NSFontAttributeName: effectivePriceFont}];
    
    if(self.cellModel.shouldShowMarkedPrice){
        [markedDownPriceLabel setFrame:CGRectMake(priceLabel.frame.origin.x + priceLabel.frame.size.width, brandLogo.frame.origin.y + brandLogo.frame.size.height/2, effectivePriceRect.width, effectivePriceRect.height)];
    }else{
        [markedDownPriceLabel setFrame:CGRectMake(nameLabel.frame.origin.x, brandLogo.frame.origin.y + brandLogo.frame.size.height/2, effectivePriceRect.width, effectivePriceRect.height)];
    }


    [markedDownPriceLabel setAttributedText:rupee];
    [markedDownPriceLabel setTextColor:UIColorFromRGB(kDarkPurpleColor)];

    //    [imgView sd_setImageWithURL:[NSURL URLWithString:[self.cellModel.product_image stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] placeholderImage:placeHolderImage completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
    [imgView sd_setImageWithURL:[NSURL URLWithString:[self.cellModel.product_image stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if(image)
        {
            self.isImageDownloaded = true;
            if(self.cellModel.tileType == ProductTileAddToCartFromWishlist || self.cellModel.tileType == ProductTileWishList
               ){
                [imgView setFrame:CGRectMake(RelativeSize(4, 320), RelativeSize(4, 320), container.frame.size.width - RelativeSize(8, 320), container.frame.size.height - 56 - 55)];
            }else{
                [imgView setFrame:CGRectMake(RelativeSize(4, 320), RelativeSize(4, 320), container.frame.size.width - RelativeSize(8, 320), container.frame.size.height - 56)];
            }
            [imgView setAlpha:0.3];
            [UIView animateWithDuration:0.4 animations:^{
                [imgView setAlpha:1.0];
            }];
        }
    }];
    
    if(self.cellModel.tileType == ProductTileAddToCartFromWishlist || self.cellModel.tileType == ProductTileWishList){

            
            addToCartString = [[NSMutableAttributedString alloc] initWithString:@"ADD TO BAG" attributes:@{NSForegroundColorAttributeName : [UIColor whiteColor], NSFontAttributeName : addToCartFont}];
            
            CGFloat originForCartButton = container.frame.size.height - (brandLogo.frame.origin.y + brandLogo.frame.size.height);
            originForCartButton = originForCartButton/2 - 20 + brandLogo.frame.origin.y + brandLogo.frame.size.height;

            [addToCartButton setFrame:CGRectMake(0, originForCartButton, container.frame.size.width - (RelativeSize(15, 320)), 40)];
            
            addToCartButton.layer.cornerRadius = 3.0;
            addToCartButton.clipsToBounds = YES;
            [addToCartButton addTarget:self action:@selector(addProduct:) forControlEvents:UIControlEventTouchUpInside];
            [addToCartButton setBackgroundImage:[SSUtility imageWithColor:UIColorFromRGB(kTurquoiseColor)] forState:UIControlStateNormal];
            [addToCartButton setBackgroundImage:[SSUtility imageWithColor:UIColorFromRGB(kButtonTouchStateColor)] forState:UIControlStateHighlighted];
            
            [addToCartButton setAttributedTitle:addToCartString forState:UIControlStateNormal];
            [addToCartButton setCenter:CGPointMake(container.frame.size.width/2, addToCartButton.center.y)];
        if(!self.cellModel.isOutOfStock){
            [addToCartButton setEnabled:TRUE];
        }else{
            [addToCartButton setEnabled:FALSE];
        }
        
        
        
    }
    if(!self.isImageDownloaded)
    {
//        [imgView setFrame:CGRectMake(self.frame.size.width/2 - placeHolderImage.size.width/2, self.frame.size.height/2 - placeHolderImage.size.height/2, placeHolderImage.size.width, placeHolderImage.size.height)];
        NSString *colorStr = [NSString stringWithFormat:@"#%@", self.cellModel.productColor];
        [imgView setBackgroundColor:[SSUtility colorFromHexString:colorStr withAlpha:0.2]];
    }
    
    if(self.cellModel.badgeString && self.cellModel.badgeString.length > 0){
        [badgeLabel setFrame:CGRectMake(imgView.frame.origin.x, imgView.frame.origin.y + imgView.frame.size.height - 25, imgView.frame.size.width, 25)];

        [badgeLabel setBackgroundColor:[UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.60]];
        badgeLabel.text = self.cellModel.badgeString;
        badgeLabel.textColor = UIColorFromRGB(kRedColor);
        badgeLabel.font = [UIFont fontWithName:kMontserrat_Regular size:13.0];
        badgeLabel.textAlignment = NSTextAlignmentCenter;
    }
    
    if(self.cellModel.discountString && self.cellModel.discountString.length > 0){
        discountImage = [UIImage imageNamed:@"DiscountBadge"];
        [discountImageView setFrame:CGRectMake(0, 0, discountImage.size.width, discountImage.size.height)];
        discountImageView.image = discountImage;
        [discountContainerView setFrame:CGRectMake(imgView.frame.origin.x + imgView.frame.size.width - discountImage.size.width - 3, 0, discountImageView.frame.size.width, discountImageView.frame.size.height)];

        NSMutableParagraphStyle *style  = [[NSMutableParagraphStyle alloc] init];
        style.minimumLineHeight = 8;
        style.maximumLineHeight = 10;
        style.alignment = NSTextAlignmentCenter;
//        [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, label.text.length)];
        
        
        
        NSRange percentRange = [self.cellModel.discountString rangeOfString:@"%"];
        
        NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:self.cellModel.discountString attributes:@{NSFontAttributeName : [UIFont fontWithName:kMontserrat_Regular size:10.0], NSForegroundColorAttributeName : UIColorFromRGB(kRedColor), NSParagraphStyleAttributeName : style}];
        [string setAttributes:@{NSFontAttributeName : [UIFont fontWithName:kMontserrat_Regular size:9.0], NSForegroundColorAttributeName : UIColorFromRGB(kRedColor)} range:percentRange];
        
        
        [discountLabel setFrame:CGRectMake(0, 0, discountContainerView.frame.size.width, discountContainerView.frame.size.height - 5)];
        discountLabel.lineBreakMode = NSLineBreakByWordWrapping;
        discountLabel.numberOfLines = 0;
        discountLabel.textAlignment = NSTextAlignmentCenter;
        [discountLabel setAttributedText:string];
        [discountContainerView bringSubviewToFront:discountLabel];
    }
}
*/
-(void)layoutSubviews{
    
    [super layoutSubviews];
    selectedLikeImage = [UIImage imageNamed:@"WishListFilled"];
    unselectedLikeImage = [UIImage imageNamed:@"WishList"];
    placeHolderImage = [UIImage imageNamed:@"ImagePlaceholder"];
    [container setFrame:CGRectMake(RelativeSize(3, 320), RelativeSize(4, 320), self.frame.size.width - RelativeSize(6, 320), self.frame.size.height - RelativeSize(8, 320))];
    container.layer.cornerRadius = 3.0;
    [container setBackgroundColor:[UIColor whiteColor]];
    container.layer.shadowColor = UIColorFromRGB(kShadowColor).CGColor;
    [container.layer setShadowOpacity:0.1];
    [container.layer setShadowOffset:CGSizeMake(0.0, 1.0)];
    
    if(self.cellModel.tileType == ProductTileAddToCartFromWishlist || self.cellModel.tileType == ProductTileWishList){
        [imgView setFrame:CGRectMake(RelativeSize(4, 320), RelativeSize(4, 320), container.frame.size.width - RelativeSize(8, 320), container.frame.size.height - 56 - RelativeSizeHeight(50, 667))];
    }else{
        [imgView setFrame:CGRectMake(RelativeSize(4, 320), RelativeSize(4, 320), container.frame.size.width - RelativeSize(8, 320), container.frame.size.height - 56)];
    }
    if(self.cellModel.tileType == ProductTileAddToCartFromWishlist || self.cellModel.tileType == ProductTileWishList){
        [brandLogo setFrame:CGRectMake(imgView.frame.origin.x, imgView.frame.origin.y + imgView.frame.size.height + RelativeSizeHeight(10, 667), RelativeSize(28, 320),RelativeSize(28, 320))];
    }else{
        [brandLogo setFrame:CGRectMake(imgView.frame.origin.x, imgView.frame.origin.y + imgView.frame.size.height + (container.frame.size.height - (imgView.frame.origin.y + imgView.frame.size.height + RelativeSize(28, 320)))/2, RelativeSize(28, 320),RelativeSize(28, 320))];
    }
    [brandLogo.layer setBorderColor:UIColorFromRGB(kBorderColor).CGColor];
    [brandLogo.layer setCornerRadius:3.0f];
    [brandLogo.layer setBorderWidth:1];
    brandLogo.clipsToBounds = YES;
    
    [brandLogo sd_setImageWithURL:[NSURL URLWithString:[self.cellModel.productLogo stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
    
    if (self.cellModel.tileType == ProductTileWishList) {
        [deleteButton setFrame:CGRectMake(container.frame.origin.x + container.frame.size.width - 40, brandLogo.frame.origin.y, 32, 32)];
        [deleteButton setBackgroundImage:(self.cellModel.is_bookmarked ? selectedLikeImage : unselectedLikeImage) forState:UIControlStateNormal];
        [deleteButton setCenter:CGPointMake(deleteButton.center.x, brandLogo.center.y)];
        [deleteButton addTarget:self action:@selector(deleteProduct: forEvent:) forControlEvents:UIControlEventTouchUpInside];
        [nameLabel setFrame:CGRectMake(brandLogo.frame.origin.x + brandLogo.frame.size.width + RelativeSize(5, 320), brandLogo.frame.origin.y + brandLogo.frame.size.height/2 - RelativeSize(15, 320), deleteButton.frame.origin.x - RelativeSize(5, 320) - (brandLogo.frame.origin.x + brandLogo.frame.size.width + RelativeSize(5, 320)), RelativeSize(15, 320))];
    }else if (self.cellModel.tileType == ProductTilePlain){
        [likeButton setFrame:CGRectMake(container.frame.origin.x + container.frame.size.width - RelativeSize(36, 320), brandLogo.frame.origin.y, RelativeSize(32, 320), RelativeSize(32, 320))];
        [likeButton setBackgroundImage:(self.cellModel.is_bookmarked ? selectedLikeImage : unselectedLikeImage) forState:UIControlStateNormal];
        [likeButton setCenter:CGPointMake(likeButton.center.x, brandLogo.center.y)];
        [likeButton addTarget:self action:@selector(toggleLike) forControlEvents:UIControlEventTouchUpInside];
        [nameLabel setFrame:CGRectMake(brandLogo.frame.origin.x + brandLogo.frame.size.width + RelativeSize(5, 320), brandLogo.frame.origin.y + brandLogo.frame.size.height/2 - RelativeSize(15, 320), likeButton.frame.origin.x - RelativeSize(5, 320) - (brandLogo.frame.origin.x + brandLogo.frame.size.width + RelativeSize(5, 320)), RelativeSize(15, 320))];
    }else if (self.cellModel.tileType == ProductTileAddToCartFromWishlist){
        [likeButton setFrame:CGRectMake(container.frame.origin.x + container.frame.size.width, brandLogo.frame.origin.y, 0, 0)];
        [likeButton setBackgroundImage:(self.cellModel.is_bookmarked ? selectedLikeImage : unselectedLikeImage) forState:UIControlStateNormal];
        [likeButton setCenter:CGPointMake(likeButton.center.x, brandLogo.center.y)];
        [nameLabel setFrame:CGRectMake(brandLogo.frame.origin.x + brandLogo.frame.size.width + RelativeSize(5, 320), brandLogo.frame.origin.y + brandLogo.frame.size.height/2 - RelativeSize(15, 320), likeButton.frame.origin.x - RelativeSize(5, 320) - (brandLogo.frame.origin.x + brandLogo.frame.size.width + RelativeSize(5, 320)), RelativeSize(15, 320))];
    }
    
    nameLabelFont = [UIFont fontWithName:kMontserrat_Light size:12.0f];
    [nameLabel setFont:nameLabelFont];
    [nameLabel setTextColor:UIColorFromRGB(kDarkPurpleColor)];
    [nameLabel setText:self.cellModel.product_name];
    
    
    NSMutableAttributedString *rupee = [[NSMutableAttributedString alloc] initWithString:kRupeeSymbol attributes:@{NSFontAttributeName : [UIFont fontWithName:kMontserrat_Regular size:10.0], NSForegroundColorAttributeName : UIColorFromRGB(kDarkPurpleColor)}];
    NSAttributedString *name = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@" %@", self.cellModel.price_effective] attributes:@{NSFontAttributeName : [UIFont fontWithName:kMontserrat_Regular size:12.0], NSForegroundColorAttributeName : UIColorFromRGB(kDarkPurpleColor)}];
    
    [rupee appendAttributedString:name];
    
    effectivePriceString = [NSString stringWithFormat:@"%@ %@",kRupeeSymbol, self.cellModel.price_effective];
    effectivePriceFont = [UIFont fontWithName:kMontserrat_Regular size:12.0];
    effectivePriceRect = [effectivePriceString sizeWithAttributes:@{NSFontAttributeName: effectivePriceFont}];
    
    [markedDownPriceLabel setFrame:CGRectMake(nameLabel.frame.origin.x, brandLogo.frame.origin.y + brandLogo.frame.size.height/2, effectivePriceRect.width, effectivePriceRect.height)];
    
    [markedDownPriceLabel setAttributedText:rupee];
    [markedDownPriceLabel setTextColor:UIColorFromRGB(kDarkPurpleColor)];
    
    
    if(self.cellModel.shouldShowMarkedPrice){
        markedPriceString = [NSString stringWithFormat:@"%@", self.cellModel.price_marked];
        NSMutableAttributedString *rupee1 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@", kRupeeSymbol] attributes:@{NSFontAttributeName : [UIFont fontWithName:kMontserrat_Light size:10.0], NSForegroundColorAttributeName : UIColorFromRGB(kRedColor)}];
        NSAttributedString *name1 = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@" %@ ", markedPriceString] attributes:@{NSFontAttributeName : [UIFont fontWithName:kMontserrat_Light size:12.0], NSForegroundColorAttributeName : UIColorFromRGB(kRedColor)}];
        
        [rupee1 appendAttributedString:name1];
        
        if([self.cellModel.price_marked isEqualToString:self.cellModel.price_effective]){
            rupee1 = [[NSMutableAttributedString alloc] init];
        }
        
        [rupee1 addAttributes:@{NSStrikethroughStyleAttributeName: @(NSUnderlineStyleSingle)
                                , NSStrikethroughColorAttributeName: UIColorFromRGB(kRedColor)
                                } range:NSMakeRange(0, rupee1.length)];
        
        priceLabelRect = [rupee1 boundingRectWithSize:CGSizeMake(45, 25) options:NSStringDrawingTruncatesLastVisibleLine context:NULL];
        
        [priceLabel setFrame:CGRectMake(markedDownPriceLabel.frame.origin.x + markedDownPriceLabel.frame.size.width + 3, markedDownPriceLabel.frame.origin.y, priceLabelRect.size.width, priceLabelRect.size.height)];
        [priceLabel setAttributedText:rupee1];
        [priceLabel setBackgroundColor:[UIColor clearColor]];
        [priceLabel setTextColor:UIColorFromRGB(kRedColor)];
    }
    
    [imgView sd_setImageWithURL:[NSURL URLWithString:[self.cellModel.product_image stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if(image)
        {
            self.isImageDownloaded = true;
            if(self.cellModel.tileType == ProductTileAddToCartFromWishlist || self.cellModel.tileType == ProductTileWishList){
                    [imgView setFrame:CGRectMake(RelativeSize(4, 320), RelativeSize(4, 320), container.frame.size.width - RelativeSize(8, 320), container.frame.size.height - 56 - 55)];
                if(self.cellModel.badgeString && self.cellModel.badgeString.length > 0){
                    [badgeLabel setFrame:CGRectMake(imgView.frame.origin.x, imgView.frame.origin.y + imgView.frame.size.height - 25, imgView.frame.size.width, 25)];
                }
            }else{
                [imgView setFrame:CGRectMake(RelativeSize(4, 320), RelativeSize(4, 320), container.frame.size.width - RelativeSize(8, 320), container.frame.size.height - 56)];
            }
            [imgView setAlpha:0.3];
            [UIView animateWithDuration:0.4 animations:^{
                [imgView setAlpha:1.0];
            }];
        }
    }];
    
    if(self.cellModel.tileType == ProductTileAddToCartFromWishlist || self.cellModel.tileType == ProductTileWishList){
        
        addToCartString = [[NSMutableAttributedString alloc] initWithString:@"ADD TO BAG" attributes:@{NSForegroundColorAttributeName : [UIColor whiteColor], NSFontAttributeName : addToCartFont}];
        
        CGFloat originForCartButton = container.frame.size.height - (brandLogo.frame.origin.y + brandLogo.frame.size.height);
        originForCartButton = originForCartButton/2 - 20 + brandLogo.frame.origin.y + brandLogo.frame.size.height;
        
        [addToCartButton setFrame:CGRectMake(0, originForCartButton, container.frame.size.width - (RelativeSize(15, 320)), 40)];
        
        addToCartButton.layer.cornerRadius = 3.0;
        addToCartButton.clipsToBounds = YES;
        [addToCartButton addTarget:self action:@selector(addProduct:) forControlEvents:UIControlEventTouchUpInside];
        [addToCartButton setBackgroundImage:[SSUtility imageWithColor:UIColorFromRGB(kTurquoiseColor)] forState:UIControlStateNormal];
        [addToCartButton setBackgroundImage:[SSUtility imageWithColor:UIColorFromRGB(kButtonTouchStateColor)] forState:UIControlStateHighlighted];
        
        [addToCartButton setAttributedTitle:addToCartString forState:UIControlStateNormal];
        [addToCartButton setCenter:CGPointMake(container.frame.size.width/2, addToCartButton.center.y)];
        if(!self.cellModel.isOutOfStock){
            [addToCartButton setEnabled:TRUE];
        }else{
            [addToCartButton setEnabled:FALSE];
        }
        
    }
    if(!self.isImageDownloaded)
    {
        NSString *colorStr = [NSString stringWithFormat:@"#%@", self.cellModel.productColor];
        [imgView setBackgroundColor:[SSUtility colorFromHexString:colorStr withAlpha:0.2]];
    }
    
    if(self.cellModel.badgeString && self.cellModel.badgeString.length > 0){
                
        [badgeLabel setFrame:CGRectMake(imgView.frame.origin.x, imgView.frame.origin.y + imgView.frame.size.height - 25, imgView.frame.size.width, 25)];
        [badgeLabel setBackgroundColor:[UIColor whiteColor]];
        
        [badgeLabel setBackgroundColor:[UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.6]];
        badgeLabel.text = self.cellModel.badgeString;
        badgeLabel.textColor = UIColorFromRGB(kRedColor);
        badgeLabel.font = [UIFont fontWithName:kMontserrat_Regular size:13.0];
        badgeLabel.textAlignment = NSTextAlignmentCenter;
    }
    
    if(self.cellModel.discountString && self.cellModel.discountString.length > 0){
        discountImage = [UIImage imageNamed:@"DiscountBadge"];
        [discountImageView setFrame:CGRectMake(0, 0, discountImage.size.width, discountImage.size.height)];
        discountImageView.image = discountImage;
        [discountContainerView setFrame:CGRectMake(imgView.frame.origin.x + imgView.frame.size.width - discountImage.size.width - 3, 0, discountImageView.frame.size.width, discountImageView.frame.size.height)];
        
        NSMutableParagraphStyle *style  = [[NSMutableParagraphStyle alloc] init];
        style.minimumLineHeight = 8;
        style.maximumLineHeight = 10;
        style.alignment = NSTextAlignmentCenter;
        
        NSRange percentRange = [self.cellModel.discountString rangeOfString:@"%"];
        
        NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:self.cellModel.discountString attributes:@{NSFontAttributeName : [UIFont fontWithName:kMontserrat_Regular size:10.0], NSForegroundColorAttributeName : UIColorFromRGB(kRedColor), NSParagraphStyleAttributeName : style}];
        [string setAttributes:@{NSFontAttributeName : [UIFont fontWithName:kMontserrat_Regular size:9.0], NSForegroundColorAttributeName : UIColorFromRGB(kRedColor)} range:percentRange];
        
        [discountLabel setFrame:CGRectMake(0, 0, discountContainerView.frame.size.width, discountContainerView.frame.size.height - 5)];
        discountLabel.lineBreakMode = NSLineBreakByWordWrapping;
        discountLabel.numberOfLines = 0;
        discountLabel.textAlignment = NSTextAlignmentCenter;
        [discountLabel setAttributedText:string];
        [discountContainerView bringSubviewToFront:discountLabel];
    }
}
-(void)removeShadow{
    [container.layer setShadowOpacity:0.0];
    [container.layer setShadowOffset:CGSizeMake(0.0, 0.0)];
}

- (void)addProduct:(id)sender{
    if(self.addWishListProductBlock){
        self.addWishListProductBlock(self.cellModel.productID, self.cellModel);
    }
}

-(void)toggleLike{
    
//    NSString *source = [SSUtility traverseToGetControllerName:self];
//    if(self.isSearched){
//        source = @"search";
//    }
//    if(self.isBrowsed){
//        source = @"category";
//    }
    
    
    if(likeTimer){
        [likeTimer invalidate];
        likeTimer = nil;
    }
    likeTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(hitLike) userInfo:nil repeats:NO];

    self.cellModel.is_bookmarked = !self.cellModel.is_bookmarked;
    [likeButton setBackgroundImage:self.cellModel.is_bookmarked ? selectedLikeImage : unselectedLikeImage forState:UIControlStateNormal];
    
//    if(!self.cellModel.is_bookmarked){
//        [FyndAnalytics trackProductLike:source itemCode:self.cellModel.productID brandName:self.cellModel.brand_name isProductUnlike:YES productCategory:@"" productSubcategory:@""];
//    }else{
//        [FyndAnalytics trackProductLike:source itemCode:self.cellModel.productID brandName:self.cellModel.brand_name isProductUnlike:NO productCategory:@"" productSubcategory:@""];
//    }
}

-(void)hitLike{
    NSMutableString *urlString = [[NSMutableString alloc] initWithString:kAPI_Inventory];
    NSString *likeURL;
    if(!self.cellModel.is_bookmarked ){
        likeURL = [NSString stringWithFormat:@"%@%@", kProductUnlikeURL, self.cellModel.productID];
    }else{
        likeURL = [NSString stringWithFormat:@"%@%@", kProductLikeURL, self.cellModel.productID];
    }

    [urlString appendString:likeURL];

    if(!likeSession){
        likeSession = [NSURLSession sharedSession];
    }

    NSURL *requestURL = [NSURL URLWithString:urlString];
    NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:requestURL];
    NSArray *availableCookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookiesForURL:[req URL]];
    NSDictionary * headers = [NSHTTPCookie requestHeaderFieldsWithCookies:availableCookies];
    
    if([availableCookies count] >0)
        [req setAllHTTPHeaderFields:[headers copy]];
    
    NSURLSessionDataTask *likeTask = [likeSession dataTaskWithRequest:req completionHandler:^(NSData *data, NSURLResponse *response, NSError *error){
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        if([json count] > 0){
            NSHTTPURLResponse *theURLResponse = (NSHTTPURLResponse *)response;

            NSArray *cookies = [NSHTTPCookie cookiesWithResponseHeaderFields:[theURLResponse allHeaderFields] forURL:[req URL]];
            [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookies:cookies forURL:[req URL] mainDocumentURL:[req URL]];
            
            
            NSString *source = [SSUtility traverseToGetControllerName:self];
            if(self.isSearched){
                source = @"search";
            }
            if(self.isBrowsed){
                source = @"category";
            }

            if([likeURL rangeOfString:@"unfollow"].length > 0){
                [FyndAnalytics trackProductLike:source itemCode:self.cellModel.productID brandName:self.cellModel.brand_name isProductUnlike:YES productCategory:@"" productSubcategory:@""];
                
            }else{
                [FyndAnalytics trackProductLike:source itemCode:self.cellModel.productID brandName:self.cellModel.brand_name isProductUnlike:NO productCategory:@"" productSubcategory:@""];
            }
            
        }else {
        }
    }];
    [likeTask resume];
}

-(void)deleteProduct:(id)sender forEvent:(UIEvent *)theEvent{

    UIButton *theCell = (UIButton *)sender;
    UITouch *touch = [[theEvent touchesForView:theCell] anyObject];
    //    CGPoint location = [touch locationInView:theCell];
    

    self.cellModel.is_bookmarked = !self.cellModel.is_bookmarked;
    
    if (self.theProductLocationBlock) {
        if (self.cellModel.is_bookmarked) {
            self.theProductLocationBlock(touch,TRUE);
        }else{
            self.theProductLocationBlock(touch,FALSE);
        }

    }
    
    NSString *source = [SSUtility traverseToGetControllerName:self];
    if(self.isSearched){
        source = @"search";
    }
    if(self.isBrowsed){
        source = @"category";
    }
    
    [deleteButton setBackgroundImage:self.cellModel.is_bookmarked ? selectedLikeImage : unselectedLikeImage forState:UIControlStateNormal];
    if(!self.cellModel.is_bookmarked){
        [FyndAnalytics trackProductLike:source itemCode:self.cellModel.productID brandName:self.cellModel.brand_name isProductUnlike:YES productCategory:@"" productSubcategory:@""];
    }else{
        [FyndAnalytics trackProductLike:source itemCode:self.cellModel.productID brandName:self.cellModel.brand_name isProductUnlike:NO productCategory:@"" productSubcategory:@""];
    }
    [self hitLike];
//    [self toggleLike];
}

-(CGFloat)getHeightFromAspectRatio:(NSString *)aspectRatio andWidth:(CGFloat)width{
    CGFloat height = 0;
    NSArray *ratioArray = [aspectRatio componentsSeparatedByString:@":"];
    height = width * [[ratioArray lastObject] floatValue] / [[ratioArray firstObject] floatValue];
    return height;
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    if (!addToCartButton.enabled &&
        [addToCartButton pointInside:[self convertPoint:point toView:addToCartButton]
                            withEvent:nil]) {
            return nil;
        }
    return [super hitTest:point withEvent:event];
}

@end
