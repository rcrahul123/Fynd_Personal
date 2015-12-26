//
//  PDPStoresCell.m
//  Explore
//
//  Created by Pranav on 15/07/15.
//  Copyright (c) 2015 Rahul. All rights reserved.
//

#import "PDPStoresCell.h"
#import "SSUtility.h"
#import "SSLine.h"

@interface PDPStoresCell ()
@property (nonatomic,strong) UILabel        *storeName;
@property (nonatomic,strong) UILabel        *storeDistance;
@property (nonatomic,strong) UILabel        *storeAddress;
@property (nonatomic,strong) UIView         *viewDirectionView;
@property (nonatomic,strong) UIImageView    *viewDirectionImgae;
@property (nonatomic,strong) UIView         *callStoreView;
@property (nonatomic,strong) UIImageView    *callStoreImgae;
@property (nonatomic,strong) UILabel        *storeOpenStatus;
@property (nonatomic,strong) UILabel        *storeTimings;
@property (nonatomic,strong) UILabel        *storeCount;


//@property (nonatomic,strong) UIView         *directionView;
//@property (nonatomic,strong) UIImageView    *viewDirectionImageView;
@property (nonatomic,strong) UILabel        *direction;
@property (nonatomic,strong) UILabel        *callStore;
@property (nonatomic,strong) UIView         *verticalLine;

@property (nonatomic,strong) UITapGestureRecognizer *viewDirectionTapGesture;
@property (nonatomic,strong) UITapGestureRecognizer *callStoreTapGesture;

@end

@implementation PDPStoresCell

- (void)awakeFromNib {
    // Initialization code
}


- (void)configureCell{
    
    /*
    self.storeCount = [[UILabel alloc] initWithFrame:CGRectZero];
    [self.storeCount setBackgroundColor:[UIColor clearColor]];
    [self.storeCount setTextColor:UIColorFromRGB(kLightGreyColor)];
    [self.storeName setFont:[UIFont fontWithName:kMontserrat_Regular size:14.0f]];
    [self.contentView addSubview:self.storeCount];
     */
    
    self.storeName = [[UILabel alloc] initWithFrame:CGRectZero];
    [self.storeName setBackgroundColor:[UIColor clearColor]];
    [self.storeName setNumberOfLines:0];
    [self.storeName setFont:[UIFont fontWithName:kMontserrat_Regular size:14.0f]];
//    [self.storeName setFont:[UIFont variableFontWithName:kMontserrat_Regular size:12.0f]];
    [self.storeName setTextColor:UIColorFromRGB(kDarkPurpleColor)];
    [self.contentView addSubview:self.storeName];
    
    
    self.storeOpenStatus = [[UILabel alloc] initWithFrame:CGRectZero];
    [self.storeOpenStatus setBackgroundColor:[UIColor clearColor]];
    [self.storeOpenStatus setFont:[UIFont fontWithName:kMontserrat_Regular size:12.0f]];
    [self.contentView addSubview:self.storeOpenStatus];
    
    self.storeTimings = [[UILabel alloc] initWithFrame:CGRectZero];
    [self.storeTimings setFont:[UIFont fontWithName:kMontserrat_Light size:12.0f]];
    [self.storeTimings setTextColor:UIColorFromRGB(kLightGreyColor)];
    [self.storeTimings setBackgroundColor:[UIColor clearColor]];
    [self.contentView addSubview:self.storeTimings];
    
    
    self.viewDirectionView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.contentView addSubview:self.viewDirectionView];
    self.viewDirectionTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(displayDirections:)];
    [self.viewDirectionView addGestureRecognizer:self.viewDirectionTapGesture];
    
    self.viewDirectionImgae = [[UIImageView alloc] initWithFrame:CGRectZero];
    [self.viewDirectionImgae setBackgroundColor:[UIColor clearColor]];
    [self.viewDirectionView addSubview:self.viewDirectionImgae];
    
    self.storeDistance = [[UILabel alloc] initWithFrame:CGRectZero];
    [self.storeDistance setFont:[UIFont fontWithName:kMontserrat_Regular size:10.0f]];
    [self.storeDistance setTextColor:UIColorFromRGB(kDarkPurpleColor)];
    [self.viewDirectionView addSubview:self.storeDistance];

    
    self.direction = [[UILabel alloc] initWithFrame:CGRectZero];
    [self.direction setBackgroundColor:[UIColor clearColor]];
    [self.direction setFont:[UIFont fontWithName:kMontserrat_Regular size:13.0f]];
    [self.direction setTextColor:UIColorFromRGB(kTurquoiseColor)];
    [self.viewDirectionView addSubview:self.direction];
    
    
    self.callStoreView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.contentView addSubview:self.callStoreView];
    self.callStoreTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(applyCall:)];
    [self.callStoreView addGestureRecognizer:self.callStoreTapGesture];
    self.callStoreImgae = [[UIImageView alloc] initWithFrame:CGRectZero];
    [self.callStoreImgae setBackgroundColor:[UIColor clearColor]];
    [self.callStoreView addSubview:self.callStoreImgae];
    
    
    
    self.callStore = [[UILabel alloc] initWithFrame:CGRectZero];
    [self.callStore setBackgroundColor:[UIColor clearColor]];
    [self.callStore setFont:[UIFont fontWithName:kMontserrat_Regular size:13.0f]];
    [self.callStore setTextColor:UIColorFromRGB(kTurquoiseColor)];
    [self.callStoreView addSubview:self.callStore];
    
    self.verticalLine = [[UIView alloc] initWithFrame:CGRectZero];
    [self.verticalLine setBackgroundColor:UIColorFromRGB(0xe4e5e6)];
