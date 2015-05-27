//
//  CLGridRowHeaderView.m
//  CLGrid
//
//  Created by 刘昶 on 15/4/27.
//  Copyright (c) 2015年 unknown. All rights reserved.
//

#import "CLGridRowHeaderView.h"
#import "CLGridTableData.h"
#import "CLGridItemView.h"
#import "CLGridHeaderItemData.h"
#import "CLGridTableRowData.h"
#import "CLGridTableView.h"
@interface CLGridRowHeaderView()
@property (nonatomic,weak) CLGridTableView *table;
@end
@implementation CLGridRowHeaderView
-(instancetype)initWithTable:(CLGridTableView *)table{
    if (self = [super init]) {
        self.table = table;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateFrames:) name:CL_GRID_TABLE_DID_RELOAD_NOTIFICATION object:table];
    }
    return self;
}

+(instancetype)headerWiethTable:(CLGridTableView *)table{
    return [[self alloc]initWithTable:table];
}
-(void)setGridData:(CLGridTableData *)gridData{
    if (self.gridData) {
        [[NSNotificationCenter defaultCenter]removeObserver:self];
        for (UIView *view in self.subviews) {
            [view removeFromSuperview];
        }
    }
    _gridData = gridData;
    if (gridData.horizeonHeaders.count) {
        [self setupContent];
    }
}

-(void)setupContent{
    
    
    CGFloat y = 0;
    
    for (int tr=0; tr<self.gridData.horizeonHeaders.count; tr++) {
        CGFloat x = 0;
        CLGridTableRowData *row = self.gridData.horizeonHeaders[tr];
        if (tr > 0) {
            CLGridTableRowData *pRow = self.gridData.horizeonHeaders[tr - 1];
            y += pRow.rowHeight;
        }
        
        for (int td=0; td<row.cellDatas.count; td++) {
            CLGridHeaderItemData *hData = row.cellDatas[td];
            NSArray *widths = self.gridData.colWidths;
            if (td > 0) {
                x += [widths[td - 1] floatValue];
            }
            if(hData.isEmptyItem) continue;
            CLGridItemView *header = [CLGridItemView new];
            
            CGFloat width = [widths[td] floatValue];
            CGFloat height = row.rowHeight;
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
                    CLGridTableRowData *r = self.gridData.horizeonHeaders[i];
                    tempHeight += r.rowHeight;
                }
                height = tempHeight;
            }
            
            header.frame = CGRectMake(x, y, width, height);
            header.boarderType = CLGridItemViewBoarderTypeBottom;
            
            if (self.table.showBoarder) {
                if (CGRectGetMaxX(header.frame) == self.gridData.rowWidth) {
                    header.boarderType |= CLGridItemViewBoarderTypeRight;
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
