//
//  BrowseByBrandViewController.m
//  
//
//  Created by Rahul on 7/6/15.
//
//

#import "BrowseByBrandViewController.h"
#define kParallaxHeaderHeight   300
@interface BrowseByBrandViewController (){
        BOOL isScrolling;
}
@end

@implementation BrowseByBrandViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // Do any additional setup after loading the view.
    
    browseByBrandLoader = [[FyndActivityIndicator alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    [browseByBrandLoader setCenter:CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height/2)];
    
    sortParam = @"";
    pages = 1;
    self.navigationController.navigationBar.topItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.browseByBrandRequestHandler = [[BrowseByBrandRequestHandler alloc] init];
    paramDictionary = [[NSMutableDictionary alloc] init];
    
//    [self setupScreen];
    [self setupHeader];

    [self setupParallaxComponents];
    [self.view addSubview:browseByBrandLoader];
    [browseByBrandLoader startAnimating];

    [self fetchBrandData];
//    [[UIApplication sharedApplication] setStatusBarHidden:TRUE];
    backButtonImageName = kBackButtonImageWhite;
    [self setBackButton:backButtonImageName];
}

-(void)setBackButton:(NSString *)imageName{
    UIImage *backButtonImage = [[UIImage imageNamed:imageName] imageWithAlignmentRectInsets:UIEdgeInsetsMake(0, kBackButtonImageInset, 0, 0)];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:backButtonImage style:UIBarButtonItemStyleBordered target:self action:@selector(backAction:)];
}
-(void)backAction:(id)sender{
    [self.navigationController popViewControllerAnimated:TRUE];
}

-(BOOL)hidesBottomBarWhenPushed{
    return YES;
}


-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:TRUE];
//    [[UIApplication sharedApplication] setStatusBarHidden:TRUE];//Amboj commented for nav bar issues
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    if(!isNavBarVisible){

        [self.navigationController.navigationBar changeNavigationBarToTransparent:TRUE];
    }else{
        [self.navigationController.navigationBar setBackgroundColor:[UIColor whiteColor]];
        [self.navigationController.navigationBar setTranslucent:YES];
    }
    [self.navigationController.navigationBar setFrame:CGRectMake(0, 0, self.navigationController.navigationBar.frame.size.width, self.navigationController.navigationBar.frame.size.height)];
    backButtonImageName = kBackButtonImageWhite;
    [self setBackButton:backButtonImageName];

}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar setFrame:CGRectMake(0, 20, self.navigationController.navigationBar.frame.size.width, self.navigationController.navigationBar.frame.size.height)];
//    self.scrollView.contentOffset = CGPointMake(0, 0 - self.scrollView.contentInset.top);
    [self resetBars];
}

-(void)parseURL:(NSString *)urlString{
//    brandURL = [urlString mutableCopy];
////    self.browseByBrandRequestHandler.baseURLString = url;
//    NSArray *mutableArray = [urlString componentsSeparatedByString:@"&"];
////    brandURL = [[NSMutableString alloc] initWithString:[mutableArray objectAtIndex:0]];
//    brandURL = [NSMutableString stringWithFormat:@"%@&", [mutableArray objectAtIndex:0]];
    
    
//    NSURL *url = [NSURL URLWithString:[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSURL *url = [NSURL URLWithString:urlString];

    NSArray *params = [[url query] componentsSeparatedByString:@"&"];
    
    defaultParamDictionaryArray = [[NSMutableArray alloc] init];
    
    defaultParamDictionary = [[NSMutableDictionary alloc] init];
    for(int i = 0; i < [params count]; i++){
        NSArray *tempArrray = [[params objectAtIndex:i] componentsSeparatedByString:@"="];
        [defaultParamDictionary setObject:[[tempArrray lastObject] stringByRemovingPercentEncoding] forKey:[tempArrray firstObject]];
        
        NSDictionary *temp = [[NSDictionary alloc] initWithObjectsAndKeys:[[tempArrray lastObject] stringByRemovingPercentEncoding], [tempArrray firstObject], nil];
        [defaultParamDictionaryArray addObject:temp];
    }
    if(!self.isProfileBrand){
        if(self.gender){
            [defaultParamDictionary setObject:self.gender forKey:@"gender"];
            [defaultParamDictionaryArray addObject:[NSDictionary dictionaryWithObjectsAndKeys:self.gender, @"gender", nil]];
        }else{
            FyndUser *user = [SSUtility loadUserObjectWithKey:kFyndUserKey];
            [defaultParamDictionary setObject:user.gender forKey:@"gender"];
            [defaultParamDictionaryArray addObject:[NSDictionary dictionaryWithObjectsAndKeys:user.gender, @"gender", nil]];
        }
    }
    brandURL = [[[urlString componentsSeparatedByString:@"?"] firstObject] mutableCopy];
    [brandURL appendString:@"?"];
}


-(BOOL)prefersStatusBarHidden{
    return YES;
}
-(void)setupScreen{
//    [self setupHeader];
//    [self setupParallaxComponents];
    [self setupBrandDetails];
    [self setupSortFilterButtons];
//    [self addActivityIndicators];
    
    
//    [self fetchPickOfTheWeek];
    [self fetchMoreProducts];
}

-(void)fetchBrandData{
    
    
//    paramDictionary = [[NSMutableDictionary alloc] initWithDictionary:@{@"items" : @"true", @"filters" : @"true", @"headers" : @"true", @"pick_of_the_week" : @"true"}];
    paramDictionary = [defaultParamDictionary mutableCopy];
    
    paramArray = [[NSMutableArray alloc] init];
    
//    NSArray *paramKeys = [paramDictionary allKeys];
//    for(int i = 0; i < [paramKeys count]; i++){
//        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
//        [dict setObject:[paramDictionary objectForKey:[paramKeys objectAtIndex:i]] forKey:[paramKeys objectAtIndex:i]];
//        [paramArray addObject:dict];
//    }
    [paramArray addObjectsFromArray:defaultParamDictionaryArray];
    
    [self.browseByBrandRequestHandler fetchBrowseByBrandDataWithArray:paramArray fromURL:brandURL withRequestCompletionhandler:^(id responseData, NSError *error) {
        [self setupScreen];
        if([responseData count] > 0){
            if(responseData[@"items"] && [responseData[@"items"] count] > 0){
                brandDataDictionary = responseData;
                brandModel = [[BrandTileModel alloc] initWithBrowseDataDictionary:brandDataDictionary];
                //            brandModel.brandID = [SSUtility getValueForParam:kBrandID from:brandURL];
                brandModel.brandID = defaultParamDictionary[@"brand"];
                
                brandModel.moreProducts = [SSUtility parseJSON:[brandDataDictionary objectForKey:@"items"] forGridView:moreProductsList];
                hasNext = [[[brandDataDictionary objectForKey:@"page"] objectForKey:@"has_next"] boolValue];
                if(!hasNext){
                    moreProductsList.shouldHideLoaderSection = YES;
                }else{
                    moreProductsList.shouldHideLoaderSection = NO;
                }
                for(int i = 0; i < [[brandDataDictionary objectForKey:@"sort_on"] count]; i++){
                    if([[[[brandDataDictionary objectForKey:@"sort_on"] objectAtIndex:i] objectForKey:@"is_selected"] boolValue]){
                        sortParam = [[[brandDataDictionary objectForKey:@"sort_on"] objectAtIndex:i] objectForKey:@"value"];
                    }
                }
                dispatch_async(dispatch_get_main_queue(), ^(void){
                    [self updateBrandDetailScreen];
                });
                [SSUtility removeBranchStoredData];
            }else{
                
            }
        }
    }];
}



