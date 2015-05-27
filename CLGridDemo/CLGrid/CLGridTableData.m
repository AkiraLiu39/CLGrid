//
//  CLGridTableData.m
//  CLGrid
//
//  Created by 刘昶 on 15/4/27.
//  Copyright (c) 2015年 unknown. All rights reserved.
//

#import "CLGridTableData.h"
#import "CLGridTableRowData.h"
#import "CLGridHeaderItemData.h"

NSString *const CL_GRID_TABLE_DID_RELOAD_NOTIFICATION = @"CL_GRID_TABLE_WIDTH_CHANGE_NOTIFICATION";
NSString *const CL_GRID_TABLE_COLUMN_WIDTH_IN_USERINFO = @"CL_GRID_TABLE_WIDTH";
const float CL_GRID_TABLE_COLUMN_MIN_HORIZEON_MARGIN = 5.0f;
const float CL_GRID_TABLE_COLUMN_MIN_VERTICAL_MARGIN = 5.0f;
@interface CLGridTableData(){
    NSMutableArray *_horizeonHeaders;
    NSMutableArray *_verticalHeaders;
    NSMutableArray *_bodyRows;
    NSMutableArray *_colWidths;
    NSMutableArray *_verticalHeaderWidths;
}
@end
@implementation CLGridTableData

@synthesize horizeonHeaders = _horizeonHeaders;
@synthesize verticalHeaders = _verticalHeaders;
@synthesize bodyRows = _bodyRows;
@synthesize colWidths = _colWidths;
@synthesize rowWidth = _rowWidth;
@synthesize verticalHeaderWidths = _verticalHeaderWidths;
@synthesize verticalHeaderWidth = _verticalHeaderWidth;
@synthesize horizeonHeaderHeight =_horizeonHeaderHeight;


-(instancetype)init{
    if (self = [super init]) {
        _horizeonHeaders = [NSMutableArray array];
        _verticalHeaders = [NSMutableArray array];
        _bodyRows = [NSMutableArray array];
        _colWidths = [NSMutableArray array];
        _verticalHeaderWidths = [NSMutableArray array];
        self.tableCellFont = [UIFont systemFontOfSize:17];
        _cellHorizeonMargin = CL_GRID_TABLE_COLUMN_MIN_HORIZEON_MARGIN;
        _cellVerticalMargin = CL_GRID_TABLE_COLUMN_MIN_VERTICAL_MARGIN;
    }
    return self;
}
-(NSArray *)horizeonHeaders{
    return _horizeonHeaders.copy;
}
-(NSArray *)verticalHeaders{
    return _verticalHeaders.copy;
}
-(NSArray *)bodyRows{
    return _bodyRows.copy;
}
-(NSArray *)colWidths{
    return _colWidths.copy;
}
-(BOOL)isShowHorizeonHeader{
    return self.horizeonHeaders.count > 0;
}

-(void)setCellHorizeonMargin:(CGFloat)cellHorizeonMargin{
    _cellHorizeonMargin = cellHorizeonMargin;
    [_colWidths removeAllObjects];
    [_verticalHeaderWidths removeAllObjects];
    [self refreshAllRow];
}

-(void)setCellVerticalMargin:(CGFloat)cellVerticalMargin{
    _cellVerticalMargin = cellVerticalMargin;
    [self refreshAllRow];
}

-(CGFloat)totalWith{
    return self.rowWidth + self.verticalHeaderWidth;
}



-(void)refreshAllRow{
    if (self.horizeonHeaders.count) {
        _horizeonHeaderHeight = 0;
        for (CLGridTableRowData *row in self.horizeonHeaders) {
            [self refreshColumnWidth:row];
            _horizeonHeaderHeight += row.rowHeight;
        }
    }
    if (self.bodyRows.count) {
        _bodyHeight = 0;
        for (CLGridTableRowData *row in self.bodyRows) {
            [self refreshColumnWidth:row];
            _bodyHeight += row.rowHeight;
        }
        
    }
    if (self.verticalHeaders.count) {
        for (CLGridTableRowData *row in self.verticalHeaders) {
            [self refreshColumnHeaderWidth:row];
        }
    }
}

-(BOOL)isShowVerticalHeader{
    return self.verticalHeaders.count > 0;
}

