//
//  PDPStoresCell.h
//  Explore
//
//  Created by Pranav on 15/07/15.
//  Copyright (c) 2015 Rahul. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PDPModel.h"

@interface PDPStoresCell : UITableViewCell

- (void)configureCell;
@property (nonatomic,strong) Store *cellStoreData;
@property (nonatomic,assign) NSInteger  storeIndex;;
@end
