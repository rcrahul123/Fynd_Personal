//
//  FyndBlankPage.m
//  Explore
//
//  Created by Pranav on 04/09/15.
//  Copyright (c) 2015 Rahul. All rights reserved.
//

#import "FyndBlankPage.h"
#import "SSUtility.h"

@interface FyndBlankPage ()
- (void)setUpBlankPage:(ErrorBlankImage)type;
@end

@implementation FyndBlankPage
CGFloat actionButtonHeight = 50.0f;
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (id)initWithFrame:(CGRect)frame blankPageType:(ErrorBlankImage)pageType{
    
    if(self == [super initWithFrame:frame]){
        [self setUpBlankPage:pageType];
        
        self.layer.cornerRadius = 3.0f;
        [self setBackgroundColor:[UIColor whiteColor]];
    }
    return self;
}


- (void)setUpBlankPage:(ErrorBlankImage)type{
    NSString *actionText = nil;
    
    switch (type) {
        case ErrorNoOrders:
            actionText = @"LET'S GO FYNDING";
            [self generateErroPage:@"EmptyOrders" andActionText:actionText andType:ErrorNoOrders];
            break;
            
        case ErrorNoSearchResults:
            actionText = @"SEARCH AGAIN";
            [self generateErroPage:@"NoSearchResults" andActionText:actionText andType:ErrorNoSearchResults];
            break;
          
        case ErroNoCartItem:
            actionText = @"LET'S GO FYNDING";
            [self generateErroPage:@"EmptyBag" andActionText:actionText andType:ErroNoCartItem];
            break;
            
        case ErrorNoWishlist:
            actionText = @"LET'S GO FYNDING";
            [self generateErroPage:@"EmptyWishlist" andActionText:actionText andType:ErrorNoWishlist];
            break;
            
        case ErrorNoNotifications:
            actionText = @"GO BACK";
            [self generateErroPage:@"NoNotification" andActionText:actionText andType:ErrorNoNotifications];
            break;
            
        case ErrorNoBrands:
            actionText = @"GO TO BRANDS";
            [self generateErroPage:@"EmptyBrands" andActionText:actionText andType:ErrorNoBrands];
            break;

            
        case ErrorNoCollections:
            actionText = @"GO TO COLLECTIONS";
            [self generateErroPage:@"EmptyCollections" andActionText:actionText andType:ErrorNoCollections];
            break;

         case ErrorSystemDown:
            actionText = @"RETRY";
            [self generateErroPage:@"SystemDown" andActionText:actionText andType:ErrorSystemDown];
            break;
            
        case ErrorEmptyBrandsTab:
            actionText = @"LET'S GO FYNDING";
            [self generateErroPage:@"EmptyBrands" andActionText:actionText andType:ErrorEmptyBrandsTab];
            break;
            
        case ErrorEmptyCollectionsTab:
            actionText = @"LET'S GO FYNDING";
            [self generateErroPage:@"EmptyCollections" andActionText:actionText andType:ErrorEmptyCollectionsTab];
            break;
            
        case ErrorEmptyAddFromWishlist:
            actionText = @"GO TO BAG";
            [self generateErroPage:@"EmptyWishlist" andActionText:actionText andType:ErrorEmptyAddFromWishlist];
            break;

            
        default:
            break;
    }
}


- (void)generateErroPage:(NSString *)withImageName andActionText:(NSString *)text andType:(ErrorBlankImage)errorType{
    
    UIImage *image = [UIImage imageNamed:withImageName];
//    UIImageView *errorImage = [[UIImageView alloc] initWithFrame:CGRectMake(self.frame.size.width/2 - 50, self.frame.size.height/2 - 50, 100, 100)];
    UIImageView *errorImage = [[UIImageView alloc] initWithFrame:CGRectMake(self.frame.size.width/2 - (image.size.width/2)/2, self.frame.size.height/2 - (image.size.height/2)/2, image.size.width/2, image.size.height/2)];
    [errorImage setBackgroundColor:[UIColor clearColor]];
    [errorImage setImage:[UIImage imageNamed:withImageName]];
    [self addSubview:errorImage];
    
    NSString *errorDescriptionString = nil;
    if(errorType == ErrorNoOrders){
        errorDescriptionString = @"No Orders Yet!";
    }else  if(errorType == ErrorNoSearchResults){
        errorDescriptionString = @"No Search Results Found!";
    }
    else  if(errorType == ErroNoCartItem){
        errorDescriptionString = @"Bag is Empty!";
    }
    else if(errorType == ErrorNoWishlist){
        errorDescriptionString = @"Wishlist is Empty!";
    }else if (errorType == ErrorNoNotifications){
        errorDescriptionString = @"No Notifications Yet!";
    }else if (errorType == ErrorNoBrands){
        errorDescriptionString = @"No Brands Followed!";
    }else if (errorType == ErrorNoCollections){
        errorDescriptionString = @"No Collections Followed!";
    }else if (errorType == ErrorSystemDown){
        errorDescriptionString = @"System Down!";
    }else if (errorType == ErrorEmptyBrandsTab){
        errorDescriptionString = @"Coming Soon!";
    }else if (errorType == ErrorEmptyCollectionsTab){
        errorDescriptionString = @"Coming Soon!";
    }else if (errorType == ErrorEmptyAddFromWishlist){
        errorDescriptionString = @"Wishlist is Empty!";
    }
    
    CGSize size = [SSUtility getLabelDynamicSize:errorDescriptionString withFont:[UIFont fontWithName:kMontserrat_Regular size:15.0f] withSize:CGSizeMake(self.frame.size.width -20, MAXFLOAT)];
    UILabel *errorDescription = [SSUtility generateLabel:errorDescriptionString withRect:CGRectMake(self.frame.size.width/2 -size.width/2, errorImage.frame.origin.y + errorImage.frame.size.height + 10, size.width,size.height) withFont:[UIFont fontWithName:kMontserrat_Regular size:15.0f]];
    [errorDescription setText:errorDescriptionString];
    [self addSubview:errorDescription];
    
    UIButton *actionButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [actionButton setFrame:CGRectMake(10, self.frame.size.height - (actionButtonHeight+10), self.frame.size.width-20, actionButtonHeight)];
    [actionButton addTarget:self action:@selector(handleAction:) forControlEvents:UIControlEventTouchUpInside];
    [actionButton setBackgroundImage:[SSUtility imageWithColor:UIColorFromRGB(kTurquoiseColor)] forState:UIControlStateNormal];
    [actionButton setBackgroundImage:[SSUtility imageWithColor:UIColorFromRGB(kButtonTouchStateColor)] forState:UIControlStateHighlighted];
    actionButton.layer.cornerRadius = 3.0f;
    [actionButton setClipsToBounds:TRUE];
    actionButton.titleLabel.font = [UIFont fontWithName:kMontserrat_Bold size:14.0f];
    [actionButton setTitle:text forState:UIControlStateNormal];
    [self addSubview:actionButton];
    
//    CGFloat totalHeight = errorDescription.frame.origin.y + errorDescription.frame.size.height + 10 + actionButtonHeight+10;
//    if (totalHeight>self.frame.size.height) {
//        [self setFrame:CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, totalHeight)];
//    }

    
}

- (void)handleAction:(id)sender{
    if(self.blankPageBlock){
        self.blankPageBlock();
    }
}

@end
