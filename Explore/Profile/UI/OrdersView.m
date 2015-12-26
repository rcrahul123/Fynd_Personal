//
//  OrdersView.m
//  Explore
//
//  Created by Amboj Goyal on 8/11/15.
//  Copyright (c) 2015 Rahul. All rights reserved.
//

#import "OrdersView.h"
#import "FyndBlankPage.h"
#import "SSUtility.h"
#import "CartRequestHandler.h"
#import "PDPModel.h"
#import "PopOverlayHandler.h"

@interface OrdersView()<PopOverlayHandlerDelegate>{
    
}
@property (nonatomic,strong) FyndBlankPage *blankPage;
@property (nonatomic,strong) CartRequestHandler *cartHandler;
@property (nonatomic,strong) NSMutableArray     *exchangeItemSize;
@property (nonatomic,strong) PopOverlayHandler   *popOverlayHanler;

-(void)headerTapped:(id)sender forEvent:(UIEvent *)theEvent;
@end


@implementation OrdersView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(id)initWithFrame:(CGRect)frame{
    
    if(self == [super initWithFrame:frame]){
        
        requestHandler = [[ProfileRequestHandler alloc] init];
        [self getData];
    }
    return self;
}

- (void)configureOrdersView{
    if(1){
        if(self.blankPage){
            [self.blankPage removeFromSuperview];
            self.blankPage = nil;
        }
        self.blankPage = [[FyndBlankPage alloc] initWithFrame:CGRectMake(5, 0, self.frame.size.width - 10, 300) blankPageType:ErrorNoOrders];
        [self.blankPage setBackgroundColor:[UIColor whiteColor]];
        __weak OrdersView *weakSelf = self;
        self.blankPage.blankPageBlock = ^(){
            [weakSelf.orderViewDelegate handleOrderlBlankPageAction];
        };
        [self addSubview:self.blankPage];
    }
    
    [self setFrame:CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, 300)];
}


-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    
    if([keyPath isEqualToString:@"pastOrdersTable.contentSize"]){
        [pastOrdersTable setFrame:CGRectMake(pastOrdersTable.frame.origin.x, pastOrdersTable.frame.origin.y, pastOrdersTable.frame.size.width, pastOrdersTable.contentSize.height + 40)];
        [self setFrame:CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, pastOrdersTable.frame.origin.y + pastOrdersTable.frame.size.height)];
        
    }else if([keyPath isEqualToString:@"activeOrdersTable.contentSize"]){
        [activeOrdersTable setFrame:CGRectMake(activeOrdersTable.frame.origin.x, activeOrdersTable.frame.origin.y, activeOrdersTable.frame.size.width, activeOrdersTable.contentSize.height)];
        if([pastOrdersArray count] > 0){
            [pastOrdersHeader setFrame:CGRectMake(pastOrdersHeader.frame.origin.x, activeOrdersTable.frame.origin.y + activeOrdersTable.frame.size.height, activeOrdersTable.frame.size.width, pastOrdersHeader.frame.size.height)];
        }else{
            [self setFrame:CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, activeOrdersTable.frame.origin.y + activeOrdersTable.frame.size.height)];
        }
    }
    else if([keyPath isEqualToString:@"pastOrdersHeader.frame"]){
        [pastOrdersTable setFrame:CGRectMake(pastOrdersTable.frame.origin.x, pastOrdersHeader.frame.origin.y + pastOrdersHeader.frame.size.height, pastOrdersTable.frame.size.width, pastOrdersTable.contentSize.height)];
        [self setFrame:CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, pastOrdersTable.frame.origin.y + pastOrdersTable.frame.size.height)];
    }
}


