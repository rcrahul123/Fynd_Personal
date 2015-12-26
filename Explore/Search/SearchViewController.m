//
//  SearchViewController.m
//  Explore
//
//  Created by Amboj Goyal on 7/21/15.
//  Copyright (c) 2015 Rahul. All rights reserved.
//

#import "SearchViewController.h"
#import "SearchRequestHandler.h"
@interface SearchViewController (){
    UIView *theHeaderView;
    UIButton *searchIconImage;
    UIButton *searchPlaceholder;
    UIButton *dismissButton;
    BrowseByCategoryView *theBrowseByCategory;
    UIView *blankView;
    SearchRequestHandler *searchHandler;
    PDPViewController *pdpViewController;
    UIView *autoSuggestionView;
    UITapGestureRecognizer *tapViewGesture;
    CGFloat keyBoardHeight;
    UIActivityIndicatorView *theSearchIndicator;
    UILabel *noResultsLabel;
}

@end

@implementation SearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];

//    [self.view setBackgroundColor:[UIColor colorWithRed:230.0/255.0 green:230.0/255.0 blue:230.0/255.0 alpha:1.0]];
    [self.view setBackgroundColor:[UIColor whiteColor]];

    // Do any additional setup after loading the view.

    [self.navigationController.navigationBar setFont:[UIFont fontWithName:kMontserrat_Regular size:16.0f] withColor:UIColorFromRGB(kDarkPurpleColor)];    
    //Adding the header view
    [self createHeaderView];
//    [self createBottomBlankView];
    
    [self addSearchBar];

    if (!isSearching) {
        [self addCategoryView];
    }else{
        if (_searchString != nil) {
            [self enableSearch:nil];
        }
        
    }
    
     urlString = [[NSMutableString alloc] initWithString:kAPI_Inventory];
    [urlString appendString:@"autocomplete/?"];
    baseHandler = [[SSBaseRequestHandler alloc] init];
    

}

- (void)keyboardWillShow:(NSNotification *)notification {
    keyBoardHeight = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
}

-(void)keyboardWillHide:(NSNotification *)notification {
    [self cancelSearch];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    [theHeaderView removeFromSuperview];
    theHeaderView = nil;
    
    [blankView removeFromSuperview];
    blankView = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillChangeFrameNotification object:nil];
    [self cancelSearch];
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:NO];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillChangeFrameNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];


    
//    [[FyndAnalytics sharedMySingleton] sendMixPanelPageTracking:@"Search Screen" withProperties:nil];
}
-(void)createBottomBlankView{
    if (blankView) {
        [blankView removeFromSuperview];
        blankView = nil;
    }
    
    blankView = [[UIView alloc] initWithFrame:CGRectMake(0, [[UIScreen mainScreen] bounds].size.height - 49, [[UIScreen mainScreen] bounds].size.height, 49)];
    [blankView setBackgroundColor:[UIColor whiteColor]];
    
    [[[UIApplication sharedApplication] keyWindow] addSubview:blankView];

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)createHeaderView{
    
    if (!theHeaderView) {

    theHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 20, DeviceWidth, 44)];
//    [theHeaderView setBackgroundColor:[UIColor colorWithRed:231.0/255.0 green:231.0/255.0 blue:231.0/255.0 alpha:1.0]];
        [theHeaderView setBackgroundColor:[UIColor clearColor]];

    
    
    //Adding the Icon for Search.
        
    magnifierImage = [UIImage imageNamed:@"SearchBrowse"];
    
//    //Adding the dismiss Button
//    dismissButton = [[UIButton alloc] initWithFrame:CGRectMake(theHeaderView.frame.size.width - 42, theHeaderView.frame.size.height/2 - 14,32,32)];
//    [dismissButton setBackgroundImage:[UIImage imageNamed:@"CrossGrey"] forState:UIControlStateNormal];
//    [dismissButton addTarget:self action:@selector(dismissSearch) forControlEvents:UIControlEventTouchUpInside];
//    [theHeaderView addSubview:dismissButton];
    }
    [self.view addSubview:theHeaderView];
    
    SSLine *line = [[SSLine alloc] initWithFrame:CGRectMake(0, theHeaderView.frame.size.height - 1, theHeaderView.frame.size.width, 1)];
    [line setBackgroundColor:UIColorFromRGB(kSignUpColor)];
    [theHeaderView addSubview:line];
}

