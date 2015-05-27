//
//  CLGridColHeaderView.h
//  CLGrid
//
//  Created by 刘昶 on 15/4/27.
//  Copyright (c) 2015年 unknown. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CLGridTableView;
@class CLGridTableData;
@interface CLGridColHeaderView : UIScrollView
@property (nonatomic,strong) NSArray *headerRows;
@property (nonatomic,strong) CLGridTableData *gridData;
-(instancetype)initWithTable:(CLGridTableView *)table;
+(instancetype)headerWithTable:(CLGridTableView *)table;
@end
