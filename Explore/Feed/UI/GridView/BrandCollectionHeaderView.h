//
//  BrandCollectionHeaderView.h
//  BrandCollectionPOC
//
//  Created by Pranav on 23/06/15.
//  Copyright (c) 2015 Pranav. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BrandTileModel.h"
#import "CollectionTileModel.h"

@interface BrandCollectionHeaderView : UIView{
//    NSURLSessionConfiguration *config;
//    NSURLCache *cache;
//    BOOL            bannerImageDownloded;
    UIImage *placeHolderImage;
}

@property (nonatomic,assign) BOOL                   isBrandTile;
@property (nonatomic,strong) NSString               *bannerImageUrl;
@property (nonatomic,strong) NSString               *bannerLogoUrl;
@property (nonatomic,strong) NSString               *logoAspectRatio;
@property (nonatomic,strong) UIImageView    *headerImageView;
@property (nonatomic,strong) NSURLSessionDataTask *headerDataTask;
@property (nonatomic,assign) BOOL   bannerImageDownloded;
@property (nonatomic,strong) NSString *productColor;

- (void)configureHeader;
//- (void)resetObjects;
@end
