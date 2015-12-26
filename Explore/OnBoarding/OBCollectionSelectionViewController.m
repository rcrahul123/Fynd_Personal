//
//  OBCollectionSelectionViewController.m
//  Explore
//
//  Created by Rahul Chaudhari on 12/08/15.
//  Copyright (c) 2015 Rahul. All rights reserved.
//

#import "OBCollectionSelectionViewController.h"
#import "PaginationData.h"
#import "OnBoardingRequestHandler.h"
#import "UserAuthenticationHandler.h"
//#import <Mixpanel/MPTweakInline.h>

@interface OBCollectionSelectionViewController (){
    BOOL    collectionServiceInProgress;
    PaginationData  *collectionPagination;
    int collectionPageNumber;
    
    UIImageView *headerImageView;
    UILabel *collectionMessageLabel;
    UILabel *collectionMessageLabel1;

    NSString *theGender;
    NSMutableArray *collectionArray;
    BOOL isBrandSuccessful;
    BOOL isCollectionSuccessful;
    UserAuthenticationHandler *userAuthenticationHandler;
    
    
    NSMutableArray *brandArray;
    
}
@property (nonatomic,strong) OnBoardingRequestHandler  *tabRequestHandler;
@property (nonatomic,strong) GridView           *collectionGridView;
//@property (nonatomic,strong) UIActivityIndicatorView *activityIndicator;
@end

@implementation OBCollectionSelectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    followCollectionLoader = [[FyndActivityIndicator alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    [followCollectionLoader setCenter:CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height/2 - 30)];
    
    self.navigationController.navigationBar.topItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
//    self.followCollectionScrollview = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-114)];
    self.followCollectionScrollview = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-64)];
    self.followCollectionScrollview.showsHorizontalScrollIndicator = false;
    self.followCollectionScrollview.showsVerticalScrollIndicator = FALSE;
    [self.followCollectionScrollview setBackgroundColor:[UIColor clearColor]];
    self.followCollectionScrollview.delegate = self;
    [self.navigationController.navigationBar setFont:[UIFont fontWithName:kMontserrat_Regular size:16.0f] withColor:UIColorFromRGB(kDarkPurpleColor)];


    shouldShowNext = FALSE;
    collectionPageNumber = 1;

    
    
    UIImage *img = [UIImage imageNamed:@"FollowCollectionHeader"];
    headerImageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.followCollectionScrollview.frame.size.width/2 - img.size.width/2, 20, img.size.width, img.size.height)];
    headerImageView.image = img;
    [self.followCollectionScrollview addSubview:headerImageView];
    [headerImageView setHidden:TRUE];
    
    collectionMessageLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.followCollectionScrollview.frame.size.width/2 - 175, headerImageView.frame.size.height + headerImageView.frame.origin.y + 15, 350, 18)];
    [collectionMessageLabel setFont:[UIFont fontWithName:kMontserrat_Regular size:16.0f]];
    [collectionMessageLabel setNumberOfLines:0];
    [collectionMessageLabel setTextColor:UIColorFromRGB(kTurquoiseColor)];
    [collectionMessageLabel setTextAlignment:NSTextAlignmentCenter];
    [self.followCollectionScrollview addSubview:collectionMessageLabel];
    
    collectionMessageLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(self.followCollectionScrollview.frame.size.width/2 - 175, collectionMessageLabel.frame.size.height + collectionMessageLabel.frame.origin.y + 5, 350, 18)];
    [collectionMessageLabel1 setFont:[UIFont fontWithName:kMontserrat_Light size:14.0f]];
    [collectionMessageLabel1 setNumberOfLines:0];
    [collectionMessageLabel1 setTextColor:UIColorFromRGB(kDarkPurpleColor)];
    [collectionMessageLabel1 setTextAlignment:NSTextAlignmentCenter];
    [self.followCollectionScrollview addSubview:collectionMessageLabel1];

    theGender = [NSString stringWithFormat:@"%@",(FyndUser *)[SSUtility loadUserObjectWithKey:kFyndUserKey].gender];
    collectionPageNumber = 1;
    self.collectionGridView = [[GridView alloc] initWithFrame:CGRectMake(0, collectionMessageLabel1.frame.size.height + collectionMessageLabel1.frame.origin.y + 20, self.view.frame.size.width, self.view.frame.size.height -(collectionMessageLabel.frame.size.height + collectionMessageLabel.frame.origin.y)- 50 - 64)];
    self.collectionGridView.delegate = self;
    [self fetchCollectionServiceData:collectionPageNumber];
    [self.view setBackgroundColor:UIColorFromRGB(kBackgroundGreyColor)];
    
    [self.view addSubview:self.followCollectionScrollview];
    [self.view setFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 66)];
     [self setupBottomBar];

    [self setBackButton];
}
-(void)setBackButton{
    UIImage *backButtonImage = [[UIImage imageNamed:kBackButtonImage] imageWithAlignmentRectInsets:UIEdgeInsetsMake(0, kBackButtonImageInset, 0, 0)];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:backButtonImage style:UIBarButtonItemStyleBordered target:self action:@selector(backAction:)];
}
-(void)backAction:(id)sender{
    [self.navigationController popViewControllerAnimated:TRUE];
}


