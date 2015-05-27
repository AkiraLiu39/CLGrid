//
//  ViewController.m
//  CLGridDemo
//
//  Created by 刘昶 on 15/5/27.
//  Copyright (c) 2015年 unknown. All rights reserved.
//

#import "GridDemoController.h"
#import "CLGrid.h"
@interface GridDemoController ()<CLGridTableViewDelegate>
@property (nonatomic,weak) CLGridTableView *gridTable;
@end

@implementation GridDemoController


-(CLGridTableView *)gridTable{
    if (!_gridTable) {
        CLGridTableView *grid = [CLGridTableView new];
        grid.gridDelegate = self;
        grid.showBoarder = YES;
        grid.layer.masksToBounds = YES;
        grid.layer.cornerRadius = 5.0f;
        grid.layer.borderColor = [UIColor lightGrayColor].CGColor;
        grid.layer.borderWidth = 0.5f;
        [self.view addSubview:grid];
        _gridTable = grid;
    }
    
   return _gridTable;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    if ([UIDevice currentDevice].systemVersion.floatValue >= 7.0) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
//
    self.gridTable.gridData = [self gridData];
    
    CGFloat padding = 10.0f;
    self.gridTable.frame = CGRectMake(padding, padding, CGRectGetWidth(self.view.frame) - 2 * padding,400);
    
    
}


-(CLGridTableData *)gridData{
    int row = 40;
    int col = 10;
    int colHeaderCount = 2;
    CLGridTableData *data = [self fakeDataWithRowCount:row ColCount:col];
    CLGridItemData *topLeft = [CLGridItemData itemWithCellContent:self.title];
    topLeft.cellTextAlignment = NSTextAlignmentCenter;
    data.leftTopItemData = topLeft;
    
    if (self.demoType == DemoGridTypeHeader) {
        [data addHorizeonHeader:[self fakeRowSimpleHeaderWithColCount:col]];
        NSArray *colHeaders = [self fakeColSimpleHeaderWithRowCount:row headerColCount:colHeaderCount];
        for (CLGridTableRowData *colH in colHeaders) {
            [data addVerticalHeader:colH];
        }
    }else if (self.demoType == DemoGridTypeHeaderSpan){
        NSArray *rowHeaders = [self fakeRowSpanHeaderWithHeaderRowCount:2 ColCount:col];
        NSArray *colHeaders = [self fakeColSpanHeaderWithHeaderRowCount:row colCount:colHeaderCount];
        for (CLGridTableRowData *rowH in rowHeaders) {
            [data addHorizeonHeader:rowH];
        }
        
        for (CLGridTableRowData *colH in colHeaders) {
            [data addVerticalHeader:colH];
        }
    }
    
    
    
    
    return data;
    
}


-(CLGridTableRowData *)fakeRowSimpleHeaderWithColCount:(int)col{
    CLGridTableRowData *row = [CLGridTableRowData new];
    NSMutableArray *tds = [NSMutableArray array];
    for (int i=0; i<col; i++) {
        NSString *title = [NSString stringWithFormat:@"RH %i",i];
        CLGridHeaderItemData *headerItem = [CLGridHeaderItemData itemWithCellContent:title];
        headerItem.cellTextAlignment = NSTextAlignmentCenter;
        headerItem.cellTextNormalColor = [UIColor redColor];
        [tds addObject:headerItem];
    }
    row.cellDatas = tds.copy;
    return row;
}


-(NSArray *)fakeColSimpleHeaderWithRowCount:(int)row headerColCount:(int)headerCol{
    
    NSMutableArray *headers = [NSMutableArray array];
    for (int i=0; i<row; i++) {
        NSMutableArray *tds = [NSMutableArray array];
        CLGridTableRowData *row = [CLGridTableRowData new];
        
        for (int j =0; j<headerCol; j++) {
            NSString *str = [NSString stringWithFormat:@"CH %i-%i",i,j];
            CLGridHeaderItemData *headerItem = [CLGridHeaderItemData itemWithCellContent:str];
            headerItem.cellTextNormalColor = [UIColor orangeColor];
            [tds addObject:headerItem];
        }
        
        
        row.cellDatas = tds.copy;
        [headers addObject:row];
    }
    return headers;
}


