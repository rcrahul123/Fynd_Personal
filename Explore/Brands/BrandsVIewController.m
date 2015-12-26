//
//  FirstViewController.m
//  TabBasedAppSample
//
//  Created by Rahul on 6/23/15.
//  Copyright (c) 2015 Rahul. All rights reserved.
//
//#define kGenderViewHeight   55.0f
#import "BrandsVIewController.h"
#import "BrowseByCollectionViewController.h"
#import "BrowseByBrandViewController.h"
#import "HomeRequestHandler.h"
#import "BrowseByCategoryViewController.h"
#import "GenderHeaderView.h"
#import "SSUtility.h"
#import "GridView.h"
#import "GenderHeaderModel.h"
#import "FyndUser.h"
#import "FyndAnalytics.h"
@interface BrandsVIewController ()<UICollectionViewDataSource,UICollectionViewDelegate>
{
    SearchViewController *theSearchViewController;
//    BrowseByCollectionViewController *theBrowseController;
//    BrowseByBrandViewController *brandController;
    
    CGSize brandProductSize;
    BrandTabData    *brandServiceData;
    BOOL            isGenderViewVisible;
    
    BOOL hideBars;
    BOOL isScrolling;
    SSLine *genderLine;
    CGFloat genderViewHeight;
    BOOL    genderValueChanged;
}
@property (nonatomic,strong) NSMutableArray *brandArray;
@property (nonatomic,strong) UICollectionView *brandCollectionView;
@property (nonatomic,strong) HomeRequestHandler  *tabRequestHandler;
@property (nonatomic,strong) GenderHeaderView    *genderHeader;
@property (nonatomic,strong) UIActivityIndicatorView *activityIndicator;
@property (nonatomic,strong) UIView *navigationView;
@property (nonatomic,strong) GridView           *brandGridView;
@property (nonatomic, strong) PDPViewController *pdpController;
@property (nonatomic, strong) BrowseByBrandViewController *browseByBrandController;
@property (nonatomic, strong) BrowseByCollectionViewController *browseByCollectionController;
@property (nonatomic,strong) NSString       *selectedGenderFilter;
@property (nonatomic,strong) FyndBlankPage          *blankBrandsPage;

//- (void)fetchBrandsServiceData;
//- (void)configureBrandColectionView;
- (void)generateHeaderView;
@end

@implementation BrandsVIewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    userDefaults = [NSUserDefaults standardUserDefaults];
//    FyndUser *loggedInIUser = [SSUtility loadUserObjectWithKey:kFyndUserKey];
    genderViewHeight = 55;

    if(!self.isProfileBrand){
        [self fetchStoredUser];
        
//        self.navigationView = [self configureNavigationView:[loggedInIUser.gender capitalizedString]];
        self.navigationView = [self configureNavigationView:[self.selectedGenderFilter capitalizedString]];
        self.navigationItem.titleView = self.navigationView;
        

        brandPageNumber = 1;
        searchButton = [[UIBarButtonItem alloc] init];
        [searchButton setImage:[UIImage imageNamed:@"SearchBrowse"]];
        [searchButton setTarget:self];
        [searchButton setAction:@selector(beginSearch)];
        self.navigationItem.rightBarButtonItems = @[searchButton];
        
        notificationIcon = [[UIBarButtonItem alloc] init];
        [notificationIcon setImage:[UIImage imageNamed:@"Notification"]];
        [notificationIcon setTarget:self];
        [notificationIcon setAction:@selector(showNotifications)];
        self.navigationItem.leftBarButtonItem = notificationIcon;
//        self.brandGridView = [[GridView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 50 - 64)];
//Changes by Amboj to manage the issue
        
    }else{
        self.title = @"My Brands";

        self.navigationController.navigationBar.topItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];

    }
      [self.navigationController.navigationBar setFont:[UIFont fontWithName:kMontserrat_Regular size:16.0f] withColor:UIColorFromRGB(kDarkPurpleColor)];
    self.brandGridView = [[GridView alloc] initWithFrame:CGRectMake(0, RelativeSize(3, 320), self.view.frame.size.width, self.view.frame.size.height - 64)];
    self.brandGridView.delegate = self;
    self.brandGridView.collectionView.scrollsToTop = YES;
    brandsLoader = [[FyndActivityIndicator alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    [brandsLoader setCenter:CGPointMake(self.brandGridView.frame.size.width/2, self.brandGridView.frame.size.height/2 - 30)];

    
//    self.selectedGenderFilter = loggedInIUser.gender; //@"men";
    /*
    if([[userDefaults objectForKey:@"isLaunchedViaBranch"] boolValue]){
        NSArray *params = [userDefaults objectForKey:@"BranchParameters"];
        self.selectedGenderFilter = [[params objectAtIndex:0] objectForKey:@"gender"];
        self.navigationView = [self configureNavigationView:[self.selectedGenderFilter capitalizedString]];
        self.navigationItem.titleView  = self.navigationView;
        
    }else{
        self.selectedGenderFilter = loggedInIUser.gender;
    }
     */
    
    
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.brandGridView.collectionView.alwaysBounceVertical= true;

    [self fetchBrandsServiceDataForPageNumer:1 andGender:self.selectedGenderFilter];
    
    [SSUtility removeBranchStoredData];
    
    [self.view setBackgroundColor:UIColorFromRGB(kBackgroundGreyColor)];
    if (self.isProfileBrand) {
        [self setBackButton];
    }
}
-(void)setBackButton{
    UIImage *backButtonImage = [[UIImage imageNamed:kBackButtonImage] imageWithAlignmentRectInsets:UIEdgeInsetsMake(0, kBackButtonImageInset, 0, 0)];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:backButtonImage style:UIBarButtonItemStyleBordered target:self action:@selector(backAction:)];
}
-(void)backAction:(id)sender{
    [self.navigationController popViewControllerAnimated:TRUE];
}

