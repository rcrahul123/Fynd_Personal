//
//  CategoryViewController.m
//  Explore
//
//  Created by Amboj Goyal on 8/3/15.
//  Copyright (c) 2015 Rahul. All rights reserved.
//

#import "BrowseByCategoryViewController.h"
#import "SearchViewController.h"
#import "LocationSearchViewController.h"
#import "FyndBlankPage.h"
#import "SSUtility.h"

@interface BrowseByCategoryViewController (){
    CGSize productAspectRatioSize;
    SearchViewController *theSearchViewController;

    
    UIImageView *sortIcon;
    UILabel *sortLabel;
    UIView *sortButtonContainer;
    UITapGestureRecognizer *tapToSortGesture;
    
    UIImageView *filterIcon;
    UILabel *filterLabel;
    UIView *filterButtonContainer;
    UITapGestureRecognizer *tapToFilterGesture;
    
    
    UIView *filterNSortButtonContainer;
    NSArray *defaultFilters;
    NSDictionary *categoryDataDictionary;
    BOOL hasNext;
    UILabel *messageLabel;
    UIView *titleViewResults;
}
@property (nonatomic,strong)UIActivityIndicatorView *theLoader;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic,strong)UILabel *countLabel;
@end

@implementation BrowseByCategoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    CGRect theFrame = self.view.frame;
    theFrame.size.height = [[UIScreen mainScreen] bounds].size.height;
    self.view.frame = theFrame;
    [self.view setBackgroundColor:UIColorFromRGB(kBackgroundGreyColor)];
    
    
    CGSize categorySize = [SSUtility getSingleLineLabelDynamicSize:self.theCategory withFont:[UIFont fontWithName:kMontserrat_Regular size:14.0f] withSize:CGSizeMake(200, 30)];
    categorySize = CGSizeMake(categorySize.width + 5, categorySize.height+ 2);
    
//    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, categorySize.width,categorySize.height)];
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, categorySize.width,categorySize.height)];
    _titleLabel.font = [UIFont fontWithName:kMontserrat_Regular size:14.0f];
    [_titleLabel setLineBreakMode:NSLineBreakByTruncatingTail];
    _titleLabel.textColor =UIColorFromRGB(kDarkPurpleColor);
    [_titleLabel setBackgroundColor:[UIColor clearColor]];
    [_titleLabel setTextAlignment:NSTextAlignmentCenter];
    _titleLabel.text = [self.theCategory capitalizedString];
