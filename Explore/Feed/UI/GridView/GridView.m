
//  GridView.m
//  
//
//  Created by Rahul on 7/6/15.
//
//

#import "GridView.h"

@implementation GridView
@synthesize shouldHideLoaderSection;

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    
    if(self){
        
        isFetching = false;
        self.parsedDataArray = [[NSMutableArray alloc] initWithCapacity:0];
//        collectionViewFrame = CGRectMake(RelativeSize(3, 320), RelativeSize(3, 320), self.frame.size.width - RelativeSize(6, 320), self.frame.size.height);
        collectionViewFrame = CGRectMake(RelativeSize(3, 320), RelativeSize(0, 320), self.frame.size.width - RelativeSize(6, 320), self.frame.size.height);

        flow = [[CustomFlow alloc] init];
        myCollectionView = [[UICollectionView alloc] initWithFrame:collectionViewFrame collectionViewLayout:flow];
        [myCollectionView setShowsVerticalScrollIndicator:FALSE];
        [myCollectionView setShowsHorizontalScrollIndicator:FALSE];
        self.collectionView = myCollectionView;
    }
    return self;
}

-(void)setShouldHideLoaderSection:(BOOL)theBool{
    shouldHideLoaderSection = theBool;
    flow.isLoaderHidden = theBool;
    if(shouldHideLoaderSection){
        [self removeLoaderSection];
    }
}


-(void)removeLoaderSection{
    NSInteger sectionCount = [self.collectionView numberOfSections];
    if(sectionCount > 1){
//        NSIndexSet *set = [[NSIndexSet alloc] initWithIndex:1];
//        [self.collectionView deleteSections:set];
//
////        GridStatusCollectionViewCell *cell = (GridStatusCollectionViewCell *)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:1]];
////        [cell setHidden:YES];
        
    }
}



-(void)addCollectionView{
 
    flow.dataArray = self.parsedDataArray;
    [myCollectionView setBackgroundColor:UIColorFromRGB(kBackgroundGreyColor)];
    
    [myCollectionView registerClass:[GridStatusCollectionViewCell class] forCellWithReuseIdentifier:@"StatusCell"];
    [myCollectionView registerClass:[HTMLCollectionViewCell class] forCellWithReuseIdentifier:@"HTMLCell"];

    [myCollectionView registerClass:[ProductCell class] forCellWithReuseIdentifier:@"Cell"];
    [myCollectionView registerClass:[BrandsGrid class] forCellWithReuseIdentifier:@"Brand"];
    [myCollectionView registerClass:[CollectionGrid class] forCellWithReuseIdentifier:@"Collection"];
    [myCollectionView registerClass:[TipCollectionViewCell class] forCellWithReuseIdentifier:@"Tip"];
    [myCollectionView registerClass:[WelcomeCardCell class] forCellWithReuseIdentifier:@"WelcomeCard"];
    [myCollectionView registerClass:[OffersContainerCollectionViewCell class] forCellWithReuseIdentifier:@"OfferCell"];
    [myCollectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"LargeOfferCell"];

    
    myCollectionView.delegate = self;
    myCollectionView.dataSource = self;
    [self addSubview:myCollectionView];
}



#pragma delegates nd datasources

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{

    return CGSizeZero;
}


