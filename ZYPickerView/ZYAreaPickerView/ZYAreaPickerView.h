//
//  ZYAreaPickerView.h
//  ZYAreaPickerView
//
//  Created by 张祎 on 18/1/10.
//  Copyright © 2018年 objcat. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZYAreaPickerView : UIView

/**
 *  初始化方法
 *  请设置强引用属性否则会无法弹出picker
 *  @return (ZYPickerView *)
 */
+ (ZYAreaPickerView *)pickerViewWithDeterminBlock:(void (^) (NSString *))determinBlock;

/**
 *  显示
 */
- (void)show;

/**
 *  隐藏
 */
- (void)hidden;

/**
 *  点击确定
 */
@property (nonatomic, copy) void (^determinBlock) (NSString *);

@end
