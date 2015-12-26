//
//  BrandsGrid.m
//  BrandCollectionPOC
//
//  Created by Pranav on 25/06/15.
//  Copyright (c) 2015 Pranav. All rights reserved.
//

#import "BrandsGrid.h"
#import "BrandCollectionHeaderView.h"
#import "ProductCollectionAdapter.h"
#import "BrandProductCell.h"
#import "SSUtility.h"



@interface BrandsGrid()<ProductCollectionAdapterDelegate>
@property (nonatomic,strong) BrandCollectionHeaderView  *gridHeaderView;
@property (nonatomic,strong) UICollectionView           *productCollectionView;
@property (nonatomic,strong) ProductCollectionAdapter   *productAdapter;

@property (nonatomic,strong) UIImageView    *brandRoundBackGround;

@property (nonatomic,strong) UILabel        *brandName;
@property (nonatomic,strong) UILabel        *brandStoreLocation;
@property (nonatomic,strong) UILabel        *brandStores;
@property (nonatomic,strong) UILabel        *brandFollowers;
@property (nonatomic,strong) UIButton       *followBtn;
@property (nonatomic,strong) UIView         *brandInfoUpperStrip;
@property (nonatomic,strong) UIView         *brandInfoLowerStrip;
@property (nonatomic,strong) UIView         *brandInfoCompleteView;
@property (nonatomic,assign) CGFloat        brandBannerHeight;
@property (nonatomic,strong) NSURLSessionDataTask *logoDataTask;
@property (nonatomic,strong) UIImageView           *brandLogo;


- (void)configureBrandHeader;
- (void)configureBrandUpperStrip;
- (void)configureBrandLowerStrip;
- (void)configureBrandGridProducts;
@end

@implementation BrandsGrid

CGSize dynamicSize;
CGFloat brandUpperInfoTripHeight;
#define kVerticalPadding 10.0f
//#define kFollowBtnWidth  70

#define HELVETICA_BOLD   @"Helvetica-Bold"
#define HELVETICA        @"Helvetica"
#define HELVETICA_NEUE_ITALIC      @"HelveticaNeue-Italic"
#define HELVETICA_NEUE      @"HelveticaNeue"
#define HelveticaNeue_Thin @"HelveticaNeue-Thin"

CGFloat logoDynamicWidth = 50.0f;
CGFloat logoDynamicHeight = 50.0f;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
//        [self setBackgroundColor:[UIColor clearColor]];
        dynamicSize = CGSizeZero;
        
        
        containerView = [[UIView alloc] init];
        [self addSubview:containerView];
        
        self.brandInfoCompleteView = [[UIView alloc] init];
        [self.brandInfoCompleteView setBackgroundColor:[UIColor whiteColor]];
        [containerView addSubview:self.brandInfoCompleteView];
        [containerView bringSubviewToFront:self.brandInfoCompleteView];
        
        self.gridHeaderView = [[BrandCollectionHeaderView alloc] initWithFrame:CGRectZero];
//        [self.gridHeaderView setBackgroundColor:[UIColor clearColor]];
        [containerView addSubview:self.gridHeaderView];
        [containerView sendSubviewToBack:self.gridHeaderView];
        
        
        // Upper Strip object allocation
        self.brandLogo = [[UIImageView alloc] initWithFrame:CGRectZero];
//        [self.brandLogo setBackgroundColor:[UIColor clearColor]];
        self.brandLogo.layer.cornerRadius = 3.0f;
        
        self.brandLogo.layer.borderWidth =1.0f;
        self.brandLogo.layer.borderColor = UIColorFromRGB(0xDDDDDD).CGColor;
        self.brandLogo.clipsToBounds = TRUE;
        [self.brandInfoCompleteView addSubview:self.brandLogo];
        
        self.brandInfoUpperStrip = [[UIView alloc] initWithFrame:CGRectZero];
        [self.brandInfoUpperStrip setBackgroundColor:[UIColor whiteColor]];
        self.brandName = [[UILabel alloc] initWithFrame:CGRectZero];
//        [self.brandName setBackgroundColor:[UIColor clearColor]];
        [self.brandName setTextColor:UIColorFromRGB(kDarkPurpleColor)];
        [self.brandName setFont:[UIFont fontWithName:kMontserrat_Regular size:15.0f]];
        
        self.brandBannerHeight = [self getHeightFromAspectRatio:self.currentBrandData.brandBannerAspectRatio andWidth:self.brandBannerWidth];
        
       
        
        self.brandStoreLocation = [[UILabel alloc] initWithFrame:CGRectZero];
