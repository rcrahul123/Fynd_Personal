//
//  FAQView.m
//  Explore
//
//  Created by Amboj Goyal on 8/14/15.
//  Copyright (c) 2015 Rahul. All rights reserved.
//

#import "FAQView.h"
#import "SSUtility.h"

NSMutableArray *theDataArray;
UIFont *questionFont;
UIFont *answerFont;
@implementation FAQView

-(id)initWithFrame:(CGRect)frame dataDictionary:(NSMutableArray *)dataDict{
    self = [super initWithFrame:frame];
    if(self){
        [self setBackgroundColor:UIColorFromRGB(kBackgroundGreyColor)];
    }
    if (self.allSectionsFlagArray == nil) {
        self.allSectionsFlagArray = [[NSMutableArray alloc] initWithCapacity:0];
    }
   
    theDataArray = [self parseData:nil];

    [self.allSectionsFlagArray removeAllObjects];
    for (int iCount = 0; iCount<[theDataArray count]; iCount ++) {
        [self.allSectionsFlagArray addObject:[NSNumber numberWithBool:FALSE]];
    }
    
    [self confgiureTheFAQ];
    questionFont =[UIFont fontWithName:kMontserrat_Regular size:12.0f];
    answerFont =[UIFont fontWithName:kMontserrat_Light size:12.0f];
    return self;
}

-(void)confgiureTheFAQ{
    
    self.theFAQTableView = [[UITableView alloc] initWithFrame:CGRectMake(5, 5, self.frame.size.width - 10, self.frame.size.height - 70) style:UITableViewStylePlain];
    [self.theFAQTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    self.theFAQTableView.dataSource = self;
    self.theFAQTableView.delegate = self;
    [self.theFAQTableView setBackgroundColor:[UIColor clearColor]];
    [self addSubview:self.theFAQTableView];
    
}

#pragma mark - TableView Delegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString * questionValue = [[theDataArray objectAtIndex:indexPath.row] valueForKey:@"answer"];
    
    CGSize heightSize = [SSUtility getLabelDynamicSize:questionValue withFont:answerFont withSize:CGSizeMake(self.theFAQTableView.frame.size.width-10, MAXFLOAT)];
    
    return heightSize.height+20;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{

    return [theDataArray count];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if ([[self.allSectionsFlagArray objectAtIndex:section] boolValue])
        return 1;
    else
        return 0;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    NSString *selectedTile = [[theDataArray objectAtIndex:section] valueForKey:@"question"];
    CGSize questionSize = [SSUtility getLabelDynamicSize:selectedTile withFont:questionFont withSize:CGSizeMake(tableView.frame.size.width, MAXFLOAT)];

    return ceilf(questionSize.height) + 11;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *theHeader = [[UIView alloc] initWithFrame:CGRectMake(10, 0, tableView.frame.size.width, [self tableView:tableView heightForHeaderInSection:section])];
    [theHeader setBackgroundColor:[UIColor whiteColor]];
    [theHeader.layer setCornerRadius:2.0f];
    NSString *selectedTile = [[theDataArray objectAtIndex:section] valueForKey:@"question"];
    CGSize questionSize = [SSUtility getLabelDynamicSize:selectedTile withFont:questionFont withSize:CGSizeMake(theHeader.frame.size.width, MAXFLOAT)];

    NSAttributedString *btnTitle = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@" %ld.  %@",section+1,selectedTile] attributes:@{NSFontAttributeName : questionFont}];
    
    UIButton *theQuestionlabel = [[UIButton alloc] initWithFrame:CGRectMake(5, 5, theHeader.frame.size.width, questionSize.height)];
    [theQuestionlabel setAttributedTitle:btnTitle forState:UIControlStateNormal];