-(void)addHorizeonHeader:(CLGridTableRowData *)row{
    row.rowNum = (int)self.verticalHeaders.count;
    [_horizeonHeaders addObject:row];
    [self refreshColumnWidth:row];
    
    _horizeonHeaderHeight += row.rowHeight;
}

-(void)addVerticalHeader:(CLGridTableRowData *)row{
    row.rowNum = (int)self.verticalHeaders.count;
    [_verticalHeaders addObject:row];
    [self refreshColumnHeaderWidth:row];
}

-(void)addRow:(CLGridTableRowData *)row{
    row.rowNum = (int)self.bodyRows.count;
    [_bodyRows addObject:row];
    [self refreshColumnWidth:row];
    
    _bodyHeight += row.rowHeight;
}

-(void)refreshColumnWidth:(CLGridTableRowData *)row{
    if (_colWidths.count) {
        [self updateColumnWidths:row];
    }else{
        [self initializtionColumnWidths:row];
    }
    CGFloat totalWidth = 0;
    for (NSNumber *number in self.colWidths) {
        totalWidth += [number floatValue];
    }
    _rowWidth = totalWidth;
}

-(void)refreshColumnHeaderWidth:(CLGridTableRowData *)row{
    if (_verticalHeaderWidths.count) {
        [self updateColumnHeaderWidth:row];
    }else{
        [self initializtionColumnHeaderWidth:row];
    }
    CGFloat totalWidth = 0;
    for (NSNumber *number in self.verticalHeaderWidths) {
        totalWidth += [number floatValue];
    }
    _verticalHeaderWidth = totalWidth;
    
}


-(void)updateColumnWidths:(CLGridTableRowData *)row{
    __block CGFloat maxRowHeight = 0;
    [self enumerateRowForCol:row useBlock:^(int index, CLGridItemData *col, BOOL *stop) {
        
        CGSize contentSize = [self gridCellContentSize:col];
        CGFloat contentHeight = contentSize.height;
        if (contentHeight > maxRowHeight) {
            maxRowHeight = contentHeight;
        }
        CGFloat contentWidth = contentSize.width;
        CGFloat oldWidth = [self.colWidths[index] floatValue];
        if ([col isMemberOfClass:[CLGridHeaderItemData class]]) {
            //tHeader 处理
            CLGridHeaderItemData *headerCol = (CLGridHeaderItemData *)col;
            CGFloat colSpan = headerCol.colSpan;
            if (colSpan) {
                CGFloat cellItemWidth = contentWidth / colSpan;
                for (int i = index; i< index + colSpan; i++) {
                    CGFloat itemOldWidth = [_colWidths[i]floatValue];
                    if (cellItemWidth > itemOldWidth) {
                        [_colWidths replaceObjectAtIndex:i withObject:@(cellItemWidth)];
                    }
                }
            } else if (headerCol.isEmptyItem) {
                //空格返回
                return ;
            }
        }
        if (contentWidth > oldWidth) {
            [_colWidths replaceObjectAtIndex:index withObject:@(contentWidth)];
        }
    }];
    row.rowHeight = maxRowHeight;
}

-(void)initializtionColumnWidths:(CLGridTableRowData *)row{
    __block CGFloat maxRowHeight = 0;
    [self enumerateRowForCol:row useBlock:^(int index, CLGridItemData *col, BOOL *stop) {
        CGSize contentSize = [self gridCellContentSize:col];
        CGFloat contentHeight = contentSize.height;
        if (contentHeight > maxRowHeight) {
            maxRowHeight = contentHeight;
        }
        CGFloat contentWidth = contentSize.width;
        if ([col isKindOfClass:[CLGridHeaderItemData class]]) {
            //tHeader 处理
            CLGridHeaderItemData *th = (CLGridHeaderItemData *)col;
            if (th.colSpan) {
                CGFloat cellWidth = contentWidth / th.colSpan;
                for (int i=0; i<th.colSpan; i++) {
                    [_colWidths addObject:@(cellWidth)];
                }
            }else if (!th.isEmptyItem){
                [_colWidths addObject:@(contentWidth)];
            }
        }else{
            [_colWidths addObject:@(contentWidth)];
        }
    }];
    row.rowHeight = maxRowHeight;
}

