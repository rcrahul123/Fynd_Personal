//
//  OBBrandSelectionViewController.m
//  Explore
//
//  Created by Rahul Chaudhari on 12/08/15.
//  Copyright (c) 2015 Rahul. All rights reserved.
//

#import "OBBrandSelectionViewController.h"
#import "OBCollectionSelectionViewController.h"
//#import <Mixpanel/MPTweakInline.h>

@interface OBBrandSelectionViewController (){
    BOOL    serviceInProgress;
    NSString *theGender;
    PaginationData  *brandPagination;
    int brandPageNumber;
    UILabel *brandMessageLabel;
    UILabel *brandMessageLabel1;

}
@property (nonatomic,strong) OnBoardingRequestHandler  *theOBRequestHandler;

//@property (nonatomic,strong) UIActivityIndicatorView *activityIndicator;
@property (nonatomic,strong) GridView           *brandGridView;
@end

@implementation OBBrandSelectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    followBrandLoader = [[FyndActivityIndicator alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    [followBrandLoader setCenter:CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height/2 - 30)];
    
    theGender = [NSString stringWithFormat:@"%@",(FyndUser *)[SSUtility loadUserObjectWithKey:kFyndUserKey].gender];
    shouldShowNext = FALSE;
    [self.navigationController.navigationBar changeNavigationBarToTransparent:NO];
    [self.navigationController.navigationBar setFont:[UIFont fontWithName:kMontserrat_Regular size:16.0f] withColor:UIColorFromRGB(kDarkPurpleColor)];

    
//    self.mainScrollview = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-114)];
    self.mainScrollview = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-64)];
    self.mainScrollview.showsHorizontalScrollIndicator = false;
    self.mainScrollview.showsVerticalScrollIndicator = FALSE;
    [self.mainScrollview setBackgroundColor:UIColorFromRGB(0xE6E6E6)];
    self.mainScrollview.delegate = self;
   
    UIImage *img = [UIImage imageNamed:@"FollowBrandHeader"];
    headerImageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.mainScrollview.frame.size.width/2 - img.size.width/2, 20, img.size.width, img.size.height)];
    headerImageView.image = img;
    [self.mainScrollview addSubview:headerImageView];
    [headerImageView setHidden:TRUE];
    
    brandMessageLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.mainScrollview.frame.size.width/2 - 175, headerImageView.frame.size.height + headerImageView.frame.origin.y + 15, 350, 18)];
    [brandMessageLabel setFont:[UIFont fontWithName:kMontserrat_Regular size:16.0f]];
    [brandMessageLabel setNumberOfLines:0];
