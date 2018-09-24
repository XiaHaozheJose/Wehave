//
//  WHTextView.m
//  Wehave
//
//  Created by JS_Coder on 2018/5/5.
//  Copyright © 2018年 浩哲 夏. All rights reserved.
//

#import "WHTextView.h"

#import <objc/runtime.h>
static const void *wh_placeHolderKey;

@interface UITextView ()
@property (nonatomic, readonly) UILabel *wh_placeHolderLabel;
@end

@implementation WHTextView

+(void)load{
    [super load];
    method_exchangeImplementations(class_getInstanceMethod(self.class, NSSelectorFromString(@"layoutSubviews")),
                                   class_getInstanceMethod(self.class, @selector(whPlaceHolder_swizzling_layoutSubviews)));
    method_exchangeImplementations(class_getInstanceMethod(self.class, NSSelectorFromString(@"dealloc")),
                                   class_getInstanceMethod(self.class, @selector(whPlaceHolder_swizzled_dealloc)));
    method_exchangeImplementations(class_getInstanceMethod(self.class, NSSelectorFromString(@"setText:")),
                                   class_getInstanceMethod(self.class, @selector(whPlaceHolder_swizzled_setText:)));
}
#pragma mark - swizzled
- (void)whPlaceHolder_swizzled_dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self whPlaceHolder_swizzled_dealloc];
}
- (void)whPlaceHolder_swizzling_layoutSubviews {
    if (self.wh_placeHolder) {
        UIEdgeInsets textContainerInset = self.textContainerInset;
        CGFloat lineFragmentPadding = self.textContainer.lineFragmentPadding;
        CGFloat x = lineFragmentPadding + textContainerInset.left + self.layer.borderWidth;
        CGFloat y = textContainerInset.top + self.layer.borderWidth;
        CGFloat width = CGRectGetWidth(self.bounds) - x - textContainerInset.right - 2*self.layer.borderWidth;
        CGFloat height = [self.wh_placeHolderLabel sizeThatFits:CGSizeMake(width, 0)].height;
        self.wh_placeHolderLabel.frame = CGRectMake(x, y, width, height);
    }
    [self whPlaceHolder_swizzling_layoutSubviews];
}
- (void)whPlaceHolder_swizzled_setText:(NSString *)text{
    [self whPlaceHolder_swizzled_setText:text];
    if (self.wh_placeHolder) {
        [self updatePlaceHolder];
    }
}

#pragma mark - associated
-(NSString *)wh_placeHolder{
    return objc_getAssociatedObject(self, &wh_placeHolderKey);
}

-(void)setwh_placeHolder:(NSString *)wh_placeHolder{
    objc_setAssociatedObject(self, &wh_placeHolderKey, wh_placeHolder, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self updatePlaceHolder];
}
-(UIColor *)wh_placeHolderColor{
    return self.wh_placeHolderLabel.textColor;
}
-(void)setwh_placeHolderColor:(UIColor *)wh_placeHolderColor{
    self.wh_placeHolderLabel.textColor = wh_placeHolderColor;
}
-(NSString *)placeholder{
    return self.wh_placeHolder;
}
-(void)setPlaceholder:(NSString *)placeholder{
    self.wh_placeHolder = placeholder;
}
#pragma mark - update
- (void)updatePlaceHolder{
    if (self.text.length) {
        [self.wh_placeHolderLabel removeFromSuperview];
        return;
    }
    self.wh_placeHolderLabel.font = self.font?self.font:self.cacutDefaultFont;
    self.wh_placeHolderLabel.textAlignment = self.textAlignment;
    self.wh_placeHolderLabel.text = self.wh_placeHolder;
    [self insertSubview:self.wh_placeHolderLabel atIndex:0];
}
#pragma mark - lazzing
-(UILabel *)wh_placeHolderLabel{
    UILabel *placeHolderLab = objc_getAssociatedObject(self, @selector(wh_placeHolderLabel));
    if (!placeHolderLab) {
        placeHolderLab = [[UILabel alloc] init];
        placeHolderLab.numberOfLines = 0;
        placeHolderLab.textColor = [UIColor lightGrayColor];
        objc_setAssociatedObject(self, @selector(wh_placeHolderLabel), placeHolderLab, OBJC_ASSOCIATION_RETAIN);
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updatePlaceHolder) name:UITextViewTextDidChangeNotification object:self];
    }
    return placeHolderLab;
}
- (UIFont *)cacutDefaultFont{
    static UIFont *font = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        UITextView *textview = [[UITextView alloc] init];
        textview.text = @" ";
        font = textview.font;
    });
    return font;
}


@end