-(void)showNotifications{
    NotificationViewController *notificationController = [[NotificationViewController alloc] init];
    [self.navigationController pushViewController:notificationController animated:YES];
}

- (UIView *)configureNavigationView:(NSString *)optionString{
    UIView *navigationView = [[UIView alloc] initWithFrame:CGRectMake(100, 10, 200, 40)];
    [navigationView setBackgroundColor:[UIColor clearColor]];
    
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showGenderView)];
    [navigationView addGestureRecognizer:gesture];
    CGSize aSize = [SSUtility getLabelDynamicSize:optionString withFont:[UIFont fontWithName:kMontserrat_Light size:16.0f] withSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
    
    UILabel *navigationViewLabel = [[UILabel alloc] initWithFrame:CGRectMake(navigationView.frame.size.width/2 - aSize.width/2,navigationView.frame.size.height/2 - aSize.height/2 , aSize.width, aSize.height)];
    [navigationViewLabel setBackgroundColor:[UIColor clearColor]];
    [navigationViewLabel setText:optionString];
    [navigationViewLabel setFont:[UIFont fontWithName:kMontserrat_Light size:16.0]];
    [navigationViewLabel setTextAlignment:NSTextAlignmentCenter];
    [navigationViewLabel setTextColor:UIColorFromRGB(kSignUpColor)];
    [navigationView addSubview:navigationViewLabel];
    
    UIImage *image = [UIImage imageNamed:@"Down"];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(navigationViewLabel.frame.origin.x + navigationViewLabel.frame.size.width, navigationViewLabel.frame.size.height - image.size.height/2, image.size.width, image.size.height)];;
    imageView.tag = 1234;
    [imageView setBackgroundColor:[UIColor clearColor]];
    
    [imageView setImage:image];
    [imageView setCenter:CGPointMake(imageView.center.x, navigationView.frame.size.height/2)];
    [navigationView addSubview:imageView];
    if (isGenderViewVisible) {
        imageView.transform = CGAffineTransformMakeRotation(DEGREES_TO_RADIANS(180));
    }
    return navigationView;
}

- (void)generateGenderGridView:(NSString *)gender{
    
    if(self.brandGridView){
        [self.brandGridView.parsedDataArray removeAllObjects];
        [self.brandGridView removeFromSuperview];
        self.brandGridView = nil;
    }
//    self.brandGridView = [[GridView alloc] initWithFrame:CGRectMake(0, self.genderHeader.frame.size.height, self.view.frame.size.width, self.view.frame.size.height - 50 - 64)];
    self.brandGridView = [[GridView alloc] initWithFrame:CGRectMake(0, self.genderHeader.frame.size.height, self.view.frame.size.width, self.view.frame.size.height - 64)];

    self.brandGridView.delegate = self;
    
    self.selectedGenderFilter = gender;

    
    if(self.selectedGenderFilter && self.selectedGenderFilter!=nil)
        [userDefaults setObject:self.selectedGenderFilter forKey:@"StoredGender"];
    
    
    [self fetchBrandsServiceDataForPageNumer:1 andGender:self.selectedGenderFilter];
}



CGPoint startPoint;
CGPoint endPoint;
-(void)showGenderView{

    isGenderViewVisible = !isGenderViewVisible;
    if(isGenderViewVisible){
      [self generateHeaderView];
    }
    if(isGenderViewVisible){
        startPoint = CGPointMake(self.genderHeader.frame.origin.x, -genderViewHeight);
        endPoint = CGPointMake(self.genderHeader.frame.origin.x, 0);
    }
    else{
        startPoint = CGPointMake(self.genderHeader.frame.origin.x, 0);
        endPoint = CGPointMake(self.genderHeader.frame.origin.x, -genderViewHeight);
    }
    
    [self animteHeader:startPoint toPoisition:endPoint];
    
}


- (void)animteHeader:(CGPoint)sourcePoint toPoisition:(CGPoint)destinationPoint{
    
    UIImageView *imageView = (UIImageView *)[self.navigationView viewWithTag:1234];
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.5f];
    [UIView setAnimationDelegate:self];
//    [UIView setAnimationDidStopSelector:@selector(animationDidStop:finished:)];
    [self.genderHeader setFrame:CGRectMake(self.genderHeader.frame.origin.x, destinationPoint.y, self.genderHeader.frame.size.width, self.genderHeader.frame.size.height)];
    if(isGenderViewVisible){
            imageView.transform = CGAffineTransformMakeRotation(DEGREES_TO_RADIANS(180));
            [self.brandGridView setFrame:CGRectMake(self.brandGridView.frame.origin.x, self.genderHeader.frame.size.height, self.brandGridView.frame.size.width, self.brandGridView.frame.size.height - self.genderHeader.frame.size.height)];
    }
    else{
        imageView.transform = CGAffineTransformMakeRotation(DEGREES_TO_RADIANS(360));
        [self.brandGridView setFrame:CGRectMake(self.brandGridView.frame.origin.x, 0, self.brandGridView.frame.size.width, self.brandGridView.frame.size.height + self.genderHeader.frame.size.height)];
        [self.brandGridView.collectionView setFrame:CGRectMake(self.brandGridView.collectionView.frame.origin.x, self.brandGridView.collectionView.frame.origin.y, self.brandGridView.collectionView.frame.size.width, self.brandGridView.frame.size.height)];

            [self.genderHeader setAlpha:0.0f];
    }
    [UIView commitAnimations];
}

