//
//  CartItem.h
//  Explore
//
//  Created by Pranav on 01/09/15.
//  Copyright (c) 2015 Rahul. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CartItem : NSObject

@property (nonatomic,assign) NSInteger   productId;
@property (nonatomic,copy)   NSString    *itemBrandName;
@property (nonatomic,copy)   NSString    *itemName;
@property (nonatomic,strong)   NSString  *itemCost;
@property (nonatomic,strong)   NSString    *itemSize;
@property (nonatomic,assign) NSInteger   itemQuantity;
@property (nonatomic,assign) BOOL        tryAtHomeSelected;
@property (nonatomic,assign) BOOL        outOfStock;
@property (nonatomic,assign) BOOL        highlighted;
@property (nonatomic,strong) ActionModel    *action;
@property (nonatomic,strong) NSString       *productImageUrl;
@property (nonatomic,strong) NSString       *productImageAspectRatio;
@property (nonatomic,assign) NSInteger      cartItemIndex;
@property (nonatomic,copy) NSString         *convenienceFee;
@property (nonatomic,assign) BOOL      hasPriceChanged;
@property (nonatomic,copy) NSString         *message;
- (CartItem *)initWithCartItemDictionary:(NSDictionary *)itemDict;
@end
