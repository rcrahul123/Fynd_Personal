//
//  BrowseByCateogiryView.m
//  Explore
//
//  Created by Amboj Goyal on 8/1/15.
//  Copyright (c) 2015 Rahul. All rights reserved.
//

#import "BrowseByCategoryView.h"
#import "SearchRequestHandler.h"
#import "SSUtility.h"
#import "GenderHeaderView.h"
#import "GenderHeaderModel.h"

@interface BrowseByCategoryView(){
    SearchRequestHandler *searchHandler;
    UITapGestureRecognizer *categoryTapGesture;
    
    UIView *theHeader;

    //Header for Browse
    UIView *browseByCategoryContainer;
    UIImageView *browseByCategoryImageView;
    UILabel *browseByCategoryTitle;
    
    //Header for Category

    UIFont *categoryItemFont;
    UIView *lineBar;
    
    NSMutableArray *sectionsBoolArray;
//    UIActivityIndicatorView *theIndicator;
    GenderHeaderView *theGenderView;
    UIButton *tappedButton;
    
}
@property (nonatomic,strong)NSMutableArray *allCategoryTilesArray;

@property (nonatomic,strong)NSMutableArray *allSectionsFlagArray;

@property (nonatomic,strong)NSMutableDictionary *finalCategoryDictionary;
@property (nonatomic,strong)NSMutableArray *finalCategoryArray;
@property (nonatomic,assign)NSInteger tappedSection;

@property (nonatomic,strong) UIScrollView *browseScrollView;
@property (nonatomic,strong) UITableView *browseTableView;
@end

@implementation BrowseByCategoryView
-(id)initWithFrame:(CGRect)frame dataDictionary:(NSDictionary *)dataDict{
    self = [super initWithFrame:frame];
    if(self){
        [self setBackgroundColor:[UIColor whiteColor]];
    }
    if (searchHandler) {
        searchHandler = nil;
    }
    searchHandler = [[SearchRequestHandler alloc] init];

//    if (theIndicator) {
//        [theIndicator removeFromSuperview];
//        theIndicator = nil;
//    }
//    theIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
//    [theIndicator setFrame:CGRectMake(self.frame.size.width/2 - 30, self.frame.size.height/2 - 30, 50, 50)];
//    [self addSubview:theIndicator];
//    [theIndicator startAnimating];
    
    
    if(searchLoader){
        [searchLoader stopAnimating];
        [searchLoader removeFromSuperview];
    }
    searchLoader = [[FyndActivityIndicator alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    [searchLoader setCenter:CGPointMake(self.frame.size.width/2, self.frame.size.height/2)];
    

//    [self createHeaderViews];
    self.allSectionsFlagArray = [[NSMutableArray alloc] initWithCapacity:0];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    if([defaults objectForKey:@"cachedCategoryData"]){
        NSDate *cachedDate= [defaults objectForKey:@"cachedDate"];

        NSDate *dateA = cachedDate;
        NSDate *dateB = [NSDate date];
        
        NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
        NSDateComponents *components = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay
                                                   fromDate:dateA
                                                     toDate:dateB
                                                    options:0];
        
        
        if(components.day >= 1){
            [self addSubview:searchLoader];
            [searchLoader startAnimating];
            [self fetchData];
        }else{
            NSArray *cacehedData = [searchHandler parseCategoryData:[defaults objectForKey:@"cachedCategoryData"]];
            if (self.finalCategoryArray) {
                self.finalCategoryArray = nil;
            }
            self.finalCategoryArray = [[NSMutableArray alloc] initWithArray:cacehedData];
            [self createCateogryHeader];
            [self createTableScrollView];

        }
    }else{
        [self addSubview:searchLoader];
        [searchLoader startAnimating];
        
        [self fetchData];
    }
    
    return self;
}


-(void)fetchData{
    [searchHandler fetchCategoryDataWithParameters:nil withRequestCompletionhandler:^(id responseData, NSError *error) {
        if(responseData){
//            if (theIndicator) {
//                [theIndicator stopAnimating];
//                [theIndicator removeFromSuperview];
//                theIndicator = nil;
//            }
            
            
            
            //            if (self.finalCategoryDictionary) {
            //                self.finalCategoryDictionary = nil;
            //            }
            //            self.finalCategoryDictionary = [[NSMutableDictionary alloc] initWithDictionary:responseData];
            if (self.finalCategoryArray) {
                self.finalCategoryArray = nil;
            }
            self.finalCategoryArray = [[NSMutableArray alloc] initWithArray:responseData];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [searchLoader stopAnimating];
                [searchLoader removeFromSuperview];
                [self createCateogryHeader];
                [self createTableScrollView];
            });
           
        }else{
        }
    }];
}

