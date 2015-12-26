//
//  NotificationViewController.m
//  Explore
//
//  Created by Rahul Chaudhari on 05/10/15.
//  Copyright © 2015 Rahul. All rights reserved.
//

#import "NotificationViewController.h"


@implementation LoaderTableViewCell
@synthesize gifContainer;

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        filePath = [[NSBundle mainBundle] pathForResource:@"loader.gif" ofType:nil];
        imageData = [NSData dataWithContentsOfFile:filePath];
        gifContainer = [[SCGIFImageView alloc] init];
        gifContainer.animationDuration = 0.030;
        [gifContainer setData:imageData];
        [self addSubview:gifContainer];
        
    }
    return self;
}


-(void)layoutSubviews{
    [gifContainer setFrame:CGRectMake(0, 0, 40, 40)];
    [gifContainer setCenter:CGPointMake(self.frame.size.width/2, self.frame.size.height/2)];
    [gifContainer startAnimating];
}

@end


@interface NotificationViewController ()

@end

@implementation NotificationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.view setBackgroundColor:UIColorFromRGB(kBackgroundGreyColor)];

    pageNumber = 1;
    
    self.title = @"Notifications";
    self.navigationController.navigationBar.topItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationController.navigationBarHidden = false;
    [self.navigationController.navigationBar setBackgroundColor:UIColorFromRGB(0xF2F2F2)];
    [self.navigationController.navigationBar setFont:[UIFont fontWithName:kMontserrat_Regular size:16.0f] withColor:UIColorFromRGB(kDarkPurpleColor)];
    [self setBackButton];
    
    
    notificationLoader = [[FyndActivityIndicator alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    
    
    if(self.requestHandler){
        self.requestHandler = nil;
    }
    
    self.requestHandler = [[HomeRequestHandler alloc] init];
    [self fetchNotifications];
    
}


-(void)fetchNotifications{

    if(isFetching){
        return;
    }

    if(pageNumber > 1 && !pageData.hasNext){
        return;
    }
    isFetching = true;
    NSDictionary *param = [[NSDictionary alloc] initWithObjectsAndKeys:[NSString stringWithFormat:@"%d", pageNumber], @"page", nil];
    
    if(pageNumber == 1){
        [self.view addSubview:notificationLoader];
        [notificationLoader startAnimating];
    }
    
    [self.requestHandler fetchNotifications:param withRequestCompletionhandler:^(id responseData, NSError *error) {
        if(pageNumber == 1){
            [notificationLoader removeFromSuperview];
            [notificationLoader stopAnimating];
        }
        
        if(responseData && [responseData isKindOfClass:[NSDictionary class]] && [responseData count] > 0 && [responseData[@"items"] count] > 0){

            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            [defaults setBool:FALSE forKey:kNewNotificationKey];

            if([responseData isKindOfClass:[NSDictionary class]] && responseData[@"page"]){
                pageData = [[PaginationData alloc] initWithDictionary:responseData[@"page"]];
            }
            if(pageNumber == 1){
                self.notificationsArray = [[NSMutableArray alloc] init];
                [self parseNotificationArray:responseData[@"items"]];
                [self populateTable];
                
            }else{
                NSInteger prevLastIndex = [self.notificationsArray count] - 1;
                NSInteger newLastIndex = 0;

                
                [self parseNotificationArray:responseData[@"items"]];
//                [notificationsTable reloadData];
                
                newLastIndex = [self.notificationsArray count] - 1;
                
                NSMutableArray *indexSetArray = [[NSMutableArray alloc] initWithCapacity:0];
                for(int i = 0; i < newLastIndex - prevLastIndex; i++){
                    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i+prevLastIndex +1 inSection:0];
                    [indexSetArray addObject:indexPath];
                }

                [notificationsTable insertRowsAtIndexPaths:indexSetArray withRowAnimation:UITableViewRowAnimationNone];
                
                
            }
            isFetching = false;
            pageNumber++;

        }else{
            isFetching = false;
            pageNumber--;
            if(pageNumber <= 1){
                if(self.blankPage){
                    [self.blankPage removeFromSuperview];
                    self.blankPage = nil;
                }
                self.blankPage = [[FyndBlankPage alloc] initWithFrame:CGRectMake(10, 10, self.view.frame.size.width-20, self.view.frame.size.height - 64) blankPageType:ErrorNoNotifications];
                [self.blankPage setBackgroundColor:[UIColor whiteColor]];
                __weak NotificationViewController *weakSelf = self;
                self.blankPage.blankPageBlock = ^(){
                    [weakSelf.navigationController popViewControllerAnimated:YES];
                };
                [self.view addSubview:self.blankPage];
            }
        }
    }];
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:TRUE];
    [self.navigationController.navigationBar changeNavigationBarToTransparent:FALSE];
}


-(void)parseNotificationArray:(id)responseData{
    
    for(int i = 0; i < [responseData count]; i++){
        OfferSubTile *offerTile = [[OfferSubTile alloc] initWithDictionary:[responseData objectAtIndex:i]];
        [self.notificationsArray addObject:offerTile];
    }
}


-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleDefault;
}

