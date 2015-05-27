//
//  CLGridTableData.h
//  CLGrid
//
//  Created by 刘昶 on 15/4/27.
//  Copyright (c) 2015年 unknown. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@class CLGridTableRowData;
@class CLGridItemData;
FOUNDATION_EXPORT const float CL_GRID_TABLE_COLUMN_MIN_HORIZEON_MARGIN;
FOUNDATION_EXPORT const float CL_GRID_TABLE_COLUMN_MIN_VERTICAL_MARGIN;
FOUNDATION_EXPORT NSString *const CL_GRID_TABLE_DID_RELOAD_NOTIFICATION;
FOUNDATION_EXPORT NSString *const CL_GRID_TABLE_COLUMN_WIDTH_IN_USERINFO;
@interface CLGridTableData : NSObject

@property (nonatomic,assign,getter=isShowHorizeonHeader) BOOL showHorizeonHeader;

@property (nonatomic,assign,getter=isShowVerticalHeader) BOOL showVerticalHeader;
//CLGridTableRowData array
@property (nonatomic,strong,readonly) NSArray *horizeonHeaders;
//CLGridTableRowData array
@property (nonatomic,strong,readonly) NSArray *verticalHeaders;
//tbody 行 CLGridTableRowData array
@property (nonatomic,strong,readonly) NSArray *bodyRows;
//每列宽度 NSNumber array
@property (nonatomic,strong,readonly) NSArray *colWidths;

@property (nonatomic,strong) UIFont *tableCellFont;

//每行内容总宽度(排除列头)
@property (nonatomic,assign,readonly) CGFloat rowWidth;
//列头总宽度
@property (nonatomic,assign,readonly) CGFloat verticalHeaderWidth;
//列头每列宽度 NSNumber array
@property (nonatomic,strong,readonly) NSArray *verticalHeaderWidths;

@property (nonatomic,assign,readonly) CGFloat horizeonHeaderHeight;

@property (nonatomic,assign,readonly) CGFloat bodyHeight;
//每行总宽度 (包括列头宽度)
@property (nonatomic,assign,readonly) CGFloat totalWith;
//单元格单边垂直间距 默认 5
@property (nonatomic,assign) CGFloat cellVerticalMargin;
//单元格单边水平间距 默认 10
@property (nonatomic,assign) CGFloat cellHorizeonMargin;
//表格左上角单元格数据
@property (nonatomic,strong) CLGridItemData *leftTopItemData;

@property (nonatomic,strong) NSArray *maxVerticalHeaderWidths;

-(void)addHorizeonHeader:(CLGridTableRowData *)row;

-(void)addVerticalHeader:(CLGridTableRowData *)row;

-(void)addRow:(CLGridTableRowData *)row;

-(void)autoMarginCellHorizeonWithExpectWidth:(CGFloat)width;
@end
