//
//  NetBankingViewController.m
//  Explore
//
//  Created by Amboj Goyal on 12/7/15.
//  Copyright © 2015 Rahul. All rights reserved.
//

#import "NetBankingViewController.h"
#import "SSLine.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "CartViewController.h"

@interface NetBankingViewController ()
@property (nonatomic,assign) BOOL moreOptionsClicked;
@end

@implementation NetBankingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Choose A Bank";
    [self.navigationController.navigationBar changeNavigationBarToTransparent:FALSE];
    [self.view setBackgroundColor:UIColorFromRGB(kBackgroundGreyColor)];
    [self setBackButton];
    [self configureTableView];
}

-(void)configureTableView{
    
    NSArray *subArray = [self.theNetBankingData subarrayWithRange:NSMakeRange(6, [self.theNetBankingData count]-6)];
    
    self.moreOptionsData = [[NSMutableArray alloc] initWithArray:subArray];
    
    
    self.netBankingTableView = [[UITableView alloc] initWithFrame:CGRectMake(RelativeSize(6, 320), 0, self.view.frame.size.width-RelativeSize(12, 320), self.view.frame.size.height - 65) style:UITableViewStyleGrouped];
    [self.netBankingTableView setBackgroundColor:UIColorFromRGB(kBackgroundGreyColor)];

    self.netBankingTableView.alwaysBounceVertical = TRUE;
    self.netBankingTableView.dataSource = self;
    self.netBankingTableView.delegate = self;

    [self.netBankingTableView setShowsVerticalScrollIndicator:FALSE];
    [self.netBankingTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.view addSubview:self.netBankingTableView];

}



