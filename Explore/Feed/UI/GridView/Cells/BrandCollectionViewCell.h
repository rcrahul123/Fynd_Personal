//
//  BrandCollectionViewCell.h
//  FreshSample
//
//  Created by Rahul on 6/17/15.
//  Copyright (c) 2015 Rahul. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BrandCollectionViewCell : UICollectionViewCell<UICollectionViewDataSource, UICollectionViewDelegate>{
    UICollectionView *horizontalCollectionView;
    UICollectionViewFlowLayout *subFlow;
    UIView *headerView;
    
    UIView *containerView;
}

@end