//        [self.brandStoreLocation setBackgroundColor:[UIColor clearColor]];
        [self.brandStoreLocation setNumberOfLines:0];
        [self.brandStoreLocation setTextColor:UIColorFromRGB(kDarkPurpleColor)];
        [self.brandStoreLocation setFont:[UIFont fontWithName:kMontserrat_Light size:12.0f]];
        
        
        [self.brandInfoUpperStrip addSubview:self.brandName];
        [self.brandInfoUpperStrip addSubview:self.brandStoreLocation];
        [self.brandInfoCompleteView addSubview:self.brandInfoUpperStrip];
        
        
        //        self.currentBrandData = brandTileData;
        // Grid Products Allocation
//        if(self.currentBrandData.products && [self.currentBrandData.products count]>0)
        {
            layout = [[UICollectionViewFlowLayout alloc] init];
            [layout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
            
            self.productAdapter = [[ProductCollectionAdapter alloc] init];
            self.productAdapter.delegate = self;
            self.productCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
            [self.productCollectionView setShowsHorizontalScrollIndicator:NO];
            self.productCollectionView.scrollsToTop = NO;
            [self.productCollectionView registerClass:[BrandProductCell class] forCellWithReuseIdentifier:@"ProductCell"];
//            self.productCollectionView.pagingEnabled = TRUE;
        
            [self.productCollectionView setBackgroundColor:[UIColor whiteColor]];
            [self.brandInfoCompleteView addSubview:self.productCollectionView];
            
        }
        
        
        // Lower Strip object allocation
        self.brandInfoLowerStrip = [[UIView alloc] initWithFrame:CGRectZero];
        [self.brandInfoLowerStrip setBackgroundColor:[UIColor whiteColor]];
        
        self.brandStores = [[UILabel alloc] initWithFrame:CGRectZero];
//        [self.brandStores setBackgroundColor:[UIColor clearColor]];
        [self.brandStores setFont:[UIFont fontWithName:kMontserrat_Bold size:12.0f]];
        
        self.followBtn = [UIButton buttonWithType:UIButtonTypeCustom];
       
       
        [self.followBtn addTarget:self action:@selector(toggleFollow:forEvent:) forControlEvents:UIControlEventTouchUpInside];
        [self.followBtn.layer setCornerRadius:2.0];
        
        self.brandFollowers = [[UILabel alloc] initWithFrame:CGRectZero];
//        [self.brandFollowers setBackgroundColor:[UIColor clearColor]];
        [self.brandFollowers setFont:[UIFont fontWithName:kMontserrat_Bold size:12.0f]];
        
        [self.brandInfoLowerStrip addSubview:self.brandStores];
        [self.brandInfoLowerStrip addSubview:self.followBtn];
        [self.brandInfoLowerStrip addSubview:self.brandFollowers];
        [self.brandInfoCompleteView addSubview:self.brandInfoLowerStrip];
        
//        requestHandler = [[SSBaseRequestHandler alloc] init];
        
        discountContainerView = [[UIView alloc] init];
        [containerView addSubview:discountContainerView];
        
        discountLabel = [[UILabel alloc] init];
        [discountContainerView addSubview:discountLabel];
        
        discountImageView = [[UIImageView alloc] init];
        [discountContainerView addSubview:discountImageView];
        
    }
    return self;
}