- (void)generateHeaderView{
    
    if(self.genderHeader){
        [self.genderHeader removeFromSuperview];
        self.genderHeader = nil;
    }
    
        __weak BrandsVIewController *weakSelf = self;
    self.genderHeader = [[GenderHeaderView alloc] initWithFrame:CGRectMake(0, -genderViewHeight+5, self.view.frame.size.width, kGenderViewHeight)];
    [self.genderHeader setBackgroundColor:[UIColor whiteColor]];
    
    NSArray *genderArray = [NSArray arrayWithObjects:@"Women",@"Men", nil];

    
    NSMutableArray *catArray = [[NSMutableArray alloc] initWithCapacity:[genderArray count]];
    for (int catCount = 0; catCount<[genderArray count]; catCount++) {
        GenderHeaderModel *theModel = [[GenderHeaderModel alloc] init];
        if([[self.selectedGenderFilter capitalizedString] isEqualToString:[genderArray objectAtIndex:catCount]]){
            self.genderHeader.defaultGenderIndex = catCount;
        }
        [theModel setTheGenderDisplayName:[genderArray objectAtIndex:catCount]];
        [theModel setTheGenderValue:[genderArray objectAtIndex:catCount]];
        [theModel setTheGenderSelectedImageName:[NSString stringWithFormat:@"%@_selected",[genderArray objectAtIndex:catCount]]];
        [theModel setTheGenderImageName:[genderArray objectAtIndex:catCount]];
        
        [catArray addObject:theModel];
    }

    
    NSArray *theDataArray =[self.genderHeader configureViewWithData:catArray withSelectedObjectAtIndex:0];
    [self.genderHeader setGenderScrollerToDefaultIndex:self.genderHeader.defaultGenderIndex];
    self.genderHeader.onTapAction = ^(id sender){
        [weakSelf changeCategory:sender withArray:theDataArray];
    };
    [self.view addSubview:self.genderHeader];
    
//    if (genderLine) {
//        [genderLine removeFromSuperview];
//        genderLine = nil;
//    }
//    genderLine = [[SSLine alloc] initWithFrame:CGRectMake(0, self.genderHeader.frame.origin.y +self.genderHeader.frame.size.height-1, self.genderHeader.frame.size.width, 1)];
//    [self.view addSubview:genderLine];

    
}

-(void)changeCategory:(id)sender withArray:(NSArray *)theArray{
    CustomViewForCategory *tappedView = (CustomViewForCategory *)sender;
    [self.genderHeader updateScroller:sender withAnimation:TRUE];
    
    if(self.navigationView){
        [self.navigationView removeFromSuperview];
        self.navigationView = nil;
    }
    
    self.navigationView = [self configureNavigationView:[tappedView.headerTitle.text capitalizedString]];
    self.navigationItem.titleView  = self.navigationView;
  [self.navigationController.navigationBar setFont:[UIFont fontWithName:kMontserrat_Regular size:16.0f] withColor:UIColorFromRGB(kDarkPurpleColor)];    
    
    if(self.brandCollectionView){
        [self.brandCollectionView removeFromSuperview];
        self.brandCollectionView = nil;
    }
    
    self.selectedGenderFilter = [tappedView.headerTitle.text lowercaseString];
    [self generateGenderGridView:self.selectedGenderFilter];
    
}

- (void)animateScrollerToPosition:(CGPoint)endPosition{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3f];
    [self.genderHeader.scrollLineBar setFrame:CGRectMake(endPosition.x,self.genderHeader.scrollLineBar.frame.origin.y, self.genderHeader.scrollLineBar.frame.size.width, self.genderHeader.scrollLineBar.frame.size.height)];
    [UIView commitAnimations];
    
}