-(void)addCategoryView{
    __weak SearchViewController *weakSelf = self;
    theBrowseByCategory = [[BrowseByCategoryView alloc] initWithFrame:CGRectMake(0, theHeaderView.frame.origin.y + theHeaderView.frame.size.height, theHeaderView.frame.size.width, self.view.frame.size.height - theHeaderView.frame.size.height+5) dataDictionary:nil];
    
    
    theBrowseByCategory.theTapOnCategory = ^(NSString *theURLString, NSString *theCategoryName, NSString *theParentCategoryName, NSString *gender){
        [weakSelf dismissViewControllerAnimated:FALSE completion:^{
            if (weakSelf.thePushBlock) {
                weakSelf.thePushBlock(@"category",theURLString,theCategoryName, theParentCategoryName, gender,nil);
            }
        }];
    };
    
    [self.view addSubview:theBrowseByCategory];
    
}

-(void)dismissSearch{
    [self dismissViewControllerAnimated:TRUE completion:nil];
    if (theHeaderView) {
        [theHeaderView removeFromSuperview];
        theHeaderView = nil;
    }

    if (blankView) {
        [blankView removeFromSuperview];
        blankView = nil;
    }
    if (autoSuggestionView) {
        [autoSuggestionView removeFromSuperview];
        autoSuggestionView = nil;
    }
    [[NSUserDefaults standardUserDefaults] setObject:[NSKeyedArchiver archivedDataWithRootObject:previousSearchArray] forKey:kPreviousSearchKey];
}

-(void)addSearchBar{
    

    
    //SEARCHBAR
    searchBarContainerView = [[UIView alloc] initWithFrame:CGRectMake(0, 20, DeviceWidth, 44)];
    [searchBarContainerView setBackgroundColor:[UIColor clearColor]];

    
    //Adding the dismiss Button
    dismissButton = [[UIButton alloc] initWithFrame:CGRectMake(searchBarContainerView.frame.size.width - 42, searchBarContainerView.frame.size.height/2 - 14,32,32)];
    [dismissButton setBackgroundImage:[UIImage imageNamed:@"CrossGrey"] forState:UIControlStateNormal];
    [dismissButton addTarget:self action:@selector(dismissSearch) forControlEvents:UIControlEventTouchUpInside];
    [searchBarContainerView addSubview:dismissButton];
    
    
    [searchBarContainerView setAlpha:1.0];
    _theSearchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, searchBarContainerView.frame.size.width - 40, 44)];
    [_theSearchBar setPlaceholder:@"Search"];
    
    _theSearchBar.delegate = self;
    [_theSearchBar setUserInteractionEnabled:YES];
    [_theSearchBar setBackgroundColor:[UIColor clearColor]];
    [_theSearchBar setTintColor:UIColorFromRGB(kButtonPurpleColor)];
    [searchBarContainerView addSubview:_theSearchBar];
    [self.view addSubview:searchBarContainerView];
    
    
    for ( UIView * subview in [[[_theSearchBar subviews] firstObject] subviews])
    {
        if ([subview isKindOfClass:NSClassFromString(@"UISearchBarBackground") ] ){
            subview.alpha = 0.0;
        }
        if ([subview isKindOfClass:NSClassFromString(@"UISegmentedControl") ] ){
            subview.alpha = 0.0;
        }
        if ([subview isKindOfClass:NSClassFromString(@"UISearchBarTextField") ] ){
            UITextField *textField = (UITextField *)subview;
            [textField setFont:[UIFont fontWithName:kMontserrat_Light size:14.0]];
            //            UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 25, 25)];
            //            [imgView setImage:magnifierImage];
            //            textField.leftView = imgView;
            [textField setBackgroundColor:UIColorFromRGB(0xE8E8E8)];
            
            
            // get the font attribute
            NSDictionary *attr = textField.defaultTextAttributes;
            // define a max size
            CGSize maxSize = CGSizeMake(textField.superview.bounds.size.width - 60, 40);
            // get the size of the text
            CGFloat widthText = [@"Search" boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attr context:nil].size.width;
            
            // get the size of one space
            CGFloat widthSpace = [@" " boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attr context:nil].size.width;
            
            int spaces = floor((maxSize.width - widthText) / widthSpace);
            
            // add the spaces
            NSMutableString *newText = [[NSMutableString alloc] initWithString:@"Search  "];
            for(int i = 0 ; i < spaces; i ++){
                [newText appendString:@" "];
            }
            textField.placeholder = newText;
        }
        if([subview isKindOfClass:[UIButton class]]){
            UIButton *btn = (UIButton *)subview;
            [btn setAttributedTitle:[[NSAttributedString alloc] initWithString:@"Cancel" attributes:@{NSFontAttributeName : [UIFont fontWithName:kMontserrat_Light size:14]}] forState:UIControlStateNormal];
        }
    }
}



