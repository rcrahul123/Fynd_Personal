//
//  OBCollectionSelectionViewController.h
//  Explore
//
//  Created by Rahul Chaudhari on 12/08/15.
//  Copyright (c) 2015 Rahul. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OBCollectionSelectionViewController : UIViewController<GridViewDelegate,UIScrollViewDelegate>{
    UIView *bottomBar;
    UIButton *followCollectionLabel;
    UITapGestureRecognizer *tapLabel;
    BOOL shouldShowNext;
    
    NSAttributedString *followString;
    
    FyndActivityIndicator *followCollectionLoader;
    
    BOOL isObserverAdded;
}
@property (nonatomic,strong) NSArray *theFollowigBrandData;
@property (nonatomic,strong)UIScrollView *followCollectionScrollview;
@end
