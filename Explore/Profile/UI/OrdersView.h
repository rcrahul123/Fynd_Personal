//
//  OrdersView.h
//  Explore
//
//  Created by Amboj Goyal on 8/11/15.
//  Copyright (c) 2015 Rahul. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyOrderModel.h"
#import "OrderHeaderView.h"
#import "MyOrderProductCell.h"
#import "MyOrderAddressCell.h"
#import "MyOrderCostCell.h"
#import "ProfileRequestHandler.h"

typedef void (^OrderViewExchangeBlock)(NSString *orderId, ShipmentItem *theExchangeShippingItem , NSDictionary *theDataDictionary);
typedef void (^OrderViewReturnBlock)(NSString *orderId,ShipmentItem *theExchangeShippingItem , NSDictionary *theDataDictionary, NSString *cost);

typedef void (^OrderViewCancelBlock)(NSString *orderId, NSString *cost);
typedef void (^OrderViewCallusBlock)();


@protocol OrderViewDelegate <NSObject>

-(void)productTileTapped:(NSString *)actionURL;
- (void)handleOrderlBlankPageAction;
-(void)showLoader;
-(void)dismissLoader;
@end

@interface OrdersView : UIView<UITableViewDelegate, UITableViewDataSource, MyOrderDelegate, MyOrderProductCellDelegate,MyOrderAddressCellDelegate>{
    UILabel *messageLabel;
    UITableView *activeOrdersTable;
    UITableView *pastOrdersTable;
    UILabel *pastOrdersHeader;
    NSMutableArray *activeOrdersArray;
    NSMutableArray *pastOrdersArray;
    
    NSDictionary *dataDictionary;
    ProfileRequestHandler *requestHandler;
    
    BOOL isPastOrderHeaderObserverAdded;
    BOOL isPastOrderTableObserverAdded;
    BOOL isActiveOrderTableObserveAdded;
}
- (void)configureOrdersView;
@property (nonatomic,strong) OrderViewExchangeBlock theExchangeBlock;
@property (nonatomic,strong) OrderViewReturnBlock theReturnBlock;
@property (nonatomic,strong) OrderViewCancelBlock theCancelBlock;
@property (nonatomic,strong) OrderViewCallusBlock theCallBlock;
@property (nonatomic,strong)NSMutableArray *allSectionsFlagArray;
@property (nonatomic, strong) id<OrderViewDelegate> orderViewDelegate;

-(void)getData;

-(void)releaseResources;

@end
