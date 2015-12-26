//
//  NearestStorePopUp.m
//  Explore
//
//  Created by Pranav on 14/07/15.
//  Copyright (c) 2015 Rahul. All rights reserved.
//

#import "NearestStorePopUp.h"
#import "PDPModel.h"
#import "PDPStoresCell.h"
#import "SSUtility.h"
#import "PopHeaderView.h"

@interface NearestStorePopUp(){
    BOOL moreStoresClicked;
    UIImageView *accesoryImageView;
    PopHeaderView *popUpHeaderView;
    NSArray       *daysArray;
    NSArray       *timeSlotArray;
}
@end

@implementation NearestStorePopUp

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
        [self setBackgroundColor:[UIColor whiteColor]];
        daysArray = [[NSArray alloc] initWithObjects:@"Today",@"Tomorrow", nil];
        timeSlotArray = [[NSArray alloc] initWithObjects:@"11:00AM-1:00PM",@"1:00PM-3:00PM",@"3:00PM-5:00PM", nil];
    }
    return self;
}
-(void)showHeader{
    popUpHeaderView = [[PopHeaderView alloc] init];
    NSString *headerString = nil;
    NSString *imageName = nil;
    if (self.isViewAllStores) {
        headerString = @"NEAREST STORE";
        imageName = @"Store";
    }else{
        headerString = @"PICK @ STORE";
        imageName = @"PickAtStore";
    }
    
    [self addSubview:[popUpHeaderView popHeaderViewWithTitle:headerString andImageName:imageName withOrigin:CGPointMake(RelativeSize(-11, 320), self.frame.origin.y-(RelativeSizeHeight(80, 568)))]];
}
- (void)generateStores{
//    [self showHeader];
    CGRect tableFrame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    self.storesTable = [[UITableView alloc] initWithFrame:tableFrame];
    [self.storesTable setBackgroundColor:[UIColor whiteColor]];
    [self.storesTable setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    self.storesTable.dataSource = self;
    self.storesTable.delegate = self;
    if (!self.isViewAllStores) {
        [self.storesTable setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    }
//    self.storesTable.tableHeaderView = [self configureTableHeader];
    [self addSubview:self.storesTable];
}


- (UIView *)configureTableHeader{
    UIView *tableHeader = [[UIView alloc] initWithFrame:CGRectMake(self.frame.origin.x, 0, self.frame.size.width, 60)];
    [tableHeader setBackgroundColor:[UIColor whiteColor]];

    CGFloat logoImageWidth = 40.0f;
    UIImageView *logoImage = [[UIImageView alloc] initWithFrame:CGRectMake(RelativeSize(15, 320), tableHeader.frame.size.height/2 -(logoImageWidth/2), logoImageWidth, logoImageWidth)];
    logoImage.layer.cornerRadius = 3.0f;
    logoImage.layer.borderWidth = 1.0f;
    logoImage.layer.borderColor = UIColorFromRGB(0xe4e5e6).CGColor;
    logoImage.clipsToBounds = TRUE;
    [logoImage setBackgroundColor:[UIColor clearColor]];
//    [logoImage setImage:[UIImage imageNamed:@"Logo4.png"]];
    
    if(self.brandLogoImageUrl && self.brandLogoImageUrl.length >0)
    {
        // Asynchronously retrieve image
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
            NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:self.brandLogoImageUrl]];
            
            dispatch_sync(dispatch_get_main_queue(), ^{
                [logoImage setImage:[UIImage imageWithData:imageData]];
            });
        });
    }
    
    [tableHeader addSubview:logoImage];
    NSString *storeString = nil;
    if ([self.storedData count]>1) {
        storeString = [NSString stringWithFormat:@"%ld Stores Nearby",(unsigned long)[self.storedData count]];        
    }else{
        storeString = [NSString stringWithFormat:@"%ld Store Nearby",(unsigned long)[self.storedData count]];
    }
    CGSize size1 = [SSUtility getLabelDynamicSize:storeString withFont:[UIFont fontWithName:kMontserrat_Regular size:15.0f] withSize:CGSizeMake(tableHeader.frame.size.width -(logoImage.frame.origin.x + logoImage.frame.size.width) , MAXFLOAT)];
    
    UILabel *totalStores = [SSUtility generateLabel:storeString withRect:CGRectMake(logoImage.frame.origin.x + logoImage.frame.size.width + kStorePadding, logoImage.frame.origin.y+logoImage.frame.size.height/2 - size1.height/2, 300, size1.height) withFont:[UIFont fontWithName:kMontserrat_Regular size:15.0f]];
    [totalStores setTextAlignment:NSTextAlignmentLeft];
    [totalStores setText:storeString];
    [totalStores setTextColor:UIColorFromRGB(kDarkPurpleColor)];
    [tableHeader addSubview:totalStores];
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *currentAddress = [userDefaults objectForKey:@"location"];
    CGSize size = [SSUtility getLabelDynamicSize:currentAddress withFont:[UIFont fontWithName:kMontserrat_Regular size:16.0f] withSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
    
    UILabel *address = [[UILabel alloc] initWithFrame:CGRectMake(self.frame.size.width - size.width, totalStores.frame.origin.y, 100, 40)];
    [address setBackgroundColor:[UIColor clearColor]];
    
    
    [address setText:currentAddress];
    [address setFont:[UIFont fontWithName:kMontserrat_Light size:12.0f]];
    [address setTextColor:UIColorFromRGB(kLightGreyColor)];
    [tableHeader addSubview:address];
    
//    SSLine *line = [[SSLine alloc] initWithFrame:CGRectMake(logoImage.frame.origin.x, tableHeader.frame.size.height - 1, tableHeader.frame.size.width-(2*logoImage.frame.origin.x),1)];
    SSLine *line = [[SSLine alloc] initWithFrame:CGRectMake(tableHeader.frame.origin.x, tableHeader.frame.size.height - 1, tableHeader.frame.size.width,1)];
    
    [tableHeader addSubview:line];
    
    UIButton  *crossButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [crossButton setFrame:CGRectMake(line.frame.origin.x + line.frame.size.width - 32-kStorePadding, tableHeader.frame.size.height/2 - 16, 32, 32)];
    [crossButton setBackgroundColor:[UIColor clearColor]];
    [crossButton setBackgroundImage:[UIImage imageNamed:@"CrossGrey"] forState:UIControlStateNormal];
    [crossButton addTarget:self action:@selector(croosClicked) forControlEvents:UIControlEventTouchUpInside];
    [tableHeader addSubview:crossButton];
                                                                           
    return tableHeader;
}

