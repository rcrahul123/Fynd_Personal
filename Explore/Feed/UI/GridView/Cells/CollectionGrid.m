//
//  CollectionGrid.m
//  Explore
//
//  Created by Pranav on 30/06/15.
//  Copyright (c) 2015 Rahul. All rights reserved.
//

#import "CollectionGrid.h"
#import "BrandCollectionHeaderView.h"
#import "ProductCollectionAdapter.h"
#import "BrandProductCell.h"
#import "SSUtility.h"

@interface CollectionGrid ()<ProductCollectionAdapterDelegate>
@property (nonatomic,strong) BrandCollectionHeaderView  *gridHeaderView;
@property (nonatomic,strong) UICollectionView           *productCollectionView;
@property (nonatomic,strong) ProductCollectionAdapter   *productAdapter;

@property (nonatomic,strong) UILabel        *brandName;
@property (nonatomic,strong) UILabel        *brandStoreLocation;
@property (nonatomic,strong) UILabel        *brandStores;
@property (nonatomic,strong) UILabel        *brandFollowers;
@property (nonatomic,strong) UIButton       *followBtn;
@property (nonatomic,strong) UIView         *brandInfoUpperStrip;
@property (nonatomic,strong) UIView         *brandInfoLowerStrip;
@property (nonatomic,assign) CGFloat         bannerHeight;
@property (nonatomic,strong) UIView         *collectionInfoCompleteView;

//@property (nonatomic,strong) NSURLSessionDataTask *logoDataTask;
@property (nonatomic,strong) UIImageView           *collectionLogo;

//- (void)configureCollectionHeader;
//- (void)configureCollectionUpperStrip;
//- (void)configureCollectionLowerStrip;
//- (void)configureCollectionGridProducts;


@end

@implementation CollectionGrid

CGSize size;
CGFloat upperInfoTripHeight;
#define kVerticalPadding 10.0f
#define kFollowBtnWidth  84
#define kFollowBtnHeight 34

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        
        collectionGridContainer = [[UIView alloc] init];
        [collectionGridContainer setBackgroundColor:[UIColor lightGrayColor]];
        [self addSubview:collectionGridContainer];
        
        self.collectionInfoCompleteView = [[UIView alloc] init];
        [self.collectionInfoCompleteView setBackgroundColor:[UIColor whiteColor]];
        [collectionGridContainer addSubview:self.collectionInfoCompleteView];
        [collectionGridContainer bringSubviewToFront:self.collectionInfoCompleteView];
        
        self.gridHeaderView = [[BrandCollectionHeaderView alloc] initWithFrame:CGRectZero];
//        [self.gridHeaderView setBackgroundColor:[UIColor clearColor]];
        [collectionGridContainer addSubview:self.gridHeaderView];
        [collectionGridContainer sendSubviewToBack:self.gridHeaderView];
        

        // Upper Strip object allocation
        self.collectionLogo = [[UIImageView alloc] initWithFrame:CGRectZero];
        [self.collectionLogo setBackgroundColor:[UIColor whiteColor]];
        self.collectionLogo.layer.cornerRadius = 3.0f;
        
        self.collectionLogo.layer.borderWidth =1.0f;
        self.collectionLogo.layer.borderColor = UIColorFromRGB(0xDDDDDD).CGColor; //UIColorFromRGB(0xDDDDDD).CGColor;
        self.collectionLogo.clipsToBounds = TRUE;
        [self.collectionInfoCompleteView addSubview:self.collectionLogo];
        
        self.brandInfoUpperStrip = [[UIView alloc] initWithFrame:CGRectZero];
        [self.brandInfoUpperStrip setBackgroundColor:[UIColor whiteColor]];
        self.brandName = [[UILabel alloc] initWithFrame:CGRectZero];
