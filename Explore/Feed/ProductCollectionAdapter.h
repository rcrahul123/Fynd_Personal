//
//  ProductCollectionAdapter.h
//  BrandCollectionPOC
//
//  Created by Pranav on 23/06/15.
//  Copyright (c) 2015 Pranav. All rights reserved.
//


#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "SubProductModel.h"

@protocol ProductCollectionAdapterDelegate;

@interface ProductCollectionAdapter : NSObject <UICollectionViewDataSource,UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic,strong) NSMutableArray *totalProducts;
@property (nonatomic,assign) CGSize          productCellSize;
@property (nonatomic,unsafe_unretained) id<ProductCollectionAdapterDelegate> delegate;
@end

@protocol ProductCollectionAdapterDelegate<NSObject>
- (void)selectedProductTile:(SubProductModel *)subProduct;
@end