- (void)fetchBrandsServiceDataForPageNumer:(int)thePageNumber andGender:(NSString *)gender{

    [self.view addSubview:brandsLoader];
    [brandsLoader startAnimating];
    if(self.blankBrandsPage){
        [self.blankBrandsPage removeFromSuperview];
        self.blankBrandsPage = nil;
    }

    if([userDefaults valueForKey:@"latitude"] && [userDefaults valueForKey:@"longitude"]){
        latitude = [[userDefaults valueForKey:@"latitude"] stringValue];
        longitude = [[userDefaults valueForKey:@"longitude"] stringValue];
        city = [[userDefaults objectForKey:@"city"] lowercaseString];
    }
    
    if(self.tabRequestHandler == nil){
        self.tabRequestHandler = [[HomeRequestHandler alloc] init];
    }
    self.tabRequestHandler.profileBrands = self.isProfileBrand;
    
    serviceInProgress = TRUE;
    NSMutableDictionary *theParams = [[NSMutableDictionary alloc] init];
    [theParams setObject:[NSString stringWithFormat:@"%d",thePageNumber] forKey:@"page"];

    if(self.isProfileBrand){
        [theParams setObject:@"brand" forKey:@"type"];
        self.brandGridView.theGridViewType = GridViewTypeMyBrand;
    }
    else{
        [theParams setObject:gender forKey:@"gender"];
    }
    
    [self.tabRequestHandler fetchBrandsTabDataWithParameters:theParams withRequestCompletionhandler:^(id responseData, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^(void){
            [brandsLoader stopAnimating];
            [brandsLoader removeFromSuperview];
        });
        
        if(!error){
            if([[responseData objectForKey:@"items"] count] > 0){
                
                if(brandPagination){
                    brandPagination = nil;
                }
                brandPagination = [[PaginationData alloc] initWithDictionary:[responseData objectForKey:@"page"]];
                if(!brandPagination.hasNext){
                    self.brandGridView.shouldHideLoaderSection = YES;
                }else{
                    self.brandGridView.shouldHideLoaderSection = NO;
                }
                NSArray  *itemsData = [responseData objectForKey:@"items"];
                
                if([itemsData count]>0){
                    [self.brandGridView.parsedDataArray addObjectsFromArray:[SSUtility parseJSON:itemsData forGridView:self.brandGridView]];
                    dispatch_async(dispatch_get_main_queue(), ^(void){
                        [self.brandGridView addCollectionView];
                        self.brandGridView.collectionView.alwaysBounceVertical = true;
                    });
                }else{
                    
                    //                __weak BrandsVIewController *weakSelf = self;
                    if(self.isProfileBrand){
                        [self displayBlankPage:ErrorNoBrands];
                        if(isGenderViewVisible){
                            [self showGenderView];
                        }
                    }else{
                        [self displayBlankPage:ErrorEmptyBrandsTab];
                        if(isGenderViewVisible){
                            [self showGenderView];
                        }
                    }
                }
                serviceInProgress = FALSE;
            }else{
                if(self.isProfileBrand){
                    [self displayBlankPage:ErrorNoBrands];
                    if(isGenderViewVisible){
                        [self showGenderView];
                    }
                }else{
                    [self displayBlankPage:ErrorEmptyBrandsTab];
                    if(isGenderViewVisible){
                        [self showGenderView];
                    }
                    
                }
            }
        }else{
            [self displayBlankPage:ErrorSystemDown];
            if(isGenderViewVisible){
                [self showGenderView];
            }
        }
    }
     
     ];
    [self.view addSubview:self.brandGridView];
}



- (void)displayBlankPage:(ErrorBlankImage)pageType{
    if(self.blankBrandsPage){
        [self.blankBrandsPage removeFromSuperview];
        self.blankBrandsPage = nil;
    }
    self.blankBrandsPage = [[FyndBlankPage alloc] initWithFrame:CGRectMake(10, 10, self.view.frame.size.width-20, self.view.frame.size.height- (20 +64+44)) blankPageType:pageType];
    __weak BrandsVIewController *controller = self;
    self.blankBrandsPage.blankPageBlock=^(){
        if(pageType == ErrorNoBrands){
            [controller.tabBarController setSelectedIndex:1];
        }
        else if(pageType == ErrorSystemDown){
            [controller tapOnRetry];
        }else if (pageType == ErrorEmptyBrandsTab){
            [controller.tabBarController setSelectedIndex:0];
        }
    };
    [self.view addSubview:self.blankBrandsPage];
}


- (void)tapOnRetry{
    if(self.blankBrandsPage){
        [self.blankBrandsPage removeFromSuperview];
        self.blankBrandsPage = nil;
    }
    [self fetchBrandsServiceDataForPageNumer:1 andGender:self.selectedGenderFilter];
}



- (void)configureNewBrandsRowsIndexPath{
 
    NSMutableArray *indexSetArray = [[NSMutableArray alloc] initWithCapacity:0];
    for(int i = 0; i < newBrandsCount - initialBrandsCount; i++){
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i+initialBrandsCount +1 inSection:0];
        [indexSetArray addObject:indexPath];
    }
    [self.brandCollectionView insertItemsAtIndexPaths:indexSetArray];
}


- (void)configureBrandCollectionView{

    if(self.brandCollectionView){
        [self.brandCollectionView removeFromSuperview];
        self.brandCollectionView = nil;
    }
    UICollectionViewFlowLayout *layout=[[UICollectionViewFlowLayout alloc] init];
    CGFloat heightForCollection = 0.0f;
    if (self.isProfileBrand) {
        heightForCollection =  self.view.frame.size.height-(self.genderHeader.frame.origin.y + self.genderHeader.frame.size.height);
    }else{
        heightForCollection =  self.view.frame.size.height-(50+ self.genderHeader.frame.origin.y + self.genderHeader.frame.size.height);
    }
    self.brandCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, self.genderHeader.frame.origin.y + self.genderHeader.frame.size.height, self.view.frame.size.width, heightForCollection) collectionViewLayout:layout];
    [self.brandCollectionView setBackgroundColor:[UIColor whiteColor]];
    [self.brandCollectionView registerClass:[BrandsGrid class] forCellWithReuseIdentifier:@"Brand"];
    self.brandCollectionView.dataSource = self;
    self.brandCollectionView.delegate = self;
    [self.view addSubview:self.brandCollectionView];
}


- (void)showPDPScreen:(NSString *)url{
    if(self.pdpController){
        self.pdpController = nil;
    }
    self.pdpController = [[PDPViewController alloc] init];
    self.pdpController.productURL = url;
    [self.navigationController pushViewController:self.pdpController animated:YES];
}



#pragma GridView Delegate Methods

- (void)showBrandProductPDP:(NSString *)pdpUrl{
    [self showPDPScreen:pdpUrl];
}

