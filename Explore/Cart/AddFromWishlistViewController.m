//
//  AddFromWishlistViewController.m
//  Explore
//
//  Created by Rahul Chaudhari on 02/09/15.
//  Copyright (c) 2015 Rahul. All rights reserved.
//

#import "AddFromWishlistViewController.h"
#import "CartRequestHandler.h"
#import "PopOverlayHandler.h"
#import "FyndBlankPage.h"

@interface AddFromWishlistViewController ()<PopOverlayHandlerDelegate,UIAlertViewDelegate>
@property (nonatomic,strong) CartRequestHandler *cartHandler;
@property (nonatomic,strong) NSMutableArray     *productSizes;
@property (nonatomic,strong) PopOverlayHandler  *cartOverlayHandler;
@property (nonatomic,assign) NSString           *currentProductId;
@property (nonatomic,strong) FyndBlankPage      *wishlistBlankPage;
@property (nonatomic,strong) FyndActivityIndicator *indicator;
@end

@implementation AddFromWishlistViewController
#define y_padding 10.0f

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    addFromWishlistLoader = [[FyndActivityIndicator alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    [addFromWishlistLoader setCenter:CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height/2)];
    
    [self.view setBackgroundColor:UIColorFromRGB(kBackgroundGreyColor)];
    [self setEdgesForExtendedLayout:UIRectEdgeNone];

    pageNumber = 1;

    self.navigationController.navigationBar.topItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.title = @"Add From Wishlist";
    profileRequestHandler = [[ProfileRequestHandler alloc] init];
    wishlistGridView = [[GridView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - self.navigationController.navigationBar.frame.origin.y - self.navigationController.navigationBar.frame.size.height - self.tabBarController.tabBar.frame.size.height)];
    wishlistGridView.theGridViewType = GridViewTypeCartFromWishlist;
    wishlistGridView.delegate = self;
    
    [self getMyWishlist];
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

//-(void)viewWillAppear:(BOOL)animated{
//    [super viewWillAppear:animated];
//    [self.navigationController.navigationBar changeNavigationBarToTransparent:FALSE];
//}


-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self.navigationController.navigationBar changeNavigationBarToTransparent:FALSE];
    
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:TRUE];
    [self.navigationController.view setBackgroundColor:[UIColor whiteColor]];
}

-(void)getMyWishlist{
    
    theGender = [NSString stringWithFormat:@"%@",(FyndUser *)[SSUtility loadUserObjectWithKey:kFyndUserKey].gender];
    self.isFetching = FALSE;
    profileRequestHandler = [[ProfileRequestHandler alloc] init];//@{@"page":@"1"}
     paramDic = [[NSMutableDictionary alloc] init];
    [paramDic setObject:[NSString stringWithFormat:@"%d",pageNumber] forKey:@"page"];
    [paramDic setObject:theGender forKey:@"gender"];
    [paramDic setObject:@"False" forKey:@"items"];
    [paramDic setObject:@"10" forKey:@"page_size"];
    
    self.indicator = [[FyndActivityIndicator alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    [self.indicator setCenter:CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height/2 - 30)];
    [self.view addSubview:self.indicator];
    [self.indicator startAnimating];
    
    [profileRequestHandler fetchWishListData:paramDic withCompletionHandler:^(id responseData, NSError *error) {
        NSDictionary *json = responseData;
//        [SSUtility dismissActivityOverlay];
        [self.indicator stopAnimating];
        [self.indicator removeFromSuperview];
        self.indicator = nil;
        
        if(!error){
            if([json count] > 0){
                if([[json objectForKey:@"items"] count]>0){
                    [wishlistGridView.parsedDataArray addObjectsFromArray:[SSUtility parseJSON:[json objectForKey:@"items"] forGridView:wishlistGridView]];
                    self.hasNext = [[[json objectForKey:@"page"] objectForKey:@"has_next"] boolValue];
                    if(self.hasNext){
                        wishlistGridView.shouldHideLoaderSection = false;
                    }else{
                        wishlistGridView.shouldHideLoaderSection = true;
                    }
                    pageNumber++;
                    dispatch_async(dispatch_get_main_queue(), ^(void){
                        if ([wishlistGridView.parsedDataArray count]>0) {
                            [wishlistGridView addCollectionView];
                            [self.view addSubview:wishlistGridView];
                            
                        }else{
                            messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2 - 50, 50, 200, 50)];
                            [messageLabel setText:@"No Wishlist."];
                            [messageLabel setTextColor:UIColorFromRGB(kDarkPurpleColor)];
                            [self.view addSubview:messageLabel];
                            
                        }
                    });
                }else{
                    [self displayBlankPage:ErrorEmptyAddFromWishlist];
                }
            }
        }else{
            [self displayBlankPage:ErrorSystemDown];
        }
    }];
}



