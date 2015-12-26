//
//  FilterHeaderCellTableViewCell.h
//  Explore
//
//  Created by Rahul Chaudhari on 26/07/15.
//  Copyright (c) 2015 Rahul. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FilterModel.h"

@interface FilterHeaderTableViewCell : UITableViewCell{
    UIImageView *categoryImage;
    UILabel *categoryNameLabel;
    UIView *selectionMark;
    UIFont *labelFont;
    UIFont *labelFontBold;
}

@property (nonatomic, strong) FilterModel *filterModel;
@property (nonatomic, assign) BOOL isCurrentCell;


@end