- (void)fetchCollectionServiceData:(NSInteger)pageNumber{
    if(self.tabRequestHandler == nil){
        self.tabRequestHandler = [[OnBoardingRequestHandler alloc] init];
    }
//    if(self.activityIndicator){
//        [self.activityIndicator removeFromSuperview];
//        self.activityIndicator = nil;
//    }
//    
//    self.activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
//    [self.activityIndicator setFrame:CGRectMake(self.view.frame.size.width/2 -25, self.view.frame.size.height/2 - 25, 50, 50)];
//    [self.activityIndicator startAnimating];
//    [self.view addSubview:self.activityIndicator];
    
    [self.view addSubview:followCollectionLoader];
    [followCollectionLoader startAnimating];
    
    collectionServiceInProgress = TRUE;
    NSMutableDictionary *theParams = [[NSMutableDictionary alloc] init];
    [theParams setObject:[NSString stringWithFormat:@"%ld",(long)pageNumber] forKey:@"page"];
    [theParams setObject:theGender forKey:@"gender"];
    [theParams setObject:@"False" forKey:@"items"];

    [self.tabRequestHandler fetchCollectionTabDataWithParameters:theParams withRequestCompletionhandler:^(id responseData, NSError *error) {
        
        [self.collectionGridView.parsedDataArray addObjectsFromArray:[SSUtility parseJSON:[responseData objectForKey:@"items"] forGridView:self.collectionGridView]];
        
        if(collectionPagination){
            collectionPagination = nil;
        }
        collectionPagination = [[PaginationData alloc] initWithDictionary:[responseData objectForKey:@"page"]];
        if(!collectionPagination.hasNext){
            self.collectionGridView.shouldHideLoaderSection = YES;
        }else{
            self.collectionGridView.shouldHideLoaderSection = NO;
        }
        
        dispatch_async(dispatch_get_main_queue(), ^(void){
            
//            [self.activityIndicator stopAnimating];
//            self.activityIndicator = nil;
            [followCollectionLoader stopAnimating];
            [followCollectionLoader removeFromSuperview];

            [self.followCollectionScrollview addSubview:self.collectionGridView];
            [self.collectionGridView addCollectionView];
            
            [headerImageView setHidden:FALSE];
            
            NSString *theCollectionMessage = @"Simplify your experience";
            [collectionMessageLabel setText:theCollectionMessage];
            
            NSString *theCollectionMessage1 = @"with collections handpicked by our experts";
            [collectionMessageLabel1 setText:theCollectionMessage1];

            if(isObserverAdded){
                @try {
                    [self removeObserver:self forKeyPath:@"self.collectionGridView.collectionView.contentSize"];
                    isObserverAdded = false;
                }
                @catch (NSException *exception) {
                }
            }
                
            [self addObserver:self forKeyPath:@"self.collectionGridView.collectionView.contentSize" options:NSKeyValueObservingOptionNew |NSKeyValueObservingOptionOld context:NULL];
            isObserverAdded = true;
        });
        
        collectionServiceInProgress = FALSE;
    }];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
    if(collectionServiceInProgress)
        return;
    if(self.followCollectionScrollview.contentOffset.y + self.followCollectionScrollview.frame.size.height >= self.followCollectionScrollview.contentSize.height - 110 && self.followCollectionScrollview.contentOffset.y > 0 && collectionPagination.hasNext){
        collectionServiceInProgress = true;
        
        NSInteger prevLastIndex = [self.collectionGridView.parsedDataArray count] - 1;
        __block NSInteger newLastIndex = 0;
        
        collectionPageNumber ++;
        
        NSDictionary *paramDict = @{@"page":[NSString stringWithFormat:@"%d", collectionPageNumber],
                                    @"gender":theGender,
                                    @"items":@"False"
                                    };
        if(collectionPagination.hasNext){
            [self.tabRequestHandler fetchCollectionTabDataWithParameters:paramDict withRequestCompletionhandler:^(id responseData, NSError *error){
                
                if(collectionPagination){
                    collectionPagination = nil;
                }
                collectionPagination = [[PaginationData alloc] initWithDictionary:[responseData objectForKey:@"page"]];
                if(!collectionPagination.hasNext){
                    self.collectionGridView.shouldHideLoaderSection = YES;
                }else{
                    self.collectionGridView.shouldHideLoaderSection = NO;
                }
                [self.collectionGridView.parsedDataArray addObjectsFromArray:[SSUtility parseJSON:[responseData objectForKey:@"items"] forGridView:self.collectionGridView]];
                newLastIndex = [self.collectionGridView.parsedDataArray count] - 1;

                NSMutableArray *indexSetArray = [[NSMutableArray alloc] initWithCapacity:0];
                for(int i = 0; i < newLastIndex - prevLastIndex; i++){
                    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i+prevLastIndex +1 inSection:0];
                    [indexSetArray addObject:indexPath];
                }
                
                dispatch_async(dispatch_get_main_queue(), ^(void){
                    [self.collectionGridView reloadCollectionView:indexSetArray];
                    collectionServiceInProgress = false;
                });
            }];
        }
    }
}


