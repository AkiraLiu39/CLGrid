//
//  CLGridItemHeaderData.m
//  CLGrid
//
//  Created by 刘昶 on 15/4/27.
//  Copyright (c) 2015年 unknown. All rights reserved.
//

#import "CLGridHeaderItemData.h"

@implementation CLGridHeaderItemData

-(instancetype)init{
    if (self = [super init]) {
        self.disabled = YES;
        self.rowSpan = 1;
    }
    return self;
}

+(instancetype)emptyHeader{
    static dispatch_once_t onceToken;
    static CLGridHeaderItemData *emptyHeader;
    dispatch_once(&onceToken, ^{
        CLGridHeaderItemData *header = [self new];
        header.emptyItem = YES;
        header.disabled = YES;
        emptyHeader = header;
    });
    return emptyHeader;
}

@end