/*
- (void)showCollectionProductPDP:(NSString *)collectionURL{
    [self showPDPScreen:collectionURL];
}
 */



#pragma delegates nd datasources

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    BrandTileModel *brandData = [brandServiceData.brandArray objectAtIndex:indexPath.row];
    CGFloat height = [self calculateBrandCellHeight:brandData];
    CGSize cellSize = CGSizeMake(self.view.frame.size.width-20,height);
    return cellSize;
}


-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return [brandServiceData.brandArray count];
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    BrandsGrid *cell = (BrandsGrid *)[collectionView dequeueReusableCellWithReuseIdentifier:@"Brand" forIndexPath:indexPath];
//    cell.currentBrandData = [self.brandArray objectAtIndex:indexPath.row];
    cell.currentBrandData = [brandServiceData.brandArray objectAtIndex:indexPath.row];

    CGFloat calculatedWidth = ((self.view.frame.size.width - 2*kGridComponentPadding) - 2*kGridComponentPadding)/3.5;
    if(cell.currentBrandData.products && [cell.currentBrandData.products count]>0)
    {
        SubProductModel *subProduct = [cell.currentBrandData.products objectAtIndex:0];
        CGFloat productContainerHeight = [self getProductsAspectRatio:subProduct.subProductAspectRatio andWidth:calculatedWidth];
        CGSize aSize = CGSizeMake(calculatedWidth,productContainerHeight);
        cell.brandCollectionViewSize = aSize;
    }

    cell.brandBannerWidth = self.view.frame.size.width;
//    [cell configureBrandGrid];
    
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
//    BrandTileModel *model = [brandServiceData.brandArray objectAtIndex:indexPath.row] action] url];
    
    BrowseByBrandViewController *browseByBrandController = [[BrowseByBrandViewController alloc] init];
    browseByBrandController.isProfileBrand = self.isProfileBrand;
    BrandTileModel *currentBrand = [brandServiceData.brandArray objectAtIndex:indexPath.row];
    [browseByBrandController parseURL:currentBrand.action.url];
    [self.navigationController pushViewController:browseByBrandController animated:YES];
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath{
    
//    AnimationViewController *animateViewController = [[AnimationViewController alloc] init];
//    animateViewController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
//    [self.navigationController presentViewController:animateViewController animated:TRUE completion:nil];
}

CGSize brandCellDynamicSize ;
- (CGFloat)calculateBrandCellHeight:(BrandTileModel *)brandData{
    CGRect fixedRect =  CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 50 - 64);
    CGFloat dynamicHeight = 0.0f;
    CGFloat bannerDynamicHeight = [self getHeightFromAspectRatio:brandData.brandBannerAspectRatio andWidth:self.view.frame.size.width];
    dynamicHeight += bannerDynamicHeight + kGridComponentPadding;
    
    brandCellDynamicSize = [SSUtility getLabelDynamicSize:brandData.banner_title withFont:[UIFont fontWithName:@"Helvetica-Bold" size:15.0f] withSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
    dynamicHeight += kGridComponentPadding + brandCellDynamicSize.height;
    
    NSString *modifiedString = [NSString stringWithFormat:@"Nearest %@",brandData.nearest_store];
    brandCellDynamicSize = [SSUtility getLabelDynamicSize:modifiedString withFont:[UIFont fontWithName:@"HelveticaNeue" size:10.0f] withSize:CGSizeMake(250, MAXFLOAT)];
    dynamicHeight += kGridComponentPadding + brandCellDynamicSize.height;
    
    CGFloat calculatedWidth = ((fixedRect.size.width - 2*kGridComponentPadding) - 2*kGridComponentPadding)/3.5;
    
    
    if(brandData.products && [brandData.products count]>0) // If any brnad is having some producs then only need to calculate height
    {
        SubProductModel *subProduct = [brandData.products objectAtIndex:0]; // TODO
        CGFloat productContainerHeight = [self getProductsAspectRatio:subProduct.subProductAspectRatio andWidth:calculatedWidth];
        brandProductSize = CGSizeMake(calculatedWidth,productContainerHeight);
        dynamicHeight += productContainerHeight + kGridComponentPadding;

    }
    
    dynamicHeight += kGridComponentPadding + 60;
    return dynamicHeight;
}



-(CGFloat)getHeightFromAspectRatio:(NSString *)aspectRatio andWidth:(CGFloat)width{
    CGFloat height = 0;
    NSArray *ratioArray = [aspectRatio componentsSeparatedByString:@":"];
    height = (width - RelativeSize(20, 320)) * [[ratioArray lastObject] floatValue] / [[ratioArray firstObject] floatValue];
    return height;
}


- (CGFloat)getProductsAspectRatio:(NSString *)aspectRatio andWidth:(CGFloat)width{
    CGFloat height = 0;
    NSArray *ratioArray = [aspectRatio componentsSeparatedByString:@":"];
    height = (width) * [[ratioArray lastObject] floatValue] / [[ratioArray firstObject] floatValue];
    return height;
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:TRUE];

    [self updateNotificationIcon];

    [self fetchStoredUser];
    
    [self.navigationController.navigationBar changeNavigationBarToTransparent:FALSE];
    [[[UIApplication sharedApplication] keyWindow] setBackgroundColor:[UIColor whiteColor]];        

