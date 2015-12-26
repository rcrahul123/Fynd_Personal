//
//  PDPViewController.m
//  Explore
//
//  Created by Rahul Chaudhari on 25/07/15.
//  Copyright (c) 2015 Rahul. All rights reserved.
//

#import "PDPViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "PDPHandler.h"
#import "PDPFeedBackViewController.h"
#import "CartRequestHandler.h"
#import "CartViewController.h"

#import "FyndAnalytics.h"
#import "PDPSizeGuideViewController.h"
#import "FyndErrorInfoView.h"


const int numberOfSharedItems = 5;

@interface PDPViewController () <PopOverlayHandlerDelegate>{
    UIBarButtonItem *wishListBarItem;
    CGRect          fixedFrame;
    BOOL hideBars;
    BOOL isScrolling;
   
}
@property(nonatomic,strong) UIView *fixedView;
@property (nonatomic,strong) PDPHandler *pdpHandler;
@property (nonatomic,strong) UIView     *addCartInfoView;
@property (nonatomic,assign) BOOL       floatingStarted;
@property (nonatomic,strong) FyndErrorInfoView *fyndErrorView;

- (void)addItemCartService:(NSMutableArray *)sizeData;
//- (void)generateAddCartInforView;
@end

@implementation PDPViewController
CGPoint endPoint2;
- (void)viewDidLoad {
    [super viewDidLoad];

    [self.navigationController.navigationBar setFont:[UIFont fontWithName:kMontserrat_Regular size:16.0f] withColor:UIColorFromRGB(kDarkPurpleColor)];

    pdpLoader = [[FyndActivityIndicator alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    [pdpLoader setCenter:CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height/2)];
    
    self.navigationController.navigationBar.topItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
//    headerHeight = self.view.frame.size.height * .80; //RelativeSizeHeight(385, 480);
//    headerHeight = self.view.frame.size.height - (80+64)+20;
    headerHeight = self.view.frame.size.height - (80+64) + 15;


    [self.view setBackgroundColor:UIColorFromRGB(kBackgroundGreyColor)];
    
    [self fetchProductDetails];
    [self setBackButton];
}
-(void)setBackButton{
    UIImage *backButtonImage = [[UIImage imageNamed:kBackButtonImage] imageWithAlignmentRectInsets:UIEdgeInsetsMake(0, kBackButtonImageInset, 0, 0)];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:backButtonImage style:UIBarButtonItemStyleBordered target:self action:@selector(backAction:)];
}
-(void)backAction:(id)sender{
    [self.navigationController popViewControllerAnimated:TRUE];
}


-(BOOL)prefersStatusBarHidden{
    return YES;
}

-(BOOL)hidesBottomBarWhenPushed{
    return YES;
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
//    [self fetchProductDetails];
    detailView.isItemAddedIntoCart = FALSE;
//    [detailView updateAddToCartButton];
    
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:TRUE];
//    [detailView updateAddToCartButton];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.navigationController.navigationBar changeNavigationBarToTransparent:TRUE];
    [self.navigationController.navigationBar setFrame:CGRectMake(0, 0, self.navigationController.navigationBar.frame.size.width, self.navigationController.navigationBar.frame.size.height)];
    [self.tabBarController.tabBar setHidden:TRUE];

    
}

- (void)fetchProductDetails{
    [self.view addSubview:pdpLoader];
    [pdpLoader startAnimating];
    if(self.pdpHandler == nil){
        self.pdpHandler = [[PDPHandler alloc] init];
    }

    NSDictionary *dict = [NSDictionary  dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%@",self.productURL],@"PDPURL", nil];
    [self.pdpHandler fetchProductDetails:dict withCompletionHandler:^(id responseData, NSError *error) {
        
        if(!error){
            [self parsePDPResponse:responseData];
            
            dispatch_async(dispatch_get_main_queue(), ^(void){
                [pdpActivityIndicator stopAnimating];
                [pdpActivityIndicator removeFromSuperview];
            
                if(self.productDiscription.isTryAtHomeAvailable){
                    [self fetchFyndFitSize];
                }else{
                    [self genaratePDPScreen];
                }
            });
        }else{
            self.fyndErrorView = [[FyndErrorInfoView alloc] initWithFrame:CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y-50, self.view.frame.size.width, 50)];
            [self.fyndErrorView showErrorView:[error.userInfo objectForKey:@"message"] withRect:self.view.frame];
            __weak PDPViewController *homeContrl = self;
            self.fyndErrorView.errorAnimationBlock = ^(){
                if(homeContrl.fyndErrorView){
                    [homeContrl.fyndErrorView removeFromSuperview];
                    homeContrl.fyndErrorView = nil;
                }
            };
        }

    }];
}