//    [_titleLabel setAdjustsFontSizeToFitWidth:TRUE];

    NSString *theText = @"12220 items";
   CGSize countLabelSize = [SSUtility getLabelDynamicSize:theText withFont:[UIFont fontWithName:kMontserrat_Regular size:12.0f] withSize:CGSizeMake(MAXFLOAT, 44)];
    _countLabel = [[UILabel alloc] initWithFrame:CGRectMake(_titleLabel.frame.origin.x+ categorySize.width/2- countLabelSize.width/2, _titleLabel.frame.size.height+3, countLabelSize.width,15)];
    _countLabel.font = [UIFont fontWithName:kMontserrat_Light size:12.0f];
    _countLabel.textColor =UIColorFromRGB(kGenderSelectorTintColor);
    [_countLabel setTextAlignment:NSTextAlignmentCenter];
    [_countLabel setTag:213];

    [_countLabel setHidden:TRUE];

    titleViewResults = [[UIView alloc] initWithFrame:CGRectMake(0, 0, categorySize.width+20,categorySize.height+15)];
    [titleViewResults addSubview:_titleLabel];
    [titleViewResults addSubview:_countLabel];
    [titleViewResults setBackgroundColor:[UIColor clearColor]];
    self.navigationItem.titleView = titleViewResults;

    browseByCategotyLoader = [[FyndActivityIndicator alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    [browseByCategotyLoader setCenter:CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height/2)];
    [self.view addSubview:browseByCategotyLoader];
    [browseByCategotyLoader startAnimating];
    
    [self parseURL:self.theProductURL];
    [self addFilternSortButtons];
    
    sortParam = @"";
    pageNumber = 1;
    isFetching = false;
    paramDictionary = [[NSMutableDictionary alloc] init];
    requestHandler = [[SSBaseRequestHandler alloc] init];

    parsedDataArray = [[NSMutableArray alloc] initWithCapacity:0];
    // Do any additional setup after loading the view.

    if (feedGrdidView) {
        [feedGrdidView removeFromSuperview];
        feedGrdidView = nil;
    }
    feedGrdidView = [[GridView alloc] initWithFrame:CGRectMake(0, filterNSortButtonContainer.frame.origin.y+ filterNSortButtonContainer.frame.size.height, self.view.frame.size.width, self.view.frame.size.height - 64-filterNSortButtonContainer.frame.size.height)];
    if(self.screenType == BrowseTypeBrwose){
        feedGrdidView.isBrowsed = true;
    }else{
        feedGrdidView.isSearched = true;
    }
    feedGrdidView.delegate = self;
    [self getData];
    searchButton = [[UIBarButtonItem alloc] init];

    [searchButton setImage:[UIImage imageNamed:@"SearchBrowse"]];
    [searchButton setTarget:self];
    [searchButton setAction:@selector(beginSearchFromEmptyState:)];
    
    self.navigationItem.rightBarButtonItems = @[searchButton];

    self.navigationController.navigationBar.topItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    [self.navigationController.navigationBar setFont:[UIFont fontWithName:kMontserrat_Regular size:16.0f] withColor:UIColorFromRGB(kDarkPurpleColor)];

    [self setBackButton];
}
-(void)setBackButton{
    UIImage *backButtonImage = [[UIImage imageNamed:kBackButtonImage] imageWithAlignmentRectInsets:UIEdgeInsetsMake(0, kBackButtonImageInset, 0, 0)];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:backButtonImage style:UIBarButtonItemStyleBordered target:self action:@selector(backAction:)];
}
-(void)backAction:(id)sender{
    [self.navigationController popViewControllerAnimated:TRUE];
}
-(void)parseURL:(NSString *)urlString{
    
    NSURL *url = [NSURL URLWithString:urlString];
    NSArray *params = [[url query] componentsSeparatedByString:@"&"];
    
    defaultParamDictionary = [[NSMutableDictionary alloc] init];
    defaultParamDictionaryArray = [[NSMutableArray alloc] init];

    
    for(int i = 0; i < [params count]; i++){
        NSArray *tempArrray = [[params objectAtIndex:i] componentsSeparatedByString:@"="];

        [defaultParamDictionary setObject:[[tempArrray lastObject] stringByRemovingPercentEncoding] forKey:[tempArrray firstObject]];
        
        NSDictionary *temp = [[NSDictionary alloc] initWithObjectsAndKeys:[[tempArrray lastObject] stringByRemovingPercentEncoding], [tempArrray firstObject], nil];
        [defaultParamDictionaryArray addObject:temp];
    }
    feedURL = [[[urlString componentsSeparatedByString:@"?"] firstObject] mutableCopy];
    [feedURL appendString:@"?"];
}


-(BOOL)hidesBottomBarWhenPushed{
    return YES;
}

-(void)setupButtonsContainer{
    if (filterNSortButtonContainer) {
        [filterNSortButtonContainer removeFromSuperview];
        filterNSortButtonContainer = nil;
    }
    filterNSortButtonContainer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 40)];
    [filterNSortButtonContainer setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:filterNSortButtonContainer];
    
    CALayer *dividerLayer = [CALayer layer];
    dividerLayer.frame = CGRectMake(0, 5, 1, filterNSortButtonContainer.frame.size.height - 12);
    dividerLayer.backgroundColor = UIColorFromRGB(0xD0D0D0).CGColor;
    dividerLayer.position = (CGPoint){CGRectGetMidX(filterNSortButtonContainer.layer.bounds), CGRectGetMidY(filterNSortButtonContainer.layer.bounds)};
    [filterNSortButtonContainer.layer addSublayer:dividerLayer];
    
    [filterNSortButtonContainer setAlpha:0.9];


}