//    [brandMessageLabel setCenter:CGPointMake(self.view.frame.size.width/2, 35)];
    [brandMessageLabel setTextColor:UIColorFromRGB(kTurquoiseColor)];
    [brandMessageLabel setTextAlignment:NSTextAlignmentCenter];
    [self.mainScrollview addSubview:brandMessageLabel];
    
    brandMessageLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(self.mainScrollview.frame.size.width/2 - 175, brandMessageLabel.frame.size.height + brandMessageLabel.frame.origin.y + 5, 350, 18)];
    
    [brandMessageLabel1 setFont:[UIFont fontWithName:kMontserrat_Light size:14.0f]];
    [brandMessageLabel1 setNumberOfLines:0];
    //    [brandMessageLabel setCenter:CGPointMake(self.view.frame.size.width/2, 35)];
    [brandMessageLabel1 setTextColor:UIColorFromRGB(kDarkPurpleColor)];
    [brandMessageLabel1 setTextAlignment:NSTextAlignmentCenter];
    [self.mainScrollview addSubview:brandMessageLabel1];

    
    self.brandGridView = [[GridView alloc] initWithFrame:CGRectMake(0, brandMessageLabel1.frame.size.height + brandMessageLabel1.frame.origin.y + 20, self.view.frame.size.width, self.view.frame.size.height -(brandMessageLabel1.frame.size.height + brandMessageLabel1.frame.origin.y+30)- 114)];

    self.brandGridView.delegate = self;
    brandPageNumber = 1;
    [self fetchBrandsServiceDataForPageNumer:brandPageNumber andGender:theGender];

    [self.view addSubview:self.mainScrollview];
    [self.view setFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 66)];
    [self setupBottomBar];
}
- (void)fetchBrandsServiceDataForPageNumer:(int)thePageNumber andGender:(NSString *)gender{
    
    if(self.theOBRequestHandler == nil){
        self.theOBRequestHandler = [[OnBoardingRequestHandler alloc] init];
    }
    
    [self.mainScrollview addSubview:followBrandLoader];
    [followBrandLoader startAnimating];
    
    serviceInProgress = TRUE;
    NSMutableDictionary *theParams = [[NSMutableDictionary alloc] init];
    [theParams setObject:[NSString stringWithFormat:@"%d",thePageNumber] forKey:@"page"];
    [theParams setObject:gender forKey:@"gender"];
    [theParams setObject:@"False" forKey:@"items"];
    
    [self.theOBRequestHandler fetchBrandsTabDataWithParameters:theParams withRequestCompletionhandler:^(id responseData, NSError *error) {
        
        if(brandPagination){
            brandPagination = nil;
        }
        brandPagination = [[PaginationData alloc] initWithDictionary:[responseData objectForKey:@"page"]];
        if(!brandPagination.hasNext){
            self.brandGridView.shouldHideLoaderSection = YES;
        }else{
            self.brandGridView.shouldHideLoaderSection = NO;
        }
        [self.brandGridView.parsedDataArray addObjectsFromArray:[SSUtility parseJSON:[responseData objectForKey:@"items"] forGridView:self.brandGridView]];
        
        dispatch_async(dispatch_get_main_queue(), ^(void){
            
//            [self.activityIndicator stopAnimating];
//            self.activityIndicator = nil;
            [followBrandLoader stopAnimating];
            [followBrandLoader removeFromSuperview];
            
            [self.mainScrollview addSubview:self.brandGridView];
            [self.brandGridView addCollectionView];

            [headerImageView setHidden:FALSE];
            
            NSString *theBrandMessage = @"Personalize your experience";
            [brandMessageLabel setText:theBrandMessage];
            
            NSString *theBrandMessage1 = @"by following your favourite brands";
            [brandMessageLabel1 setText:theBrandMessage1];
            
            if(!isObserverAdded){
                [self addObserver:self forKeyPath:@"self.brandGridView.collectionView.contentSize" options:NSKeyValueObservingOptionNew |NSKeyValueObservingOptionOld context:NULL];
                isObserverAdded = true;
            }
           
        });
    serviceInProgress = FALSE;
    }];
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
    if(serviceInProgress)
        return;
    if(self.mainScrollview.contentOffset.y + self.mainScrollview.frame.size.height >= self.mainScrollview.contentSize.height - 110 && self.mainScrollview.contentOffset.y > 0 && brandPagination.hasNext){

        serviceInProgress = true;
        
        NSInteger prevLastIndex = [self.brandGridView.parsedDataArray count] - 1;
        __block NSInteger newLastIndex = 0;
        
        brandPageNumber ++;
        
        NSDictionary *paramDict = @{@"page":[NSString stringWithFormat:@"%d", brandPageNumber],
                                    @"gender":theGender,
                                    @"items":@"False"
                                    };
        if(brandPagination.hasNext){
            [self.theOBRequestHandler fetchBrandsTabDataWithParameters:paramDict withRequestCompletionhandler:^(id responseData, NSError *error){
                [self.brandGridView.parsedDataArray addObjectsFromArray:[SSUtility parseJSON:[responseData objectForKey:@"items"] forGridView:self.brandGridView]];
                newLastIndex = [self.brandGridView.parsedDataArray count] - 1;
                serviceInProgress = false;
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
}


-(void)brandFollowing:(BrandTileModel *)theBrandModel{
    if (brandsArray == nil) {
        brandsArray = [[NSMutableArray alloc] init];
    }
    if (theBrandModel.is_following) {
        if (![brandsArray containsObject:theBrandModel.brandID]) {
            [brandsArray addObject:theBrandModel.brandID];
        }

    }else{
        if ([brandsArray containsObject:theBrandModel.brandID]) {
            [brandsArray removeObject:theBrandModel.brandID];
        }
    }
//    if ([brandsArray count]>0) {
        [self toggleNext];
//    }
}

-(void)toggleNext{
    shouldShowNext = !shouldShowNext;

    if([brandsArray count]>0){
        followBrandLabel.userInteractionEnabled = TRUE;
        
        NSAttributedString *nextString = [[NSAttributedString alloc] initWithString:@"NEXT" attributes:@{NSFontAttributeName : [UIFont fontWithName:kMontserrat_Regular size:16.0], NSForegroundColorAttributeName : [UIColor whiteColor]}];

        [followBrandLabel setBackgroundImage:[SSUtility imageWithColor:UIColorFromRGB(kTurquoiseColor)] forState:UIControlStateNormal];
        [followBrandLabel setBackgroundImage:[SSUtility imageWithColor:UIColorFromRGB(kButtonTouchStateColor)] forState:UIControlStateHighlighted];
        
        [followBrandLabel setAttributedTitle:nextString forState:UIControlStateNormal];
//        [followBrandLabel setText:@"NEXT"];
//        followBrandLabel.textColor = [UIColor whiteColor];
//        [followBrandLabel setBackgroundColor:UIColorFromRGB(kTurquoiseColor)];
        bottomBar.alpha = 1.0;
    }else{

        [followBrandLabel setAttributedTitle:followString forState:UIControlStateNormal];
//        if (MPTweakValue(@"SkipOnBoarding_Step",YES)) {
//            followBrandLabel.userInteractionEnabled = TRUE;
//        }else{
//            followBrandLabel.userInteractionEnabled = FALSE;
//        }

        followBrandLabel.userInteractionEnabled = FALSE;
        [followBrandLabel setBackgroundImage:[SSUtility imageWithColor:[UIColor clearColor]] forState:UIControlStateNormal];
        bottomBar.alpha = 0.9;
    }    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = false;
    self.navigationItem.hidesBackButton = TRUE;
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
    [self.view bringSubviewToFront:bottomBar];
    NSString *buttonText = @"";
//    if (MPTweakValue(@"SkipOnBoarding_Step",YES)) {
//        buttonText = @"Skip";
//    }else{
//        buttonText = @"Follow atleast 1 Brand";
//    }
        buttonText = @"Follow atleast 1 Brand";
    followString = [[NSAttributedString alloc] initWithString:buttonText attributes:@{NSFontAttributeName : [UIFont fontWithName:kMontserrat_Regular size:16.0], NSForegroundColorAttributeName : UIColorFromRGB(kDarkPurpleColor)}];
    followBrandLabel = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, bottomBar.frame.size.width, bottomBar.frame.size.height)];
    [followBrandLabel setAttributedTitle:followString forState:UIControlStateNormal];
    followBrandLabel.backgroundColor = [UIColor clearColor];

    [followBrandLabel setCenter:CGPointMake(bottomBar.frame.size.width/2, bottomBar.frame.size.height/2)];
    followBrandLabel.clipsToBounds = YES;

//    if (MPTweakValue(@"SkipOnBoarding_Step",YES)) {
//        followBrandLabel.userInteractionEnabled = TRUE;
//    }else{
//        followBrandLabel.userInteractionEnabled = FALSE;
//    }
    followBrandLabel.userInteractionEnabled = FALSE;
    [bottomBar addSubview:followBrandLabel];
    

    tapLabel = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(goToNextScreen)];
    [followBrandLabel addGestureRecognizer:tapLabel];
}

-(void)goToNextScreen{
    
    
    [self performSegueWithIdentifier:@"OBBrandToOBCollection" sender:nil];
}
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
    if ([segue.identifier isEqualToString:@"OBBrandToOBCollection"])
    {
        OBCollectionSelectionViewController *followCollectionView = [segue destinationViewController];
        followCollectionView.theFollowigBrandData  = brandsArray;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    
    if([keyPath isEqualToString:@"self.brandGridView.collectionView.contentSize"]) {
        if([self.brandGridView.parsedDataArray count] > 0){
            [self.brandGridView.collectionView setFrame:CGRectMake(self.brandGridView.collectionView.frame.origin.x, self.brandGridView.collectionView.frame.origin.y, self.brandGridView.collectionView.frame.size.width, self.brandGridView.collectionView.contentSize.height)];
            [self.brandGridView setFrame:CGRectMake(self.brandGridView.frame.origin.x, self.brandGridView.frame.origin.y, self.brandGridView.frame.size.width, self.brandGridView.collectionView.frame.origin.y + self.brandGridView.collectionView.frame.size.height)];
            [self.mainScrollview setContentSize:CGSizeMake(self.mainScrollview.frame.size.width, self.brandGridView.frame.origin.y + self.brandGridView.frame.size.height  + 60)];//+ brandMessageLabel.frame.size.height + brandMessageLabel.frame.origin.y
        }

    }
}


-(void)dealloc{
    if(isObserverAdded){
        [self removeObserver:self forKeyPath:@"self.brandGridView.collectionView.contentSize"];
        isObserverAdded = false;
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