- (void)fetchFyndFitSize{
    if(self.pdpHandler == nil){
        self.pdpHandler = [[PDPHandler alloc] init];
    }
    NSDictionary *dict = [NSDictionary  dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%@",self.productDiscription.productID],@"product_id", nil];
    [self.pdpHandler getFyndAFitSize:dict withCompletionHandler:^(id responseData, NSError *error) {
        
     self.productDiscription.convenienceFee =  [responseData objectForKey:@"convenience_fee"];
     self.productDiscription.fyndAFitDictonary = [[NSMutableDictionary alloc] initWithCapacity:0];
       NSArray *sizes =  [responseData objectForKey:@"size_options"];
        for(NSInteger counter=0; counter < [sizes count]; counter++){
            NSDictionary *dict = [sizes objectAtIndex:counter];
            NSArray *possibleSize = [dict objectForKey:@"possible_sizes"];
            NSMutableArray *associatedSizeArray = nil;
            if(possibleSize && [possibleSize count]>0){
                associatedSizeArray = [[NSMutableArray alloc] initWithCapacity:0];
                
                for(NSInteger sizeCounter=0; sizeCounter < [possibleSize count]; sizeCounter++){
                    NSDictionary *currentSize = [possibleSize objectAtIndex:sizeCounter];
                    ProductSize *size = [[ProductSize alloc] initWithDictionary:currentSize];
                    [associatedSizeArray addObject:size];
                }
                [self.productDiscription.fyndAFitDictonary setObject:associatedSizeArray forKey:[dict objectForKey:@"size"]];
            }
            
        }
        [self genaratePDPScreen];
    }];
}



- (void)parsePDPResponse:(NSDictionary *)dict{
    self.productDiscription = [[PDPModel alloc] initWithDictionary:dict];
    self.productDiscription.productID = [SSUtility getValueForParam:kProductID from:self.productURL];
    int arr = (int)[[self.navigationController viewControllers] count];
    if (arr>=2) {
        UIViewController *theParentViewController = [[self.navigationController viewControllers] objectAtIndex:arr-2];
        
        NSString *source = [self getSourceName:theParentViewController];
        if([source isEqualToString:@"search"]){
            if(!self.isFromSearch){
                source = @"category";
            }
        }
        [FyndAnalytics trackPDPWith:source forItem:self.productDiscription.productID andBrand:self.productDiscription.brandName andCategory:self.productDiscription.parentCategoryID andSubCategory:self.productDiscription.childCategoryID];
    }
}

-(NSString *)getSourceName : (UIResponder *)responder{
    NSString *source;
    NSString *className = NSStringFromClass([(UIViewController *)responder class]);
    
    if([className isEqualToString:@"FeedViewController"]){
        source = @"feed";
        
    }else if ([className isEqualToString:@"BrandsVIewController"]){
        source = @"brand";
        
    }else if ([className isEqualToString:@"BrowseByBrandViewController"]){
        source = @"brand_browse";
        
    }else if([className isEqualToString:@"CollectionsViewController"]){
        source = @"collection";
        
    }else if([className isEqualToString:@"BrowseByCollectionViewController"]){
        source = @"collection_browse";
        
    }else if ([className isEqualToString:@"PDPViewController"]){
        source = @"more_products";
        
    }else if ([className isEqualToString:@"ProfileViewController"] || [className isEqualToString:@"AddFromWishlistViewController"]){
        source = @"wishlist";
        
    }else if ([className isEqualToString:@"PDPViewController"]){
        source = @"more_products";
        
    }else if ([className isEqualToString:@"BrowseByCategoryViewController"]){
        source = @"search";
        
    }else if ([className isEqualToString:@"CartViewController"]){
           source = @"cart";
        
    }else if([className isEqualToString:@""]){
        return nil;
    }
    
    return source;
}


- (void)genaratePDPScreen{
    [self createHeaderView];
    [self setupDetailView];
    
    if(SYSTEM_VERSION_LESS_THAN(@"8.0")){
        [productImageView setupHeaderViewWithFrame:CGRectMake(0, 0, self.pdpScrollView.frame.size.width, headerHeight + 150)];
    }else{
        [headerScroller setupContainer];
    }

}

-(void)createHeaderView{
    
    if(SYSTEM_VERSION_LESS_THAN(@"8.0")){
        productImageView = [[PDPTopView alloc] initWithImagesArray:self.productDiscription.producetAllImages];
        
        __block PDPTopView *blockImageView = productImageView;
        productImageView.productInformationText = self.productDiscription.productInfo;
        __weak PDPViewController *weakSelf = self;
        productImageView.theShareBlock = ^(NSInteger selectedIndex){
            
            NSURL *myWebsite = [NSURL URLWithString:weakSelf.productDiscription.shareUrl];
            
            //        NSMutableArray *shareItems = [NSMutableArray new];
            //        while ([shareItems count] < 5)
            //            [shareItems addObject: weakSelf];
            
            FyndActivityItemProvider *itemProvider = [[FyndActivityItemProvider alloc] initWithPlaceholderItem:@""];
            
            itemProvider.productDetails = weakSelf.productDiscription.productName;
            itemProvider.brandName = weakSelf.productDiscription.brandName;
            itemProvider.productImage = [blockImageView.imageArray objectAtIndex:0];
            itemProvider.shareURL = myWebsite;
            
            //        NSString *textToShare = @"";
            
            //        NSArray *objectsToShare = @[textToShare, myWebsite];
            NSArray *objectsToShare = @[itemProvider, myWebsite];
            imageToBeShared = [blockImageView.imageArray objectAtIndex:selectedIndex];
            
            //        NSArray *objectsToShare = @[itemProvider, myWebsite];
            UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:objectsToShare applicationActivities:nil];
            //        UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:@[shareItems] applicationActivities:nil];
            
            
            [activityVC setValue:[NSString stringWithFormat:@"%@ from %@ on Fynd", weakSelf.productDiscription.productName, weakSelf.productDiscription.brandName] forKey:@"subject"];
            
            [weakSelf presentViewController:activityVC animated:YES completion:nil];
        };
    }else{
        headerScroller = [[PDPHeaderScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, headerHeight) andImageURLs:self.productDiscription.producetAllImages];
        headerScroller.headerDelegate = self;
        
        headerScroller.productInformationText = self.productDiscription.productInfo;
        __weak PDPViewController *weakSelf = self;
        headerScroller.theShareBlock = ^(UIImage * selectedImage){
            
            NSURL *myWebsite = [NSURL URLWithString:weakSelf.productDiscription.shareUrl];
            FyndActivityItemProvider *itemProvider = [[FyndActivityItemProvider alloc] initWithPlaceholderItem:@""];
            itemProvider.productDetails = weakSelf.productDiscription.productName;
            itemProvider.brandName = weakSelf.productDiscription.brandName;
            itemProvider.productImage = selectedImage;
            itemProvider.shareURL = myWebsite;
            NSArray *objectsToShare = @[itemProvider, myWebsite];
            imageToBeShared = selectedImage;
            UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:objectsToShare applicationActivities:nil];
            [activityVC setValue:[NSString stringWithFormat:@"%@ from %@ on Fynd", weakSelf.productDiscription.productName, weakSelf.productDiscription.brandName] forKey:@"subject"];
            [weakSelf presentViewController:activityVC animated:YES completion:nil];
        };
    }
}