- (void)layoutSubviews{
    
    layout = [[UICollectionViewFlowLayout alloc] init];
    [layout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    self.productCollectionView.collectionViewLayout= layout;

    boldFontForCount = [UIFont fontWithName:kMontserrat_Light size:12.0f];
    regularFontForStore = [UIFont fontWithName:kMontserrat_Light size:12.0f];
//    [self setBackgroundColor:[UIColor clearColor]];
    [containerView setFrame:CGRectMake(RelativeSize(3, 320), RelativeSize(4, 320), self.frame.size.width - RelativeSize(6, 320), self.frame.size.height - RelativeSize(8, 320))];
    
    [containerView setBackgroundColor:[UIColor whiteColor]];
    containerView.layer.cornerRadius = 3.0;
    containerView.layer.shadowColor = UIColorFromRGB(kShadowColor).CGColor;
    [containerView.layer setShadowOpacity:0.1];
    [containerView.layer setShadowOffset:CGSizeMake(0.0, 1.0)];
    
    self.brandBannerHeight = [self getHeightFromAspectRatio:self.currentBrandData.brandBannerAspectRatio andWidth:self.brandBannerWidth];
    
    self.gridHeaderView.isBrandTile = TRUE;
    self.gridHeaderView.bannerImageUrl = self.currentBrandData.banner_url;
    self.gridHeaderView.logoAspectRatio = self.currentBrandData.brandLogoAspectRatio;
    self.gridHeaderView.bannerLogoUrl = self.currentBrandData.brandlogo;
    self.gridHeaderView.productColor = self.currentBrandData.productColor;
    [self.gridHeaderView setFrame:CGRectMake(RelativeSize(3, 320), RelativeSize(3, 320), containerView.frame.size.width - RelativeSize(12, 320), self.brandBannerHeight-RelativeSize(12, 320))];
    [self.gridHeaderView configureHeader];
    
    [self downloadLogo:self.currentBrandData.brandlogo];
    
    
    tempSize1 = [SSUtility getLabelDynamicSize:self.currentBrandData.banner_title withFont:[UIFont fontWithName:kMontserrat_Regular size:15.0f] withSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
    brandUpperInfoTripHeight = RelativeSizeHeight(2, 480) + tempSize1.height + RelativeSizeHeight(2, 480);
    
    modifiedString1 = self.currentBrandData.nearest_store;
    if(modifiedString1 != (id)[NSNull null])
    {
        if(modifiedString1 && modifiedString1.length >0){
            tempSize1 = [SSUtility getLabelDynamicSize:modifiedString1 withFont:[UIFont fontWithName:kMontserrat_Light size:12.0f] withSize:CGSizeMake(250, MAXFLOAT)];
            brandUpperInfoTripHeight += tempSize1.height + RelativeSizeHeight(2, 480);
        }
    }
    [self.brandInfoUpperStrip setFrame:CGRectMake(0,RelativeSize(3, 320)+ (logoDynamicHeight/2 -10), self.gridHeaderView.frame.size.width,brandUpperInfoTripHeight)];
    
    
    dynamicSize = [SSUtility getLabelDynamicSize:self.currentBrandData.banner_title withFont:[UIFont fontWithName:kMontserrat_Regular size:15.0f] withSize:CGSizeMake(MAXFLOAT, RelativeSize(17, 320))];
    [self.brandName setFrame:CGRectMake(self.brandInfoUpperStrip.frame.size.width/2-dynamicSize.width/2, 0, dynamicSize.width, dynamicSize.height)];
//    [self.brandName setBackgroundColor:[UIColor clearColor]];
    [self.brandName setText:self.currentBrandData.banner_title];
    
    nearestStore = self.currentBrandData.nearest_store;
    if(nearestStore != (id)[NSNull null]){
        dynamicSize = [SSUtility getLabelDynamicSize:nearestStore withFont:[UIFont fontWithName:kMontserrat_Light size:12.0f] withSize:CGSizeMake(250, MAXFLOAT)];
        [self.brandStoreLocation setFrame:CGRectMake(self.gridHeaderView.frame.size.width/2 - dynamicSize.width/2, self.brandName.frame.origin.y + self.brandName.frame.size.height+2, dynamicSize.width, dynamicSize.height+3)];
        [self.brandStoreLocation setText:nearestStore];
    }
    
    
    CGFloat lowerInfoY = self.brandInfoUpperStrip.frame.origin.y + self.brandInfoUpperStrip.frame.size.height;
    if([self.currentBrandData.products count] >0){
//        self.productAdapter.delegate = self;
        self.productAdapter.totalProducts = self.currentBrandData.products;
        self.productAdapter.productCellSize = self.brandCollectionViewSize;
        self.productCollectionView.dataSource = self.productAdapter;
        self.productCollectionView.delegate = self.productAdapter;
        
        [self.productCollectionView setFrame:CGRectMake(self.brandInfoUpperStrip.frame.origin.x , self.brandInfoUpperStrip.frame.origin.y + self.brandInfoUpperStrip.frame.size.height+1*kVerticalPadding, self.brandInfoUpperStrip.frame.size.width,self.brandCollectionViewSize.height)];
    }
    
    
    if([self.currentBrandData.products count] >0)
        lowerInfoY += self.productCollectionView.frame.size.height + RelativeSizeHeight(6, 480);
    else
        lowerInfoY += self.productCollectionView.frame.size.height;
    
    [self.brandInfoLowerStrip setFrame:CGRectMake(self.productCollectionView.frame.origin.x, lowerInfoY + RelativeSizeHeight(8, 480), self.gridHeaderView.frame.size.width, RelativeSizeHeight(kFollowBtnHeight, 480)+4)];
    
    [self.followBtn setFrame:CGRectMake(self.brandInfoLowerStrip.frame.size.width/2 - RelativeSize(kFollowBtnWidth, 320)/2, self.brandInfoLowerStrip.frame.size.height/2 - RelativeSizeHeight(kFollowBtnHeight, 480)/2, RelativeSize(kFollowBtnWidth, 320), RelativeSizeHeight(kFollowBtnHeight, 480))];
    
    
    storeString1 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%ld", (long)self.currentBrandData.store_count] attributes:@{NSFontAttributeName : boldFontForCount, NSForegroundColorAttributeName : UIColorFromRGB(kDarkPurpleColor)}];
    if (self.currentBrandData.store_count>1) {
        storesString2 = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@" Stores"] attributes:@{NSFontAttributeName : regularFontForStore, NSForegroundColorAttributeName : UIColorFromRGB(kDarkPurpleColor)}];
    }else{
        storesString2 = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@" Store"] attributes:@{NSFontAttributeName : regularFontForStore, NSForegroundColorAttributeName : UIColorFromRGB(kDarkPurpleColor)}];
        
    }
    [storeString1 appendAttributedString:storesString2];
    
    storeRect = [storeString1 boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingTruncatesLastVisibleLine context:NULL];
    [self.brandStores setFrame:CGRectMake(self.followBtn.frame.origin.x - (RelativeSize(28, 320) + storeRect.size.width),self.followBtn.frame.origin.y + self.followBtn.frame.size.height/2 -storeRect.size.height/2, storeRect.size.width, storeRect.size.height)];
    
    [self.brandStores setAttributedText:storeString1];
    
    if(!self.currentBrandData.is_following){
        followText = [[NSAttributedString alloc] initWithString : @"FOLLOW"
                                                     attributes : @{
                                                                    NSFontAttributeName : [UIFont fontWithName:kMontserrat_Bold size:14.0],
                                                                    NSForegroundColorAttributeName : [UIColor whiteColor]
                                                                    }];
        [self.followBtn setBackgroundColor:UIColorFromRGB(kTurquoiseColor)];
        
    }else {
        followText = [[NSAttributedString alloc] initWithString : @"FOLLOWING"
                                                     attributes : @{
                                                                    NSFontAttributeName : [UIFont fontWithName:kMontserrat_Light size:12.0],
                                                                    NSForegroundColorAttributeName :UIColorFromRGB(kTurquoiseColor)
                                                                    }];
        [self.followBtn setBackgroundColor:[UIColor clearColor]];
        self.followBtn.layer.cornerRadius = 3.0f;
        self.followBtn.layer.borderColor = UIColorFromRGB(kTurquoiseColor).CGColor;
        self.followBtn.layer.borderWidth = 1.0f;
    }
    [self.followBtn setAttributedTitle:followText forState:UIControlStateNormal];
    
    
    followerString1 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%ld", (long)self.currentBrandData.follower_count] attributes:@{NSFontAttributeName : boldFontForCount, NSForegroundColorAttributeName : UIColorFromRGB(kDarkPurpleColor)}];
    followerString2 = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:(self.currentBrandData.follower_count == 1 ? @" Follower" : @" Followers")] attributes:@{NSFontAttributeName : regularFontForStore, NSForegroundColorAttributeName : UIColorFromRGB(kDarkPurpleColor)}];
    [followerString1 appendAttributedString:followerString2];
    
    followerRect = [followerString1 boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingTruncatesLastVisibleLine context:NULL];
    [self.brandFollowers setFrame:CGRectMake(self.followBtn.frame.origin.x + self.followBtn.frame.size.width + RelativeSize(17, 320), self.followBtn.frame.origin.y +self.followBtn.frame.size.height/2 -followerRect.size.height/2, followerRect.size.width, followerRect.size.height)];
    [self.brandFollowers setAttributedText:followerString1];
    
    [self.brandLogo setFrame:CGRectMake(self.gridHeaderView.frame.size.width/2 -logoDynamicWidth/2, self.brandInfoCompleteView.frame.origin.y -(logoDynamicHeight/2+15), kLogoWidth, kLogoWidth)];
    
    [self.brandInfoCompleteView setFrame:CGRectMake(self.gridHeaderView.frame.origin.x+3, self.gridHeaderView.frame.origin.y+self.gridHeaderView.frame.size.height -kExtraPadding+3, self.gridHeaderView.frame.size.width+1, self.brandInfoLowerStrip.frame.origin.y + self.brandInfoLowerStrip.frame.size.height)];
    
    if(self.currentBrandData.discountString && self.currentBrandData.discountString.length > 0){
        discountImage = [UIImage imageNamed:@"DiscountBadgeRed"];
        [discountImageView setFrame:CGRectMake(0, 0, discountImage.size.width, discountImage.size.height)];
        discountImageView.image = discountImage;
        [discountContainerView setFrame:CGRectMake(self.gridHeaderView.frame.origin.x + self.gridHeaderView.frame.size.width - discountImage.size.width - 6, 0, discountImageView.frame.size.width, discountImageView.frame.size.height)];
        
        NSMutableParagraphStyle *style  = [[NSMutableParagraphStyle alloc] init];
        style.minimumLineHeight = 12;
        style.maximumLineHeight = 12;
        style.alignment = NSTextAlignmentCenter;
        //        [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, label.text.length)];
        
        
        
        NSRange percentRange = [self.currentBrandData.discountString rangeOfString:@"%"];
        
        NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:self.currentBrandData.discountString attributes:@{NSFontAttributeName : [UIFont fontWithName:kMontserrat_Regular size:12.0], NSForegroundColorAttributeName :[UIColor whiteColor], NSParagraphStyleAttributeName : style}];
        [string setAttributes:@{NSFontAttributeName : [UIFont fontWithName:kMontserrat_Regular size:11.0], NSForegroundColorAttributeName : [UIColor whiteColor]} range:percentRange];
        
        
        [discountLabel setFrame:CGRectMake(5, 0, discountContainerView.frame.size.width - 10, discountContainerView.frame.size.height - 5)];
        discountLabel.lineBreakMode = NSLineBreakByWordWrapping;
        discountLabel.numberOfLines = 0;
        discountLabel.textAlignment = NSTextAlignmentCenter;
        [discountLabel setAttributedText:string];
        [discountContainerView bringSubviewToFront:discountLabel];
    }
}