- (void)displayBlankPage:(ErrorBlankImage)pageType{
    
    self.wishlistBlankPage = [[FyndBlankPage alloc] initWithFrame:CGRectMake(10, y_padding, self.view.frame.size.width-20, self.view.frame.size.height- (y_padding+64+44+10)) blankPageType:pageType];
    __weak AddFromWishlistViewController *controller = self;
    self.wishlistBlankPage.blankPageBlock =^(){
        
        if(pageType == ErrorEmptyAddFromWishlist){
//            [controller.tabBarController setSelectedIndex:0];
            UINavigationController *navController = [[controller.tabBarController viewControllers] objectAtIndex:4];
            [navController popToRootViewControllerAnimated:YES];
        }
        else if(pageType == ErrorSystemDown){
            [controller tapOnRetry];
        }
        
        
    };
    [self.view addSubview:self.wishlistBlankPage];
}


- (void)tapOnRetry{
    if(self.wishlistBlankPage){
        [self.wishlistBlankPage removeFromSuperview];
        self.wishlistBlankPage = nil;
    }
    [self getMyWishlist];
}



#pragma mark GridView Delegate Methods

- (void)showBrandProductPDP:(NSString *)pdpUrl{
    [self showPDPScreen:pdpUrl];
}

- (void)showCollectionProductPDP:(NSString *)collectionURL{
    [self showPDPScreen:collectionURL];
}


- (void)addWishProductToCart:(NSString *)productId andModel:(ProductTileModel *)model{
    selectedTileModel = model;
    
    [self.view addSubview:addFromWishlistLoader];
    [addFromWishlistLoader startAnimating];
    
    if(self.cartHandler == nil){
        self.cartHandler = [[CartRequestHandler alloc] init];
    }
    
    if(self.productSizes){
        [self.productSizes removeAllObjects];
        self.productSizes = nil;
    }
    self.productSizes = [[NSMutableArray alloc] initWithCapacity:0];
    __weak AddFromWishlistViewController *currentController = self;
    self.currentProductId = productId;
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:productId,@"product_id",nil];
    [self.cartHandler getItemAvailableSizes:dict withCompletionHandler:^(id responseData, NSError *error)
     {
        
        NSArray *sizeArray = [responseData objectForKey:@"sizes"];
        for(NSInteger counter=0; counter < [sizeArray count]; counter++){
            NSDictionary *sizeDict = [sizeArray objectAtIndex:counter];
            ProductSize *size = [[ProductSize alloc] initWithDictionary:sizeDict];
            [self.productSizes addObject:size];
        }
//        [SSUtility dismissActivityOverlay];
         [addFromWishlistLoader stopAnimating];
         [addFromWishlistLoader removeFromSuperview];
         
//        [currentController showItemSizesPopUp:self.productSizes cartItem:catItem];
         [currentController displayWishListItemAvailableSizes:self.productSizes andModel:model];
    }];
    
}


- (void)displayWishListItemAvailableSizes:(NSMutableArray *)size andModel:(ProductTileModel *)model{

    
    if(self.cartOverlayHandler){
        self.cartOverlayHandler.overlayDelegate = nil;
        self.cartOverlayHandler = nil;
    }
    self.cartOverlayHandler = [[PopOverlayHandler alloc] init];
    self.cartOverlayHandler.overlayDelegate = self;
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    BOOL isTryAtHomeFirstTime = [[userDefaults objectForKey:@"isTryAtHomeGuideSeen"] boolValue];
    
    
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setObject:[NSNumber numberWithInt:AddCartInBagOverlay] forKey:@"PopUpType"];
    [parameters setObject:[NSNumber numberWithBool:isTryAtHomeFirstTime] forKey:@"TryAtHomeModuleType"];
    
    [parameters setObject:[NSNumber numberWithInt:1] forKey:@"maxSizeSelection"];

//    NSArray *preSelectedSize = [item.itemSize componentsSeparatedByString:@","];
//    [parameters setObject:preSelectedSize forKey:@"preSelectedSize"];
    
    [parameters setObject:size forKey:@"PopUpData"];
    [parameters setObject:@"CANCEL" forKey:@"LeftButtonTitle"];
    [parameters setObject:@"ADD TO BAG" forKey:@"RightButtonTitle"];
    [parameters setObject:[NSNumber numberWithInteger:SelectSizeFromWishlist] forKey:@"TryAtHomAction"];
    [self.cartOverlayHandler presentOverlay:SizeGuideOverlay rootView:self.view enableAutodismissal:TRUE withUserInfo:parameters];
    
}