-(void)collectionFollowing:(CollectionTileModel *)theCollectionModel{
    if (collectionArray == nil) {
        collectionArray = [[NSMutableArray alloc] init];
    }
    if (theCollectionModel.is_following) {

        if (![collectionArray containsObject:theCollectionModel.collectionID]) {
            [collectionArray addObject:theCollectionModel.banner_title];

        }
        
    }else{
        if ([collectionArray containsObject:theCollectionModel.collectionID]) {
            [collectionArray removeObject:theCollectionModel.banner_title];
        }
    }
    [self toggleNext];
}


-(void)toggleNext{
    shouldShowNext = !shouldShowNext;
    
    if([collectionArray count]>0){
        
        NSAttributedString *nextString = [[NSAttributedString alloc] initWithString:@"Let's go Fynding" attributes:@{NSFontAttributeName : [UIFont fontWithName:kMontserrat_Regular size:16.0], NSForegroundColorAttributeName : [UIColor whiteColor]}];
        
        [followCollectionLabel setBackgroundImage:[SSUtility imageWithColor:UIColorFromRGB(kTurquoiseColor)] forState:UIControlStateNormal];
        [followCollectionLabel setBackgroundImage:[SSUtility imageWithColor:UIColorFromRGB(kButtonTouchStateColor)] forState:UIControlStateHighlighted];
        [followCollectionLabel setAttributedTitle:nextString forState:UIControlStateNormal];
        
        followCollectionLabel.userInteractionEnabled = TRUE;
        bottomBar.alpha = 1.0;

    }else{
        [followCollectionLabel setAttributedTitle:followString forState:UIControlStateNormal];
//        if (MPTweakValue(@"SkipOnBoarding_Step",YES)) {
//            followCollectionLabel.userInteractionEnabled = TRUE;
//        }else{
//            followCollectionLabel.userInteractionEnabled = FALSE;
//        }
        followCollectionLabel.userInteractionEnabled = FALSE;
        [followCollectionLabel setBackgroundImage:[SSUtility imageWithColor:[UIColor clearColor]] forState:UIControlStateNormal];

        bottomBar.alpha = 0.9;
    }
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = false;
    
    if([collectionArray count]>0){
        
        NSAttributedString *nextString = [[NSAttributedString alloc] initWithString:@"Let's go Fynding" attributes:@{NSFontAttributeName : [UIFont fontWithName:kMontserrat_Regular size:16.0], NSForegroundColorAttributeName : [UIColor whiteColor]}];
        
        [followCollectionLabel setBackgroundImage:[SSUtility imageWithColor:UIColorFromRGB(kTurquoiseColor)] forState:UIControlStateNormal];
        [followCollectionLabel setBackgroundImage:[SSUtility imageWithColor:UIColorFromRGB(kButtonTouchStateColor)] forState:UIControlStateHighlighted];
        [followCollectionLabel setAttributedTitle:nextString forState:UIControlStateNormal];
        
        followCollectionLabel.userInteractionEnabled = TRUE;
        bottomBar.alpha = 1.0;
        
    }else{
        [followCollectionLabel setAttributedTitle:followString forState:UIControlStateNormal];
//        if (MPTweakValue(@"SkipOnBoarding_Step",YES)) {
//            followCollectionLabel.userInteractionEnabled = TRUE;
//        }else{
//            followCollectionLabel.userInteractionEnabled = FALSE;
//        }
        followCollectionLabel.userInteractionEnabled = FALSE;
        [followCollectionLabel setBackgroundImage:[SSUtility imageWithColor:[UIColor clearColor]] forState:UIControlStateNormal];
        
        bottomBar.alpha = 0.9;
    }
}