-(void)setupDetailView{
    
    if(SYSTEM_VERSION_LESS_THAN(@"8.0")){
        self.pdpScrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
        [self.pdpScrollView setBackgroundColor:UIColorFromRGB(kBackgroundGreyColor)];
        [self.view addSubview:self.pdpScrollView];
        self.pdpScrollView.delegate = self;
        [self.pdpScrollView setParallaxHeaderView:productImageView mode:VGParallaxHeaderModeFill height:headerHeight];
        //    [self.pdpScrollView setContentSize:CGSizeMake(self.view.frame.size.width, RelativeSizeHeight(800, 568))];
        [self.pdpScrollView setShowsVerticalScrollIndicator:FALSE];
        
        UIImage *curvImage = [UIImage imageNamed:@"ArcImage"];
        CGFloat height = curvImage.size.height * self.pdpScrollView.frame.size.width/curvImage.size.width;
        UIImageView *pdpCurveImage = [[UIImageView alloc] initWithImage:curvImage];
        [pdpCurveImage setFrame:CGRectMake(0, -height, self.pdpScrollView.frame.size.width, height)];
        [pdpCurveImage setBackgroundColor:[UIColor clearColor]];
        [self.pdpScrollView addSubview:pdpCurveImage];
        
        detailView = [[ProductDetailView alloc] initWithFrame:CGRectMake(0, pdpCurveImage.frame.origin.y+ pdpCurveImage.frame.size.height, self.pdpScrollView.frame.size.width, self.pdpScrollView.frame.size.height)];
        detailView.detailDelegate = self;
        [detailView setBackgroundColor:UIColorFromRGB(kBackgroundGreyColor)];
        [self.pdpScrollView addSubview:detailView];
        
        __weak PDPViewController *weak = self;
        __weak ProductDetailView *detailWeak = detailView;
        detailView.addCartItemBlock = ^(NSMutableArray *array,BOOL isItemAddedIntoCart){
            if(!isItemAddedIntoCart)
                [weak addItemCartService1:array];
            else{
                if(weak.tabBarController.selectedIndex == 4){
                    [weak.navigationController popToRootViewControllerAnimated:YES];
                }else{
                    
                    UINavigationController *navController = [[weak.tabBarController viewControllers] objectAtIndex:4];
                    [navController popToRootViewControllerAnimated:NO];
                    [detailWeak.addToCartButton setTitle:@"BUY NOW" forState:UIControlStateNormal];
                    [weak.tabBarController setSelectedIndex:4];
                }
            }
        };
        
        if(!isDetailViewObserverAdded){
            [self addObserver:self forKeyPath:@"detailView.frame" options:NSKeyValueObservingOptionNew context:NULL];
            isDetailViewObserverAdded= TRUE;
        }
        
        [self.view addSubview:self.pdpScrollView];
        [self setupDetailScreen];
        
        self.fixedView = [self generateFixButtons];
        //    [self.view addSubview:self.fixedView];
        
    }else{
        self.pdpScrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
        [self.pdpScrollView setBackgroundColor:UIColorFromRGB(kBackgroundGreyColor)];
        [self.view addSubview:self.pdpScrollView];
        self.pdpScrollView.delegate = self;
        //    [self.pdpScrollView setParallaxHeaderView:productImageView mode:VGParallaxHeaderModeFill height:headerHeight];
        [self.pdpScrollView setParallaxHeaderView:headerScroller mode:VGParallaxHeaderModeFill height:headerHeight];
        
        //    [self.pdpScrollView setContentSize:CGSizeMake(self.view.frame.size.width, RelativeSizeHeight(800, 568))];
        [self.pdpScrollView setShowsVerticalScrollIndicator:FALSE];
        
        UIImage *curvImage = [UIImage imageNamed:@"ArcImage"];
        CGFloat height = curvImage.size.height * self.pdpScrollView.frame.size.width/curvImage.size.width;
        UIImageView *pdpCurveImage = [[UIImageView alloc] initWithImage:curvImage];
        [pdpCurveImage setFrame:CGRectMake(0, -height, self.pdpScrollView.frame.size.width, height)];
        [pdpCurveImage setBackgroundColor:[UIColor clearColor]];
        [pdpCurveImage setTag:1111];
        [self.pdpScrollView addSubview:pdpCurveImage];
        
        detailView = [[ProductDetailView alloc] initWithFrame:CGRectMake(0, pdpCurveImage.frame.origin.y+ pdpCurveImage.frame.size.height, self.pdpScrollView.frame.size.width, self.pdpScrollView.frame.size.height)];
        detailView.detailDelegate = self;
        [detailView setBackgroundColor:UIColorFromRGB(kBackgroundGreyColor)];
        [self.pdpScrollView addSubview:detailView];
        
        __weak PDPViewController *weak = self;
        __weak ProductDetailView *detailWeak = detailView;
        detailView.addCartItemBlock = ^(NSMutableArray *array,BOOL isItemAddedIntoCart){
            if(!isItemAddedIntoCart)
                [weak addItemCartService1:array];
            else{
                if(weak.tabBarController.selectedIndex == 4){
                    [weak.navigationController popToRootViewControllerAnimated:YES];
                }else{
                    
                    UINavigationController *navController = [[weak.tabBarController viewControllers] objectAtIndex:4];
                    [navController popToRootViewControllerAnimated:NO];
                    [detailWeak.addToCartButton setTitle:@"BUY NOW" forState:UIControlStateNormal];
                    [weak.tabBarController setSelectedIndex:4];
                }
            }
        };
        
        if(!isDetailViewObserverAdded){
            [self addObserver:self forKeyPath:@"detailView.frame" options:NSKeyValueObservingOptionNew context:NULL];
            isDetailViewObserverAdded= TRUE;
        }
        
        [self.view addSubview:self.pdpScrollView];
        [self setupDetailScreen];
        
        self.fixedView = [self generateFixButtons];
        //    [self.view addSubview:self.fixedView];
    }
}


