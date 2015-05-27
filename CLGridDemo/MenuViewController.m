//
//  MenuViewController.m
//  CLGridDemo
//
//  Created by 刘昶 on 15/5/27.
//  Copyright (c) 2015年 unknown. All rights reserved.
//

#import "MenuViewController.h"
#import "GridDemoController.h"
@interface MenuViewController ()

@end

@implementation MenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSString *title =  segue.identifier;
    GridDemoController *ctrl = segue.destinationViewController;
    ctrl.title = title;
    DemoGridType type = DemoGridTypeSimple;
    if ([@"header" isEqualToString:title]) {
        type = DemoGridTypeHeader;
    }else if ([@"headerSpan" isEqualToString:title]){
        type = DemoGridTypeHeaderSpan;
    }
    ctrl.demoType = type;
}


@end
