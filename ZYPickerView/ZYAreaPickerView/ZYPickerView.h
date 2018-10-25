//
//  ZYPickerView.h
//  ZYPickerView
//
//  Created by hfcb on 18/1/10.
//  Copyright © 2018年 张祎. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZYPickerView : UIView

/**
 *  初始化方法
 *  @return (ZYPickerView *)
 */
+ (ZYPickerView *)pickerView;

/**
 *  出现
 */
- (void)show;

/**
 *  隐藏
 */
- (void)hidden;

/**
 *  选择按钮点击
 */
@property (nonatomic, copy) void (^determinBlock) (NSString *);

@end