-(void)addFilternSortButtons{
    [self setupButtonsContainer];
    NSAttributedString *sortString = [[NSAttributedString alloc] initWithString:@"SORT" attributes:@{NSFontAttributeName : [UIFont fontWithName:kMontserrat_Light size:14.0], NSForegroundColorAttributeName : [UIColor blackColor]}];
    CGRect sortRect = [sortString boundingRectWithSize:CGSizeMake(filterNSortButtonContainer.frame.size.width/2, filterNSortButtonContainer.frame.size.height) options:NSStringDrawingTruncatesLastVisibleLine context:NULL];
    
    
    NSAttributedString *filterString = [[NSAttributedString alloc] initWithString:@"FILTER" attributes:@{NSFontAttributeName : [UIFont fontWithName:kMontserrat_Light size:14.0], NSForegroundColorAttributeName : [UIColor blackColor]}];
    CGRect filterRect = [filterString boundingRectWithSize:CGSizeMake(filterNSortButtonContainer.frame.size.width/2, filterNSortButtonContainer.frame.size.height) options:NSStringDrawingTruncatesLastVisibleLine context:NULL];
    
    sortButtonContainer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, filterNSortButtonContainer.frame.size.width/2 - 4, filterNSortButtonContainer.frame.size.height)];
    [sortButtonContainer setCenter:CGPointMake(filterNSortButtonContainer.frame.size.width/4, filterNSortButtonContainer.frame.size.height/2)];
    [filterNSortButtonContainer addSubview:sortButtonContainer];
    
    UIButton *sortButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, sortButtonContainer.frame.size.width + 4, sortButtonContainer.frame.size.height)];
    [sortButton setBackgroundImage:[SSUtility imageWithColor:[UIColor clearColor]] forState:UIControlStateNormal];
    [sortButton setBackgroundImage:[SSUtility imageWithColor:UIColorFromRGB(0xF4F4F4)] forState:UIControlStateHighlighted];
    [sortButton addTarget:self action:@selector(showSortByView) forControlEvents:UIControlEventTouchUpInside];
    [sortButtonContainer addSubview:sortButton];

    sortLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, sortRect.size.width, sortRect.size.height)];
    [sortLabel setCenter:CGPointMake(sortButtonContainer.frame.size.width/2, sortButtonContainer.frame.size.height/2)];
    [sortLabel setBackgroundColor:[UIColor clearColor]];
    //    [sortButton addTarget:self action:@selector(showSortByView) forControlEvents:UIControlEventTouchUpInside];
    [sortLabel setAttributedText:sortString];
    [sortButtonContainer addSubview:sortLabel];
    
    UIImage *sortImage = [UIImage imageNamed:@"SortHeader"];
    //    sortIcon = [[UIImageView alloc] initWithFrame:CGRectMake(sortLabel.frame.origin.x - 30, 0, 32, 32)];
    sortIcon = [[UIImageView alloc] initWithFrame:CGRectMake(sortLabel.frame.origin.x - sortImage.size.width - 3, 0, sortImage.size.width, sortImage.size.height)];
    [sortIcon setImage:sortImage];
    [sortIcon setCenter:CGPointMake(sortIcon.center.x, sortButtonContainer.frame.size.height/2)];
    [sortButtonContainer addSubview:sortIcon];
    
    filterButtonContainer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, filterNSortButtonContainer.frame.size.width/2 - 4, filterNSortButtonContainer.frame.size.height)];
    [filterButtonContainer setCenter:CGPointMake(filterNSortButtonContainer.frame.size.width/2 + filterNSortButtonContainer.frame.size.width/4, filterNSortButtonContainer.frame.size.height/2)];
    [filterNSortButtonContainer addSubview:filterButtonContainer];
    
    UIButton *filterButton = [[UIButton alloc] initWithFrame:CGRectMake(-4, 0, sortButtonContainer.frame.size.width + 4, sortButtonContainer.frame.size.height)];
    [filterButton setBackgroundImage:[SSUtility imageWithColor:[UIColor clearColor]] forState:UIControlStateNormal];
    [filterButton setBackgroundImage:[SSUtility imageWithColor:UIColorFromRGB(0xF4F4F4)] forState:UIControlStateHighlighted];
    [filterButton addTarget:self action:@selector(showFilterView) forControlEvents:UIControlEventTouchUpInside];
    [filterButtonContainer addSubview:filterButton];
    
    filterLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, filterRect.size.width, filterRect.size.height)];
    [filterLabel setCenter:CGPointMake(filterButtonContainer.frame.size.width/2, filterButtonContainer.frame.size.height/2)];
    [filterLabel setBackgroundColor:[UIColor clearColor]];
    [filterLabel setAttributedText:filterString];
    [filterButtonContainer addSubview:filterLabel];
    
    UIImage *filterImage = [UIImage imageNamed:@"FilterHeader"];
    //    filterIcon = [[UIImageView alloc] initWithFrame:CGRectMake(filterLabel.frame.origin.x - 30, 0, 32, 32)];
    filterIcon = [[UIImageView alloc] initWithFrame:CGRectMake(filterLabel.frame.origin.x - filterImage.size.width - 3, 0, filterImage.size.width, filterImage.size.height)];
    //    [filterIcon setImage:[UIImage imageNamed:@"FilterHeader"]];
    [filterIcon setImage:filterImage];
    
    [filterIcon setCenter:CGPointMake(filterIcon.center.x, filterButtonContainer.frame.size.height/2)];
    [filterButtonContainer addSubview:filterIcon];
    
    [filterNSortButtonContainer setUserInteractionEnabled:FALSE];
    [sortLabel setAlpha:0.4];
    [filterLabel setAlpha:0.4];
}


