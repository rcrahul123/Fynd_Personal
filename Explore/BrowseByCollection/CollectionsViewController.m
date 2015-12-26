//
//  CollectionsViewController.m
//  Explore
//
//  Created by Rahul Chaudhari on 29/07/15.
//  Copyright (c) 2015 Rahul. All rights reserved.
//

#import "CollectionsViewController.h"
#import "LocationSearchViewController.h"
#import "SearchViewController.h"
#import "BrowseByBrandViewController.h"
#import "BrowseByCollectionViewController.h"
#import "HomeRequestHandler.h"
#import "CollectionTabData.h"
#import "BrowseByCategoryViewController.h"
#import "GridView.h"
#import "GenderHeaderView.h"
#import "GenderHeaderModel.h"
#import "FyndAnalytics.h"

@interface CollectionsViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,GridViewDelegate>
{
    SearchViewController *theSearchViewController;
    LocationSearchViewController *locationSearchViewController;
    
    CGSize collectionProductSize;
    CollectionTabData    *collectionServiceData;
    SSLine *genderLine;
    BOOL hideBars;
    BOOL isScrolling;
    BOOL    collectionGenderValueChanged;
}
@property (nonatomic,strong) NSMutableArray *collectionArray;
@property (nonatomic,strong) UICollectionView *collectionsCollectionView;
@property (nonatomic,strong) HomeRequestHandler  *tabRequestHandler;
@property (nonatomic,strong) GridView           *collectionGridView;
@property (nonatomic, strong) PDPViewController *pdpController;
@property (nonatomic,strong) UIView *navigationView;
@property (nonatomic, strong) BrowseByBrandViewController *browseByBrandController;
@property (nonatomic,strong) UIActivityIndicatorView *activityIndicator;
@property (nonatomic, strong) BrowseByCollectionViewController *browseByCollectionController;
@property (nonatomic,strong) GenderHeaderView    *genderHeader;
@property (nonatomic,strong) NSString       *selectedGenderFilter;
@property (nonatomic,strong) FyndBlankPage *blankCollectionsPage;

- (void)configureCollectionsCollectionView;


@end

@implementation CollectionsViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.

    userDefaults = [NSUserDefaults standardUserDefaults];
    
    
//    FyndUser *loggedInIUser = [SSUtility loadUserObjectWithKey:kFyndUserKey];
    if(!self.isProfileCollection){
        
        /*
        if([[userDefaults objectForKey:@"isLaunchedViaBranch"] boolValue]){
            NSArray *params = [userDefaults objectForKey:@"BranchParameters"];
            NSLog(@"params   ------   %@",[params description]);
            self.selectedGenderFilter = [[params objectAtIndex:0] objectForKey:@"gender"];
            NSLog(@"self.selectedGenderFilter    %@",self.selectedGenderFilter);
        }else{
            NSString *storedGender = [userDefaults objectForKey:@"StoredGender"];
            if(storedGender && storedGender!=nil){
                self.selectedGenderFilter = storedGender;
            }else{
                self.selectedGenderFilter = loggedInIUser.gender;
            }
        }
        
        if(self.selectedGenderFilter && self.selectedGenderFilter!=nil)
            [userDefaults setObject:self.selectedGenderFilter forKey:@"StoredGender"];
        */
    
        [self fetchStoredUser];
        
//        self.navigationView = [self configureNavigationView:[loggedInIUser.gender capitalizedString]];
        self.navigationView = [self configureNavigationView:[self.selectedGenderFilter capitalizedString]];
        self.navigationItem.titleView = self.navigationView;
        
        searchButton = [[UIBarButtonItem alloc] init];
        [searchButton setImage:[UIImage imageNamed:@"SearchBrowse"]];
        [searchButton setTarget:self];
        [searchButton setAction:@selector(beginSearch)];
        
        self.navigationItem.rightBarButtonItems = @[searchButton];
        
        collectionPageNumber = 1;
        notificationIcon = [[UIBarButtonItem alloc] init];
        [notificationIcon setImage:[UIImage imageNamed:@"Notification"]];
        [notificationIcon setTarget:self];
        [notificationIcon setAction:@selector(showNotifications)];
        self.navigationItem.leftBarButtonItem = notificationIcon;
    }else{
        self.title = @"My Collections";
        [self.navigationController.navigationBar setFont:[UIFont fontWithName:kMontserrat_Regular size:16.0f] withColor:UIColorFromRGB(kDarkPurpleColor)];
        self.navigationController.navigationBar.topItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    }
    self.collectionGridView = [[GridView alloc] initWithFrame:CGRectMake(0, RelativeSize(3, 320), self.view.frame.size.width, self.view.frame.size.height - 64)];
    self.collectionGridView.collectionView.scrollsToTop = YES;

    [self.navigationController.navigationBar setFont:[UIFont fontWithName:kMontserrat_Regular size:16.0f] withColor:UIColorFromRGB(kDarkPurpleColor)];
    self.collectionGridView.delegate = self;
    self.automaticallyAdjustsScrollViewInsets = NO;