-(void)createHeaderViews{
    if (browseByCategoryContainer) {
        [browseByCategoryContainer removeFromSuperview];
        browseByCategoryContainer = nil;
    }
    
    browseByCategoryContainer = [[UIView alloc] initWithFrame:CGRectMake(0,0, self.frame.size.width, 40)];
    [browseByCategoryContainer setBackgroundColor:UIColorFromRGB(0xD4D4D4)];
    
    UIFont *headerFont = [UIFont fontWithName:kMontserrat_Light size:14.0f];
    CGSize headerTitleSize = [SSUtility getLabelDynamicSize:@"Browse By Category" withFont:headerFont withSize:CGSizeMake(MAXFLOAT, 40)];
    
    
    browseByCategoryTitle = [[UILabel alloc] initWithFrame:CGRectMake(browseByCategoryContainer.frame.size.width/2 - ceilf(headerTitleSize.width/2)+10, browseByCategoryContainer.frame.size.height/2 - ceilf(headerTitleSize.height/2), ceilf(headerTitleSize.width),ceilf(headerTitleSize.height))];
    [browseByCategoryTitle setText:@"Browse By Category"];
    [browseByCategoryTitle setFont:headerFont];
    [browseByCategoryTitle setTextColor:UIColorFromRGB(0x909090)];
    [browseByCategoryContainer addSubview:browseByCategoryTitle];
    
    browseByCategoryImageView = [[UIImageView alloc] initWithFrame:CGRectMake(browseByCategoryTitle.frame.origin.x - 20, browseByCategoryTitle.frame.origin.y+4, 13, 10)];
    [browseByCategoryImageView setImage:[UIImage imageNamed:@"browse_icon"]];
    
    [browseByCategoryContainer addSubview:browseByCategoryImageView];
    
    
    [self addSubview:browseByCategoryContainer];
    
    
}

-(void)createCateogryHeader{
    
    NSMutableArray *catArray = [[NSMutableArray alloc] initWithCapacity:[self.finalCategoryArray count]];

    for (int catCount = 0; catCount<[self.finalCategoryArray count]; catCount++) {
        GenderHeaderModel *theModel = [[GenderHeaderModel alloc] init];
        [theModel setTheGenderDisplayName:[[[self.finalCategoryArray objectAtIndex:catCount] allKeys] objectAtIndex:0]];
        [theModel setTheGenderValue:[[[self.finalCategoryArray objectAtIndex:catCount] allKeys] objectAtIndex:0]];
        [theModel setTheGenderImageName:[[[self.finalCategoryArray objectAtIndex:catCount] allKeys] objectAtIndex:0]];
        NSString *imageName = [[[self.finalCategoryArray objectAtIndex:catCount] allKeys] objectAtIndex:0];
        [theModel setTheGenderSelectedImageName:[NSString stringWithFormat:@"%@_selected",imageName]];
        [catArray addObject:theModel];
    }
    
    
    
    
    __weak BrowseByCategoryView *weakSelf = self;
    
    theGenderView = [[GenderHeaderView alloc] initWithFrame:CGRectMake(0, browseByCategoryContainer.frame.origin.y + browseByCategoryContainer.frame.size.height+5, self.frame.size.width, kGenderViewHeight)];

    [theGenderView setBackgroundColor:[UIColor whiteColor]];

    self.allCategoryTilesArray =  [[theGenderView configureViewWithData:catArray withSelectedObjectAtIndex:0] mutableCopy];
    
    theGenderView.onTapAction = ^(id sender){
        [weakSelf changeCategory:sender];
    };
    [self addSubview:theGenderView];
    
    [theGenderView setDefaultGenderIndex:0];

    SSLine *line = [[SSLine alloc] initWithFrame:CGRectMake(0, theGenderView.frame.origin.y +theGenderView.frame.size.height-1, theGenderView.frame.size.width, 1)];
    [self addSubview:line];
    
}