-(void)croosClicked{
    if(self.tapOnCancel){
        self.tapOnCancel();
    }
}


#pragma mark TableView Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
//    return 3; //[self.storedData count];
    
    NSInteger sectionCount =0;
    if(self.isViewAllStores){
//        sectionCount =2;
        sectionCount =1;
    }else{
        sectionCount =3;
    }
    return sectionCount;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSInteger rowCount =0;
//    if(section ==1){
    if(section ==0){
        if(moreStoresClicked || self.isViewAllStores)
            rowCount = [self.storedData count];
        else
             rowCount = 0;
    }else{
        rowCount =1;
    }
//    rowCount = 3;
    return rowCount;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat cellHeight = 0.0f;
    cellHeight = [self getStoreCellHeight:[self.storedData objectAtIndex:indexPath.row] andIndex:indexPath.row+1];
    return cellHeight;
}



- (CGFloat)getStoreCellHeight:(Store *)store andIndex:(NSInteger)storeIndex{
    
    CGFloat storeHeight = 0.0f;
    CGSize dynamicSize = CGSizeZero;
    NSString *storeName = store.storeName;

    storeHeight = kStorePadding;
    
    dynamicSize = [SSUtility getLabelDynamicSize:storeName withFont:[UIFont fontWithName:kMontserrat_Regular size:14.0f] withSize:CGSizeMake(self.frame.size.width - (40), MAXFLOAT)];
    
    storeHeight += dynamicSize.height;
    
    NSString *storeOpeningStatus = nil;
    if(store.isStoreOpen){
        storeOpeningStatus = @"OPEN";
    }else{
        storeOpeningStatus = @"CLOSED";
    }
    dynamicSize= [SSUtility getLabelDynamicSize:storeOpeningStatus withFont:[UIFont fontWithName:kMontserrat_Regular size:12.0f] withSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
    
    
    storeHeight += dynamicSize.height + kStorePadding-3 + kStorePadding +20 + kStorePadding+5;
    
    return  storeHeight;
}

-(CGFloat)tableView:(UITableView*)tableView heightForHeaderInSection:(NSInteger)section
{
    CGFloat headerHeight = 0.0f;
    
    if(section==0){
        headerHeight =60.0f;
    }
    else if(section == 1 && !self.isViewAllStores)
        headerHeight = RelativeSizeHeight(30, 480);
    return headerHeight;
}


-(UIView*)tableView:(UITableView*)tableView viewForFooterInSection:(NSInteger)section
{
    return [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
}


- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *sectionHeader = nil;

//    if(section==2)
    if(section==2)
    {
        if (!self.isViewAllStores) {
            sectionHeader = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.storesTable.frame.size.width, RelativeSizeHeight(30, 480))];
            [sectionHeader setBackgroundColor:[UIColor whiteColor]];
            UIButton *moreStoreBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            [moreStoreBtn setBackgroundColor:[UIColor clearColor]];
            [moreStoreBtn setFrame:CGRectMake(RelativeSize(5, 320), 0, 100, RelativeSizeHeight(30, 480))];
            [moreStoreBtn setTitle:@"More Store" forState:UIControlStateNormal];
            moreStoreBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
            [moreStoreBtn addTarget:self action:@selector(showMoreStores:) forControlEvents:UIControlEventTouchUpInside];
            [moreStoreBtn.titleLabel setFont:[UIFont fontWithName:kMontserrat_Regular size:11.0f]];
            [moreStoreBtn setTitleColor:UIColorFromRGB(0x5F9DE5) forState:UIControlStateNormal];
            [sectionHeader addSubview:moreStoreBtn];
            
            accesoryImageView = [[UIImageView alloc] initWithFrame:CGRectMake(moreStoreBtn.frame.origin.x + moreStoreBtn.frame.size.width, moreStoreBtn.frame.size.height/2 - 5, 10, 10)];
            [accesoryImageView setBackgroundColor:[UIColor clearColor]];
            [accesoryImageView setImage:[UIImage imageNamed:@"CheckDelivery_arrow.png"]];
            [sectionHeader addSubview:accesoryImageView];
            
        }else{
            sectionHeader = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.storesTable.frame.size.width, 30)];
            [sectionHeader setBackgroundColor:[UIColor greenColor]];
        }
        
    }else if(section ==0){
        sectionHeader = [self configureTableHeader];
    }
    
    return sectionHeader;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellIdentifier = nil; //= @"StoresCell";
    
    UITableViewCell *cell= nil;
    PDPStoresCell *storeCell =nil;