-(void)enableSearch:(id)sender{
    
    //Populating the
    NSData *data = [[NSUserDefaults standardUserDefaults] valueForKey:kPreviousSearchKey];
    NSArray *previousArray = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    if (previousArray != nil) {
        previousSearchArray = [previousArray mutableCopy];
    }
    
    autoSuggestionView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, DeviceWidth, kDeviceHeight)];
    [autoSuggestionView setBackgroundColor:[UIColor clearColor]];
    [[[UIApplication sharedApplication]keyWindow] addSubview:autoSuggestionView];

    
    //TABLEVIEW
//    UIView *tableViewContainerView = [[UIView alloc] initWithFrame:CGRectMake(0, searchBarContainerView.frame.origin.y + searchBarContainerView.frame.size.height, DeviceWidth, autoSuggestionView.frame.size.height - searchBarContainerView.frame.size.height)];
    UIView *tableViewContainerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DeviceWidth, autoSuggestionView.frame.size.height - searchBarContainerView.frame.size.height)];

//    [tableViewContainerView setBackgroundColor:UIColorFromRGB(kSignUpColor)];
    [tableViewContainerView setBackgroundColor:[UIColor whiteColor]];
//    [tableViewContainerView setAlpha:0.9];
    
//    _theSearchTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, DeviceWidth, self.view.frame.size.height - _theSearchBar.frame.size.height - keyBoardHeight-10) style:UITableViewStylePlain];
    _theSearchTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, DeviceWidth, self.view.frame.size.height - _theSearchBar.frame.size.height - keyBoardHeight-10) style:UITableViewStylePlain];
    [_theSearchTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [_theSearchTableView setBackgroundColor:[UIColor clearColor]];
    _theSearchTableView.delegate = self;
    _theSearchTableView.dataSource = self;
    [_theSearchTableView setUserInteractionEnabled:TRUE];
    [tableViewContainerView addSubview:_theSearchTableView];
    [autoSuggestionView addSubview:tableViewContainerView];

    theSearchIndicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(autoSuggestionView.frame.size.width/2-12, 50, 24, 24)];
    theSearchIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    theSearchIndicator.hidesWhenStopped = TRUE;
    [autoSuggestionView addSubview:theSearchIndicator];
    
    [autoSuggestionView bringSubviewToFront:theSearchIndicator];
    
    
    noResultsLabel = [[UILabel alloc] initWithFrame:CGRectMake(autoSuggestionView.frame.size.width/2 - 150, 5, autoSuggestionView.frame.size.width-(autoSuggestionView.frame.size.width/2 - 140), 50)];
    [noResultsLabel setText:@"No results found"];
    [noResultsLabel setFont:[UIFont fontWithName:kMontserrat_Regular size:14.0f]];
    [noResultsLabel setTextColor:UIColorFromRGB(kGenderSelectorTintColor)];
    [noResultsLabel setHidden:TRUE];
    [noResultsLabel setTextAlignment:NSTextAlignmentLeft];
    [noResultsLabel setBackgroundColor:[UIColor clearColor]];
    [autoSuggestionView addSubview:noResultsLabel];


}
//-(void)handleClear{
//    _theSearchBar.text = @"";
//    [autoSuggestArray removeAllObjects];
//    isSearching = FALSE;
//    [_theSearchTableView reloadData];
//}

