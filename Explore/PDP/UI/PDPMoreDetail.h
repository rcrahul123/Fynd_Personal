//
//  PDPMoreDetail.h
//  ParallexPDPSample
//
//  Created by Pranav on 09/07/15.
//  Copyright (c) 2015 Pranav. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SSLine.h"
@protocol PDPMoreDetailDelegate;
@interface PDPMoreDetail : UIView

@property (nonatomic,strong) NSMutableArray *productMoreDescription;
@property (nonatomic,unsafe_unretained) id<PDPMoreDetailDelegate>moreDetailDelegate;
@property (nonatomic,strong) UIView *headerView;
- (void)generatePDPMoreDetail;
@end

@protocol PDPMoreDetailDelegate <NSObject>
//- (void)moreInfoTabChanged;
- (void)moreInfoTabChanged:(NSInteger)anIndex;
@end