- (void)prepareForReuse{
    [layout invalidateLayout];
    layout = nil;
    [containerView setFrame:CGRectZero];
//    [self.gridHeaderView resetObjects];
    self.currentBrandData = nil;
    
    [self.gridHeaderView.headerDataTask cancel];
    self.gridHeaderView.headerDataTask = nil;

    [self.gridHeaderView setFrame:CGRectZero];
//    self.gridHeaderView.bannerImageDownloded = FALSE;
    self.gridHeaderView.bannerImageUrl = nil;
//    self.gridHeaderView.headerImageView.image = nil;
    self.gridHeaderView.headerImageView.image = [UIImage imageNamed:@"ImagePlaceholder"];
    

    [self.productCollectionView setFrame:CGRectZero];
    
    self.productCollectionView.dataSource = nil;
    
    
    [self.logoDataTask cancel];
    self.logoDataTask = nil;
    self.brandLogo.image = nil;
    [self.brandLogo setFrame:CGRectZero];
    
    [self.brandInfoUpperStrip setFrame:CGRectZero];
    [self.brandName setFrame:CGRectZero];
    [self.brandStoreLocation setFrame:CGRectZero];
    [self.brandInfoCompleteView setFrame:CGRectZero];
    
    [self.brandInfoLowerStrip setFrame:CGRectZero];
    [self.followBtn setFrame:CGRectZero];
    [self.brandStores setFrame:CGRectZero];
    [self.brandFollowers setFrame:CGRectZero];
    
    tempSize1 = CGSizeZero;
    modifiedString1 = nil;
    

//    self.productAdapter = nil;
    
//    config1 = nil;
//    cache1 = nil;
    
    
    storeString1 = nil;
    storesString2 = nil;
    storeRect = CGRectZero;
    
    followerString1 = nil;
    followerString2 = nil;
    followerRect = CGRectZero;
    
    boldFontForCount = nil;
    regularFontForStore = nil;
    
    followText = nil;
    nearestStore = nil;
    
    [discountContainerView setFrame:CGRectZero];
    [discountLabel setFrame:CGRectZero];
    [discountImageView setFrame:CGRectZero];
}





