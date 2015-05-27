//
//  CLGridColHeaderView.m
//  CLGrid
//
//  Created by 刘昶 on 15/4/27.
//  Copyright (c) 2015年 unknown. All rights reserved.
//

#import "CLGridColHeaderView.h"
#import "CLGridTableView.h"
#import "CLGridTableData.h"
#import "CLGridTableRowData.h"
#import "CLGridHeaderItemData.h"
#import "CLGridItemView.h"
@interface CLGridColHeaderView()
@property (nonatomic,weak) CLGridTableView *table;
@end
@implementation CLGridColHeaderView

-(instancetype)initWithTable:(CLGridTableView *)table{
    if (self = [super init]) {
        self.table = table;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateFrames:) name:CL_GRID_TABLE_DID_RELOAD_NOTIFICATION object:table];
    }
    return self;
}
+(instancetype)headerWithTable:(CLGridTableView *)table{
    return [[self alloc] initWithTable:table];
}
-(void)setGridData:(CLGridTableData *)gridData{
    if (self.gridData) {
        [[NSNotificationCenter defaultCenter]removeObserver:self];
        for (UIView *view in self.subviews) {
            [view removeFromSuperview];
        }
    }
    _gridData = gridData;
    if (gridData.verticalHeaders.count) {
        [self setupContent];
    }
}

-(void)setupContent{
    
    CGFloat y = 0;
    
    for (int tr=0; tr<self.gridData.verticalHeaders.count; tr++) {
        CGFloat x = 0;
        CLGridTableRowData *row = self.gridData.verticalHeaders[tr];
        CLGridTableRowData *bRow = self.gridData.bodyRows[tr];
        
        if (tr > 0) {
            CLGridTableRowData *pRow = self.gridData.bodyRows[tr - 1];
            y += pRow.rowHeight;
        }
        
        for (int td=0; td<row.cellDatas.count; td++) {
            CGFloat height = bRow.rowHeight;
            CLGridHeaderItemData *hData = row.cellDatas[td];
            NSArray *widths = self.gridData.verticalHeaderWidths;
            if (td > 0) {
                x += [widths[td - 1] floatValue];
            }
            if(hData.isEmptyItem) continue;
            CLGridItemView *header = [CLGridItemView new];
            
            CGFloat width = [widths[td] floatValue];

            
            int colSpan = hData.colSpan;
            int rowSpan = hData.rowSpan;
            if (colSpan > 1) {
                CGFloat tempWidth = 0;
                for (int i= td; i < td + colSpan; i ++) {
                    tempWidth += [widths[i] floatValue];
                }
                width = tempWidth;
            }
            if (rowSpan > 1) {
                CGFloat tempHeight = 0;
                for (int i = tr; i < tr + rowSpan; i ++) {
                    CLGridTableRowData *r = self.gridData.bodyRows[i];
                    tempHeight += r.rowHeight;
                }
                height = tempHeight;
            }
            
            header.frame = CGRectMake(x, y, width, height);
            header.boarderType = CLGridItemViewBoarderTypeBottom;
            
            if (self.table.showBoarder) {
                if (CGRectGetMaxX(header.frame) == self.gridData.verticalHeaderWidth) {
                    header.boarderType |=  CLGridItemViewBoarderTypeRight;
                }
                header.boarderType |= CLGridItemViewBoarderTypeLeft;
            }
            header.itemData = hData;
            [self addSubview:header];
        }
    }
}

-(void)updateFrames:(NSNotification *)noti{
    for (UIView *view in self.subviews) {
        [view removeFromSuperview];
    }
    [self setupContent];
    
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

@end
