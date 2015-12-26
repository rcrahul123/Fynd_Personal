//
//  CartItem.m
//  Explore
//
//  Created by Pranav on 01/09/15.
//  Copyright (c) 2015 Rahul. All rights reserved.
//

#import "CartItem.h"

@implementation CartItem

- (CartItem *)initWithCartItemDictionary:(NSDictionary *)itemDict{
    
     self = [super init];
    if(self){
     
        self.productId = [[itemDict objectForKey:@"product_id"] integerValue];
        self.itemBrandName = [itemDict objectForKey:@"brand"];
        self.itemName = [itemDict objectForKey:@"name"];
        self.itemSize = [itemDict objectForKey:@"size"];
        self.itemCost = [itemDict objectForKey:@"price"];
        self.itemQuantity = [[itemDict objectForKey:@"item_quantity"] integerValue];
        
        NSDictionary *imageData = [itemDict objectForKey:@"product_image"];
        if([imageData isKindOfClass:[NSDictionary class]] && imageData!=nil){
            self.productImageUrl = [imageData objectForKey:@"url"];
            self.productImageAspectRatio = [imageData objectForKey:@"aspect_ratio"];
        }
        
        self.action = [[ActionModel alloc] initWithDictionary:itemDict[@"action"]];
        
        self.tryAtHomeSelected = [[itemDict objectForKey:@"try_at_home"] boolValue];
//        self.outOfStock = [[itemDict objectForKey:@"is_out_of_stock"] boolValue];

        self.highlighted = [[itemDict objectForKey:@"is_highlighted"] boolValue];
        self.message = itemDict[@"message"];
//        self.hasPriceChanged = [itemDict[@"has_price_changed"] boolValue];
        
//           self.changedPriceValue = itemDict[@"has_price_changed"];
    }
    return self;
}
@end
