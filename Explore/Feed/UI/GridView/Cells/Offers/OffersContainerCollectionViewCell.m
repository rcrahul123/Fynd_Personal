//
//  OffersContainerCollectionViewCell.m
//  Explore
//
//  Created by Rahul Chaudhari on 15/12/15.
//  Copyright © 2015 Rahul. All rights reserved.
//

#import "OffersContainerCollectionViewCell.h"


@implementation FlowLayout


- (id)init
{
    self = [super init];
    if (self) {
    }
    
    return self;
}

-(id)initWithSize:(CGSize)size{
    self = [super init];
    if (self) {

        self.totalHeight = size.height;
        self.totalWidth = size.width;
    }
    return self;
}



- (void)setup
{
    CGFloat width = self.totalWidth;
    CGFloat height = self.totalHeight;
    
    self.itemSize = CGSizeMake(width * 0.8, height);
    self.minimumLineSpacing = 0.0f;
    self.minimumInteritemSpacing = RelativeSize(2, 320);
//    self.collectionView.bounces = false;
}

-(void)prepareLayout
{
    [super prepareLayout];
}

-(CGSize)collectionViewContentSize{
    NSInteger number = [self.collectionView numberOfItemsInSection:0];
    return CGSizeMake(number * self.itemSize.width + RelativeSize(6, 320), self.itemSize.height/2);
}



@end

@implementation OffersContainerCollectionViewCell

-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        flow = [[FlowLayout alloc] initWithSize:frame.size];
    }
    return self;
}


-(void)prepareForReuse{
    self.offersModel = nil;
    [flow invalidateLayout];
    [offersCollectionView removeFromSuperview];
    offersCollectionView = nil;
}

-(void)layoutSubviews{
    [flow setup];
    [flow setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    offersCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(RelativeSize(4, 320), RelativeSize(0, 320), self.frame.size.width - RelativeSize(8, 320), self.frame.size.height - RelativeSize(0, 320)) collectionViewLayout:flow];
    offersCollectionView.showsHorizontalScrollIndicator = false;
    offersCollectionView.showsVerticalScrollIndicator = false;
    [offersCollectionView setBackgroundColor:UIColorFromRGB(kBackgroundGreyColor)];
    [offersCollectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"OfferCell"];

    [self addSubview:offersCollectionView];
    offersCollectionView.delegate = self;
    offersCollectionView.dataSource = self;
    
    [flow.collectionView setContentSize:CGSizeMake(self.frame.size.width * 0.8 * [self.offersModel.subModuleArray count] + RelativeSize(4, 320), flow.collectionView.frame.size.height)];
}


#pragma mark - collectionView delegates and datasources

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.offersModel.subModuleArray count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"OfferCell" forIndexPath:indexPath];
    [cell setBackgroundColor:[UIColor clearColor]];
    
    OffersView *view = [[OffersView alloc] initWithFrame:CGRectMake(RelativeSize(4, 320), 0, cell.frame.size.width - RelativeSize(5, 320), cell.frame.size.height)];

    view.subTileModel = [self.offersModel.subModuleArray objectAtIndex:indexPath.row];
    [cell addSubview:view];
    cell.clipsToBounds = NO;
    
    return cell;
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(self.frame.size.width * 0.8, self.frame.size.height - RelativeSize(4, 320));
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    OfferSubTile *tile = (OfferSubTile *)[self.offersModel.subModuleArray objectAtIndex:indexPath.row];
    if(self.offerDelegate && [self.offerDelegate respondsToSelector:@selector(offerTapped:)]){
        [self.offerDelegate offerTapped:tile];
    }
}


-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return RelativeSize(4, 320);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 0.0;
}


@end
