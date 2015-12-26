//
//  OffersContainerCollectionViewCell.h
//  Explore
//
//  Created by Rahul Chaudhari on 15/12/15.
//  Copyright © 2015 Rahul. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OffersView.h"

@interface FlowLayout : UICollectionViewFlowLayout

@property (nonatomic, assign) NSInteger cellCount;
@property (nonatomic) UIEdgeInsets sectionInset;
@property (nonatomic) CGSize itemSize;
@property (nonatomic) CGFloat minimumLineSpacing;
@property (nonatomic) CGFloat minimumInteritemSpacing;
@property (nonatomic, assign) CGFloat totalWidth;
@property (nonatomic, assign) CGFloat totalHeight;

-(id)initWithSize:(CGSize)size;
- (void)setup;

@end


@protocol OffersContainerCollectionViewCellDelegate <NSObject>

@optional
-(void)offerTapped:(OfferSubTile *)offerData;

@end


@interface OffersContainerCollectionViewCell : UICollectionViewCell<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>{
    UICollectionView *offersCollectionView;
//    UICollectionViewFlowLayout *flow;
    FlowLayout *flow;

}

@property (nonatomic, strong) OffersTileModel *offersModel;
@property (nonatomic, strong) id<OffersContainerCollectionViewCellDelegate> offerDelegate;

@end