//    [theQuestionlabel setTitle:[NSString stringWithFormat:@" %ld.  %@",section+1,selectedTile] forState:UIControlStateNormal];
//    [theQuestionlabel setFont:questionFont];
    [theQuestionlabel setTag:section];
    [theQuestionlabel addTarget:self action:@selector(headerTapped:) forControlEvents:UIControlEventTouchUpInside];
    theQuestionlabel.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [theQuestionlabel setTitleColor:UIColorFromRGB(kDarkPurpleColor) forState:UIControlStateNormal];
    [theQuestionlabel setBackgroundColor:[UIColor whiteColor]];
    [theHeader addSubview:theQuestionlabel];
    
    return theHeader;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 20)];
    [footerView setBackgroundColor:[UIColor clearColor]];
    return footerView;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    if(cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
    }
    
    cell.textLabel.text = [[theDataArray objectAtIndex:indexPath.row] valueForKey:@"answer"];
    [cell.textLabel setTextColor:UIColorFromRGB(kLightGreyColor)];
    [cell.contentView setBackgroundColor:[UIColor whiteColor]];
    [cell.textLabel setFont:answerFont];
    [cell.textLabel setNumberOfLines:0];


    return cell;
}
- (NSInteger)tableView:(UITableView *)tableView indentationLevelForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 1;
}
-(NSMutableArray *)parseData:(NSArray *)theArray{
    NSMutableArray *faqArray = [[NSMutableArray alloc] init];
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"FAQ" ofType:@"json"];
    NSData *data = [NSData dataWithContentsOfFile:path];
    NSArray *json_response = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
  
    for (int i=0; i<[json_response count]; i++) {
        NSMutableDictionary *qa = [[NSMutableDictionary alloc] init];
        [qa setObject:[[json_response objectAtIndex:i] valueForKey:@"question"] forKey:@"question"];
        [qa setObject:[[json_response objectAtIndex:i] valueForKey:@"answer"] forKey:@"answer"];
        [faqArray addObject:qa];
    }
    
    return faqArray;
}

#pragma mark - Custom Methods

-(void)headerTapped:(id)sender{
    UIButton *tappedButton = (UIButton *)sender;
    int section = (int)tappedButton.tag;
    
    if (section >= 0)
    {
        [self toggleSection:section forTableView:self.theFAQTableView];
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
    
    
    NSUInteger openedSection = [self openedSectionForIndex:(int)sectionIndex];
    
    [self setSectionAtIndex:sectionIndex open:YES];
    [self setSectionAtIndex:openedSection open:NO];
    
    NSArray* indexPathsToInsert = [self indexPathsForRowsInSectionAtIndex:sectionIndex forTableView:tableView];
    NSArray* indexPathsToDelete = [self indexPathsForRowsInSectionAtIndex:openedSection forTableView:tableView];
    
    [tableView beginUpdates];
    [tableView insertRowsAtIndexPaths:indexPathsToInsert withRowAnimation:UITableViewRowAnimationFade];
    [tableView deleteRowsAtIndexPaths:indexPathsToDelete withRowAnimation:UITableViewRowAnimationFade];
    [tableView endUpdates];
    
    UIView *roundedView = [self tableView:tableView viewForHeaderInSection:sectionIndex];
    UIBezierPath *maskPath;
    maskPath = [UIBezierPath bezierPathWithRoundedRect:roundedView.bounds
                                     byRoundingCorners:(UIRectCornerBottomLeft|UIRectCornerBottomRight)
                                           cornerRadii:CGSizeMake(0.0, 0.0)];
    
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = roundedView.bounds;
    maskLayer.path = maskPath.CGPath;
    roundedView.layer.mask = maskLayer;
}

- (void)collapseSectionWithIndex:(NSUInteger)sectionIndex forTableView:(UITableView *)tableView
{

    [self setSectionAtIndex:sectionIndex open:NO];
    
    NSArray* indexPathsToDelete = [self indexPathsForRowsInSectionAtIndex:sectionIndex forTableView:nil];
    [tableView deleteRowsAtIndexPaths:indexPathsToDelete withRowAnimation:UITableViewRowAnimationFade];
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

- (void)setSectionAtIndex:(NSUInteger)sectionIndex open:(BOOL)open
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
    NSMutableArray* array = [[NSMutableArray alloc] init];
    [array addObject:[NSIndexPath indexPathForRow:0 inSection:sectionIndex]];
    
    return array;
}


@end