//    if(indexPath.section == 0){
    if(indexPath.section == 3){
        cellIdentifier = @"NearestStoreCell";
        if(cell== nil){
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        }
        [cell.contentView addSubview:[self generateNearestView]];
        
    }
//    else if(indexPath.section ==1){
    else if(indexPath.section ==0){
        cellIdentifier = @"StoresCell";
        storeCell =(PDPStoresCell *) [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if(cell == nil){
            storeCell = (PDPStoresCell *)[[PDPStoresCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        }
        storeCell.storeIndex = indexPath.row+1;
        [storeCell setSelectionStyle:UITableViewCellSelectionStyleNone];
        storeCell.cellStoreData =[self.storedData objectAtIndex:indexPath.row];
        [storeCell configureCell];
        
        if(indexPath.row != [self.storedData count]-1){
        }
        
        
        cell = (UITableViewCell *)storeCell;
        
    }
    else if(indexPath.section ==2){
        cellIdentifier = @"ScheduleVisit";
        if(cell== nil){
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        }
        [cell.contentView addSubview:[self generateScheduleVisit]];
    }
    return cell;
}


- (UIView *)generateNearestView{
    
    UIView *nearView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 365, RelativeSizeHeight(80, 480))];
    UIImageView *anImage = [[UIImageView alloc] initWithFrame:CGRectMake(RelativeSize(20, 320), 5, 20, 15)];
    [anImage setBackgroundColor:[UIColor clearColor]];
    [anImage setImage:[UIImage imageNamed:@"Store.png"]];
    [nearView addSubview:anImage];
    
    UILabel *storeHeading = [[UILabel alloc] initWithFrame:CGRectMake(anImage.frame.origin.x + anImage.frame.size.width +10, anImage.frame.origin.y, 200, 20)];
    [storeHeading setBackgroundColor:[UIColor clearColor]];
    [storeHeading setText:@"Nearest Store Address"];
    [storeHeading setFont:[UIFont fontWithName:kMontserrat_Regular size:12.0f]];
    [nearView addSubview:storeHeading];
    
    Store *nearestStore = [self.storedData objectAtIndex:0];
    
    CGSize storeNameSize = [SSUtility getLabelDynamicSize:nearestStore.storeName withFont:[UIFont fontWithName:kMontserrat_Regular size:12.0f] withSize:CGSizeMake(MAXFLOAT, 20)];
    
    UILabel *nearestStoreName  = [[UILabel alloc] initWithFrame:CGRectMake(anImage.frame.origin.x, anImage.frame.origin.y + anImage.frame.size.height + 10, storeNameSize.width+10, 20)];
    [nearestStoreName setBackgroundColor:[UIColor clearColor]];
    nearestStoreName.text = nearestStore.storeName;
    [nearestStoreName setTextColor:UIColorFromRGB(kGreenColor)];
    [nearestStoreName setFont:[UIFont fontWithName:kMontserrat_Regular size:12.0f]];
    [nearView addSubview:nearestStoreName];
    
    
    CGSize storeDistanceSize  = [SSUtility getLabelDynamicSize:[NSString stringWithFormat:@"(%@)",nearestStore.storeDistance] withFont:[UIFont fontWithName:kMontserrat_Regular size:12.0f] withSize:CGSizeMake(MAXFLOAT, 20)];
    
    UILabel * nearStoreDistance = [[UILabel alloc] initWithFrame:CGRectMake(nearestStoreName.frame.origin.x + nearestStoreName.frame.size.width + 10, nearestStoreName.frame.origin.y, storeDistanceSize.width, 20)];
    [nearStoreDistance setFont:[UIFont fontWithName:kMontserrat_Regular size:12.0f]];
    [nearStoreDistance setTextColor:UIColorFromRGB(kLightGreyColor)];
    [nearView addSubview:nearStoreDistance];
    
    
    UILabel *nearestStoreAddress = [[UILabel alloc] initWithFrame:CGRectMake(nearestStoreName.frame.origin.x, nearestStoreName.frame.origin.y + nearestStoreName.frame.size.height + 5, 300, 20)];
    [nearestStoreAddress setBackgroundColor:[UIColor clearColor]];
    [nearestStoreAddress setFont:[UIFont fontWithName:kMontserrat_Regular size:12.0f]];
    nearestStoreAddress.text = nearestStore.storeAddress;
    [nearestStoreAddress setTextColor:UIColorFromRGB(kLightGreyColor)];
    [nearView addSubview:nearestStoreAddress];
    
    return nearView;
}