-(void)updateBrandDetailScreen{
    
    [browseByBrandLoader stopAnimating];
    [browseByBrandLoader removeFromSuperview];
    [self.scrollView addSubview:brandDetailContainerView];
    [self.scrollView addSubview:buttonsContainer];    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self downloadImageFromURL:brandModel.banner_url forImageView:headerView];
        dispatch_async(dispatch_get_main_queue(), ^(void){
            gradientView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, DeviceWidth, 80)];
            gradientView.alpha = 0.8;
            CAGradientLayer *gradient = [CAGradientLayer layer];
            gradient.frame = gradientView.bounds;
            gradient.colors = [NSArray arrayWithObjects:(id)[UIColorFromRGB(kSignUpColor) CGColor], (id)[[UIColor clearColor] CGColor], nil];
            [gradientView.layer insertSublayer:gradient atIndex:0];
            [headerView addSubview:gradientView];
            [headerView bringSubviewToFront:gradientView];
        });
    });
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self downloadImageFromURL:brandModel.brandlogo forImageView:brandLogoImage];
    });

    [brandName setText:brandModel.name];
    CGSize nameSize = [SSUtility getLabelDynamicSize:brandName.text withFont:brandName.font withSize:CGSizeMake(self.scrollView.frame.size.width, MAXFLOAT)];
    [brandName setFrame:CGRectMake(brandName.frame.origin.x, brandName.frame.origin.y, nameSize.width, nameSize.height)];
    [brandName setCenter:CGPointMake(self.scrollView.frame.size.width/2, brandLogoImage.frame.origin.y + brandLogoImage.frame.size.height + nameSize.height/2 + 7)];

    //get nearest store name
    if(brandModel.nearest_store != (id)[NSNull null]){
        [nearestStoreLabel setText:brandModel.nearest_store];
        [nearestStoreLabel setFont:[UIFont fontWithName:kMontserrat_Light size:12.0]];
        CGSize nearestStoreSize = [SSUtility getLabelDynamicSize:nearestStoreLabel.text withFont:nearestStoreLabel.font withSize:CGSizeMake(self.scrollView.frame.size.width, MAXFLOAT)];
        [nearestStoreLabel setFrame:CGRectMake(0, 0, nearestStoreSize.width, nearestStoreSize.height)];
        [nearestStoreLabel setCenter:CGPointMake(self.scrollView.frame.size.width/2, brandName.frame.origin.y + brandName.frame.size.height + nearestStoreSize.height/2 + 3)];
    }

    if(!brandModel.is_following){
        
        followButtonText = [[NSAttributedString alloc] initWithString : @"FOLLOW"
                                                     attributes : @{
                                                                    NSFontAttributeName : [UIFont fontWithName:kMontserrat_Bold size:14.0],
                                                                    NSForegroundColorAttributeName : [UIColor whiteColor]
                                                                    }];
        [followButton setBackgroundColor:UIColorFromRGB(kTurquoiseColor)];
        
    }else {
        followButtonText = [[NSAttributedString alloc] initWithString : @"FOLLOWING"
                                                     attributes : @{
                                                                    NSFontAttributeName : [UIFont fontWithName:kMontserrat_Light size:12.0],
                                                                    NSForegroundColorAttributeName :UIColorFromRGB(kTurquoiseColor)
                                                                    }];
        [followButton setBackgroundColor:[UIColor clearColor]];
        followButton.layer.cornerRadius = 3.0f;
        followButton.layer.borderColor = UIColorFromRGB(kTurquoiseColor).CGColor;
        followButton.layer.borderWidth = 1.0f;
    }
    
    [followButton setAttributedTitle:followButtonText forState:UIControlStateNormal];
    [followButton setHidden:false];
    
    
    NSMutableAttributedString *storesText1 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%ld", (long)brandModel.store_count] attributes:@{NSFontAttributeName : [UIFont fontWithName:kMontserrat_Light size:12.0f], NSForegroundColorAttributeName : UIColorFromRGB(kDarkPurpleColor)}];
    NSMutableAttributedString *storesText2 = nil;
    if (brandModel.store_count>1) {
        storesText2 = [[NSMutableAttributedString alloc] initWithString:@" Stores" attributes:@{NSFontAttributeName : [UIFont fontWithName:kMontserrat_Light size:12.0f],NSForegroundColorAttributeName : UIColorFromRGB(kDarkPurpleColor)}];
        
    }else{
        storesText2 = [[NSMutableAttributedString alloc] initWithString:@" Store" attributes:@{NSFontAttributeName : [UIFont fontWithName:kMontserrat_Light size:12.0f],NSForegroundColorAttributeName : UIColorFromRGB(kDarkPurpleColor)}];
        
    }
    [storesText1 appendAttributedString:storesText2];
    CGRect storeFrame = [storesText1 boundingRectWithSize:CGSizeMake((0 + followButton.frame.origin.x), MAXFLOAT) options:NSStringDrawingTruncatesLastVisibleLine context:nil];
    [numberOfStoresLabel setFrame:CGRectMake(0, 0, storeFrame.size.width, storeFrame.size.height)];
    [numberOfStoresLabel setAttributedText:storesText1];
    [numberOfStoresLabel setCenter:CGPointMake((0 + followButton.frame.origin.x)/2, followButton.center.y)];
    
    followersText1 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%ld", (long)brandModel.follower_count] attributes:@{NSFontAttributeName : [UIFont fontWithName:kMontserrat_Light size:12.0f], NSForegroundColorAttributeName : UIColorFromRGB(kDarkPurpleColor)}];
    followersText2 = [[NSMutableAttributedString alloc] initWithString:(brandModel.follower_count == 1 ? @" Follower" : @" Followers") attributes:@{NSFontAttributeName : [UIFont fontWithName:kMontserrat_Light size:12.0f], NSForegroundColorAttributeName : UIColorFromRGB(kDarkPurpleColor)}];
    [followersText1 appendAttributedString:followersText2];
    followerFrame = [followersText1 boundingRectWithSize:CGSizeMake((0 + followButton.frame.origin.x), MAXFLOAT) options:NSStringDrawingTruncatesLastVisibleLine context:nil];
    [numberOfFollowersButton setFrame:CGRectMake(0, 0, followerFrame.size.width, followerFrame.size.height)];
    [numberOfFollowersButton setAttributedText:followersText1];
    [numberOfFollowersButton setCenter:CGPointMake((self.scrollView.frame.size.width + followButton.frame.origin.x + followButton.frame.size.width)/2, followButton.center.y)];
    
    if([[brandDataDictionary objectForKey:@"filters"] count] > 0 && [[brandDataDictionary objectForKey:@"sort_on"] count] > 0){
        [buttonsContainer setUserInteractionEnabled:TRUE];
        [sortLabel setAlpha:1.0];
        [filterLabel setAlpha:1.0];
    }
    
    moreProductsList.parsedDataArray = brandModel.moreProducts;
    [moreProductsList addCollectionView];
    [moreProductsContainer setHidden:NO];
    
    buttonContainerOriginalFrame = buttonsContainer.frame;
}