- (void)performActionOnOverlay:(NSInteger)tag andPopType:(RPWOverlayType )type andInputDictionary:(NSMutableDictionary *)dictionary{
 
    if(tag==-1){ //If user click on cancel then this will execute
        [self.cartOverlayHandler dismissOverlay];
        return;
    }
    
    switch (type) {
//        case TryAtHomeOverlay:
            case AddCartInBagOverlay:
                [self.cartOverlayHandler dismissOverlay];
                self.cartOverlayHandler.contentView.userInteractionEnabled = FALSE;
                [self addWishListItemToCart:[[dictionary objectForKey:@"selectedSizeData"] objectAtIndex:0]];
            break;
         default:
            break;
    }
}


- (void)addWishListItemToCart:(ProductSize *)productSize{
    [self.view addSubview:addFromWishlistLoader];
    [addFromWishlistLoader startAnimating];
    
     NSDictionary *paramDict = [[NSDictionary alloc] initWithObjectsAndKeys:@"standard",@"order_type",self.currentProductId,@"product_id",productSize.sizeValue,@"size1", nil];
    
    __weak PopOverlayHandler *popOverHandler = self.cartOverlayHandler;
    __weak  AddFromWishlistViewController *ctrl = self;
    __weak FyndActivityIndicator *weakLoader = addFromWishlistLoader;
    [self.cartHandler addItemIntoCart:paramDict withCompletionHandler:^(id responseData, NSError *error) {
        [weakLoader stopAnimating];
        [weakLoader removeFromSuperview];
        
        ctrl.cartOverlayHandler.contentView.userInteractionEnabled = TRUE;
        [popOverHandler dismissOverlay];
        BOOL successStatus = [[responseData objectForKey:@"is_added"] boolValue];
            [FyndAnalytics trackAddToBagWithType:@"buy" brandName:selectedTileModel.brand_name itemCode:selectedTileModel.productID articleCode:@"" productPrice:[NSString stringWithFormat:@"%ld", (long)selectedTileModel.price_effective] from:@"wishlist"];

//        //Increment the counter and change the icon
//        int totalBagItems =[[[NSUserDefaults standardUserDefaults] valueForKey:kHasItemInBag] intValue];
//        
//        
//        if (totalBagItems>0) {
//            totalBagItems ++;
//        }else{
//            totalBagItems ++;
//            UITabBarItem *cartBarItem = [self.tabBarController.tabBar.items objectAtIndex:4];
//            [cartBarItem setSelectedImage:[UIImage imageNamed:@"CartFilledSelectedTab"]];
//            [cartBarItem setImage:[UIImage imageNamed:@"CartFilledTab"]];
//        }

        
            if(ctrl.itemAdded){
                [ctrl.navigationController popViewControllerAnimated:TRUE];
                ctrl.itemAdded(successStatus);
            }
    }];
}


- (void)wishListItemSuccessAlert:(BOOL)aBool{
    NSString *messageString = nil;
    if(aBool){
        messageString = @"Item,Added to your cart";
    }else{
        messageString = @"There is a problem at server end.";
    }
//    
//    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:messageString delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
//    [alertView show];
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(buttonIndex == 0){
        [self.navigationController popViewControllerAnimated:TRUE];
    }
}


-(void)didScrollToEndOfLastPage{
    
    [paramDic setObject:[NSString stringWithFormat:@"%d",pageNumber] forKey:@"page"];

    NSInteger prevLastIndex = [wishlistGridView.parsedDataArray count] - 1;
    __block NSInteger newLastIndex = 0;
    
    if(self.hasNext){
        [profileRequestHandler fetchWishListData:paramDic withCompletionHandler:^(id responseData, NSError *error) {
            if([[responseData objectForKey:@"items"] count] > 0){
                pageNumber++;
            [wishlistGridView.parsedDataArray addObjectsFromArray:[SSUtility parseJSON:[responseData objectForKey:@"items"] forGridView:wishlistGridView]];
            newLastIndex = [wishlistGridView.parsedDataArray count] - 1;
            
            NSMutableArray *indexSetArray = [[NSMutableArray alloc] initWithCapacity:0];
            for(int i = 0; i < newLastIndex - prevLastIndex; i++){
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i+prevLastIndex +1 inSection:0];
                [indexSetArray addObject:indexPath];
            }
            self.hasNext = [[[responseData objectForKey:@"page"] objectForKey:@"has_next"] boolValue];
            if(self.hasNext){
                wishlistGridView.shouldHideLoaderSection = false;
            }else{
                wishlistGridView.shouldHideLoaderSection = true;
            }
            dispatch_async(dispatch_get_main_queue(), ^(void){
                [wishlistGridView reloadCollectionView:indexSetArray];
            });
        }
        }];
    }
}

- (void)showPDPScreen:(NSString *)url{
    if(self.pdpController){
        self.pdpController = nil;
    }
    self.pdpController = [[PDPViewController alloc] init];
    self.pdpController.productURL = url;
    [self.navigationController pushViewController:self.pdpController animated:YES];
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

@end
