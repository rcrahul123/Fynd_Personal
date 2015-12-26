//
//  SSUtility.m
//  BrandCollectionPOC
//
//  Created by Pranav on 25/06/15.
//  Copyright (c) 2015 Pranav. All rights reserved.
//

#import "SSUtility.h"
#import "PopOverlayHandler.h"
#import <sys/utsname.h>

static PopOverlayHandler   *activityOverlay;
static UIView               *errorView;
@implementation SSUtility


+ (CGSize)getLabelDynamicSize:(NSString *)title withFont:(UIFont *)font withSize:(CGSize)size{
    CGSize expectedSize = size;
//    CGSize aSize = [title sizeWithFont:font constrainedToSize:expectedSize lineBreakMode:NSLineBreakByWordWrapping];
    CGRect rect = [title boundingRectWithSize:expectedSize options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading) attributes:@{NSFontAttributeName : font} context:NULL];
    return rect.size;
//    return aSize;
}

+ (CGSize)getSingleLineLabelDynamicSize:(NSString *)title withFont:(UIFont *)font withSize:(CGSize)size{
    CGSize expectedSize = size;
    //    CGSize aSize = [title sizeWithFont:font constrainedToSize:expectedSize lineBreakMode:NSLineBreakByWordWrapping];
    CGRect rect = [title boundingRectWithSize:expectedSize options:NSStringDrawingTruncatesLastVisibleLine attributes:@{NSFontAttributeName : font} context:NULL];
    return rect.size;
    //    return aSize;
}

+ (UILabel *)generateLabel:(NSString *)unitValue withRect:(CGRect)unitRect withFont:(UIFont *)font{
    UILabel *unitLabel = [[UILabel alloc] initWithFrame:unitRect];
    [unitLabel setBackgroundColor:[UIColor clearColor]];
    [unitLabel setTextColor:[UIColor lightGrayColor]];
    [unitLabel setTextAlignment:NSTextAlignmentCenter];
    [unitLabel setText:unitValue];
    [unitLabel setFont:font];
    return unitLabel;
}


+ (UIColor *)colorFromHexString:(NSString *)hexString {
    unsigned rgbValue = 0;
    NSScanner *scanner = [NSScanner scannerWithString:hexString];
    [scanner setScanLocation:1]; // bypass '#' character
    [scanner scanHexInt:&rgbValue];
    return [UIColor colorWithRed:((rgbValue & 0xFF0000) >> 16)/255.0 green:((rgbValue & 0xFF00) >> 8)/255.0 blue:(rgbValue & 0xFF)/255.0 alpha:1.0];
}