-(void)dismissSearchView:(UITapGestureRecognizer *)sender{
    
    [autoSuggestionView removeFromSuperview];
    autoSuggestionView = nil;
}


//- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
//    if ([touch.view isKindOfClass:[UIButton class]]) {
//        UISearchBar *searchbarView  = self.theSearchBar;
//        CGPoint clearTouchPoint = [touch locationInView:searchbarView];
//        if (CGRectContainsPoint(searchbarView.frame, clearTouchPoint)) {
//            [self handleClear];
//        }
//        return ![searchbarView hitTest:clearTouchPoint withEvent:nil];
//    }else if([touch.view isKindOfClass:[UITableView class]]) {
//        UITableView *searchbarView  = self.theSearchTableView;
//        CGPoint touchPoint = [touch locationInView:searchbarView];
//        return ![searchbarView hitTest:touchPoint withEvent:nil];
//    }
//    
//    else{
//        UITableView *tableView = self.theSearchTableView;
//        CGPoint touchPoint = [touch locationInView:tableView];
//        return ![tableView hitTest:touchPoint withEvent:nil];
//    }
//
//}

-(void)cancelSearch{
    [self searchBarCancelButtonClicked:_theSearchBar];
}

#pragma mark - UISeasrchBar Delegates
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    if ([searchBar.text isEqualToString:@""]) {
        [autoSuggestArray removeAllObjects];
        isSearching = FALSE;
        [self.theSearchTableView reloadData];
        [noResultsLabel setText:@"No results found"];        
        [noResultsLabel setHidden:TRUE];
    }
}
-(void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{

    NSAttributedString *cancelString = [[NSAttributedString alloc] initWithString:@"Cancel" attributes:@{NSFontAttributeName :[UIFont fontWithName:kMontserrat_Light size:14], NSForegroundColorAttributeName : UIColorFromRGB(kDarkPurpleColor)}];
    NSAttributedString *cancelTapString = [[NSAttributedString alloc] initWithString:@"Cancel" attributes:@{NSFontAttributeName :[UIFont fontWithName:kMontserrat_Light size:14], NSForegroundColorAttributeName : UIColorFromRGB(kSignUpColor)}];

    cancelButtton = [[UIButton alloc] initWithFrame:CGRectMake(searchBarContainerView.frame.size.width, 0, 60, 44)];
    [cancelButtton setBackgroundColor:[UIColor clearColor]];
    [cancelButtton setAttributedTitle:cancelString forState:UIControlStateNormal];
    [cancelButtton setAttributedTitle:cancelTapString forState:UIControlStateHighlighted];
//    [cancelButtton setTitleColor:UIColorFromRGB(kDarkPurpleColor) forState:UIControlStateNormal];
//    [cancelButtton setTitleColor:UIColorFromRGB(kSignUpColor) forState:UIControlStateHighlighted];
    [cancelButtton addTarget:self action:@selector(cancelSearch) forControlEvents:UIControlEventTouchUpInside];
    [searchBarContainerView addSubview:cancelButtton];
    
    [UIView animateWithDuration:0.2 animations:^{
        [_theSearchBar setFrame:CGRectMake(0, 0, searchBarContainerView.frame.size.width - 70, 44)];
        [cancelButtton setFrame:CGRectMake(_theSearchBar.frame.origin.x + _theSearchBar.frame.size.width + 5, cancelButtton.frame.origin.y, cancelButtton.frame.size.width, cancelButtton.frame.size.height)];
    }];
    [dismissButton setHidden:YES];
    [self enableSearch:nil];
}

-(BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar{
    return YES;
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    
    [dismissButton setHidden:false];
    dismissButton.alpha = 0.0;
    [UIView animateWithDuration:0.2 animations:^{
        [_theSearchBar setFrame:CGRectMake(0, 0, searchBarContainerView.frame.size.width - 40, 44)];
        [cancelButtton setFrame:CGRectMake(searchBarContainerView.frame.size.width, cancelButtton.frame.origin.y, cancelButtton.frame.size.width, cancelButtton.frame.size.height)];
        dismissButton.alpha = 1.0;
    }];
    
    searchBar.text = @"";
    [searchBar resignFirstResponder];
//    [searchBar setShowsCancelButton:NO animated:YES];
    [autoSuggestArray removeAllObjects];
    isSearching = FALSE;
    [self dismissSearchView:nil];
}

-(BOOL)searchBar:(UISearchBar *)searchBar shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    [searchDataTask cancel];
//    [autoSuggestArray removeAllObjects];

//    [timer invalidate];
    
    NSString *str = [searchBar.text stringByReplacingCharactersInRange:range withString:text];
    if(str.length > 0){
        isSearching = TRUE;
        
        if (searchHandler) {
            searchHandler = nil;
        }
        searchHandler = [[SearchRequestHandler alloc] init];
        
        searchDictionary = [[NSMutableDictionary alloc] init];
        [searchDictionary setObject:str forKey:@"q"];
        [self getData];
//        timer = [NSTimer scheduledTimerWithTimeInterval: 0.0
//                                                 target: self
//                                               selector:@selector(getData)
//                                               userInfo: nil repeats:NO];
    }else{
        dispatch_async(dispatch_get_main_queue(), ^(void){
            [autoSuggestArray removeAllObjects];
            isSearching = FALSE;
            [_theSearchTableView reloadData];
            [noResultsLabel setText:@"No results found"];
            [noResultsLabel setHidden:TRUE];
            [theSearchIndicator stopAnimating];
        });
        
    }
    return YES;
}


-(void)getData{
    [theSearchIndicator startAnimating];
    [_theSearchTableView setHidden:TRUE];
    [noResultsLabel setHidden:TRUE];
    searchDataTask = [baseHandler sendCachedHttpRequestWithURL:urlString withParameters:searchDictionary withCompletionHandler:^(id responseData, NSError *error) {
       
        if(responseData != nil){
            id json = [NSJSONSerialization JSONObjectWithData:responseData options:0 error:nil];

        if(json && [json count] > 0){
            [noResultsLabel setHidden:TRUE];
            [theSearchIndicator stopAnimating];
            [_theSearchTableView setHidden:FALSE];
            if (autoSuggestArray) {
                [autoSuggestArray removeAllObjects];
            }
            autoSuggestArray = [NSMutableArray arrayWithArray:(NSArray *)[self parseSearchData:json]];
            dispatch_async(dispatch_get_main_queue(), ^(void){
                [_theSearchTableView reloadData];
            });
        }else{
            //No Data to Display hence show no result found.
            [[NSRunLoop mainRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.01]];
            [theSearchIndicator stopAnimating];
            [noResultsLabel setText:[NSString stringWithFormat:@"No results found for \"%@\" ",[searchDictionary valueForKey:@"q"]]];
            CGSize textSize = [SSUtility getLabelDynamicSize:noResultsLabel.text withFont:[UIFont fontWithName:kMontserrat_Regular size:14.0f ] withSize:CGSizeMake(MAXFLOAT, 50)];
            
            float origin_x = autoSuggestionView.frame.size.width/2 - textSize.width/2;
            if (origin_x<10.0) {
                origin_x = 10.0f;
            }
            float width = autoSuggestionView.frame.size.width-(autoSuggestionView.frame.size.width/2 - textSize.width/2);
            if (width> autoSuggestionView.frame.size.width-20) {
                width = autoSuggestionView.frame.size.width-25;
            }
            
            [noResultsLabel setFrame:CGRectMake(origin_x, 5,width, 50)];
            dispatch_async(dispatch_get_main_queue(), ^(void){
                [autoSuggestArray removeAllObjects];
                [_theSearchTableView reloadData];
                [noResultsLabel setHidden:FALSE];
            });
        }
    }else{
            //No Data to Display hence show no result found.
//        [[NSRunLoop mainRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.01]];
//        [theSearchIndicator stopAnimating];
//        
//        if ([searchDictionary valueForKey:@"q"]) {
//            NSString *textForSearch = [searchDictionary valueForKey:@"q"];
//            if (textForSearch.length>0) {
//                [noResultsLabel setText:[NSString stringWithFormat:@"No results found for \" %@ \" ",[searchDictionary valueForKey:@"q"]]];
//                CGSize textSize = [SSUtility getLabelDynamicSize:noResultsLabel.text withFont:[UIFont fontWithName:kMontserrat_Regular size:14.0f ] withSize:CGSizeMake(MAXFLOAT, 50)];
//                
//                [noResultsLabel setFrame:CGRectMake(autoSuggestionView.frame.size.width/2 - textSize.width/2, 60, autoSuggestionView.frame.size.width-(autoSuggestionView.frame.size.width/2 - textSize.width/2), 50)];
//                [noResultsLabel setHidden:FALSE];
//            }else{
//                [noResultsLabel setText:@"No results found"];
//                [noResultsLabel setHidden:TRUE];
//            }
//        }
            dispatch_async(dispatch_get_main_queue(), ^(void){
                [autoSuggestArray removeAllObjects];
                [_theSearchTableView reloadData];
            });
        }
    }];
    [searchDataTask resume];
}



-(NSArray *)parseSearchData:(NSArray *)data{
    NSMutableArray * suggestedArray = [[NSMutableArray alloc] initWithCapacity:0];
    NSInteger count = [data count];
    if (count>0) {
        
        for(int i = 0; i < count; i++){
            AutoSuggestModel *model = [[AutoSuggestModel alloc] initWithDictionary:[data objectAtIndex:i]];
            
            [suggestedArray addObject:model];
        }
    }
    return suggestedArray;
}


- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    
    AutoSuggestModel *freeTextModel = [[AutoSuggestModel alloc] init];
    freeTextModel.itemType = @"FREETEXT";
    NSMutableString *urlSearchString = [[NSMutableString alloc] initWithString:kAPI_Inventory];
    [urlSearchString appendString:[NSString stringWithFormat:@"browse-by-category/?q=%@&items=true&filters=true&headers=true",[SSUtility handleEncoding:searchBar.text]]];
//    urlString = (NSMutableString *)[SSUtility handleEncoding:urlString];
    freeTextModel.itemURL = urlSearchString;
    freeTextModel.itemValue = searchBar.text;
    freeTextModel.displayName = searchBar.text;
    
    if (previousSearchArray == nil) {
        previousSearchArray = [[NSMutableArray alloc] init];
    }
    [previousSearchArray addObject:freeTextModel];
    
    previousSearchArray = [self getUniqueListForSuggestion:previousSearchArray];
    
    NSArray * tempPreviousSearchArray = [[previousSearchArray reverseObjectEnumerator] allObjects];
    [previousSearchArray removeAllObjects];
    previousSearchArray = (NSMutableArray *)tempPreviousSearchArray;
    
    [[NSUserDefaults standardUserDefaults] setObject:[NSKeyedArchiver archivedDataWithRootObject:tempPreviousSearchArray] forKey:kPreviousSearchKey];
    _searchString = _searchTextField.text;
    
    
    [self dismissSearchView:nil];
    
    [self dismissViewControllerAnimated:FALSE completion:^{
        if (self.thePushBlock) {
            self.thePushBlock(freeTextModel.itemType,freeTextModel.itemURL,freeTextModel.itemValue, nil, nil, freeTextModel);
        }
    }];
    
}

