//
//  NearestStorePopUp.h
//  Explore
//
//  Created by Pranav on 14/07/15.
//  Copyright (c) 2015 Rahul. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SSLine.h"
typedef void (^DidTapCancel)();
typedef void (^CrossPopUp)();
@interface NearestStorePopUp : UIView <UITableViewDataSource,UITableViewDelegate,UIPickerViewDelegate,UIPickerViewDataSource>
@property (nonatomic,strong) UITableView *storesTable;
@property (nonatomic,strong) NSMutableArray *storedData;
@property (nonatomic,strong) NSString       *brandName;
@property (nonatomic,strong) NSString       *brandLogoImageUrl;
@property (nonatomic,assign) BOOL            isViewAllStores;
@property (nonatomic,copy) DidTapCancel tapOnCancel;
@property (nonatomic,strong) UIPickerView *myPicker;
@property (nonatomic,copy) CrossPopUp          crossPopUpBlock;
- (void)generateStores;
@end
