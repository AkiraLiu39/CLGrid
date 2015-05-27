//
//  CLGridTableItemCell.m
//  CLGrid
//
//  Created by 刘昶 on 15/4/27.
//  Copyright (c) 2015年 unknown. All rights reserved.
//

#import "CLGridTableRowCell.h"
#import "CLGridTableRowData.h"
#import "CLGridItemView.h"
#import "CLGridTableData.h"
#import "CLGridTableView.h"
@interface CLGridTableRowCell()<CLGridItemViewDelegate>
@property (nonatomic,strong) NSMutableArray *itemCells;
@property (nonatomic,assign) BOOL showBoarder;
@property (nonatomic,weak) CLGridTableView *table;
@end;
@implementation CLGridTableRowCell

-(NSMutableArray *)itemCells{
    return _itemCells? _itemCells : (_itemCells = [NSMutableArray array]);
}
+(instancetype)cellWithTable:(CLGridTableView *)table data:(CLGridTableRowData *)data{
    static NSString *const cellId = @"CLGridRowCell";
    CLGridTableRowCell *cell = [table.tableBody dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[self alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.table = table;
        [cell setupContentItemCell:data width:table.gridData.colWidths];
    }
    cell.rowData = data;
    return cell;
}
-(void)setTable:(CLGridTableView *)table{
    _table = table;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateItemFrame:) name:CL_GRID_TABLE_DID_RELOAD_NOTIFICATION object:table];
}

-(void)setupContentItemCell:(CLGridTableRowData *)row width:(NSArray *)width{
    NSArray *items = row.cellDatas;
    int count = (int)items.count;
    for (int i=0; i<count; i++) {
        CLGridItemView *cellView = [CLGridItemView new];

        CGFloat newWidth = [width[i] floatValue];
        if (i == 0) {
            cellView.frame = CGRectMake(0, 0, newWidth, row.rowHeight);
        }else{
            CLGridItemView *pItemView = self.itemCells[i-1];
            CGFloat x = CGRectGetMaxX(pItemView.frame);
            cellView.frame = CGRectMake(x, 0, newWidth, row.rowHeight);
        }
        cellView.boarderType = CLGridItemViewBoarderTypeBottom;
        if (self.table.showBoarder) {
            if (i == items.count -1) {
                cellView.boarderType |= CLGridItemViewBoarderTypeLeft| CLGridItemViewBoarderTypeRight;
            }else{
                cellView.boarderType |= CLGridItemViewBoarderTypeLeft;
            }
        }
        cellView.itemDelegate = self;
        [self.contentView addSubview:cellView];
        [self.itemCells addObject:cellView];
    }
}

-(void)updateItemFrame:(NSNotification *)notification{
    NSArray *width = notification.userInfo[CL_GRID_TABLE_COLUMN_WIDTH_IN_USERINFO];
    
    for (int i=0; i<self.itemCells.count; i++) {
        CLGridItemView *itemView = self.itemCells[i];
        CGFloat newWidth = [width[i] floatValue];
        if (i == 0) {
            itemView.frame = CGRectMake(0, 0, newWidth, self.rowData.rowHeight);
        }else{
            CLGridItemView *pItemView = self.itemCells[i-1];
            CGFloat x = CGRectGetMaxX(pItemView.frame);
            itemView.frame = CGRectMake(x, 0, newWidth, self.rowData.rowHeight);
        }
    }
}


-(void)setRowData:(CLGridTableRowData *)rowData{
    _rowData = rowData;
    [self updateContentCells];
}
-(void)updateContentCells{
    for (int i=0; i<self.itemCells.count; i++) {
        CLGridItemView *itemView = self.itemCells[i];
        CLGridItemData *itemData = self.rowData.cellDatas[i];
        itemView.itemData = itemData;
    }
}

-(void)gridItemDidClick:(CLGridItemView *)item atPath:(CLGridItemPath)path{
    if ([self.table respondsToSelector:@selector(gridTableRowCell:DidClickItem:)]) {
        [(id<CLGridTableRowCellDelegate>)self.table gridTableRowCell:self DidClickItem:item];
    }
}


-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