-(void)setupBottomBar{
    bottomBar = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 48, self.view.frame.size.width, 50)];
    [bottomBar setBackgroundColor:[UIColor whiteColor]];
    [bottomBar setAlpha:0.9];
    bottomBar.layer.borderColor = UIColorFromRGB(kShadowColor).CGColor;
    [bottomBar.layer setShadowOpacity:0.2];
    [bottomBar.layer setShadowRadius:2.0];
    [bottomBar.layer setShadowOffset:CGSizeMake(0.0, 0.0)];
    [self.view addSubview:bottomBar];
    NSString *buttonText = @"";
//    if (MPTweakValue(@"SkipOnBoarding_Step",YES)) {
//        buttonText = @"Skip";
//    }else{
//        buttonText = @"Follow atleast 1 Collection";
//    }
    buttonText = @"Follow atleast 1 Collection";
    followString = [[NSAttributedString alloc] initWithString:buttonText attributes:@{NSFontAttributeName : [UIFont fontWithName:kMontserrat_Regular size:16.0], NSForegroundColorAttributeName : UIColorFromRGB(kDarkPurpleColor)}];
    followCollectionLabel = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, bottomBar.frame.size.width, bottomBar.frame.size.height)];
    [followCollectionLabel setAttributedTitle:followString forState:UIControlStateNormal];
    followCollectionLabel.backgroundColor = [UIColor clearColor];

    [followCollectionLabel setCenter:CGPointMake(bottomBar.frame.size.width/2, bottomBar.frame.size.height/2)];
    followCollectionLabel.clipsToBounds = YES;

//    if (MPTweakValue(@"SkipOnBoarding_Step",YES)) {
//        followCollectionLabel.userInteractionEnabled = TRUE;
//    }else{
//        followCollectionLabel.userInteractionEnabled = FALSE;
//    }
    followCollectionLabel.userInteractionEnabled = FALSE;
    [bottomBar addSubview:followCollectionLabel];
    
//    [followCollectionLabel setUserInteractionEnabled:FALSE];
    tapLabel = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(goToNextScreen)];
    [followCollectionLabel addGestureRecognizer:tapLabel];
}

-(void)goToNextScreen{
//    [SSUtility showActivityOverlay:self.view];
    [self.view addSubview:followCollectionLoader];
    [followCollectionLoader startAnimating];
//    if (MPTweakValue(@"SkipOnBoarding_Step",YES)) {
//        isCollectionSuccessful  = TRUE;
//        isBrandSuccessful = TRUE;
//        [self navigateToNextScreen];
//    }else{
//        [self createOnBoardingRequestData];
//    }
    [self createOnBoardingRequestData];
}