#pragma mark - UITableViewDelegates

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (isSearching) {
        return nil;
    }else{
        tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 40.0f)];
        [tableHeaderView setBackgroundColor:[UIColor whiteColor]];
//        [tableHeaderView setAlpha:0.9];
//        UIImageView *searchImageHeader = nil;
//        if ([previousSearchArray count]>0) {
//            //Adding the Search Icon for Header View
//            searchImageHeader = [[UIImageView alloc] initWithFrame:CGRectMake(10, 15, 15, 15)];
//            [searchImageHeader setImage:[UIImage imageNamed:@"search"]];
//            [tableHeaderView addSubview:searchImageHeader];
//        }


//        UILabel *previousSearchLabel = [[UILabel alloc] initWithFrame:CGRectMake(searchImageHeader.frame.origin.x + searchImageHeader.frame.size.width + 10, 5, 250, 30)];
//        UILabel *previousSearchLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 5, 250, 30)];
        UILabel *previousSearchLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, tableHeaderView.frame.size.width, 30)];
        if ([previousSearchArray count]>0) {
            [previousSearchLabel setText:@"My Previous Searches"];
            [previousSearchLabel setTextAlignment:NSTextAlignmentLeft];
            [previousSearchLabel setFrame:CGRectMake(15, 5, tableHeaderView.frame.size.width, 30)];
        }else{
            [previousSearchLabel setText:@"No Previous Searches"];
            [previousSearchLabel setTextAlignment:NSTextAlignmentCenter];
            [previousSearchLabel setFrame:CGRectMake(0, 5, tableHeaderView.frame.size.width, 30)];
        }
        
        [previousSearchLabel setFont:[UIFont fontWithName:kMontserrat_Regular size:14.0f]];