#pragma mark ProductCollectionAdapter

- (void)selectedProductTile:(SubProductModel *)subProduct{
    if([self.brandGridDelegate respondsToSelector:@selector(selectedBrandProduct:)]){
        [self.brandGridDelegate selectedBrandProduct:subProduct.action.url];
    }
}





- (void)downloadLogo:(NSString *)imageUrl{
    
    NSString *dataURL =  imageUrl;
    [self.brandLogo sd_setImageWithURL:[NSURL URLWithString:[dataURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
//        [self.contentView setBackgroundColor:[UIColor clearColor]];
        [self.brandLogo setAlpha:0.3];
        [UIView animateWithDuration:0.4 animations:^{
            [self.brandLogo setAlpha:1.0];
        }];
    }];
}



-(CGFloat)getHeightFromAspectRatio:(NSString *)aspectRatio andWidth:(CGFloat)width{
    CGFloat height = 0;
    NSArray *ratioArray = [aspectRatio componentsSeparatedByString:@":"];
    height = (width-20) * [[ratioArray lastObject] floatValue] / [[ratioArray firstObject] floatValue];
    return height;
}


-(void)toggleFollow:(id)sender forEvent:(UIEvent *)theEvent{
    
//    NSString *CurrentSelectedCViewController = NSStringFromClass([[((UINavigationController *)viewController1) visibleViewController] class]);

//    NSString *srcController = [SSUtility traverseToGetControllerName:self];
//    if(self.currentBrandData.theBrandTileType == BrandTileMyBrand){
//        srcController = @"my_brand";
//    }
    
    UIButton *theCell = (UIButton *)sender;
    UITouch *touch = [[theEvent touchesForView:theCell] anyObject];
    self.currentBrandData.is_following = !self.currentBrandData.is_following;
    if (self.currentBrandData.theBrandTileType == BrandTileMyBrand) {
        if (self.theBrandLocationBlock) {
            if (self.currentBrandData.is_following) {
               self.theBrandLocationBlock(touch,TRUE);
            }else{
                self.theBrandLocationBlock(touch,FALSE);
            }
        }
    }
    
    if(followTimer){
        [followTimer invalidate];
        followTimer = nil;
    }
    if ([(FyndUser *)[SSUtility loadUserObjectWithKey:kFyndUserKey] isOnboarded])
        followTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(hitFollow) userInfo:nil repeats:NO];


    if(!self.currentBrandData.is_following){
//        if([(FyndUser *)[SSUtility loadUserObjectWithKey:kFyndUserKey] isOnboarded]){
//            [FyndAnalytics trackBrandFollow:srcController brandName:self.currentBrandData.name isUnFollowed:YES];
//        }
        followText = [[NSAttributedString alloc] initWithString : @"FOLLOW"
                                                     attributes : @{
                                                                    NSFontAttributeName : [UIFont fontWithName:kMontserrat_Bold size:14.0],
                                                                    NSForegroundColorAttributeName : [UIColor whiteColor]
                                                                    }];
        [self.followBtn setBackgroundColor:UIColorFromRGB(kTurquoiseColor)];
        
    }else {
//        if([(FyndUser *)[SSUtility loadUserObjectWithKey:kFyndUserKey] isOnboarded]){
//            [FyndAnalytics trackBrandFollow:srcController brandName:self.currentBrandData.name isUnFollowed:NO];
//        }
        followText = [[NSAttributedString alloc] initWithString : @"FOLLOWING"
                                                     attributes : @{
                                                                    NSFontAttributeName : [UIFont fontWithName:kMontserrat_Light size:12.0],
                                                                    NSForegroundColorAttributeName : /*UIColorFromRGB(kGreenColor)*/UIColorFromRGB(kTurquoiseColor)
                                                                    }];
        [self.followBtn setBackgroundColor:[UIColor clearColor]];
        self.followBtn.layer.cornerRadius = 3.0f;
        self.followBtn.layer.borderColor = UIColorFromRGB(kTurquoiseColor).CGColor;
        self.followBtn.layer.borderWidth = 1.0f;
    }
    [self.followBtn setAttributedTitle:followText forState:UIControlStateNormal];
    if (![(FyndUser *)[SSUtility loadUserObjectWithKey:kFyndUserKey] isOnboarded]){
        if (self.brandGridDelegate && [self.brandGridDelegate respondsToSelector:@selector(brandFollowingData:)]) {
            [self.brandGridDelegate brandFollowingData:self.currentBrandData];
        }
    }
}