-(void)downloadImageFromURL:(NSString *)urlString forImageView:(UIImageView *)imageView{
    [imageView sd_setImageWithURL:[NSURL URLWithString:[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        [imageView setAlpha:0.3];
        [UIView animateWithDuration:0.4 animations:^{
            [imageView setAlpha:1.0];
        }];
    }];
}


-(void)fetchMoreProducts{
    moreProductsContainer = [[UIView alloc] initWithFrame:CGRectMake(0, brandDetailContainerView.frame.origin.y + brandDetailContainerView.frame.size.height + 3, self.scrollView.frame.size.width, 0)];
    [moreProductsContainer setBackgroundColor:UIColorFromRGB(kBackgroundGreyColor)];
    [self.scrollView addSubview:moreProductsContainer];
    moreProductsHeaderLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, moreProductsContainer.frame.size.width, 0)];
    [moreProductsHeaderLabel setCenter:CGPointMake(moreProductsContainer.frame.size.width/2, moreProductsHeaderLabel.frame.size.height/2)];
    [moreProductsHeaderLabel setBackgroundColor:[UIColor clearColor]];
    [moreProductsHeaderLabel setTextColor:UIColorFromRGB(kDarkPurpleColor)];
    [moreProductsHeaderLabel setTextAlignment:NSTextAlignmentCenter];
    [moreProductsHeaderLabel setText:@"MORE PRODUCTS"];
    [moreProductsHeaderLabel setFont:[UIFont fontWithName:kMontserrat_Bold size:13.0]];
    [moreProductsContainer addSubview:moreProductsHeaderLabel];
    moreProductsList = [[GridView alloc] initWithFrame:CGRectMake(0, moreProductsHeaderLabel.frame.origin.y + moreProductsHeaderLabel.frame.size.height + 6, moreProductsContainer.frame.size.width, 0)];
    moreProductsList.collectionView.scrollsToTop = false;
    moreProductsList.delegate = self;
    [moreProductsContainer addSubview:moreProductsList];
    
    if(isParsedDataArrayOBserverAdded){
        @try {
            [self removeObserver:self forKeyPath:@"moreProductsList.parsedDataArray"];
            isParsedDataArrayOBserverAdded = FALSE;
        }
        @catch (NSException *exception) {
        }
    }
    [self addObserver:self forKeyPath:@"moreProductsList.parsedDataArray" options:NSKeyValueObservingOptionOld context:NULL];
    isParsedDataArrayOBserverAdded = TRUE;
    
    
    if(isHeaderLabelObserverAdded){
        @try {
            [self removeObserver:self forKeyPath:@"moreProductsHeaderLabel.frame"];
            isHeaderLabelObserverAdded = FALSE;
        }
        @catch (NSException *exception) {
        }
    }
    [self addObserver:self forKeyPath:@"moreProductsHeaderLabel.frame" options:NSKeyValueObservingOptionOld context:NULL];
    isHeaderLabelObserverAdded = TRUE;
    

    if(isCollectionContentSizeObserverAdded){
        @try {
            [self removeObserver:self forKeyPath:@"moreProductsList.collectionView.contentSize"];
            isCollectionContentSizeObserverAdded = FALSE;
        }
        @catch (NSException *exception) {
        }
    }
    [self addObserver:self forKeyPath:@"moreProductsList.collectionView.contentSize" options:NSKeyValueObservingOptionOld context:NULL];
    isCollectionContentSizeObserverAdded = TRUE;
    
    [moreProductsContainer setHidden:YES];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    
    if([keyPath isEqualToString:@"moreProductsList.collectionView.contentSize"]) {
        [moreProductsList.collectionView setFrame:CGRectMake(moreProductsList.collectionView.frame.origin.x, moreProductsList.collectionView.frame.origin.y, moreProductsList.collectionView.frame.size.width, moreProductsList.collectionView.contentSize.height)];
        [moreProductsList setFrame:CGRectMake(moreProductsList.frame.origin.x, moreProductsList.frame.origin.y, moreProductsList.frame.size.width, moreProductsList.collectionView.frame.origin.y + moreProductsList.collectionView.frame.size.height)];
        [moreProductsContainer setFrame:CGRectMake(0, brandDetailContainerView.frame.origin.y + brandDetailContainerView.frame.size.height, self.scrollView.frame.size.width, moreProductsList.frame.origin.y + moreProductsList.frame.size.height)];
        [self.scrollView setContentSize:CGSizeMake(self.scrollView.frame.size.width, moreProductsContainer.frame.origin.y + moreProductsContainer.frame.size.height + 10)];
        
        [moreProductsContainer setBackgroundColor:UIColorFromRGB(kBackgroundGreyColor)];
        
    }else if ([keyPath isEqualToString:@"moreProductsHeaderLabel.frame"]){
        [moreProductsList setFrame:CGRectMake(moreProductsList.frame.origin.x, moreProductsHeaderLabel.frame.origin.y + moreProductsHeaderLabel.frame.size.height, moreProductsHeaderLabel.frame.size.width, moreProductsHeaderLabel.frame.size.height)];
    }else if ([keyPath isEqualToString:@"moreProductsList.parsedDataArray"]){
        [browseByBrandLoader stopAnimating];
        [browseByBrandLoader removeFromSuperview];
        
        if([moreProductsList.parsedDataArray count] ==0){
            [moreProductsList setHidden:true];
            if(!errorLabel){
                errorLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, brandDetailContainerView.frame.origin.y + brandDetailContainerView.frame.size.height +20, self.scrollView.frame.size.width, 30)];
                [errorLabel setTextAlignment:NSTextAlignmentCenter];
                [errorLabel setBackgroundColor:[UIColor clearColor]];
                [errorLabel setText:@"No products according to this filter"];
                [errorLabel setFont:[UIFont fontWithName:kMontserrat_Regular size:14.0]];
                [errorLabel setTextColor:UIColorFromRGB(kSignUpColor)];
                [self.scrollView addSubview:errorLabel];
            }
        }else{
            [moreProductsList setHidden:false];
            if(errorLabel){
                [errorLabel removeFromSuperview];
                errorLabel = nil;
            }
        }
    }
}