//        [previousSearchLabel setTextColor:UIColorFromRGB(0x9C9C9C)];
        [previousSearchLabel setTextColor:UIColorFromRGB(kGenderSelectorTintColor)];
        [tableHeaderView addSubview:previousSearchLabel];
        
        
        return  tableHeaderView;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (isSearching) {
        return 0.0f;
    }else{
        return 40.0f;
    }
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (isSearching) {
        return [autoSuggestArray count];
    }else{
        if ([previousSearchArray count]>5) {
            return 5;
        }else
            return [previousSearchArray count];
    }
    

}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    if(cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    [cell setFrame:CGRectMake(cell.frame.origin.x,cell.frame.origin.y , DeviceWidth, cell.frame.size.height)];
    NSString *cellText = nil;
    if (isSearching) {
        cellText= [NSString stringWithFormat:@"%@", [[(AutoSuggestModel *)[autoSuggestArray objectAtIndex:indexPath.row] displayName] capitalizedString]];
    }else{
        cellText= [NSString stringWithFormat:@"%@", [[(AutoSuggestModel *)[previousSearchArray objectAtIndex:indexPath.row] displayName] capitalizedString]];
    }
    cell.textLabel.text = cellText;
    cell.textLabel.textColor = UIColorFromRGB(kDarkPurpleColor);
//    [cell.textLabel setTextColor:[UIColor whiteColor]];
    [cell.textLabel setFont:[UIFont fontWithName:kMontserrat_Light size:14.0f]];
    cell.userInteractionEnabled = TRUE;
    UIView *view = [cell viewWithTag:10];
    if(view){
        [view removeFromSuperview];
        view = nil;
        
    }
    [cell setBackgroundColor:[UIColor clearColor]];
    
    
    NSString *labelText = nil;
    if (isSearching) {
        NSString *item_Type = [(AutoSuggestModel *)[autoSuggestArray objectAtIndex:indexPath.row] itemType];
        if (item_Type != [NSNull class]) {
            labelText =[[NSString stringWithFormat:@"%@", item_Type] uppercaseString];
        }
    }else{
        NSString *item_Type = [(AutoSuggestModel *)[previousSearchArray objectAtIndex:indexPath.row] itemType];
        if (item_Type != (id)[NSNull null] && ![item_Type isEqualToString:@"FREETEXT"]) {
            labelText =[[NSString stringWithFormat:@"%@", item_Type] uppercaseString];
        }
        
    }

    CGSize cellSize = [SSUtility getLabelDynamicSize:labelText withFont:[UIFont fontWithName:kMontserrat_Regular size:10.0f] withSize:CGSizeMake(MAXFLOAT, 20)];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(cell.frame.size.width -cellSize.width-9, cell.contentView.frame.size.height/2 - 9, cellSize.width, 20)];
    label.tag = 10;

    label.textColor = UIColorFromRGB(kGenderSelectorTintColor);
    label.font = [UIFont fontWithName:kMontserrat_Regular size:10.0f];
    [label setTextAlignment:NSTextAlignmentRight];
    [label setText:labelText];
    [label setBackgroundColor:[UIColor clearColor]];
