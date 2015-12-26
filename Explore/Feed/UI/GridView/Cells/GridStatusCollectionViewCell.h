//
//  GridStatusCollectionViewCell.h
//  Explore
//
//  Created by Rahul Chaudhari on 10/09/15.
//  Copyright (c) 2015 Rahul. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SCGIFImageView.h"

@interface GridStatusCollectionViewCell : UICollectionViewCell{
    UIView *containerView;
    NSAttributedString *messageString;
    UILabel *messageLabel;
    UIImageView *loadeMore;
    
    NSString *filePath;
    SCGIFImageView *gifContainer;
    NSData* imageData;
}

@property (nonatomic, strong) NSString *message;
@property (nonatomic, assign) BOOL shouldShowLoader;

@end
