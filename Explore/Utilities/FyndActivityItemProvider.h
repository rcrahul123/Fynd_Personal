//
//  FyndActivityItemProvider.h
//  Explore
//
//  Created by Rahul Chaudhari on 18/10/15.
//  Copyright © 2015 Rahul. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FyndActivityItemProvider : UIActivityItemProvider

@property (nonatomic, strong) NSString *productDetails;
@property (nonatomic, strong) NSString *brandName;
@property (nonatomic, strong) UIImage *productImage;
@property (nonatomic, strong) NSURL *shareURL;

@end