-(void)getData{
    
    if(self.orderViewDelegate && [self.orderViewDelegate respondsToSelector: @selector(showLoader)]){
        [self.orderViewDelegate showLoader];
    }
    
    if(self.blankPage){
        [self.blankPage removeFromSuperview];
        self.blankPage = nil;
    }
    activeOrdersArray = [[NSMutableArray alloc] initWithCapacity:0];
    pastOrdersArray = [[NSMutableArray alloc] initWithCapacity:0];
    self.allSectionsFlagArray = [[NSMutableArray alloc] initWithCapacity:0];
    
    if(activeOrdersTable){
        
        if(isActiveOrderTableObserveAdded){
            @try {
                [self removeObserver:self forKeyPath:@"activeOrdersTable.contentSize"];
                isActiveOrderTableObserveAdded = FALSE;
            }
            @catch (NSException *exception) {
                
            }
        }
        
        activeOrdersTable.delegate = nil;
        activeOrdersTable.dataSource = nil;
        [activeOrdersTable removeFromSuperview];
        activeOrdersTable = nil;
    }
    activeOrdersTable = [[UITableView alloc] initWithFrame:CGRectMake(RelativeSize(0, 375), RelativeSize(0, 375), self.frame.size.width - RelativeSize(0, 375), 0) style:UITableViewStylePlain];

    
    if(pastOrdersHeader != nil){
        if(isPastOrderHeaderObserverAdded){
            @try {
                [self removeObserver:self forKeyPath:@"pastOrdersHeader.frame"];
                isPastOrderHeaderObserverAdded = FALSE;
            }
            @catch (NSException *exception) {
                
            }
        }
        
        [pastOrdersHeader removeFromSuperview];
        pastOrdersHeader = nil;
    }
    pastOrdersHeader = [[UILabel alloc] initWithFrame:CGRectMake(pastOrdersHeader.frame.origin.x, activeOrdersTable.frame.origin.y + activeOrdersTable.frame.size.height, pastOrdersHeader.frame.size.width, 30)];

    
    if(pastOrdersTable){
        
        if(isPastOrderTableObserverAdded){
            @try {
                [self removeObserver:self forKeyPath:@"pastOrdersTable.contentSize"];
                isPastOrderTableObserverAdded = FALSE;
            }
            @catch (NSException *exception) {
                
            }
        }
        
        pastOrdersTable.delegate = nil;
        pastOrdersTable.dataSource = nil;
        [pastOrdersTable removeFromSuperview];
        pastOrdersTable = nil;
    }
    pastOrdersTable = [[UITableView alloc] initWithFrame:CGRectMake(RelativeSize(0, 375), pastOrdersHeader.frame.origin.y + pastOrdersHeader.frame.size.height + 30, self.frame.size.width - RelativeSize(0, 375), 0) style:UITableViewStylePlain];

    [requestHandler getMyorderdataWithCompletionHandler:^(id responseData, NSError *error) {
        dataDictionary = responseData;
        
        if([[dataDictionary objectForKey:@"my_orders"] count]  > 0){
            for(int i = 0; i < [[dataDictionary objectForKey:@"my_orders"] count]; i++){
                MyOrderModel *myOrder = [[MyOrderModel alloc] initWithDictionary:[[dataDictionary objectForKey:@"my_orders"] objectAtIndex:i]];
                if(myOrder.isActiveOrder){
                    [activeOrdersArray addObject:myOrder];
                }else{
                    [pastOrdersArray addObject:myOrder];
                    [self.allSectionsFlagArray addObject:[NSNumber numberWithBool:false]];
                }
            }
            pastOrdersHeader = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 50)];
            [self addSubview:pastOrdersHeader];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                if(self.orderViewDelegate && [self.orderViewDelegate respondsToSelector: @selector(dismissLoader)]){
                    [self.orderViewDelegate dismissLoader];
                }
                if([activeOrdersArray count] > 0){
                    [self showActiveOrdersTable];
                }
                if([pastOrdersArray count] > 0){
                    [self showPastOrdersTable];
                }
            });
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                if(self.orderViewDelegate && [self.orderViewDelegate respondsToSelector: @selector(dismissLoader)]){
                    [self.orderViewDelegate dismissLoader];
                }
                [self configureOrdersView];
            });
        }
        }];
    
}

