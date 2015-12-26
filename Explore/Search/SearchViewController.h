//
//  SearchViewController.h
//  Explore
//
//  Created by Amboj Goyal on 7/21/15.
//  Copyright (c) 2015 Rahul. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BrowseByCategoryView.h"
#import "AutoSuggestModel.h"
#import "PDPViewController.h"

typedef void (^PushAnotherView)(NSString *controllerType,NSString *theURL,NSString *valueString, NSString *parentCategory, NSString *gender, AutoSuggestModel *searchModel);

@interface SearchViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,UISearchBarDelegate,UIGestureRecognizerDelegate>{
    
    NSMutableArray *previousSearchArray;
    NSMutableArray *autoSuggestArray;
    NSURLSessionDataTask *searchDataTask;
    BOOL isSearching;
    UIView *tableHeaderView;
    
    NSTimer *timer;
    NSMutableDictionary *searchDictionary;
    
    SSBaseRequestHandler *baseHandler;
    NSMutableString *urlString;
    UIImage *magnifierImage;
    
    UIView *searchBarContainerView;
    UIButton *cancelButtton;
}
@property (nonatomic,strong)   UITextField * searchTextField;
@property (nonatomic,strong)UITableView *theSearchTableView;
@property (nonatomic,strong) NSString *searchString;
@property (nonatomic,strong) UISearchBar *theSearchBar;
@property (nonatomic,strong)PushAnotherView thePushBlock;
-(void)enableSearch:(id)sender;
@end