//    self.selectedGenderFilter = loggedInIUser.gender;
  
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
    
    
    
    self.collectionGridView.collectionView.alwaysBounceVertical= true;

    collectionLoader = [[FyndActivityIndicator alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    [collectionLoader setCenter:CGPointMake(self.collectionGridView.frame.size.width/2, self.collectionGridView.frame.size.height/2 - 30)];

    
    [self fetchCollectionServiceData:1 andGender:self.selectedGenderFilter];
    [SSUtility removeBranchStoredData];
    
    
    [self.view setBackgroundColor:UIColorFromRGB(kBackgroundGreyColor)];

    if (self.isProfileCollection) {
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
    [navigationView setBackgroundColor:[UIColor whiteColor]];
    
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showGenderView)];
    [navigationView addGestureRecognizer:gesture];
    CGSize aSize = [SSUtility getLabelDynamicSize:optionString withFont:[UIFont fontWithName:kMontserrat_Light size:16.0f] withSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
    
    UILabel *navigationViewLabel = [[UILabel alloc] initWithFrame:CGRectMake(navigationView.frame.size.width/2 - aSize.width/2,navigationView.frame.size.height/2 - aSize.height/2 , aSize.width, aSize.height)];
    [navigationViewLabel setBackgroundColor:[UIColor clearColor]];
    [navigationViewLabel setText:optionString];
    [navigationViewLabel setTextColor:UIColorFromRGB(kSignUpColor)];
    [navigationViewLabel setFont:[UIFont fontWithName:kMontserrat_Light size:16.0]];
    [navigationViewLabel setTextAlignment:NSTextAlignmentCenter];
    [navigationView addSubview:navigationViewLabel];
    
    UIImage *image = [UIImage imageNamed:@"Down"];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(navigationViewLabel.frame.origin.x + navigationViewLabel.frame.size.width, navigationViewLabel.frame.size.height - image.size.height/2, image.size.width, image.size.height)];;
    imageView.tag = 2345;
    [imageView setBackgroundColor:[UIColor clearColor]];
    
    [imageView setImage:image];
    [imageView setCenter:CGPointMake(imageView.center.x, navigationView.frame.size.height/2)];
    [navigationView addSubview:imageView];
    
    if (isGenderViewVisible) {
        imageView.transform = CGAffineTransformMakeRotation(DEGREES_TO_RADIANS(180));
    }
    
    return navigationView;
}



CGPoint startPoint1;
CGPoint endPoint1;
-(void)showGenderView{
    //    [self generateHeaderView];
    isGenderViewVisible = !isGenderViewVisible;
    if(isGenderViewVisible){
        [self generateHeaderView];
    }
    if(isGenderViewVisible){
        startPoint1 = CGPointMake(self.genderHeader.frame.origin.x, -kGenderViewHeight);
        endPoint1 = CGPointMake(self.genderHeader.frame.origin.x, 0);
    }
    else{
        startPoint1 = CGPointMake(self.genderHeader.frame.origin.x, 0);
        endPoint1 = CGPointMake(self.genderHeader.frame.origin.x, -kGenderViewHeight);
    }
    
    [self animteHeader:startPoint1 toPoisition:endPoint1];
    
}


