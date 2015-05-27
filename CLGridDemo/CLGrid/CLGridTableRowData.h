//
//  CLGridTableRowData.h
//  CLGrid
//
//  Created by 刘昶 on 15/4/27.
//  Copyright (c) 2015年 unknown. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface CLGridTableRowData : NSObject
@property (nonatomic,assign) int rowNum;
//CLGridItemData or CLGridHeaderItemData array
@property (nonatomic,strong) NSArray *cellDatas;
@property (nonatomic,assign) CGFloat rowHeight;
@end