-(void)createOnBoardingRequestData{
    
    NSMutableArray *dictionaryArray = [[NSMutableArray alloc] initWithCapacity:0];
    
    for (NSString *brndName in self.theFollowigBrandData) {
         NSMutableDictionary *brandDictionary = [[NSMutableDictionary alloc] init];
        [brandDictionary setObject:brndName forKey:@"brand"];
        [dictionaryArray addObject:brandDictionary];
    }
    [self.tabRequestHandler sendOnBoardingDataWithMultipleParams:dictionaryArray withCompletionHandler:^(id responseData, NSError *error) {
        if (!error) {
            isBrandSuccessful = TRUE;
            [self navigateToNextScreen];
        }
    }];
    
    NSMutableArray *collectionDictionaryArray = [[NSMutableArray alloc] initWithCapacity:0];
    
    for (int k =0; k<[collectionArray count]; k++) {
        NSMutableDictionary *collectionDictionary = [[NSMutableDictionary alloc] init];
        [collectionDictionary setObject:[collectionArray objectAtIndex:k] forKey:@"collection_id"];
        [collectionDictionaryArray addObject:collectionDictionary];
    }
    
    [self.tabRequestHandler sendOnBoardingDataWithMultipleParams:collectionDictionaryArray withCompletionHandler:^(id responseData, NSError *error) {
        if (!error) {
            isCollectionSuccessful = TRUE;
            [self navigateToNextScreen];
        }
    }];
}

-(void)navigateToNextScreen{
    if (isCollectionSuccessful && isBrandSuccessful) {
//        [SSUtility dismissActivityOverlay];
        [followCollectionLoader stopAnimating];
        [followCollectionLoader removeFromSuperview];
        
        userAuthenticationHandler = [[UserAuthenticationHandler alloc] init];
        [userAuthenticationHandler completeUserOnBoardingWithCompletionHandler:^(id responseData, NSError *error) {
            if(!error){
                FyndUser *theUser = (FyndUser *)[SSUtility loadUserObjectWithKey:kFyndUserKey];
                if([[responseData objectForKey:@"is_onboarded"] boolValue]){
                    [theUser setIsOnboarded:TRUE];
                    
                }else{
                    [theUser setIsOnboarded:FALSE];
                }
                NSString *city = [[NSUserDefaults standardUserDefaults] valueForKey:@"city"];
                
                [[NSUserDefaults standardUserDefaults] setBool:TRUE forKey:kShowWelcomeCard];
                
                [FyndAnalytics registerPropertiesForOnBoardingForUser:theUser.userId Location:city withBrandsData:_theFollowigBrandData andCollectionsData:collectionArray];
                
               
            }
        }];
            [self performSegueWithIdentifier:@"OnBoardingToTab" sender:nil];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    
    if([keyPath isEqualToString:@"self.collectionGridView.collectionView.contentSize"]) {
        if([self.collectionGridView.parsedDataArray count] > 0){
            [self.collectionGridView.collectionView setFrame:CGRectMake(self.collectionGridView.collectionView.frame.origin.x, self.collectionGridView.collectionView.frame.origin.y, self.collectionGridView.collectionView.frame.size.width, self.collectionGridView.collectionView.contentSize.height)];
            [self.collectionGridView setFrame:CGRectMake(self.collectionGridView.frame.origin.x, self.collectionGridView.frame.origin.y, self.collectionGridView.frame.size.width, self.collectionGridView.collectionView.frame.origin.y + self.collectionGridView.collectionView.frame.size.height)];
            [self.followCollectionScrollview setContentSize:CGSizeMake(self.followCollectionScrollview.frame.size.width, self.collectionGridView.frame.origin.y + self.collectionGridView.frame.size.height + 60)];
        }
    }
}


-(void)dealloc{
    if(isObserverAdded){
        @try {
            [self removeObserver:self forKeyPath:@"self.collectionGridView.collectionView.contentSize"];
            isObserverAdded = false;
        }
        @catch (NSException *exception) {
        }
    }

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