-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:TRUE];
    [self.navigationController.navigationBar changeNavigationBarToTransparent:FALSE];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:TRUE];
    [self.navigationController.view setBackgroundColor:[UIColor whiteColor]];
}
#pragma mark - Getting Data from service.
-(void)getData{
    
    isFetching = TRUE;
    if(feedGrdidView){
        [feedGrdidView setHidden:true];
    }
    
    paramDictionary = [defaultParamDictionary mutableCopy];
    
    paramArray = [[NSMutableArray alloc] init];
    
//    NSArray *paramKeys = [paramDictionary allKeys];
//    for(int i = 0; i < [paramKeys count]; i++){
//        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
//        [dict setObject:[paramDictionary objectForKey:[paramKeys objectAtIndex:i]] forKey:[paramKeys objectAtIndex:i]];
//        [paramArray addObject:dict];
//    }
    
    [paramArray addObjectsFromArray:defaultParamDictionaryArray];

    __block FyndActivityIndicator *weakLoader = browseByCategotyLoader;
    

    [requestHandler sendHttpRequestWithURL:feedURL withParameterArray:paramArray withCompletionHandler:^(id responseData, NSError *error) {
        if (categoryDataDictionary) {
            categoryDataDictionary = nil;
        }
        categoryDataDictionary = responseData;
        
        if([categoryDataDictionary count] > 0){
            if([feedGrdidView isHidden]){
                [feedGrdidView setHidden:false];
            }
            feedGrdidView.parsedDataArray = [SSUtility parseJSON:[categoryDataDictionary objectForKey:@"items"] forGridView:feedGrdidView];
            hasNext = [[[categoryDataDictionary objectForKey:@"page"] objectForKey:@"has_next"] boolValue];
            if(hasNext){
                feedGrdidView.shouldHideLoaderSection = false;
            }else{
                feedGrdidView.shouldHideLoaderSection = true;
            }
            
            NSDictionary *temp = categoryDataDictionary[@"page"];
            NSString *totalItemsCount = [NSString stringWithFormat:@"%@",temp[@"total_item_count"]];
            NSString *countValue = nil;
            if ([totalItemsCount intValue]>1) {
                countValue = [NSString stringWithFormat:@"%@ Items",totalItemsCount];
            }else{
                countValue = [NSString stringWithFormat:@"%@ Item",totalItemsCount];
            }
            if (![[countValue uppercaseString] isEqualToString:@"NONE"]) {
                
                
                CGSize categorySize = [SSUtility getSingleLineLabelDynamicSize:[self.theCategory capitalizedString] withFont:[UIFont fontWithName:kMontserrat_Regular size:14.0f] withSize:CGSizeMake(200, 30)];
                categorySize = CGSizeMake(categorySize.width + 5, categorySize.height+ 2);
                [_titleLabel setFrame:CGRectMake(10, 0, categorySize.width,categorySize.height)];
                [titleViewResults setFrame:CGRectMake(titleViewResults.frame.origin.x, titleViewResults.frame.origin.y, categorySize.width+20,categorySize.height+15)];
                
                _titleLabel.text = [self.theCategory capitalizedString];

                [_countLabel setText:countValue];
                CGSize countLabelSize = [SSUtility getLabelDynamicSize:countValue withFont:[UIFont fontWithName:kMontserrat_Regular size:12.0f] withSize:CGSizeMake(MAXFLOAT, 44)];
                [_countLabel setFrame:CGRectMake(_titleLabel.frame.origin.x+ categorySize.width/2- countLabelSize.width/2, _titleLabel.frame.size.height+3, countLabelSize.width,15)];
                
                [_countLabel setHidden:FALSE];
            }else
                [_countLabel setHidden:TRUE];
            for(int i = 0; i < [[categoryDataDictionary objectForKey:@"sort_on"] count]; i++){
                if([[[[categoryDataDictionary objectForKey:@"sort_on"] objectAtIndex:i] objectForKey:@"is_selected"] boolValue]){
                    sortParam = [[[categoryDataDictionary objectForKey:@"sort_on"] objectAtIndex:i] objectForKey:@"value"];
                }
            }
            
            dispatch_async(dispatch_get_main_queue(), ^(void){
                
                if ([feedGrdidView.parsedDataArray count]>0) {
                    if([feedGrdidView isHidden]){
                        feedGrdidView.hidden = false;
                    }
                    if(![self.blankPage isHidden]){
                        self.blankPage.hidden = true;
                    }
                    [self.view addSubview:feedGrdidView];
                    
                    [feedGrdidView addCollectionView];
//                    [feedGrdidView.collectionView reloadData];
                    [feedGrdidView reloadCollectionView];
                    isFetching = false;

                    [weakLoader stopAnimating];
                    [weakLoader removeFromSuperview];
                    [filterNSortButtonContainer setUserInteractionEnabled:TRUE];
                    [sortLabel setAlpha:1.0];
                    [filterLabel setAlpha:1.0];
                }else{
                   

                    feedGrdidView.hidden = true;
                    
                    [filterNSortButtonContainer setUserInteractionEnabled:FALSE];
                    [sortLabel setAlpha:0.4];
                    [filterLabel setAlpha:0.4];
                    
                    [weakLoader stopAnimating];
                    [weakLoader removeFromSuperview];
                    
//                    theIndicator = nil;
                    if (self.blankPage) {
                        [self.blankPage removeFromSuperview];
                        self.blankPage = nil;
                    }
                    
                    self.blankPage = [[FyndBlankPage alloc] initWithFrame:CGRectMake(10, sortButtonContainer.frame.origin.y + sortButtonContainer.frame.size.height + 10, self.view.frame.size.width-20, self.view.frame.size.height - filterNSortButtonContainer.frame.size.height-20 - 64) blankPageType:ErrorNoSearchResults];
                    
                    __weak BrowseByCategoryViewController *controller = self;
                    self.blankPage.blankPageBlock =^(){
                        [controller beginSearchFromEmptyState:TRUE];
                    };
                    
                    [self.view addSubview:self.blankPage];
                }
            });
                [SSUtility removeBranchStoredData];
            }else{
                if (self.blankPage) {
                    [self.blankPage removeFromSuperview];
                    self.blankPage = nil;
                }
                
                self.blankPage = [[FyndBlankPage alloc] initWithFrame:CGRectMake(10, sortButtonContainer.frame.origin.y + sortButtonContainer.frame.size.height + 10, self.view.frame.size.width-20, self.view.frame.size.height - filterNSortButtonContainer.frame.size.height-20 - 64) blankPageType:ErrorNoSearchResults];
                
                __weak BrowseByCategoryViewController *controller = self;
                self.blankPage.blankPageBlock =^(){
                    [controller beginSearchFromEmptyState:TRUE];
                };
                
                [self.view addSubview:self.blankPage];
                [SSUtility removeBranchStoredData];
        }
    }

    ];
}

