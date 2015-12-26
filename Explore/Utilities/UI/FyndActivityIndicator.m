//
//  FyndActivityIndicator.m
//  Explore
//
//  Created by Rahul Chaudhari on 03/10/15.
//  Copyright © 2015 Rahul. All rights reserved.
//

#import "FyndActivityIndicator.h"
#import "SCGIFImageView.h"

@implementation FyndActivityIndicator

@synthesize indicatorType;

//-(id)initWithLoaderType:(FyndLoaderType)type{
//
//    if(type == FyndLoaderTypeSmall){
//        imageName = @"Loader";
//    }else if (type == FyndLoaderTypeLarge){
//        imageName = @"Loader";
//    }
//    indicatorType = type;
//    loaderImage = [UIImage imageNamed:[NSString stringWithFormat:@"%@1.png", imageName]];
//    indicatorFrame = CGRectMake(0, 0,loaderImage.size.width,loaderImage.size.height);
//
//    self = [super initWithFrame:indicatorFrame];
//
//    [self setupImageView];
//
//    return self;
//}


-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    
    if(self){
        //        [self setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.2]];
        
        [self setBackgroundColor:[UIColor clearColor]];
    }
    imageName = @"Loader_000";
    
    loaderImage = [UIImage imageNamed:[NSString stringWithFormat:@"%@0.png", imageName]];
    indicatorFrame = CGRectMake(0, 0, loaderImage.size.width, loaderImage.size.height);
    
    
    //    overlayView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    //                [overlay setBackgroundColor:UIColorFromRGB(0x444444)];
    //    [overlayView setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.4]];
    //                overlay.alpha = 0.9;
    //    [self addSubview:overlayView];
    
    
    [self setupImageView];
    
    return self;
}

-(id)initWithSize:(CGSize)size{
    self = [super initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    
    if(self){
        //        [self setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.2]];
        
        [self setBackgroundColor:[UIColor clearColor]];
    }
    imageName = @"Loader_000";
    
    loaderImage = [UIImage imageNamed:[NSString stringWithFormat:@"%@0.png", imageName]];
    indicatorFrame = CGRectMake(0, 0, loaderImage.size.width, loaderImage.size.height);
    
    
    //    overlayView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    //                [overlay setBackgroundColor:UIColorFromRGB(0x444444)];
    //    [overlayView setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.4]];
    //                overlay.alpha = 0.9;
    //    [self addSubview:overlayView];
    
    
    [self setupImageViewWithSize:size];
    
    return self;
}


//-(void)setIndicatorType:(FyndLoaderType)type{
//
//
//    if(type == FyndLoaderTypeSmall){
//        imageName = @"Loader";
//    }else if (type == FyndLoaderTypeLarge){
//        imageName = @"Loader";
//    }
//    loaderImage = [UIImage imageNamed:[NSString stringWithFormat:@"%@1.png", imageName]];
//    indicatorFrame = CGRectMake(0, 0,loaderImage.size.width,loaderImage.size.height);
//
//    [self setupImageView];
//
//    indicatorType = type;
//}


-(void)setupImageView{
    
    //    if(CGRectIsEmpty(indicatorFrame)){
    //        loaderView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 39, 39)];
    //    }else{
    //        loaderView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, indicatorFrame.size.width, indicatorFrame.size.height)];
    //    }
    //
    //    NSMutableArray *animationImagesArray = [[NSMutableArray alloc] init];
    //    for(int i = 0; i <= 50; i++){
    //        [animationImagesArray addObject:[UIImage imageNamed:[NSString stringWithFormat:@"%@%d.png", imageName, i]]];
    //    }
    //    loaderView.animationImages = animationImagesArray;
    //
    //    loaderView.animationDuration = 1.5;
    //
    //    [loaderView setCenter:CGPointMake(self.frame.size.width/2, self.frame.size.height/2)];
    //    [self addSubview:loaderView];
    
    
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"loader.gif" ofType:nil];
    
    NSData* imageData = [NSData dataWithContentsOfFile:filePath];
    
    SCGIFImageView *gifContainer = [[SCGIFImageView alloc] initWithFrame:CGRectMake(0, 0,52, 52)];
    gifContainer.animationDuration = 0.030;
    
    [gifContainer setCenter:CGPointMake(self.frame.size.width/2, self.frame.size.height/2)];
    [gifContainer setData:imageData];
    [self addSubview:gifContainer];
    
}


-(void)setupImageViewWithSize:(CGSize)size{
    
    //    if(CGRectIsEmpty(indicatorFrame)){
    //        loaderView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 39, 39)];
    //    }else{
    //        loaderView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, indicatorFrame.size.width, indicatorFrame.size.height)];
    //    }
    //
    //    NSMutableArray *animationImagesArray = [[NSMutableArray alloc] init];
    //    for(int i = 0; i <= 50; i++){
    //        [animationImagesArray addObject:[UIImage imageNamed:[NSString stringWithFormat:@"%@%d.png", imageName, i]]];
    //    }
    //    loaderView.animationImages = animationImagesArray;
    //
    //    loaderView.animationDuration = 1.5;
    //
    //    [loaderView setCenter:CGPointMake(self.frame.size.width/2, self.frame.size.height/2)];
    //    [self addSubview:loaderView];
    
    
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"loader.gif" ofType:nil];
    
    NSData* imageData = [NSData dataWithContentsOfFile:filePath];
    
    SCGIFImageView *gifContainer = [[SCGIFImageView alloc] initWithFrame:CGRectMake(0, 0,size.width, size.height)];
    gifContainer.animationDuration = 0.030;
    
    [gifContainer setCenter:CGPointMake(self.frame.size.width/2, self.frame.size.height/2)];
    [gifContainer setData:imageData];
    [self addSubview:gifContainer];
    
}


-(void)startAnimating{
    [loaderView startAnimating];
}


-(void)stopAnimating{
    [loaderView stopAnimating];
}


/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end