-(CLGridTableData *)fakeDataWithRowCount:(int)row ColCount:(int)col{
    CLGridTableData *table = [CLGridTableData new];
    table.tableCellFont = [UIFont systemFontOfSize:13];

    for (int tr=0; tr<row; tr++) {
        CLGridTableRowData *row = [CLGridTableRowData new];
        NSMutableArray *tds = [NSMutableArray array];
        for (int td = 0; td< col; td++) {
            CLGridItemData *item = [CLGridItemData itemWithCellContent:[self randomStrWithLength:10]];
            item.cellTextAlignment = NSTextAlignmentCenter;
            item.cellTextHighLightColor = [UIColor blueColor];
            [tds addObject:item];
        }
        row.cellDatas = tds.copy;
        [table addRow:row];
    }
    return table;
}

-(NSArray *)fakeRowSpanHeaderWithHeaderRowCount:(int)headerRowCount ColCount:(int)col{
    NSMutableArray *headers = [NSMutableArray array];
    for (int i=0; i<headerRowCount; i++) {
        NSMutableArray *tds = [NSMutableArray array];
        CLGridTableRowData *row = [CLGridTableRowData new];
        
        for (int j =0; j<col; j++) {
            CLGridHeaderItemData *headerItem;
            NSString *str = [NSString stringWithFormat:@"RH %i-%i",i,j];
            if (i == 0) {
                // first row
                if (j == 0) {
                    headerItem = [CLGridHeaderItemData itemWithCellContent:str];
                    headerItem.colSpan = col;
                }else{
                    headerItem = [CLGridHeaderItemData emptyHeader];
                }
            }else{
                headerItem = [CLGridHeaderItemData itemWithCellContent:str];
            }
            headerItem.cellTextNormalColor = [UIColor redColor];
            [tds addObject:headerItem];
            
        }
        
        
        row.cellDatas = tds.copy;
        [headers addObject:row];
    }
    return headers;
}


-(NSArray *)fakeColSpanHeaderWithHeaderRowCount:(int)headerRowCount colCount:(int)col{
    NSMutableArray *headers = [NSMutableArray array];
    for (int i=0; i<headerRowCount; i++) {
        NSMutableArray *tds = [NSMutableArray array];
        CLGridTableRowData *row = [CLGridTableRowData new];
        
        for (int j =0; j<col; j++) {
            CLGridHeaderItemData *headerItem;
            NSString *str = [NSString stringWithFormat:@"CH %i-%i",i,j];
            if (i == 0) {
                //first row
                headerItem = [CLGridHeaderItemData itemWithCellContent:str];
                if (j == 0) {
                    headerItem.rowSpan = headerRowCount;
                }
            }else{
                if (j == 0) {
                    headerItem = [CLGridHeaderItemData emptyHeader];
                }else{
                    headerItem = [CLGridHeaderItemData itemWithCellContent:str];
                }
            }
            headerItem.cellTextNormalColor = [UIColor orangeColor];
            [tds addObject:headerItem];
            
        }
        
        
        row.cellDatas = tds.copy;
        [headers addObject:row];
    }
    return headers;
}

-(NSString *)randomStrWithLength:(int)length{
    int l = 1 + arc4random_uniform(length - 1);
    char data[l];
    for (int i=0; i<l; i++) {
        data[i] = (char)('A' + (arc4random_uniform(26)));
    }
    return [[NSString alloc]initWithBytes:data length:l encoding:NSUTF8StringEncoding];
}


-(void)gridTable:(CLGridTableView *)grid gridTableItemDidClickAtPath:(NSIndexPath *)path{
    NSLog(@"grid item clicked at row : %i , col : %i",path.rowNum,path.colNum);
}
-(void)dealloc{
    NSLog(@"<%@,%p> dealloc",self.class,self);
}

@end