+(NSMutableArray *)parseJSON:(NSArray *)json forGridView:(GridView *)gridView{
    NSMutableArray *parsedDataArray = [[NSMutableArray alloc] init];
    
    for(int i = 0; i < [json count]; i ++){
        
        CGFloat width = 0;
        CGFloat height = 0;
        
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
        
        if([[json objectAtIndex:i] objectForKey:@"tile_size"])
            [dict setObject:[[json objectAtIndex:i] objectForKey:@"tile_size"] forKey:@"tile_size"];
        
        if([[[[json objectAtIndex:i] objectForKey:@"tile_size"] stringValue] isEqualToString:@"1"] || [[[[json objectAtIndex:i] objectForKey:@"tile_size"] stringValue] isEqualToString:@"0"]){
            
            //            width = self.view.frame.size.width/2;
            width = gridView.collectionView.frame.size.width/2;
            [dict setObject:[NSNumber numberWithFloat:width] forKey:@"width"];
            
        }else if([[[[json objectAtIndex:i] objectForKey:@"tile_size"] stringValue] isEqualToString:@"2"]){
            
            //            width = self.view.frame.size.width;
            width = gridView.collectionView.frame.size.width;
            [dict setObject:[NSNumber numberWithFloat:width] forKey:@"width"];
            
        }else if([[[json objectAtIndex:i] objectForKey:@"tile_type"] isEqualToString:@"card"] || [[[json objectAtIndex:i] objectForKey:@"tile_type"] isEqualToString:@"carousal"]){
            width = gridView.collectionView.frame.size.width;
            [dict setObject:[NSNumber numberWithFloat:width] forKey:@"width"];
        }
        
        [dict setObject:[[json objectAtIndex:i] valueForKey:@"tile_type"] forKey:@"tile_type"];
        
        //        height = [self getHeightFromAspectRatio:[[json objectAtIndex:i] objectForKey:@"aspect_ratio"] andWidth:width];
        
        if([[[json objectAtIndex:i] objectForKey:@"tile_type"] isEqualToString:@"html"]){
            
            HTMLTileModel *htmlModel = [[HTMLTileModel alloc] init];
            htmlModel.htmlString = [[[json objectAtIndex:i] objectForKey:@"value"] objectForKey:[[[[json objectAtIndex:i] objectForKey:@"value"] allKeys] objectAtIndex:0]];
            htmlModel.toBeRemoved = [[[json objectAtIndex:i] objectForKey:@"to_be_removed"] boolValue];
            
            height = [self getProductsAspectRatio:@"23:24" andWidth:width];
            [dict setObject:htmlModel forKey:@"values"];

        }else if([[[json objectAtIndex:i] objectForKey:@"tile_type"] isEqualToString:@"product"]){
            //            height += RelativeSize(42, 320);
            
            ProductTileModel *prod = [[ProductTileModel alloc] initWithDictionary:[[json objectAtIndex:i] objectForKey:@"value"]];
            if([[[[json objectAtIndex:i] objectForKey:@"tile_size"] stringValue] isEqualToString:@"2"]){
                prod.shouldShowMarkedPrice = YES;
                
            }
            if([[json objectAtIndex:i] objectForKey:@"badge"]){
                prod.badgeString = [[json objectAtIndex:i] objectForKey:@"badge"];
            }
            prod.productID = [SSUtility getValueForParam:kProductID from:prod.action.url];
            height = [self getHeightFromAspectRatio:prod.aspect_ratio andWidth:width];
//            height += RelativeSize(52, 320);
            height += 70;

            if(gridView.theGridViewType == GridViewTypeCartFromWishlist || gridView.theGridViewType == GridViewTypeWishList){
                height += 55;
                prod.tileType = ProductTileAddToCartFromWishlist;
            }
            [dict setObject:prod forKey:@"values"];

        }
        else if ([[[json objectAtIndex:i] objectForKey:@"tile_type"] isEqualToString:@"tip"]){
            
            TipTileModel *tip = [[TipTileModel alloc] initWithDictionary:[[json objectAtIndex:i] objectForKey:@"value"]];
            //            height = [self getHeightFromAspectRatio:tip.aspect_ratio andWidth:width];
            [dict setObject:tip forKey:@"values"];
            height = [self getProductsAspectRatio:tip.aspect_ratio andWidth:width];
        }
        else if ([[[json objectAtIndex:i] objectForKey:@"tile_type"] isEqualToString:@"brand"]){
            
            BrandTileModel *brand = [[BrandTileModel alloc] initWithDictionary:[[json objectAtIndex:i] objectForKey:@"value"]];
            brand.brandID = [SSUtility getValueForParam:kBrandID from:brand.action.url];
            height = [self calculateBrandCellHeight:brand forGridView :gridView];
            [dict setObject:brand forKey:@"values"];
            
        }else if ([[[json objectAtIndex:i] objectForKey:@"tile_type"] isEqualToString:@"collection"]){
            
            CollectionTileModel *collection = [[CollectionTileModel alloc] initWithDictionary:[[json objectAtIndex:i] objectForKey:@"value"]];
            collection.collectionID = [SSUtility getValueForParam:kCollectionID from:collection.action.url];
            height = [self calculateCollectionGridHeight:collection forGridView:gridView];
            [dict setObject:collection forKey:@"values"];
        }else if ([[[json objectAtIndex:i] objectForKey:@"tile_type"] isEqualToString:@"welcome"]){
            HTMLTileModel *htmlModel = [[HTMLTileModel alloc] init];
        [dict setObject:[[json objectAtIndex:i] objectForKey:@"isOrderCard"] forKey:@"isOrderCard"];            
            height = 100;
            [dict setObject:htmlModel forKey:@"values"];
        }else if ([[[json objectAtIndex:i] objectForKey:@"tile_type"] isEqualToString:@"card"]){
            
            OffersTileModel *tileModel = [[OffersTileModel alloc] initWithDictionary:[[json objectAtIndex:i] objectForKey:@"value"]];
            [dict setObject:tileModel forKey:@"values"];
//            height = [self getHeightFromAspectRatio:tileModel.aspectRatio andWidth:width*0.8];
            height = [self getHeightFromAspectRatio:@"2:1" andWidth:width*0.8] + RelativeSize(20.5, 320);

        }else if ([[[json objectAtIndex:i] objectForKey:@"tile_type"] isEqualToString:@"carousal"]){
            
            OffersTileModel *tileModel = [[OffersTileModel alloc] initWithDictionary:[[json objectAtIndex:i] objectForKey:@"value"]];
            [dict setObject:tileModel forKey:@"values"];
            //            height = [self getHeightFromAspectRatio:tileModel.aspectRatio andWidth:width*0.8];
            height = [self getHeightFromAspectRatio:@"2:1" andWidth:width] + RelativeSize(18, 320);
            
        }
        [dict setObject:[NSNumber numberWithFloat:height] forKey:@"height"];
        [parsedDataArray addObject:dict];
    }
    return parsedDataArray;
}

