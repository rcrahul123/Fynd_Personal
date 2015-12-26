//
//  GridView.h
//  
//
//  Created by Rahul on 7/6/15.
//
//

#import <UIKit/UIKit.h>
#import "CustomFlow.h"

#import "BrandCollectionViewCell.h"
#import "ProductTileModel.h"
#import "ProductCell.h"

#import "TipTileModel.h"
#import "TipCollectionViewCell.h"

#import "BrandTileModel.h"

#import "CollectionTileModel.h"
#import "BrandsGrid.h"
#import "CollectionGrid.h"
#import "SSUtility.h"

#import "HTMLCollectionViewCell.h"
#import "GridStatusCollectionViewCell.h"
#import "WelcomeCardCell.h"
#import "OffersContainerCollectionViewCell.h"
#import "OffersTileModel.h"

#import "LargeOfferCell.h"
@protocol GridViewDelegate <NSObject>

@optional
- (void)gridViewDidScroll:(UIScrollView *)scrollView;
- (void)gridViewDidEndDecelerating:(UIScrollView *)scrollView;
- (void)gridViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate;
- (void)addWishProductToCart:(NSString *)productId andModel:(ProductTileModel *)model;


- (void)didScrollToEndOfLastPage;
- (void)showPDPScreen:(NSString *)productURL;
- (void)showBrowseByBrandPage:(NSString *)brandURL;
- (void)showBrowseByCollectionPage:(NSString *)collectionURL;
- (void)showBrandProductPDP:(NSString *)pdpUrl;
- (void)showCollectionProductPDP:(NSString *)pdpUrl;
-(void)brandFollowing:(BrandTileModel *)theBrandModel;
-(void)collectionFollowing:(CollectionTileModel *)theCollectionModel;
- (void)showBrowseByCategoryPage:(NSString *)categoryURL;

-(void)openCart;
-(void)openBrand;
-(void)openOrders;

@end
typedef enum {
    GridViewTypePlain,
    GridViewTypeWishList,
    GridViewTypeCartFromWishlist,
    GridViewTypeMyBrand,
    GridViewTypeMyCollection
}GridViewType;

@interface GridView : UIView<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout,BrandGridDelegate,CollectionGridDelegate,HTMLGridDelegate, OffersContainerCollectionViewCellDelegate, LargeOfferCellDelegate>{
    UICollectionView *myCollectionView;
    CGRect collectionViewFrame;
    CustomFlow *flow;
    CGSize productAspectRatioSize;
    BOOL isFetching;
    BOOL shouldHideLoaderSection;

}

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *parsedDataArray;
@property (nonatomic,unsafe_unretained) id<GridViewDelegate> delegate;
@property GridViewType theGridViewType;
@property (nonatomic, assign) BOOL isSearched;
@property (nonatomic, assign) BOOL isBrowsed;

@property (nonatomic, assign) BOOL shouldHideLoaderSection;

-(void)addCollectionView;
-(void)reloadCollectionView;
-(void)reloadCollectionView:(NSArray *)indexArray;
//-(void)deleteAtPoint:(CGPoint)pt;
-(void)deleteCellAt:(NSIndexPath *)indexPath withAnimation:(BOOL)animate;
@end
