//
//  MyOrderModel.h
//  Explore
//
//  Created by Rahul Chaudhari on 04/09/15.
//  Copyright (c) 2015 Rahul. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ActionModel.h"

@interface ShipmentItem : NSObject

@property (nonatomic,assign) NSInteger  productId;
@property (nonatomic,assign) NSInteger  bagId;
@property (nonatomic, strong) NSString *productName;
@property (nonatomic, strong) NSString *productImageURL;
@property (nonatomic, strong) NSString *aspectRatio;
@property (nonatomic, strong) ActionModel *action;
@property (nonatomic, strong) NSString *deliveryStatus;
@property (nonatomic, strong) NSString *actionTime;
@property (nonatomic, strong) NSString *price;
@property (nonatomic, assign) BOOL canReturn;
@property (nonatomic, assign) BOOL canExchange;
@property (nonatomic, assign) BOOL isTryAtHome;
@property (nonatomic, strong) NSString *sizeString;
@property (nonatomic, strong) NSString *hexCode;

-(id)initWithDictionary:(NSDictionary *)dataDictionary;

@end

@interface MyOrderModel : NSObject

@property (nonatomic, strong) NSString *orderId;
@property (nonatomic, strong) NSString *orderDate;
@property (nonatomic, strong) NSMutableArray *shipmentArray;
@property (nonatomic, strong) NSString *userName;
@property (nonatomic, strong) NSString *deliveryAddress;
@property (nonatomic, strong) NSString *deliveryAddressType;
@property (nonatomic, strong) NSString *totalCost;
@property (nonatomic, strong) NSString *modeOfPayment;
@property (nonatomic, assign) BOOL canCancel;
@property (nonatomic, assign) BOOL isActiveOrder;
@property (nonatomic, strong) NSString *orderStatus;
@property (nonatomic, strong) NSString *hexCode;
@property (nonatomic, strong) NSString *deliveryTime;
@property (nonatomic, strong) NSString *deliveryDate;


-(id)initWithDictionary:(NSDictionary *)dataDictionary;
@end
