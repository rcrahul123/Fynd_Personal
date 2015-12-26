//
//  OBBrandSelectionViewController.h
//  Explore
//
//  Created by Rahul Chaudhari on 12/08/15.
//  Copyright (c) 2015 Rahul. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GridView.h"
#import "OnBoardingRequestHandler.h"

@interface OBBrandSelectionViewController : UIViewController<GridViewDelegate,UIScrollViewDelegate>{
    UIView *bottomBar;
    UIButton *followBrandLabel;
    UITapGestureRecognizer *tapLabel;
    BOOL shouldShowNext;
    
    UIImageView *headerImageView;
    UILabel *theFollowLabel;
    NSMutableArray *brandsArray;
    NSAttributedString *followString;
    
    FyndActivityIndicator *followBrandLoader;
    
    bool isObserverAdded;
    
}
@property (nonatomic,strong)UIScrollView *mainScrollview;
@end
