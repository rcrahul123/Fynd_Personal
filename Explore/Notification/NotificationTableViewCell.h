//
//  NotificationTableViewCell.h
//  Explore
//
//  Created by Rahul Chaudhari on 15/12/15.
//  Copyright © 2015 Rahul. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OffersTileModel.h"
#import "OffersView.h"

@interface NotificationTableViewCell : UITableViewCell

@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) OfferSubTile *model;
@property (nonatomic, strong) OffersView *offerView;

@end
