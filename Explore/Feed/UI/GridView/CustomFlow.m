
//  CustomFlow.m
//  FreshSample
//
//  Created by Rahul on 6/17/15.
//  Copyright (c) 2015 Rahul. All rights reserved.
//

#import "CustomFlow.h"

@implementation CustomFlow
CGRect prevAttrFrame;
UICollectionViewLayoutAttributes *prev2Attr;


-(id)init{
    self = [super init];
    if(self){
       
        collectionViewContentHeight = self.collectionView.frame.size.height;
        prevAttrFrame = CGRectZero;
        deviceWidht = [[UIScreen mainScreen] bounds].size.width;
        deviceHeight = [[UIScreen mainScreen] bounds].size.height;
    }
    return  self;
}

-(void)prepareLayout{
    collectionViewContentHeight = 0;
    attributesArray = [[NSMutableArray alloc] initWithCapacity:0];
    
    prevAttrFrame = CGRectZero;
    prev2Attr = nil;
    for(int i = 0; i < [self.collectionView numberOfItemsInSection:0]; i++){
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
        UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
        CGFloat width = [[[self.dataArray objectAtIndex:attributes.indexPath.row] objectForKey:@"width"] floatValue];
        CGFloat height = [[[self.dataArray objectAtIndex:attributes.indexPath.row] objectForKey:@"height"] floatValue];
        
        CGFloat originX = 0;
        CGFloat originY = 0;
        
        if(attributes.indexPath.row > 0){
            
            if(floorf(prevAttrFrame.origin.x + prevAttrFrame.size.width) == floorf(self.collectionView.frame.size.width)){
                
                if(floorf([[[self.dataArray objectAtIndex:attributes.indexPath.row - 1] objectForKey:@"width"] floatValue]) == floorf(self.collectionView.frame.size.width)){
                    originY = prevAttrFrame.origin.y + prevAttrFrame.size.height;
                }else{
                    for(UICollectionViewLayoutAttributes *iteratingAttr in attributesArray){
                        if(iteratingAttr.indexPath.row == attributes.indexPath.row - 2){
                            prev2Attr = iteratingAttr;
                            break;
                        }
                    }
                    originX = 0;
                    originY = prev2Attr.frame.origin.y + prev2Attr.frame.size.height;
                }
            }else{
                
                for(UICollectionViewLayoutAttributes *iteratingAttr in attributesArray){
                    if(iteratingAttr.indexPath.row == attributes.indexPath.row - 2){
                        prev2Attr = iteratingAttr;
                        break;
                    }
                }
                originX = prevAttrFrame.origin.x + prevAttrFrame.size.width;
                originY = prev2Attr.frame.origin.y + prev2Attr.frame.size.height;
            }
            if([[[[self.dataArray objectAtIndex:indexPath.row] objectForKey:@"tile_size"] stringValue] isEqualToString:@"2"]){
                originX = 0;
                originY = MAX(prev2Attr.frame.origin.y + prev2Attr.frame.size.height, prevAttrFrame.origin.y + prevAttrFrame.size.height);
            }
        }else{
            originY = 0;
            originX = 0;
        }

        prevAttrFrame = CGRectMake(originX, originY, width, height);
        [attributes setFrame:prevAttrFrame];
        if([[[[self.dataArray objectAtIndex:indexPath.row] objectForKey:@"tile_type"] lowercaseString] isEqualToString:@"card"] || [[[[self.dataArray objectAtIndex:indexPath.row] objectForKey:@"tile_type"] lowercaseString] isEqualToString:@"carousal"]){
    
            if([[[[self.dataArray objectAtIndex:indexPath.row] objectForKey:@"tile_type"] lowercaseString] isEqualToString:@"card"]){
                [attributes setFrame:CGRectMake(-RelativeSize(4, 320), prevAttrFrame.origin.y + RelativeSize(4, 320), prevAttrFrame.size.width + RelativeSize(8, 320), prevAttrFrame.size.height)];
                prevAttrFrame = CGRectMake(originX, originY + RelativeSize(4, 320), width, height);
                
            }else{
                [attributes setFrame:CGRectMake(-RelativeSize(4, 320), prevAttrFrame.origin.y + RelativeSize(0, 320), prevAttrFrame.size.width + RelativeSize(8, 320), prevAttrFrame.size.height)];
                prevAttrFrame = CGRectMake(originX, originY + RelativeSize(0, 320), width, height);
            }

        }
        
        [attributesArray addObject:attributes];
        
        if(collectionViewContentHeight < prevAttrFrame.origin.y + prevAttrFrame.size.height){
            collectionViewContentHeight = prevAttrFrame.origin.y + prevAttrFrame.size.height;
        }
        if(attributes.indexPath.row == [self.collectionView numberOfItemsInSection:0] - 1){
            [self.collectionView setContentSize:CGSizeMake(self.collectionView.contentSize.width, collectionViewContentHeight)];
        }
    }
    if(self.collectionView.numberOfSections > 1){
        for(int i = 0; i < [self.collectionView numberOfItemsInSection:1]; i++){
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:1];
            UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
            CGFloat width = self.collectionView.frame.size.width;
            CGFloat height = 80;

            CGFloat originY = prevAttrFrame.origin.y + prevAttrFrame.size.height;
            CGFloat originX = 0;
            
            if(!self.isLoaderHidden){
                collectionViewContentHeight += height;
                
            }
            [attributes setFrame:CGRectMake(originX, originY, width, height)];
            [attributesArray addObject:attributes];
        }
    }
}

-(CGSize)collectionViewContentSize{

    return CGSizeMake(self.collectionView.frame.size.width, collectionViewContentHeight);
}


-(NSArray *)layoutAttributesForElementsInRect:(CGRect)rect{
    NSPredicate *filterPredicate = [NSPredicate predicateWithBlock:^BOOL(UICollectionViewLayoutAttributes * evaluatedObject, NSDictionary *bindings) {
        BOOL predicateRetVal = CGRectIntersectsRect(rect, [evaluatedObject frame]);
        return predicateRetVal;
    }];
    
    NSArray *retVal = [attributesArray filteredArrayUsingPredicate:filterPredicate];

    return retVal;
}

-(UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewLayoutAttributes *retVal = [attributesArray objectAtIndex:indexPath.row];
    return retVal;
}

@end
