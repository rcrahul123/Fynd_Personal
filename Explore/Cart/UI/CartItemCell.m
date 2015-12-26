//
//  CartItemCell.m
//  Explore
//
//  Created by Pranav on 01/09/15.
//  Copyright (c) 2015 Rahul. All rights reserved.
//

#import "CartItemCell.h"
#import "SSUtility.h"
#import "SSLine.h"
#import "PopOverlayHandler.h"

#define kCardImageViewWidth    70
#define kDeleteButtonViewWidth 70

@interface CartItemCell ()<PopOverlayHandlerDelegate>{
    UIImage *placeHolderImage;
}
@property (nonatomic, assign) BOOL isImageDownloaded;
@property (nonatomic,strong) UIImageView    *cartImage;
@property (nonatomic,strong) UIActivityIndicatorView  *cartItemActivityIndicator;
@property (nonatomic,strong) UILabel        *brandName;
@property (nonatomic,strong) UILabel        *itemName;
@property (nonatomic,strong) UILabel        *price;
@property (nonatomic,strong) UILabel        *size;
@property (nonatomic,strong) UILabel        *quantity;
@property (nonatomic,strong) UILabel        *tryAtHome;
@property (nonatomic,strong) UIButton       *editButton;
@property (nonatomic,strong) UIButton       *deleteButton;
@property (nonatomic,strong) SSLine         *horizontalLine;
//@property (nonatomic,strong) SSLine         *verticalLineView1;
//@property (nonatomic,strong) UIView         *verticalLineView;
@property (nonatomic,strong) UIButton    *crossImage;
@property (nonatomic,strong) UILabel        *cartUnavailabilityMessage;
@property (nonatomic,strong) UITapGestureRecognizer *cartItemTapGesture;
@property (nonatomic,strong) PopOverlayHandler      *poverlayHandler;


@property (nonatomic,strong) UIView         *swipeButtonView;
@property (nonatomic,strong) UIButton    *deleteItemButton;
//- (void)configureItemLayout;
@end

@implementation CartItemCell

#define cart_x_padding 10


- (id)init{
    if(self == [super init]){
    }
    return self;
}


- (void)configureItemLayout{

    self.cardMainView = [[UIView alloc] initWithFrame:CGRectMake(RelativeSize(6, 320), 0, self.contentView.frame.size.width-(RelativeSize(12, 320)), self.contentView.frame.size.height)];
    self.cardMainView.layer.cornerRadius =  3.0f;
    self.cardMainView.clipsToBounds= TRUE;

    [self.cardMainView setBackgroundColor:[UIColor whiteColor]];
    [self setBackgroundColor:[UIColor clearColor]];



    [self.contentView addSubview:self.cardMainView];

    self.swipeButtonView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.swipeButtonView setBackgroundColor:UIColorFromRGB(kBackgroundGreyColor)];
    
    self.deleteItemButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    [self.swipeButtonView addSubview:self.deleteItemButton];
    
    [self.contentView addSubview:self.swipeButtonView];

    
    UIPanGestureRecognizer *thePan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
    thePan.minimumNumberOfTouches=1;
    thePan.maximumNumberOfTouches = 1;
    thePan.delegate = self;
    [self.cardMainView addGestureRecognizer:thePan];
    
    
    self.cartImage = [[UIImageView alloc] initWithFrame:CGRectZero];
    [self.cartImage setUserInteractionEnabled:TRUE];
    self.cartItemTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cartImageTapped:)];
    [self.cartImage addGestureRecognizer:self.cartItemTapGesture];
    [self.cartImage setBackgroundColor:[UIColor clearColor]];
    [self.cardMainView addSubview:self.cartImage];
    
    self.brandName = [[UILabel alloc] initWithFrame:CGRectZero];
    [self.brandName setBackgroundColor:[UIColor clearColor]];
    [self.cardMainView addSubview:self.brandName];
    
    self.itemName = [[UILabel alloc] initWithFrame:CGRectZero];
    [self.itemName setBackgroundColor:[UIColor clearColor]];
    [self.cardMainView addSubview:self.itemName];
    
    
    self.price = [[UILabel alloc] initWithFrame:CGRectZero];
    [self.price setBackgroundColor:[UIColor clearColor]];
    [self.cardMainView addSubview:self.price];
    
    self.size = [[UILabel alloc] initWithFrame:CGRectZero];
    [self.size setBackgroundColor:[UIColor clearColor]];
    [self.cardMainView addSubview:self.size];
    
    
    self.editButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.editButton setFrame:CGRectZero];
    [self.editButton setBackgroundImage:[UIImage imageNamed:@"BagEdit"] forState:UIControlStateNormal];
    [self.editButton setBackgroundImage:[UIImage imageNamed:@"BagEditTouch"] forState:UIControlStateHighlighted];
    [self.editButton setBackgroundColor:[UIColor clearColor]];
    [self.cardMainView addSubview:self.editButton];
    
    