//    [cell.textLabel setFrame:CGRectMake(cell.textLabel.frame.origin.x, cell.textLabel.frame.origin.y, cell.textLabel.frame.size.width - cellSize.width -5, cell.textLabel.frame.size.height)];
//    [cell.textLabel adjustsFontSizeToFitWidth];

    [cell addSubview:label];
    
    SSLine *theBorderLine = [[SSLine alloc] initWithFrame:CGRectMake(5, cell.frame.size.height-1, cell.frame.size.width-10, 1)];
    [cell addSubview:theBorderLine];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    AutoSuggestModel *tappedModel = nil;
    if (isSearching) {
        //TODO - add the selected value in the previous Search Array
        tappedModel = (AutoSuggestModel *)[autoSuggestArray objectAtIndex:indexPath.row];
        if (previousSearchArray == nil) {
            previousSearchArray = [[NSMutableArray alloc] init];
        }
        [previousSearchArray addObject:tappedModel];

        previousSearchArray = [self getUniqueListForSuggestion:previousSearchArray];
        
        NSArray * tempPreviousSearchArray = [[previousSearchArray reverseObjectEnumerator] allObjects];
        [previousSearchArray removeAllObjects];
        previousSearchArray = (NSMutableArray *)tempPreviousSearchArray;
        
        [[NSUserDefaults standardUserDefaults] setObject:[NSKeyedArchiver archivedDataWithRootObject:tempPreviousSearchArray] forKey:kPreviousSearchKey];
        _searchString = _searchTextField.text;
        //Navigate to the detail Page.
        
        }else{
            tappedModel = (AutoSuggestModel *)[previousSearchArray objectAtIndex:indexPath.row];
        }
        [self dismissSearchView:nil];
        
        [self dismissViewControllerAnimated:FALSE completion:^{
            if (self.thePushBlock) {
                self.thePushBlock(tappedModel.itemType,tappedModel.itemURL,tappedModel.displayName, nil, nil, tappedModel);
            }
        }];

}

