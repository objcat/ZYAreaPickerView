//
//  ZYAreaPickerView.m
//  ZYAreaPickerView
//
//  Created by 张祎 on 18/1/10.
//  Copyright © 2018年 objcat All rights reserved.
//

#import "ZYAreaPickerView.h"

@interface ZYAreaPickerView () <UIPickerViewDelegate, UIPickerViewDataSource>

/** 选择器 */
@property (strong, nonatomic) IBOutlet UIPickerView *pickerView;
/** 省 */
@property (nonatomic, strong) NSMutableArray *provinceArr;
/** 市 */
@property (nonatomic, strong) NSMutableArray *cityArr;
/** 区 */
@property (nonatomic, strong) NSMutableArray *areaArr;
/** 遮罩层 */
@property (nonatomic, weak) UIView *blockView;
/** 数据源 */
@property (nonatomic, strong) id responseObject;

@end

@implementation ZYAreaPickerView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

+ (ZYAreaPickerView *)pickerViewWithDeterminBlock:(void (^) (NSString *))determinBlock {
    
    ZYAreaPickerView *pickerView = [[[NSBundle mainBundle] loadNibNamed:@"ZYAreaPickerView" owner:nil options:nil] objectAtIndex:0];
    
    [pickerView setDeterminBlock:^(NSString *str) {
        determinBlock(str);
    }];
    
    pickerView.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width, 240);
    
    UIView *blockView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    blockView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0];
    blockView.hidden = YES;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:pickerView action:@selector(tapAction)];
    [blockView addGestureRecognizer:tap];
    
    pickerView.blockView = blockView;
    [pickerView.blockView addSubview:pickerView];
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:blockView];
    [window bringSubviewToFront:blockView];
    
    return pickerView;
}

- (void)tapAction {
    [self hidden];
}

- (void)awakeFromNib {
    
    [super awakeFromNib];
    //设置代理
    self.pickerView.delegate = self;
    self.pickerView.dataSource = self;
    NSString *path = [[NSBundle mainBundle] pathForResource:@"province" ofType:@"txt"];
    NSData *data = [NSData dataWithContentsOfFile:path];
    self.responseObject = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    //填充省市区
    self.provinceArr = self.responseObject;
    self.cityArr = self.provinceArr.count ?  self.responseObject[0][@"city"] : nil;
    self.areaArr = self.cityArr.count ? self.cityArr[0][@"area"] : nil;
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 3;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    
    switch (component) {
            
        case 0: {
            return self.provinceArr.count;
            break;
        }
            
        case 1: {
            return self.cityArr.count;
            break;
        }
            
        case 2: {
            
            return self.areaArr.count;
            break;
        }
            
        default:
            return 0;
            break;
    }
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
    
    UILabel *label = [[UILabel alloc] init];
    label.backgroundColor = [UIColor redColor];
    NSString *title;
    
    switch (component) {
        case 0: {
            NSDictionary *dic = self.provinceArr[row];
            title = dic[@"name"];
            break;
        }
        case 1: {
            NSDictionary *dic = self.cityArr[row];
            title = dic[@"name"];
            break;
        }
        case 2: {
            title = self.areaArr[row];
            break;
        }
        default:
            break;
    }
    
    label.text = title;
    label.font = [UIFont systemFontOfSize:13];
    label.textColor = [UIColor colorWithRed:121 / 255.0 green:124 / 255.0 blue:125 / 255.0 alpha:1];
    label.textAlignment = NSTextAlignmentCenter;
    label.adjustsFontSizeToFitWidth = YES;
    
    return label;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
    if (component == 0) {
        
        //获取当前省
        NSDictionary *provinceDic = self.provinceArr.count ? self.provinceArr[row] : nil;
        //获取市数组
        self.cityArr = provinceDic[@"city"];
        //获取第一个市
        NSDictionary *cityDic = self.cityArr.count ? self.cityArr[0] : nil;
        //获取区数组
        self.areaArr = cityDic[@"area"];
        
        //刷新数据 并初始化滚轮index
        [self.pickerView reloadAllComponents];
        [self.pickerView selectRow:0 inComponent:1 animated:NO];
        [self.pickerView selectRow:0 inComponent:2 animated:NO];
        
    } else if (component == 1) {
        
        //获取当前市
        NSDictionary *cityDic = self.cityArr.count ? self.cityArr[row] : nil;
        //获取区数组
        self.areaArr = cityDic[@"area"];
        //刷新数据 并初始化滚轮index
        [self.pickerView reloadComponent:2];
        [self.pickerView selectRow:0 inComponent:2 animated:NO];
        
    }
}

- (void)show {
    
    self.blockView.hidden = NO;
    [UIView animateWithDuration:0.25 animations:^{
        self.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height - 240, [UIScreen mainScreen].bounds.size.width, 240);
        self.blockView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.8];
    }];
}

- (void)hidden {
    
    [UIView animateWithDuration:0.25 animations:^{
        self.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width, 240);
        self.blockView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0];
    } completion:^(BOOL finished) {
        self.blockView.hidden = YES;
    }];
}

- (IBAction)cancelAction:(id)sender { [self hidden]; }

- (IBAction)determinBlock:(id)sender {
    
    if ([self anySubViewScrolling:self.pickerView]) {
        //滚动停止后才能进行选择
        return;
    }

    NSDictionary *provinceDic = self.provinceArr.count ?self.provinceArr[[self.pickerView selectedRowInComponent:0]] : nil;
    NSDictionary *cityDic = self.cityArr.count ? self.cityArr[[self.pickerView selectedRowInComponent:1]] : nil;
    NSString *areaStr = self.areaArr.count ? self.areaArr[[self.pickerView selectedRowInComponent:2]] : nil;
    NSString *resultStr = [NSString stringWithFormat:@"%@ %@ %@", provinceDic[@"name"], cityDic[@"name"], areaStr];
    self.determinBlock ? self.determinBlock(resultStr) : nil;
    [self hidden];
}

//判断是否在滚动
- (BOOL)anySubViewScrolling:(UIView *)view {
    
    if ([view isKindOfClass:[UIScrollView class]]) {
        UIScrollView *scrollView = (UIScrollView *)view;
        if (scrollView.dragging || scrollView.decelerating) {
            return YES;
        }
    }
    
    for (UIView *subView in view.subviews) {
        if ([self anySubViewScrolling:subView]) {
            return YES;
        }
    }
    
    return NO;
}

@end
