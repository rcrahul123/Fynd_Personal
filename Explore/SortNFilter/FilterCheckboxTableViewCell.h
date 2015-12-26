//
//  FilterCheckboxTableViewCell.h
//  
//
//  Created by Rahul on 7/16/15.
//
//

#import <UIKit/UIKit.h>
#import "SSUtility.h"
#import "FilterModel.h"

@interface FilterCheckboxTableViewCell : UITableViewCell{
    UIImageView *checkButton;
    UILabel *valueLabel;
    UIImageView *colorView;
    CGSize valueLabelSize;
    UIView *separatorView;
    UIFont *labelFont;
    UIFont *labelFontLight;
}

@property (nonatomic, strong) FilterOptionModel *model;
@property (nonatomic, assign) BOOL shouldShowSeparator;

//@property (nonatomic, assign) BOOL isSelected;
//@property (nonatomic, strong) NSString *value;
//@property (nonatomic, strong) NSString *colorCode;

@end