#pragma mark - Navigation Icons Action
-(void)beginSearchFromEmptyState:(BOOL)isComingFromEmptyState{
    __weak BrowseByCategoryViewController *weakSelf = self;
    if (theSearchViewController == nil) {
//        theSearchViewController = [[SearchViewController alloc] init];
    }

       theSearchViewController = [[SearchViewController alloc] init];
    theSearchViewController.thePushBlock = ^(NSString *stringParam,NSString *theURLString,NSString *theName, NSString* parentCatgory, NSString *gender, AutoSuggestModel *searchModel){
        if ([[stringParam uppercaseString] isEqualToString:@"PRODUCT"]) {
            PDPViewController * pdpViewController = [[PDPViewController alloc] init];
            pdpViewController.productURL = theURLString;
            [weakSelf.navigationController pushViewController:pdpViewController animated:TRUE];
            
        }else if ([[stringParam uppercaseString] isEqualToString:@"BRAND"]){
            BrowseByBrandViewController * brandController = [[BrowseByBrandViewController alloc] init];
            brandController.isProfileBrand = TRUE;
            [brandController parseURL:theURLString];
            [weakSelf.navigationController pushViewController:brandController animated:TRUE];
            
        }else if ([[stringParam uppercaseString] isEqualToString:@"COLLECTION"]){
            BrowseByCollectionViewController *theBrowseController = [[BrowseByCollectionViewController alloc] init];
            theBrowseController.isProfileCollection = TRUE;
            [theBrowseController parseURL:theURLString];
            [weakSelf.navigationController pushViewController:theBrowseController animated:TRUE];
            
        }else if ([[stringParam uppercaseString] isEqualToString:@"CATEGORY"] || [[stringParam uppercaseString] isEqualToString:@"FREETEXT"]){
            weakSelf.theProductURL = theURLString;
            [weakSelf parseURL:theURLString];
            weakSelf.theCategory = theName;
            [weakSelf viewWillAppear:TRUE];
            [weakSelf getData];
            
            if([[stringParam uppercaseString] isEqualToString:@"FREETEXT"]){

                if(searchModel && searchModel != nil){
                    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                    [formatter setDateFormat:@"YYYY-MM-dd'T'HH:mm:ss"];
                    NSDate *now = [NSDate date];
                    NSString *dateString = [formatter stringFromDate:now];

                    if(weakSelf.screenType == BrowseTypeSearch){
                        [FyndAnalytics trackSearchEventFrom:@"search" searchString:searchModel.displayName searchDate:dateString];
                    }else{
                        [FyndAnalytics trackSearchEventFrom:@"category" searchString:searchModel.displayName searchDate:dateString];
                    }
                }
                
            }else{
             
                [FyndAnalytics trackCategoryEvent:gender category:parentCatgory subcategory:theName];
            }


        }
    };
    
    [self.navigationController presentViewController:theSearchViewController animated:TRUE completion:nil];
}


-(void)searchLocation{
    LocationSearchViewController *searchViewCOntroller = [[LocationSearchViewController alloc] init];
    [self.navigationController pushViewController:searchViewCOntroller animated:YES];
}

