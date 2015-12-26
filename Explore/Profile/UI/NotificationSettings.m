//
//  NotificationSettings.m
//  Explore
//
//  Created by Pranav on 13/08/15.
//  Copyright (c) 2015 Rahul. All rights reserved.
//

#import "NotificationSettings.h"
#import "SSUtility.h"
#import "NotificationCell.h"

@interface NotificationSettings ()<UITableViewDataSource,UITableViewDelegate,NotificationCellDelegate>
{
    
    UIButton        *cancel;
    UIButton        *saveChanges;
}
@property (nonatomic,strong) NSMutableArray *notificationOptions;
@property (nonatomic,strong) UITableView *notificationOptionsTable;

- (void)setUpNotificationView;

@end

@implementation NotificationSettings


- (id)initWithFrame:(CGRect)frame{
    
    if(self == [super initWithFrame:frame]){
        

        
        [self setBackgroundColor:UIColorFromRGB(kBackgroundGreyColor)];
        [self genetateNotificationOptions];
        [self setUpNotificationView];
    }
    return self;
}


- (void)genetateNotificationOptions{
    self.notificationOptions = [[NSMutableArray alloc] initWithCapacity:0];
    //    NSMutableDictionary *recommendedDict = [NSMutableDictionary dictionaryWithObject:@"You will get all immediate notification and reminders about all offers and exclusive items in our app" forKey:@"Recommended"];
    NSMutableDictionary *recommendedDict =[NSMutableDictionary dictionaryWithObjectsAndKeys:@"You will get all immediate notification and reminders about all offers and exclusive items in our app",@"Recommended",[NSNumber numberWithBool:FALSE],@"isSelected", nil];
    [self.notificationOptions addObject:recommendedDict];
    //    NSMutableDictionary *standardDict = [NSMutableDictionary dictionaryWithObject:@"You will get only the important notificaton and reminders about all offers and exclusive items in our app" forKey:@"Standard"];
    NSMutableDictionary *standardDict = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"You will get only the important notificaton and reminders about all offers and exclusive items in our app",@"Recommended",[NSNumber numberWithBool:FALSE],@"isSelected", nil];
    [self.notificationOptions addObject:standardDict];
    
    //    NSMutableDictionary *neverDict = [NSMutableDictionary dictionaryWithObject:@"You will get all immediate notification and reminders about all offers and exclusive items in our app" forKey:@"Never"];
    NSMutableDictionary *neverDict = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"You will get all immediate notification and reminders about all offers and exclusive items in our app",@"Never",[NSNumber numberWithBool:FALSE],@"isSelected", nil];
    [self.notificationOptions addObject:neverDict];
}

