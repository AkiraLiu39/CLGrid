//
//  CLGridTableItemView.h
//  CLGrid
//
//  Created by 刘昶 on 15/5/4.
//  Copyright (c) 2015年 unknown. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CLGridItemData.h"
typedef enum {
    CLGridItemViewBoarderTypeNone = 0,
    CLGridItemViewBoarderTypeLeft = 1,
    CLGridItemViewBoarderTypeRight = 1 << 1,
    CLGridItemViewBoarderTypeBottom = 1 << 2,
    CLGridItemViewBoarderTypeTop = 1 << 3
}CLGridItemViewBoarderType;

@protocol CLGridItemViewDelegate;

@interface CLGridItemView : UIButton
@property (nonatomic,strong) CLGridItemData *itemData;
@property (nonatomic,assign) CLGridItemViewBoarderType boarderType;
@property (nonatomic,assign) id<CLGridItemViewDelegate> itemDelegate;
@end

@protocol CLGridItemViewDelegate <NSObject>

@optional
-(void)gridItemDidClick:(CLGridItemView *)item atPath:(CLGridItemPath)path;

@end