-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    if([keyPath isEqualToString:@"detailView.frame"]){
        [self.pdpScrollView setContentSize:CGSizeMake(self.pdpScrollView.frame.size.width, detailView.frame.size.height)];
    }
}


- (UIView*)generateFixButtons{
    
    //    UIView *cView = [[UIView alloc] initWithFrame:CGRectMake(self.frame.origin.x, floatingButtonsStartingFrame.origin.y , self.frame.size.width, 60)];
    UIView *cView = [[UIView alloc] initWithFrame:CGRectMake(self.view.frame.origin.x, self.view.frame.size.height -60 , self.view.frame.size.width, 60)];

    [cView setBackgroundColor:[UIColor whiteColor]];
    
    NSInteger addToCartStartPoint =10;
    
    if(self.productDiscription.isTryAtHomeAvailable){
    
        UIButton  *tryAtHomeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        tryAtHomeButton.layer.cornerRadius = 3.0f;
        [tryAtHomeButton setFrame:CGRectMake(addToCartStartPoint,  5, self.view.frame.size.width/3, 50)];
        [tryAtHomeButton setBackgroundColor:UIColorFromRGB(0x33CC99)];
        [tryAtHomeButton setTitle:@"TRY @ HOME" forState:UIControlStateNormal];
        [tryAtHomeButton addTarget:self action:@selector(tryAtHomeAction:) forControlEvents:UIControlEventTouchUpInside];
        tryAtHomeButton.titleLabel.font = [UIFont fontWithName:kMontserrat_Bold size:13.0f];
        [cView addSubview:tryAtHomeButton];
        addToCartStartPoint+=  tryAtHomeButton.frame.origin.x + tryAtHomeButton.frame.size.width;
    }
    
    UIButton  *addToCartButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [addToCartButton setFrame:CGRectMake(addToCartStartPoint, 5, self.view.frame.size.width - addToCartStartPoint-10, 50)];
    addToCartButton.layer.cornerRadius = 3.0f;
    [addToCartButton setBackgroundColor:UIColorFromRGB(0xEE365E)];
    [addToCartButton setTitle:@"BUY NOW" forState:UIControlStateNormal];
    [addToCartButton addTarget:self action:@selector(buyNowTap:) forControlEvents:UIControlEventTouchUpInside];
    [addToCartButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    addToCartButton.titleLabel.font = [UIFont fontWithName:kMontserrat_Bold size:13.0f];
    [cView addSubview:addToCartButton];
    
    
    return cView;
}


-(void)tryAtHomeAction:(id)sender{
    [detailView pickAtStore:nil];
}

- (void)buyNowTap:(id)sender{
    [detailView addItemToCart:nil];
}

-(void)setupDetailScreen{
    
    //Dummy PDP Info
    /*
    NSMutableArray *dummyInfoData = [self.productDiscription.productDescription mutableCopy];
    NSMutableDictionary *dict = [self.productDiscription.productDescription objectAtIndex:0];
    [dummyInfoData addObject:dict];
    self.productDiscription.productDescription = dummyInfoData;
     */
    
    
    detailView.productData = self.productDiscription;
    [detailView generateProductInfo];
    detailView.tag = CONTENT_IMAGE_VIEW_TAG;
    
    
    /* // I have to work on this, for dynamic height. As of now usinh Rahul work
     CGFloat height = [self calculateDynamicCellHeight:data withTabTag:0];
     
     self.detailView = [[ProductDetailView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.view.frame.size.width, height)];
     self.detailView.detailDelegate = self;
     self.detailView.productData = data;
     [self.detailView generateProductInfo];
     self.detailView.tag = CONTENT_IMAGE_VIEW_TAG;
     [self.view addSubview:self.detailView];
     */
}



-(CGFloat)calculateDynamicCellHeight:(PDPModel *)productDescription withTabTag:(NSInteger)index{
    CGFloat aHeight = 0.0f;
//    NSInteger couponContainerHeight = [productDescription.coupans count]* (2*kPDPElementsPadding);
    NSInteger couponContainerHeight = 1* (2*kPDPElementsPadding);
    NSDictionary *dict = [productDescription.productDescription objectAtIndex:index];
    CGSize descriptionSize = [SSUtility getDynamicSizeWithSpacing:[dict objectForKey:@"text"] withFont:[UIFont fontWithName:kMontserrat_Light size:14.0f] withSize:CGSizeMake(self.view.frame.size.width-40, MAXFLOAT) spacing:5.0f];
    
    NSInteger descriptionContentHeight = descriptionSize.height;
    NSMutableArray *detailData = [dict objectForKey:@"details"];
    descriptionContentHeight += [detailData count]* (2*kPDPElementsPadding);
    
    /*
    aHeight += kPDPNameStripHeight + kPDPElementsPadding + kPDPDefaultSizeStripHeight +kPDPElementsPadding + couponContainerHeight +2*kPDPElementsPadding + kPDPOrderButtonsHeight + kPDPElementsPadding + kPDPDeliveryOptionsViewHeight + kPDPElementsPadding + kPDPNearestStoreViewHeight + kPDPElementsPadding + kPDPMoreDetailHeader + 5+ descriptionSize.height+ kPDPElementsPadding+ kPDPFeedBackViewHeight + 8*kPDPElementsPadding;
     */
    
    /* // Height Modification
    if(productDescription.productDescription && [productDescription.productDescription count]>0)
//    if(0)
    {
        aHeight += kPDPNameStripHeight + kPDPElementsPadding + kPDPDefaultSizeStripHeight +kPDPElementsPadding + couponContainerHeight +2*kPDPElementsPadding + kPDPOrderButtonsHeight + kPDPElementsPadding + kPDPDeliveryOptionsViewHeight + kPDPElementsPadding + kPDPNearestStoreViewHeight + kPDPElementsPadding + kPDPMoreDetailHeader + 5+ descriptionSize.height+ kPDPElementsPadding+ kPDPFeedBackViewHeight + 1*kPDPElementsPadding + descriptionContentHeight;
    }else{
        aHeight += kPDPNameStripHeight + kPDPElementsPadding + kPDPDefaultSizeStripHeight +kPDPElementsPadding + couponContainerHeight +2*kPDPElementsPadding + kPDPOrderButtonsHeight + kPDPElementsPadding + kPDPDeliveryOptionsViewHeight + kPDPElementsPadding + kPDPNearestStoreViewHeight + kPDPElementsPadding + kPDPMoreDetailHeader + 5+ descriptionSize.height+ kPDPElementsPadding+ kPDPFeedBackViewHeight + 1*kPDPElementsPadding;
    }
     */
    
    
    if(productDescription.productDescription && [productDescription.productDescription count]>0)
//            if(0)
    {
        aHeight += kPDPNameStripHeight + kPDPElementsPadding + kPDPDefaultSizeStripHeight +kPDPElementsPadding + kPDPElementsPadding + kPDPOrderButtonsHeight + kPDPElementsPadding + kPDPDeliveryOptionsViewHeight + kPDPElementsPadding + kPDPNearestStoreViewHeight + kPDPElementsPadding + kPDPMoreDetailHeader + 5+ kPDPElementsPadding+ kPDPFeedBackViewHeight + 1*kPDPElementsPadding + descriptionContentHeight;
    }else{
        aHeight += kPDPNameStripHeight + kPDPElementsPadding + kPDPDefaultSizeStripHeight +kPDPElementsPadding + couponContainerHeight +2*kPDPElementsPadding + kPDPOrderButtonsHeight + kPDPElementsPadding + kPDPDeliveryOptionsViewHeight + kPDPElementsPadding + kPDPNearestStoreViewHeight + kPDPElementsPadding + kPDPMoreDetailHeader + 5+ descriptionSize.height+ kPDPElementsPadding+ kPDPFeedBackViewHeight + 1*kPDPElementsPadding;
    }
    

   return aHeight;
}


- (void)updateProductInfoLayout:(NSInteger)indexValue withSimilarProductsContainerHeight:(NSInteger)gridContainerHeight{
    CGFloat height = [self calculateDynamicCellHeight:self.productDiscription withTabTag:indexValue];
    height += gridContainerHeight;
    [detailView setFrame:CGRectMake(detailView.frame.origin.x, detailView.frame.origin.y, detailView.frame.size.width, height)];
}



- (void)displayPopUp:(PDPPopUpType)type withUserInput:(NSMutableDictionary *)dict{
    NSMutableDictionary *parameters = nil;
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    BOOL isTryAtHomeFirstTime = [[userDefaults objectForKey:@"isTryAtHomeGuideSeen"] boolValue];
    
    switch (type) {
        case PDPSizeGuidePopUp:
            parameters = [[NSMutableDictionary alloc] init];
            [parameters setObject:[NSNumber numberWithInt:SizeGuideOverlay] forKey:@"PopUpType"];
            [parameters setObject:@"http://128.199.116.47/images/3.png" forKey:@"Url"];
            
            break;
            
        case PDPSeeAllStorePopUp:
            parameters = [[NSMutableDictionary alloc] init];
            [parameters setObject:[NSNumber numberWithInt:NearestStoreOverlay] forKey:@"PopUpType"];
            [parameters setObject:@"http://128.199.116.47/images/3.png" forKey:@"Url"];
            [parameters setObject:[NSNumber numberWithBool:TRUE] forKey:@"isViewAllStores"];
            [parameters setObject:self.productDiscription.brandName forKey:@"BrandName"];
            [parameters setObject:self.productDiscription.logoImageData.imageUrl forKey:@"BrandLogo"];
//            [parameters setObject:@"http://orbis-staging.addsale.com/media/images/inventory/brand/being_human_logo.jpg" forKey:@"BrandLogo"];
            [parameters setObject:self.productDiscription.stores forKey:@"PopUpData"];
            break;
            
        case PDPPickAtStorePopUp:
            parameters = [[NSMutableDictionary alloc] init];
            [parameters setObject:[NSNumber numberWithInt:NearestStoreOverlay] forKey:@"PopUpType"];
            [parameters setObject:[NSNumber numberWithBool:FALSE] forKey:@"isViewAllStores"];
            [parameters setObject:@"http://128.199.116.47/images/3.png" forKey:@"Url"];
            [parameters setObject:self.productDiscription.stores forKey:@"PopUpData"];
            break;
            
        case PDPPinCodePopUp:
            parameters = [[NSMutableDictionary alloc] init];
            [parameters setObject:self.productDiscription.productID forKey:@"ProductId"];
            [parameters setObject:[NSNumber numberWithInt:PinCodeOverlay] forKey:@"PopUpType"];
            break;
            
        case PDPTRYAtHomePopUp: //PickAtStoreOverlay
            parameters = [[NSMutableDictionary alloc] init];
            if(isTryAtHomeFirstTime){
                [parameters setObject:[NSNumber numberWithInt:TryAtHomeOverlay] forKey:@"PopUpType"];
                [parameters setObject:self.productDiscription.fyndAFitDictonary forKey:@"DependentSizes"];
            }
            else{
                [parameters setObject:[NSNumber numberWithInt:TryAtHomeFirstTimeOverlay] forKey:@"PopUpType"];
             }
            
            [parameters setObject:self.productDiscription.sizeArray forKey:@"PopUpData"];
            [parameters setObject:self.productDiscription.convenienceFee forKey:@"convenienceFee"];
            [parameters setObject:[NSNumber numberWithInt:2] forKey:@"maxSizeSelection"];
            [parameters setObject:@"CANCEL" forKey:@"LeftButtonTitle"];
            [parameters setObject:@"BUY NOW" forKey:@"RightButtonTitle"];
            [parameters setObject:[NSNumber numberWithInteger:SelectSizeFromAddToCart] forKey:@"TryAtHomAction"];
            
            [parameters setObject:[NSNumber numberWithBool:isTryAtHomeFirstTime] forKey:@"TryAtHomeModuleType"];
            break;
        default:
            break;
    }
    
    if(self.popOverHandler){
        self.popOverHandler.overlayDelegate = nil;
        self.popOverHandler = nil;
    }
    self.popOverHandler = [[PopOverlayHandler alloc] init];
    self.popOverHandler.overlayDelegate = self;
    [self.popOverHandler presentOverlay:SizeGuideOverlay rootView:self.view enableAutodismissal:TRUE withUserInfo:parameters];
}

-(void)showSimilarProductsWithProductURL:(NSString *)URL{
    PDPViewController *theSimilarProductInstance = [[PDPViewController alloc] init];
    theSimilarProductInstance.productURL = URL;
    [self.navigationController pushViewController:theSimilarProductInstance animated:TRUE];

}

- (void)showSizeGuide:(NSString *)someUrl{
    PDPSizeGuideViewController *sizeGuideController = [[PDPSizeGuideViewController alloc] init];
    [self.navigationController pushViewController:sizeGuideController animated:TRUE];
}

- (void)performActionOnOverlay:(NSInteger)tag andPopType:(RPWOverlayType )type andInputDictionary:(NSMutableDictionary *)dictionary{
    
    NSUserDefaults *userDefaults = nil;

    if(tag==-1){ //If user click on cancel then this will execute
        [self.popOverHandler dismissOverlay];
        return;
    }
   
    switch (type) {
            
        case TryAtHomeFirstTimeOverlay:
            
            userDefaults = [NSUserDefaults standardUserDefaults];
            BOOL isTryAtHomeFirstTime = [[userDefaults objectForKey:@"isTryAtHomeGuideSeen"] boolValue];

             if(!isTryAtHomeFirstTime){
                 [userDefaults setObject:[NSNumber numberWithBool:TRUE] forKey:@"isTryAtHomeGuideSeen"];
             }
            
            [self.popOverHandler dismissOverlay];
            [self displayPopUp:PDPTRYAtHomePopUp withUserInput:nil];
            break;
            
        case TryAtHomeOverlay:
            [self.popOverHandler dismissOverlay];
            self.popOverHandler.contentView.userInteractionEnabled = FALSE;
            [self addItemCartService:[dictionary objectForKey:@"selectedSizeData"]];
            break;
            
        default:
            break;
            }
    
    
//      Keep in Mind , Fisrt time Size pop up.
    /*
    [self.popOverHandler dismissOverlay];
    
    [self displayPopUp:PDPTRYAtHomePopUp withUserInput:nil];
     */
     
}


- (void)addItemCartService:(NSMutableArray *)sizeData{
 
    [self.view addSubview:pdpLoader];
    [pdpLoader startAnimating];
    CartRequestHandler *cartHandler = [[CartRequestHandler alloc] init];
    ProductSize *size1Value = [sizeData objectAtIndex:0];
    ProductSize *size2Value = [sizeData objectAtIndex:1];
    
    NSDictionary *paramDict = [[NSDictionary alloc] initWithObjectsAndKeys:@"try_at_home",@"order_type",self.productDiscription.productID,@"product_id",size1Value.sizeValue,@"size1",size2Value.sizeValue,@"size2", nil];
  
    [cartHandler addItemIntoCart:paramDict withCompletionHandler:^(id responseData, NSError *error) {
        [self.popOverHandler dismissOverlay];

        [pdpLoader stopAnimating];
        [pdpLoader removeFromSuperview];
        
        if([[responseData objectForKey:@"is_added"] boolValue]){
            [FyndAnalytics trackAddToBagWithType:@"faf" brandName:self.productDiscription.brandName itemCode:self.productDiscription.productID articleCode:@"" productPrice:[NSString stringWithFormat:@"%ld", (long)self.productDiscription.productEffectivePrice] from:@"product"];

            //Increment the cpomter and change the icon
            int totalBagItems =[[[NSUserDefaults standardUserDefaults] valueForKey:kHasItemInBag] intValue];
            
            
            if (totalBagItems>0) {
                totalBagItems ++;
            }else{
                totalBagItems ++;
                UITabBarItem *cartBarItem = [self.tabBarController.tabBar.items objectAtIndex:4];
                [cartBarItem setSelectedImage:[[UIImage imageNamed:@"CartFilledSelectedTab"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
                [cartBarItem setImage:[[UIImage imageNamed:@"CartFilledTab"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
            }

            UINavigationController *navController = [[self.tabBarController viewControllers] objectAtIndex:4];
            [navController popToRootViewControllerAnimated:NO];

            [self.tabBarController setSelectedIndex:4];
        }
    }];
}


- (void)generateAddCartInfoView{
    
    [detailView updateAddToCartButton];
    self.addCartInfoView = [[UIView alloc] initWithFrame:CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y-50, self.view.frame.size.width, 50)];
    [self.addCartInfoView setBackgroundColor:UIColorFromRGB(kGreenColor)];
    NSString *infoString = @"1 item added to your bag";
    CGSize size = [SSUtility getLabelDynamicSize:infoString withFont:[UIFont fontWithName:kMontserrat_Regular size:14.0f] withSize:CGSizeMake(self.addCartInfoView.frame.size.width, MAXFLOAT)];
    UILabel *info = [SSUtility generateLabel:@"1 item added to your bag" withRect:CGRectMake(self.addCartInfoView.frame.size.width/2 - size.width/2, self.addCartInfoView.frame.size.height/2 - size.height/2, size.width, size.height) withFont:[UIFont fontWithName:kMontserrat_Regular size:14.0f]];
    [info setTextColor:[UIColor whiteColor]];
    [self.addCartInfoView addSubview:info];
    [[[[UIApplication sharedApplication] windows] objectAtIndex:0] addSubview:self.addCartInfoView];
//    [self.view addSubview:self.addCartInfoView];

    endPoint2 = CGPointMake(self.view.frame.origin.y,0);
//    [self showAddCartInformation];
     [self animteAddCartInfo:endPoint2];
}


- (void)animteAddCartInfo:(CGPoint)destinationPoint{
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.5f];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(animationDidStop:finished:)];
    [self.addCartInfoView setFrame:CGRectMake(self.addCartInfoView.frame.origin.x, destinationPoint.y, self.addCartInfoView.frame.size.width, self.addCartInfoView.frame.size.height)];
    [UIView commitAnimations];
}


- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
    
    [UIView animateWithDuration:3.0f animations:^{
        self.addCartInfoView.alpha = 0.0f;
    }
    completion:^(BOOL finished) {
        if(self.addCartInfoView){
            [self.addCartInfoView removeFromSuperview];
            self.addCartInfoView = nil;
        }
    }];
    
}

- (void)addItemCartService1:(NSMutableArray *)sizeData{
    //Called for Buy Now
    
    if(sizeData && [sizeData count]>0){
        [self.view addSubview:pdpLoader];
        [pdpLoader startAnimating];
        
        CartRequestHandler *cartHandler = [[CartRequestHandler alloc] init];
        ProductSize *size1Value = [sizeData objectAtIndex:0];
        NSDictionary *paramDict = [[NSDictionary alloc] initWithObjectsAndKeys:@"standard",@"order_type",self.productDiscription.productID,@"product_id",size1Value.sizeValue,@"size1", nil];
        
        [cartHandler addItemIntoCart:paramDict withCompletionHandler:^(id responseData, NSError *error) {
            [pdpLoader stopAnimating];
            [pdpLoader removeFromSuperview];
            
            [self.popOverHandler dismissOverlay];
            if([[responseData objectForKey:@"is_added"] boolValue]){
                [FyndAnalytics trackAddToBagWithType:@"buy" brandName:self.productDiscription.brandName itemCode:self.productDiscription.productID articleCode:@"" productPrice:[NSString stringWithFormat:@"%ld", (long)self.productDiscription.productEffectivePrice] from:@"product"];
                
                detailView.isItemAddedIntoCart  = TRUE;
                [self generateAddCartInfoView];
            //Increment the counter and change the icon
                int totalBagItems =[[[NSUserDefaults standardUserDefaults] valueForKey:kHasItemInBag] intValue];
                

                if (totalBagItems>0) {
                    totalBagItems ++;
                }else{
                    totalBagItems ++;
                    UITabBarItem *cartBarItem = [self.tabBarController.tabBar.items objectAtIndex:4];
                    [cartBarItem setSelectedImage:[[UIImage imageNamed:@"CartFilledSelectedTab"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
                    [cartBarItem setImage:[[UIImage imageNamed:@"CartFilledTab"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
                }

                
                
            }
        }];
    }else{
        
        if(!self.floatingStarted){
        [UIView animateWithDuration:0.25f delay:0
                            options:UIViewAnimationOptionAllowUserInteraction animations:^{
                                
                                [self.pdpScrollView setContentOffset:CGPointMake(self.pdpScrollView.frame.origin.x, self.pdpScrollView.contentOffset.y+120)];
                                
                            } completion:^(BOOL finished) {
                                self.floatingStarted = TRUE;
                                
                                [detailView wiggleView];
                                
                            }];
        }else{
            [detailView wiggleView];
        }
        
    }
}


- (void)displayFeedBack{
//    PDPFeedBackViewController *feedBackController = [[PDPFeedBackViewController alloc] init];
//    [self.navigationController pushViewController:feedBackController animated:TRUE];
    
    if(returnController){
        returnController = nil;
    }
    
    returnController = [[RetunPolicyViewController alloc] init];
    [self.navigationController pushViewController:returnController animated:YES];
}


-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    [self.navigationController.navigationBar setFrame:CGRectMake(0, 20, self.navigationController.navigationBar.frame.size.width, self.navigationController.navigationBar.frame.size.height)];
    self.pdpScrollView.contentOffset = CGPointMake(0, 0 - self.pdpScrollView.contentInset.top);
    [self resetBars];
    [[UIApplication sharedApplication] setStatusBarHidden:FALSE];
    if(isDetailViewObserverAdded){
        @try{
            [self removeObserver:self forKeyPath:@"detailView.frame"];
            isDetailViewObserverAdded = false;
        }@catch(id anException){
            
        }
    }
//    [self removeObserver:self forKeyPath:@""];
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{

    CGFloat thersoldOffset = 0.0f;
//    if(self.view.frame.size.height == 667){
////        thersoldOffset = -415.0f;
//        thersoldOffset = - 379;
//    }else if(self.view.frame.size.height == 568){
////        thersoldOffset = -308;
//        thersoldOffset = -281;
//    }else if(self.view.frame.size.height == 480){
////        thersoldOffset = -208;
//        thersoldOffset = -192;
//    }
    
    if([self.productDiscription.coupans count] > 0){
//        thersoldOffset = -(headerHeight - 164);
        thersoldOffset = -(headerHeight - 159);
    }else{
//        thersoldOffset = -(headerHeight - 131);
        thersoldOffset = -(headerHeight - 126);
    }

    

    if(scrollView.contentOffset.y > thersoldOffset){
        self.floatingStarted = TRUE;
        [detailView updateButtonsFrame:CGRectMake(detailView.thirdStripView.frame.origin.x, detailView.floatingButtonsFixedFrame.origin.y-15, detailView.thirdStripView.frame.size.width, detailView.thirdStripView.frame.size.height)];

    }else if(scrollView.contentOffset.y < thersoldOffset){
        self.floatingStarted = FALSE;
        [detailView updateButtonsFrame:CGRectMake(detailView.thirdStripView.frame.origin.x, detailView.floatingButtonsStartingFrame.origin.y + (headerHeight + scrollView.contentOffset.y) -15, detailView.thirdStripView.frame.size.width, detailView.thirdStripView.frame.size.height)];
    }
    [self.pdpScrollView shouldPositionParallaxHeader];
    
    
    //Code to show the Navigation bar and show the whishlist icon
    if (scrollView.contentOffset.y<=0) {
        self.title = @"";
//        [self.navigationController.navigationBar changeNavigationBarToTransparent:YES];
        self.navigationController.navigationBar.shadowImage = [UIImage new];
        self.navigationController.navigationBar.backgroundColor = [UIColor clearColor];


        [self.navigationItem setRightBarButtonItems:nil];
    }else {
        if (scrollView.contentOffset.y>detailView.gridContainerView.frame.origin.y) {
            self.title = @"You May Also Like";
            self.navigationItem.rightBarButtonItems = nil;

            [self manageBarsWithScroll:scrollView forGridView:nil];
        }else{
            if (![self.tabBarController.tabBar isHidden]) {
                [self.tabBarController.tabBar setHidden:TRUE];
            }
                
            self.title = [self.productDiscription.productName capitalizedString];
             //Adding the wish list icon
            UIBarButtonItem *negativeSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
            negativeSpace.width = -15;
            
            self.navigationItem.rightBarButtonItems = @[negativeSpace, [self wishListButton]];
        }
//        [self.navigationController.navigationBar changeNavigationBarToTransparent:NO];
        
        self.navigationController.navigationBar.backgroundColor = UIColorFromRGB(0xF2F2F2);
        self.navigationController.navigationBar.shadowImage = [SSUtility imageWithColor:UIColorFromRGB(0xDDDDDD)];

    }
}

-(void)toggleLikeForBarItem{
    [(UIButton *)[wishListBarItem customView] setBackgroundImage:self.productDiscription.productBookMerked ? [UIImage imageNamed:@"WishlistLarge"] : [UIImage imageNamed:@"WishlistLargeFilled"] forState:UIControlStateNormal];
    
    [detailView toggleLike];
}

- (UIBarButtonItem *)wishListButton
{
    NSString *imageName = nil;
    if (self.productDiscription.productBookMerked) {
        imageName = @"WishlistLargeFilled";
    }else{
        imageName = @"WishlistLarge";
    }

//    UIImage *image = [[UIImage imageNamed:imageName] imageWithAlignmentRectInsets:UIEdgeInsetsMake(6, 0, 0, 0)];
    UIImage *image = [[UIImage imageNamed:imageName] imageWithAlignmentRectInsets:UIEdgeInsetsMake(0, 0, 0, -11)];

    CGRect buttonFrame = CGRectMake(0, 0, image.size.width, image.size.height);
    
    
    UIButton *button = [[UIButton alloc] initWithFrame:buttonFrame];
    [button setBackgroundImage:image forState:UIControlStateNormal];
    [button addTarget:self action:@selector(toggleLikeForBarItem) forControlEvents:UIControlEventTouchUpInside];
    wishListBarItem= [[UIBarButtonItem alloc] initWithCustomView:button];

    return wishListBarItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)manageBarsWithScroll:(UIScrollView *)scrollView forGridView:(GridView *)theGrdidView{

    if([[[UIDevice currentDevice] systemVersion] floatValue] < 7.0f){
        return;
    }
    
    CGRect tabBarFrame = self.tabBarController.tabBar.frame;
    CGFloat tabHeight = tabBarFrame.size.height;
    
    if(scrollView.contentOffset.y > detailView.gridContainerView.frame.origin.y){
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
        {
            isScrolling = TRUE;
            
            [UIView animateWithDuration:0.1 animations:^{
                if (hideBars) {
                    
                }
                
            } completion:^(BOOL finished) {
                [UIView animateWithDuration:0.4 animations:^{
                    if(!hideBars){
                    }
                    [self.tabBarController.tabBar setFrame:tabBarFrame];
                    
                } completion:^(BOOL finished) {
                    if(hideBars){
                    }
                    isScrolling = FALSE;
                }];
                
            }];
        }
        
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
    if(isDetailViewObserverAdded){
        [detailView removeObserver];
        @try{
            [self removeObserver:self forKeyPath:@"detailView.frame"];
            isDetailViewObserverAdded = false;
        }@catch(id anException){
            
        }
    }
}

-(void)exitFullScreenMode:(id)scrollView{
    
    [self.pdpScrollView setParallaxHeaderView:nil mode:VGParallaxHeaderModeFill height:-headerHeight];
    [self.pdpScrollView setParallaxHeaderView:scrollView mode:VGParallaxHeaderModeFill height:headerHeight];
    UIView *view = [self.pdpScrollView viewWithTag:1111];
    [self.pdpScrollView bringSubviewToFront:view];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