-(void)hitFollow{
    
        NSMutableString *urlString = [[NSMutableString alloc] initWithString:kAPI_Inventory];
    
        NSString *dataURL;
        if(!self.currentBrandData.is_following ){
            dataURL = [NSString stringWithFormat:@"%@brand=%@", kBrandUnfollowURL, [SSUtility handleEncoding:self.currentBrandData.brandID]];
        }else{
            dataURL = [NSString stringWithFormat:@"%@brand=%@", kBrandFollowURL, [SSUtility handleEncoding:self.currentBrandData.brandID]];
        }
        
    [urlString appendString:dataURL];
        NSURLSession *session = [NSURLSession sharedSession];
        
        NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    
    NSURLSessionDataTask *likeTask = [session dataTaskWithRequest:req completionHandler:^(NSData *data, NSURLResponse *response, NSError *error){
        if(data.length > 0 && data != nil){
            NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            if([json count] > 0){
                [self setFollowersCount:json];
                
                NSString *string = [[response URL] absoluteString];
                if([(FyndUser *)[SSUtility loadUserObjectWithKey:kFyndUserKey] isOnboarded]){

                    NSString *srcController = [SSUtility traverseToGetControllerName:self];
                    if(self.currentBrandData.theBrandTileType == BrandTileMyBrand){
                        srcController = @"my_brand";
                    }
                    
                    if([string rangeOfString:@"unfollow"].length > 0){
                        [FyndAnalytics trackBrandFollow:srcController brandName:self.currentBrandData.name isUnFollowed:YES];
                    }else{
                        [FyndAnalytics trackBrandFollow:srcController brandName:self.currentBrandData.name isUnFollowed:NO];
                    }
                }
            }else {
            }
        }
    }];
    [likeTask resume];
}

