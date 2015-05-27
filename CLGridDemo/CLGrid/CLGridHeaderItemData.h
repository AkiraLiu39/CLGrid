//
//  CLGridItemHeaderData.h
//  CLGrid
//
//  Created by 刘昶 on 15/4/27.
//  Copyright (c) 2015年 unknown. All rights reserved.
//

#import "CLGridItemData.h"


@interface CLGridHeaderItemData : CLGridItemData

@property (nonatomic,assign,getter=isEmptyItem) BOOL emptyItem;
@property (nonatomic,assign) unsigned int colSpan;
@property (nonatomic,assign) unsigned int rowSpan;
+(instancetype)emptyHeader;
@end