-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
//    if(self.shouldHideLoaderSection){
//        return 1;
//    }else
//        return 2;
    return 2;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if(section == 0)
        return [self.parsedDataArray count];
    else
        return 1;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if(indexPath.section == 0){
        
        if([[[self.parsedDataArray objectAtIndex:indexPath.row] objectForKey:@"tile_type"] isEqualToString:@"loader"]){
            
            GridStatusCollectionViewCell *cell = (GridStatusCollectionViewCell *)[myCollectionView dequeueReusableCellWithReuseIdentifier:@"StatusCell" forIndexPath:indexPath];
            cell.layer.shouldRasterize = YES;
            cell.layer.rasterizationScale = [UIScreen mainScreen].scale;
            cell.message = [[self.parsedDataArray lastObject] objectForKey:@"value"];
            return  cell;
        }
        else if([[[self.parsedDataArray objectAtIndex:indexPath.row] objectForKey:@"tile_type"] isEqualToString:@"html"]){
            
             HTMLCollectionViewCell *cell = (HTMLCollectionViewCell *)[myCollectionView dequeueReusableCellWithReuseIdentifier:@"HTMLCell" forIndexPath:indexPath];
             cell.layer.shouldRasterize = YES;
             cell.layer.rasterizationScale = [UIScreen mainScreen].scale;
             cell.webView.tag = indexPath.row + 1;
             cell.model = (HTMLTileModel *)[[self.parsedDataArray objectAtIndex:indexPath.row] objectForKey:@"values"];
             cell.htmlDelegate = self;

             
            
            return  cell;
        }
        else if([[[self.parsedDataArray objectAtIndex:indexPath.row] objectForKey:@"tile_type"] isEqualToString:@"product"]){
            
            ProductCell *cell = (ProductCell *)[myCollectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
            cell.layer.shouldRasterize = YES;
            cell.layer.rasterizationScale = [UIScreen mainScreen].scale;
            if(self.isSearched){
                cell.isSearched = true;
            }
            if(self.isBrowsed){
                cell.isBrowsed = true;
            }
            cell.addWishListProductBlock = ^(NSString *productId, ProductTileModel *model){
                [self.delegate addWishProductToCart:productId andModel:model];
            };
            
            cell.cellModel = (ProductTileModel *)[[self.parsedDataArray objectAtIndex:indexPath.row] objectForKey:@"values"];
            if (self.theGridViewType == GridViewTypePlain) {
                cell.cellModel.tileType = ProductTilePlain;
            }else if(self.theGridViewType == GridViewTypeWishList){
                cell.cellModel.tileType = ProductTileWishList;
            }else  if(self.theGridViewType == GridViewTypeWishList){
                cell.cellModel.tileType = ProductTileAddToCartFromWishlist;
            }
            cell.theProductLocationBlock = ^(UITouch *theTouchLocation, BOOL isLiked){
                CGPoint pt = [theTouchLocation locationInView:self.superview];
                [self deleteAtPoint:pt withBool:isLiked];
            };
            
            
            return cell;
            
        }else if([[[self.parsedDataArray objectAtIndex:indexPath.row] objectForKey:@"tile_type"] isEqualToString:@"tip"]){
            TipCollectionViewCell *cell = (TipCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"Tip" forIndexPath:indexPath];
            cell.layer.shouldRasterize = YES;
            cell.layer.rasterizationScale = [UIScreen mainScreen].scale;
            cell.model = (TipTileModel *)[[self.parsedDataArray objectAtIndex:indexPath.row] objectForKey:@"values"];
            return cell;
            
        }else if([[[self.parsedDataArray objectAtIndex:indexPath.row] objectForKey:@"tile_type"] isEqualToString:@"brand"]){
            BrandsGrid *cell = (BrandsGrid *)[collectionView dequeueReusableCellWithReuseIdentifier:@"Brand" forIndexPath:indexPath];
            cell.layer.shouldRasterize = YES;
            cell.layer.rasterizationScale = [UIScreen mainScreen].scale;
            cell.currentBrandData = (BrandTileModel *)[[self.parsedDataArray objectAtIndex:indexPath.row] objectForKey:@"values"];
            cell.brandGridDelegate = self;
            if (self.theGridViewType == GridViewTypeMyBrand) {
                cell.currentBrandData.theBrandTileType = BrandTileMyBrand;
            }else{
                cell.currentBrandData.theBrandTileType = BrandTilePlain;
            }
            CGFloat calculatedWidth = ((self.frame.size.width - 2*kGridComponentPadding) - 2*kGridComponentPadding)/3.5;
            
            cell.brandBannerWidth = self.frame.size.width;
            if(cell.currentBrandData.products && [cell.currentBrandData.products count]>0){
                SubProductModel *subProduct = [cell.currentBrandData.products objectAtIndex:0];
                CGFloat productContainerHeight = [self getProductsAspectRatio:subProduct.subProductAspectRatio andWidth:calculatedWidth];
                
                CGSize aSize = CGSizeMake(calculatedWidth,productContainerHeight);
                cell.brandCollectionViewSize = aSize;
                cell.brandBannerWidth = self.frame.size.width;
            }
            cell.theBrandLocationBlock = ^(UITouch *theTouch,BOOL isFollowing){
                CGPoint brandPoint = [theTouch locationInView:myCollectionView];
                [self deleteAtPoint:brandPoint withBool:isFollowing];
            };
            
//            [cell configureBrandGrid];
            return cell;
            
        }else if([[[self.parsedDataArray objectAtIndex:indexPath.row] objectForKey:@"tile_type"] isEqualToString:@"collection"]){
            CollectionGrid *cell = (CollectionGrid *)[collectionView dequeueReusableCellWithReuseIdentifier:@"Collection" forIndexPath:indexPath];
            cell.layer.shouldRasterize = YES;
            cell.layer.rasterizationScale = [UIScreen mainScreen].scale;
            cell.collectionTileModel = (CollectionTileModel *)[[self.parsedDataArray objectAtIndex:indexPath.row] objectForKey:@"values"];
            cell.collectionDelegate = self;
            if (self.theGridViewType == GridViewTypeMyCollection) {
                cell.collectionTileModel.theCollectionTileType = CollectionTileMyCollection;
            }else{
                cell.collectionTileModel.theCollectionTileType = CollectionTilePlain;
            }
            
            cell.bannerWidth = self.frame.size.width;
            CGFloat calculatedWidth = ((self.frame.size.width - 2*kGridComponentPadding) - 2*kGridComponentPadding)/3.5;
            
            if(cell.collectionTileModel.products && [cell.collectionTileModel.products count]>0){
                SubProductModel *subProduct = [cell.collectionTileModel.products objectAtIndex:0];
                CGFloat productContainerHeight = [self getProductsAspectRatio:subProduct.subProductAspectRatio andWidth:calculatedWidth];
                
                CGSize aSize = CGSizeMake(calculatedWidth,productContainerHeight);
                cell.collectionViewCellSize = aSize;
            }
            cell.theCollectionLocationBlock = ^(UITouch *theTouch,BOOL isFollowing){
                CGPoint pt = [theTouch locationInView:myCollectionView];
                [self deleteAtPoint:pt withBool:isFollowing];
            };
//            [cell configureCollectionGrid];
            return cell;
        }
        else if([[[self.parsedDataArray objectAtIndex:indexPath.row] objectForKey:@"tile_type"] isEqualToString:@"welcome"]){
            WelcomeCardCell *cell = (WelcomeCardCell *)[myCollectionView dequeueReusableCellWithReuseIdentifier:@"WelcomeCard" forIndexPath:indexPath];
            cell.layer.shouldRasterize = YES;
            cell.layer.rasterizationScale = [UIScreen mainScreen].scale;

            BOOL isOrder = [[[self.parsedDataArray objectAtIndex:indexPath.row] valueForKey:@"isOrderCard"] boolValue];
            if (isOrder) {
                cell.isOrderCard = TRUE;
            }else{
                cell.isOrderCard = FALSE;
            }

            cell.theCallBackBlock = ^(NSString *theType){
                [self showScreen:theType];
            };
            return cell;
            
        }else if([[[self.parsedDataArray objectAtIndex:indexPath.row] objectForKey:@"tile_type"] isEqualToString:@"card"]){
            OffersContainerCollectionViewCell *cell = (OffersContainerCollectionViewCell *)[myCollectionView dequeueReusableCellWithReuseIdentifier:@"OfferCell" forIndexPath:indexPath];
            cell.offerDelegate = self;
            cell.offersModel = (OffersTileModel *)[[self.parsedDataArray objectAtIndex:indexPath.row] objectForKey:@"values"];
            return  cell;
            
        }else if([[[self.parsedDataArray objectAtIndex:indexPath.row] objectForKey:@"tile_type"] isEqualToString:@"carousal"]){
            UICollectionViewCell *cell = (UICollectionViewCell *)[myCollectionView dequeueReusableCellWithReuseIdentifier:@"LargeOfferCell" forIndexPath:indexPath];
            
            LargeOfferCell *view = [[LargeOfferCell alloc] initWithFrame:cell.bounds andModel:(OffersTileModel *)[[self.parsedDataArray objectAtIndex:indexPath.row] objectForKey:@"values"]];
            view.delegate = self;
            [cell addSubview:view];

            return  cell;
        }
    }else{
        GridStatusCollectionViewCell *statusCell = (GridStatusCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"StatusCell" forIndexPath:indexPath];
        statusCell.layer.shouldRasterize = YES;
        statusCell.layer.rasterizationScale = [UIScreen mainScreen].scale;
        if(self.shouldHideLoaderSection){
            [statusCell setHidden:YES];
        }else{
            [statusCell setHidden:NO];
        }
        return statusCell;
    }
    return nil;
}