- (void)showMoreStores:(id)sender{
    moreStoresClicked = !moreStoresClicked;
    
    if(moreStoresClicked){
        [UIView animateWithDuration:0.33f animations:^()
         {
             accesoryImageView.transform=CGAffineTransformMakeRotation(M_PI / 2);
         }];
        
        [self.storesTable insertRowsAtIndexPaths:[self indexPathForStores:[self.storedData count]] withRowAnimation:UITableViewRowAnimationNone];
    }else{
        [UIView animateWithDuration:0.33f animations:^()
         {
             accesoryImageView.transform=CGAffineTransformMakeRotation(0);
         }];
        [self.storesTable deleteRowsAtIndexPaths:[self indexPathForStores:[self.storedData count]] withRowAnimation:UITableViewRowAnimationNone];

    }
    
    
}


- (NSArray *)indexPathForStores:(NSInteger)rows{
    
    NSMutableArray *indexPathArray = [[NSMutableArray alloc] initWithCapacity:0];
    for(NSInteger counter=0; counter< rows; counter++){
        [indexPathArray addObject:[NSIndexPath indexPathForRow:counter inSection:1]];
    }
    return [indexPathArray copy];
}



- (UIView *)generateScheduleVisit{
    UIView *visitView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, RelativeSize(300, 320),310)];
    [visitView setUserInteractionEnabled:TRUE];
    
