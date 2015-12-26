//
//  FAQView.h
//  Explore
//
//  Created by Amboj Goyal on 8/14/15.
//  Copyright (c) 2015 Rahul. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FAQView : UIView<UITableViewDataSource, UITableViewDelegate>

-(id)initWithFrame:(CGRect)frame dataDictionary:(NSDictionary *)dataDict;
@property (nonatomic,strong) UITableView *theFAQTableView;
@property (nonatomic,strong)NSMutableArray *allSectionsFlagArray;
@end