-(void)setBackButton{
    UIImage *backButtonImage = [[UIImage imageNamed:kBackButtonImage] imageWithAlignmentRectInsets:UIEdgeInsetsMake(0, kBackButtonImageInset, 0, 0)];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:backButtonImage style:UIBarButtonItemStyleBordered target:self action:@selector(backAction:)];
}
-(void)backAction:(id)sender{
    [self.navigationController popViewControllerAnimated:TRUE];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if ([self.theNetBankingData count]>6) {
        return 2;
    }else{
        return 1;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 6;
    }else{
        if (self.moreOptionsClicked) {
            return [self.theNetBankingData count] - 6;
        }else{
            return 0;
        }
    }

}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *theFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 0.01)];
    [theFooterView setBackgroundColor:[UIColor whiteColor]];
    return theFooterView;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView *theBankHeading = [[UIView alloc] initWithFrame:CGRectMake(10, 0, tableView.frame.size.width, [self tableView:tableView heightForHeaderInSection:section])];
    [theBankHeading setBackgroundColor:UIColorFromRGB(kBackgroundGreyColor)];
    
    if (section == 0) {
//        UILabel *chooseBankHeading = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 40)];
        
//        [chooseBankHeading setText:@"CHOOSE A BANK"];
//        [chooseBankHeading setTextColor:UIColorFromRGB(kGenderSelectorTintColor)];
//        [chooseBankHeading setFont:[UIFont fontWithName:kMontserrat_Regular size:14.0f]];
//        chooseBankHeading.center = theBankHeading.center;
//        chooseBankHeading.textAlignment = NSTextAlignmentCenter;
//        [theBankHeading addSubview:chooseBankHeading];
    }else{
        [theBankHeading setBackgroundColor:[UIColor whiteColor]];
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 7, 30, 30)];
        [imageView setBackgroundColor:[UIColor clearColor]];
        [imageView setImage:[UIImage imageNamed:@"ShowMore"]];
        [theBankHeading addSubview:imageView];
        
        
        UIButton *moreStoreBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [moreStoreBtn setBackgroundColor:[UIColor clearColor]];
        
        [moreStoreBtn setFrame:CGRectMake(imageView.frame.origin.x + imageView.frame.size.width + 10, imageView.frame.origin.y, self.netBankingTableView.frame.size.width-50, 30)];
        moreStoreBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [moreStoreBtn setTitle:@"Show More" forState:UIControlStateNormal];
        [moreStoreBtn setTitleColor:UIColorFromRGB(kTurquoiseColor) forState:UIControlStateNormal];
        [moreStoreBtn addTarget:self action:@selector(showMoreOptions:) forControlEvents:UIControlEventTouchUpInside];
        [moreStoreBtn.titleLabel setFont:[UIFont fontWithName:kMontserrat_Light size:14.0f]];
        
        UIImageView *plusIcon = [[UIImageView alloc] initWithFrame:CGRectMake(self.netBankingTableView.frame.size.width-40, 2, 35, 35)];
        [plusIcon setBackgroundColor:[UIColor clearColor]];
        [plusIcon setImage:[UIImage imageNamed:@"PlusIcon"]];
        [plusIcon setTag:980];
        [theBankHeading addSubview:plusIcon];
        
        
        [theBankHeading addSubview:moreStoreBtn];
        
        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:theBankHeading.bounds
                                                       byRoundingCorners:UIRectCornerBottomLeft|UIRectCornerBottomRight
                                                             cornerRadii:CGSizeMake(3.0, 3.0)];
        CAShapeLayer *maskLayer = [CAShapeLayer layer];
        maskLayer.frame = theBankHeading.bounds;
        maskLayer.path = maskPath.CGPath;
        theBankHeading.layer.mask = maskLayer;
    }
    
    
    return theBankHeading;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 10.0;
    }else{
        return 44.0f;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *netBankingCellIdentifier = @"NetbankingCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:netBankingCellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:netBankingCellIdentifier];
    }
    [cell setFrame:CGRectMake(0, 0, tableView.frame.size.width, cell.frame.size.height)];

    
    [cell setBackgroundColor:[UIColor whiteColor]];
    
    if (indexPath.section == 0 || self.moreOptionsClicked) {
        UIImageView *imgView =(UIImageView *)[cell.contentView viewWithTag:4132];
        if(imgView){
            [imgView removeFromSuperview];
            imgView = nil;
            
        }
        
        
        UILabel *textLbl =(UILabel *)[cell.contentView viewWithTag:132];
        if(textLbl){
            [textLbl removeFromSuperview];
            textLbl = nil;
            
        }
        
        SSLine *bottomLine =(SSLine *)[cell.contentView viewWithTag:888];
        if(bottomLine){
            [bottomLine removeFromSuperview];
            bottomLine = nil;
            
        }
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(5, cell.frame.size.height/2 - 12, 30, 25)];
        [imageView setTag:4132];
        
        NSString *imageURL = nil;
        if (indexPath.section == 0) {
            imageURL = [[self.theNetBankingData objectAtIndex:indexPath.row] bankLogo];
        }else{
            imageURL = [[self.moreOptionsData objectAtIndex:indexPath.row] bankLogo];
        }
        if (imageURL != nil) {

            [imageView sd_setImageWithURL:[NSURL URLWithString:imageURL]];
        }else{
            [imageView setBackgroundColor:[UIColor clearColor]];
        }
        
        [cell.contentView addSubview:imageView];
        
        UILabel *optionLabel = [[UILabel alloc] initWithFrame:CGRectMake(imageView.frame.origin.x + imageView.frame.size.width + 10, 0, cell.frame.size.width - 50, 40)];
        [optionLabel setTag:132];
        [optionLabel setBackgroundColor:[UIColor clearColor]];
        [optionLabel setTextColor:UIColorFromRGB(kSignUpColor)];
        if (indexPath.section == 0) {
            [optionLabel setText:[[self.theNetBankingData objectAtIndex:indexPath.row] bankName]];
        }else if (indexPath.section == 1){
            [optionLabel setText:[[self.moreOptionsData objectAtIndex:indexPath.row] bankName]];
        }

        [optionLabel setFont:[UIFont fontWithName:kMontserrat_Light size:14.0f]];
        [cell.contentView addSubview:optionLabel];
        
        if (indexPath.row == 0 && indexPath.section == 0) {
            UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:cell.bounds
                                                           byRoundingCorners:UIRectCornerTopLeft|UIRectCornerTopRight
                                                                 cornerRadii:CGSizeMake(3.0, 3.0)];
            CAShapeLayer *maskLayer = [CAShapeLayer layer];
            maskLayer.frame = cell.bounds;
            maskLayer.path = maskPath.CGPath;
            cell.layer.mask = maskLayer;
            
        }
        if ((indexPath.section == 0 && indexPath.row <6) || (indexPath.section == 1 && indexPath.row<[self.moreOptionsData count]-1)) {
            
            SSLine *line = [[SSLine alloc] initWithFrame:CGRectMake(10, cell.frame.size.height-1, self.netBankingTableView.frame.size.width - 20, 1)];
            line.tag = 888;
            [cell.contentView addSubview:line];
        }
        if ((indexPath.section == 0 && indexPath.row ==6) || (indexPath.section == 1 && indexPath.row ==[self.moreOptionsData count]-1)) {
    
            UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:cell.bounds
                                                           byRoundingCorners:UIRectCornerBottomLeft|UIRectCornerBottomRight
                                                                 cornerRadii:CGSizeMake(3.0, 3.0)];
            CAShapeLayer *maskLayer = [CAShapeLayer layer];
            maskLayer.frame = cell.bounds;
            maskLayer.path = maskPath.CGPath;
            cell.layer.mask = maskLayer;
        }
    }
    


    
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:TRUE];
    
    NSMutableDictionary *theDataDic = [[NSMutableDictionary alloc] init];
    [theDataDic setObject:@"NB" forKey:@"mode"];
    if (indexPath.section == 0) {
        [theDataDic setObject:[self.theNetBankingData objectAtIndex:indexPath.row] forKey:@"data"];
    }else{
        [theDataDic setObject:[self.moreOptionsData objectAtIndex:indexPath.row] forKey:@"data"];
    }


    
    UINavigationController *navController = [[self.tabBarController viewControllers] objectAtIndex:4];
    [navController popToRootViewControllerAnimated:TRUE];
    if([[[navController viewControllers] objectAtIndex:0] isKindOfClass:[CartViewController class]]){
        CartViewController *cartController = [[(UINavigationController *)navController viewControllers] objectAtIndex:0];
        
        [cartController selectedNetbankingOption:theDataDic];
    }

}