-(void)showSortByView{
    if(!sortView){
        sortView = [[SortViewController alloc] initSortByArray:[categoryDataDictionary objectForKey:@"sort_on"]];
        sortView.delegate = self;
        sortNav = [[UINavigationController alloc] initWithRootViewController:sortView];
    }
    [self presentViewController:sortNav animated:YES completion:nil];
}

-(void)showFilterView{
    
    if(filterView){
        filterView.filterDelegate = self;
        filterView = nil;
    }
    defaultFilters = [[NSArray alloc] initWithArray:[categoryDataDictionary objectForKey:@"filters"]];
    filterView = [[FilterViewController alloc] initWithDataArray:defaultFilters];
    filterView.filterDelegate = self;
    filterNav = [[UINavigationController alloc] initWithRootViewController:filterView];
    [self.navigationController presentViewController:filterNav animated:YES completion:nil];
}


#pragma mark - SortDelegate

-(void)sortSelected:(NSString *)string{
    sortParam = string;
    [self getFilteredDataWithAppliedFilters:filterArray];
}

-(void)sortDismissed{
    if(sortView){
        sortNav = nil;
        sortView = nil;
    }
}


#pragma Mark - Filters Delegates
-(void)resetFilters{
    filterArray = nil;
    [self getFilterResetData];
}

-(void)getFilterResetData{
    
    isFetching = TRUE;
    __block FyndActivityIndicator *weakLoader = browseByCategotyLoader;
    
    pageNumber = 1;

    paramDictionary = [defaultParamDictionary mutableCopy];
    [paramDictionary setObject:sortParam forKey:@"sort_on"];
    
    paramArray = [[NSMutableArray alloc] init];
    
//    NSArray *paramKeys = [paramDictionary allKeys];
//    for(int i = 0; i < [paramKeys count]; i++){
//        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
//        [dict setObject:[paramDictionary objectForKey:[paramKeys objectAtIndex:i]] forKey:[paramKeys objectAtIndex:i]];
//        [paramArray addObject:dict];
//    }
    [paramArray addObjectsFromArray:defaultParamDictionaryArray];
    [paramArray addObject:[[NSDictionary alloc] initWithObjectsAndKeys:sortParam, @"sort_on", nil]];

    
    [requestHandler sendHttpRequestWithURL:feedURL withParameterArray:paramArray withCompletionHandler:^(id responseData, NSError *error) {
        categoryDataDictionary = responseData;
        if([categoryDataDictionary count] > 0){
            if (feedGrdidView.parsedDataArray) {
                [feedGrdidView.parsedDataArray removeAllObjects];
            }
            [feedGrdidView.parsedDataArray addObjectsFromArray:[SSUtility parseJSON:[categoryDataDictionary objectForKey:@"items"] forGridView:feedGrdidView]];
            hasNext = [[[categoryDataDictionary objectForKey:@"page"] objectForKey:@"has_next"] boolValue];
            if(hasNext){
                feedGrdidView.shouldHideLoaderSection = false;
            }else{
                feedGrdidView.shouldHideLoaderSection = true;
            }
            NSDictionary *temp = categoryDataDictionary[@"page"];
            NSString *countValue = [NSString stringWithFormat:@"%@ Items",temp[@"total_item_count"]];
            if (![countValue isEqualToString:@"none"]) {
                
                CGSize categorySize = [SSUtility getSingleLineLabelDynamicSize:[self.theCategory capitalizedString] withFont:[UIFont fontWithName:kMontserrat_Regular size:14.0f] withSize:CGSizeMake(200, 30)];
                categorySize = CGSizeMake(categorySize.width + 5, categorySize.height+ 2);
                [_titleLabel setFrame:CGRectMake(10, 0, categorySize.width,categorySize.height)];
                [titleViewResults setFrame:CGRectMake(titleViewResults.frame.origin.x, titleViewResults.frame.origin.y, categorySize.width+20,categorySize.height+15)];
                
                
                _titleLabel.text = [self.theCategory capitalizedString];
                [_countLabel setText:countValue];
                CGSize countLabelSize = [SSUtility getLabelDynamicSize:countValue withFont:[UIFont fontWithName:kMontserrat_Regular size:12.0f] withSize:CGSizeMake(MAXFLOAT, 44)];
                [_countLabel setFrame:CGRectMake(_titleLabel.frame.origin.x+ categorySize.width/2- countLabelSize.width/2, _titleLabel.frame.size.height+3, countLabelSize.width,15)];

                [_countLabel setHidden:FALSE];
            }else
                [_countLabel setHidden:TRUE];
            dispatch_async(dispatch_get_main_queue(), ^(void){
                
                if ([feedGrdidView.parsedDataArray count]>0) {
//                    [feedGrdidView.collectionView reloadData];
                    [feedGrdidView reloadCollectionView];
                    isFetching = false;
                    [weakLoader stopAnimating];
                    [weakLoader removeFromSuperview];
                    
                    [filterView updateFilterViewWithNewData:defaultFilters];
                }else{
                    if (messageLabel) {
                        [messageLabel removeFromSuperview];
                        messageLabel = nil;
                    }
//                    [theIndicator stopAnimating];
                    [weakLoader stopAnimating];
                    [weakLoader removeFromSuperview];
                    
                    messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2 - 50, 50, 200, 50)];
                    [messageLabel setText:@"No Results."];
                    [messageLabel setTextColor:UIColorFromRGB(kDarkPurpleColor)];
                    [self.view addSubview:messageLabel];
                }
                
            });
        }
    }];
}