//    [self.verticalLine setBackgroundColor:UIColorFromRGB(kRedColor)];
    [self.contentView addSubview:self.verticalLine];
}

#define kStoreImageHeight 32
- (void)layoutSubviews{
    CGSize dynamicSize = CGSizeZero;
    
    /*
    CGSize countSize = [SSUtility getLabelDynamicSize:[NSString stringWithFormat:@"%ld. ",(long)self.storeIndex] withFont:[UIFont fontWithName:kMontserrat_Regular size:14.0f] withSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
    [self.storeCount setFrame:CGRectMake(RelativeSize(15, 320), kStorePadding, countSize.width+5,countSize.height)];
    [self.storeCount setText:[NSString stringWithFormat:@"%ld. ",(long)self.storeIndex]];
    
     dynamicSize = [SSUtility getLabelDynamicSize:self.cellStoreData.storeName withFont:[UIFont fontWithName:kMontserrat_Regular size:14.0f] withSize:CGSizeMake(self.frame.size.width - (40), MAXFLOAT)];
    [self.storeName setFrame:CGRectMake(self.storeCount.frame.origin.x + self.storeCount.frame.size.width +kStorePadding/2 , kStorePadding, dynamicSize.width, dynamicSize.height)];
    [self.storeName setText:self.cellStoreData.storeName];
     */
    
    dynamicSize = [SSUtility getLabelDynamicSize:self.cellStoreData.storeName withFont:[UIFont fontWithName:kMontserrat_Regular size:14.0f] withSize:CGSizeMake(self.frame.size.width - (40), MAXFLOAT)];
    [self.storeName setFrame:CGRectMake(RelativeSize(15, 320), kStorePadding, dynamicSize.width,dynamicSize.height)];
    [self.storeName setText:self.cellStoreData.storeName];

    
    
    NSString *storeOpeningStatus = nil;
    if(self.cellStoreData.isStoreOpen){
        storeOpeningStatus = @"OPEN";
        [self.storeOpenStatus setText:storeOpeningStatus];
        [self.storeOpenStatus setTextColor:UIColorFromRGB(kLightGreyColor)];
    }else{
        storeOpeningStatus = @"CLOSED";
        [self.storeOpenStatus setText:storeOpeningStatus];
        [self.storeOpenStatus setTextColor:UIColorFromRGB(kLightGreyColor)];
    }
    CGSize statusSize= [SSUtility getLabelDynamicSize:storeOpeningStatus withFont:[UIFont fontWithName:kMontserrat_Regular size:13.0f] withSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
   
    [self.storeOpenStatus setFrame:CGRectMake(self.storeName.frame.origin.x, self.storeName.frame.origin.y + self.storeName.frame.size.height + kStorePadding-3, statusSize.width, statusSize.height)];
    
    [self.storeTimings setFrame:CGRectMake(self.storeOpenStatus.frame.origin.x + self.storeOpenStatus.frame.size.width + kStorePadding, self.storeOpenStatus.frame.origin.y, self.frame.size.width - (self.storeOpenStatus.frame.origin.x + self.storeOpenStatus.frame.size.width), self.storeOpenStatus.frame.size.height)];
    [self.storeTimings setText:self.cellStoreData.storeTiming];
    
//    [self.viewDirectionView setFrame:CGRectMake(self.storeCount.frame.origin.x, self.storeOpenStatus.frame.origin.y + self.storeOpenStatus.frame.size.height + kStorePadding, self.frame.size.width/2 - 1*kStorePadding,20)];
    [self.viewDirectionView setFrame:CGRectMake(self.storeName.frame.origin.x- kStorePadding/2, self.storeOpenStatus.frame.origin.y + self.storeOpenStatus.frame.size.height + kStorePadding, self.frame.size.width/2 - 1*kStorePadding,20)];
    

    
    [self.viewDirectionView setBackgroundColor:[UIColor clearColor]];
    
    [self.viewDirectionImgae setFrame:CGRectMake(0, self.viewDirectionView.frame.size.height/2 - kStoreImageHeight/2, kStoreImageHeight, kStoreImageHeight)];
    [self.viewDirectionImgae setBackgroundColor:[UIColor clearColor]];
    [self.viewDirectionImgae setImage:[UIImage imageNamed:@"StoreDirection"]];
    
    CGSize directionSize = [SSUtility getLabelDynamicSize:@"Directions" withFont:[UIFont fontWithName:kMontserrat_Regular size:13.0f] withSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
    [self.direction setFrame:CGRectMake(self.viewDirectionImgae.frame.origin.x + self.viewDirectionImgae.frame.size.width, self.viewDirectionView.frame.size.height/2 -15, directionSize.width, 30)];
    [self.direction setText:@"Directions"];
    
    
    [self.verticalLine setFrame:CGRectMake(self.viewDirectionView.frame.origin.x + self.viewDirectionView.frame.size.width + 5, self.viewDirectionView.frame.origin.y, 2, self.viewDirectionView.frame.size.height)];
    
    dynamicSize = [SSUtility getLabelDynamicSize:[NSString stringWithFormat:@"(%@)",self.cellStoreData.storeDistance] withFont:[UIFont fontWithName:kMontserrat_Regular size:12.0f] withSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
    [self.storeDistance setFrame:CGRectMake(self.direction.frame.origin.x + self.direction.frame.size.width+4, self.direction.frame.origin.y+8, dynamicSize.width, dynamicSize.height)];
    [self.storeDistance setText:[NSString stringWithFormat:@"(%@)",self.cellStoreData.storeDistance]];
    
//    [self.callStoreView setFrame:CGRectMake(self.verticalLine.frame.origin.x+ self.verticalLine.frame.size.width + 5, self.viewDirectionView.frame.origin.y, self.viewDirectionView.frame.size.width, self.viewDirectionView.frame.size.height)];
    [self.callStoreView setFrame:CGRectMake(self.verticalLine.frame.origin.x + self.verticalLine.frame.size.width +5, self.viewDirectionView.frame.origin.y, self.frame.size.width - (self.verticalLine.frame.origin.x + self.verticalLine.frame.size.width +kStorePadding), self.viewDirectionView.frame.size.height)];
    [self.callStoreView setBackgroundColor:[UIColor clearColor]];
    
    [self.callStoreImgae setFrame:CGRectMake(kStorePadding/2, self.callStoreView.frame.size.height/2 - kStoreImageHeight/2, kStoreImageHeight, kStoreImageHeight)];
    [self.callStoreImgae setBackgroundColor:[UIColor clearColor]];
    [self.callStoreImgae setImage:[UIImage imageNamed:@"StoreCallStore"]];
    
    [self.callStore setFrame:CGRectMake(self.callStoreImgae.frame.origin.x + self.callStoreImgae.frame.size.width, self.callStoreView.frame.size.height/2 -15, 120, 30)];
    [self.callStore setText:@"Call Store"];
    
    SSLine *horizontalLine = [[SSLine alloc] initWithFrame:CGRectMake(RelativeSize(15, 320), self.frame.size.height - 1, self.frame.size.width-(2*RelativeSize(15, 320)), 1)];
    [self.contentView addSubview:horizontalLine];
}


- (UIView *)generateViewDirectionView{
    
    
    CGSize dynamicSize = [SSUtility getLabelDynamicSize:self.cellStoreData.storeAddress withFont:[UIFont fontWithName:kMontserrat_Light size:12.0f] withSize:CGSizeMake(self.frame.size.width - 20, MAXFLOAT)];
    
    UIView *directionView = [[UIView alloc] initWithFrame:CGRectMake(10, self.storeAddress.frame.origin.y + dynamicSize.height + kStorePadding, self.frame.size.width/2 -20, RelativeSize(40, 480))];
    [directionView setBackgroundColor:[UIColor clearColor]];
    
    UITapGestureRecognizer *directionViewGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(displayDirections:)];
    [directionView addGestureRecognizer:directionViewGesture];
    
    UIImageView *viewDirectionImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 5, 30, 30)];
    [viewDirectionImageView setBackgroundColor:[UIColor clearColor]];
    [viewDirectionImageView setImage:[UIImage imageNamed:@"StoreDirection"]];
    [directionView addSubview:viewDirectionImageView];
    
    UILabel *direction = [[UILabel alloc] initWithFrame:CGRectMake(viewDirectionImageView.frame.origin.x + viewDirectionImageView.frame.size.width +5 , viewDirectionImageView.frame.origin.y, 120, 30)];
    [direction setBackgroundColor:[UIColor clearColor]];
    [direction setText:@"View Directions"];
    [direction setFont:[UIFont fontWithName:kMontserrat_Regular size:13.0f]];
    [direction setTextColor:UIColorFromRGB(kBlueColor)];
    [directionView addSubview:direction];
    
    return directionView;
}


