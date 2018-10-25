//
//  TestViewController.m
//  ZYPickerView
//
//  Created by 张祎 on 2018/1/11.
//  Copyright © 2018年 张祎. All rights reserved.
//

#import "TestViewController.h"
#import "ZYAreaPickerView.h"

@interface TestViewController ()
@property (nonatomic, strong) ZYAreaPickerView *pickerView;
@property (strong, nonatomic) IBOutlet UITextView *textView;
@end

@implementation TestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.textView.editable = NO;
    self.textView.layer.borderWidth = 0.5;
    self.textView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
    __weak typeof(self) weakSelf = self;
    self.pickerView = [ZYAreaPickerView pickerViewWithDeterminBlock:^(NSString *location) {
        weakSelf.textView.text = location;
    }];
}

- (IBAction)push:(id)sender {
    
}

- (IBAction)show:(id)sender {
    [self.pickerView show];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