-(void)setupParallaxComponents{
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    self.scrollView.scrollsToTop = YES;
    [self.scrollView setBackgroundColor:UIColorFromRGB(kBackgroundGreyColor)];
    [self.view addSubview:self.scrollView];
    self.scrollView.delegate = self;
    [self.scrollView setShowsVerticalScrollIndicator:NO];
    [self.scrollView setParallaxHeaderView:headerView mode:VGParallaxHeaderModeFill height:RelativeSizeHeight(kParallaxHeaderHeight, 667)];
    [self.scrollView setContentSize:CGSizeMake(self.view.bounds.size.width, 200)];
    
    brandDetailContainerView = [[UIView alloc] init];
    [brandDetailContainerView setBackgroundColor:[UIColor whiteColor]];
//    [self.scrollView addSubview:brandDetailContainerView];
}

-(void)setupHeader{
    
    headerView = [[UIImageView alloc] init];
    [headerView setBackgroundColor:UIColorFromRGB(kBackgroundGreyColor)];
    [headerView setContentMode:UIViewContentModeScaleAspectFill];
}

-(void)setupBrandDetails{

    UIImage *img = [UIImage imageNamed:@"ArcImage"];
    arcImage = [[UIImageView alloc] init];
    CGFloat height = img.size.height * self.scrollView.frame.size.width/img.size.width;
    [arcImage setFrame:CGRectMake(0, -height, self.scrollView.frame.size.width, height)];
    [arcImage setImage:img];
    [brandDetailContainerView addSubview:arcImage];
    
    brandLogoImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kLogoWidth, kLogoWidth)];
    [brandLogoImage setCenter:CGPointMake(arcImage.center.x, arcImage.center.y)];
    [brandLogoImage setBackgroundColor:[UIColor clearColor]];
    
    brandLogoImage.layer.cornerRadius = 3.0f;
    brandLogoImage.layer.borderWidth =1.0f;
    brandLogoImage.layer.borderColor = UIColorFromRGB(0xD0D0D0).CGColor;
    brandLogoImage.clipsToBounds = TRUE;
    
    [brandDetailContainerView addSubview:brandLogoImage];
    
    NSString *brandNameString = @"PUMA";
    brandName = [[UILabel alloc] init];
    [brandName setFont:[UIFont fontWithName:kMontserrat_Regular size:14.0]];
    [brandName setBackgroundColor:[UIColor clearColor]];
    [brandName setTextColor:UIColorFromRGB(kDarkPurpleColor)];
    CGSize nameSize = [SSUtility getLabelDynamicSize:brandNameString withFont:brandName.font withSize:CGSizeMake(self.scrollView.frame.size.width, MAXFLOAT)];
    [brandName setFrame:CGRectMake(0, 0, nameSize.width, nameSize.height)];
    [brandName setCenter:CGPointMake(self.scrollView.frame.size.width/2, brandLogoImage.frame.origin.y + brandLogoImage.frame.size.height + nameSize.height/2 + 7)];
    [brandName setTextAlignment:NSTextAlignmentCenter];
    [brandDetailContainerView addSubview:brandName];
    
    NSString *nearestStoreString = @"Nearest Store 3KM";
    nearestStoreLabel = [[UILabel alloc] init];
    [nearestStoreLabel setFont:[UIFont fontWithName:kMontserrat_Light size:12.0]];
    [nearestStoreLabel setBackgroundColor:[UIColor clearColor]];
    [nearestStoreLabel setTextColor:UIColorFromRGB(kDarkPurpleColor)];
    CGSize nearestStoreSize = [SSUtility getLabelDynamicSize:nearestStoreString withFont:nearestStoreLabel.font withSize:CGSizeMake(self.scrollView.frame.size.width, MAXFLOAT)];
    [nearestStoreLabel setFrame:CGRectMake(0, 0, nearestStoreSize.width, nearestStoreSize.height)];
    [nearestStoreLabel setCenter:CGPointMake(self.scrollView.frame.size.width/2, brandName.frame.origin.y + brandName.frame.size.height + nearestStoreSize.height/2 + 5)];
    [brandDetailContainerView addSubview:nearestStoreLabel];
    
    followButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, RelativeSize(110, 320), RelativeSizeHeight(kFollowBtnHeight, 480))];

    
    if(!brandModel.is_following){
        followButtonText = [[NSAttributedString alloc] initWithString : @"FOLLOW"
                                                           attributes : @{
                                                                          NSFontAttributeName : [UIFont fontWithName:kMontserrat_Bold size:14.0],
                                                                          NSForegroundColorAttributeName :[UIColor whiteColor]
                                                                          }];
        [followButton setBackgroundColor:UIColorFromRGB(kTurquoiseColor)];
        
    }else {
        followButtonText = [[NSAttributedString alloc] initWithString : @"FOLLOWING"
                                                           attributes : @{
                                                                          NSFontAttributeName : [UIFont fontWithName:kMontserrat_Light size:12.0],
                                                                          NSForegroundColorAttributeName :UIColorFromRGB(kTurquoiseColor)
                                                                          }];
        [followButton setBackgroundColor:[UIColor clearColor]];
        followButton.layer.cornerRadius = 3.0f;
        followButton.layer.borderColor = UIColorFromRGB(kTurquoiseColor).CGColor;
        followButton.layer.borderWidth = 1.0f;
    }

    [followButton setAttributedTitle:followButtonText forState:UIControlStateNormal];
    [followButton addTarget:self action:@selector(toggleFollow) forControlEvents:UIControlEventTouchUpInside];
    [brandDetailContainerView addSubview:followButton];
    [followButton.layer setCornerRadius:2.0];
    [followButton setCenter:CGPointMake(self.scrollView.frame.size.width/2, nearestStoreLabel.frame.origin.y + nearestStoreLabel.frame.size.height + followButton.frame.size.height/2 + 8 )];
    [followButton setHidden:true];
    
    
    NSMutableAttributedString *storesText1 = [[NSMutableAttributedString alloc] initWithString:@"12" attributes:@{NSFontAttributeName : [UIFont fontWithName:kMontserrat_Light size:12.0f], NSForegroundColorAttributeName : UIColorFromRGB(kDarkPurpleColor)}];
    NSMutableAttributedString *storesText2 = [[NSMutableAttributedString alloc] initWithString:@" Stores" attributes:@{NSFontAttributeName : [UIFont fontWithName:kMontserrat_Light size:12.0f],NSForegroundColorAttributeName : UIColorFromRGB(kDarkPurpleColor)}];
    
    [storesText1 appendAttributedString:storesText2];
    
    CGRect storeFrame = [storesText1 boundingRectWithSize:CGSizeMake((0 + followButton.frame.origin.x), MAXFLOAT) options:NSStringDrawingTruncatesLastVisibleLine context:nil];
    numberOfStoresLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, storeFrame.size.width, storeFrame.size.height)];
    [numberOfStoresLabel setBackgroundColor:[UIColor clearColor]];
    [numberOfStoresLabel setCenter:CGPointMake((0 + followButton.frame.origin.x)/2, followButton.center.y)];
    [brandDetailContainerView addSubview:numberOfStoresLabel];
    
    
    followersText1 = [[NSMutableAttributedString alloc] initWithString:@"54" attributes:@{NSFontAttributeName : [UIFont fontWithName:kMontserrat_Bold size:12.0],
                                                                                                                  NSForegroundColorAttributeName : [UIColor blackColor]}];
    followersText2 = [[NSMutableAttributedString alloc] initWithString:@" Followers" attributes:@{NSFontAttributeName : [UIFont fontWithName:kMontserrat_Light size:12.0],
                                                                                                                       NSForegroundColorAttributeName : [UIColor blackColor]}];
    
    [followersText1 appendAttributedString:followersText2];
    followerFrame = [followersText1 boundingRectWithSize:CGSizeMake((0 + followButton.frame.origin.x), MAXFLOAT) options:NSStringDrawingTruncatesLastVisibleLine context:nil];
    numberOfFollowersButton = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, followerFrame.size.width, followerFrame.size.height)];
    [numberOfFollowersButton setBackgroundColor:[UIColor clearColor]];
    [numberOfFollowersButton setCenter:CGPointMake((self.scrollView.frame.size.width + followButton.frame.origin.x + followButton.frame.size.width)/2, followButton.center.y)];
    [brandDetailContainerView addSubview:numberOfFollowersButton];
}

