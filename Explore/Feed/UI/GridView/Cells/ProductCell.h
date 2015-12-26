//
//  ProductCell.h
//  FreshSample
//
//  Created by Rahul on 6/17/15.
//  Copyright (c) 2015 Rahul. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProductTileModel.h"

#import "SSBaseRequestHandler.h"
#import <SDWebImage/UIImageView+WebCache.h>
typedef void (^ProductCellLocationBlock)(UITouch *pointOfTouch, BOOL isLiked);
typedef void (^AddWishListProduct)(NSString *productId, ProductTileModel *productModel);

@interface ProductCell : UICollectionViewCell{
    
    UIView *container;
    UIImageView *imgView;
    
    UILabel *nameLabel;
    UIImageView *brandLogo;
    UILabel *priceLabel;
    UILabel *markedDownPriceLabel;
    UIButton *likeButton;
    UIButton *deleteButton;
    NSURLSessionDataTask *dataTask;
    NSURLSessionDataTask *logoTask;
    
    UIActivityIndicatorView *productCellActivityIndicator;
    
    NSTimer *likeTimer;
    
    
    NSURLSessionConfiguration *config;
    NSURLCache *cache;
    NSURLSession *session;
    NSURLSession *logoSession;
    NSURLSession *likeSession;
    
    UIImage *selectedLikeImage;
    UIImage *unselectedLikeImage;
    
    NSString *markedPriceString;
    NSMutableAttributedString *markedPriceAttributedString;
    
    NSString *effectivePriceString;
    
    UIFont *nameLabelFont;
    UIFont *priceLabelFont;
    CGRect priceLabelRect;
    
    UIFont *effectivePriceFont;
    CGSize effectivePriceRect;
    
    UIImage *productImage;
    UIImage *brandLogoImage;
    
    UIButton *addToCartButton;
    NSMutableAttributedString *addToCartString;
    UIFont *addToCartFont;
    
    UILabel *outOfStockLabel;
    NSMutableAttributedString *outOfStockString;
    UIFont *outOfStockFont;
    
    UIImage *placeHolderImage;
    
    CGSize imageSize;
    
    UILabel *badgeLabel;
    
    UIView *discountContainerView;
    UILabel *discountLabel;
    UIImage *discountImage;
    UIImageView *discountImageView;
}

@property (nonatomic) bool isImageDownloaded;

@property (nonatomic, strong) ProductTileModel *cellModel;
@property (nonatomic,strong) ProductCellLocationBlock theProductLocationBlock;
@property (nonatomic,copy) AddWishListProduct       addWishListProductBlock;
@property (nonatomic, assign) BOOL isSearched;
@property (nonatomic, assign) BOOL isBrowsed;

-(void)removeShadow;

@end