- (CGFloat)getProductsAspectRatio:(NSString *)aspectRatio andWidth:(CGFloat)width{
    CGFloat height = 0;
    NSArray *ratioArray = [aspectRatio componentsSeparatedByString:@":"];
    height = (width) * [[ratioArray lastObject] floatValue] / [[ratioArray firstObject] floatValue];
    return height;
}



- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0.0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 0.0;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
//    if([[[self.parsedDataArray objectAtIndex:indexPath.row] objectForKey:@"tile_type"] isEqualToString:@"brand"]){
//        BrowseByBrandViewController *brandDisplayPage = [[BrowseByBrandViewController alloc] init];
//        [self.navigationController pushViewController:brandDisplayPage animated:YES];
    
//    }
    
    if([[[self.parsedDataArray objectAtIndex:indexPath.row] objectForKey:@"tile_type"] isEqualToString:@"product"]){
        ProductCell *cell = (ProductCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
        [cell removeShadow];
        
        ProductTileModel *model = (ProductTileModel *)[[self.parsedDataArray objectAtIndex:indexPath.row] objectForKey:@"values"];
        
//        if (self.theGridViewType == GridViewTypeWishList) {
//            if (cell.alpha>=0.9) {
//                if([self.delegate respondsToSelector:@selector(showPDPScreen:)]){
//                    [self.delegate showPDPScreen:model.action.url];
//                }
//            }
//        }else{
            if([self.delegate respondsToSelector:@selector(showPDPScreen:)]){
                [self.delegate showPDPScreen:model.action.url];
            }
//        }
        
    }else if([[[self.parsedDataArray objectAtIndex:indexPath.row] objectForKey:@"tile_type"] isEqualToString:@"brand"]){
        BrandTileModel *model = (BrandTileModel *)[[self.parsedDataArray objectAtIndex:indexPath.row] objectForKey:@"values"];
        
//        BrandsGrid *cell = (BrandsGrid *)[self.collectionView cellForItemAtIndexPath:indexPath];
        
//        if (self.theGridViewType == GridViewTypeMyBrand) {
//            if (cell.alpha>=0.9) {
//                if([self.delegate respondsToSelector:@selector(showBrowseByBrandPage:)]){
//                    [self.delegate showBrowseByBrandPage:model.action.url];
//                }
//            }
//        }else{
            if([self.delegate respondsToSelector:@selector(showBrowseByBrandPage:)]){
                [self.delegate showBrowseByBrandPage:model.action.url];
            }
//        }
    }else if([[[self.parsedDataArray objectAtIndex:indexPath.row] objectForKey:@"tile_type"] isEqualToString:@"collection"]){
        CollectionTileModel *model = (CollectionTileModel *)[[self.parsedDataArray objectAtIndex:indexPath.row] objectForKey:@"values"];
//        CollectionGrid *cell = (CollectionGrid *)[self.collectionView cellForItemAtIndexPath:indexPath];

//        if (self.theGridViewType == GridViewTypeMyCollection) {
//            if (cell.alpha>=0.9) {
//                if([self.delegate respondsToSelector:@selector(showBrowseByCollectionPage:)]){
//                    [self.delegate showBrowseByCollectionPage:model.action.url];
//                }
//            }
//        }else{
            if([self.delegate respondsToSelector:@selector(showBrowseByCollectionPage:)]){
                [self.delegate showBrowseByCollectionPage:model.action.url];
            }
//        }
        
    }
}

