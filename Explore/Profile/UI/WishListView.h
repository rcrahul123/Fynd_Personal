//
//  WishListView.h
//  Explore
//
//  Created by Amboj Goyal on 8/11/15.
//  Copyright (c) 2015 Rahul. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProfileRequestHandler.h"
#import "GridView.h"
#import "FyndBlankPage.h"
#import "CartRequestHandler.h"
#import "PDPModel.h"
#import "PopOverlayHandler.h"
typedef void (^ShowPDPScreen)(NSString *theURL);
typedef void (^WishListViewBlock)();

@protocol WishlistDelegate <NSObject>

-(void)showLoader;
-(void)dismissLoader;

@end

@interface WishListView : UIView<GridViewDelegate, PopOverlayHandlerDelegate>{
    int pageNumber;
//    bool isFetching;
//    BOOL hasNext;
    ProfileRequestHandler *profileRequestHandler;
    UILabel *messageLabel;
    NSString * theGender;
    
    BOOL isWishlistObserverAdded;
    ProductTileModel *selectedTileModel;

}
@property (nonatomic,strong) CartRequestHandler *cartHandler;
@property (nonatomic,strong) NSMutableArray     *productSizes;
@property (nonatomic,assign) NSString           *currentProductId;
@property (nonatomic,strong) PopOverlayHandler  *cartOverlayHandler;

@property (nonatomic,strong) GridView *wishListGridView;
@property (nonatomic,copy)ShowPDPScreen thePDPCallback;
@property (nonatomic,assign) bool isFetching;
@property (nonatomic,assign) BOOL hasNext;
@property(nonatomic,copy) WishListViewBlock wishListViewBlock;
@property (nonatomic,strong) FyndBlankPage *fyndBlankPage;
@property (nonatomic, strong) id<WishlistDelegate> delegate;
-(void)configureWishList;
- (void)reloadWishList;

@end
