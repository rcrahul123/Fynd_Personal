//
//  BrandCollectionViewCell.m
//  FreshSample
//
//  Created by Rahul on 6/17/15.
//  Copyright (c) 2015 Rahul. All rights reserved.
//

#import "BrandCollectionViewCell.h"

@implementation BrandCollectionViewCell


-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        
        containerView = [[UIView alloc] init];
        [self addSubview:containerView];
        
        headerView = [[UIView alloc] init];
        [containerView addSubview:headerView];
        
        subFlow = [[UICollectionViewFlowLayout alloc] init];
        
        horizontalCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:subFlow];
//        horizontalCollectionView = [[UICollectionView alloc] init];
        horizontalCollectionView.delegate = self;
        horizontalCollectionView.dataSource = self;
//        [horizontalCollectionView setCollectionViewLayout:subFlow];
        [horizontalCollectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"SmallProductCell"];
        [containerView addSubview:horizontalCollectionView];
    }
    return self;
}


-(void)prepareForReuse{
    [containerView setFrame:CGRectZero];
    [headerView setFrame:CGRectZero];
    [horizontalCollectionView setFrame:CGRectZero];
}


-(void)layoutSubviews{
    [containerView setFrame:CGRectMake(5, 5, self.frame.size.width - 10, self.frame.size.height - 10)];
    [containerView setBackgroundColor:[UIColor whiteColor]];
    
    [headerView setFrame:CGRectMake(5, 15, containerView.frame.size.width - 10, 150)];
    [headerView setBackgroundColor:[UIColor lightGrayColor]];

    [subFlow setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    [subFlow setItemSize:CGSizeMake(150, 250)];

    [horizontalCollectionView setBackgroundColor:[UIColor clearColor]];
    [horizontalCollectionView setFrame:CGRectMake(5, headerView.frame.origin.y + headerView.frame.size.height + 5, containerView.frame.size.width - 10, containerView.frame.size.height - (headerView.frame.origin.y + headerView.frame.size.height + 10))];
}


-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 10;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"SmallProductCell" forIndexPath:indexPath];
    
    
    [cell.contentView setBackgroundColor:[UIColor lightGrayColor]];
    return cell;
}
@end
