//
//  FyndActivityIndicator.h
//  Explore
//
//  Created by Rahul Chaudhari on 03/10/15.
//  Copyright © 2015 Rahul. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum FyndLoaderType{
    FyndLoaderTypeSmall,
    FyndLoaderTypeLarge
}FyndLoaderType;


@interface FyndActivityIndicator : UIView{
    CGRect indicatorFrame;
    UIImageView *loaderView;
    NSString *imageName;
    UIImage *loaderImage;
    FyndLoaderType indicatorType;
    
//    UIView *overlayView;

}


@property (nonatomic, assign) FyndLoaderType indicatorType;

//-(id)initWithLoaderType:(FyndLoaderType)type;
-(id)initWithFrame:(CGRect)frame;
-(id)initWithSize:(CGSize)size;
-(void)startAnimating;
-(void)stopAnimating;

@end
