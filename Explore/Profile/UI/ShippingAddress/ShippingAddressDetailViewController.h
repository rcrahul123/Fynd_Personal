//
//  ShippingAddressDetailViewController.h
//  Explore
//
//  Created by Amboj Goyal on 8/12/15.
//  Copyright (c) 2015 Rahul. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShippingAddressModel.h"
#import "LocationSearchViewController.h"
#import "CartData.h"
#import "FyndErrorInfoView.h"

@protocol ShippingAddressDetailViewDelegate <NSObject>

-(void)newAddressAdded:(CartData *)data;

@end

typedef void (^SaveChangesBlock)(id theModel, BOOL isEditing);
typedef void (^DeleteBlock)(id theModel);

//@protocol ShippingAddressListViewDelegate<NSObject>
//- (void)selectedAddressAndTimeSlot:(NSDictionary *)dataDictionary;
//@end

@interface ShippingAddressDetailViewController : UIViewController<LocationSearchDelegate>{
    FyndActivityIndicator *editAddressLoader;
    BOOL keyboardIsShown;
}

@property (nonatomic,copy) SaveChangesBlock theSaveBlock;
@property (nonatomic,copy) DeleteBlock theDeleteBlock;
@property (nonatomic,assign) BOOL isComingFromCart;
@property (nonatomic, strong) id<ShippingAddressDetailViewDelegate> delegate;
@property (nonatomic, strong) FyndErrorInfoView *errorView;

//@property (nonatomic,unsafe_unretained) id<ShippingAddressListViewDelegate>delegate;

-(void)configureDetailScreenWithData:(ShippingAddressModel *)theDataArray;

@end