//    if(self.cartCellData.highlighted || self.cartCellData.outOfStock){
        self.cartUnavailabilityMessage = [[UILabel alloc] initWithFrame:CGRectZero];
        [self.cartUnavailabilityMessage setBackgroundColor:[UIColor clearColor]];
        [self.cardMainView addSubview:self.cartUnavailabilityMessage];
//    }
}


- (void)cartImageTapped:(id)sender{
    if(self.cartItemPDP){
        self.cartItemPDP(self.cartCellData.action.url);
    }
}

- (void)layoutSubviews{

    [super layoutSubviews];
    [self.contentView setBackgroundColor:[UIColor clearColor]];
    placeHolderImage = [UIImage imageNamed:@"ImagePlaceholder"];

    CGFloat cartItemHeight =[self getCartItemAspectRatio:self.cartCellData.productImageAspectRatio andWidth:kCardImageViewWidth];

    [self.cartImage setFrame:CGRectMake(cart_x_padding/2, cart_x_padding/2, kCardImageViewWidth, cartItemHeight)];
    
    CGSize dynamicSize = CGSizeZero;
    
    [self.cartImage sd_setImageWithURL:[NSURL URLWithString:[self.cartCellData.productImageUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if (!self.isImageDownloaded) {
          [self.cartImage setAlpha:0.3];
        }
        self.isImageDownloaded = true;
        [self.cartImage setFrame:CGRectMake(cart_x_padding/2, cart_x_padding/2, kCardImageViewWidth, cartItemHeight)];
        [UIView animateWithDuration:0.2 animations:^{
            [self.cartImage setAlpha:1.0];
        }];
    }];
    
    
    dynamicSize = [SSUtility getLabelDynamicSize:self.cartCellData.itemBrandName withFont:[UIFont fontWithName:kMontserrat_Light size:14.0f] withSize:CGSizeMake(self.frame.size.width/2, MAXFLOAT)];
    [self.brandName setFrame:CGRectMake(self.cartImage.frame.origin.x + self.cartImage.frame.size.width + cart_x_padding, 1*cart_x_padding, dynamicSize.width, dynamicSize.height)];
    [self.brandName setTextColor:UIColorFromRGB(kGenderSelectorTintColor)];
    [self.brandName setNumberOfLines:1];
    [self.brandName setFont:[UIFont fontWithName:kMontserrat_Light size:14.0f]];
    [self.brandName setText:self.cartCellData.itemBrandName];
    
    
    dynamicSize = [SSUtility getLabelDynamicSize:self.cartCellData.itemName withFont:[UIFont fontWithName:kMontserrat_Light size:14.0f] withSize:CGSizeMake(self.frame.size.width - (self.brandName.frame.origin.x+40), 30)];
    [self.itemName setFrame:CGRectMake(self.brandName.frame.origin.x, self.brandName.frame.origin.y + self.brandName.frame.size.height+cart_x_padding/2, dynamicSize.width, dynamicSize.height)];
    [self.itemName setNumberOfLines:1];
    [self.itemName setTextColor:UIColorFromRGB(kGenderSelectorTintColor)];
    [self.itemName setText:self.cartCellData.itemName];
    [self.itemName setFont:[UIFont fontWithName:kMontserrat_Light size:14.0f]];
    
    NSString *priceString = [NSString stringWithFormat:@"%@ %@  |  %@",kRupeeSymbol,self.cartCellData.itemCost,self.cartCellData.itemSize];
    dynamicSize = [SSUtility getLabelDynamicSize:priceString withFont:[UIFont fontWithName:kMontserrat_Regular size:14.0f] withSize:CGSizeMake(self.frame.size.width/2, MAXFLOAT)];

    [self.price setFrame:CGRectMake(self.itemName.frame.origin.x, self.contentView.frame.size.height - cart_x_padding-dynamicSize.height, dynamicSize.width, dynamicSize.height)];
    
    [self.price setText:priceString];
    [self.price setFont:[UIFont fontWithName:kMontserrat_Regular size:14.0f]];
    
    
    if(self.cartCellData.tryAtHomeSelected){
        CGSize size = [SSUtility getLabelDynamicSize:@"FYND A FIT" withFont:[UIFont fontWithName:kMontserrat_Regular size:15.0f] withSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
        UILabel *tryAtHome =[SSUtility generateLabel:@"FYND A FIT" withRect:CGRectMake(self.price.frame.origin.x + self.price.frame.size.width+5, self.price.frame.origin.y, 200, size.height) withFont:[UIFont fontWithName:kMontserrat_Regular size:15.0f]];
        [tryAtHome setTextAlignment:NSTextAlignmentLeft];
        [tryAtHome setFont:[UIFont fontWithName:kMontserrat_Regular size:15.0f]];
        [tryAtHome setTextColor:UIColorFromRGB(kButtonPurpleColor)];
        [tryAtHome setBackgroundColor:[UIColor clearColor]];
        [self.cardMainView addSubview:tryAtHome];
    }
    

    if(self.cartCellData.highlighted)
    {
        self.cardMainView.layer.cornerRadius = 5.0f;
        self.cardMainView.layer.borderWidth = 1.0f;
        self.cardMainView.layer.borderColor = UIColorFromRGB(kRedColor).CGColor;
    }
        NSString *messageString = nil;
        
        if(self.cartCellData.highlighted){
            messageString = self.cartCellData.message;
            [self.cartUnavailabilityMessage setTextColor:UIColorFromRGB(kRedColor)];
        }else{
            
            if ([self.cartCellData.message rangeOfString:@"Rs"].length>0) {
                
                NSArray *messageStringArray = [self.cartCellData.message componentsSeparatedByString:@"Rs"];
                
                NSMutableAttributedString *priceValueInitial = [[NSMutableAttributedString alloc] initWithString:[messageStringArray objectAtIndex:0] attributes:@{NSFontAttributeName:[UIFont fontWithName:kMontserrat_Light size:12.0f]}];
                
                NSMutableAttributedString *ruppeeSymbol = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@",kRupeeSymbol] attributes:@{NSFontAttributeName:[UIFont fontWithName:kMontserrat_Light size:11.0f]}];
                
                NSMutableAttributedString *priceValueFinal = [[NSMutableAttributedString alloc] initWithString:[messageStringArray objectAtIndex:1] attributes:@{NSFontAttributeName:[UIFont fontWithName:kMontserrat_Light size:12.0f]}];
                
                [priceValueInitial appendAttributedString:ruppeeSymbol];
                [priceValueInitial appendAttributedString:priceValueFinal];
                messageString = [priceValueInitial string];
                
                [self.cartUnavailabilityMessage setTextColor:UIColorFromRGB(kGreenColor)];
            }else{
                messageString = self.cartCellData.message;
                [self.cartUnavailabilityMessage setTextColor:UIColorFromRGB(kRedColor)];

            }
            
        }
        
        /*
         if(self.cartCellData.outOfStock){
         messageString = @"Out of Stock";
         }else if(self.cartCellData.highlighted){
         messageString = @"Cannot be delivered";
         }else if (self.cartCellData.hasPriceChanged){
         //Check if price has increased or decreased.
         if ([self.cartCellData.changedPriceValue isEqualToString:@"0"]) {
         messageString = @"Price has changed";
         }else{
         NSMutableAttributedString *ruppeeSymbol = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@ ",kRupeeSymbol] attributes:@{NSFontAttributeName:[UIFont fontWithName:kMontserrat_Regular size:13.0f]}];
         //                int priceValue = (int)self.cartCellData.hasPriceChanged * -1;
         NSAttributedString *priceValueString = [[NSAttributedString alloc] initWithString:self.cartCellData.changedPriceValue attributes:@{NSFontAttributeName:[UIFont fontWithName:kMontserrat_Regular size:15.0f]}];
         
         [ruppeeSymbol appendAttributedString:priceValueString];
         messageString = [NSString stringWithFormat:@"You save %@",ruppeeSymbol];
         }
         }
         */
        
        CGSize mesaageSize = [SSUtility getLabelDynamicSize:messageString withFont:[UIFont fontWithName:kMontserrat_Light size:15.0f] withSize:CGSizeMake(self.frame.size.width - (self.horizontalLine.frame.origin.x), 20.0f)];

        [self.cartUnavailabilityMessage setFrame:CGRectMake(self.itemName.frame.origin.x, self.itemName.frame.origin.y + self.itemName.frame.size.height + cart_x_padding, mesaageSize.width,mesaageSize.height)];
//        [self.cartUnavailabilityMessage setFrame:CGRectMake(self.horizontalLine.frame.origin.x, self.horizontalLine.frame.origin.y + cart_x_padding, mesaageSize.width,mesaageSize.height)];
        [self.cartUnavailabilityMessage setFont:[UIFont fontWithName:kMontserrat_Light size:12.0f]];
        [self.cartUnavailabilityMessage setText:messageString];

//        [self.cartUnavailabilityMessage setTextColor:UIColorFromRGB(kRedColor)];


        [self.cardMainView bringSubviewToFront:self.cartUnavailabilityMessage];
        
//    }

    
    if(!self.isImageDownloaded){
        NSString *colorStr = @"#C4DDE0";
        [self.cartImage setBackgroundColor:[SSUtility colorFromHexString:colorStr withAlpha:0.2]];
    }
    [self.cardMainView setFrame:CGRectMake(RelativeSize(6, 320), 0, self.contentView.frame.size.width-RelativeSize(12, 320), self.contentView.frame.size.height)];


    [self.swipeButtonView setFrame:CGRectMake(self.contentView.frame.size.width - kDeleteButtonViewWidth, 0, kDeleteButtonViewWidth, self.contentView.frame.size.height)];
    
    [self.deleteItemButton setFrame:CGRectMake(self.swipeButtonView.frame.size.width/2- 15, self.swipeButtonView.frame.size.height/2- 20, 30, 30)];


    [self.deleteItemButton setBackgroundImage:[UIImage imageNamed:@"DeleteCartItem"] forState:UIControlStateNormal];
    [self.deleteItemButton setBackgroundImage:[UIImage imageNamed:@"DeleteCartItemTouch"] forState:UIControlStateHighlighted];
    [self.deleteItemButton addTarget:self action:@selector(deleteCart:) forControlEvents:UIControlEventTouchUpInside];
    

    [self.contentView bringSubviewToFront:self.cardMainView];

    //Setting Edit Icon
    
    [self.editButton setFrame:CGRectMake(self.cardMainView.frame.size.width - 40, self.cardMainView.frame.size.height/2 -20, 30, 30)];
    [self.editButton addTarget:self action:@selector(editCart:) forControlEvents:UIControlEventTouchUpInside];
}


-(void)deleteInvalidCartItem:(id)sender{
    self.cardDelete(self.cartCellData);
}


- (CGFloat)getCartItemAspectRatio:(NSString *)aspectRatio andWidth:(CGFloat)width{
    CGFloat height = 0;
    NSArray *ratioArray = [aspectRatio componentsSeparatedByString:@":"];
    height = (width) * [[ratioArray lastObject] floatValue] / [[ratioArray firstObject] floatValue]-10;
    return height;
}


- (void)editCart:(id)sender{
    self.cardEdit(self.cartCellData);
}

- (void)deleteCart:(id)sender{
    if (self.cardDelete) {
        self.cardDelete(self.cartCellData);
    }
/*
    self.poverlayHandler = [[PopOverlayHandler alloc] init];
    self.poverlayHandler.overlayDelegate = self;
   
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];

    [parameters setObject:@"Remove Item" forKey:@"Alert Title"];
    [parameters setObject:@"NO" forKey:@"LeftButtonTitle"];
    [parameters setObject:@"YES" forKey:@"RightButtonTitle"];
    [parameters setObject:[NSNumber numberWithInt:CustomAlertDeleteCartItem] forKey:@"PopUpType"];
    [parameters setObject:@"Are you sure you want to remove this item?" forKey:@"Alert Message"];
    [parameters setObject:[NSNumber numberWithInteger:SelectSizeFromEditSize] forKey:@"TryAtHomAction"];
    

    [self.poverlayHandler presentOverlay:CustomAlertDeleteCartItem rootView:self enableAutodismissal:TRUE withUserInfo:parameters];
    */
}

- (void)performActionOnOverlay:(NSInteger)tag andPopType:(RPWOverlayType )type andInputDictionary:(NSMutableDictionary *)dictionary{

    if(tag==-1){ //If user click on cancel then this will execute
        [self.poverlayHandler dismissOverlay];
        return;
    }else if(tag==200){
        [self.poverlayHandler dismissOverlay];
        if(self.cardDelete){
            self.cardDelete(self.cartCellData);
        }
    }
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(buttonIndex ==1){
        if(self.cardDelete){
            self.cardDelete(self.cartCellData);
        }
    }
}

- (void)awakeFromNib {
    // Initialization code
}



- (void)prepareForReuse{
//    [cartImageTask cancel];
//    cartImageTask = nil;
    
    [self.cartImage setFrame:CGRectZero];
    [self.brandName setFrame:CGRectZero];
    [self.itemName setFrame:CGRectZero];
    [self.size setFrame:CGRectZero];
    [self.editButton setFrame:CGRectZero];
    [self.deleteButton setFrame:CGRectZero];
    [self.crossImage setFrame:CGRectZero];

    [self.cardMainView setFrame:CGRectZero];
    [self.swipeButtonView setFrame:CGRectZero];
    [self.deleteItemButton setFrame:CGRectZero];
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)handlePan:(UIPanGestureRecognizer *)recognizer{
    recognizer.cancelsTouchesInView = YES;
    if (self.theSwipeBlock) {
        self.theSwipeBlock(recognizer,self);
    }
}

-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    if ([gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]]) {
        UIPanGestureRecognizer *thePan = (UIPanGestureRecognizer *)gestureRecognizer;
        CGPoint translation = [thePan translationInView:self.contentView];
        if (fabs(translation.x)<fabs(translation.y)) {
            return TRUE;
        }
        return FALSE;
    }
    return FALSE;
}

@end