-(void)setBackButton{
    UIImage *backButtonImage = [[UIImage imageNamed:kBackButtonImage] imageWithAlignmentRectInsets:UIEdgeInsetsMake(0, kBackButtonImageInset, 0, 0)];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:backButtonImage style:UIBarButtonItemStyleBordered target:self action:@selector(backAction:)];
}


-(void)backAction:(id)sender{
    [self.navigationController popViewControllerAnimated:TRUE];
}


-(void)populateTable{
    if(notificationsTable){
        notificationsTable.delegate = nil;
        notificationsTable.dataSource = nil;
        [notificationsTable removeFromSuperview];
        notificationsTable = nil;
    }
    
    notificationsTable = [[UITableView alloc] initWithFrame:CGRectMake(RelativeSize(6, 320), 0, self.view.frame.size.width - RelativeSize(12, 320), self.view.frame.size.height - 49)];
    notificationsTable.separatorStyle = UITableViewCellSelectionStyleNone;
    notificationsTable.showsVerticalScrollIndicator = false;
    notificationsTable.showsHorizontalScrollIndicator = false;
    [notificationsTable setBackgroundColor:[UIColor clearColor]];
    notificationsTable.delegate = self;
    notificationsTable.dataSource = self;
    [self.view addSubview:notificationsTable];
}



#pragma mark - tableView delegates and data sources

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(section == 0){
        return [self.notificationsArray count];
    }else{
        return 1;
    }
//    return 1;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
//   return [self.notificationsArray count] + 1;
    return 2;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section == 1){
        return 60;
    }else{
        OfferSubTile *tile = (OfferSubTile *)[self.notificationsArray objectAtIndex:indexPath.row];
//        return [SSUtility getHeightFromAspectRatio:tile.aspectRatio andWidth:self.view.frame.size.width] + RelativeSize(8, 320);
            return [SSUtility getHeightFromAspectRatio:tile.aspectRatio andWidth:self.view.frame.size.width] + RelativeSize(8, 320) + RelativeSize(8, 320);
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(indexPath.section == 1){
//        LoaderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LoaderCell"];
        LoaderTableViewCell *cell = nil;
        if(cell == nil){
            cell = [[LoaderTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LoaderCell"];
            [cell setBackgroundColor:[UIColor clearColor]];
            
            if(pageData.hasNext){
                [cell.gifContainer setHidden:false];
            }else{
                [cell.gifContainer setHidden:true];
            }
        }
        
        return  cell;

    }else{
        NSString *identifier = @"NotificationCell";
        
        NotificationTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if(!cell)
        {
            cell = [[NotificationTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
        }
        cell.model = [self.notificationsArray objectAtIndex:indexPath.row];
        [cell setBackgroundColor:UIColorFromRGB(kBackgroundGreyColor)];
        return cell;
    }
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return RelativeSize(4, 320);
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return RelativeSize(4, 320);
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return [[UIView alloc] init];
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return [[UIView alloc] init];
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row == [self.notificationsArray count]){
        
    }else{
        OfferSubTile *model = (OfferSubTile *)[self.notificationsArray objectAtIndex:indexPath.row];
        [self openOfferPage:model.actionModel];
    }
}


-(void)openOfferPage:(ActionModel *)actionModel{
    
    NSString *url = actionModel.url;
    NSString *type = actionModel.type;
    

    if([type isEqualToString:@"product"]){
        if(self.pdpController){
            self.pdpController = nil;
        }
        self.pdpController = [[PDPViewController alloc] init];
        self.pdpController.productURL = url;
        [self.navigationController pushViewController:self.pdpController animated:YES];
        
    }else if([type isEqualToString:@"brand"]){
        if(self.browseByBrandController){
            self.browseByBrandController = nil;
        }
        self.browseByBrandController = [[BrowseByBrandViewController alloc] init];
        self.browseByBrandController.isProfileBrand = true;
        [self.browseByBrandController parseURL:url];
        [self.navigationController pushViewController:self.browseByBrandController animated:YES];
        
    }else if([type isEqualToString:@"collection"]){
        if(self.browseByCollectionController){
            self.browseByCollectionController = nil;
        }
        self.browseByCollectionController = [[BrowseByCollectionViewController alloc] init];
        self.browseByCollectionController.isProfileCollection = true;
        [self.browseByCollectionController parseURL:url];
        [self.navigationController pushViewController:self.browseByCollectionController animated:YES];
        
    }else if ([type isEqualToString:@"category"] || [type isEqualToString:@"search"]){
        if(self.browseByCategoryController){
            self.browseByCategoryController = nil;
        }
        NSString *categoryName = [SSUtility getValueForParam:@"q" from:url];
        self.browseByCategoryController = [[BrowseByCategoryViewController alloc] init];
        self.browseByCategoryController.theCategory = categoryName;
        self.browseByCategoryController.theProductURL = url;
        [self.navigationController pushViewController:self.browseByCategoryController animated:TRUE];
    }
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{

    if(scrollView.contentOffset.y + scrollView.frame.size.height + 50 > scrollView.contentSize.height){
        [self fetchNotifications];
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