-(void)setupSortFilterButtons{
    [self setupButtonsContainer];
    [self addButtons];
    [brandDetailContainerView setFrame:CGRectMake(0, 0, self.scrollView.frame.size.width, buttonsContainer.frame.origin.y + buttonsContainer.frame.size.height)];
}

-(void)setupButtonsContainer{
    buttonsContainer = [[UIView alloc] initWithFrame:CGRectMake(0, followButton.frame.origin.y + followButton.frame.size.height + 10, self.scrollView.frame.size.width, 45)];
    buttonsContainer.backgroundColor = [UIColor whiteColor];
//    [self.scrollView addSubview:buttonsContainer];
    
    CALayer *topBorder = [CALayer layer];
    topBorder.frame = CGRectMake(6, 0, buttonsContainer.frame.size.width - 12, 1);
    topBorder.backgroundColor = UIColorFromRGB(0xD0D0D0).CGColor;
    [buttonsContainer.layer addSublayer:topBorder];
    
    CALayer *dividerLayer = [CALayer layer];
    dividerLayer.frame = CGRectMake(0, 5, 1, buttonsContainer.frame.size.height - 12);
    dividerLayer.backgroundColor = UIColorFromRGB(0xD0D0D0).CGColor;
    dividerLayer.position = (CGPoint){CGRectGetMidX(buttonsContainer.layer.bounds), CGRectGetMidY(buttonsContainer.layer.bounds)};
    [buttonsContainer.layer addSublayer:dividerLayer];
    buttonContainerOriginalFrame = buttonsContainer.frame;
}

-(void)addButtons{
    NSAttributedString *sortString = [[NSAttributedString alloc] initWithString:@"SORT" attributes:@{NSFontAttributeName : [UIFont fontWithName:kMontserrat_Light size:14.0], NSForegroundColorAttributeName : [UIColor blackColor]}];
    CGRect sortRect = [sortString boundingRectWithSize:CGSizeMake(buttonsContainer.frame.size.width/2, buttonsContainer.frame.size.height) options:NSStringDrawingTruncatesLastVisibleLine context:NULL];
    
    NSAttributedString *filterString = [[NSAttributedString alloc] initWithString:@"FILTER" attributes:@{NSFontAttributeName : [UIFont fontWithName:kMontserrat_Light size:14.0], NSForegroundColorAttributeName : [UIColor blackColor]}];
    CGRect filterRect = [filterString boundingRectWithSize:CGSizeMake(buttonsContainer.frame.size.width/2, buttonsContainer.frame.size.height) options:NSStringDrawingTruncatesLastVisibleLine context:NULL];
    sortButtonContainer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, buttonsContainer.frame.size.width/2, buttonsContainer.frame.size.height)];
    [sortButtonContainer setCenter:CGPointMake(buttonsContainer.frame.size.width/4, buttonsContainer.frame.size.height/2)];
    [buttonsContainer addSubview:sortButtonContainer];
    
    UIButton *sortButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, sortButtonContainer.frame.size.width + 4, sortButtonContainer.frame.size.height)];
    [sortButton setBackgroundImage:[SSUtility imageWithColor:[UIColor clearColor]] forState:UIControlStateNormal];
    [sortButton setBackgroundImage:[SSUtility imageWithColor:UIColorFromRGB(0xF4F4F4)] forState:UIControlStateHighlighted];
    [sortButton addTarget:self action:@selector(showSortByView) forControlEvents:UIControlEventTouchUpInside];
    [sortButtonContainer addSubview:sortButton];

    sortLabel = [[UILabel alloc] initWithFrame:CGRectMake(1, 1, sortRect.size.width, sortRect.size.height - 2)];
    [sortLabel setCenter:CGPointMake(sortButtonContainer.frame.size.width/2, sortButtonContainer.frame.size.height/2)];
    [sortLabel setBackgroundColor:[UIColor clearColor]];
    [sortLabel setAttributedText:sortString];
    [sortButtonContainer addSubview:sortLabel];
    
    UIImage *sortImage = [UIImage imageNamed:@"SortHeader"];