- (void)setUpNotificationView{
   
    self.notificationOptionsTable = [[UITableView alloc] initWithFrame:CGRectMake(10, 20, self.frame.size.width-20, 500) style:UITableViewStylePlain];
    self.notificationOptionsTable.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    [self.notificationOptionsTable setBackgroundColor:UIColorFromRGB(kBackgroundGreyColor)];
    [self.notificationOptionsTable setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    self.notificationOptionsTable.dataSource = self;
    self.notificationOptionsTable.delegate = self;
//    self.notificationOptionsTable.contentInset = UIEdgeInsetsZero;

    
    [self addSubview:self.notificationOptionsTable];
    
    
    cancel = [UIButton buttonWithType:UIButtonTypeCustom];
    cancel.layer.cornerRadius = 3.0f;
    [cancel setFrame:CGRectMake(20, self.frame.size.height -50-64, self.frame.size.width/2 -20, 50)];
    [cancel setBackgroundColor:UIColorFromRGB(0xEE365E)];
    [cancel setTitle:@"CANCEL" forState:UIControlStateNormal];
    cancel.titleLabel.font = [UIFont fontWithName:kMontserrat_Bold size:13.0f];
    [self addSubview:cancel];
    
    
    
    saveChanges = [UIButton buttonWithType:UIButtonTypeCustom];
    saveChanges.layer.cornerRadius = 3.0f;
    [saveChanges setFrame:CGRectMake(cancel.frame.origin.x + cancel.frame.size.width+10, cancel.frame.origin.y, cancel.frame.size.width, 50)];
    
    [saveChanges setBackgroundColor:UIColorFromRGB(0xEE365E)];
    [saveChanges setTitle:@"SAVE CHANGES" forState:UIControlStateNormal];
    [saveChanges setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    saveChanges.titleLabel.font = [UIFont fontWithName:kMontserrat_Bold size:13.0f];
    [self addSubview:saveChanges];
}


#pragma mark UITableView Delegate Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
        return 1;
//    return [self.notificationOptions count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 120.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.0f;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
//    return 1;
    return [self.notificationOptions count];
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:TRUE];
    [self cellSettingChange:indexPath.row];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier = @"NotificationCell";
    
    /*
    UITableViewCell *notificationCell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    [notificationCell setSelectionStyle:UITableViewCellSelectionStyleBlue];
    if(notificationCell == nil){
        notificationCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    [self couponDataView:notificationCell withNotificationDict:[self.notificationOptions objectAtIndex:indexPath.section]];
    
    notificationCell.layer.cornerRadius = 5.0f;
    [notificationCell setBackgroundColor:[UIColor whiteColor]];
    return notificationCell;
     */
    
    NotificationCell *notificationCell =  (NotificationCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    [notificationCell setSelectionStyle:UITableViewCellSelectionStyleBlue];
    if(notificationCell == nil){
        notificationCell = [[NotificationCell alloc] initWithFrame:CGRectMake(0, 0, notificationCell.frame.size.width, 120) andData:[self.notificationOptions objectAtIndex:indexPath.row]];
        notificationCell.cellDelegate = self;
        notificationCell.tag = indexPath.row;
    }
    return notificationCell;
}

- (void)couponDataView:(UITableViewCell *)notificationCell withNotificationDict:(NSMutableDictionary  *)notificationDict{
    
    
    
    UIButton *selectionButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    NSInteger index = [self.notificationOptions indexOfObject:notificationDict];

    selectionButton.tag  = index;
    [selectionButton setFrame:CGRectMake(5, 5, 25, 25)];
    [selectionButton setBackgroundColor:[UIColor clearColor]];
    if(![[notificationDict objectForKey:@"isSelected"] boolValue]){
        [selectionButton setBackgroundImage:[UIImage imageNamed:@"filter_unselected"] forState:UIControlStateNormal];
        [notificationCell setBackgroundColor:[UIColor whiteColor]];
    }
    else{
        [selectionButton setBackgroundImage:[UIImage imageNamed:@"filter_selected"] forState:UIControlStateNormal];
        [notificationCell setBackgroundColor:[UIColor redColor]];
    }
    
    [selectionButton addTarget:self action:@selector(notificationSettingsChange:) forControlEvents:UIControlEventTouchUpInside];
    
    [notificationCell.contentView addSubview:selectionButton];
    
    NSString *optionHeading = [[notificationDict allKeys] objectAtIndex:0];
    UILabel *heading = [SSUtility generateLabel:optionHeading withRect:CGRectMake(selectionButton.frame.origin.x + selectionButton.frame.size.width + 5, selectionButton.frame.origin.y, self.frame.size.width - selectionButton.frame.size.width - 10, 30) withFont:[UIFont fontWithName:kMontserrat_Bold size:15.0f]];
    [heading setBackgroundColor:[UIColor clearColor]];
    [heading setTextAlignment:NSTextAlignmentLeft];
    [notificationCell.contentView addSubview:heading];
    
    NSString *notificationDescriptionString = [notificationDict objectForKey:[[notificationDict allKeys] objectAtIndex:0]];
    CGSize aSize = [SSUtility getLabelDynamicSize:notificationDescriptionString withFont:[UIFont fontWithName:kMontserrat_Light size:15.0f] withSize:CGSizeMake(heading.frame.size.width-10, MAXFLOAT)];
    UILabel *notificationDescription = [SSUtility generateLabel:notificationDescriptionString withRect:CGRectMake(heading.frame.origin.x, heading.frame.origin.y + heading.frame.size.height + 5, aSize.width, aSize.height) withFont:[UIFont fontWithName:kMontserrat_Light size:15.0f]];
    [notificationDescription setTextAlignment:NSTextAlignmentLeft];
    [notificationDescription setNumberOfLines:0];
    [notificationCell.contentView addSubview:notificationDescription];
}



- (void)cellSettingChange:(NSInteger)cellTag{
    
    for(NSInteger counter=0; counter < [self.notificationOptions count]; counter++){
        
        NSMutableDictionary *currentDict = [self.notificationOptions objectAtIndex:counter];
        if(counter == cellTag){
            [currentDict setObject:[NSNumber numberWithBool:TRUE] forKey:@"isSelected"];
        }else{
            [currentDict setObject:[NSNumber numberWithBool:FALSE] forKey:@"isSelected"];
        }
    }
    
    [self.notificationOptionsTable reloadData];
}

- (void)notificationSettingsChange:(id)sender{
    UIButton *btn = (UIButton *)sender;
    
    for(NSInteger counter=0; counter < [self.notificationOptions count]; counter++){
        
        NSMutableDictionary *currentDict = [self.notificationOptions objectAtIndex:counter];
        if(counter == btn.tag){
            [currentDict setObject:[NSNumber numberWithBool:TRUE] forKey:@"isSelected"];
        }else{
            [currentDict setObject:[NSNumber numberWithBool:FALSE] forKey:@"isSelected"];
        }
    }
    
    [self.notificationOptionsTable reloadData];
    //     [btn setBackgroundImage:[UIImage imageNamed:@"filter_selected"] forState:UIControlStateNormal];
}


/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end
