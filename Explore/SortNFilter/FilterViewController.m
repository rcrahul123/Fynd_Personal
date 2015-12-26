//
//  FilterViewController.m
//  Explore
//
//  Created by Rahul Chaudhari on 26/09/15.
//  Copyright © 2015 Rahul. All rights reserved.
//

#import "FilterViewController.h"

@interface FilterViewController ()

@end

@implementation FilterViewController


-(id)initWithDataArray:(NSArray *)dataArray{
    self = [super init];
    if(self){
        
        self.title = @"Filters";
        self.navigationController.navigationBar.translucent = NO;
        self.edgesForExtendedLayout = UIRectEdgeNone;

        filterLoader = [[FyndActivityIndicator alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
        [filterLoader setCenter:CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height/2)];

        filterArray = dataArray;
        selectedIndex = 0;
        
        [self parseFilterData];

        subArray = [[filterArray objectAtIndex:0] valueForKey:@"option"];
    }
    return self;
}

//-(BOOL)prefersStatusBarHidden{
//    return YES;
//}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self getHeaderForTable];
    [self addButtons];
    
    tableContainer = [[UIView alloc] initWithFrame:CGRectMake(0, headerView.frame.origin.y + headerView.frame.size.height, self.view.frame.size.width, self.view.frame.size.height - (headerView.frame.origin.y + headerView.frame.size.height) - buttonsContainer.frame.size.height - 64)];
    [tableContainer setBackgroundColor:[UIColor whiteColor]];
    [tableContainer setAlpha:0.94];
    [self.view addSubview:tableContainer];
    
    [self addHeadersTable];
    tableSeparator = [[UIView alloc] initWithFrame:CGRectMake(headersTableView.frame.origin.x + headersTableView.frame.size.width, 0, 1, tableContainer.frame.size.height)];
    [tableSeparator setBackgroundColor:UIColorFromRGB(0xD0D0D0)];
    [tableContainer addSubview:tableSeparator];
    [self addValuesTable];
    
    [self.view bringSubviewToFront:buttonsContainer];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self.navigationController.view setBackgroundColor:[UIColor whiteColor]];
    
    [self.navigationController.navigationBar changeNavigationBarToTransparent:FALSE];
    [self.navigationController.navigationBar setFont:[UIFont fontWithName:kMontserrat_Regular size:16.0f] withColor:UIColorFromRGB(kDarkPurpleColor)];
    
    cancelButton = [[UIButton alloc] initWithFrame:CGRectMake(self.navigationController.navigationBar.frame.size.width - 40, self.navigationController.navigationBar.frame.size.height/2 - 16, 32, 32)];
    [cancelButton setBackgroundImage:[UIImage imageNamed:@"CrossGrey"] forState:UIControlStateNormal];
    [cancelButton addTarget:self action:@selector(dismissFilter) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationController.navigationBar addSubview:cancelButton];
}


-(void)updateFilterViewWithNewData:(NSArray *)newDataArray{
    self.view.userInteractionEnabled = TRUE;
    [filterLoader stopAnimating];
    [filterLoader removeFromSuperview];
    
    parsedOriginalData = nil;
    selectedIndex = 0;
    filterArray = newDataArray;
    [self parseFilterData];
    [headersTableView reloadData];
    [valuesTableView reloadData];
    
    [UIView animateWithDuration:0.2 animations:^{
    } completion:^(BOOL finished) {
        FilterModel *tempModel;
        for (int i = 0; i < [parsedFilterData count]; i++) {
            tempModel = (FilterModel *)[parsedFilterData objectAtIndex:i];
            if([tempModel.filterType isEqualToString:selectedFilterType]){
                selectedIndexPath = [NSIndexPath indexPathForRow:i inSection:0];
                [UIView animateWithDuration:0.2 animations:^{
                    [headersTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];
                    [self tableView:headersTableView didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
                }];
                break;
            }
        }
    }];
}

-(void)parseFilterData{
    
    parsedFilterData = [[NSMutableArray alloc] init];
    for(int i = 0; i < [filterArray count]; i++){
        FilterModel *filterModel = [[FilterModel alloc] initWithDictionary:[filterArray objectAtIndex:i]];
        [parsedFilterData addObject:filterModel];
    }
    
    if(!parsedOriginalData){
        parsedOriginalData = [[NSMutableArray alloc] init];
        for(int i = 0; i < [filterArray count]; i++){
            FilterModel *filterModel = [[FilterModel alloc] initWithDictionary:[filterArray objectAtIndex:i]];
            [parsedOriginalData addObject:filterModel];
        }
    }
}

-(void)addHeadersTable{
    headersTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, tableContainer.frame.size.width * 0.35, tableContainer.frame.size.height)];
    [headersTableView setBackgroundColor:[UIColor clearColor]];
    headersTableView.tag = 1;
    headersTableView.delegate = self;
    headersTableView.dataSource = self;
    headersTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    headersTableView.separatorStyle = UITableViewCellSelectionStyleNone;
    [tableContainer addSubview:headersTableView];
    selectedFilterType = [(FilterModel *)[parsedFilterData objectAtIndex:0] filterType];
}