//    sortIcon = [[UIImageView alloc] initWithFrame:CGRectMake(sortLabel.frame.origin.x - 30, 0, 32, 32)];
    sortIcon = [[UIImageView alloc] initWithFrame:CGRectMake(sortLabel.frame.origin.x - sortImage.size.width - 3, 0, sortImage.size.width, sortImage.size.height)];
    [sortIcon setImage:sortImage];
    [sortIcon setCenter:CGPointMake(sortIcon.center.x, sortButtonContainer.frame.size.height/2)];
    [sortButtonContainer addSubview:sortIcon];
    
    filterButtonContainer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, buttonsContainer.frame.size.width/2, buttonsContainer.frame.size.height)];
    [filterButtonContainer setCenter:CGPointMake(buttonsContainer.frame.size.width/2 + buttonsContainer.frame.size.width/4, buttonsContainer.frame.size.height/2)];
    [buttonsContainer addSubview:filterButtonContainer];

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
    
    [buttonsContainer setUserInteractionEnabled:FALSE];
    [sortLabel setAlpha:0.4];
    [filterLabel setAlpha:0.4];
}

-(void)addActivityIndicators{
    brandDetailActivityIndicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(brandDetailContainerView.frame.size.width/2 - 20, brandDetailContainerView.frame.size.height/2 - 20, 40, 40)];
    [brandDetailActivityIndicator setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];
    [brandDetailContainerView addSubview:brandDetailActivityIndicator];
    [brandDetailActivityIndicator startAnimating];
}

-(void)showSortByView{
    
    if(!sortView){
        sortView = [[SortViewController alloc] initSortByArray:[brandDataDictionary objectForKey:@"sort_on"]];
        sortView.delegate = self;
        sortNav = [[UINavigationController alloc] initWithRootViewController:sortView];
    }
    [self presentViewController:sortNav animated:YES completion:nil];
}


#pragma mark - SortDelegate

-(void)sortDismissed{
    if(sortView){
        sortNav = nil;
        sortView = nil;
    }
}

-(void)sortSelected:(NSString *)string{
    sortParam = string;
    [self getFilteredDataWithAppliedFilters:filterArray];
}

-(void)showFilterView{
    
    if(filterView){
        filterView.filterDelegate = self;
        filterView = nil;
    }
    defaultFilters = [[NSArray alloc] initWithArray:[brandDataDictionary objectForKey:@"filters"]];
    filterView = [[FilterViewController alloc] initWithDataArray:defaultFilters];
    filterView.filterDelegate = self;
    filterNav = [[UINavigationController alloc] initWithRootViewController:filterView];
    [self.navigationController presentViewController:filterNav animated:YES completion:nil];
}


#pragma mark  - filterView delegates
-(void)resetFilters{
    filterArray = nil;
    if(applyFilterLoader){
        [applyFilterLoader stopAnimating];
        [applyFilterLoader removeFromSuperview];
        applyFilterLoader = nil;
    }
    applyFilterLoader = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(moreProductsContainer.frame.size.width/2 - 20, moreProductsContainer.frame.origin.y + 20, 40, 40)];
    [applyFilterLoader setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];
    [self.scrollView addSubview:applyFilterLoader];
    [applyFilterLoader startAnimating];
    [moreProductsContainer setHidden:true];
    [self getFilterResetData];
}

-(void)getFilterResetData{
    
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


//    [SSUtility showActivityOverlay:self.scrollView];
    [self.view addSubview:browseByBrandLoader];
    [browseByBrandLoader startAnimating];
    
    [self.browseByBrandRequestHandler fetchBrowseByBrandDataWithArray:paramArray fromURL:brandURL withRequestCompletionhandler:^(id responseData, NSError *error) {
        brandDataDictionary = responseData;
        brandModel.moreProducts = [SSUtility parseJSON:[brandDataDictionary objectForKey:@"items"] forGridView:moreProductsList];
        hasNext = [[[brandDataDictionary objectForKey:@"page"] objectForKey:@"has_next"] boolValue];
        if(!hasNext){
            moreProductsList.shouldHideLoaderSection = YES;
        }else{
            moreProductsList.shouldHideLoaderSection = NO;
        }
        moreProductsList.parsedDataArray = brandModel.moreProducts;
        
        fetching = false;
        
        dispatch_async(dispatch_get_main_queue(), ^(void){
//            [SSUtility dismissActivityOverlay];
            [browseByBrandLoader stopAnimating];
            [browseByBrandLoader removeFromSuperview];
            
            [moreProductsHeaderLabel setFrame:CGRectMake(moreProductsHeaderLabel.frame.origin.x, moreProductsHeaderLabel.frame.origin.y, moreProductsHeaderLabel.frame.size.width, 0)];
//            [moreProductsList.collectionView reloadData];
            [moreProductsList reloadCollectionView];
            [filterView updateFilterViewWithNewData:[brandDataDictionary objectForKey:@"filters"]];
            
            [applyFilterLoader stopAnimating];
            [applyFilterLoader removeFromSuperview];
            [moreProductsContainer setHidden:FALSE];
        });
    }];
}

-(void)refreshFiltersWith:(NSArray *)appliedFilters{
    if(applyFilterLoader){
        [applyFilterLoader stopAnimating];
        [applyFilterLoader removeFromSuperview];
        applyFilterLoader = nil;
    }
    applyFilterLoader = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(moreProductsContainer.frame.size.width/2 - 20, moreProductsContainer.frame.origin.y + 20, 40, 40)];
    [applyFilterLoader setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];
    [self.scrollView addSubview:applyFilterLoader];
    [applyFilterLoader startAnimating];
    [moreProductsContainer setHidden:true];
    
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
    
    filterArray = array;
    paramArray = [[NSMutableArray alloc] init];
    
    paramDictionary = [defaultParamDictionary mutableCopy];
    [paramDictionary setObject:sortParam forKey:@"sort_on"];
    
//    //remove gender from default if gender filter applied
//    for(int i = 0; i < [filterArray count]; i++){
//        if([[[[[filterArray objectAtIndex:i] allKeys] objectAtIndex:0] lowercaseString] isEqualToString:@"gender"]){
//            if(paramDictionary[@"gender"]){
//                [paramDictionary removeObjectForKey:@"gender"];
//                break;
//            }
//        }
//    }
    
    //copy default params to paramArray
