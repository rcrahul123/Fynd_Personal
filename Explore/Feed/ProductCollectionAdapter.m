//
//  ProductCollectionAdapter.m
//  BrandCollectionPOC
//
//  Created by Pranav on 23/06/15.
//  Copyright (c) 2015 Pranav. All rights reserved.
//

#import "ProductCollectionAdapter.h"
#import "BrandProductCell.h"
#import "BrandTileModel.h"

@implementation ProductCollectionAdapter


#pragma mark -
#pragma mark - collection view delegate methods

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    //    return 6;
    return [self.totalProducts count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"ProductCell";
    
    UICollectionViewCell *cell = nil;

    BrandProductCell *productCell = (BrandProductCell *)[collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
        
    SubProductModel *subProductModel = [self.totalProducts objectAtIndex:indexPath.row];
    productCell.productImageViewSize = self.productCellSize;
    productCell.urlString = subProductModel.product_image;
    [productCell setBackgroundColor:[UIColor clearColor]];
    productCell.productColor = subProductModel.productColor;
    productCell.showDiscountBadge = subProductModel.shouldShowBadge;
    cell = (UICollectionViewCell *)productCell;
    return cell;
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(self.productCellSize.width,self.productCellSize.height);
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    SubProductModel *selectedProduct = [self.totalProducts objectAtIndex:indexPath.row];
    if([self.delegate respondsToSelector:@selector(selectedProductTile:)]){
        [self.delegate selectedProductTile:selectedProduct];
    }
    
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 5.0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 5.0;
}
@end
