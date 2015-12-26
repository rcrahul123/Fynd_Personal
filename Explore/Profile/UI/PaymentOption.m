//
//  PaymentOption.m
//  Explore
//
//  Created by Amboj Goyal on 8/16/15.
//  Copyright (c) 2015 Rahul. All rights reserved.
//

#import "PaymentOption.h"

NSMutableArray *theDataArr;

@implementation PaymentOption

-(id)initWithFrame:(CGRect)frame dataDictionary:(NSMutableArray *)dataDict{
    self = [super initWithFrame:frame];
    if(self){
        [self setBackgroundColor:UIColorFromRGB(kBackgroundGreyColor)];
    }
    theDataArr = [self parseData:nil];
    
    
    [self confgiureThePatymentOptions];
//    questionFont =[UIFont fontWithName:kMontserrat_Regular size:12.0f];
//    answerFont =[UIFont fontWithName:kMontserrat_Light size:12.0f];
    return self;
}

-(void)confgiureThePatymentOptions{
    
    self.thePaymentOptionTableView = [[UITableView alloc] initWithFrame:CGRectMake(5, 5, self.frame.size.width - 10, self.frame.size.height - 70) style:UITableViewStylePlain];
    [self.thePaymentOptionTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    self.thePaymentOptionTableView.dataSource = self;
    self.thePaymentOptionTableView.delegate = self;
    [self.thePaymentOptionTableView setBackgroundColor:[UIColor clearColor]];
    [self addSubview:self.thePaymentOptionTableView];
    
}

#pragma mark - TableView Delegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 0;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return [theDataArr count];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return 0;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 50;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *theHeader = [[UIView alloc] initWithFrame:CGRectMake(10, 0, tableView.frame.size.width, [self tableView:tableView heightForHeaderInSection:section])];
    [theHeader setBackgroundColor:[UIColor whiteColor]];
    [theHeader.layer setCornerRadius:2.0f];
    
    
    UIImageView *optionImage = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, 100, 40)];
    [optionImage setBackgroundColor:[UIColor whiteColor]];
    NSString *urlString = [[theDataArr objectAtIndex:section] valueForKey:@"imageURL"];

    if (urlString && ![urlString isEqualToString:@""]) {
    NSURL *imageURL = [NSURL URLWithString:urlString];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
            
            NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
            
            dispatch_sync(dispatch_get_main_queue(), ^{
                [optionImage setImage:[UIImage imageWithData:imageData]];
            });
        });
        
    }

    
    [theHeader addSubview:optionImage];
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
    
    
    return cell;
}

-(NSMutableArray *)parseData:(NSArray *)theArray{
    NSMutableArray *faqArray = [[NSMutableArray alloc] init];
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"Payment" ofType:@"json"];
    NSData *data = [NSData dataWithContentsOfFile:path];
    NSArray *json_response = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
    
    
    
    
    for (int i=0; i<[json_response count]; i++) {
        NSMutableDictionary *qa = [[NSMutableDictionary alloc] init];
        [qa setObject:[[json_response objectAtIndex:i] valueForKey:@"name"] forKey:@"name"];
        [qa setObject:[[json_response objectAtIndex:i] valueForKey:@"imageURL"] forKey:@"imageURL"];
        [faqArray addObject:qa];
    }
    
    return faqArray;
}


@end