//    if([[[NSUserDefaults standardUserDefaults] valueForKey:@"refreshBrands"] boolValue])
    if(([[[NSUserDefaults standardUserDefaults] valueForKey:@"refreshBrands"] boolValue] || genderValueChanged )&& !self.isProfileBrand)
    {
        if(self.brandGridView){
            [self.brandGridView.parsedDataArray removeAllObjects];
            [self.brandGridView removeFromSuperview];
            self.brandGridView = nil;
        }
        self.brandGridView = [[GridView alloc] initWithFrame:CGRectMake(0, RelativeSize(3, 320), self.view.frame.size.width, self.view.frame.size.height)];
        
        self.brandGridView.delegate = self;
        
        
        latitude = [[userDefaults objectForKey:@"latitude"] stringValue];
        longitude = [[userDefaults objectForKey:@"longitude"] stringValue];
        city = [[userDefaults objectForKey:@"city"] lowercaseString];
        [self fetchBrandsServiceDataForPageNumer:1 andGender:self.selectedGenderFilter];
        [[NSUserDefaults standardUserDefaults] setBool:FALSE forKey:@"refreshBrands"];
        
        
        if(genderValueChanged){
//            isGenderViewVisible =!isGenderViewVisible;
            isGenderViewVisible = FALSE;
            if(self.genderHeader){
                [self.genderHeader removeFromSuperview];
                self.genderHeader = nil;
            }
                self.navigationView = [self configureNavigationView:[self.selectedGenderFilter capitalizedString]];
                self.navigationItem.titleView = self.navigationView;
            }
        }
    }


- (void)fetchStoredUser{
    genderValueChanged = false;
    FyndUser *loggedInIUser = [SSUtility loadUserObjectWithKey:kFyndUserKey];
    if([[userDefaults objectForKey:@"isLaunchedViaBranch"] boolValue]){
        NSArray *params = [userDefaults objectForKey:@"BranchParameters"];
        self.selectedGenderFilter = [[params objectAtIndex:0] objectForKey:@"gender"];
    }else{
        NSString *storedGender = [userDefaults objectForKey:@"StoredGender"];
        
        if(storedGender && storedGender !=nil){
            if(![storedGender isEqualToString:self.selectedGenderFilter]){
                genderValueChanged = TRUE;
            }
        }
        
        if(storedGender && storedGender!=nil){
            self.selectedGenderFilter = storedGender;
        }else{
            self.selectedGenderFilter = loggedInIUser.gender;
        }
        
    }
    
    if(self.selectedGenderFilter && self.selectedGenderFilter!=nil)
        [userDefaults setObject:self.selectedGenderFilter forKey:@"StoredGender"];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    //Testing - Moving above lines to view will appear
//    [self.navigationController.navigationBar changeNavigationBarToTransparent:FALSE];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:TRUE];
    [self.navigationController.view setBackgroundColor:[UIColor whiteColor]];
    [self resetBars];
}