-(void)updateColumnHeaderWidth:(CLGridTableRowData *)row{
    [self enumerateRowForCol:row useBlock:^(int index, CLGridItemData *col, BOOL *stop) {
        CGSize contentSize = [self gridCellContentSize:col];
        CGFloat contentWidth = contentSize.width;
        contentWidth = [self adjustVertivalHeaderWidthWithWidth:contentWidth index:index];
        CGFloat oldWidth = [_verticalHeaderWidths[index] floatValue];
        if ([col isMemberOfClass:[CLGridHeaderItemData class]]) {
            //tHeader 处理
            CLGridHeaderItemData *headerCol = (CLGridHeaderItemData *)col;
            CGFloat colSpan = headerCol.colSpan;
            if (colSpan) {
                CGFloat cellItemWidth = contentWidth / colSpan;
                for (int i = index; i< index + colSpan; i++) {
                    CGFloat itemOldWidth = [_verticalHeaderWidths[i]floatValue];
                    if (cellItemWidth > itemOldWidth) {
                        [_verticalHeaderWidths replaceObjectAtIndex:i withObject:@(cellItemWidth)];
                    }
                }
            } else if (headerCol.isEmptyItem) {
                //空格返回
                return ;
            }
        }
        if (contentWidth > oldWidth) {
            [_verticalHeaderWidths replaceObjectAtIndex:index withObject:@(contentWidth)];
        }
    }];
}

-(void)initializtionColumnHeaderWidth:(CLGridTableRowData *)row{
    [self enumerateRowForCol:row useBlock:^(int index, CLGridItemData *col, BOOL *stop) {
        CGSize contentSize = [self gridCellContentSize:col];
        CGFloat contentWidth = contentSize.width;
        contentWidth = [self adjustVertivalHeaderWidthWithWidth:contentWidth index:index];
        if ([col isKindOfClass:[CLGridHeaderItemData class]]) {
            //tHeader 处理
            CLGridHeaderItemData *th = (CLGridHeaderItemData *)col;
            if (th.colSpan) {
                CGFloat cellWidth = contentWidth / th.colSpan;
                for (int i=0; i<th.colSpan; i++) {
                    [_verticalHeaderWidths addObject:@(cellWidth)];
                }
            }else if (!th.isEmptyItem){
                [_verticalHeaderWidths addObject:@(contentWidth)];
            }
        }
    }];
}


-(CGSize)gridCellContentSize:(CLGridItemData *)data{
    CGSize size = [data.cellContent sizeWithFont:data.cellFont?data.cellFont : (data.cellFont = self.tableCellFont)];
    size.height += 2 * self.cellVerticalMargin;
    size.width += 2 * self.cellHorizeonMargin;
    return size;
}

-(CGFloat)adjustVertivalHeaderWidthWithWidth:(CGFloat)width index:(int)index{
    CGFloat adJustedW = width;
    if (self.maxVerticalHeaderWidths.count && index < self.maxVerticalHeaderWidths.count) {
        CGFloat maxW = [self.maxVerticalHeaderWidths[index]floatValue] ;
        if (maxW > 0 && width > maxW) {
            adJustedW = maxW;
        }
    }
    return adJustedW;
}

-(void)enumerateRowForCol:(CLGridTableRowData *)row useBlock:(void (^)(int index,CLGridItemData *col,BOOL *stop))block{
    BOOL stop = false;
    if(!block || stop) return;
    NSArray *arr = row.cellDatas;
    for (int i=0; i<arr.count; i++) {
        CLGridItemData *item = arr[i];
        item.itemPath = CLGridItemPathMake(row.rowNum, i);
        block(i,arr[i],&stop);
    }
}

-(void)autoMarginCellHorizeonWithExpectWidth:(CGFloat)width{
    CGFloat totalMargin =  (self.colWidths.count  + self.verticalHeaderWidths.count ) * self.cellHorizeonMargin * 2;
    
    CGFloat contentOnlyW = self.totalWith - totalMargin;
    
    CGFloat margin = (width - contentOnlyW) / (self.colWidths.count  + self.verticalHeaderWidths.count ) / 2;
    if (margin > CL_GRID_TABLE_COLUMN_MIN_HORIZEON_MARGIN) {
        self.cellHorizeonMargin = margin;
    }else{
        self.cellHorizeonMargin = CL_GRID_TABLE_COLUMN_MIN_HORIZEON_MARGIN;
    }
    
    

}
@end