//        [self.brandName setBackgroundColor:[UIColor clearColor]];
        [self.brandName setTextColor:UIColorFromRGB(kDarkPurpleColor)];
        [self.brandName setFont:[UIFont fontWithName:kMontserrat_Regular size:15.0f]];
        
        self.bannerHeight = [self getHeightFromAspectRatio:self.collectionTileModel.bannerAspectRatio andWidth:self.bannerWidth];
        
        
        
        
        self.brandStoreLocation = [[UILabel alloc] initWithFrame:CGRectZero];
        [self.brandStoreLocation setNumberOfLines:0];
//        [self.brandStoreLocation setBackgroundColor:[UIColor clearColor]];
        [self.brandStoreLocation setFont:[UIFont fontWithName:kMontserrat_Light size:12.0f]];
        [self.brandStoreLocation setTextColor:UIColorFromRGB(kDarkPurpleColor)];
        
        [self.brandInfoUpperStrip addSubview:self.brandName];
        [self.brandInfoUpperStrip addSubview:self.brandStoreLocation];
        [self.collectionInfoCompleteView addSubview:self.brandInfoUpperStrip];
        
        
        // Grid Products Allocation
//            UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
//            [layout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
//            self.productAdapter = [[ProductCollectionAdapter alloc] init];
//            self.productAdapter.delegate = self;
//            self.productCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
//            [self.productCollectionView setShowsHorizontalScrollIndicator:NO];
//            [self.productCollectionView registerClass:[BrandProductCell class] forCellWithReuseIdentifier:@"ProductCell"];
//            self.productCollectionView.pagingEnabled = TRUE;
//            [self.productCollectionView setBackgroundColor:[UIColor clearColor]];
//            [self.collectionInfoCompleteView addSubview:self.productCollectionView];
        
        layout = [[UICollectionViewFlowLayout alloc] init];
        [layout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
        self.productAdapter = [[ProductCollectionAdapter alloc] init];
        self.productAdapter.delegate = self;
        self.productCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        self.productCollectionView.scrollsToTop = NO;
        [self.productCollectionView setShowsHorizontalScrollIndicator:NO];
        [self.productCollectionView registerClass:[BrandProductCell class] forCellWithReuseIdentifier:@"ProductCell"];
//        self.productCollectionView.pagingEnabled = TRUE;
        [self.productCollectionView setBackgroundColor:[UIColor clearColor]];
        [self.collectionInfoCompleteView addSubview:self.productCollectionView];
        
        
        // Lower Strip object allocation
        self.brandInfoLowerStrip = [[UIView alloc] initWithFrame:CGRectZero];
        [self.brandInfoLowerStrip setBackgroundColor:[UIColor whiteColor]];
        
        self.brandStores = [[UILabel alloc] initWithFrame:CGRectZero];
//        [self.brandStores setBackgroundColor:[UIColor clearColor]];
        [self.brandStores setFont:[UIFont fontWithName:kMontserrat_Regular size:12.0f]];
        
        
        self.followBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        
        [self.followBtn addTarget:self action:@selector(toggleFollow:forEvent:) forControlEvents:UIControlEventTouchUpInside];
        [self.followBtn.layer setCornerRadius:2.0];
        
        self.brandFollowers = [[UILabel alloc] initWithFrame:CGRectZero];
//        [self.brandFollowers setBackgroundColor:[UIColor clearColor]];
        [self.brandFollowers setFont:[UIFont fontWithName:kMontserrat_Regular size:12.0f]];
        
        [self.brandInfoLowerStrip addSubview:self.brandStores];
        [self.brandInfoLowerStrip addSubview:self.followBtn];
        [self.brandInfoLowerStrip addSubview:self.brandFollowers];
        [self.collectionInfoCompleteView addSubview:self.brandInfoLowerStrip];
        
        
//        requestHandler = [[SSBaseRequestHandler alloc] init];
        
        discountContainerView = [[UIView alloc] init];
        [collectionGridContainer addSubview:discountContainerView];
        
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
    [collectionGridContainer setFrame:CGRectMake(RelativeSize(3, 320), RelativeSize(4, 320), self.frame.size.width - RelativeSize(6, 320), self.frame.size.height - RelativeSize(8, 320))];
    
    [collectionGridContainer setBackgroundColor:[UIColor whiteColor]];
    collectionGridContainer.layer.cornerRadius = 3.0;
    
    collectionGridContainer.layer.shadowColor = UIColorFromRGB(kShadowColor).CGColor;
    [collectionGridContainer.layer setShadowOpacity:0.1];
    [collectionGridContainer.layer setShadowOffset:CGSizeMake(0.0, 1.0)];
    
    self.bannerHeight = [self getHeightFromAspectRatio:self.collectionTileModel.bannerAspectRatio andWidth:self.bannerWidth];
    
    self.gridHeaderView.isBrandTile = FALSE;
    self.gridHeaderView.bannerImageUrl = self.collectionTileModel.banner_url;
    self.gridHeaderView.bannerLogoUrl = self.collectionTileModel.collectionlogo;
    self.gridHeaderView.logoAspectRatio = self.collectionTileModel.collectionLogoAspectRatio;
    self.gridHeaderView.productColor = self.collectionTileModel.productColor;
    
    [self.gridHeaderView setFrame:CGRectMake(RelativeSize(3, 320), RelativeSize(3, 320), collectionGridContainer.frame.size.width - RelativeSize(12, 320), self.bannerHeight-RelativeSize(12, 320))];
    
    [self.gridHeaderView configureHeader];
    
    [self downloadLogo:self.collectionTileModel.collectionlogo];
    
    tempSize = [SSUtility getLabelDynamicSize:self.collectionTileModel.banner_title withFont:[UIFont fontWithName:kMontserrat_Regular size:15.0f] withSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
    upperInfoTripHeight = RelativeSizeHeight(2, 480) + tempSize.height + RelativeSizeHeight(2, 480);
    
    modifiedString = [NSString stringWithFormat:@"Last Updated %@",self.collectionTileModel.last_updated];
    tempSize = [SSUtility getLabelDynamicSize:modifiedString withFont:[UIFont fontWithName:kMontserrat_Light size:12.0f] withSize:CGSizeMake(250, MAXFLOAT)];
    upperInfoTripHeight += tempSize.height + RelativeSizeHeight(2, 480);
    
    [self.brandInfoUpperStrip setFrame:CGRectMake(0,RelativeSize(3, 320)+ (kLogoWidth/2 -10), self.gridHeaderView.frame.size.width,upperInfoTripHeight)];
    
    size = [SSUtility getLabelDynamicSize:self.collectionTileModel.banner_title withFont:[UIFont fontWithName:kMontserrat_Regular size:15.0f] withSize:CGSizeMake(MAXFLOAT, RelativeSize(17, 320))];
    [self.brandName setFrame:CGRectMake(self.gridHeaderView.frame.size.width/2-size.width/2, 0, size.width, size.height)];
    [self.brandName setText:self.collectionTileModel.banner_title];
    
//    lastUpdated = [NSString stringWithFormat:@"Updated %@",self.collectionTileModel.last_updated];
    size = [SSUtility getLabelDynamicSize:self.collectionTileModel.last_updated withFont:[UIFont fontWithName:kMontserrat_Light size:12.0f] withSize:CGSizeMake(250, MAXFLOAT)];
    [self.brandStoreLocation setText:self.collectionTileModel.last_updated];
    [self.brandStoreLocation setFrame:CGRectMake(self.gridHeaderView.frame.size.width/2 - size.width/2, self.brandName.frame.origin.y + self.brandName.frame.size.height+2, size.width, size.height+3)];
    
    
    CGFloat lowerInfoY = self.brandInfoUpperStrip.frame.origin.y + self.brandInfoUpperStrip.frame.size.height;
    if([self.collectionTileModel.products count] >0){
        self.productAdapter.totalProducts = self.collectionTileModel.products;
        self.productAdapter.productCellSize = self.collectionViewCellSize;
        self.productCollectionView.dataSource = self.productAdapter;
        self.productCollectionView.delegate = self.productAdapter;
        
        [self.productCollectionView setFrame:CGRectMake(self.brandInfoUpperStrip.frame.origin.x , self.brandInfoUpperStrip.frame.origin.y + self.brandInfoUpperStrip.frame.size.height+1*kVerticalPadding, self.brandInfoUpperStrip.frame.size.width,self.collectionViewCellSize.height)];
    }
    
    if([self.collectionTileModel.products count] >0)
        lowerInfoY += self.productCollectionView.frame.size.height + RelativeSizeHeight(6, 480);
    else
        lowerInfoY += self.productCollectionView.frame.size.height;
    
    [self.brandInfoLowerStrip setFrame:CGRectMake(self.productCollectionView.frame.origin.x, lowerInfoY + RelativeSizeHeight(8, 480), self.gridHeaderView.frame.size.width, RelativeSizeHeight(kFollowBtnHeight, 480)+4)];
    [self.followBtn setFrame:CGRectMake(self.brandInfoLowerStrip.frame.size.width/2 - RelativeSize(kFollowBtnWidth, 320)/2, self.brandInfoLowerStrip.frame.size.height/2 - RelativeSizeHeight(kFollowBtnHeight, 480)/2, RelativeSize(kFollowBtnWidth, 320), RelativeSizeHeight(kFollowBtnHeight, 480))];
    
    storeString1 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%ld", (long)self.collectionTileModel.product_count] attributes:@{NSFontAttributeName : boldFontForCount, NSForegroundColorAttributeName : UIColorFromRGB(kDarkPurpleColor)}];
    if (self.collectionTileModel.product_count>1) {
        storesString2 = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@" Products"] attributes:@{NSFontAttributeName : regularFontForStore, NSForegroundColorAttributeName : UIColorFromRGB(kDarkPurpleColor)}];
        
    }else{
        storesString2 = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@" Product"] attributes:@{NSFontAttributeName : regularFontForStore, NSForegroundColorAttributeName : UIColorFromRGB(kDarkPurpleColor)}];
    }
    
    [storeString1 appendAttributedString:storesString2];
    
    storeRect = [storeString1 boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingTruncatesLastVisibleLine context:NULL];
    [self.brandStores setFrame:CGRectMake(self.followBtn.frame.origin.x - (RelativeSize(20, 320) + storeRect.size.width),self.followBtn.frame.origin.y + self.followBtn.frame.size.height/2 -storeRect.size.height/2, storeRect.size.width, storeRect.size.height)];
    [self.brandStores setAttributedText:storeString1];
    
    
    if(!self.collectionTileModel.is_following){
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
    
    
    followerString1 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%ld", (long)self.collectionTileModel.follower_count] attributes:@{NSFontAttributeName : boldFontForCount, NSForegroundColorAttributeName : UIColorFromRGB(kDarkPurpleColor)}];
    followerString2 = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:(self.collectionTileModel.follower_count == 1 ? @" Follower" : @" Followers")] attributes:@{NSFontAttributeName : regularFontForStore, NSForegroundColorAttributeName : UIColorFromRGB(kDarkPurpleColor)}];
    [followerString1 appendAttributedString:followerString2];
    
    
    followerRect = [followerString1 boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingTruncatesLastVisibleLine context:NULL];
    [self.brandFollowers setFrame:CGRectMake(self.followBtn.frame.origin.x + self.followBtn.frame.size.width + RelativeSize(17, 320), self.followBtn.frame.origin.y +self.followBtn.frame.size.height/2 -followerRect.size.height/2, followerRect.size.width, followerRect.size.height)];
    
    [self.brandFollowers setAttributedText:followerString1];
    [self.collectionLogo setFrame:CGRectMake(self.gridHeaderView.frame.size.width/2 -kLogoWidth/2, self.collectionInfoCompleteView.frame.origin.y -(kLogoWidth/2+15), kLogoWidth, kLogoWidth)];
    
    [self.collectionInfoCompleteView setFrame:CGRectMake(self.gridHeaderView.frame.origin.x+3, self.gridHeaderView.frame.origin.y+self.gridHeaderView.frame.size.height -kExtraPadding+3, self.gridHeaderView.frame.size.width+1, self.brandInfoLowerStrip.frame.origin.y + self.brandInfoLowerStrip.frame.size.height)];
    
    
    if(self.collectionTileModel.discountString && self.collectionTileModel.discountString.length > 0){
        discountImage = [UIImage imageNamed:@"DiscountBadgeRed"];
        [discountImageView setFrame:CGRectMake(0, 0, discountImage.size.width, discountImage.size.height)];
        discountImageView.image = discountImage;
        [discountContainerView setFrame:CGRectMake(self.gridHeaderView.frame.origin.x + self.gridHeaderView.frame.size.width - discountImage.size.width - 6, 0, discountImageView.frame.size.width, discountImageView.frame.size.height)];
        
        NSMutableParagraphStyle *style  = [[NSMutableParagraphStyle alloc] init];
        style.minimumLineHeight = 12;
        style.maximumLineHeight = 12;
        style.alignment = NSTextAlignmentCenter;
        //        [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, label.text.length)];
        
        
        
        NSRange percentRange = [self.collectionTileModel.discountString rangeOfString:@"%"];
        
        NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:self.collectionTileModel.discountString attributes:@{NSFontAttributeName : [UIFont fontWithName:kMontserrat_Regular size:12.0], NSForegroundColorAttributeName :[UIColor whiteColor], NSParagraphStyleAttributeName : style}];
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
    [collectionGridContainer setFrame:CGRectZero];

    
    self.collectionTileModel = nil;
    
    [self.gridHeaderView.headerDataTask cancel];
    self.gridHeaderView.headerDataTask = nil;
    //    self.gridHeaderView.bannerImageDownloded = FALSE;
    self.gridHeaderView.bannerImageUrl = nil;
    //    self.gridHeaderView.headerImageView.image = nil;
    self.gridHeaderView.headerImageView.image = [UIImage imageNamed:@"ImagePlaceholder"];

    
    [self.collectionInfoCompleteView setFrame:CGRectZero];
    [self.gridHeaderView setFrame:CGRectZero];
    [self.productCollectionView setFrame:CGRectZero];
    self.productCollectionView.dataSource = nil;
    
    self.collectionLogo.image = nil;
    [self.collectionLogo setFrame:CGRectZero];
    
    [self.brandInfoUpperStrip setFrame:CGRectZero];
    [self.brandName setFrame:CGRectZero];
    [self.brandStoreLocation setFrame:CGRectZero];
    [self.collectionInfoCompleteView setFrame:CGRectZero];
    tempSize = CGSizeZero;
    modifiedString = nil;
    
    
    [self.brandInfoLowerStrip setFrame:CGRectZero];
    [self.followBtn setFrame:CGRectZero];
    [self.brandStores setFrame:CGRectZero];
    [self.brandFollowers setFrame:CGRectZero];
    
    