//    NSArray *paramKeys = [paramDictionary allKeys];
//    for(int i = 0; i < [paramKeys count]; i++){
//        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
//        [dict setObject:[paramDictionary objectForKey:[paramKeys objectAtIndex:i]] forKey:[paramKeys objectAtIndex:i]];
//        [paramArray addObject:dict];
//    }
    [paramArray addObjectsFromArray:defaultParamDictionaryArray];
    [paramArray addObject:[[NSDictionary alloc] initWithObjectsAndKeys:sortParam, @"sort_on", nil]];

    
    //remove gender from default if gender filter applied
    for(int i = 0; i < [filterArray count]; i++){
        if([[[[[filterArray objectAtIndex:i] allKeys] objectAtIndex:0] lowercaseString] isEqualToString:@"gender"]){
            for(int j = 0; j < [paramArray count]; j++){
                NSDictionary *temp = [paramArray objectAtIndex:j];
                if([[[[temp allKeys] objectAtIndex:0] lowercaseString] isEqualToString:@"gender"]){
                    [paramArray removeObjectAtIndex:j];
                    break;
                }
            }
        }
    }
    
    //copy filter params to paramArray
    for(int i = 0; i < [filterArray count]; i++){
        [paramArray addObject:[filterArray objectAtIndex:i]];
    }
    pages = 1;

    [self.view addSubview:browseByBrandLoader];
    [browseByBrandLoader startAnimating];
    
    [self.browseByBrandRequestHandler fetchBrowseByBrandDataWithArray:paramArray fromURL:brandURL withRequestCompletionhandler:^(id responseData, NSError *error) {
        brandDataDictionary = responseData;
        brandModel.moreProducts = [SSUtility parseJSON:[brandDataDictionary objectForKey:@"items"] forGridView:moreProductsList];
        hasNext = [[[brandDataDictionary objectForKey:@"page"] objectForKey:@"has_next"] boolValue];
        if(!hasNext){
            moreProductsList.shouldHideLoaderSection = YES;
        }else{
            moreProductsList.shouldHideLoaderSection = NO;
        }
        moreProductsList.parsedDataArray = brandModel.moreProducts;
        
        fetching = false;
        
        dispatch_async(dispatch_get_main_queue(), ^(void){
            
//            [SSUtility dismissActivityOverlay];
            [browseByBrandLoader stopAnimating];
            [browseByBrandLoader removeFromSuperview];
            
            [moreProductsHeaderLabel setFrame:CGRectMake(moreProductsHeaderLabel.frame.origin.x, moreProductsHeaderLabel.frame.origin.y, moreProductsHeaderLabel.frame.size.width, 0)];
//            [moreProductsList.collectionView reloadData];
            [moreProductsList reloadCollectionView];
            [filterView updateFilterViewWithNewData:[brandDataDictionary objectForKey:@"filters"]];
            
            [applyFilterLoader stopAnimating];
            [applyFilterLoader removeFromSuperview];
            [moreProductsContainer setHidden:FALSE];
        });
    }];
}




#pragma marks - scroll view delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if(scrollView.contentOffset.y + 44>= buttonContainerOriginalFrame.origin.y){
        [buttonsContainer setFrame:CGRectMake(buttonsContainer.frame.origin.x, scrollView.contentOffset.y + 44, buttonsContainer.frame.size.width, buttonsContainer.frame.size.height)];
        [buttonsContainer setAlpha:0.9];
        [self.scrollView bringSubviewToFront:buttonsContainer];
    }else{
        [buttonsContainer setAlpha:1.0];
        [buttonsContainer setFrame:CGRectMake(buttonsContainer.frame.origin.x, buttonContainerOriginalFrame.origin.y, buttonsContainer.frame.size.width, buttonsContainer.frame.size.height)];
    }
    [self.scrollView shouldPositionParallaxHeader];

    if (scrollView.contentOffset.y<=0) {
        self.title = @"";
        isNavBarVisible = false;
        [self.navigationController.navigationBar setBackgroundColor:[UIColor clearColor]];
        if([backButtonImageName isEqualToString:kBackButtonImage]){
            self.navigationItem.leftBarButtonItem = nil;
            backButtonImageName = kBackButtonImageWhite;
            [self setBackButton:backButtonImageName];
        }
        if (![self.tabBarController.tabBar isHidden]) {
            [self.tabBarController.tabBar setHidden:TRUE];
        }
//        CGRect tabFrame = self.tabBarController.tabBar.frame;
//        tabFrame.origin.y = kDeviceHeight + tabFrame.size.height;
//        [UIView animateWithDuration:0.4 animations:^{
//            [self.tabBarController.tabBar setFrame:tabFrame];
//        }];
        
        
    }else {
        isNavBarVisible = true;
        self.title = brandModel.name;
        [self.navigationController.navigationBar setBackgroundColor:[UIColor whiteColor]];
        if([backButtonImageName isEqualToString:kBackButtonImageWhite]){
            self.navigationItem.leftBarButtonItem = nil;
            backButtonImageName = kBackButtonImage;
            [self setBackButton:backButtonImageName];
        }
        [self manageBarsWithScroll:scrollView forGridView:nil];
    }
    
    if(fetching)
        return;
    
    if(scrollView.contentOffset.y + scrollView.frame.size.height >= scrollView.contentSize.height - 100 && scrollView.contentOffset.y > 0 && hasNext){
        fetching = true;
        
        if(paramArray){
            for(int i = 0; i < [paramArray count]; i++){
                if([[[[paramArray objectAtIndex:i] allKeys] objectAtIndex:0] isEqualToString:@"page"]){
                    [paramArray removeObjectAtIndex:i];
                    break;
                }
            }
        }
        
        NSInteger prevLastIndex = [moreProductsList.parsedDataArray count] - 1;
        __block NSInteger newLastIndex = 0;
        
//        [paramDictionary setObject:[NSString stringWithFormat:@"%d", ++pages] forKey:@"page"];
        [paramArray addObject:[NSDictionary dictionaryWithObject:[NSString stringWithFormat:@"%d", ++pages] forKey:@"page"]];
        [self.browseByBrandRequestHandler fetchBrowseByBrandDataWithArray:paramArray fromURL:brandURL withRequestCompletionhandler:^(id responseData, NSError *error) {

            NSDictionary *json = responseData;
            
            [brandModel.moreProducts addObjectsFromArray:[SSUtility parseJSON:[json objectForKey:@"items"] forGridView:moreProductsList]];
            moreProductsList.parsedDataArray = brandModel.moreProducts;
            hasNext = [[[json objectForKey:@"page"] objectForKey:@"has_next"] boolValue];
            if(!hasNext){
                moreProductsList.shouldHideLoaderSection = YES;
            }else{
                moreProductsList.shouldHideLoaderSection = NO;
            }
            newLastIndex = [moreProductsList.parsedDataArray count] - 1;
            
            NSMutableArray *indexSetArray = [[NSMutableArray alloc] initWithCapacity:0];
            for(int i = 0; i < newLastIndex - prevLastIndex; i++){
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i+prevLastIndex +1 inSection:0];
                [indexSetArray addObject:indexPath];
            }
            dispatch_async(dispatch_get_main_queue(), ^(void){
                fetching = false;
                
                [moreProductsList reloadCollectionView:indexSetArray];
            });
        }];
    }
}


