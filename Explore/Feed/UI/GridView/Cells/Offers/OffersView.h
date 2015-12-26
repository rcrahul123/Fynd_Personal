//
//  OffersView.h
//  Explore
//
//  Created by Rahul Chaudhari on 15/12/15.
//  Copyright © 2015 Rahul. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OffersTileModel.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import <QuartzCore/QuartzCore.h>


@interface OffersView : UIView

@property (nonatomic, strong) OfferSubTile *subTileModel;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIView *containerView;

@end
