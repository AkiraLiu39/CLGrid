//
//  ViewController.h
//  CLGridDemo
//
//  Created by 刘昶 on 15/5/27.
//  Copyright (c) 2015年 unknown. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    DemoGridTypeSimple = 0,
    DemoGridTypeHeader = 1,
    DemoGridTypeHeaderSpan = 2
} DemoGridType;

@interface GridDemoController : UIViewController

@property (nonatomic,assign) DemoGridType demoType;

@end