-(void)toggleFollow{
    
    if(followTimer){
        [followTimer invalidate];
        followTimer = nil;
    }
    followTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(hitFollow) userInfo:nil repeats:NO];
    brandModel.is_following = !brandModel.is_following;
    

    if(!brandModel.is_following){
//        [FyndAnalytics trackBrandFollow:@"brand_browse" brandName:brandModel.name isUnFollowed:YES];
        followButtonText = [[NSAttributedString alloc] initWithString : @"FOLLOW"
                                                           attributes : @{
                                                                          NSFontAttributeName : [UIFont fontWithName:kMontserrat_Bold size:14.0],
                                                                          NSForegroundColorAttributeName : [UIColor whiteColor]
                                                                          }];
        [followButton setBackgroundColor:UIColorFromRGB(kTurquoiseColor)];
        
    }else {
//        [FyndAnalytics trackBrandFollow:@"brand_browse" brandName:brandModel.name isUnFollowed:NO];
        followButtonText = [[NSAttributedString alloc] initWithString : @"FOLLOWING"
                                                           attributes : @{
                                                                          NSFontAttributeName : [UIFont fontWithName:kMontserrat_Light size:12.0],
                                                                          NSForegroundColorAttributeName :UIColorFromRGB(kTurquoiseColor)
                                                                          }];
        [followButton setBackgroundColor:[UIColor clearColor]];
        followButton.layer.cornerRadius = 3.0f;
        followButton.layer.borderColor = UIColorFromRGB(kTurquoiseColor).CGColor;
        followButton.layer.borderWidth = 1.0f;
    }
    [followButton setAttributedTitle:followButtonText forState:UIControlStateNormal];
}


-(void)hitFollow{
    
    if(!brandModel.is_following ){
        [self.browseByBrandRequestHandler unfollowBrand:brandModel.brandID withRequestCompletionhandler:^(id responseData, NSError *error) {
            if(!error){
                
                [self setFollowersCount:responseData];
                
                [FyndAnalytics trackBrandFollow:@"brand_browse" brandName:brandModel.name isUnFollowed:YES];
            }
        }];
    }else{
        [self.browseByBrandRequestHandler followBrand:brandModel.brandID withRequestCompletionhandler:^(id responseData, NSError *error) {
            if(!error){
                [self setFollowersCount:responseData];
                
                [FyndAnalytics trackBrandFollow:@"brand_browse" brandName:brandModel.name isUnFollowed:NO];
            }
        }];
    }
}

-(void)setFollowersCount:(id)response{
    
    if ([response objectForKey:@"counts"]) {
        NSArray *countArray = [response valueForKey:@"counts"];
        if ([countArray count]>0) {
            NSDictionary *countDic = [countArray objectAtIndex:0];
            if ([countDic objectForKey:@"count"]) {
                brandModel.follower_count = [[countDic objectForKey:@"count"] integerValue];
                followersText1 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%ld", (long)brandModel.follower_count] attributes:@{NSFontAttributeName : [UIFont fontWithName:kMontserrat_Light size:12.0f], NSForegroundColorAttributeName : UIColorFromRGB(kDarkPurpleColor)}];
                followersText2 = [[NSMutableAttributedString alloc] initWithString:(brandModel.follower_count == 1 ? @" Follower" : @" Followers") attributes:@{NSFontAttributeName : [UIFont fontWithName:kMontserrat_Light size:12.0f], NSForegroundColorAttributeName : UIColorFromRGB(kDarkPurpleColor)}];
                [followersText1 appendAttributedString:followersText2];
                followerFrame = [followersText1 boundingRectWithSize:CGSizeMake((0 + followButton.frame.origin.x), MAXFLOAT) options:NSStringDrawingTruncatesLastVisibleLine context:nil];
                [numberOfFollowersButton setFrame:CGRectMake(0, 0, followerFrame.size.width, followerFrame.size.height)];
                [numberOfFollowersButton setAttributedText:followersText1];
                [numberOfFollowersButton setCenter:CGPointMake((self.scrollView.frame.size.width + followButton.frame.origin.x + followButton.frame.size.width)/2, followButton.center.y)];
            }
        }
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


- (void)showPDPScreen:(NSString *)url{
    if(self.pdpController){
        self.pdpController = nil;
    }
    self.pdpController = [[PDPViewController alloc] init];
    self.pdpController.productURL = url;
    [self.navigationController pushViewController:self.pdpController animated:YES];
}

#pragma mark - Manage the Tab Bar


-(void)manageBarsWithScroll:(UIScrollView *)scrollView forGridView:(GridView *)theGrdidView{
    
    if([[[UIDevice currentDevice] systemVersion] floatValue] < 7.0f){
        return;
    }
    
    CGRect tabBarFrame = self.tabBarController.tabBar.frame;
    CGFloat tabHeight = tabBarFrame.size.height;
    
    if(scrollView.contentOffset.y > 0){
        CGFloat yVelocity = [scrollView.panGestureRecognizer velocityInView:scrollView].y;
        
        if (yVelocity<0) {
            //Hide the Bar
            tabBarFrame.origin.y = kDeviceHeight + tabHeight;
        }else if(yVelocity>0){
            //Show Bar
            tabBarFrame.origin.y = kDeviceHeight - tabHeight;
            if ([self.tabBarController.tabBar isHidden]) {
                [self.tabBarController.tabBar setHidden:FALSE];
            }

        }
    }
    if(!isScrolling){
            isScrolling = TRUE;
                [UIView animateWithDuration:0.4 animations:^{
                    [self.tabBarController.tabBar setFrame:tabBarFrame];
                    
                } completion:^(BOOL finished) {
                    isScrolling = FALSE;
                }];
    }
}


-(void)resetBars{
    
    //Resetting the tab bar data
    CGRect tabFrame = self.tabBarController.tabBar.frame;
    tabFrame.origin.y = kDeviceHeight - tabFrame.size.height;
    [self.tabBarController.tabBar setFrame:tabFrame];
    [self.tabBarController.tabBar setHidden:FALSE];
}

-(void)dealloc{
    if(isParsedDataArrayOBserverAdded){
        @try {
            [self removeObserver:self forKeyPath:@"moreProductsList.parsedDataArray"];
            isParsedDataArrayOBserverAdded = FALSE;
        }
        @catch (NSException *exception) {
        }
    }
    
    if(isHeaderLabelObserverAdded){
        @try {
            [self removeObserver:self forKeyPath:@"moreProductsHeaderLabel.frame"];
            isHeaderLabelObserverAdded = FALSE;
        }
        @catch (NSException *exception) {
        }
    }
    
    if(isCollectionContentSizeObserverAdded){
        @try {
            [self removeObserver:self forKeyPath:@"moreProductsList.collectionView.contentSize"];
            isCollectionContentSizeObserverAdded = FALSE;
        }
        @catch (NSException *exception) {
        }
    }
}

@end