- (UIView *)generateCallStore{
    UIView *callStoreView = [[UIView alloc] initWithFrame:CGRectMake(self.viewDirectionView.frame.origin.x+ self.viewDirectionView.frame.size.width +30, self.viewDirectionView.frame.origin.y, self.viewDirectionView.frame.size.width, self.viewDirectionView.frame.size.height)];
    [callStoreView setBackgroundColor:[UIColor clearColor]];
    
    UITapGestureRecognizer *callStoreGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(applyCall:)];
    [callStoreView addGestureRecognizer:callStoreGesture];
    
    UIImageView *callStoreImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 5, 30, 30)];
    [callStoreImageView setBackgroundColor:[UIColor clearColor]];
    [callStoreImageView setImage:[UIImage imageNamed:@"StoreCallStore"]];
    [callStoreView addSubview:callStoreImageView];
    
    UILabel *callStore = [[UILabel alloc] initWithFrame:CGRectMake(callStoreImageView.frame.origin.x + callStoreImageView.frame.size.width +5 , callStoreImageView.frame.origin.y, 120, 30)];
    [callStore setBackgroundColor:[UIColor clearColor]];
    [callStore setText:@"Call Store"];
    [callStore setFont:[UIFont fontWithName:kMontserrat_Regular size:13.0f]];
    [callStore setTextColor:UIColorFromRGB(kBlueColor)];
    [callStoreView addSubview:callStore];
    return callStoreView;
}