-(void)createTableScrollView{
    self.browseScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, theGenderView.frame.origin.y + theGenderView.frame.size.height+1, self.frame.size.width,self.frame.size.height -(theGenderView.frame.origin.y + theGenderView.frame.size.height))];
    [self.browseScrollView setBackgroundColor:[UIColor clearColor]];
    [self.browseScrollView setTag:987];
    [self.browseScrollView setScrollEnabled:TRUE];
    [self.browseScrollView setPagingEnabled:TRUE];
    [self.browseScrollView setShowsHorizontalScrollIndicator:FALSE];
    [self.browseScrollView setBounces:FALSE];
    [self.browseScrollView setDelegate:self];
    
    [self addSubview:self.browseScrollView];
    
    int width=5;
    
    
    for (int totalTabelCount = 0; totalTabelCount<[self.allCategoryTilesArray count]; totalTabelCount ++) {
        sectionsBoolArray = [[NSMutableArray alloc] initWithCapacity:0];
        [self.allSectionsFlagArray addObject:sectionsBoolArray];
        
        self.browseTableView = [[UITableView alloc] initWithFrame:CGRectMake(width, 0, self.frame.size.width-10, self.browseScrollView.frame.size.height-theGenderView.frame.size.height+20) style:UITableViewStylePlain];//-(theGenderView.frame.origin.y + theGenderView.frame.size.height)
        self.browseTableView.tag=totalTabelCount+100;
        
        self.browseTableView.dataSource = self;
        self.browseTableView.delegate = self;

        [self.browseTableView setBackgroundColor:[UIColor whiteColor]];
        [self.browseTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];

        [self.browseTableView setShowsVerticalScrollIndicator:FALSE];
        [self.browseScrollView addSubview:self.browseTableView];
        width+=self.frame.size.width;
        
        NSDictionary *mod = [self.finalCategoryArray objectAtIndex:totalTabelCount];
        if([[[[mod allKeys] lastObject] lowercaseString] isEqualToString:[[[self.allCategoryTilesArray objectAtIndex:totalTabelCount] headerTitle].text lowercaseString]]){
            if([[[mod allValues] objectAtIndex:0] count] <= 0){
                UIImage *image = [UIImage imageNamed:@"EmptyCategory"];
                UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, image.size.width, image.size.height)];
                imageView.image = image;
                [imageView setCenter:CGPointMake(self.browseTableView.center.x, self.browseTableView.center.y - 40)];
                [self.browseScrollView addSubview:imageView];
                
                UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(imageView.center.x - 75, imageView.frame.origin.y + imageView.frame.size.height + 10, 150, 20)];
                [label setText:@"Coming Soon!"];
                [label setTextAlignment:NSTextAlignmentCenter];
                [label setBackgroundColor:[UIColor clearColor]];
                [label setFont:[UIFont fontWithName:kMontserrat_Regular size:15.0f]];
                [label setTextColor:[UIColor lightGrayColor]];
                [self.browseScrollView addSubview:label];
                
            }
        }
        
        
    }
    
    self.browseScrollView.contentSize = CGSizeMake(self.browseScrollView.frame.size.width * self.allCategoryTilesArray.count, self.browseScrollView.frame.size.height);

}
#pragma mark UIGestureRecognzierDelegate implementation


