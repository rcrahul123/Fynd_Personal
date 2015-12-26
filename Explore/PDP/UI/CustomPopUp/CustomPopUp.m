//
//  CustomPopUp.m
//  Explore
//
//  Created by Pranav on 14/07/15.
//  Copyright (c) 2015 Rahul. All rights reserved.
//

#import "CustomPopUp.h"
@interface CustomPopUp(){
    PopHeaderView *topHeaderView;
}
@property (nonatomic,strong) UIImageView *sizeGuideImage;
@end

@implementation CustomPopUp
CGPoint location;

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
     
        [self setBackgroundColor:[UIColor blueColor]];
        UISwipeGestureRecognizer *swipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeView:)];
        [swipe setDirection:UISwipeGestureRecognizerDirectionDown];
//        [self addGestureRecognizer:swipe];
        
//        UIPanGestureRecognizer *pangesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
        
        [self showHeader];
    }
    return self;
}

CGPoint startLoc;
CGPoint moveLoc;
CGPoint stopLoc;


-(void)handlePan:(id)sender{
    
    UIPanGestureRecognizer  *recognizer = (id)sender;
    if(recognizer.state == UIGestureRecognizerStateBegan){
        startLoc = [recognizer locationInView:self];
        
        if(startLoc.y < self.frame.origin.y){
            return;
        }
        
    }
    else if(recognizer.state == UIGestureRecognizerStateChanged){
        moveLoc = [recognizer locationInView:self];
        [self setFrame:CGRectMake(self.frame.origin.x, moveLoc.y, self.frame.size.width, self.frame.size.height)];
    }
    
    
}

- (void)handleSwipeView:(id)sender{
    
    UISwipeGestureRecognizer *recognizer = (UISwipeGestureRecognizer *)sender;
    
    if (recognizer.direction == UISwipeGestureRecognizerDirectionDown) {
        location.y += 220.0;
    }
    
    [UIView animateWithDuration:0.5 animations:^{
        self.alpha = 0.0;
//        self.center = location;
        self.center = CGPointMake(180 , location.y);
    }];
    
}


-(void)showHeader{
    topHeaderView = [[PopHeaderView alloc] init];
    [self addSubview:[topHeaderView popHeaderViewWithTitle:@"SIZE GUIDE" andImageName:@"size" withOrigin:CGPointMake(RelativeSize(-11, 320), self.frame.origin.y-(RelativeSizeHeight(80, 568)))]];
}

- (void)fetchGuideImage{
   // @"http://128.199.181.146:8888/unsafe/600x0/http://128.199.181.146/media/images/inventory/brand/lee_banner.jpg";
    NSString *str = @"http://128.199.181.146:8888/unsafe/600x0/http://128.199.181.146/media/images/inventory/brand/lee_banner.jpg";//[self.sizeGuideDict objectForKey:@"Url"];
    
    self.sizeGuideImage = [[UIImageView alloc] initWithFrame:self.frame];
    [self.sizeGuideImage setBackgroundColor:[UIColor clearColor]];
//    ImageDownloader *imageDownloader = [[ImageDownloader alloc] init];
    __block UIImage *downloadImage = nil;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        
        NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:str]];
        
        dispatch_sync(dispatch_get_main_queue(), ^{
            downloadImage =[UIImage imageWithData:imageData];
            [self.sizeGuideImage setImage:downloadImage];
        });
    });
    
    [self addSubview:self.sizeGuideImage];
}

@end
