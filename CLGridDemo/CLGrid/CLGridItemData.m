//
//  CLGridItemData.m
//  CLGrid
//
//  Created by 刘昶 on 15/4/27.
//  Copyright (c) 2015年 unknown. All rights reserved.
//

#import "CLGridItemData.h"

@implementation CLGridItemData


-(instancetype)init{
    if (self = [super init]) {
        self.cellBackground = [UIColor whiteColor];
        self.cellTextNormalColor = [UIColor blackColor];
    }
    return self;
}
-(instancetype)initWithCellContent:(NSString *)content{
    if (self = [self init]) {
        self.cellContent = content;
    }
    return self;
}
+(instancetype)itemWithCellContent:(NSString *)content{
    return [[self alloc]initWithCellContent:content];
}
@end