- (void)showMoreOptions:(id)sender{
    UIButton * sectionView = (UIButton *)sender;
    self.moreOptionsClicked = !self.moreOptionsClicked;
    
    if(self.moreOptionsClicked){
        
        UIImageView *headerImg = (UIImageView *)[self.netBankingTableView viewWithTag:980];
        [headerImg setImage:[UIImage imageNamed:@"Minus"]];
        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:sectionView.superview.bounds
                                                       byRoundingCorners:UIRectCornerBottomLeft|UIRectCornerBottomRight
                                                             cornerRadii:CGSizeMake(0.0, 0.0)];
        CAShapeLayer *maskLayer = [CAShapeLayer layer];
        maskLayer.frame = sectionView.superview.bounds;
        maskLayer.path = maskPath.CGPath;
        sectionView.superview.layer.mask = maskLayer;
        
        SSLine *line = [[SSLine alloc] initWithFrame:CGRectMake(10, headerImg.superview.frame.size.height-1, self.netBankingTableView.frame.size.width - 20, 1)];
        line.tag = 999;
        [headerImg.superview addSubview:line];
        
        
        [self.netBankingTableView insertRowsAtIndexPaths:[self indexPathForMoreOptions:[self.theNetBankingData count]-6] withRowAnimation:UITableViewRowAnimationAutomatic];
        
//        [self.netBankingTableView setFrame:CGRectMake(self.netBankingTableView.frame.origin.x, self.netBankingTableView.frame.origin.y, self.netBankingTableView.frame.size.width, self.view.frame.size.height - 10)];
    }else{
        UIImageView *headerImg = (UIImageView *)[self.netBankingTableView viewWithTag:980];
        
        SSLine *headerLine = (SSLine *)[headerImg.superview viewWithTag:999];
        
        [headerLine removeFromSuperview];
        headerLine= nil;
        [headerImg setImage:[UIImage imageNamed:@"PlusIcon"]];
        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:sectionView.superview.bounds
                                                       byRoundingCorners:UIRectCornerBottomLeft|UIRectCornerBottomRight
                                                             cornerRadii:CGSizeMake(3.0, 3.0)];
        CAShapeLayer *maskLayer = [CAShapeLayer layer];
        maskLayer.frame = sectionView.superview.bounds;
        maskLayer.path = maskPath.CGPath;
        sectionView.superview.layer.mask = maskLayer;
        
        [self.netBankingTableView deleteRowsAtIndexPaths:[self indexPathForMoreOptions:[self.theNetBankingData count]-6] withRowAnimation:UITableViewRowAnimationAutomatic];
        
//        [self.netBankingTableView setFrame:CGRectMake(self.netBankingTableView.frame.origin.x, self.netBankingTableView.frame.origin.y, self.netBankingTableView.frame.size.width, 44*8)];
    }
}

- (NSArray *)indexPathForMoreOptions:(NSInteger)rows{
    
    NSMutableArray *indexPathArray = [[NSMutableArray alloc] initWithCapacity:0];
    for(NSInteger counter=0; counter< rows; counter++){
        [indexPathArray addObject:[NSIndexPath indexPathForRow:counter inSection:1]];
    }
    return [indexPathArray copy];
}



/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
