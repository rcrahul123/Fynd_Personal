//
//  GridStatusCollectionViewCell.m
//  Explore
//
//  Created by Rahul Chaudhari on 10/09/15.
//  Copyright (c) 2015 Rahul. All rights reserved.
//

#import "GridStatusCollectionViewCell.h"

@implementation GridStatusCollectionViewCell

-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        
        containerView = [[UIView alloc] init];
        [self addSubview:containerView];
        
        messageLabel = [[UILabel alloc] init];
        [self addSubview:messageLabel];
        
        loadeMore = [[UIImageView alloc] init];
        [loadeMore setBackgroundColor:[UIColor clearColor]];
//        NSString *imageName = @"Loader_000";
//        NSMutableArray *animationImagesArray = [[NSMutableArray alloc] init];
//        for(int i = 0; i <= 50; i++){
//            [animationImagesArray addObject:[UIImage imageNamed:[NSString stringWithFormat:@"%@%d.png",imageName, i]]];
//        }
//        loadeMore.animationImages = animationImagesArray;
//        
//        loadeMore.animationDuration = 1.5;
//        
//        [self addSubview:loadeMore];
        
        
        filePath = [[NSBundle mainBundle] pathForResource:@"loader.gif" ofType:nil];
        imageData = [NSData dataWithContentsOfFile:filePath];
        gifContainer = [[SCGIFImageView alloc] initWithFrame:CGRectMake(0, 0,40, 40)];
        gifContainer.animationDuration = 0.030;
        
        [gifContainer setData:imageData];
        [containerView addSubview:gifContainer];
    }
    return self;
}


-(void)prepareForReuse{
    [containerView setFrame:CGRectZero];
    [messageLabel setFrame:CGRectZero];
    messageString = nil;
    
    imageData = nil;
    [gifContainer setData:nil];
}




-(void)layoutSubviews{
    
    [containerView setFrame:CGRectMake(RelativeSize(3, 320), RelativeSize(3, 320), self.frame.size.width -  RelativeSize(6, 320), self.frame.size.height -  RelativeSize(6, 320))];
    [containerView setBackgroundColor:[UIColor clearColor]];
    [containerView.layer setCornerRadius:3.0];
    [containerView setClipsToBounds:YES];
    
    //    if(self.message){
    //        messageString = [[NSAttributedString alloc] initWithString:self.message attributes:@{NSForegroundColorAttributeName : [UIColor blackColor], NSFontAttributeName : [UIFont fontWithName:kMontserrat_Regular size:12.0]}];
    //        CGRect rect = [messageString boundingRectWithSize:CGSizeMake(self.frame.size.width - 15, self.frame.size.height - 10) options:NSStringDrawingTruncatesLastVisibleLine context:NULL];
    //
    //        [messageLabel setFrame:CGRectMake(5, 5, rect.size.width, rect.size.height)];
    //        messageLabel.numberOfLines = 0;
    //        messageLabel.lineBreakMode = NSLineBreakByWordWrapping;
    //        [messageLabel setAttributedText:messageString];
    //        [messageLabel setTextAlignment:NSTextAlignmentCenter];
    //    }
    //    [loadeMore setFrame:CGRectMake(self.frame.size.width/2 - 20, self.frame.size.height/2 - 20, 40, 40)];
    //    [loadeMore startAnimating];
    
    
    imageData = [NSData dataWithContentsOfFile:filePath];
    [gifContainer setData:imageData];
    [gifContainer setCenter:CGPointMake(containerView.frame.size.width/2, containerView.frame.size.height/2)];
    
}


@end
