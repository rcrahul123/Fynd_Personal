//
//  LargeOfferCell.h
//  Explore
//
//  Created by Rahul Chaudhari on 15/12/15.
//  Copyright © 2015 Rahul. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OffersTileModel.h"
#import <SDWebImage/UIImageView+WebCache.h>

@protocol LargeOfferCellDelegate <NSObject>

@optional
-(void)largeOfferCellTapped:(OfferSubTile *)subTile;

@end


@interface LargeOfferCell : UIView<UIScrollViewDelegate>{
    UIScrollView *containerScrollView;
    UIPageControl *pageControl;
    NSInteger numberOfItems;
    
    UIColor *bgColor;
}

@property (nonatomic, strong) OffersTileModel *model;
@property (nonatomic, strong) id<LargeOfferCellDelegate> delegate;

-(id)initWithFrame:(CGRect)frame andModel:(OffersTileModel *)model;

@end
