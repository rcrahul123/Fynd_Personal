//
//  WishListView.m
//  Explore
//
//  Created by Amboj Goyal on 8/11/15.
//  Copyright (c) 2015 Rahul. All rights reserved.
//

#import "WishListView.h"
#import "GridView.h"
#import "TabBarViewController.h"

@implementation WishListView

-(void)configureWishList{
    [self setBackgroundColor:UIColorFromRGB(kBackgroundGreyColor)];

    if(isWishlistObserverAdded){
        [self removeObserver:self forKeyPath:@"self.wishListGridView.collectionView.contentSize"];
        isWishlistObserverAdded = false;
        
    }
    if(self.wishListGridView){
        [self.wishListGridView removeFromSuperview];
        self.wishListGridView = nil;
    }
    if(self.fyndBlankPage){
        [self.fyndBlankPage removeFromSuperview];
        self.fyndBlankPage = nil;
    }
    
//    [SSUtility showActivityOverlay:self];
    if(self.delegate && [self.delegate respondsToSelector: @selector(showLoader)]){
        [self.delegate showLoader];
    }
    self.wishListGridView = [[GridView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    self.wishListGridView.theGridViewType = GridViewTypeWishList;
//    self.wishListGridView.theGridViewType = GridViewTypeCartFromWishlist;

    self.wishListGridView.delegate = self;
    
    
    [self addObserver:self forKeyPath:@"self.wishListGridView.collectionView.contentSize" options:NSKeyValueObservingOptionOld context:NULL];
    isWishlistObserverAdded = true;
    
    pageNumber = 1;
    theGender = [NSString stringWithFormat:@"%@",(FyndUser *)[SSUtility loadUserObjectWithKey:kFyndUserKey].gender];
    self.isFetching = FALSE;
    profileRequestHandler = [[ProfileRequestHandler alloc] init];//@{@"page":@"1"}
    NSMutableDictionary *paramDic = [[NSMutableDictionary alloc] init];
    [paramDic setObject:[NSString stringWithFormat:@"%d",pageNumber] forKey:@"page"];
    [paramDic setObject:theGender forKey:@"gender"];
    [paramDic setObject:@"False" forKey:@"items"];
//    [paramDic setObject:@"3" forKey:@"page_size"];
    
    [profileRequestHandler fetchWishListData:paramDic withCompletionHandler:^(id responseData, NSError *error) {
        NSDictionary *json = responseData;
//        [SSUtility dismissActivityOverlay];
        if(self.delegate && [self.delegate respondsToSelector: @selector(dismissLoader)]){
            [self.delegate dismissLoader];
        }
        if([json count] > 0){
            [self.wishListGridView.parsedDataArray addObjectsFromArray:[SSUtility parseJSON:[json objectForKey:@"items"] forGridView:self.wishListGridView]];
            self.hasNext = [[[json objectForKey:@"page"] objectForKey:@"has_next"] boolValue];
            if(!self.hasNext){
                self.wishListGridView.shouldHideLoaderSection = true;
            }else{
                self.wishListGridView.shouldHideLoaderSection = false;
            }
            dispatch_async(dispatch_get_main_queue(), ^(void){
                if ([self.wishListGridView.parsedDataArray count]>0) {
                    if(self.fyndBlankPage){
                        [self.fyndBlankPage removeFromSuperview];
                        self.fyndBlankPage = nil;
                    }
                    [self.wishListGridView addCollectionView];
                    [self addSubview:self.wishListGridView];

                }else{
                   
                    if(self.fyndBlankPage){
                        [self.fyndBlankPage removeFromSuperview];
                        self.fyndBlankPage = nil;
                    }
//                    self.fyndBlankPage = [[FyndBlankPage alloc] initWithFrame:CGRectMake(10, 10, self.frame.size.width-20, self.frame.size.height+RelativeSizeHeight(55, 250)) blankPageType:ErrorNoWishlist];
                    self.fyndBlankPage = [[FyndBlankPage alloc] initWithFrame:CGRectMake(10, 10, self.frame.size.width-20, 300) blankPageType:ErrorNoWishlist];

                    [self setFrame:CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, self.fyndBlankPage.frame.origin.y + self.fyndBlankPage.frame.size.height)];
                    [self.fyndBlankPage setBackgroundColor:[UIColor whiteColor]];
                    __weak WishListView *aView = self;
                   self.fyndBlankPage.blankPageBlock =^(){
                        if(aView.wishListViewBlock){
                            aView.wishListViewBlock();
                        }
                    };
//                    [fyndBlankPage setBackgroundColor:[UIColor redColor]];
                    [self addSubview:self.fyndBlankPage];
                }
            });
        }
    }];
}


-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context{
    if([keyPath isEqualToString:@"self.wishListGridView.collectionView.contentSize"]){
        [self.wishListGridView.collectionView setFrame:CGRectMake(self.wishListGridView.collectionView.frame.origin.x, self.wishListGridView.collectionView.frame.origin.y, self.wishListGridView.collectionView.frame.size.width, self.wishListGridView.collectionView.frame.origin.y + self.wishListGridView.collectionView.contentSize.height)];
        [self.wishListGridView setFrame:CGRectMake(self.wishListGridView.frame.origin.x, self.wishListGridView.frame.origin.y, self.wishListGridView.frame.size.width, self.wishListGridView.collectionView.frame.origin.y + self.wishListGridView.collectionView.contentSize.height)];
        [self setFrame:CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, self.wishListGridView.frame.origin.y + self.wishListGridView.frame.size.height)];
    }
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
 if(scrollView.contentOffset.y + scrollView.frame.size.height >= scrollView.contentSize.height - 100 && scrollView.contentOffset.y > 0 && self.hasNext)
 {
     self.isFetching = true;
     
     
     NSInteger prevLastIndex = [self.wishListGridView.parsedDataArray count] - 1;
     __block NSInteger newLastIndex = 0;
     
     [profileRequestHandler fetchWishListData:[NSDictionary dictionaryWithObject:[NSString stringWithFormat:@"%d", ++pageNumber] forKey:@"page"] withCompletionHandler:^(id responseData, NSError *error) {
         NSDictionary *json = responseData;
         pageNumber++;
         
         [self.wishListGridView.parsedDataArray addObjectsFromArray:[SSUtility parseJSON:[json objectForKey:@"items"] forGridView:self.wishListGridView]];
         self.hasNext = [[[json objectForKey:@"page"] objectForKey:@"has_next"] boolValue];
         if(!self.hasNext){
             self.wishListGridView.shouldHideLoaderSection = true;
         }else{
             self.wishListGridView.shouldHideLoaderSection = false;
         }
         newLastIndex = [self.wishListGridView.parsedDataArray count] - 1;
         
         NSMutableArray *indexSetArray = [[NSMutableArray alloc] initWithCapacity:0];
         for(int i = 0; i < newLastIndex - prevLastIndex; i++){
             NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i+prevLastIndex +1 inSection:0];
             [indexSetArray addObject:indexPath];
         }
         dispatch_async(dispatch_get_main_queue(), ^(void){
             self.isFetching = false;
             
             [self.wishListGridView reloadCollectionView:indexSetArray];
         });
     }];

 }
}