#pragma mark - UISCrollView Delegates

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if(scrollView.isDecelerating && scrollView.tag == 987) {
        CGFloat pageWidth = self.browseScrollView.frame.size.width;
        int page = floor((self.browseScrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
        CustomViewForCategory *newCustomView = (CustomViewForCategory *)[self.allCategoryTilesArray objectAtIndex:page];
            [theGenderView updateScroller:newCustomView withAnimation:TRUE];
    }
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView
{
    if (scrollView.tag != 987) {
        scrollView.userInteractionEnabled = NO;
    }
}
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if (scrollView.tag == 987) {
        CGFloat pageWidth = self.browseScrollView.frame.size.width;
        int page = floor((self.browseScrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
        CustomViewForCategory *newCustomView = (CustomViewForCategory *)[self.allCategoryTilesArray objectAtIndex:page];
        [self changeCategory:newCustomView];
    }else{
        scrollView.userInteractionEnabled = TRUE;
    }
}
#pragma mark - Custom Methods

-(void)changeCategory:(id)sender{
    CustomViewForCategory *tappedView = (CustomViewForCategory *)sender;

    self.tappedSection = tappedView.tag - 11;
    
    CGRect frame = CGRectZero;
    frame.origin.x = self.browseScrollView.frame.size.width * (tappedView.tag-11);
    frame.origin.y = self.browseScrollView.frame.origin.y;
    frame.size = self.browseScrollView.frame.size;
    [self.browseScrollView scrollRectToVisible:frame animated:YES];
    
    
    int tagValue = (int)tappedView.tag -11+100;

    UITableView *currentTableView = (UITableView *)[self.browseScrollView viewWithTag:tagValue];
    for (int i =0; i<[[self.allSectionsFlagArray objectAtIndex:currentTableView.tag-100] count]; i++) {
        [[self.allSectionsFlagArray objectAtIndex:currentTableView.tag-100] replaceObjectAtIndex:i withObject:[NSNumber numberWithBool:FALSE]];
    }
    
    [currentTableView reloadData];
}

#pragma mark - TableView Delegate
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 44.0f;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    NSString *selectedTile = [((CustomViewForCategory *)[self.allCategoryTilesArray objectAtIndex:self.tappedSection]).headerTitle.text capitalizedString];
//    int totalSections = (int)[[self.finalCategoryDictionary valueForKey:selectedTile] count];
    int totalSections = (int)[[[self.finalCategoryArray objectAtIndex:self.tappedSection] valueForKey:selectedTile] count];
    
    while (totalSections < [[self.allSectionsFlagArray objectAtIndex:tableView.tag-100] count])
    {
        [[self.allSectionsFlagArray objectAtIndex:tableView.tag-100] removeLastObject];
    }
    
    while (totalSections > [[self.allSectionsFlagArray objectAtIndex:tableView.tag-100] count])
    {
        [[self.allSectionsFlagArray objectAtIndex:tableView.tag-100] addObject:@NO];
    }
    
    return totalSections;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    
    if ([[[self.allSectionsFlagArray objectAtIndex:tableView.tag-100] objectAtIndex:section] boolValue]) {
        NSString *selectedTile = [((CustomViewForCategory *)[self.allCategoryTilesArray objectAtIndex:self.tappedSection]).headerTitle.text capitalizedString];
        CategoryModel *theModel = (CategoryModel *)[(NSArray *)[[self.finalCategoryArray objectAtIndex:self.tappedSection] valueForKey:selectedTile] objectAtIndex:section];
        
        return [theModel.childArray count];
        
    }
    return 0;
    
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    theHeader = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 44.0f)];
    [theHeader setBackgroundColor:[UIColor whiteColor]];
    NSString *selectedTile = [((CustomViewForCategory *)[self.allCategoryTilesArray objectAtIndex:_tappedSection]).headerTitle.text capitalizedString];
//    CategoryModel *theModel = (CategoryModel *)[(NSArray *)[self.finalCategoryDictionary valueForKey:selectedTile] objectAtIndex:section];
    CategoryModel *theModel = (CategoryModel *)[(NSArray *)[[self.finalCategoryArray objectAtIndex:self.tappedSection] valueForKey:selectedTile] objectAtIndex:section];
    
    
    UIButton * theHeaderView = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, theHeader.frame.size.width, theHeader.frame.size.height)];
    [theHeaderView setTitle:theModel.theCategoryName forState:UIControlStateNormal];
    [theHeaderView setTitleColor:UIColorFromRGB(kDarkPurpleColor) forState:UIControlStateNormal];
    [theHeaderView setTag:section];
    theHeaderView.titleLabel.textAlignment = NSTextAlignmentCenter;
    [theHeaderView setBackgroundImage:[SSUtility imageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
    [theHeaderView setBackgroundImage:[SSUtility imageWithColor:UIColorFromRGB(kBackgroundGreyColor)] forState:UIControlStateHighlighted];
    [theHeaderView.titleLabel setFont:[UIFont fontWithName:kMontserrat_Regular size:14.0f]];
    [theHeaderView addTarget:self action:@selector(headerTapped:) forControlEvents:UIControlEventTouchUpInside];
    [theHeader addSubview:theHeaderView];
    theHeader.clipsToBounds = NO;
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(10, theHeader.frame.size.height -0.5, theHeader.frame.size.width-20,0.5)];
//    lineView.tag = section+555;
    lineView.backgroundColor = UIColorFromRGB(kBackgroundGreyColor);
    [theHeader addSubview:lineView];
    
    return theHeader;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
//    UIView *lineView;
    NSString *selectedTile = [((CustomViewForCategory *)[self.allCategoryTilesArray objectAtIndex:_tappedSection]).headerTitle.text capitalizedString];
//    CategoryModel *theModel = (CategoryModel *)[(NSArray *)[self.finalCategoryDictionary valueForKey:selectedTile] objectAtIndex:indexPath.section];
    CategoryModel *theModel = (CategoryModel *)[(NSArray *)[[self.finalCategoryArray objectAtIndex:self.tappedSection] valueForKey:selectedTile] objectAtIndex:indexPath.section];
    if(cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@",[[theModel.childArray objectAtIndex:indexPath.row] theCategoryName]];

    [cell.textLabel setTextColor:UIColorFromRGB(kTurquoiseColor)];
    [cell.textLabel setFont:[UIFont fontWithName:kMontserrat_Light size:14.0f]];
    [cell.textLabel setFrame:CGRectMake(50, 0, 100, 30)];
    [cell.textLabel setTextAlignment:NSTextAlignmentCenter];

//    if ([theModel.childArray count] == indexPath.row+1) {
//        if (lineView == nil) {
//            lineView = [[UIView alloc] initWithFrame:CGRectMake(10, cell.frame.size.height -0.5, cell.frame.size.width-20,0.5)];
//            lineView.backgroundColor = UIColorFromRGB(kRedColor);
//            [cell.contentView addSubview:lineView];
//        }
//    }else{
//        
//    }
    
    UIView *bgColorView = [[UIView alloc] init];
    bgColorView.backgroundColor = UIColorFromRGB(kBackgroundGreyColor);
    [cell setSelectedBackgroundView:bgColorView];
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    //Open the Category Page.
    
    NSString *selectedTile=[((CustomViewForCategory *)[self.allCategoryTilesArray objectAtIndex:_tappedSection]).headerTitle.text capitalizedString];
    CategoryModel *theModel = (CategoryModel *)[(NSArray *)[[self.finalCategoryArray objectAtIndex:self.tappedSection] valueForKey:selectedTile] objectAtIndex:indexPath.section];
    
    CategoryModel *theFinalModel = (CategoryModel *)[theModel.childArray objectAtIndex:indexPath.row];
    
    
    NSString *theURLToPass = theFinalModel.theCategoryURL;
    
    if (self.theTapOnCategory) {
        self.theTapOnCategory(theURLToPass,theFinalModel.theCategoryName, theModel.theCategoryName, selectedTile);
    }
    
}

-(void)headerTapped:(id)sender{
    tappedButton = (UIButton *)sender;
    int section = (int)tappedButton.tag;
    
    
    NSInteger tableViewIndex = [tappedButton.superview.superview  tag];
    UITableView *tblView = (UITableView *)[self.browseScrollView viewWithTag:tableViewIndex];
    

    if (section >= 0)
    {
        [self toggleSection:section forTableView:tblView];
    }
}

- (void)toggleSection:(NSUInteger)sectionIndex forTableView:(UITableView *)tableView
{
    NSArray *localBoolArray = [self.allSectionsFlagArray objectAtIndex:tableView.tag-100];
    
    if (sectionIndex >= [localBoolArray count])
    {
        return;
    }
    
    BOOL sectionIsOpen = [[localBoolArray objectAtIndex:sectionIndex] boolValue];
    
    if (sectionIsOpen)
    {
        [self collapseSectionWithIndex:sectionIndex forTableView:tableView];
    }
    else
    {
        [self expandSectionWithIndex:sectionIndex forTableView:tableView];
    }
}

- (void)expandSectionWithIndex:(NSUInteger)sectionIndex forTableView:(UITableView *)tableView
{
        int tableIndex = (int)tableView.tag -100;


    if (sectionIndex >= [[self.allSectionsFlagArray objectAtIndex:tableIndex] count]) return;
    
    if ([[[self.allSectionsFlagArray objectAtIndex:tableIndex] objectAtIndex:sectionIndex] boolValue]){
        return;
    }
    

    NSUInteger openedSection = [self openedSectionForIndex:tableIndex];
    
    [self setSectionAtIndex:sectionIndex open:YES forTableIndex:tableIndex];
    [self setSectionAtIndex:openedSection open:NO forTableIndex:tableIndex];
    
    NSArray* indexPathsToInsert = [self indexPathsForRowsInSectionAtIndex:sectionIndex forTableView:tableView];
    NSArray* indexPathsToDelete = [self indexPathsForRowsInSectionAtIndex:openedSection forTableView:tableView];
    
    UITableViewRowAnimation insertAnimation;
    UITableViewRowAnimation deleteAnimation;
    
    if (openedSection == NSNotFound || sectionIndex < openedSection)
    {
        insertAnimation = UITableViewRowAnimationTop;
        deleteAnimation = UITableViewRowAnimationBottom;
    }
    else
    {
        insertAnimation = UITableViewRowAnimationBottom;
        deleteAnimation = UITableViewRowAnimationTop;
    }
    
    [tableView beginUpdates];
    [tableView insertRowsAtIndexPaths:indexPathsToInsert withRowAnimation:insertAnimation];
    [tableView deleteRowsAtIndexPaths:indexPathsToDelete withRowAnimation:deleteAnimation];
    [tableView endUpdates];
    
}

- (void)collapseSectionWithIndex:(NSUInteger)sectionIndex forTableView:(UITableView *)tableView
{
    int tableIndex = (int)tableView.tag -100;
    [self setSectionAtIndex:sectionIndex open:NO forTableIndex:tableIndex];
    
    NSArray* indexPathsToDelete = [self indexPathsForRowsInSectionAtIndex:sectionIndex forTableView:tableView];
    [tableView deleteRowsAtIndexPaths:indexPathsToDelete withRowAnimation:UITableViewRowAnimationTop];
}

- (NSUInteger)openedSectionForIndex:(int)indexofTable
{
    for (NSUInteger index = 0 ; index < [[self.allSectionsFlagArray objectAtIndex:indexofTable] count] ; index++)
    {
        if ([[[self.allSectionsFlagArray objectAtIndex:indexofTable] objectAtIndex:index] boolValue])
        {
            return index;
        }
    }
    
    return NSNotFound;
}

- (void)setSectionAtIndex:(NSUInteger)sectionIndex open:(BOOL)open forTableIndex:(int)tableIndex
{
    
    if (sectionIndex >= [[self.allSectionsFlagArray objectAtIndex:tableIndex] count])
    {
        return;
    }
    
    [[self.allSectionsFlagArray objectAtIndex:tableIndex] replaceObjectAtIndex:sectionIndex withObject:@(open)];
}

- (NSArray*)indexPathsForRowsInSectionAtIndex:(NSUInteger)sectionIndex forTableView:(UITableView *)tableView
{
    int tableIndex = (int)tableView.tag -100;
    if (sectionIndex >= [[self.allSectionsFlagArray objectAtIndex:tableIndex] count])
    {
        return nil;
    }
    // from tableView delegates.. easy but need to check
//    NSInteger NEEDTOCHECK_numberOfRows =[self tableView:tableView numberOfRowsInSection:sectionIndex];
    
    
    //From Source - Reliable
    NSString *categoryName = [[[[self.allCategoryTilesArray objectAtIndex:tableView.tag -100] headerTitle] text] capitalizedString];
//    CategoryModel *theCategoryModel = (CategoryModel *)[[self.finalCategoryDictionary valueForKey:categoryName] objectAtIndex:sectionIndex];
    CategoryModel *theCategoryModel = (CategoryModel *)[[[self.finalCategoryArray objectAtIndex:self.tappedSection] valueForKey:categoryName] objectAtIndex:sectionIndex];
    int numberOfRows = (int)[theCategoryModel.childArray count];
    
    
    NSMutableArray* array = [[NSMutableArray alloc] init];
    
    for (int i = 0 ; i < numberOfRows ; i++)
    {
        [array addObject:[NSIndexPath indexPathForRow:i inSection:sectionIndex]];
    }
    
    return array;
}



@end
