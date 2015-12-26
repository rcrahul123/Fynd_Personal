//
//  TipCollectionViewCell.h
//  TabBasedAppSample
//
//  Created by Rahul on 6/25/15.
//  Copyright (c) 2015 Rahul. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TipTileModel.h"
#import "SSBaseRequestHandler.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface TipCollectionViewCell : UICollectionViewCell<SDWebImageManagerDelegate>{
    UIView *containerView;
    UIImageView *backgroundImage;
    UILabel *tipLabel;
    CGSize labelMaxSize;
    CGRect labelFrame;

    UIFont *labelFont;
    
    UIImage *bgImage;
    
    UIImage *placeholderImage;
    BOOL isImageDownloaded;
    
    CGSize imageSize;
}

@property (nonatomic, strong) TipTileModel *model;

@end
