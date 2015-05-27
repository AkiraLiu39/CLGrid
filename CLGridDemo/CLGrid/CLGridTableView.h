//
//  CLTableView.h
//  repoartTable
//
//  Created by 刘昶 on 15/4/24.
//  Copyright (c) 2015年 tpg. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CLGridTableData;
@class CLGridItemData;
@protocol CLGridTableViewDelegate;
@interface CLGridTableView : UIView
@property (nonatomic,strong) CLGridTableData *gridData;
@property (nonatomic,assign) BOOL showBoarder;
@property (nonatomic,weak) id<CLGridTableViewDelegate> gridDelegate;
@property (nonatomic,assign) BOOL bounces;
-(UITableView *)tableBody;
-(void)reloadGridData;
@end

@protocol CLGridTableViewDelegate <NSObject>

@optional
-(void)gridTable:(CLGridTableView *)grid horizeonHeaderItemDidClickAtPath:(NSIndexPath *)path;

-(void)gridTable:(CLGridTableView *)grid verticalHeaderItemDidClickAtPath:(NSIndexPath *)path;

-(void)gridTable:(CLGridTableView *)grid topLeftItemDidClickAtPath:(NSIndexPath *)path;

-(void)gridTable:(CLGridTableView *)grid gridTableItemDidClickAtPath:(NSIndexPath *)path;


@end
@interface NSIndexPath(CLGrid)
+(instancetype) indexPathWithRow:(int) rowNum col:(int)colNum;
@property (nonatomic,assign) int rowNum;
@property (nonatomic,assign) int colNum;
@end