-(void)setFollowersCount:(id)response{
    if ([response objectForKey:@"counts"]) {
        NSArray *countArray = [response valueForKey:@"counts"];
        if ([countArray count]>0) {
            NSDictionary *countDic = [countArray objectAtIndex:0];
            if ([countDic objectForKey:@"count"]) {
                self.currentBrandData.follower_count  = [[countDic objectForKey:@"count"] integerValue];
                followerString1 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%ld", (long)self.currentBrandData.follower_count] attributes:@{NSFontAttributeName : boldFontForCount, NSForegroundColorAttributeName : UIColorFromRGB(kDarkPurpleColor)}];
                followerString2 = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:(self.currentBrandData.follower_count == 1 ? @" Follower" : @" Followers")] attributes:@{NSFontAttributeName : regularFontForStore, NSForegroundColorAttributeName : UIColorFromRGB(kDarkPurpleColor)}];
                [followerString1 appendAttributedString:followerString2];
                
                followerRect = [followerString1 boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingTruncatesLastVisibleLine context:NULL];
                [self.brandFollowers setFrame:CGRectMake(self.followBtn.frame.origin.x + self.followBtn.frame.size.width + 2*kVerticalPadding, self.followBtn.frame.origin.y +self.followBtn.frame.size.height/2 -followerRect.size.height/2, followerRect.size.width, followerRect.size.height)];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.brandFollowers setAttributedText:followerString1];
                });
                
            }
        }
    }
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */


/*
- (void)configureBrandGrid{
    [self clearBrandLayoutData];
    containerView = [[UIView alloc] init];
    [self addSubview:containerView];
    self.brandInfoCompleteView = [[UIView alloc] init];
    [self.brandInfoCompleteView setBackgroundColor:[UIColor whiteColor]];
    [containerView addSubview:self.brandInfoCompleteView];
    
    [containerView bringSubviewToFront:self.brandInfoCompleteView];
    
    [self configureBrandHeader];
    [self configureBrandUpperStrip];
    if(self.currentBrandData.products && [self.currentBrandData.products count]>0){
        [self configureBrandGridProducts];
    }
    [self configureBrandLowerStrip];
}


- (void)clearBrandLayoutData{
    if(containerView){
        [containerView removeFromSuperview];
        containerView = nil;
    }
    if (self.brandInfoCompleteView) {
        [self.brandInfoCompleteView removeFromSuperview];
        self.brandInfoCompleteView = nil;
    }
    
    if(self.brandInfoUpperStrip){
        [self.brandInfoUpperStrip removeFromSuperview];
        self.brandInfoUpperStrip = nil;
    }
    if(self.productCollectionView){
        [self.productCollectionView removeFromSuperview];
        self.productCollectionView = nil;
    }
    if(self.productAdapter){
        self.productAdapter = nil;
    }
    if(self.brandInfoLowerStrip){
        [self.brandInfoLowerStrip removeFromSuperview];
        self.brandInfoLowerStrip = nil;
    }
}


- (void)configureBrandHeader{
    self.gridHeaderView = [[BrandCollectionHeaderView alloc] initWithFrame:CGRectZero];
    self.gridHeaderView.isBrandTile = TRUE;
    self.gridHeaderView.bannerImageUrl = self.currentBrandData.banner_url;
    self.gridHeaderView.logoAspectRatio = self.currentBrandData.brandLogoAspectRatio;
    self.gridHeaderView.bannerLogoUrl = self.currentBrandData.brandlogo;
    [self.gridHeaderView setBackgroundColor:[UIColor clearColor]];
    [containerView addSubview:self.gridHeaderView];
    [containerView sendSubviewToBack:self.gridHeaderView];
}


- (void)configureBrandUpperStrip{
    
    self.brandLogo = [[UIImageView alloc] initWithFrame:CGRectZero];
    [self.brandLogo setBackgroundColor:[UIColor clearColor]];
    self.brandLogo.layer.cornerRadius = 3.0f;
    
    self.brandLogo.layer.borderWidth =1.0f;
    self.brandLogo.layer.borderColor = UIColorFromRGB(0xDDDDDD).CGColor;
    self.brandLogo.clipsToBounds = TRUE;
    [self downloadLogo:self.currentBrandData.brandlogo];
    [self.brandInfoCompleteView addSubview:self.brandLogo];
    
    self.brandInfoUpperStrip = [[UIView alloc] initWithFrame:CGRectZero];
    [self.brandInfoUpperStrip setBackgroundColor:[UIColor whiteColor]];
    self.brandName = [[UILabel alloc] initWithFrame:CGRectZero];
    [self.brandName setBackgroundColor:[UIColor clearColor]];
    [self.brandName setText:self.currentBrandData.banner_title];
    [self.brandName setTextColor:UIColorFromRGB(kDarkPurpleColor)];
    [self.brandName setFont:[UIFont fontWithName:kMontserrat_Regular size:15.0f]];
    
    self.brandBannerHeight = [self getHeightFromAspectRatio:self.currentBrandData.brandBannerAspectRatio andWidth:self.brandBannerWidth];
    
    tempSize1 = [SSUtility getLabelDynamicSize:self.currentBrandData.banner_title withFont:[UIFont fontWithName:kMontserrat_Regular size:15.0f] withSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
    brandUpperInfoTripHeight = RelativeSizeHeight(2, 480) + tempSize1.height + RelativeSizeHeight(2, 480);
    modifiedString1 = [NSString stringWithFormat:@"%@",self.currentBrandData.nearest_store];
    tempSize1 = [SSUtility getLabelDynamicSize:modifiedString1 withFont:[UIFont fontWithName:kMontserrat_Light size:12.0f] withSize:CGSizeMake(250, MAXFLOAT)];
    brandUpperInfoTripHeight += tempSize1.height + RelativeSizeHeight(2, 480);
    
    self.brandStoreLocation = [[UILabel alloc] initWithFrame:CGRectZero];
    [self.brandStoreLocation setBackgroundColor:[UIColor clearColor]];
    [self.brandStoreLocation setNumberOfLines:0];
    [self.brandStoreLocation setTextColor:UIColorFromRGB(kDarkPurpleColor)];
    [self.brandStoreLocation setFont:[UIFont fontWithName:kMontserrat_Light size:12.0f]];
    [self.brandStoreLocation setText:modifiedString1];
    
    [self.brandInfoUpperStrip addSubview:self.brandName];
    [self.brandInfoUpperStrip addSubview:self.brandStoreLocation];
    [self.brandInfoCompleteView addSubview:self.brandInfoUpperStrip];
    
}

- (void)configureBrandLowerStrip{
    self.brandInfoLowerStrip = [[UIView alloc] initWithFrame:CGRectZero];
    [self.brandInfoLowerStrip setBackgroundColor:[UIColor whiteColor]];
    
    self.brandStores = [[UILabel alloc] initWithFrame:CGRectZero];
    [self.brandStores setBackgroundColor:[UIColor clearColor]];
    [self.brandStores setFont:[UIFont fontWithName:kMontserrat_Bold size:12.0f]];
    
    self.followBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    if(!self.currentBrandData.is_following){
        followText = [[NSAttributedString alloc] initWithString : @"FOLLOW"
                                                     attributes : @{
                                                                    NSFontAttributeName : [UIFont fontWithName:kMontserrat_Bold size:14.0],
                                                                    NSForegroundColorAttributeName : [UIColor whiteColor]
                                                                    }];
        [self.followBtn setBackgroundColor:UIColorFromRGB(kTurquoiseColor)];
        
    }else {
        followText = [[NSAttributedString alloc] initWithString : @"FOLLOWING"
                                                     attributes : @{
                                                                    NSFontAttributeName : [UIFont fontWithName:kMontserrat_Light size:12.0],
                                                                    NSForegroundColorAttributeName : UIColorFromRGB(kTurquoiseColor)
                                                                    }];
        [self.followBtn setBackgroundColor:[UIColor clearColor]];
        self.followBtn.layer.cornerRadius = 3.0f;
        self.followBtn.layer.borderColor = UIColorFromRGB(kTurquoiseColor).CGColor;
        self.followBtn.layer.borderWidth = 1.0f;
    }
    [self.followBtn setAttributedTitle:followText forState:UIControlStateNormal];
    [self.followBtn addTarget:self action:@selector(toggleFollow:forEvent:) forControlEvents:UIControlEventTouchUpInside];
    [self.followBtn.layer setCornerRadius:2.0];
    
    self.brandFollowers = [[UILabel alloc] initWithFrame:CGRectZero];
    [self.brandFollowers setBackgroundColor:[UIColor clearColor]];
    [self.brandFollowers setFont:[UIFont fontWithName:kMontserrat_Bold size:12.0f]];
    
    [self.brandInfoLowerStrip addSubview:self.brandStores];
    [self.brandInfoLowerStrip addSubview:self.followBtn];
    [self.brandInfoLowerStrip addSubview:self.brandFollowers];
    [self.brandInfoCompleteView addSubview:self.brandInfoLowerStrip];
}

- (void)configureBrandGridProducts{
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    [layout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    
    self.productAdapter = [[ProductCollectionAdapter alloc] init];
    self.productAdapter.delegate = self;
    self.productCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    [self.productCollectionView setShowsHorizontalScrollIndicator:NO];
    
    [self.productCollectionView registerClass:[BrandProductCell class] forCellWithReuseIdentifier:@"ProductCell"];
    self.productCollectionView.pagingEnabled = TRUE;
    self.productAdapter.productCellSize = self.brandCollectionViewSize;
    self.productAdapter.totalProducts = self.currentBrandData.products;
    self.productCollectionView.dataSource = self.productAdapter;
    self.productCollectionView.delegate = self.productAdapter;
    [self.productCollectionView setBackgroundColor:[UIColor clearColor]];
    [self.brandInfoCompleteView addSubview:self.productCollectionView];
}
*/


@end

