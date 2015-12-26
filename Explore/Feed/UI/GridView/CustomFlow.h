//
//  CustomFlow.h
//  FreshSample
//
//  Created by Rahul on 6/17/15.
//  Copyright (c) 2015 Rahul. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomFlow : UICollectionViewFlowLayout{
    CGFloat collectionViewContentHeight;
    CGFloat deviceWidht;
    CGFloat deviceHeight;
    NSMutableArray* attributesArray;
}

@property (nonatomic, strong) NSArray *dataArray;
@property (nonatomic) NSInteger numberOfColumns;
@property (nonatomic, assign) BOOL isLoaderHidden;

@end
