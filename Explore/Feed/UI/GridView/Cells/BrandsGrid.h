//
//  BrandsGrid.h
//  BrandCollectionPOC
//
//  Created by Pranav on 25/06/15.
//  Copyright (c) 2015 Pranav. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BrandTileModel.h"
#import "SSBaseRequestHandler.h"
#import <SDWebImage/UIImageView+WebCache.h>

typedef void (^BrandCellLocationBlock)(UITouch *theTileModel,BOOL isFollowing);
@protocol BrandGridDelegate;

@interface BrandsGrid : UICollectionViewCell{
    UIView *containerView;
    NSTimer *followTimer;
    NSAttributedString *followText;
    
    NSMutableAttributedString *storeString1;
    NSAttributedString *storesString2;
    CGRect storeRect;

    NSMutableAttributedString *followerString1;
    NSAttributedString *followerString2;
    CGRect followerRect;
    
    UIFont *boldFontForCount;
    UIFont *regularFontForStore;
    
    CGSize tempSize1;
    NSString *modifiedString1;
    NSString *nearestStore;
    UICollectionViewFlowLayout *layout;
    
//    NSURLSessionConfiguration *config1;
//    NSURLCache *cache1;
//    SSBaseRequestHandler *requestHandler;
    
    UIView *discountContainerView;
    UILabel *discountLabel;
    UIImage *discountImage;
    UIImageView *discountImageView;
    
}
@property (nonatomic,strong) BrandTileModel               *currentBrandData;
@property (nonatomic,assign) CGSize                       brandCollectionViewSize;
@property (nonatomic,assign) CGFloat                      brandBannerWidth;
@property (nonatomic,unsafe_unretained) id<BrandGridDelegate> brandGridDelegate;
@property (nonatomic,strong) BrandCellLocationBlock theBrandLocationBlock;
- (void)configureBrandGrid;

@end

@protocol BrandGridDelegate <NSObject>
- (void)selectedBrandProduct:(NSString *)productUrl;
-(void)brandFollowingData:(BrandTileModel *)theBrandModel;
@end