//    SSLine *headerLine = [[SSLine alloc] initWithFrame:CGRectMake(visitView.frame.origin.x, 5, visitView.frame.size.width, 1)];
//    [visitView addSubview:headerLine];
    
    UIImageView *clockIcon = [[UIImageView alloc] initWithFrame:CGRectMake(RelativeSize(20, 320), 12, 18, 17)];
    [clockIcon setImage:[UIImage imageNamed:@"Schedule"]];
    [visitView addSubview:clockIcon];
    
    UILabel *scheduleHeading = [[UILabel alloc] initWithFrame:CGRectMake(clockIcon.frame.origin.x + clockIcon.frame.size.width + 10, 10, 200, 20)];
    [scheduleHeading setBackgroundColor:[UIColor clearColor]];
    [scheduleHeading setText:@"Schedule Visit"];
    [scheduleHeading setFont:[UIFont fontWithName:kMontserrat_Regular size:12.0f]];
    [scheduleHeading setTextColor:UIColorFromRGB(kLightGreyColor)];
    [visitView addSubview:scheduleHeading];
    
    CGRect pickerFrame = CGRectMake(RelativeSize(0, 320),scheduleHeading.frame.origin.y + scheduleHeading.frame.size.height,visitView.frame.size.width,0);
    
    
    UIDatePicker *myPicker = [[UIDatePicker alloc] initWithFrame:pickerFrame];
    [myPicker addTarget:self action:@selector(pickerChanged:) forControlEvents:UIControlEventValueChanged];
    [myPicker setDatePickerMode:UIDatePickerModeDateAndTime];
//    [myPicker setBackgroundColor:[UIColor yellowColor]];
    [visitView addSubview:myPicker];
    
    
    CGFloat buttonWidth = (self.frame.size.width - (2*(RelativeSize(10, 320)) - 10))/2-10;
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancelBtn setBackgroundColor:UIColorFromRGB(kBackgroundGreyColor)];
    [cancelBtn setFrame:CGRectMake(RelativeSize(10, 320), myPicker.frame.origin.y + myPicker.frame.size.height-15,buttonWidth, 40)];
    [cancelBtn setTitleColor:UIColorFromRGB(kLightGreyColor) forState:UIControlStateNormal];
    [cancelBtn setTitle:@"CANCEL" forState:UIControlStateNormal];
    [cancelBtn.titleLabel setFont:[UIFont fontWithName:kMontserrat_Regular size:14.0f]];
    [cancelBtn addTarget:self action:@selector(dismissView:) forControlEvents:UIControlEventTouchUpInside];
    [visitView addSubview:cancelBtn];
    
    UIButton *confirmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [confirmBtn setBackgroundColor:UIColorFromRGB(kGreenColor)];
    [confirmBtn setFrame:CGRectMake(cancelBtn.frame.origin.x + cancelBtn.frame.size.width +10, cancelBtn.frame.origin.y, cancelBtn.frame.size.width, cancelBtn.frame.size.height)];
    [confirmBtn setTitle:@"CONFIRM" forState:UIControlStateNormal];
    [confirmBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [confirmBtn.titleLabel setFont:[UIFont fontWithName:kMontserrat_Regular size:14.0f]];
    [visitView addSubview:confirmBtn];
    
    return visitView;
}



-(void)dismissView:(id)sender{
    if (self.tapOnCancel) {
        self.tapOnCancel();        
    }

}

- (void)pickerChanged:(id)sender{
}


#pragma Mark UIPicker

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    
    return 2;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    NSInteger rowCount = 0;
    if(component == 0){
        rowCount = [daysArray count];
    }else{
        rowCount = [timeSlotArray count];
    }
    return rowCount;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
    return 50.0f;
}


- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component{
    
    CGFloat componentWidth = 0.0f;
    if(component == 0){
        componentWidth = 110.0f;
    }else{
        componentWidth = 300.0f;
    }
    return componentWidth;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    
    NSString *displyTitle = nil;
    if(component ==0){
        displyTitle = [daysArray objectAtIndex:row];
    }else{
        displyTitle = [timeSlotArray objectAtIndex:row];
    }
    return displyTitle;
    
}

- (NSAttributedString *)pickerView:(UIPickerView *)pickerView attributedTitleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSString *title = [self pickerView:pickerView titleForRow:row forComponent:component];
    NSAttributedString *attString;
    attString = [[NSAttributedString alloc] initWithString:title attributes:@{NSForegroundColorAttributeName:[UIColor blackColor], NSFontAttributeName : [UIFont fontWithName:HELVETICA_NEUE size:3.0f]}];
    return attString;
    
}


@end