- (void)animteHeader:(CGPoint)sourcePoint toPoisition:(CGPoint)destinationPoint{
    
    UIImageView *imageView = (UIImageView *)[self.navigationView viewWithTag:2345];

    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.5f];
    [UIView setAnimationDelegate:self];
    //    [UIView setAnimationDidStopSelector:@selector(animationDidStop:finished:)];
    [self.genderHeader setFrame:CGRectMake(self.genderHeader.frame.origin.x, destinationPoint.y, self.genderHeader.frame.size.width, self.genderHeader.frame.size.height)];
    if(isGenderViewVisible){
        imageView.transform = CGAffineTransformMakeRotation(DEGREES_TO_RADIANS(180));
        [self.collectionGridView setFrame:CGRectMake(self.collectionGridView.frame.origin.x, self.genderHeader.frame.size.height, self.collectionGridView.frame.size.width, self.collectionGridView.frame.size.height - self.genderHeader.frame.size.height-5)];
    }
    else{
        imageView.transform = CGAffineTransformMakeRotation(DEGREES_TO_RADIANS(360));
        [self.collectionGridView setFrame:CGRectMake(self.collectionGridView.frame.origin.x, 0, self.collectionGridView.frame.size.width, self.collectionGridView.frame.size.height + self.genderHeader.frame.size.height+5)];
        [self.collectionGridView.collectionView setFrame:CGRectMake(self.collectionGridView.collectionView.frame.origin.x, self.collectionGridView.collectionView.frame.origin.y, self.collectionGridView.collectionView.frame.size.width, self.collectionGridView.frame.size.height)];
        
        [self.genderHeader setAlpha:0.0f];

    }
    [UIView commitAnimations];
}


- (void)generateGenderGridView:(NSString *)gender{
    
    if(self.collectionGridView){
        [self.collectionGridView.parsedDataArray removeAllObjects];
        [self.collectionGridView removeFromSuperview];
        self.collectionGridView = nil;
    }
    self.collectionGridView = [[GridView alloc] initWithFrame:CGRectMake(0, self.genderHeader.frame.size.height, self.view.frame.size.width, self.view.frame.size.height - 50 - 64)];
    self.collectionGridView.delegate = self;
    
    self.selectedGenderFilter = gender;
    [self fetchCollectionServiceData:1 andGender:self.selectedGenderFilter];
}


- (void)generateHeaderView{
    
    if(self.genderHeader){
        [self.genderHeader removeFromSuperview];
        self.genderHeader = nil;
    }
    
    __weak CollectionsViewController *weakSelf = self;
    self.genderHeader = [[GenderHeaderView alloc] initWithFrame:CGRectMake(0, -kGenderViewHeight, self.view.frame.size.width, kGenderViewHeight)];
    [self.genderHeader setBackgroundColor:[UIColor whiteColor]];
    
//    NSArray *genderArray = [NSArray arrayWithObjects:@"Men",@"Women",@"Boys",@"Girls", nil];
//     NSArray *genderArray = [NSArray arrayWithObjects:@"Women",@"Men",@"Girls",@"Boys", nil];
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
//    NSArray *theDataArray =[self.genderHeader configureViewWithData:catArray withSelectedObjectAtIndex:2];
//    [self.genderHeader setGenderScrollerToDefaultIndex:2];
    self.genderHeader.onTapAction = ^(id sender){
        [weakSelf changeCategory:sender withArray:theDataArray];
    };
    [self.view addSubview:self.genderHeader];
    
    if (genderLine) {
        [genderLine removeFromSuperview];
        genderLine = nil;
    }
    
    genderLine = [[SSLine alloc] initWithFrame:CGRectMake(0, self.genderHeader.frame.origin.y +self.genderHeader.frame.size.height-1, self.genderHeader.frame.size.width, 1)];
    [self.view addSubview:genderLine];
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
    
    if(self.collectionsCollectionView){
        [self.collectionsCollectionView removeFromSuperview];
        self.collectionsCollectionView = nil;
    }
    
    self.selectedGenderFilter = [tappedView.headerTitle.text lowercaseString];
    
    
    if(self.selectedGenderFilter && self.selectedGenderFilter!=nil)
        [userDefaults setObject:self.selectedGenderFilter forKey:@"StoredGender"];
    
    
    [self generateGenderGridView:self.selectedGenderFilter];
    
}

