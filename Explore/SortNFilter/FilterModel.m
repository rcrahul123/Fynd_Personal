//
//  FilterModel.m
//  
//
//  Created by Rahul on 7/19/15.
//
//

#import "FilterModel.h"

@implementation FilterOptionModel

-(id)initWithDictionary:(NSDictionary *)filterOptionDictionary forIndex:(NSInteger)index{
    self = [super init];
    if(self){
        self.index = index;
        self.count = [filterOptionDictionary[@"count"] integerValue];
        self.filterName = filterOptionDictionary[@"display"];
        self.filterValue = [filterOptionDictionary[@"value"] stringByRemovingPercentEncoding];
        self.isFilterSelected = [filterOptionDictionary[@"is_selected"] boolValue];
        self.filterColorCode = filterOptionDictionary[@"value"];
    }
    return self;
}

@end

@implementation FilterModel

-(id)initWithDictionary:(NSDictionary *)filterDataDict{
    self = [super init];
   
    if(self){
        self.isAnyValueSelected = FALSE;
        NSDictionary *keyData = filterDataDict[@"key"];
        self.displayName = keyData[@"display"];
        self.filterType = keyData[@"name"];
        self.filterOptions = [[NSMutableArray alloc] initWithCapacity:[[filterDataDict objectForKey:@"values"] count]];
        
        for(int i = 0; i < [[filterDataDict objectForKey:@"values"] count]; i++){
            FilterOptionModel *option = [[FilterOptionModel alloc] initWithDictionary:[[filterDataDict objectForKey:@"values"] objectAtIndex:i] forIndex:i];
            if([self.filterType isEqualToString:@"color"]){
                option.shouldShowColorCode = true;
            }else{
                option.shouldShowColorCode = false;
            }
            if(option.isFilterSelected){
                self.isAnyValueSelected = TRUE;
            }
            [self.filterOptions addObject:option];
        }
    }
    return self;
}
@end