-(void)addValuesTable{
    valuesTableView = [[UITableView alloc] initWithFrame:CGRectMake(tableSeparator.frame.origin.x + tableSeparator.frame.size.width, 0, self.view.frame.size.width - headersTableView.frame.size.width, tableContainer.frame.size.height)];
    [valuesTableView setBackgroundColor:[UIColor clearColor]];
    valuesTableView.tag = 2;
    valuesTableView.delegate = self;
    valuesTableView.dataSource = self;
    valuesTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [tableContainer addSubview:valuesTableView];
}

-(void)addButtons{
    
    buttonsContainer = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 63 - 64, self.view.frame.size.width, 63)];
    [buttonsContainer setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:buttonsContainer];
    buttonsContainer.layer.shadowColor = [UIColor blackColor].CGColor;
    buttonsContainer.layer.shadowOffset = CGSizeMake(0, 1);
    buttonsContainer.layer.shadowRadius = 2.0;
    buttonsContainer.layer.shadowOpacity = 0.3;
    
    NSAttributedString *resetAttr = [[NSAttributedString alloc] initWithString:@"CLEAR" attributes:@{NSFontAttributeName : [UIFont fontWithName:kMontserrat_Regular size:14.0], NSForegroundColorAttributeName : UIColorFromRGB(kGenderSelectorTintColor)}];
    NSAttributedString *resetAttrTouch = [[NSAttributedString alloc] initWithString:@"CLEAR" attributes:@{NSFontAttributeName : [UIFont fontWithName:kMontserrat_Regular size:14.0], NSForegroundColorAttributeName : UIColorFromRGB(kBackgroundGreyColor)}];
    
    resetButtton = [[UIButton alloc] initWithFrame:CGRectMake(10, 0, (self.view.frame.size.width) * 0.35 - 10, 50)];
    [resetButtton setAttributedTitle:resetAttr forState:UIControlStateNormal];
    [resetButtton setAttributedTitle:resetAttrTouch forState:UIControlStateHighlighted];
    
    [resetButtton addTarget:self action:@selector(resetButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    [buttonsContainer addSubview:resetButtton];
    resetButtton.layer.cornerRadius = 3.0;
    
    NSAttributedString *applyAttr = [[NSAttributedString alloc] initWithString:@"APPLY FILTERS" attributes:@{NSFontAttributeName : [UIFont fontWithName:kMontserrat_Regular size:14.0], NSForegroundColorAttributeName : [UIColor whiteColor]}];
    applyButton = [[UIButton alloc] initWithFrame:CGRectMake(resetButtton.frame.origin.x + resetButtton.frame.size.width, 10, (buttonsContainer.frame.size.width - 20) * 0.65, buttonsContainer.frame.size.height - 20)];
    [applyButton setBackgroundImage:[SSUtility imageWithColor:UIColorFromRGB(kTurquoiseColor)] forState:UIControlStateNormal];
    [applyButton setBackgroundImage:[SSUtility imageWithColor:UIColorFromRGB(kButtonTouchStateColor)] forState:UIControlStateHighlighted];
    [applyButton setAttributedTitle:applyAttr forState:UIControlStateNormal];
    [applyButton addTarget:self action:@selector(applyFilterTapped) forControlEvents:UIControlEventTouchUpInside];
    [buttonsContainer addSubview:applyButton];
    applyButton.layer.cornerRadius = 3.0;
    applyButton.clipsToBounds = YES;
    
    [applyButton setCenter:CGPointMake(applyButton.center.x, buttonsContainer.frame.size.height/2)];
    [resetButtton setCenter:CGPointMake(resetButtton.center.x, applyButton.center.y)];
}


-(void)getHeaderForTable{
    
    NSAttributedString *headerText = [[NSAttributedString alloc] initWithString:@" Filters  " attributes:@{NSFontAttributeName : [UIFont fontWithName:kMontserrat_Regular size:18.0], NSForegroundColorAttributeName : UIColorFromRGB(kDarkPurpleColor)}];
    CGRect headerLabelSize = [headerText boundingRectWithSize:CGSizeMake(self.view.frame.size.width, 25) options:NSStringDrawingTruncatesLastVisibleLine context:NULL];
    
    headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 0)];
    [headerView setBackgroundColor:UIColorFromRGB(kHeaderBackgroundColor)];
    
    UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(headerView.frame.size.width/2 - headerLabelSize.size.width/2, headerView.frame.size.height/2 - headerLabelSize.size.height/2, headerLabelSize.size.width, headerLabelSize.size.height)];
    [headerLabel setBackgroundColor:UIColorFromRGB(kHeaderBackgroundColor)];
    [headerLabel setAttributedText:headerText];
    [headerLabel setTextAlignment:NSTextAlignmentCenter];
    [headerLabel setCenter:CGPointMake(headerView.frame.size.width/2, headerView.frame.size.height/2 + 10)];
    
    UIImageView *sortIcon = [[UIImageView alloc] initWithFrame:CGRectMake(headerLabel.frame.origin.x - 30 , 0, 40, 40)];
    [sortIcon setImage:[UIImage imageNamed:@"FilterHeader"]];
    [sortIcon setCenter:CGPointMake(sortIcon.center.x, headerLabel.center.y)];
    
    UIButton *crossButton = [[UIButton alloc] initWithFrame:CGRectMake(headerView.frame.size.width - 40, headerLabel.center.y - 20, 40, 40)];
    [crossButton setCenter:CGPointMake(crossButton.center.x, headerLabel.center.y)];
    [crossButton setBackgroundImage:[UIImage imageNamed:@"Cross"] forState:UIControlStateNormal];
    [crossButton addTarget:self action:@selector(dismissFilter) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:headerView];
}