CGSize dynamicGridSize ;
CGFloat followButtonHeight = 34.0f;
+ (CGFloat)calculateBrandCellHeight:(BrandTileModel *)brandData forGridView:(GridView *)grid{
    CGFloat dynamicHeight = 0.0f;
   
    CGFloat bannerDynamicHeight = [self getHeightFromAspectRatio:brandData.brandBannerAspectRatio andWidth:grid.frame.size.width];
//    bannerDynamicHeight = bannerDynamicHeight/2;
    dynamicHeight += bannerDynamicHeight + kGridComponentPadding;
    
    CGFloat testHeight = 0.0f;
    
    dynamicGridSize = [SSUtility getLabelDynamicSize:brandData.banner_title withFont:[UIFont fontWithName:kMontserrat_Regular size:15.0f] withSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
    testHeight += RelativeSizeHeight(2, 480) + dynamicGridSize.height + RelativeSizeHeight(2, 480);
    

    NSString *modifiedString = brandData.nearest_store;
    if(modifiedString !=(id)[NSNull null]){
        if(modifiedString && modifiedString.length >0){
            dynamicGridSize = [SSUtility getLabelDynamicSize:modifiedString withFont:[UIFont fontWithName:kMontserrat_Light size:12.0f] withSize:CGSizeMake(250, MAXFLOAT)];
            testHeight +=  dynamicGridSize.height;
//            dynamicHeight += testHeight + kGridComponentPadding;
        }
    }
    dynamicHeight += testHeight + kGridComponentPadding;

  
    CGFloat calculatedWidth = ((grid.collectionView.frame.size.width - 2*kGridComponentPadding) - 2*kGridComponentPadding)/3.5;
    if(brandData.products && [brandData.products count]>0) // If any brnad is having some producs then only need to calculate height
    {
        SubProductModel *subProduct = [brandData.products objectAtIndex:0];
        CGFloat productContainerHeight = [self getProductsAspectRatio:subProduct.subProductAspectRatio andWidth:calculatedWidth];
        dynamicHeight += productContainerHeight;
        dynamicHeight += RelativeSizeHeight(8, 480); //SMG
    }
//    CGFloat lowerStripHeight = RelativeSizeHeight(4, 480) + RelativeSizeHeight(34, 480) + RelativeSizeHeight(4, 480)+4;//SMG
    CGFloat lowerStripHeight = RelativeSizeHeight(34, 480) + RelativeSizeHeight(8, 480)+4;
    dynamicHeight += lowerStripHeight-kExtraPadding + (kLogoWidth/2-15);
    return dynamicHeight;
}

+ (CGFloat)calculateCollectionGridHeight:(CollectionTileModel *)collectionData forGridView:(GridView *)grid{
    CGFloat dynamicHeight = 0.0f;
    CGFloat bannerDynamicHeight = [self getHeightFromAspectRatio:collectionData.bannerAspectRatio andWidth:grid.frame.size.width];
//    bannerDynamicHeight = bannerDynamicHeight/2;
    dynamicHeight += bannerDynamicHeight + kGridComponentPadding;
    
    CGFloat testHeight = 0.0f;
    
    dynamicGridSize = [SSUtility getLabelDynamicSize:collectionData.banner_title withFont:[UIFont fontWithName:kMontserrat_Regular size:15.0f] withSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
    testHeight += RelativeSizeHeight(2, 480) + dynamicGridSize.height + RelativeSizeHeight(2, 480);
    NSString *modifiedString = [NSString stringWithFormat:@"Updated %@",collectionData.last_updated];
    dynamicGridSize = [SSUtility getLabelDynamicSize:modifiedString withFont:[UIFont fontWithName:kMontserrat_Light size:12.0f] withSize:CGSizeMake(250, MAXFLOAT)];
    testHeight +=  dynamicGridSize.height;
    dynamicHeight += testHeight + kGridComponentPadding;
    
    CGFloat calculatedWidth = ((grid.collectionView.frame.size.width - 2*kGridComponentPadding) - 2*kGridComponentPadding)/3.5;

    if(collectionData.products  && [collectionData.products count]>0){
        SubProductModel *subProduct = [collectionData.products objectAtIndex:0];
        CGFloat productContainerHeight = [self getProductsAspectRatio:subProduct.subProductAspectRatio andWidth:calculatedWidth];
        dynamicHeight += productContainerHeight;
        dynamicHeight += RelativeSizeHeight(8, 480);
    }
//    CGFloat lowerStripHeight = RelativeSizeHeight(8, 480) + RelativeSizeHeight(34, 480) + RelativeSizeHeight(8, 480)+4;//SMG
    CGFloat lowerStripHeight = RelativeSizeHeight(34, 480) + RelativeSizeHeight(8, 480)+4;
    dynamicHeight += lowerStripHeight-kExtraPadding + (kLogoWidth/2-15);
    return dynamicHeight;
}


+(CGFloat)getHeightFromAspectRatio:(NSString *)aspectRatio andWidth:(CGFloat)width{
    CGFloat height = 0;
    NSArray *ratioArray = [aspectRatio componentsSeparatedByString:@":"];
    height = (width - RelativeSize(20, 320)) * [[ratioArray lastObject] floatValue] / [[ratioArray firstObject] floatValue];
    return height;
}

+ (CGFloat)getProductsAspectRatio:(NSString *)aspectRatio andWidth:(CGFloat)width{
    CGFloat height = 0;
    NSArray *ratioArray = [aspectRatio componentsSeparatedByString:@":"];
    height = (width) * [[ratioArray lastObject] floatValue] / [[ratioArray firstObject] floatValue];
    return height;
}

+(NSString *)getValueForParam:(NSString *)param from:(NSString *)urlString{
    NSString *value;
    NSString *paramString = [[urlString componentsSeparatedByString:@"?"] lastObject];
    NSArray *paramArray = [paramString componentsSeparatedByString:@"&"];
    
    NSMutableDictionary *paramDict = [[NSMutableDictionary alloc] initWithCapacity:0];
    for(int i = 0; i < [paramArray count]; i++){
        NSString *param = [paramArray objectAtIndex:i];
        NSString *key = [[param componentsSeparatedByString:@"="] firstObject];
        NSString *value = [[param componentsSeparatedByString:@"="] lastObject];
        [paramDict setObject:value forKey:key];
    }
    value = [paramDict objectForKey:param];
    
    return value;
}

+(UIImage *)imageWithColor:(UIColor *)color
{
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

+(void)saveCustomObject:(FyndUser *)object
{
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSData *myEncodedObject = [NSKeyedArchiver archivedDataWithRootObject:object];
    [prefs setObject:myEncodedObject forKey:kFyndUserKey];
    [prefs synchronize];
}

+(FyndUser*)loadUserObjectWithKey:(NSString*)key
{
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSData *myEncodedObject = [prefs objectForKey:key ];
    FyndUser *userData = (FyndUser *)[NSKeyedUnarchiver unarchiveObjectWithData: myEncodedObject];
    return userData;
}

+ (void)showActivityOverlay:(UIView *)view{
    
    if(activityOverlay){
        [activityOverlay dismissOverlay];
        activityOverlay = nil;

    }
    activityOverlay = [[PopOverlayHandler alloc] init];
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setObject:[NSNumber numberWithInt:ActivityIndicatorOverlay] forKey:@"PopUpType"];
    [activityOverlay presentOverlay:RateUsOverlay rootView:view enableAutodismissal:TRUE withUserInfo:parameters];
}

+(void)deleteUserDataForKey:(NSString *)key{
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    [prefs removeObjectForKey:key];
    [prefs synchronize];
}


+ (void)dismissActivityOverlay{
    [activityOverlay dismissOverlay];
    activityOverlay = nil;
}

+(NSString *)handleEncoding:(NSString *)urlString{
    NSString *encodedStr = (__bridge NSString *)CFURLCreateStringByAddingPercentEscapes(NULL, (CFStringRef)urlString, NULL,(CFStringRef)@"!*'();:@&=+$,/?%#[]" , kCFStringEncodingUTF8);
    return encodedStr;
}

+(CGSize)getDynamicSizeWithSpacing:(NSString *)title withFont:(UIFont *)font withSize:(CGSize)size spacing:(NSInteger)spaceValue{
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = spaceValue;
    NSDictionary *tempDict = @{NSFontAttributeName:font
                               ,NSParagraphStyleAttributeName:paragraphStyle
                               };
    CGSize sizeOfText = [title boundingRectWithSize:size
                                            options: (NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading)
                                         attributes: tempDict
                                            context: nil].size;
    
    return sizeOfText;
}


+(CGFloat)getMinimumButtonHeight:(float)originalSize relatedToHeight:(float)screenHeight{
    CGFloat height;
    
    height = RelativeSizeHeight(originalSize, screenHeight);
    if(height < 44){
        height = 44;
    }
    return height;
}




+(NSString *)getDeviceName
{
    struct utsname systemInfo;
    uname(&systemInfo);
    
    NSString *iOSDeviceModelsPath = [[NSBundle mainBundle] pathForResource:@"DeviceModel" ofType:@"plist"];
    NSDictionary *iOSDevices = [NSDictionary dictionaryWithContentsOfFile:iOSDeviceModelsPath];
    
    NSString* deviceModel = [NSString stringWithCString:systemInfo.machine
                                               encoding:NSUTF8StringEncoding];
    
    NSString *deviceName = [iOSDevices valueForKey:deviceModel];
    return deviceName;
}

+(BOOL)checkIfUserInAllowedCities:(NSString *)city{
    
    BOOL allowUser = false;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSArray *cityArray = [defaults objectForKey:@"availableCities"];
    
    for(int i = 0; i < [cityArray count]; i++){
        if([[city lowercaseString] isEqualToString:[[cityArray objectAtIndex:i] lowercaseString]]){
            allowUser = true;
            break;
        }
    }
    return allowUser;
}


+(NSString *)getUserAgentString
{
//    Fynd/iOS Platform-Version/8.0.1 App-Version/1.0.1
    NSMutableString *ua = [[NSMutableString alloc]init];
    [ua appendString:@"Fynd/iOS"];
    [ua appendString:@" Platform-Version/"];
    [ua appendFormat:@"%@",[[UIDevice currentDevice] systemVersion]];
    [ua appendString:@" App-Version/"];
    [ua appendString:[[NSBundle mainBundle]objectForInfoDictionaryKey:@"CFBundleShortVersionString"]];
    return [ua copy];
}

+(NSString *)traverseToGetControllerName:(UIView *)view{
    
    BOOL found = false;
    Class vcc = [UIViewController class];
    
    // Traverse responder chain. Return first found view controller, which will be the view's view controller.
    UIResponder *responder = view;
    while ((responder = [responder nextResponder])){
        if ([responder isKindOfClass: vcc]){
            found = true;
//            return (UIViewController *)responder;
            break;
        }else{
            found = false;
        }
    }
    
    // If the view controller isn't found, return nil.
//    return nil;
    if(found){
        NSString *className = NSStringFromClass([(UIViewController *)responder class]);
        if([className isEqualToString:@"FeedViewController"]){
            return @"feed";
            
        }else if ([className isEqualToString:@"BrandsVIewController"]){
            return @"brand";
            
        }else if ([className isEqualToString:@"BrowseByBrandViewController"]){
            return @"brand_browse";
            
        }else if([className isEqualToString:@"CollectionsViewController"]){
            return @"collection";
            
        }else if([className isEqualToString:@"BrowseByCollectionViewController"]){
            return @"collection_browse";
            
        }else if ([className isEqualToString:@"PDPViewController"]){
            return @"more_products";
            
        }else if ([className isEqualToString:@"ProfileViewController"] || [className isEqualToString:@"AddFromWishlistViewController"]){
            return @"wishlist";
            
        }else if ([className isEqualToString:@"PDPViewController"]){
            return @"more_products";
            
        }else if([className isEqualToString:@""]){
            return nil;
        }
    }
    return nil;
}


+(NSString *)getUserID{
    NSString *userID = nil;
    
    FyndUser *user = [SSUtility loadUserObjectWithKey:kFyndUserKey];
    if(user){
        userID = (NSString *)user.userId;
    }
    return userID;
}

+(void)showOverlayViewWithMessage:(NSString *)theMessage andColor:(UIColor *)theOverlayColor{
    
    UIWindow *theWindow = [[[UIApplication sharedApplication] windows] objectAtIndex:0];
      __block  UIView *overlayView = [[UIView alloc] initWithFrame:CGRectMake(0, -50, theWindow.frame.size.width, 50)];
        [overlayView setBackgroundColor:theOverlayColor];
    
        CGSize size = [SSUtility getLabelDynamicSize:theMessage withFont:[UIFont fontWithName:kMontserrat_Regular size:14.0f] withSize:CGSizeMake(overlayView.frame.size.width, MAXFLOAT)];

        UILabel *info = [SSUtility generateLabel:theMessage withRect:CGRectMake(overlayView.frame.size.width/2 - size.width/2, overlayView.frame.size.height/2 - size.height/2, size.width, size.height) withFont:[UIFont fontWithName:kMontserrat_Regular size:14.0f]];
        [info setTextColor:[UIColor whiteColor]];
        [overlayView addSubview:info];
        [theWindow addSubview:overlayView];
    
        [UIView animateWithDuration:0.5 animations:^{
            [overlayView setFrame:CGRectMake(overlayView.frame.origin.x, 0,overlayView.frame.size.width, overlayView.frame.size.height)];

        } completion:^(BOOL finished) {
            [UIView animateWithDuration:3.0f animations:^{
                overlayView.alpha = 0.0f;
            }
                             completion:^(BOOL finished) {
                                 if(overlayView){
                                     [overlayView removeFromSuperview];
                                     overlayView = nil;
                                 }
            }];

        }];
}
+(UIColor *)colorFromHexString:(NSString *)hexString withAlpha:(CGFloat)alpha{
    unsigned rgbValue = 0;
    NSScanner *scanner = [NSScanner scannerWithString:hexString];
    [scanner setScanLocation:1]; // bypass '#' character
    [scanner scanHexInt:&rgbValue];
    return [UIColor colorWithRed:((rgbValue & 0xFF0000) >> 16)/255.0 green:((rgbValue & 0xFF00) >> 8)/255.0 blue:(rgbValue & 0xFF)/255.0 alpha:alpha];
}


+(void)removeBranchStoredData{
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if([[userDefaults objectForKey:@"isLaunchedViaBranch"] boolValue]){
        [userDefaults removeObjectForKey:@"isLaunchedViaBranch"];
        [userDefaults removeObjectForKey:@"BranchDeepLinkUrl"];
        [userDefaults removeObjectForKey:@"BranchParameters"];
        [userDefaults setObject:[NSNumber numberWithBool:FALSE] forKey:@"loggedOutUserClickBranchLink"];
        [userDefaults setObject:[NSNumber numberWithBool:FALSE] forKey:@"BranchDeepLinkEventFired"];
    }
}
@end