-(void)reloadCollectionView:(NSArray *)indexArray{
    flow.dataArray = self.parsedDataArray;

    [myCollectionView insertItemsAtIndexPaths:indexArray];

    isFetching = false;
  
}

-(void)reloadCollectionView{
    flow.dataArray = self.parsedDataArray;
    [myCollectionView reloadData];
    isFetching = false;
    
    [self.collectionView setContentOffset:CGPointZero animated:NO];
}

-(void)deleteAtPoint:(CGPoint)pt withBool:(BOOL)islike{
    
//    CGPoint pt = [loc locationInView:self.superview];
    
    NSIndexPath *indexPath = [myCollectionView indexPathForItemAtPoint:pt];
    if (self.theGridViewType == GridViewTypeWishList || self.theGridViewType == GridViewTypeMyBrand || self.theGridViewType == GridViewTypeMyCollection) {
        [UIView animateWithDuration:0.5 animations:^{
            UICollectionViewCell *theCell = (UICollectionViewCell *)[myCollectionView cellForItemAtIndexPath:indexPath];
            if (!islike) {
                [theCell setAlpha:0.2];
            }else{
                [theCell setAlpha:1.0];
            }
            
        } completion:^(BOOL finished) {
        }];

    }
//    else
//        [self deleteCellAt:indexPath withAnimation:YES];
}