- (void)animateScrollerToPosition:(CGPoint)endPosition{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3f];
    [self.genderHeader.scrollLineBar setFrame:CGRectMake(endPosition.x,self.genderHeader.scrollLineBar.frame.origin.y, self.genderHeader.scrollLineBar.frame.size.width, self.genderHeader.scrollLineBar.frame.size.height)];
    [UIView commitAnimations];
    
}


- (void)fetchCollectionServiceData:(NSInteger)pageNumber andGender:(NSString *)gender{
    
    if(self.blankCollectionsPage){
        [self.blankCollectionsPage removeFromSuperview];
        self.blankCollectionsPage = nil;
    }
    
    [self.view addSubview:collectionLoader];
    [collectionLoader startAnimating];
    
    if([userDefaults valueForKey:@"latitude"] && [userDefaults valueForKey:@"longitude"]){
        latitude = [[userDefaults valueForKey:@"latitude"] stringValue];
        longitude = [[userDefaults valueForKey:@"longitude"] stringValue];
        city = [[userDefaults objectForKey:@"city"] lowercaseString];
    }
    
    if(self.tabRequestHandler == nil){
        self.tabRequestHandler = [[HomeRequestHandler alloc] init];
    }
    self.tabRequestHandler.profileCollections = self.isProfileCollection;
    collectionServiceInProgress = TRUE;
    
    NSMutableDictionary *theParams = [[NSMutableDictionary alloc] init];
    [theParams setObject:[NSString stringWithFormat:@"%ld",(long)pageNumber] forKey:@"page"];
    if(self.isProfileCollection){
        [theParams setObject:@"collection" forKey:@"type"];
        self.collectionGridView.theGridViewType = GridViewTypeMyCollection;
    }
    else{
        self.collectionGridView.theGridViewType = GridViewTypePlain;
        [theParams setObject:gender forKey:@"gender"];
    }
    [self.tabRequestHandler fetchCollectionTabDataWithParameters:theParams withRequestCompletionhandler:^(id responseData, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^(void){
            [collectionLoader stopAnimating];
            [collectionLoader removeFromSuperview];
        });
        if(!error)
        {

            
            if([[responseData objectForKey:@"items"] count] > 0){
                
                if(collectionPagination){
                    collectionPagination = nil;
                }
                collectionPagination = [[PaginationData alloc] initWithDictionary:[responseData objectForKey:@"page"]];
                if(!collectionPagination.hasNext){
                    self.collectionGridView.shouldHideLoaderSection = true;
                }else{
                    self.collectionGridView.shouldHideLoaderSection = false;
                }
                
                NSArray *collectionArray = [responseData objectForKey:@"items"];
                if([collectionArray count] > 0){
                    [self.collectionGridView.parsedDataArray addObjectsFromArray:[SSUtility parseJSON:collectionArray forGridView:self.collectionGridView]];
                    
                    dispatch_async(dispatch_get_main_queue(), ^(void){
                        [self.collectionGridView addCollectionView];
                        self.collectionGridView.collectionView.alwaysBounceVertical = YES;
                    });
                }else{
                    if(self.isProfileCollection){
                        [self displayBlankPage:ErrorNoCollections];
                    }else{
                        [self displayBlankPage:ErrorEmptyCollectionsTab];
                        if(isGenderViewVisible){
                            [self showGenderView];
                        }
                    }
                }
                
                collectionServiceInProgress = FALSE;
            }else{
                if(self.isProfileCollection){
                    [self displayBlankPage:ErrorNoCollections];
                }else{
                    [self displayBlankPage:ErrorEmptyCollectionsTab];
                    if(isGenderViewVisible){
                        [self showGenderView];
                    }
                }
            }
        }
        
        else{
            [self displayBlankPage:ErrorSystemDown];
        }
    }];
     [self.view addSubview:self.collectionGridView];
}



