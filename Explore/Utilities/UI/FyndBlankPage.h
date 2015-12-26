//
//  FyndBlankPage.h
//  Explore
//
//  Created by Pranav on 04/09/15.
//  Copyright (c) 2015 Rahul. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^BlankPageAction)();
//typedef void (^AddCartItem)(NSMutableArray *array,BOOL aBool);
@interface FyndBlankPage : UIView

- (id)initWithFrame:(CGRect)frame blankPageType:(ErrorBlankImage)pageType;
@property (nonatomic,copy) BlankPageAction blankPageBlock;
@end
