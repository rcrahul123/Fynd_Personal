//
//  ProductCell.h
//  BrandCollectionPOC
//
//  Created by Pranav on 23/06/15.
//  Copyright (c) 2015 Pranav. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "SSBaseRequestHandler.h"
#import <SDWebImage/UIImageView+WebCache.h>


@interface BrandProductCell : UICollectionViewCell{
//    NSURLSessionConfiguration *config;
//    NSURLCache *cache;
//    NSURLSession *session;
//    NSURLSessionDataTask *dataTask;
//    SSBaseRequestHandler  *handler;
    
    UIImage *placeholderImage;
    BOOL isImageDownloaded;
    
    UIImage *badgeImage;
    UIImageView *badgeImageView;
}
@property (nonatomic,strong) NSString *productImageUrl;
@property (nonatomic,strong) UIImage  *productImage;

@property (nonatomic,assign) BOOL imageDownloaded;
@property (nonatomic,assign) CGSize productImageViewSize;
@property (nonatomic, strong) NSString *urlString;
@property (nonatomic, strong) NSString *productColor;
@property (nonatomic, assign) BOOL showDiscountBadge;
//- (void)fetchProductImage:(NSString *)withUrl;
@end
