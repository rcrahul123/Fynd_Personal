//
//  NotificationViewController.h
//  Explore
//
//  Created by Rahul Chaudhari on 05/10/15.
//  Copyright © 2015 Rahul. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FyndBlankPage.h"
#import "HomeRequestHandler.h"
#import "FyndActivityIndicator.h"
#import "OffersTileModel.h"
#import "NotificationTableViewCell.h"

#import "PDPViewController.h"
#import "BrowseByBrandViewController.h"
#import "BrowseByCollectionViewController.h"
#import "BrowseByCategoryViewController.h"
#import "PaginationData.h"
#import "SCGIFImageView.h"


@interface LoaderTableViewCell : UITableViewCell{
    NSString *filePath;
    NSData *imageData;
    
    SCGIFImageView *gifContainer;
}

@property (nonatomic, strong)SCGIFImageView *gifContainer;

@end



@interface NotificationViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>{
    FyndActivityIndicator *notificationLoader;
    
    UITableView *notificationsTable;
    int pageNumber;
    BOOL isFetching;
    PaginationData *pageData;
    
    UIView *loaderView;
    
   
}


@property (nonatomic,strong) FyndBlankPage *blankPage;
@property (nonatomic, strong) HomeRequestHandler *requestHandler;
@property (nonatomic, strong) NSMutableArray *notificationsArray;

@property (nonatomic, strong) PDPViewController *pdpController;
@property (nonatomic, strong) BrowseByBrandViewController *browseByBrandController;
@property (nonatomic, strong) BrowseByCollectionViewController *browseByCollectionController;
@property (nonatomic, strong) BrowseByCategoryViewController *browseByCategoryController;

@end