-(void)showActiveOrdersTable{
    [activeOrdersTable setBackgroundColor:UIColorFromRGB(kBackgroundGreyColor)];
    activeOrdersTable.bounces = FALSE;
    [activeOrdersTable setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    activeOrdersTable.tag = 1;
    activeOrdersTable.delegate = self;
    activeOrdersTable.dataSource = self;
    [self addSubview:activeOrdersTable];
    
    if(!isActiveOrderTableObserveAdded){
        [self addObserver:self forKeyPath:@"activeOrdersTable.contentSize" options:NSKeyValueObservingOptionOld context:NULL];
        isActiveOrderTableObserveAdded = TRUE;
    }
}


-(void)showPastOrdersTable{
    [pastOrdersHeader setText:@"PAST ORDERS"];
    [pastOrdersHeader setBackgroundColor:UIColorFromRGB(kBackgroundGreyColor)];
    [pastOrdersHeader setFont:[UIFont fontWithName:kMontserrat_Regular size:12.0]];
    [pastOrdersHeader setTextColor:UIColorFromRGB(kGenderSelectorTintColor)];
    [pastOrdersHeader setTextAlignment:NSTextAlignmentCenter];
    [self addSubview:pastOrdersHeader];
    
    
    [pastOrdersTable setBackgroundColor:[UIColor clearColor]];
    pastOrdersTable.bounces = FALSE;
    [pastOrdersTable setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    pastOrdersTable.tag = 2;
    pastOrdersTable.delegate = self;
    pastOrdersTable.dataSource = self;
    [self addSubview:pastOrdersTable];
 
    if(!isPastOrderHeaderObserverAdded){
        [self addObserver:self forKeyPath:@"pastOrdersHeader.frame" options:NSKeyValueObservingOptionOld context:NULL];
        isPastOrderHeaderObserverAdded = TRUE;
    }
    
    if(!isPastOrderTableObserverAdded){
        [self addObserver:self forKeyPath:@"pastOrdersTable.contentSize" options:NSKeyValueObservingOptionOld context:NULL];
        isPastOrderTableObserverAdded = TRUE;
    }
}


-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    OrderHeaderView *headerView = [[OrderHeaderView alloc] init];
    [headerView setTag:50+section];
    if(tableView.tag == 2)
        [headerView addTarget:self action:@selector(headerTapped:forEvent:) forControlEvents:UIControlEventTouchUpInside];

    if(tableView.tag == 1){
        headerView.orderID = ((MyOrderModel *)[activeOrdersArray objectAtIndex:section]).orderId;
        headerView.orderTime = ((MyOrderModel *)[activeOrdersArray objectAtIndex:section]).orderDate;
        headerView.totalCost = ((MyOrderModel *)[activeOrdersArray objectAtIndex:section]).totalCost;
        headerView.isActive = ((MyOrderModel *)[activeOrdersArray objectAtIndex:section]).isActiveOrder;
        headerView.numberOfItems = [[(MyOrderModel *)[activeOrdersArray objectAtIndex:section] shipmentArray] count];
    }else{
        headerView.orderID = ((MyOrderModel *)[pastOrdersArray objectAtIndex:section]).orderId;
        headerView.orderTime = ((MyOrderModel *)[pastOrdersArray objectAtIndex:section]).orderDate;
        headerView.totalCost = ((MyOrderModel *)[pastOrdersArray objectAtIndex:section]).totalCost;
        headerView.isActive = ((MyOrderModel *)[pastOrdersArray objectAtIndex:section]).isActiveOrder;
        headerView.orderStatus = ((MyOrderModel *)[pastOrdersArray objectAtIndex:section]).orderStatus;
        headerView.numberOfItems = [[(MyOrderModel *)[pastOrdersArray objectAtIndex:section] shipmentArray] count];
    }
    return headerView;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{

    UIView *footerView = [[UIView alloc] init];
    if(section == [tableView numberOfSections] - 1){
        [footerView setBackgroundColor:[UIColor clearColor]];
    }else{
        [footerView setBackgroundColor:UIColorFromRGB(kBackgroundGreyColor)];
    }

    return footerView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
//    return 48;
    if(tableView.tag == 1){
        return 48;
        
    }else if(tableView.tag == 2){
        return 80;
    }
    return 48;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 12;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat cellHeight = 0;
    
    NSArray *tableDataArray;
    if(tableView.tag == 1){
        tableDataArray = activeOrdersArray;
        
    }else if(tableView.tag == 2){
        tableDataArray = pastOrdersArray;
    }
    
    if(indexPath.row <= [[[tableDataArray objectAtIndex:indexPath.section] shipmentArray] count] - 1){
        if([[[[tableDataArray objectAtIndex:indexPath.section] shipmentArray] objectAtIndex:indexPath.row] canExchange] || [[[[tableDataArray objectAtIndex:indexPath.section] shipmentArray] objectAtIndex:indexPath.row] canReturn]){
            cellHeight = 190;
        }else{
            cellHeight = 130;
        }
    }else if(indexPath.row == [[[tableDataArray objectAtIndex:indexPath.section] shipmentArray] count]){
        cellHeight = 50;

    }
    else{
        if([[tableDataArray objectAtIndex:indexPath.section] canCancel]){
            cellHeight = 130;
        }
        else{
//            cellHeight = 65;
            cellHeight = 51;

        }
    }
    return cellHeight;
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    NSInteger orderCount = 0;
    if(tableView.tag == 1){
       orderCount = [activeOrdersArray count];
    }else{
        orderCount = [pastOrdersArray count];
    }
    return orderCount;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSInteger shipmentCount = 0;
    if(tableView.tag == 1){
        shipmentCount = [[[activeOrdersArray objectAtIndex:section] shipmentArray] count]+2;
        
    }else{
        if ([[self.allSectionsFlagArray objectAtIndex:section] boolValue]) {
            shipmentCount = [[[pastOrdersArray objectAtIndex:section] shipmentArray] count] +2;
        }else{
            shipmentCount = 0;
        }
    }
    return shipmentCount ;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(tableView.tag == 1){
        if(indexPath.row <= [[[activeOrdersArray objectAtIndex:indexPath.section] shipmentArray] count] - 1){
            MyOrderProductCell *myCell = [tableView dequeueReusableCellWithIdentifier:@"productCell"];
            if(!myCell){
                myCell = [[MyOrderProductCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"productCell"];
            }
            myCell.delegate = self;
            myCell.orderItem = [[[activeOrdersArray objectAtIndex:indexPath.section] shipmentArray] objectAtIndex:indexPath.row];
            myCell.selectionStyle = UITableViewCellSelectionStyleNone;
            return myCell;
            
        }else if(indexPath.row == [[[activeOrdersArray objectAtIndex:indexPath.section] shipmentArray] count]){
            MyOrderCostCell *cell = [tableView dequeueReusableCellWithIdentifier:@"costCell"];
            if(!cell){
                cell = [[MyOrderCostCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"costCell"];
            }
            cell.delegate = self;
            cell.orderModel = [activeOrdersArray objectAtIndex:indexPath.section];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
            
        }else{
            MyOrderAddressCell *cell = [tableView dequeueReusableCellWithIdentifier:@"addressCell"];
            if(!cell){
                cell = [[MyOrderAddressCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"addressCell"];
            }
            cell.delegate = self;
            cell.orderModel = [activeOrdersArray objectAtIndex:indexPath.section];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
        
    }else{
        if(indexPath.row <= [[[pastOrdersArray objectAtIndex:indexPath.section] shipmentArray] count] - 1){
            MyOrderProductCell *myCell = [tableView dequeueReusableCellWithIdentifier:@"productCell"];
            if(!myCell){
                myCell = [[MyOrderProductCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"productCell"];
            }
            myCell.delegate = self;
            myCell.orderItem = [[[pastOrdersArray objectAtIndex:indexPath.section] shipmentArray] objectAtIndex:indexPath.row];
            myCell.selectionStyle = UITableViewCellSelectionStyleNone;
            return myCell;
            
        }else if(indexPath.row == [[[pastOrdersArray objectAtIndex:indexPath.section] shipmentArray] count]){
            MyOrderCostCell *cell = [tableView dequeueReusableCellWithIdentifier:@"costCell"];
            if(!cell){
                cell = [[MyOrderCostCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"costCell"];
            }
            cell.delegate = self;
            cell.orderModel = [pastOrdersArray objectAtIndex:indexPath.section];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
            
        }else{
            MyOrderAddressCell *cell = [tableView dequeueReusableCellWithIdentifier:@"addressCell"];
            if(!cell){
                cell = [[MyOrderAddressCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"addressCell"];
            }
            cell.orderModel = [pastOrdersArray objectAtIndex:indexPath.section];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.delegate = self;
            return cell;
        }
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if([cell isKindOfClass:[MyOrderProductCell class]]){
        MyOrderProductCell *productCell = (MyOrderProductCell *)cell;
        if(self.orderViewDelegate && [self.orderViewDelegate respondsToSelector:@selector(productTileTapped:)]){
            [self.orderViewDelegate productTileTapped:productCell.orderItem.action.url];
        }
    }
}

-(void)exchangeItem:(ShipmentItem *)shipmentItem{
        
    //call exchage with order and bag id for respective index
    if(self.orderViewDelegate && [self.orderViewDelegate respondsToSelector: @selector(showLoader)]){
        [self.orderViewDelegate showLoader];
    }
    if(self.cartHandler == nil){
        self.cartHandler = [[CartRequestHandler alloc] init];
    }
    NSString *theOrderId = [self getOrderIDforShipment:shipmentItem];
    NSMutableDictionary *exchangeParams = [[NSMutableDictionary alloc] init];
    [exchangeParams setObject:[self getOrderIDforShipment:shipmentItem] forKey:@"order_id"];
    [exchangeParams setObject:[NSString stringWithFormat:@"%ld",(long)shipmentItem.bagId] forKey:@"bag_id"];
    [self.cartHandler fetchExchangeDataWithParams:exchangeParams withCompletionHandler:^(id responseData, NSError *error) {
        if(self.orderViewDelegate && [self.orderViewDelegate respondsToSelector: @selector(dismissLoader)]){
            [self.orderViewDelegate dismissLoader];
        }
        if (!error) {
            if (self.theExchangeBlock) {
                self.theExchangeBlock(theOrderId,shipmentItem,responseData);
            }
        }
    }];
}


-(void)returnItem:(ShipmentItem *)shipmentItem{
    
    //call return with order and bag id for respective index
    if(self.orderViewDelegate && [self.orderViewDelegate respondsToSelector: @selector(showLoader)]){
        [self.orderViewDelegate showLoader];
    }
    if(self.cartHandler == nil){
        self.cartHandler = [[CartRequestHandler alloc] init];
    }
    NSString *theOrderId = [self getOrderIDforShipment:shipmentItem];
    NSMutableDictionary *returnParams = [[NSMutableDictionary alloc] init];
    [returnParams setObject:theOrderId forKey:@"order_id"];
    [returnParams setObject:[NSString stringWithFormat:@"%ld",(long)shipmentItem.bagId] forKey:@"bag_id"];
    
    [self.cartHandler fetchReturnDataWithParams:returnParams withCompletionHandler:^(id responseData, NSError *error) {
        if(self.orderViewDelegate && [self.orderViewDelegate respondsToSelector: @selector(dismissLoader)]){
            [self.orderViewDelegate dismissLoader];
        }
        if (!error) {
            if (self.theReturnBlock) {
                NSDictionary *theDic = (NSDictionary *)responseData;
                self.theReturnBlock(theOrderId,shipmentItem,theDic, shipmentItem.price);
            }
        }
    }];
}



-(void)cancelItem:(NSString *)shipmentItem cost:(NSString *)cost{
    if (self.theCancelBlock) {
        self.theCancelBlock(shipmentItem, cost);
    }
}

-(void)callus:(id)sender{
    if(self.theCallBlock){
        self.theCallBlock();
    }
}

-(NSString *)getOrderIDforShipment:(ShipmentItem *)shipmentItem{
    NSInteger activeCount = [activeOrdersArray count];
    NSInteger pastCount = [pastOrdersArray count];
    
    NSInteger orderIndex = -1;
    
    NSString *orderID;
    for(int i = 0; i < activeCount; i++){
        if([[[activeOrdersArray objectAtIndex:i] shipmentArray] containsObject:shipmentItem]){
            orderIndex = i;
            orderID = [[activeOrdersArray objectAtIndex:orderIndex] orderId];
            break;
        }
    }
    
    if(orderIndex < 0){
        for(int i = 0; i < pastCount; i++){
            if([[[pastOrdersArray objectAtIndex:i] shipmentArray] containsObject:shipmentItem]){
                orderIndex = i;
                orderID = [[pastOrdersArray objectAtIndex:orderIndex] orderId];
                break;
            }
        }
    }
    return orderID;
}

-(void)headerTapped:(id)sender forEvent:(UIEvent *)theEvent{
    UIButton *tappedButton = (UIButton *)sender;
    UITouch *buttonTouch = [[theEvent touchesForView:tappedButton] anyObject];
    CGPoint tapPoint = [buttonTouch locationInView:pastOrdersTable];
    
    int section = (int)[(NSIndexPath *)[activeOrdersTable indexPathForRowAtPoint:tapPoint] row];
    if (section >= 0)
    {
        [self toggleSection:(tappedButton.tag-50) forTableView:pastOrdersTable];
    }
}

- (void)toggleSection:(NSUInteger)sectionIndex forTableView:(UITableView *)tableView
{
    if (sectionIndex >= [self.allSectionsFlagArray count])
    {
        return;
    }
    
    BOOL sectionIsOpen = [[self.allSectionsFlagArray objectAtIndex:sectionIndex] boolValue];
    
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
    if (sectionIndex >= [self.allSectionsFlagArray count]) return;
    
    if ([[self.allSectionsFlagArray objectAtIndex:sectionIndex] boolValue]){
        return;
    }
    
    //To open one at a time.
    NSUInteger openedSection = [self openedSectionForIndex:(int)sectionIndex];
    
    [self setSectionAtIndex:sectionIndex open:YES forTableIndex:0];

    //To open one at a time.
    [self setSectionAtIndex:openedSection open:NO forTableIndex:0];
    
    NSArray* indexPathsToInsert = [self indexPathsForRowsInSectionAtIndex:sectionIndex forTableView:tableView];

    //To open one at a time.    
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
    [self setSectionAtIndex:sectionIndex open:NO forTableIndex:0];
    
    NSArray* indexPathsToDelete = [self indexPathsForRowsInSectionAtIndex:sectionIndex forTableView:tableView];
    [tableView deleteRowsAtIndexPaths:indexPathsToDelete withRowAnimation:UITableViewRowAnimationTop];
}

- (NSUInteger)openedSectionForIndex:(int)indexofTable
{
    for (NSUInteger index = 0 ; index < [self.allSectionsFlagArray count] ; index++)
    {
        if ([[self.allSectionsFlagArray objectAtIndex:index] boolValue])
        {
            return index;
        }
    }
    return NSNotFound;
}

- (void)setSectionAtIndex:(NSUInteger)sectionIndex open:(BOOL)open forTableIndex:(int)tableIndex
{
    
    if (sectionIndex >= [self.allSectionsFlagArray count])
    {
        return;
    }
    
    [self.allSectionsFlagArray replaceObjectAtIndex:sectionIndex withObject:@(open)];
}

- (NSArray*)indexPathsForRowsInSectionAtIndex:(NSUInteger)sectionIndex forTableView:(UITableView *)tableView
{
    if (sectionIndex >= [self.allSectionsFlagArray count])
    {
        return nil;
    }
    int numberOfRows = (int)[[(MyOrderModel *)[pastOrdersArray objectAtIndex:sectionIndex] shipmentArray] count]+2;
    
    NSMutableArray* array = [[NSMutableArray alloc] init];
    
    for (int i = 0 ; i < numberOfRows ; i++)
    {
        [array addObject:[NSIndexPath indexPathForRow:i inSection:sectionIndex]];
    }
    return array;
}


-(void)releaseResources{
    if(isPastOrderHeaderObserverAdded){
        @try {
            [self removeObserver:self forKeyPath:@"pastOrdersHeader.frame"];
            isPastOrderHeaderObserverAdded = FALSE;
        }
        @catch (NSException *exception) {
            
        }
    }
    
    if(isPastOrderTableObserverAdded){
        @try {
            [self removeObserver:self forKeyPath:@"pastOrdersTable.contentSize"];
            isPastOrderTableObserverAdded = FALSE;
        }
        @catch (NSException *exception) {
            
        }
    }
    if(isActiveOrderTableObserveAdded){
        @try {
            [self removeObserver:self forKeyPath:@"activeOrdersTable.contentSize"];
            isActiveOrderTableObserveAdded = FALSE;
        }
        @catch (NSException *exception) {
            
        }
    }
}


@end
