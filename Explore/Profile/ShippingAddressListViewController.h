//
//  ShippingAddressListViewController.h
//  Explore
//
//  Created by Amboj Goyal on 9/11/15.
//  Copyright (c) 2015 Rahul. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CartRequestHandler.h"
#import "ShippingAddressDetailViewController.h"

#import "CartData.h"
#import "FyndErrorInfoView.h"

typedef void (^EditModeBlock)(id modeToOpen);
//typedef void (^UpdateModelBlock)(id modeToOpen, BOOL isEditing);
typedef void (^AddAddressBlock)(id addToAdd);

@protocol ShippingAddressListViewDelegate<NSObject>
- (void)selectedAddressAndTimeSlot:(NSDictionary *)dataDictionary;

-(void)newAddressSelected:(CartData *)data;
@end


@interface ShippingAddressListViewController : UIViewController<UITableViewDataSource,UITableViewDelegate, ShippingAddressDetailViewDelegate>{
    
    CartRequestHandler *theCartRequestHandler;
//    ShippingAddressDetailViewController *theAddressDetailPage;
    FyndActivityIndicator *shippingAddressLoader;
    
    
}
@property (nonatomic,strong)     NSMutableArray *shippingDetailsArray;
@property (nonatomic,copy) EditModeBlock theEditBlock;
@property (nonatomic,strong)    UITableView *theShippingTableView;
@property (nonatomic,assign) ShippingAddressType theShippingEnum;
@property (nonatomic,copy) AddAddressBlock theAddressBlock;
@property (nonatomic,strong) ShippingAddressDetailViewController *theAddressDetailPage;

@property (nonatomic,unsafe_unretained) id<ShippingAddressListViewDelegate>delegate;
@property (nonatomic, strong) FyndErrorInfoView *errorView;

-(void)configureShippingView;

@end



