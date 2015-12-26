//
//  BrowseByCateogiryView.h
//  Explore
//
//  Created by Amboj Goyal on 8/1/15.
//  Copyright (c) 2015 Rahul. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomViewForCategory.h"
#import "SSLine.h"
typedef void (^TapOnCategory)(NSString *theURL,NSString *theCategoryName, NSString *parentCategoryName, NSString *gender);
@interface BrowseByCategoryView : UIView<UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate,UIScrollViewDelegate>{
    FyndActivityIndicator *searchLoader;
}
@property (nonatomic,copy)TapOnCategory theTapOnCategory;
-(id)initWithFrame:(CGRect)frame dataDictionary:(NSDictionary *)dataDict;
@end
