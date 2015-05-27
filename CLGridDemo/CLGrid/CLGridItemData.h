//
//  CLGridItemData.h
//  CLGrid
//
//  Created by 刘昶 on 15/4/27.
//  Copyright (c) 2015年 unknown. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
typedef struct {
    int rowNum;
    int colNum;
}CLGridItemPath;

static inline CLGridItemPath CLGridItemPathMake(int row,int col){
    CLGridItemPath path;
    path.rowNum = row;
    path.colNum = col;
    return path;
}
@interface CLGridItemData : NSObject
@property (nonatomic,assign) CLGridItemPath itemPath;
@property (nonatomic,strong) UIColor *cellBackground;
@property (nonatomic,strong) UIFont *cellFont;
@property (nonatomic,copy) NSString *cellContent;
@property (nonatomic,strong) UIColor *cellTextNormalColor;
@property (nonatomic,strong) UIColor *cellTextDisableColor;
@property (nonatomic,strong) UIColor *cellTextHighLightColor;

@property (nonatomic,assign) BOOL disabled;

@property (nonatomic,assign) NSTextAlignment cellTextAlignment;

-(instancetype)initWithCellContent:(NSString *)content;
+(instancetype)itemWithCellContent:(NSString *)content;
@end
