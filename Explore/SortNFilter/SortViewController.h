//
//  SortViewController.h
//  Explore
//
//  Created by Rahul Chaudhari on 26/09/15.
//  Copyright © 2015 Rahul. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SortDelegate <NSObject>

-(void)sortDismissed;
-(void)sortSelected:(NSString *)string;

@end

@interface SortViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>{
    UITableView *sortTableView;
    NSArray *sortByArray;
    NSInteger listCount;
    UIView *headerView;
    UIButton *cancelButton;

}

@property (nonatomic, strong) id<SortDelegate> delegate;
-(id)initSortByArray:(NSArray *)array;
-(void)reloadSortData:(NSArray *)newArray;;


@end