-(void)locationUpdated : (NSNotification *) notification{
    
//    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
//    NSArray *placemarks= [userDefaults objectForKey:@"location"];
    NSArray *placemarks = notification.object;
    
    @try {
        CLPlacemark *placemark = [placemarks objectAtIndex:0];
        
        NSString *locatedAt = [[placemark.addressDictionary valueForKey:@"FormattedAddressLines"] componentsJoinedByString:@", "];
        [addressValue setText:locatedAt];
        
        [areaValue setText: [[NSString alloc]initWithString:placemark.locality]];
        [countryValue setText: [[NSString alloc]initWithString:placemark.country]];
        
        
        [regionValue setText:[[NSString alloc] initWithString: placemark.region.identifier]];
        [countryValue setText:[[NSString alloc] initWithString: placemark.country]];
        
        [nameValue setText:placemark.name];
        [oceanValue setText:placemark.ocean];
        [postalCodeValue setText:placemark.postalCode];
        [subLocalityValue setText:placemark.subLocality];
        [locationValue setText:placemark.location.description];

    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
    
    
}

-(void)beginSearch{
    __weak BrandsVIewController *weakSelf = self;
    theSearchViewController = [[SearchViewController alloc] init];
    theSearchViewController.thePushBlock = ^(NSString *stringParam, NSString *theURLString,NSString *theCategoryName, NSString *parentCategory, NSString *gender, AutoSuggestModel *searchModel){
        if ([[stringParam uppercaseString] isEqualToString:@"PRODUCT"]) {
           PDPViewController * pdpViewController = [[PDPViewController alloc] init];
            pdpViewController.productURL = theURLString;
            [weakSelf.navigationController pushViewController:pdpViewController animated:TRUE];

        }else if ([[stringParam uppercaseString] isEqualToString:@"BRAND"]){
           BrowseByBrandViewController * brandController = [[BrowseByBrandViewController alloc] init];
//            if(weakSelf.selectedGenderFilter){
//                brandController.gender = weakSelf.selectedGenderFilter;
//            }
            brandController.isProfileBrand = TRUE;
            [brandController parseURL:theURLString];
            [weakSelf.navigationController pushViewController:brandController animated:TRUE];

        }else if ([[stringParam uppercaseString] isEqualToString:@"COLLECTION"]){
           BrowseByCollectionViewController *theBrowseController = [[BrowseByCollectionViewController alloc] init];
//            if(weakSelf.selectedGenderFilter){
//                theBrowseController.gender = weakSelf.selectedGenderFilter;
//            }
            theBrowseController.isProfileCollection= TRUE;
            [theBrowseController parseURL:theURLString];
            [weakSelf.navigationController pushViewController:theBrowseController animated:TRUE];
            
        }else if ([[stringParam uppercaseString] isEqualToString:@"CATEGORY"] || [[stringParam uppercaseString] isEqualToString:@"FREETEXT"]){
            BrowseByCategoryViewController *theCategoryView = [[BrowseByCategoryViewController alloc] init];
            
            if([[stringParam uppercaseString] isEqualToString:@"FREETEXT"]){
                theCategoryView.screenType = BrowseTypeSearch;
                if(searchModel && searchModel != nil){
                    
                    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                    [formatter setDateFormat:@"YYYY-MM-dd'T'HH:mm:ss"];
                    NSDate *now = [NSDate date];
                    NSString *dateString = [formatter stringFromDate:now];

    
                    [FyndAnalytics trackSearchEventFrom:@"brand" searchString:searchModel.displayName searchDate:dateString];
                }
            }else{
                theCategoryView.screenType = BrowseTypeBrwose;
                [FyndAnalytics trackCategoryEvent:gender category:parentCategory subcategory:theCategoryName];
            }
            theCategoryView.theProductURL = theURLString;
            theCategoryView.theCategory = theCategoryName;
            [weakSelf.navigationController pushViewController:theCategoryView animated:TRUE];
        }
    };
    [self.navigationController presentViewController:theSearchViewController animated:TRUE completion:nil];

}

-(void)updateNotificationIcon{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    BOOL newNotifications = [defaults boolForKey:kNewNotificationKey];
    if(newNotifications){
        [notificationIcon setImage:[[UIImage imageNamed:@"NotificationActive"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
        
    }else{
        [notificationIcon setImage:[UIImage imageNamed:@"Notification"]];
    }
}


//-(void)searchLocation{
//    
//    if(searchViewController){
//        searchViewController.delegate = nil;
//        searchViewController = nil;
//    }
//    
//    searchViewController = [[LocationSearchViewController alloc] init];
//    searchViewController.delegate = self;
//    navController = [[UINavigationController alloc] initWithRootViewController:searchViewController];
//    
//    [self presentViewController:navController
//                       animated:YES
//                     completion:^{
//                         
//                     }];
//}
//
//
//
//#pragma Mark - LocationSelector Delegate
//
//-(void)didSelectLocation{
//    [searchViewController dismissLocationSearch];
//    [self fetchBrandsServiceDataForPageNumer:1 andGender:self.selectedGenderFilter];
//}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// TO DO - to be mergered with the normal call ---- AMBOJ

//- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
//    if(scrollView.contentOffset.y + scrollView.frame.size.height + 20 >= self.brandCollectionView.contentSize.height)
//    {
//        if(brandPagination.hasNext && !serviceInProgress){
//            [self fetchBrandsServiceDataForPageNumer:2 andGender:@"men"];
//        }
//    }
//    
//    
//}


#pragma mark - Grid View Delegate Method
-(void)didScrollToEndOfLastPage{
    
    brandPageNumber++;
    
    NSDictionary *paramDict = @{@"page":[NSString stringWithFormat:@"%d", brandPageNumber],@"gender":[NSString stringWithFormat:@"%@",self.selectedGenderFilter]};

    NSInteger prevLastIndex = [self.brandGridView.parsedDataArray count] - 1;
    __block NSInteger newLastIndex = 0;
    
    if(brandPagination.hasNext){

        [self.tabRequestHandler fetchBrandsTabDataWithParameters:paramDict withRequestCompletionhandler:^(id responseData, NSError *error){
            [self.brandGridView.parsedDataArray addObjectsFromArray:[SSUtility parseJSON:[responseData objectForKey:@"items"] forGridView:self.brandGridView]];
            newLastIndex = [self.brandGridView.parsedDataArray count] - 1;
            
            NSMutableArray *indexSetArray = [[NSMutableArray alloc] initWithCapacity:0];
            for(int i = 0; i < newLastIndex - prevLastIndex; i++){
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i+prevLastIndex +1 inSection:0];
                [indexSetArray addObject:indexPath];
            }
            if(brandPagination){
                brandPagination = nil;
            }
            brandPagination = [[PaginationData alloc] initWithDictionary:[responseData objectForKey:@"page"]];
            if(!brandPagination.hasNext){
                self.brandGridView.shouldHideLoaderSection = YES;
            }else{
                self.brandGridView.shouldHideLoaderSection = NO;
            }
            dispatch_async(dispatch_get_main_queue(), ^(void){
                [self.brandGridView reloadCollectionView:indexSetArray];
            });
        }];
    }
}

- (void)showBrowseByBrandPage:(NSString *)url{
    if(self.browseByBrandController){
        self.browseByBrandController = nil;
    }
    self.browseByBrandController = [[BrowseByBrandViewController alloc] init];
    self.browseByBrandController.isProfileBrand = self.isProfileBrand;

    if(self.selectedGenderFilter){
        self.browseByBrandController.gender = self.selectedGenderFilter;
    }
    [self.browseByBrandController parseURL:url];
    [self.navigationController pushViewController:self.browseByBrandController animated:YES];
}

-(void)showBrowseByCollectionPage:(NSString *)url{
    if(self.browseByCollectionController){
        self.browseByCollectionController = nil;
    }
    self.browseByCollectionController = [[BrowseByCollectionViewController alloc] init];
    if(self.selectedGenderFilter){
        self.browseByCollectionController.gender = self.selectedGenderFilter;
    }
    [self.browseByCollectionController parseURL:url];
    
    [self.navigationController pushViewController:self.browseByCollectionController animated:YES];
}

-(void)gridViewDidScroll:(UIScrollView *)scrollView{
    [self manageBarsWithScroll:scrollView forGridView:self.brandGridView];
}

 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }

#pragma mark - Bars Methods
-(void)manageBarsWithScroll:(UIScrollView *)scrollView forGridView:(GridView *)theGridView{
    
    hideBars = TRUE;
    
    if([[[UIDevice currentDevice] systemVersion] floatValue] < 7.0f){
        return;
    }
    
    CGRect navFrame = self.navigationController.navigationBar.frame;
    CGFloat navSize = navFrame.size.height - 21;
    
    CGRect tabBarFrame = self.tabBarController.tabBar.frame;
    CGFloat tabHeight = tabBarFrame.size.height;
    if (self.isProfileBrand) {
        tabHeight = 0.0f;
    }
    CGRect genderFrame =self.genderHeader.frame;
    CGFloat genderFrameSize = genderFrame.size.height;
    
    if([scrollView.panGestureRecognizer translationInView:self.view].y < 0)
    {
        if (isGenderViewVisible) {
            genderFrame.origin.y = - genderFrameSize;
        }
        navFrame.origin.y = -navSize;
        if (self.isProfileBrand) {
            tabHeight = 50;
        }
        tabBarFrame.origin.y = kDeviceHeight + tabHeight;
        hideBars = TRUE;
    }
    else if([scrollView.panGestureRecognizer translationInView:self.view].y > 0)
    {
        navFrame.origin.y = 20;
        if (self.isProfileBrand) {
            tabHeight = 0;
        }
        tabBarFrame.origin.y = kDeviceHeight - tabHeight;
        hideBars = FALSE;
    }
    
    if(!isScrolling){
        isScrolling = TRUE;
        NSTimeInterval duration = 0.0;
        if (isGenderViewVisible) {
            duration = 0.4;
        }
        [UIView animateKeyframesWithDuration:duration delay:0.0 options:UIViewKeyframeAnimationOptionCalculationModeLinear animations:^{
            if (isGenderViewVisible) {
                UIImageView *imageView = (UIImageView *)[self.navigationView viewWithTag:1234];
                imageView.transform = CGAffineTransformMakeRotation(DEGREES_TO_RADIANS(360));
                [self.genderHeader setFrame:genderFrame];
                [self.genderHeader setAlpha:0.0];
                isGenderViewVisible = !isGenderViewVisible;
                [theGridView setFrame:CGRectMake(theGridView.frame.origin.x, 0, theGridView.frame.size.width, theGridView.frame.size.height + self.genderHeader.frame.size.height+5)];
            }
            
        } completion:^(BOOL finished) {
            
            [UIView animateWithDuration:0.1 animations:^{
                if (hideBars) {
                    [self.view setFrame:CGRectMake(self.view.frame.origin.x, navFrame.origin.y + navFrame.size.height, self.view.frame.size.width, tabBarFrame.origin.y - 20)];
                    [theGridView setFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - tabBarFrame.size.height)];
                    [theGridView.collectionView setFrame:CGRectMake(theGridView.collectionView.frame.origin.x, theGridView.collectionView.frame.origin.y, theGridView.collectionView.frame.size.width, theGridView.frame.size.height)];
                }
                
            } completion:^(BOOL finished) {
                [UIView animateWithDuration:0.4 animations:^{
                    if(!hideBars){
                        [self.navigationController.navigationBar setAlpha:1.0];
                        
                    [self.view setFrame:CGRectMake(self.view.frame.origin.x, navFrame.origin.y + navFrame.size.height, self.view.frame.size.width, tabBarFrame.origin.y - 20)];
                    [theGridView setFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
                    [theGridView.collectionView setFrame:CGRectMake(theGridView.collectionView.frame.origin.x, theGridView.collectionView.frame.origin.y, theGridView.collectionView.frame.size.width, theGridView.frame.size.height)];
                    }
                    [self.navigationController.navigationBar setFrame:navFrame];
                    [self.tabBarController.tabBar setFrame:tabBarFrame];
                    
                } completion:^(BOOL finished) {
                    if(hideBars){
                        self.navigationController.view.backgroundColor = [UIColor whiteColor];
                        self.navigationController.navigationBar.alpha = 0.0;
                    }
                    isScrolling = FALSE;
                }];
                
            }];
        }];
    }
}

-(void)resetBars{
    [self.navigationController.navigationBar setAlpha:1.0];
    CGRect navFrame = self.navigationController.navigationBar.frame;
    navFrame.origin.y = 20;
    [self.navigationController.navigationBar setFrame:navFrame];
    
    //Resetting the tab bar data
    
    CGRect tabFrame = self.tabBarController.tabBar.frame;
    tabFrame.origin.y = kDeviceHeight - tabFrame.size.height;
    [self.tabBarController.tabBar setFrame:tabFrame];
    
}
#pragma mark - Brand Tile Deletion Methods
-(void)deleteAtPoint:(UITouch *)loc{
    
//    CGPoint pt = [loc locationInView:self.superview];
//    
//    NSIndexPath *indexPath = [myCollectionView indexPathForItemAtPoint:pt];
//    [self.parsedDataArray removeObjectAtIndex:indexPath.row];
//    flow.dataArray = self.parsedDataArray;
    
   
}

-(BOOL)hidesBottomBarWhenPushed{
    if (self.isProfileBrand) {
        return YES;
    }else{
        return NO;
    }
}




@end