-(void)deleteCellAt:(NSIndexPath *)indexPath withAnimation:(BOOL)animate{
    [self.parsedDataArray removeObjectAtIndex:indexPath.row];
    flow.dataArray = self.parsedDataArray;
    
    if(animate){
        [UIView animateWithDuration:0.5 animations:^{
            [myCollectionView deleteItemsAtIndexPaths:@[indexPath]];
        } completion:^(BOOL finished) {
        }];
    }else{
        [myCollectionView deleteItemsAtIndexPaths:[NSArray arrayWithObject:indexPath]];
    }
}


#pragma mark BrandGrid Delegate
- (void)selectedBrandProduct:(NSString *)productUrl{
    if([self.delegate respondsToSelector:@selector(showBrandProductPDP:)]){
        [self.delegate showBrandProductPDP:productUrl];
    }
}
-(void)brandFollowingData:(BrandTileModel *)theBrandModel{
    if([self.delegate respondsToSelector:@selector(brandFollowing:)]){
        [self.delegate brandFollowing:theBrandModel];
    }
}

#pragma mark CollectionGrid Delegate

- (void)selectedCollectionProduct:(NSString *)productUrl{
    if([self.delegate respondsToSelector:@selector(showCollectionProductPDP:)]){
        [self.delegate showCollectionProductPDP:productUrl];
    }
}
-(void)collectionFollowingData:(CollectionTileModel *)theCollectionModel{
    if([self.delegate respondsToSelector:@selector(collectionFollowing:)]){
        [self.delegate collectionFollowing:theCollectionModel];
    }
}


#pragma mark - OfferCelll delegate
-(void)offerTapped:(OfferSubTile *)offerData{
    ActionModel *actionModel = (ActionModel *)[offerData actionModel];
    
    NSString *actionURL = actionModel.url;
    if(actionURL){
        
        if([[actionModel.type lowercaseString] isEqualToString:@"product"]){
            //show pdp
            if(self.delegate && [self.delegate respondsToSelector:@selector(showPDPScreen:)]){
                [self.delegate showPDPScreen:actionURL];
            }
            
        }else if([[actionModel.type lowercaseString] isEqualToString:@"brand"]){
            //show brand page
            if(self.delegate && [self.delegate respondsToSelector:@selector(showBrowseByBrandPage:)]){
                [self.delegate showBrowseByBrandPage:actionURL];
            }
            
        }else if([[actionModel.type lowercaseString] isEqualToString:@"collection"]){
            //show collection page
            if(self.delegate && [self.delegate respondsToSelector:@selector(showBrowseByCollectionPage:)]){
                [self.delegate showBrowseByCollectionPage:actionURL];
            }
        }else if([[actionModel.type lowercaseString] isEqualToString:@"category"] || [[actionModel.type lowercaseString] isEqualToString:@"search"]){
            //show collection page
            if(self.delegate && [self.delegate respondsToSelector:@selector(showBrowseByCategoryPage:)]){
                [self.delegate showBrowseByCategoryPage:actionURL];
            }
        }
    }
}

