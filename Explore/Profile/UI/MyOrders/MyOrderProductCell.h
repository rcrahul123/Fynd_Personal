//
//  MyOrderProductCell.h
//  Explore
//
//  Created by Rahul Chaudhari on 07/09/15.
//  Copyright (c) 2015 Rahul. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyOrderModel.h"
#import "SSBaseRequestHandler.h"
#import <SDWebImage/UIImageView+WebCache.h>

@protocol MyOrderProductCellDelegate <NSObject>

@optional
-(void)returnItem:(ShipmentItem *)item;
-(void)exchangeItem:(ShipmentItem *)item;

@end

@interface MyOrderProductCell : UITableViewCell{
    UIView *separatorView;
    UIImageView *productImageView;
    UIImage *productImage;
    UILabel *productNameLabel;
    UILabel *priceSizeLabel;
    UILabel *statusLabel;
    UILabel *timeStampLabel;
    UIButton *returnItemButton;
    UIButton *exchangeItemButton;
    UILabel *tryAtHomeLabel;
    NSMutableAttributedString *priceSizeString;
    UIImage *placeHolderImage;
}

@property (nonatomic, strong) ShipmentItem *orderItem;
@property (nonatomic, strong) id<MyOrderProductCellDelegate> delegate;
@property (nonatomic, assign) BOOL isImageDownloaded;
@end