-(NSMutableArray *)getUniqueListForSuggestion:(NSMutableArray *)originalArray{
    NSMutableArray *uniqueArray = [NSMutableArray array];
    NSMutableSet *names = [NSMutableSet set];
    for (AutoSuggestModel* obj in originalArray) {
        NSString *destinationName = [obj itemURL];
        if (![names containsObject:destinationName]) {
            [uniqueArray addObject:obj];
            [names addObject:destinationName];
        }
    }
    return uniqueArray;
}
#pragma mark - Custom Methods

//-(void)parseSearchData:(NSArray *)data{
//    
//    NSInteger count = [data count];
//    if (autoSuggestArray) {
//        [autoSuggestArray removeAllObjects];
//    }
//    autoSuggestArray = [[NSMutableArray alloc] initWithCapacity:0];
//    for(int i = 0; i < count; i++){
//        AutoSuggestModel *model = [[AutoSuggestModel alloc] init];
//        model.displayName = [[data objectAtIndex:i] valueForKey:@"display"];
//        model.itemType = [[data objectAtIndex:i] valueForKey:@"type"];
//        model.itemValue = [[data objectAtIndex:i] valueForKey:@"value"];
//
//
//        [autoSuggestArray addObject:model];
//    }
//}

-(void)textFieldChanged:(id)sender{

    if (_searchTextField.text.length==0) {
        isSearching = FALSE;
        [_theSearchTableView reloadData];
    }else{
        isSearching = TRUE;
    }
}

@end