- (void)displayBlankPage:(ErrorBlankImage)pageType{
    if(self.blankCollectionsPage){
        [self.blankCollectionsPage removeFromSuperview];
        self.blankCollectionsPage = nil;
    }
    self.blankCollectionsPage = [[FyndBlankPage alloc] initWithFrame:CGRectMake(10, 10, self.view.frame.size.width-20, self.view.frame.size.height- (20 +64+ 44)) blankPageType:pageType];
    __weak CollectionsViewController *controller = self;
    self.blankCollectionsPage.blankPageBlock=^(){
        if(pageType == ErrorNoCollections){
            [controller.tabBarController setSelectedIndex:2];
        }
        else if(pageType == ErrorSystemDown){
            [controller tapOnRetry];
        }else if (pageType == ErrorEmptyCollectionsTab){
            [controller.tabBarController setSelectedIndex:0];
        }
    };
    [self.view addSubview:self.blankCollectionsPage];
    
}


- (void)tapOnRetry{
    if(self.blankCollectionsPage){
        [self.blankCollectionsPage removeFromSuperview];
        self.blankCollectionsPage = nil;
    }
    [self fetchCollectionServiceData:1 andGender:self.selectedGenderFilter];
}




- (void)configureNewCollectionIndexPath{
    
    NSMutableArray *indexSetArray = [[NSMutableArray alloc] initWithCapacity:0];
    for(int i = 0; i < newCollectionCount - initialCollectionCount; i++){
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i+initialCollectionCount +1 inSection:0];
        [indexSetArray addObject:indexPath];
    }
    [self.collectionsCollectionView insertItemsAtIndexPaths:indexSetArray];
}




- (void)configureCollectionsCollectionView{
    UICollectionViewFlowLayout *layout=[[UICollectionViewFlowLayout alloc] init];
    self.collectionsCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-50) collectionViewLayout:layout];
    [self.collectionsCollectionView setBackgroundColor:[UIColor whiteColor]];
    [self.collectionsCollectionView registerClass:[CollectionGrid class] forCellWithReuseIdentifier:@"Collection"];
    self.collectionsCollectionView.dataSource = self;
    self.collectionsCollectionView.delegate = self;
    [self.view addSubview:self.collectionsCollectionView];
}




#pragma delegates nd datasources

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    CollectionTileModel *collectionData = [collectionServiceData.collectionArray objectAtIndex:indexPath.row]; //[self.collectionArray objectAtIndex:indexPath.row];
    CGFloat height = [self calculateCollectionCellHeight:collectionData];
    CGSize cellSize = CGSizeMake(self.view.frame.size.width-20,height);
    return cellSize;
}


-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
//    return [self.collectionArray count];
    return [collectionServiceData.collectionArray count];
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    CollectionGrid *cell = (CollectionGrid *)[collectionView dequeueReusableCellWithReuseIdentifier:@"Collection" forIndexPath:indexPath];
//    cell.collectionTileModel = [self.collectionArray objectAtIndex:indexPath.row];
    cell.collectionTileModel = [collectionServiceData.collectionArray objectAtIndex:indexPath.row];
    
    CGFloat calculatedWidth = ((self.view.frame.size.width - 2*kGridComponentPadding) - 2*kGridComponentPadding)/3.5;
    
    if(cell.collectionTileModel.products && [cell.collectionTileModel.products count]>0)
    {
        SubProductModel *subProduct = [cell.collectionTileModel.products objectAtIndex:0];
        CGFloat productContainerHeight = [self getProductsAspectRatio:subProduct.subProductAspectRatio andWidth:calculatedWidth];
        
        CGSize aSize = CGSizeMake(calculatedWidth,productContainerHeight);
        cell.collectionViewCellSize = aSize;
    }
    
    cell.bannerWidth = self.view.frame.size.width;
    [cell configureCollectionGrid];
    
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    //    BrandTileModel *model = [brandServiceData.brandArray objectAtIndex:indexPath.row] action] url];
    
    BrowseByCollectionViewController *browseByBrandController = [[BrowseByCollectionViewController alloc] init];
    CollectionTileModel *currentBrand = [collectionServiceData.collectionArray objectAtIndex:indexPath.row];
    [browseByBrandController parseURL:currentBrand.action.url];
    [self.navigationController pushViewController:browseByBrandController animated:YES];
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath{
}

