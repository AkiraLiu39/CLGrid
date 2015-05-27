//
//  CLTableView.m
//  repoartTable
//
//  Created by 刘昶 on 15/4/24.
//  Copyright (c) 2015年 tpg. All rights reserved.
//

#import <objc/runtime.h>
#import "CLGridTableView.h"
#import "CLGridRowHeaderView.h"
#import "CLGridColHeaderView.h"
#import "CLGridTableData.h"
#import "CLGridTableRowCell.h"
#import "CLGridTableRowData.h"
#import "CLGridColHeaderView.h"
#import "CLGridRowHeaderView.h"
#import "CLGridItemView.h"
#import "CLGridItemData.h"
@interface CLGridTableView()<UITableViewDataSource,UITableViewDelegate,CLGridTableRowCellDelegate>
@property (nonatomic,weak) UIScrollView *horizonScrollView;
@property (nonatomic,weak) UITableView *tableBody;
@property (nonatomic,weak) CLGridColHeaderView *columnHeader;
@property (nonatomic,weak) CLGridRowHeaderView *rowHeader;
@property (nonatomic,weak) CLGridItemView *leftTopItem;

@end
@implementation CLGridTableView


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self setupTableContent];
        [self setupTableHorizeonHeader];
        [self setupTableVerticalHeader];
        [self setupLeftTopItem];
        
    }
    return self;
}

-(void)setBounces:(BOOL)bounces{
    _bounces = bounces;
    self.columnHeader.bounces = bounces;
    self.tableBody.bounces = bounces;
    self.horizonScrollView.bounces = bounces;
}
-(void)setGridData:(CLGridTableData *)gridData{
    _gridData = gridData;
//    [self reloadGridData];
    self.rowHeader.gridData = gridData;
    self.columnHeader.gridData = gridData;
    self.leftTopItem.itemData = gridData.leftTopItemData;
    
}
-(void)reloadGridData{
    [self.tableBody reloadData];
    [self updateFrames];
    [[NSNotificationCenter defaultCenter]postNotificationName:CL_GRID_TABLE_DID_RELOAD_NOTIFICATION
                                                       object:self
                                                     userInfo:@{CL_GRID_TABLE_COLUMN_WIDTH_IN_USERINFO : self.gridData.colWidths}];
    
}


-(id)initWithCoder:(NSCoder *)aDecoder{
    if(self = [super initWithCoder:aDecoder]){
    
    }
    return self;
}

-(void)setupTableHorizeonHeader{
    CLGridRowHeaderView *header = [CLGridRowHeaderView headerWiethTable:self];
    [self.horizonScrollView addSubview:header];
    self.rowHeader = header;
}

-(void)setupTableVerticalHeader{
    CLGridColHeaderView *header = [CLGridColHeaderView headerWithTable:self];
    header.delegate = self;
    header.showsVerticalScrollIndicator = NO;
    [self addSubview:header];
    self.columnHeader = header;
}

-(void)setupTableContent{
    UIScrollView *scrollView = [UIScrollView new];
    scrollView.showsHorizontalScrollIndicator = NO;
    [self addSubview:scrollView];
    self.horizonScrollView = scrollView;
    
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.delegate = self;
    tableView.dataSource = self;
    
    
    [self.horizonScrollView addSubview:tableView];
    self.tableBody = tableView;
    
}

-(void)setupLeftTopItem{
    CLGridItemView *leftTop = [CLGridItemView new];
    leftTop.boarderType = CLGridItemViewBoarderTypeBottom;
    
    [self addSubview:leftTop];
    self.leftTopItem = leftTop;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView reloadData];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CLGridTableRowData *row = self.gridData.bodyRows[indexPath.row];
    return row.rowHeight;
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat offsetY = scrollView.contentOffset.y;
    
    if (scrollView == self.columnHeader) {
        CGPoint p = self.tableBody.contentOffset;
        p.y = offsetY;
        self.tableBody.contentOffset = p;
    }else if (scrollView == self.tableBody){
        CGPoint p = self.columnHeader.contentOffset;
        p.y = offsetY;
        self.columnHeader.contentOffset = p;
    }
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.gridData.bodyRows.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    CLGridTableRowCell *cell = [CLGridTableRowCell cellWithTable:self data:self.gridData.bodyRows[indexPath.row]];
    return cell;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    [self updateFrames];
}

-(void)setShowBoarder:(BOOL)showBoarder{
    _showBoarder = showBoarder;
    if (self.showBoarder) {
        self.leftTopItem.boarderType |= CLGridItemViewBoarderTypeRight;
        self.layer.borderColor = [UIColor lightGrayColor].CGColor;
        self.layer.masksToBounds = YES;
        self.layer.cornerRadius = 3.0f;
        self.layer.borderWidth = 0.5f;
    }else{
        self.leftTopItem.boarderType ^= CLGridItemViewBoarderTypeRight;
    }
}

-(void)updateFrames{
    CGFloat vHeaderWidth = self.gridData.verticalHeaderWidth;
    CGFloat hHeaderHeight = self.gridData.horizeonHeaderHeight;

    self.horizonScrollView.frame = CGRectMake(vHeaderWidth, 0, self.bounds.size.width - vHeaderWidth, self.bounds.size.height);
    self.tableBody.frame = CGRectMake(0, hHeaderHeight, self.gridData.rowWidth, self.bounds.size.height - hHeaderHeight);
    
    self.rowHeader.frame = CGRectMake(0, 0, self.gridData.rowWidth, hHeaderHeight);
    self.columnHeader.frame = CGRectMake(0, hHeaderHeight, vHeaderWidth, CGRectGetHeight(self.tableBody.frame));
    
    CGSize hContentSize = self.horizonScrollView.contentSize;
    hContentSize.width = self.gridData.rowWidth;
    self.horizonScrollView.contentSize = hContentSize;
    self.columnHeader.contentSize = CGSizeMake(0, self.gridData.bodyHeight);
    
    self.leftTopItem.frame = CGRectMake(0, 0, vHeaderWidth, hHeaderHeight);
    
}

-(void)gridTableRowCell:(CLGridTableRowCell *)cell DidClickItem:(CLGridItemView *)itemView{
    if ([self.gridDelegate respondsToSelector:@selector(gridTable:gridTableItemDidClickAtPath:)]) {
        CLGridItemPath path = itemView.itemData.itemPath;
        NSIndexPath *index = [NSIndexPath indexPathWithRow:path.rowNum col:path.colNum];
        [self.gridDelegate gridTable:self gridTableItemDidClickAtPath:index];
    }
}


@end


@implementation NSIndexPath(CLGrid)
static const char  rowNumKey;
static const char  colNumKey;
-(int)rowNum{
    id rowNum = objc_getAssociatedObject(self, &rowNumKey);
    return  rowNum ? [rowNum intValue] : 0;
}
-(int)colNum{
    id colNum = objc_getAssociatedObject(self, &colNumKey);
    return  colNum ? [colNum intValue] : 0;
}
-(void)setRowNum:(int)rowNum{
    objc_setAssociatedObject(self, &rowNumKey, @(rowNum), OBJC_ASSOCIATION_ASSIGN);
}
-(void)setColNum:(int)colNum{
    objc_setAssociatedObject(self, &colNumKey, @(colNum), OBJC_ASSOCIATION_ASSIGN);
}

+(instancetype)indexPathWithRow:(int)rowNum col:(int)colNum{
    NSIndexPath *index = [NSIndexPath new];
    index.rowNum = rowNum;
    index.colNum = colNum;
    return index;
}

@end
