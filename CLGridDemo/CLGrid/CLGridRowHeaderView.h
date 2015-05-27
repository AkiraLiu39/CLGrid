//
//  CLGridRowHeaderView.h
//  CLGrid
//
//  Created by 刘昶 on 15/4/27.
//  Copyright (c) 2015年 unknown. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CLGridTableData;
@class CLGridTableView;
@interface CLGridRowHeaderView : UIView
@property (nonatomic,strong) CLGridTableData *gridData;

-(instancetype)initWithTable:(CLGridTableView *)table;

+(instancetype)headerWiethTable:(CLGridTableView *)table;
@end
