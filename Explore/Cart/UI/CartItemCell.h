//
//  CartItemCell.h
//  Explore
//
//  Created by Pranav on 01/09/15.
//  Copyright (c) 2015 Rahul. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CartItem.h"

typedef void (^CartEdit)(CartItem *editCartItem);
typedef void (^CartDelete)(CartItem *deletedItem);
typedef void (^ShowCartItemPDP)(NSString *actionUrl);
typedef void (^SwipeOnCell)(UIPanGestureRecognizer *thePan,id theCell);

@interface CartItemCell : UITableViewCell<UIGestureRecognizerDelegate>{
//    NSURLSessionDataTask    *cartImageTask;
//    SSBaseRequestHandler    *requestHandler;
    UIImage                 *cartImage;
}
//- (id)initWithData:(CartItem *)cartData;
@property (nonatomic,strong) CartItem       *cartCellData;
@property (nonatomic,copy) CartEdit         cardEdit;
@property (nonatomic,copy) CartDelete       cardDelete;
@property (nonatomic,copy) ShowCartItemPDP  cartItemPDP;
@property (nonatomic,copy) SwipeOnCell  theSwipeBlock;
@property (nonatomic,assign)BOOL        isCellOpen;
@property (nonatomic,strong) UIView         *cardMainView;
- (void)configureItemLayout;

@end
