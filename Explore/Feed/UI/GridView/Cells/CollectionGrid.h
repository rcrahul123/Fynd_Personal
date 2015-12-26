//
//  CollectionGrid.h
//  Explore
//
//  Created by Pranav on 30/06/15.
//  Copyright (c) 2015 Rahul. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CollectionTileModel.h"
#import "SSBaseRequestHandler.h"
#import <SDWebImage/UIImageView+WebCache.h>

@protocol CollectionGridDelegate;
typedef void (^CollectionCellLocationBlock)(UITouch *theCollectionTouch,BOOL isFollowing);
@interface CollectionGrid : UICollectionViewCell{
    UIView *collectionGridContainer;
    NSAttributedString *followText;
    NSTimer *followTimer;
    
    NSMutableAttributedString *storeString1;
    NSAttributedString *storesString2;
    CGRect storeRect;
    
    NSMutableAttributedString *followerString1;
    NSAttributedString *followerString2;
    CGRect followerRect;
    
    UIFont *boldFontForCount;
    UIFont *regularFontForStore;
    
    NSString *modifiedString;
    CGSize tempSize;
    NSString *lastUpdated;
    
//    NSURLSessionConfiguration *config2;
//    NSURLCache *cache2;
//    SSBaseRequestHandler *requestHandler;
    
    UICollectionViewFlowLayout *layout;
    
    UIView *discountContainerView;
    UILabel *discountLabel;
    UIImage *discountImage;
    UIImageView *discountImageView;
}

@property (nonatomic,strong) CollectionTileModel *collectionTileModel;
@property (nonatomic,assign) CGSize             collectionViewCellSize;
@property (nonatomic,assign) CGFloat            bannerWidth;
@property (nonatomic,unsafe_unretained) id<CollectionGridDelegate> collectionDelegate;
@property (nonatomic,strong) CollectionCellLocationBlock theCollectionLocationBlock;
- (void)configureCollectionGrid;
@end

@protocol CollectionGridDelegate <NSObject>
- (void)selectedCollectionProduct:(NSString *)productUrl;
-(void)collectionFollowingData:(CollectionTileModel *)theCollectionModel;
@end
