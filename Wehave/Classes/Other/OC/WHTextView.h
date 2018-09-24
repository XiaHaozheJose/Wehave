//
//  WHTextView.h
//  Wehave
//
//  Created by JS_Coder on 2018/5/5.
//  Copyright © 2018年 浩哲 夏. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WHTextView : UITextView
/**
 *  UITextView+placeholder
 */
@property (nonatomic, copy) NSString *wh_placeHolder;
/**
 *  Show
 */
@property (nonatomic, copy) NSString *placeholder;
/**
 *  PlaceHolder Color
 */
@property (nonatomic, strong) UIColor *wh_placeHolderColor;

@end