-(void)refreshFiltersWith:(NSArray *)appliedFilters{
    [self getFilteredDataWithAppliedFilters:appliedFilters];
}

-(void)filterDismissed{
    if(filterView){
        
        [filterNav dismissViewControllerAnimated:YES completion:^{
            filterNav = nil;
            filterView = nil;
        }];
    }
}

-(void)getFilteredDataWithAppliedFilters:(NSArray *)array{
    
    isFetching = TRUE;
    filterArray = array;
    pageNumber = 1;

    __block FyndActivityIndicator *weakLoader = browseByCategotyLoader;


    [feedGrdidView.collectionView setHidden:TRUE];
    
    [weakLoader removeFromSuperview];
    [weakLoader stopAnimating];
    
    [self.view addSubview:weakLoader];
    [weakLoader startAnimating];
    
    
    paramArray = [[NSMutableArray alloc] init];
    
    paramDictionary = [defaultParamDictionary mutableCopy];
    [paramDictionary setObject:sortParam forKey:@"sort_on"];
    
    //copy default params to paramArray
//    NSArray *paramKeys = [paramDictionary allKeys];
//    for(int i = 0; i < [paramKeys count]; i++){
//        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
//        [dict setObject:[paramDictionary objectForKey:[paramKeys objectAtIndex:i]] forKey:[paramKeys objectAtIndex:i]];
//        [paramArray addObject:dict];
//    }
    [paramArray addObjectsFromArray:defaultParamDictionaryArray];
    [paramArray addObject:[[NSDictionary alloc] initWithObjectsAndKeys:sortParam, @"sort_on", nil]];

    
    //copy filter params to paramArray
    for(int i = 0; i < [filterArray count]; i++){
        [paramArray addObject:[filterArray objectAtIndex:i]];
    }
    
    
//    [requestHandler sendHttpRequestWithURL:feedURL withParameters:paramDictionary withCompletionHandler:^(id responseData, NSError *error) {
    [requestHandler sendHttpRequestWithURL:feedURL withParameterArray:paramArray withCompletionHandler:^(id responseData, NSError *error) {
        categoryDataDictionary = responseData;
        isFetching = false;
        if([categoryDataDictionary count] > 0){
            if (feedGrdidView.parsedDataArray) {
                [feedGrdidView.parsedDataArray removeAllObjects];
            }
            
            [feedGrdidView.parsedDataArray addObjectsFromArray:[SSUtility parseJSON:[categoryDataDictionary objectForKey:@"items"] forGridView:feedGrdidView]];
            hasNext = [[[categoryDataDictionary objectForKey:@"page"] objectForKey:@"has_next"] boolValue];
            if(hasNext){
                feedGrdidView.shouldHideLoaderSection = false;
            }else{
                feedGrdidView.shouldHideLoaderSection = true;
            }
            NSDictionary *temp = categoryDataDictionary[@"page"];
            NSString *countValue = [NSString stringWithFormat:@"%@ Items",temp[@"total_item_count"]];
            if (![countValue isEqualToString:@"none"]) {
                CGSize categorySize = [SSUtility getSingleLineLabelDynamicSize:[self.theCategory capitalizedString] withFont:[UIFont fontWithName:kMontserrat_Regular size:14.0f] withSize:CGSizeMake(200, 30)];
                categorySize = CGSizeMake(categorySize.width + 5, categorySize.height+ 2);
                [_titleLabel setFrame:CGRectMake(10, 0, categorySize.width,categorySize.height)];
                [titleViewResults setFrame:CGRectMake(titleViewResults.frame.origin.x, titleViewResults.frame.origin.y, categorySize.width+20,categorySize.height+15)];
                
                _titleLabel.text = [self.theCategory capitalizedString];
                [_countLabel setText:countValue];
                CGSize countLabelSize = [SSUtility getLabelDynamicSize:countValue withFont:[UIFont fontWithName:kMontserrat_Regular size:12.0f] withSize:CGSizeMake(MAXFLOAT, 44)];
                [_countLabel setFrame:CGRectMake(_titleLabel.frame.origin.x+ categorySize.width/2- countLabelSize.width/2, _titleLabel.frame.size.height+3, countLabelSize.width,15)];

                
                [_countLabel setHidden:FALSE];
            }else
                [_countLabel setHidden:TRUE];
            dispatch_async(dispatch_get_main_queue(), ^(void){
                
                if ([feedGrdidView.parsedDataArray count]>0) {
//                    [feedGrdidView.collectionView reloadData];
                    [feedGrdidView reloadCollectionView];
//                    [theIndicator stopAnimating];
                    [weakLoader stopAnimating];
                    [weakLoader removeFromSuperview];
                    [filterView updateFilterViewWithNewData:[categoryDataDictionary objectForKey:@"filters"]];
                    [feedGrdidView.collectionView setHidden:FALSE];
                }else{
                    if (messageLabel) {
                        [messageLabel removeFromSuperview];
                        messageLabel = nil;
                    }
//                    [theIndicator stopAnimating];
                    [weakLoader stopAnimating];
                    [weakLoader removeFromSuperview];
                    messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2 - 50, 50, 200, 50)];
                    [messageLabel setText:@"No Results."];
                    [messageLabel setTextColor:UIColorFromRGB(kDarkPurpleColor)];
                    [self.view addSubview:messageLabel];
                }
                
            });
        }
    }];
}


