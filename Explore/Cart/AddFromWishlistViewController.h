//
//  AddFromWishlistViewController.h
//  Explore
//
//  Created by Rahul Chaudhari on 02/09/15.
//  Copyright (c) 2015 Rahul. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GridView.h"
#import "ProfileRequestHandler.h"
#import "PDPViewController.h"

typedef void (^ItemAddedIntoCart)(BOOL aBool);
@interface AddFromWishlistViewController : UIViewController<GridViewDelegate>{
    GridView *wishlistGridView;
    ProfileRequestHandler *profileRequestHandler;
    NSString * theGender;
    int pageNumber;
    UILabel *messageLabel;
    NSMutableDictionary *paramDic;
    
    FyndActivityIndicator *addFromWishlistLoader;
    
    ProductTileModel *selectedTileModel;
}

@property (nonatomic, assign) bool isFetching;
@property (nonatomic,assign) BOOL hasNext;
@property (nonatomic, strong) PDPViewController *pdpController;
@property (nonatomic,copy) ItemAddedIntoCart    itemAdded;

@end
