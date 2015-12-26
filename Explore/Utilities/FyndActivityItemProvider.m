//
//  FyndActivityItemProvider.m
//  Explore
//
//  Created by Rahul Chaudhari on 18/10/15.
//  Copyright © 2015 Rahul. All rights reserved.
//

#import "FyndActivityItemProvider.h"

@implementation FyndActivityItemProvider

//-(id)init{
//    self = [super init];
//    
//    return self;
//}

//- (id)activityViewController:(UIActivityViewController *)activityViewController itemForActivityType:(NSString *)activityType
//{
//    if ( [activityType isEqualToString:UIActivityTypePostToTwitter] )
//        return [[NSString alloc] initWithFormat:@"%@ from %@ on @GoFynd", self.productDetails, self.brandName];
//    if ( [activityType isEqualToString:UIActivityTypePostToFacebook] )
//        return [[NSString alloc] initWithFormat:@"%@ from %@ on @GoFynd", self.productDetails, self.brandName];
//    if ( [activityType isEqualToString:UIActivityTypeMessage] )
//        return [[NSString alloc] initWithFormat:@"%@ from %@ on @GoFynd", self.productDetails, self.brandName];
//    if ( [activityType isEqualToString:UIActivityTypeMail] )
//        return [[NSString alloc] initWithFormat:@"Hey, checkout this %@ from %@ on Fynd.", self.productDetails, self.brandName];
//    if ( [activityType isEqualToString:@"it.albertopasca.myApp"] )
//        return @"OpenMyapp custom text";
//    if([activityType isEqualToString:@"net.whatsapp.WhatsApp.ShareExtension"]){
//        return [[NSString alloc] initWithFormat:@"Hey, checkout this %@ from %@ on Fynd.", self.productDetails, self.brandName];   
//    }
//    
//    return [[NSString alloc] initWithFormat:@"Hey, checkout this %@ from %@ on Fynd.", self.productDetails, self.brandName];
//
//    
////    return nil;
//}


- (id)activityViewController:(UIActivityViewController *)activityViewController itemForActivityType:(NSString *)activityType
{
    NSMutableArray *array = [[NSMutableArray alloc] init];
    
    if ( [activityType isEqualToString:UIActivityTypePostToTwitter] ){
        
        [array addObject:[[NSString alloc] initWithFormat:@"%@ from %@ on @GoFynd", self.productDetails, self.brandName]];
        [array addObject:self.productImage];
        return array;
    }
    
    
//        return [[NSString alloc] initWithFormat:@"%@ from %@ on @GoFynd", self.productDetails, self.brandName];
    if ( [activityType isEqualToString:UIActivityTypePostToFacebook] )
        return [[NSString alloc] initWithFormat:@"%@ from %@ on @GoFynd", self.productDetails, self.brandName];
    if ( [activityType isEqualToString:UIActivityTypeMessage] )
        return [[NSString alloc] initWithFormat:@"%@ from %@ on Fynd", self.productDetails, self.brandName];
    if ( [activityType isEqualToString:UIActivityTypeMail] )
        return [[NSString alloc] initWithFormat:@"Hey, checkout this %@ from %@ on Fynd.", self.productDetails, self.brandName];
    if ( [activityType isEqualToString:@"it.albertopasca.myApp"] )
        return [[NSString alloc] initWithFormat:@"Hey, checkout this %@ from %@ on Fynd.", self.productDetails, self.brandName];
    if([activityType isEqualToString:@"net.whatsapp.WhatsApp.ShareExtension"]){
        return [[NSString alloc] initWithFormat:@"Hey, checkout this %@ from %@ on Fynd.", self.productDetails, self.brandName];
    }

    return [[NSString alloc] initWithFormat:@"Hey, checkout this %@ from %@ on Fynd.", self.productDetails, self.brandName];
    
    
    //    return nil;
}





/*
-(id)activityViewController:(UIActivityViewController *)activityViewController itemForActivityType:(NSString *)activityType
{
    // the number of item to share
    static UIActivityViewController *shareController;
    static int itemNo;
    if (shareController == activityViewController && itemNo < numberOfSharedItems - 1)
        itemNo++;
    else {
        itemNo = 0;
        shareController = activityViewController;
    }
    
    NSURL *shareURL = self.shareURL;
    
    // twitter
    if ([activityType isEqualToString: UIActivityTypePostToTwitter])
        switch (itemNo) {
            case 0: return nil;
            case 1: return [[NSString alloc] initWithFormat:@"%@ from %@ on @GoFynd", self.productDetails, self.brandName]; // you can change text for twitter, I add $ to stock symbol inside shareText here, e.g. Hashtags can be added too
            case 2: return shareURL;
            case 3: return nil; // no picture
            case 4: return @"via @YourApp";
            default: return nil;
        }
    
    // email
    else if ([activityType isEqualToString: UIActivityTypeMail])
        switch (itemNo) {
            case 0: return @"Hi!\r\n\r\nI used YourApp\r\n";
            case 1: return [[NSString alloc] initWithFormat:@"Hey, checkout this %@ from %@ on Fynd.", self.productDetails, self.brandName];
            case 2: return shareURL;
            case 3: return nil; // no picture
//            case 4: return [@"\r\nCheck it out.\r\n\r\nCheers\r\n" stringByAppendingString: [self userName]];
            default: return nil;
        }
    
//    else // Facebook or something else in the future
//        switch (itemNo) {
//            case 0: return nil;
//            case 1: return shareText;
//            case 2: return shareURL;
//            case 3: return [self shareImage];
//            case 4: return nil;
//            default: return nil;
//        }
}


*/



- (id) activityViewControllerPlaceholderItem:(UIActivityViewController *)activityViewController {
    return @"";
}



@end