- (void)reloadWishList{
    

    self.isFetching = true;
    NSInteger prevLastIndex = [self.wishListGridView.parsedDataArray count] - 1;
    __block NSInteger newLastIndex = 0;
    
    pageNumber++;
    NSMutableDictionary *paramDic = [[NSMutableDictionary alloc] init];
    [paramDic setObject:[NSString stringWithFormat:@"%d",pageNumber] forKey:@"page"];
    [paramDic setObject:theGender forKey:@"gender"];
    [paramDic setObject:@"False" forKey:@"items"];
    [paramDic setObject:@"10" forKey:@"page_size"];
    

    [profileRequestHandler fetchWishListData:paramDic withCompletionHandler:^(id responseData, NSError *error) {
        NSDictionary *json = responseData;
        [self.wishListGridView.parsedDataArray addObjectsFromArray:[SSUtility parseJSON:[json objectForKey:@"items"] forGridView:self.wishListGridView]];
        self.hasNext = [[[json objectForKey:@"page"] objectForKey:@"has_next"] boolValue];
        if(!self.hasNext){
            self.wishListGridView.shouldHideLoaderSection = true;
        }else{
            self.wishListGridView.shouldHideLoaderSection = false;
        }
        newLastIndex = [self.wishListGridView.parsedDataArray count] - 1;
        
        NSMutableArray *indexSetArray = [[NSMutableArray alloc] initWithCapacity:0];
        for(int i = 0; i < newLastIndex - prevLastIndex; i++){
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i+prevLastIndex +1 inSection:0];
            [indexSetArray addObject:indexPath];
        }
        dispatch_async(dispatch_get_main_queue(), ^(void){
            self.isFetching = false;
            [self.wishListGridView reloadCollectionView:indexSetArray];
        });
    }];
}


