//
//  ZYPickerView.m
//  ZYPickerView
//
//  Created by hfcb on 18/1/10.
//  Copyright © 2018年 张祎. All rights reserved.
//

#import "ZYPickerView.h"
#import "RequestFromServer.h"
#import <MJExtension.h>

@interface ZYPickerView () <UIPickerViewDelegate, UIPickerViewDataSource>
@property (strong, nonatomic) IBOutlet UIPickerView *pickerView;
@property (nonatomic, strong) NSMutableArray *provinceArr;
@property (nonatomic, strong) NSMutableArray *cityArr;
@property (nonatomic, strong) NSMutableArray *areaArr;
@property (nonatomic, strong) id responseObject;
@property (nonatomic, weak) UIView *blockView;
@end

@implementation ZYPickerView

+ (ZYPickerView *)pickerView {
    
    ZYPickerView *pickerView = [[[NSBundle mainBundle] loadNibNamed:@"ZYPickerView" owner:nil options:nil] objectAtIndex:0];
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
    
    self.pickerView.delegate = self;
    self.pickerView.dataSource = self;
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"province" ofType:@"txt"];
    NSData *data = [NSData dataWithContentsOfFile:path];
    self.responseObject = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    
    //填充省市区
    self.provinceArr = self.responseObject;
    self.cityArr = self.responseObject[0][@"city"];
    self.areaArr = self.responseObject[0][@"city"][0][@"area"];
    
    NSString *requestURL = [NSString stringWithFormat:@"http:192.168.1.8:8888/app/area/queryArea?token=5eebfdb57dd6437687f2c857843aa54e"];
    [RequestFromServer GET:requestURL parameters:nil viewController:nil response:^(NSURLSessionDataTask *task, id responseObject, BOOL success, NSError *error) {
        if (!success) { return ; }
    }];
    
    //        self.provinceArr = [ZYProvinceModel mj_objectArrayWithKeyValuesArray:responseObject];
    ////        if (self.arr.count > 0) {[self.arr removeObject:self.arr[0]];};
    //        if (self.provinceArr.count > 0) {
    //            ZYProvinceModel *model = self.provinceArr[0];
    //            [RequestFromServer POST:[NSString stringWithFormat:@"http:192.168.1.8:8888/app/area/treeDataLevel?token=5eebfdb57dd6437687f2c857843aa54e&parentId=%@", model.ID] parameters:nil viewController:nil response:^(NSURLSessionDataTask *task, id responseObject2, BOOL success, NSError *error) {
    //               self.cityArr = [ZYProvinceModel mj_objectArrayWithKeyValuesArray:responseObject2];
    ////                if (model.arr.count > 0) {[model.arr removeObject:model.arr[0]];};
    //                if (self.cityArr.count > 0) {
    //                    ZYProvinceModel *model2 = self.cityArr[0];
    //                    [RequestFromServer POST:[NSString stringWithFormat:@"http:192.168.1.8:8888/app/area/treeDataLevel?token=5eebfdb57dd6437687f2c857843aa54e&parentId=%@", model2.ID] parameters:nil viewController:nil response:^(NSURLSessionDataTask *task, id responseObject3, BOOL success, NSError *error) {
    //                        self.areaArr = [ZYProvinceModel mj_objectArrayWithKeyValuesArray:responseObject3];
    ////                        if (model2.arr.count > 0) {[model2.arr removeObject:model2.arr[0]];};
    //                        [self.pickerView reloadAllComponents];
    //                    }];
    //                }
    //            }];
    //        }
    
    //    }];
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
        NSDictionary *provinceDic = self.provinceArr[row];
        //获取市数组
        self.cityArr = provinceDic[@"city"];
        //获取第一个市
        NSDictionary *cityDic = self.cityArr[0];
        //获取区数组
        self.areaArr = cityDic[@"area"];
        
        //刷新数据 并初始化滚轮index
        [self.pickerView reloadAllComponents];
        [self.pickerView selectRow:0 inComponent:1 animated:NO];
        [self.pickerView selectRow:0 inComponent:2 animated:NO];
        
    } else if (component == 1) {
        
        //获取当前市
        NSDictionary *cityDic = self.cityArr[row];
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

- (IBAction)cancelAction:(id)sender {
    
    [self hidden];
}

- (IBAction)determinBlock:(id)sender {
    
    if ([self anySubViewScrolling:self.pickerView]) {
        //滚动停止后才能进行选择
        return;
    }

    NSDictionary *provinceDic = self.provinceArr[[self.pickerView selectedRowInComponent:0]];
    NSDictionary *cityDic = self.cityArr[[self.pickerView selectedRowInComponent:1]];
    NSString *areaStr = self.areaArr[[self.pickerView selectedRowInComponent:2]];
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