//19.1136111
- (void)displayDirections:(id)sender{
    
    NSString *latitude =  self.cellStoreData.storeLongitude;
    NSString *longitude = self.cellStoreData.storeLatitude;
    NSString *curreentLatitude = [[[NSUserDefaults standardUserDefaults] valueForKey:@"latitude"] stringValue];
    NSString *currentLongitude = [[[NSUserDefaults standardUserDefaults] valueForKey:@"longitude"] stringValue];
    if([[UIApplication sharedApplication] canOpenURL: [NSURL URLWithString:@"comgooglemaps://"]]){
        NSString *directionURL = [NSString stringWithFormat:@"comgooglemaps://?saddr=%@,%@&daddr=%@,%@&directionsmode=driving",curreentLatitude,currentLongitude,latitude,longitude] ;
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:directionURL]];
    }
    else{
        // With Hard Code Values
//        NSString *url = @"maps://maps.apple.com/maps?saddr=43.2694875,5.3946832&daddr=43.2739546,5.3871966";
//        NSString *url = @"maps://maps.apple.com/maps?saddr=19.10415622783025,72.88933249396754&daddr=19.086532,72.890289";
        
//        NSString *url = @"http://maps.apple.com/?saddr=Cupertino&daddr=San+Francisco";
//        NSString *url = @"http://maps.apple.com/?saddr=19.10415622783025,72.88933249396754&daddr=19.086532,72.890289";
//         NSString *url = @"http://maps.apple.com/?saddr=Mumbai&daddr=Pune";
//        NSString *url = @"http://maps.apple.com/?q=19.0979704,72.8847779"; //@"http://maps.apple.com/?ll=19.0979704,72.8847779";
        
        NSString *url = [NSString stringWithFormat:@"http://maps.apple.com/?q=%@,%@",latitude,longitude];

        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
    }
}



- (void)applyCall:(id)sender{
    NSString *str1 = [self.cellStoreData.storeNumber stringByReplacingOccurrencesOfString:@" " withString:@""];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",str1]]];
}

-(void)prepareForReuse{
    [self.viewDirectionView setFrame:CGRectZero];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end




//UIApplication *app = [UIApplication sharedApplication];
//    [app openURL:[NSURL URLWithString:@"maps://maps.google.com/maps?saddr=43.2694875,5.3946832&daddr=43.2739546,5.3871966"]];

//    [app openURL:[NSURL URLWithString:[NSString stringWithFormat:@"maps://maps.google.com/maps?saddr=%@&daddr=%@",self.cellStoreData.storeLatitude,self.cellStoreData.storeLongitude]]];

//"http://maps.google.com/maps?daddr=%f,%f&saddr=%f,%f"
//    [app openURL:[NSURL URLWithString:[NSString stringWithFormat:@"maps://maps.google.com/maps?saddr=19.1136111,72.8713889&daddr=19.173808,72.8605943"]]];

//    [app openURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://maps.google.com/maps?daddr=19.1136111,72.8713889&saddr=19.173808,72.8605943"]]];


//    NSString *latlong = @"-56.568545,1.256281";
//    NSString *latlong = [NSString stringWithFormat:@"%@,%@",self.cellStoreData.storeLatitude,self.cellStoreData.storeLongitude];