- (void)showPDPScreen:(NSString *)url{
    if (self.thePDPCallback) {
        self.thePDPCallback(url);
    }
}



- (void)addWishProductToCart:(NSString *)productId andModel:(ProductTileModel *)model{
    selectedTileModel = model;
    
    if(self.delegate && [self.delegate respondsToSelector: @selector(showLoader)]){
        [self.delegate showLoader];
    }
    if(self.cartHandler == nil){
        self.cartHandler = [[CartRequestHandler alloc] init];
    }
    
    if(self.productSizes){
        [self.productSizes removeAllObjects];
        self.productSizes = nil;
    }
    self.productSizes = [[NSMutableArray alloc] initWithCapacity:0];
    __weak WishListView *currentController = self;
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
         if(self.delegate && [self.delegate respondsToSelector: @selector(dismissLoader)]){
             [self.delegate dismissLoader];
         }
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
    
    [parameters setObject:size forKey:@"PopUpData"];
    [parameters setObject:@"CANCEL" forKey:@"LeftButtonTitle"];
    [parameters setObject:@"ADD TO BAG" forKey:@"RightButtonTitle"];
    [parameters setObject:[NSNumber numberWithInteger:SelectSizeFromWishlist] forKey:@"TryAtHomAction"];
    [self.cartOverlayHandler presentOverlay:SizeGuideOverlay rootView:self enableAutodismissal:TRUE withUserInfo:parameters];
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
    if(self.delegate && [self.delegate respondsToSelector: @selector(showLoader)]){
        [self.delegate showLoader];
    }
    
    NSDictionary *paramDict = [[NSDictionary alloc] initWithObjectsAndKeys:@"standard",@"order_type",self.currentProductId,@"product_id",productSize.sizeValue,@"size1", nil];
    
    __weak PopOverlayHandler *popOverHandler = self.cartOverlayHandler;
    __weak  WishListView *ctrl = self;
    [self.cartHandler addItemIntoCart:paramDict withCompletionHandler:^(id responseData, NSError *error) {
        if(ctrl.delegate && [ctrl.delegate respondsToSelector: @selector(dismissLoader)]){
            [ctrl.delegate dismissLoader];
        }
        ctrl.cartOverlayHandler.contentView.userInteractionEnabled = TRUE;
        [popOverHandler dismissOverlay];
        BOOL successStatus = [[responseData objectForKey:@"is_added"] boolValue];
        if (successStatus) {
            [SSUtility showOverlayViewWithMessage:@"1 item added to your bag" andColor:UIColorFromRGB(kGreenColor)];
            [FyndAnalytics trackAddToBagWithType:@"buy" brandName:selectedTileModel.brand_name itemCode:selectedTileModel.productID articleCode:@"" productPrice:[NSString stringWithFormat:@"%ld", (long)selectedTileModel.price_effective] from:@"wishlist"];

            NSArray *viewControllersArray = [(UINavigationController *)[self.window rootViewController] viewControllers];
            
            __block UITabBarController *tabController;
            
            [viewControllersArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if ([obj isKindOfClass:[TabBarViewController class]]) {
                    tabController = (UITabBarController *)[viewControllersArray objectAtIndex:idx];
                }
            }];

            
            
        //Increment the counter and change the icon
        int totalBagItems =[[[NSUserDefaults standardUserDefaults] valueForKey:kHasItemInBag] intValue];


        if (totalBagItems>0) {
            totalBagItems ++;
        }else{
            totalBagItems ++;
            UITabBarItem *cartBarItem = [tabController.tabBar.items objectAtIndex:4];
            [cartBarItem setSelectedImage:[[UIImage imageNamed:@"CartFilledSelectedTab"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
            [cartBarItem setImage:[[UIImage imageNamed:@"CartFilledTab"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
            }

        }
        
        
        NSInteger index = -1;
        for(int i = 0; i < [self.wishListGridView.parsedDataArray count]; i++){
            if([[[self.wishListGridView.parsedDataArray objectAtIndex:i] objectForKey:@"values"] isEqual:selectedTileModel]){
                index = i;
                break;
            }
        }
        if(index >= 0){
//            [self.wishListGridView deleteCellAt:[NSIndexPath indexPathForItem:index inSection:0] withAnimation:YES];
        }
    }];
}

@end