#pragma mark - largeOfferCell delgate{
-(void)largeOfferCellTapped:(OfferSubTile *)subTile{
    ActionModel *actionModel = (ActionModel *)[subTile actionModel];
    
    NSString *actionURL = actionModel.url;
    if(actionURL){
        
        if([[actionModel.type lowercaseString] isEqualToString:@"product"]){
            //show pdp
            if(self.delegate && [self.delegate respondsToSelector:@selector(showPDPScreen:)]){
                [self.delegate showPDPScreen:actionURL];
            }
            
        }else if([[actionModel.type lowercaseString] isEqualToString:@"brand"]){
            //show brand page
            if(self.delegate && [self.delegate respondsToSelector:@selector(showBrowseByBrandPage:)]){
                [self.delegate showBrowseByBrandPage:actionURL];
            }
            
        }else if([[actionModel.type lowercaseString] isEqualToString:@"collection"]){
            //show collection page
            if(self.delegate && [self.delegate respondsToSelector:@selector(showBrowseByCollectionPage:)]){
                [self.delegate showBrowseByCollectionPage:actionURL];
            }
        }else if([[actionModel.type lowercaseString] isEqualToString:@"category"] || [[actionModel.type lowercaseString] isEqualToString:@"search"]){
            //show collection page
            if(self.delegate && [self.delegate respondsToSelector:@selector(showBrowseByCategoryPage:)]){
                [self.delegate showBrowseByCategoryPage:actionURL];
            }
        }
    }
}


#pragma mark - scroll view delegete
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if(self.delegate && [self.delegate respondsToSelector:@selector(gridViewDidScroll:)]){
        [self.delegate gridViewDidScroll:scrollView];
    }
    
    if(!isFetching){
        if(scrollView.contentOffset.y + scrollView.frame.size.height >= scrollView.contentSize.height){
            if(self.delegate && [self.delegate respondsToSelector:@selector(didScrollToEndOfLastPage)]){
                isFetching = TRUE;
                [self.delegate didScrollToEndOfLastPage];

            }
        }
    }
}


-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    if(self.delegate && [self.delegate respondsToSelector:@selector(gridViewDidEndDragging:willDecelerate:)]){
        [self.delegate gridViewDidEndDragging:scrollView willDecelerate:decelerate];
    }
}


-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if(isFetching){
        return;
    }
    
    if(self.delegate && [self.delegate respondsToSelector:@selector(gridViewDidEndDecelerating:)]){
        [self.delegate gridViewDidEndDecelerating:scrollView];
    }
}

#pragma mark - HTML Delgates

-(void)showScreen:(NSString *)screenName{
    
//    if ([screenName containsString:@"cart"]) {
    if ([screenName rangeOfString:@"cart"].length>0) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(openCart)]) {
            [self.delegate openCart];
        }
        
//    }else if ([screenName containsString:@"brand"]){
    }else if ([screenName rangeOfString:@"brand"].length>0){
        if (self.delegate && [self.delegate respondsToSelector:@selector(openBrand)]) {
            [self.delegate openBrand];
        }
    }else if ([screenName rangeOfString:@"trackorder"].length>0){
        if (self.delegate && [self.delegate respondsToSelector:@selector(openOrders)]) {
            [self.delegate openOrders];
        }
    }
}

-(void)webViewLoaded:(UIWebView *)webView{
    [[self.parsedDataArray objectAtIndex:webView.tag - 1] setObject:[NSNumber numberWithFloat:webView.scrollView.contentSize.height+10] forKey:@"height"];
//    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:webView.tag - 1 inSection:0];
    [self.collectionView reloadData];
}
@end
