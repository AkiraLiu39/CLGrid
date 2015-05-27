//
//  CLGridTableItemView.m
//  CLGrid
//
//  Created by 刘昶 on 15/5/4.
//  Copyright (c) 2015年 unknown. All rights reserved.
//

#import "CLGridItemView.h"
#import "CLGridItemData.h"
@interface CLGridItemView()

@end
@implementation CLGridItemView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        self.titleLabel.adjustsFontSizeToFitWidth = YES;
        [self addTarget:self action:@selector(onClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}
-(void)onClick{

    if ([self.itemDelegate respondsToSelector:@selector(gridItemDidClick:atPath:)]) {
        [self.itemDelegate gridItemDidClick:self atPath:self.itemData.itemPath];
    }
}
-(void)setItemData:(CLGridItemData *)itemData{
    _itemData = itemData;
    self.titleLabel.font = itemData.cellFont;
    self.titleLabel.textAlignment = itemData.cellTextAlignment;
    self.enabled = !itemData.disabled;
    [self setTitle:itemData.cellContent forState:UIControlStateNormal];
    [self setBackgroundColor:itemData.cellBackground];
    [self setTitleColor:itemData.cellTextNormalColor forState:UIControlStateNormal];
    [self setTitleColor:itemData.cellTextHighLightColor forState:UIControlStateHighlighted];
    [self setTitleColor:itemData.cellTextDisableColor forState:UIControlStateDisabled];
    
}

-(void)drawRect:(CGRect)rect{
    if (self.boarderType == CLGridItemViewBoarderTypeNone) {
        return;
    }

    CGContextRef context = UIGraphicsGetCurrentContext();
    if (self.backgroundColor) {
        [self.backgroundColor set];
    }else{
        [[UIColor whiteColor] set];
    }
    CGContextFillRect(context, rect);
    [[UIColor grayColor] set];
    CGContextSetLineWidth(context, 0.5f);
    if ((self.boarderType & CLGridItemViewBoarderTypeLeft) == CLGridItemViewBoarderTypeLeft) {
        CGContextMoveToPoint(context, 0, 0);
        CGContextAddLineToPoint(context, 0, rect.size.height);
    }
    if ((self.boarderType & CLGridItemViewBoarderTypeRight) == CLGridItemViewBoarderTypeRight) {
        CGContextMoveToPoint(context, rect.size.width, 0);
        CGContextAddLineToPoint(context, rect.size.width, rect.size.height);
    }
    if ((self.boarderType & CLGridItemViewBoarderTypeBottom) == CLGridItemViewBoarderTypeBottom ) {
        CGContextMoveToPoint(context, 0, rect.size.height);
        CGContextAddLineToPoint(context, rect.size.width, rect.size.height);
    }
    if ((self.boarderType & CLGridItemViewBoarderTypeTop) == CLGridItemViewBoarderTypeTop ) {
        CGContextMoveToPoint(context, 0, 0);
        CGContextAddLineToPoint(context, rect.size.width, 0);
    }
    CGContextStrokePath(context);
    
}

-(CGRect)titleRectForContentRect:(CGRect)contentRect{
    return CGRectMake(2.5, 0, CGRectGetWidth(contentRect) - 2 * 2.5, CGRectGetHeight(contentRect));
}
@end