//    self.collectionTileModel = nil;
//    self.productAdapter = nil;
    
    storeString1 = nil;
    storesString2 = nil;
    storeRect = CGRectZero;
    
    followerString1 = nil;
    followerString2 = nil;
    followerRect = CGRectZero;
    
    boldFontForCount = nil;
    regularFontForStore = nil;
    
    followText = nil;
    lastUpdated = nil;
    
    [discountContainerView setFrame:CGRectZero];
    [discountLabel setFrame:CGRectZero];
    [discountImageView setFrame:CGRectZero];
}




- (void)downloadLogo:(NSString *)imageUrl{
    
    NSString *dataURL =  imageUrl;
    [self.collectionLogo sd_setImageWithURL:[NSURL URLWithString:[dataURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
//        [self.contentView setBackgroundColor:[UIColor clearColor]];
        [self.collectionLogo setAlpha:0.3];
        [UIView animateWithDuration:0.4 animations:^{
            [self.collectionLogo setAlpha:1.0];
        }];
    }];
}



#pragma mark ProductCollectionAdapter

- (void)selectedProductTile:(SubProductModel *)subProduct{
    if([self.collectionDelegate respondsToSelector:@selector(selectedBrandProduct:)]){
        [self.collectionDelegate selectedCollectionProduct:subProduct.action.url];
    }
}


-(CGFloat)getHeightFromAspectRatio:(NSString *)aspectRatio andWidth:(CGFloat)width{
    CGFloat height = 0;
    NSArray *ratioArray = [aspectRatio componentsSeparatedByString:@":"];
    height = (width - 20) * [[ratioArray lastObject] floatValue] / [[ratioArray firstObject] floatValue];
    return height;
}



-(void)toggleFollow:(id)sender forEvent:(UIEvent *)theEvent{
    
    UIButton *theCell = (UIButton *)sender;
    UITouch *touch = [[theEvent touchesForView:theCell] anyObject];
    self.collectionTileModel.is_following = !self.collectionTileModel.is_following;
    
    if (self.collectionTileModel.theCollectionTileType == CollectionTileMyCollection) {
        if(self.theCollectionLocationBlock){
            if (self.collectionTileModel.is_following) {
                self.theCollectionLocationBlock(touch,TRUE);
            }else{
                self.theCollectionLocationBlock(touch,FALSE);
            }

        }
    }
    if(followTimer){
        [followTimer invalidate];
        followTimer = nil;
    }
    if ([(FyndUser *)[SSUtility loadUserObjectWithKey:kFyndUserKey] isOnboarded])
        followTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(hitFollow) userInfo:nil repeats:NO];
    

//    NSString *str = [SSUtility traverseToGetControllerName:self];
//    if(self.collectionTileModel.theCollectionTileType == CollectionTileMyCollection){
//        str = @"my_collection";
//    }
    
    if(!self.collectionTileModel.is_following){
//        if([(FyndUser *)[SSUtility loadUserObjectWithKey:kFyndUserKey] isOnboarded]){
//            [FyndAnalytics trackCollectionFollow:str collectiondName:self.collectionTileModel.name isUnFollowed:YES];
//        }
        followText = [[NSAttributedString alloc] initWithString : @"FOLLOW"
                                                     attributes : @{
                                                                    NSFontAttributeName : [UIFont fontWithName:kMontserrat_Bold size:14.0],
                                                                    NSForegroundColorAttributeName : [UIColor whiteColor]
                                                                    }];
//        [self.followBtn setBackgroundColor:UIColorFromRGB(kRedColor)];
        [self.followBtn setBackgroundColor:UIColorFromRGB(kTurquoiseColor)];
        
    }else {
//        if([(FyndUser *)[SSUtility loadUserObjectWithKey:kFyndUserKey] isOnboarded]){
//            [FyndAnalytics trackCollectionFollow:str collectiondName:self.collectionTileModel.name isUnFollowed:NO];
//        }
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
    if (![(FyndUser *)[SSUtility loadUserObjectWithKey:kFyndUserKey] isOnboarded]){
        if (self.collectionDelegate && [self.collectionDelegate respondsToSelector:@selector(collectionFollowingData:)]) {
            [self.collectionDelegate collectionFollowingData:self.collectionTileModel];
        }
    }
}

-(void)hitFollow{
    NSMutableString *urlString = [[NSMutableString alloc] initWithString:kAPI_Inventory];

    NSString *dataURL;
    if(!self.collectionTileModel.is_following ){
        dataURL = [NSString stringWithFormat:@"%@collection_id=%@", kBrandUnfollowURL, [SSUtility handleEncoding:self.collectionTileModel.collectionID]];
    }else{
        dataURL = [NSString stringWithFormat:@"%@collection_id=%@", kBrandFollowURL, [SSUtility handleEncoding:self.collectionTileModel.collectionID]];
    }
    
    [urlString appendString:dataURL];
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    
    NSURLSessionDataTask *likeTask = [session dataTaskWithRequest:req completionHandler:^(NSData *data, NSURLResponse *response, NSError *error){
        if(data.length > 0 && data != nil){
            NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            if([json count] > 0){
                [self setFollowersCount:json];
                
                if([(FyndUser *)[SSUtility loadUserObjectWithKey:kFyndUserKey] isOnboarded]){
                    
                    NSString *str = [SSUtility traverseToGetControllerName:self];
                    if(self.collectionTileModel.theCollectionTileType == CollectionTileMyCollection){
                        str = @"my_collection";
                    }
                    
                    NSString *string = [[response URL] absoluteString];
                    if([string rangeOfString:@"unfollow"].length > 0){
                        [FyndAnalytics trackCollectionFollow:str collectiondName:self.collectionTileModel.name isUnFollowed:NO];
                    }else{
                        [FyndAnalytics trackCollectionFollow:str collectiondName:self.collectionTileModel.name isUnFollowed:YES];
                    }
                }
                
                
            }else {
            }
        }
    }];
    [likeTask resume];
}


//-(void)hitFollow{
//    
//    if(!collectionModel.is_following ){
//        [self.browseByCollectionRequestHandler unfollowCollection:collectionModel.collectionID withRequestCompletionhandler:^(id responseData, NSError *error) {
//            if(!error){
//                
//                [self setFollowersCount:responseData];
//            }
//        }];
//    }else{
//        [self.browseByCollectionRequestHandler followCollection:collectionModel.collectionID withRequestCompletionhandler:^(id responseData, NSError *error) {
//            if(!error){
//                [self setFollowersCount:responseData];
//            }
//        }];
//    }
//}

-(void)setFollowersCount:(id)response{
    if ([response objectForKey:@"counts"]) {
        NSArray *countArray = [response valueForKey:@"counts"];
        if ([countArray count]>0) {
            NSDictionary *countDic = [countArray objectAtIndex:0];
            if ([countDic objectForKey:@"count"]) {
                self.collectionTileModel.follower_count = [[countDic objectForKey:@"count"] integerValue];
                followerString1 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%ld", (long)self.collectionTileModel.follower_count] attributes:@{NSFontAttributeName : boldFontForCount, NSForegroundColorAttributeName : UIColorFromRGB(kDarkPurpleColor)}];
                followerString2 = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:(self.collectionTileModel.follower_count == 1 ? @" Follower" : @" Followers")] attributes:@{NSFontAttributeName : regularFontForStore, NSForegroundColorAttributeName : UIColorFromRGB(kDarkPurpleColor)}];
                [followerString1 appendAttributedString:followerString2];
                
                followerRect = [followerString1 boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingTruncatesLastVisibleLine context:NULL];
                [self.brandFollowers setFrame:CGRectMake(self.followBtn.frame.origin.x + self.followBtn.frame.size.width + 2*kVerticalPadding, self.followBtn.frame.origin.y +self.followBtn.frame.size.height/2 -followerRect.size.height/2, followerRect.size.width, followerRect.size.height)];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.brandFollowers setAttributedText:followerString1];
                });

            }
        }
    }

//    NSString *key = [[dictionary allKeys] objectAtIndex:0];
//    self.collectionTileModel.follower_count = [[dictionary objectForKey:key] integerValue];
    
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */

@end