-(void)resetButtonTapped{
    
    [self.view addSubview:filterLoader];
    [filterLoader startAnimating];
    if(self.filterDelegate && [self.filterDelegate respondsToSelector:@selector(resetFilters)]){
        [self.filterDelegate resetFilters];
    }
}

-(void)applyFilterTapped{
    [self generateAppliedFiltersArray];
    if(self.filterDelegate && [self.filterDelegate respondsToSelector:@selector(refreshFiltersWith:)]){
        [self.filterDelegate refreshFiltersWith:appliedFiltersArray];
    }
    [self dismissFilter];
}

-(void)generateAppliedFiltersArray{
    appliedFiltersArray = [[NSMutableArray alloc] initWithCapacity:0];
    for(int i = 0; i < [parsedFilterData count]; i++){
        FilterModel *mod = [parsedFilterData objectAtIndex:i];
        for(int j = 0; j < [mod.filterOptions count]; j++){
            NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithCapacity:0];
            FilterOptionModel *subMod = [mod.filterOptions objectAtIndex:j];
            if(subMod.isFilterSelected){
                [dict setObject:subMod.filterValue forKey:mod.filterType];
                [appliedFiltersArray addObject:dict];
            }
        }
    }
}

-(void)dismissFilter{

    [self.navigationController dismissViewControllerAnimated:YES completion:^{
        if(self.filterDelegate && [self.filterDelegate respondsToSelector:@selector(filterDismissed)]){
            [self.filterDelegate filterDismissed];
        }
    }];
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(tableView.tag == 1){
        return RelativeSizeHeight(80, 568);
    }else{
        return RelativeSizeHeight(52, 568);
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSInteger rowCount = 0;
    if(tableView.tag == 1){
        rowCount = [parsedFilterData count];
    }else if (tableView.tag == 2){
        rowCount = [[[parsedFilterData objectAtIndex:selectedIndex] filterOptions] count];
    }
    return rowCount;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell;
    FilterHeaderTableViewCell *headerCell;
    FilterCheckboxTableViewCell *valueCell;
    
    if(tableView.tag == 1){
        headerCell = (FilterHeaderTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"HeaderCell"];
        if(headerCell == nil){
            headerCell = [[FilterHeaderTableViewCell alloc] init];
        }
        FilterModel *model = [parsedFilterData objectAtIndex:indexPath.row];
        headerCell.filterModel = model;
        if(selectedIndex == indexPath.row){
            headerCell.isCurrentCell = true;
        }else{
            headerCell.isCurrentCell = false;
        }
        [headerCell setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        return headerCell;
        
    }else if(tableView.tag == 2){
        
        valueCell = (FilterCheckboxTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"ValueCell"];
        if(valueCell == nil){
            valueCell = [[FilterCheckboxTableViewCell alloc] init];
        }
        valueCell.model = [[[parsedFilterData objectAtIndex:selectedIndex] filterOptions] objectAtIndex:indexPath.row];
        [valueCell setSelectionStyle:UITableViewCellSelectionStyleGray];
        
        if(indexPath.row == [tableView numberOfRowsInSection:0] - 1){
            valueCell.shouldShowSeparator = false;
        }else{
            valueCell.shouldShowSeparator = true;
        }
        
        return valueCell;
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(tableView.tag == 1){
        selectedFilterType = [(FilterModel *)[parsedFilterData objectAtIndex:indexPath.row] filterType];
        NSIndexPath *prevIndex = [NSIndexPath indexPathForRow:selectedIndex inSection:0];
        
        [self checkIfFilterChangedForHeader:prevIndex];
        
        selectedIndex = indexPath.row;
        [tableView reloadRowsAtIndexPaths:@[prevIndex] withRowAnimation:UITableViewRowAnimationFade];
        [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        [valuesTableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
    }else{
        FilterCheckboxTableViewCell *valueCell = (FilterCheckboxTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
        valueCell.model.isFilterSelected = !valueCell.model.isFilterSelected;
        
        FilterModel *mod = [parsedFilterData objectAtIndex:selectedIndex];
        
        mod.isAnyValueSelected = false;
        for(int i = 0; i < [mod.filterOptions count]; i++){
            FilterOptionModel *subModel = [mod.filterOptions objectAtIndex:i];
            if(subModel.isFilterSelected){
                mod.isAnyValueSelected = true;
                break;
            }
        }
        NSIndexPath *headerIndexPath = [NSIndexPath indexPathForRow:selectedIndex inSection:0];
        [headersTableView reloadRowsAtIndexPaths:@[headerIndexPath] withRowAnimation:UITableViewRowAnimationFade];
        [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 1;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return [[UIView alloc] init];
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return [[UIView alloc] init];
}



-(void)checkIfFilterChangedForHeader:(NSIndexPath *)index{
    
    BOOL shouldReload = FALSE;
    
    NSArray *originalOptions = [[parsedOriginalData objectAtIndex:index.row] filterOptions];
    NSArray *currentOptions = [[parsedFilterData objectAtIndex:index.row] filterOptions];
    
    for(int i = 0; i < [originalOptions count]; i++){
        FilterOptionModel *origObj = [originalOptions objectAtIndex:i];
        FilterOptionModel *modObj = [currentOptions objectAtIndex:i];
        
        if(origObj.isFilterSelected != modObj.isFilterSelected){
            shouldReload = TRUE;
            break;
        }
    }
    
    if(shouldReload){
        [self.view addSubview:filterLoader];
        [filterLoader startAnimating];
        
        self.view.userInteractionEnabled = false;
        [self generateAppliedFiltersArray];
        if(self.filterDelegate && [self.filterDelegate respondsToSelector:@selector(refreshFiltersWith:)]){
            [self.filterDelegate refreshFiltersWith:appliedFiltersArray];
        }
        
    }else{

    }
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
