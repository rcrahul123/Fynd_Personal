//
//  PickAtStorePopUp.h
//  Explore
//
//  Created by Pranav on 22/07/15.
//  Copyright (c) 2015 Rahul. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SSUtility.h"
#import "PopHeaderView.h"

typedef void (^PopUpAction)(TryAtHomeType type);
typedef void (^AddItemIntoCart)(NSMutableArray *itemSizes);
typedef void (^EditCartItemSize)(NSMutableArray *itemSizes);
typedef void (^CancelPopUp)();
@interface PickAtStorePopUp : UIView

@property (nonatomic,strong) NSMutableArray     *productSizeArray;
@property (nonatomic,assign) TryAtHomeType      tryHomePopUpType;
@property (nonatomic,copy) PopUpAction          popUpAction;
@property (nonatomic,copy) AddItemIntoCart      addToCartBlock;
@property (nonatomic,copy) EditCartItemSize     editCartItemBlock;
@property (nonatomic,copy) CancelPopUp          cancePopUpBlock;
@property (nonatomic,strong) NSDictionary       *tryAtHomeDataDict;


- (void)setUpTryAtHome;
- (void)configureForFirstTime;
- (void)configure;
@end