CGSize collectionCellDynamicSize ;
- (CGFloat)calculateCollectionCellHeight:(CollectionTileModel *)collectionData{
    CGRect fixedRect =  CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 50 - 64);
    CGFloat dynamicHeight = 0.0f;
    CGFloat bannerDynamicHeight = [self getHeightFromAspectRatio:collectionData.bannerAspectRatio andWidth:self.view.frame.size.width];
    dynamicHeight += bannerDynamicHeight + kGridComponentPadding;
    
    collectionCellDynamicSize = [SSUtility getLabelDynamicSize:collectionData.banner_title withFont:[UIFont fontWithName:@"Helvetica-Bold" size:15.0f] withSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
    dynamicHeight += kGridComponentPadding + collectionCellDynamicSize.height;
    
    NSString *modifiedString = [NSString stringWithFormat:@"Last Updted %@",collectionData.last_updated];
    collectionCellDynamicSize = [SSUtility getLabelDynamicSize:modifiedString withFont:[UIFont fontWithName:@"HelveticaNeue" size:10.0f] withSize:CGSizeMake(250, MAXFLOAT)];
    dynamicHeight += kGridComponentPadding + collectionCellDynamicSize.height;
    
    CGFloat calculatedWidth = ((fixedRect.size.width - 2*kGridComponentPadding) - 2*kGridComponentPadding)/3.5;
    
    
    if(collectionData.products && [collectionData.products count]>0) // If any brnad is having some producs then only need to calculate height
    {
        SubProductModel *subProduct = [collectionData.products objectAtIndex:0]; // TODO
        CGFloat productContainerHeight = [self getProductsAspectRatio:subProduct.subProductAspectRatio andWidth:calculatedWidth];
        collectionProductSize = CGSizeMake(calculatedWidth,productContainerHeight);
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
    [self.navigationController.navigationBar changeNavigationBarToTransparent:FALSE];
    [[[UIApplication sharedApplication] keyWindow] setBackgroundColor:[UIColor whiteColor]];    

    [self updateNotificationIcon];

    [self fetchStoredUser];

//    if([[[NSUserDefaults standardUserDefaults] valueForKey:@"refreshCollection"] boolValue])
    if(([[[NSUserDefaults standardUserDefaults] valueForKey:@"refreshCollection"] boolValue] || collectionGenderValueChanged) && !self.isProfileCollection)
    {
        if(self.collectionGridView){
            [self.collectionGridView.parsedDataArray removeAllObjects];
            [self.collectionGridView removeFromSuperview];
            self.collectionGridView = nil;
        }
        //    self.brandGridView = [[GridView alloc] initWithFrame:CGRectMake(0, self.genderHeader.frame.size.height, self.view.frame.size.width, self.view.frame.size.height - 50 - 64)];
        self.collectionGridView = [[GridView alloc] initWithFrame:CGRectMake(0, RelativeSize(3, 320), self.view.frame.size.width, self.view.frame.size.height)];
        [self.collectionGridView.collectionView setAlwaysBounceVertical:YES];
        
        self.collectionGridView.delegate = self;
        
        
        latitude = [[userDefaults objectForKey:@"latitude"] stringValue];
        longitude = [[userDefaults objectForKey:@"longitude"] stringValue];
        city = [userDefaults objectForKey:@"city"];
        [self fetchCollectionServiceData:1 andGender:self.selectedGenderFilter];
        [[NSUserDefaults standardUserDefaults] setBool:FALSE forKey:@"refreshCollection"];
        
       
        if(collectionGenderValueChanged){
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
    collectionGenderValueChanged = false;
    FyndUser *loggedInIUser = [SSUtility loadUserObjectWithKey:kFyndUserKey];
    if([[userDefaults objectForKey:@"isLaunchedViaBranch"] boolValue]){
        NSArray *params = [userDefaults objectForKey:@"BranchParameters"];

        self.selectedGenderFilter = [[params objectAtIndex:0] objectForKey:@"gender"];

    }else{
        NSString *storedGender = [userDefaults objectForKey:@"StoredGender"];
        
        if(storedGender && storedGender !=nil){
            if(![storedGender isEqualToString:self.selectedGenderFilter]){
                collectionGenderValueChanged = TRUE;
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
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:TRUE];
    [self.navigationController.view setBackgroundColor:[UIColor whiteColor]];
    [self resetBars];
}

-(void)beginSearch{
    __weak CollectionsViewController *weakSelf = self;
    theSearchViewController = [[SearchViewController alloc] init];
    theSearchViewController.thePushBlock = ^(NSString *stringParam, NSString *theURLString,NSString *theCategoryName, NSString *parentCategory, NSString *gender, AutoSuggestModel *searchModel){
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
            BrowseByCategoryViewController * theCategoryController = [[BrowseByCategoryViewController alloc] init];
            if([[stringParam uppercaseString] isEqualToString:@"FREETEXT"]){
                theCategoryController.screenType = BrowseTypeSearch;
                
                if(searchModel && searchModel != nil){
                    
                    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                    [formatter setDateFormat:@"YYYY-MM-dd'T'HH:mm:ss"];
                    NSDate *now = [NSDate date];
                    NSString *dateString = [formatter stringFromDate:now];
                    
                    [FyndAnalytics trackSearchEventFrom:@"collection" searchString:searchModel.displayName searchDate:dateString];
                }
                
            }else{
                theCategoryController.screenType = BrowseTypeBrwose;
                [FyndAnalytics trackCategoryEvent:gender category:parentCategory subcategory:theCategoryName];

            }
            theCategoryController.theProductURL = theURLString;
            theCategoryController.theCategory = theCategoryName;
            [weakSelf.navigationController pushViewController:theCategoryController animated:TRUE];
        }
    };

    [self.navigationController presentViewController:theSearchViewController animated:TRUE completion:nil];
    //    [self.navigationController pushViewController:theSearchViewController animated:YES];
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


#pragma mark - Grid View Delegate Method
-(void)didScrollToEndOfLastPage{
    
    collectionPageNumber++;
    
    NSDictionary *paramDict = @{@"page":[NSString stringWithFormat:@"%d", collectionPageNumber]};
    NSInteger prevLastIndex = [self.collectionGridView.parsedDataArray count] - 1;
    __block NSInteger newLastIndex = 0;
    
    if(collectionPagination.hasNext){
        //        [self.tabRequestHandler fetchBrandsTabDataWithParameters:paramDict withCompletionHandler:^(id responseData, NSError *error) {
        [self.tabRequestHandler fetchCollectionTabDataWithParameters:paramDict withRequestCompletionhandler:^(id responseData, NSError *error){
            [self.collectionGridView.parsedDataArray addObjectsFromArray:[SSUtility parseJSON:[responseData objectForKey:@"items"] forGridView:self.collectionGridView]];
            newLastIndex = [self.collectionGridView.parsedDataArray count] - 1;
            
            NSMutableArray *indexSetArray = [[NSMutableArray alloc] initWithCapacity:0];
            for(int i = 0; i < newLastIndex - prevLastIndex; i++){
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i+prevLastIndex +1 inSection:0];
                [indexSetArray addObject:indexPath];
            }
            if(collectionPagination){
                collectionPagination = nil;
            }
            collectionPagination = [[PaginationData alloc] initWithDictionary:[responseData objectForKey:@"page"]];
            if(!collectionPagination.hasNext){
                self.collectionGridView.shouldHideLoaderSection = true;
            }else{
                self.collectionGridView.shouldHideLoaderSection = false;
            }
            
            //            hasNext = [[[responseData objectForKey:@"page"] objectForKey:@"has_next"] boolValue];
            dispatch_async(dispatch_get_main_queue(), ^(void){
                [self.collectionGridView reloadCollectionView:indexSetArray];
            });
        }];
    }
}
-(void)gridViewDidScroll:(UIScrollView *)scrollView{
    [self manageBarsWithScroll:scrollView forGridView:self.collectionGridView];
}



- (void)showPDPScreen:(NSString *)url{
    if(self.pdpController){
        self.pdpController = nil;
    }
    self.pdpController = [[PDPViewController alloc] init];
    self.pdpController.productURL = url;
    [self.navigationController pushViewController:self.pdpController animated:YES];
}

- (void)showBrowseByBrandPage:(NSString *)url{
    if(self.browseByBrandController){
        self.browseByBrandController = nil;
    }
    self.browseByBrandController = [[BrowseByBrandViewController alloc] init];
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
    self.browseByCollectionController.isProfileCollection = self.isProfileCollection;

    if(self.selectedGenderFilter){
        self.browseByCollectionController.gender = self.selectedGenderFilter;
    }
    [self.browseByCollectionController parseURL:url];
    
    [self.navigationController pushViewController:self.browseByCollectionController animated:YES];
}



- (void)showCollectionProductPDP:(NSString *)collectionURL{
    [self showPDPScreen:collectionURL];
}




#pragma mark - Scroll Bars Methods

#pragma mark - Bars Methods

-(void)manageBarsWithScroll:(UIScrollView *)scrollView forGridView:(GridView *)theGrdidView{
    
    hideBars = TRUE;
    
    if([[[UIDevice currentDevice] systemVersion] floatValue] < 7.0f){
        return;
    }
    
    CGRect navFrame = self.navigationController.navigationBar.frame;
    CGFloat navSize = navFrame.size.height - 21;
    
    CGRect tabBarFrame = self.tabBarController.tabBar.frame;
    CGFloat tabHeight = tabBarFrame.size.height;
    if (self.isProfileCollection) {
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
        if (self.isProfileCollection) {
            tabHeight = 50.0f;
        }

        tabBarFrame.origin.y = kDeviceHeight + tabHeight;
        hideBars = TRUE;
    }
    else if([scrollView.panGestureRecognizer translationInView:self.view].y > 0)
    {
        navFrame.origin.y = 20;
        if (self.isProfileCollection) {
            tabHeight = 0.0f;
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
                UIImageView *imageView = (UIImageView *)[self.navigationView viewWithTag:2345];
                imageView.transform = CGAffineTransformMakeRotation(DEGREES_TO_RADIANS(360));
                [self.genderHeader setFrame:genderFrame];
                [self.genderHeader setAlpha:0.0];
                isGenderViewVisible = !isGenderViewVisible;
                [theGrdidView setFrame:CGRectMake(theGrdidView.frame.origin.x, 0, theGrdidView.frame.size.width, theGrdidView.frame.size.height + self.genderHeader.frame.size.height+5)];
            }
            
        } completion:^(BOOL finished) {
        
            [UIView animateWithDuration:0.1 animations:^{
                if (hideBars) {
                    [self.view setFrame:CGRectMake(self.view.frame.origin.x, navFrame.origin.y + navFrame.size.height, self.view.frame.size.width, tabBarFrame.origin.y - 20)];
                    [theGrdidView setFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - tabBarFrame.size.height)];
                    [theGrdidView.collectionView setFrame:CGRectMake(theGrdidView.collectionView.frame.origin.x, theGrdidView.collectionView.frame.origin.y, theGrdidView.collectionView.frame.size.width, theGrdidView.frame.size.height)];
                }
                
            } completion:^(BOOL finished) {
                [UIView animateWithDuration:0.4 animations:^{
                    if(!hideBars){
                        [self.navigationController.navigationBar setAlpha:1.0];
                        
                    [self.view setFrame:CGRectMake(self.view.frame.origin.x, navFrame.origin.y + navFrame.size.height, self.view.frame.size.width, tabBarFrame.origin.y - 20)];
                    [theGrdidView setFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
                    [theGrdidView.collectionView setFrame:CGRectMake(theGrdidView.collectionView.frame.origin.x, theGrdidView.collectionView.frame.origin.y, theGrdidView.collectionView.frame.size.width, theGrdidView.frame.size.height)];
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
-(BOOL)hidesBottomBarWhenPushed{
    if (self.isProfileCollection) {
        return YES;
    }else{
        return NO;
    }
}


@end
