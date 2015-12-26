//
//  FilterModel.h
//  
//
//  Created by Rahul on 7/19/15.
//
//

#import <Foundation/Foundation.h>

@interface FilterOptionModel : NSObject

@property (nonatomic, assign) NSInteger index;
@property (nonatomic, strong) NSString *filterName;
@property (nonatomic, strong) NSString *filterValue;
@property (nonatomic, assign) BOOL isFilterSelected;
@property (nonatomic, strong) NSString *filterColorCode;
@property (nonatomic)NSInteger count;
@property (nonatomic, assign) BOOL shouldShowColorCode;

-(id)initWithDictionary:(NSDictionary *)filterOptionDictionary forIndex:(NSInteger)index;

@end


@interface FilterModel : NSObject

@property (nonatomic, strong) NSString *displayName;
@property (nonatomic, strong) NSString *filterType;
@property (nonatomic, strong) NSMutableArray *filterOptions;
@property (nonatomic, assign) BOOL isAnyValueSelected;

-(id)initWithDictionary:(NSDictionary *)filterDataDict;
@end
