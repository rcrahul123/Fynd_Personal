//
//  SizeBox.h
//  Explore
//
//  Created by Pranav on 30/09/15.
//  Copyright © 2015 Rahul. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PDPModel.h"

@interface SizeBox : UIView
typedef void (^UpdateDependentSizes)(ProductSize *currentSize,SizeBox *sizeBox);

@property (nonatomic,strong) NSMutableArray *sizeBoxData;
@property (nonatomic,strong) NSString        *title;
@property (nonatomic,assign) NSInteger        sizeBoxTag;
@property (nonatomic,copy) UpdateDependentSizes dependentSizeBock;
@property(nonatomic,assign) BOOL              isFyndAFitPopUp;
- (void)setUpSizeBox;
- (void)updateDependentSizes:(NSArray *)array;
- (void)updateSizeBoxDataArray:(NSArray *)array;
- (BOOL)validateSizeSelction;
@end
