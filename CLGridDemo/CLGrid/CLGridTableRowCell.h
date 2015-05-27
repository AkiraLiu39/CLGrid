//
//  CLGridTableItemCell.h
//  CLGrid
//
//  Created by 刘昶 on 15/4/27.
//  Copyright (c) 2015年 unknown. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CLGridTableRowData;
@class CLGridTableView;
@class CLGridItemView;
@interface CLGridTableRowCell : UITableViewCell
+(instancetype)cellWithTable:(CLGridTableView *)table data:(CLGridTableRowData *)data;
@property (nonatomic,strong) CLGridTableRowData *rowData;
@end

@protocol CLGridTableRowCellDelegate <NSObject>

@optional
-(void)gridTableRowCell:(CLGridTableRowCell *)cell DidClickItem:(CLGridItemView *)itemView;

@end
