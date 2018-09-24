//
//  WHMuiltipleGestureTableView.m
//  Wehave
//
//  Created by 浩哲 夏 on 2018/2/22.
//  Copyright © 2018年 浩哲 夏. All rights reserved.
//

#import "WHMuiltipleGestureTableView.h"

@implementation WHMuiltipleGestureTableView

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

@end
