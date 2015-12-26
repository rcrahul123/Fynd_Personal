//
//  SortViewController.m
//  Explore
//
//  Created by Rahul Chaudhari on 26/09/15.
//  Copyright © 2015 Rahul. All rights reserved.
//

#import "SortViewController.h"

@interface SortViewController ()

@end

@implementation SortViewController

-(id)initSortByArray:(NSArray *)array{
    self = [super init];
    if(self){
        self.title = @"Sort By";
        self.navigationController.navigationBar.translucent = NO;
        self.edgesForExtendedLayout = UIRectEdgeNone;

        sortByArray = array;
        listCount = [sortByArray count];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}


-(void)viewWillAppear:(BOOL)animated{
    [self getHeaderForTable];
    [self setupView];
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self.navigationController.view setBackgroundColor:[UIColor whiteColor]];
    
    [self.navigationController.navigationBar changeNavigationBarToTransparent:FALSE];
    [self.navigationController.navigationBar setFont:[UIFont fontWithName:kMontserrat_Regular size:16.0f] withColor:UIColorFromRGB(kDarkPurpleColor)];
    
    cancelButton = [[UIButton alloc] initWithFrame:CGRectMake(self.navigationController.navigationBar.frame.size.width - 40, self.navigationController.navigationBar.frame.size.height/2 - 16, 32, 32)];
    //    [cancelButton setBackgroundColor:[UIColor redColor]];
    [cancelButton setBackgroundImage:[UIImage imageNamed:@"CrossGrey"] forState:UIControlStateNormal];
    [cancelButton addTarget:self action:@selector(dismissSelf) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationController.navigationBar addSubview:cancelButton];

}


-(void)getHeaderForTable{
    
    NSAttributedString *headerText = [[NSAttributedString alloc] initWithString:@" Sort By " attributes:@{NSFontAttributeName : [UIFont fontWithName:kMontserrat_Regular size:18.0], NSForegroundColorAttributeName : UIColorFromRGB(kDarkPurpleColor)}];
    CGRect headerLabelSize = [headerText boundingRectWithSize:CGSizeMake(self.view.frame.size.width, 64) options:NSStringDrawingTruncatesLastVisibleLine context:NULL];
    
    headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 0)];
    [headerView setBackgroundColor:UIColorFromRGB(kHeaderBackgroundColor)];
    
    UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(headerView.frame.size.width/2 - headerLabelSize.size.width/2, headerView.frame.size.height/2 - headerLabelSize.size.height/2, headerLabelSize.size.width, headerLabelSize.size.height)];
    [headerLabel setBackgroundColor:UIColorFromRGB(kHeaderBackgroundColor)];
    [headerLabel setAttributedText:headerText];
    [headerLabel setTextAlignment:NSTextAlignmentCenter];
    [headerLabel setCenter:CGPointMake(headerView.frame.size.width/2, headerView.frame.size.height/2 + 10)];
//    [headerView addSubview:headerLabel];
    
    UIImageView *sortIcon = [[UIImageView alloc] initWithFrame:CGRectMake(headerLabel.frame.origin.x - 30 , 0, 40, 40)];
    [sortIcon setImage:[UIImage imageNamed:@"SortHeader"]];
    [sortIcon setCenter:CGPointMake(sortIcon.center.x, headerLabel.center.y)];
//    [headerView addSubview:sortIcon];
    
    UIButton *crossButton = [[UIButton alloc] initWithFrame:CGRectMake(headerView.frame.size.width - 40, headerView.frame.size.height/2 - 20, 40, 40)];
    [crossButton setCenter:CGPointMake(crossButton.center.x, headerLabel.center.y)];
    [crossButton setBackgroundImage:[UIImage imageNamed:@"Cross"] forState:UIControlStateNormal];
    [crossButton addTarget:self action:@selector(dismissSelf) forControlEvents:UIControlEventTouchUpInside];
//    [headerView addSubview:crossButton];
    
    [self.view addSubview:headerView];
}

-(void)setupView{
    sortTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, headerView.frame.origin.y + headerView.frame.size.height, self.view.frame.size.width, self.view.frame.size.height - (headerView.frame.origin.y + headerView.frame.size.height))];
    [sortTableView setBackgroundColor:[UIColor clearColor]];
    sortTableView.delegate = self;
    sortTableView.dataSource = self;
    [self.view addSubview:sortTableView];
}

-(void)reloadSortData:(NSArray *)array{
    sortByArray = array;
    if(sortTableView){
        [sortTableView reloadData];
    }
}

-(void)dismissSelf{
    [self.navigationController dismissViewControllerAnimated:YES completion:^{
        if(self.delegate && [self.delegate respondsToSelector:@selector(sortDismissed)]){
            [self.delegate sortDismissed];
        }
    }];
}

#pragma mark - tableView delegates and datasources

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return listCount;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

//-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
//    return 60;
//}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return RelativeSizeHeight(52, 568);
}

//-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
//    return [self getHeaderForTable];
//}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if(cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    }
    [cell.textLabel setText:[[sortByArray objectAtIndex:indexPath.row] valueForKey:@"name"]];
    [cell.textLabel setTextAlignment:NSTextAlignmentCenter];
    [cell.textLabel setTextColor:UIColorFromRGB(KTextColor)];
    cell.contentView.backgroundColor = [UIColor whiteColor];
    
    if([[[sortByArray objectAtIndex:indexPath.row] valueForKey:@"is_selected"] boolValue]){
        [cell.textLabel setTextColor:UIColorFromRGB(kPinkColor)];
        [cell.textLabel setFont:[UIFont fontWithName:kMontserrat_Regular size:14.0]];
        
    }else{
        [cell.textLabel setTextColor:UIColorFromRGB(KTextColor)];
        [cell.textLabel setFont:[UIFont fontWithName:kMontserrat_Light size:14.0]];
    }
    
    UIView *bgColorView = [[UIView alloc] initWithFrame:CGRectMake(0, 2, cell.frame.size.width, RelativeSizeHeight(52, 568))];
    bgColorView.backgroundColor = UIColorFromRGB(kBackgroundGreyColor);
    [cell setSelectedBackgroundView:bgColorView];
    
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if(self.delegate && [self.delegate respondsToSelector:@selector(sortSelected:)]){
        [self.delegate sortSelected:[[sortByArray objectAtIndex:indexPath.row] objectForKey:@"value"]];
    }
    [self dismissSelf];
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
