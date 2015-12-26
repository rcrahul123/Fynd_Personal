//
//  FilterViewController.h
//  Explore
//
//  Created by Rahul Chaudhari on 26/09/15.
//  Copyright © 2015 Rahul. All rights reserved.
//

#import <UIKit/UIKit.h>


#import "FilterCheckboxTableViewCell.h"
#import "FilterModel.h"
#import "FilterHeaderTableViewCell.h"

@protocol FilterViewDelegates <NSObject>

-(void)filterDismissed;
-(void)resetFilters;
-(void)refreshFiltersWith:(NSArray *)appliedFilters;

@end

@interface FilterViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>{
    
    UIView *headerView;
    UITableView *headersTableView;
    UITableView *valuesTableView;
    NSArray *filterArray;
    NSInteger selectedIndex;
    NSArray *keyArray;
    NSArray *subArray;
    NSMutableArray *parsedFilterData;
    
    NSMutableArray *parsedOriginalData;
    
    UIButton *resetButtton;
    UIButton *applyButton;
    
    NSDictionary *originalFilterDictionary;
    NSMutableArray *appliedFiltersArray;
    UIView *tableSeparator;
    
    UIView *buttonsContainer;
    
    NSInteger totalAppliedFilters;
    
    UIView *tableContainer;
    
//    UIActivityIndicatorView *indicators;
    
    NSString *selectedFilterType;
    NSIndexPath *selectedIndexPath;
    UIButton *cancelButton;
    
    FyndActivityIndicator *filterLoader;
    
    
}

@property (nonatomic) id<FilterViewDelegates> filterDelegate;

-(id)initWithDataArray:(NSArray *)dataArray;
-(void)updateFilterViewWithNewData:(NSArray *)newDataArray;


@end