#pragma mark GridView Delegate Method

-(void)didScrollToEndOfLastPage{

    if(paramArray){
        for(int i = 0; i < [paramArray count]; i++){
            if([[[[paramArray objectAtIndex:i] allKeys] objectAtIndex:0] isEqualToString:@"page"]){
                [paramArray removeObjectAtIndex:i];
                break;
            }
        }
    }
    if (hasNext && !isFetching) {
        
        isFetching = true;
//        [paramDictionary setObject:[NSString stringWithFormat:@"%d", ++pageNumber] forKey:@"page"];
        [paramArray addObject:[NSDictionary dictionaryWithObject:[NSString stringWithFormat:@"%d", ++pageNumber] forKey:@"page"]];


        NSInteger prevLastIndex = [feedGrdidView.parsedDataArray count] - 1;
        __block NSInteger newLastIndex = 0;
        
        
//        [requestHandler sendHttpRequestWithURL:feedURL withParameters:paramDictionary withCompletionHandler:^(id responseData, NSError *error) {
        [requestHandler sendHttpRequestWithURL:feedURL withParameterArray:paramArray withCompletionHandler:^(id responseData, NSError *error) {
//            NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            if([responseData count] > 0){
                [feedGrdidView.parsedDataArray addObjectsFromArray:[SSUtility parseJSON:[responseData objectForKey:@"items"] forGridView:feedGrdidView]];
                hasNext = [[[responseData objectForKey:@"page"] objectForKey:@"has_next"] boolValue];
                if(hasNext){
                    feedGrdidView.shouldHideLoaderSection = false;
                }else{
                    feedGrdidView.shouldHideLoaderSection = true;
                }
                newLastIndex = [feedGrdidView.parsedDataArray count] - 1;
                
                NSMutableArray *indexSetArray = [[NSMutableArray alloc] initWithCapacity:0];
                for(int i = 0; i < newLastIndex - prevLastIndex; i++){
                    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i+prevLastIndex +1 inSection:0];
                    [indexSetArray addObject:indexPath];
                }
                dispatch_async(dispatch_get_main_queue(), ^(void){
                    isFetching = false;
                    [feedGrdidView reloadCollectionView:indexSetArray];
                });
            }else {
                pageNumber -= 1;
            }
        }];
    }
}

- (void)showPDPScreen:(NSString *)url{

    PDPViewController* thePDPViewController = [[PDPViewController alloc] init];
    if (self.screenType == BrowseTypeSearch) {
        thePDPViewController.isFromSearch = true;
    }
    thePDPViewController.productURL = url;
    [self.navigationController pushViewController:thePDPViewController animated:YES];
}

- (void)showBrowseByBrandPage:(NSString *)url{

    BrowseByBrandViewController *theBrandViewController = [[BrowseByBrandViewController alloc] init];
    [theBrandViewController parseURL:url];
    [self.navigationController pushViewController:theBrandViewController animated:YES];
}

-(void)showBrowseByCollectionPage:(NSString *)url{

    BrowseByCollectionViewController *theBrowseCollectionViewController = [[BrowseByCollectionViewController alloc] init];
    [theBrowseCollectionViewController parseURL:url];
    
    [self.navigationController pushViewController:theBrowseCollectionViewController animated:YES];
}


@end
