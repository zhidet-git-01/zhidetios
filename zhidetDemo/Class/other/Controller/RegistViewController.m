//
//  ViewController.m
//  zhidetDemo
//
//  Created by 刘璐璐 on 15/12/8.
//  Copyright © 2015年 刘璐璐. All rights reserved.
//

#import "RegistViewController.h"
#import "JoinViewController.h"
#import "RegistNextViewController.h"
#import "YJJRequest.h"

@interface RegistViewController ()<UITextFieldDelegate>

@end

@implementation RegistViewController
{
    UITextField *_mobileTextFiled;
    UIButton *_selectButton;
    NSTimer *_removeTimer;
}

- (void)viewDidLoad {
    [super viewDidLoad];
   
    UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
    lable.text = @"用户注册";
    lable.font = [UIFont systemFontOfSize:20];
    lable.textAlignment = NSTextAlignmentCenter;
    lable.textColor = [UIColor whiteColor];
    self.navigationItem.titleView = lable;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"登录" style:UIBarButtonItemStyleDone target:self action:@selector(join:)];
    UIButton *leftButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 15, 25)];
    [leftButton setBackgroundImage:[UIImage imageNamed:@"nav_return"] forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(returnHome:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self createUI];
    
    
}

- (void) createUI{
    
    _mobileTextFiled = [[UITextField alloc] initWithFrame:CGRectMake(20, 30, WIDTH - 40, 40)];
    _mobileTextFiled.delegate = self;
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 25, 30)];
    label.text = @"📱";
    _mobileTextFiled.leftView = label;
    _mobileTextFiled.leftViewMode = UITextFieldViewModeAlways;
    _mobileTextFiled.layer.borderWidth = 1;
    _mobileTextFiled.placeholder = @"请输入您的手机号码";
    _mobileTextFiled.font = [UIFont systemFontOfSize:14];
    _mobileTextFiled.clearButtonMode = YES;
    _mobileTextFiled.layer.borderColor = AwayColor.CGColor;
    _mobileTextFiled.clipsToBounds = YES;
    _mobileTextFiled.layer.cornerRadius = 5;
    [self.view addSubview:_mobileTextFiled];
    
    _selectButton = [[UIButton alloc] initWithFrame:CGRectMake(20, 90, 20, 20)];
    _selectButton.layer.borderColor = AwayColor.CGColor;
    _selectButton.layer.borderWidth = 1;
    [_selectButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    _selectButton.clipsToBounds = YES;
    _selectButton.layer.cornerRadius = 2;
    [_selectButton addTarget:self action:@selector(selectedClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_selectButton];
    
    UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(45, 90, 100, 20)];
    lable.text = @"已阅读并同意";
    lable.font = [UIFont systemFontOfSize:14];
    [self.view addSubview:lable];
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(125, 90, 160, 20)];
    [button setTitleColor:[UIColor colorWithRed:0.5 green:0.8 blue:0.5 alpha:1] forState:UIControlStateNormal];
    [button setTitle:@"《值得投用户服务协议》" forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:14];
    [self.view addSubview:button];
    
    UIButton *nextButton = [[UIButton alloc] initWithFrame:CGRectMake(20, 130, WIDTH - 40, 40)];
    [nextButton setTitle:@"下一步" forState:UIControlStateNormal];
    nextButton.backgroundColor = [UIColor colorWithRed:255/255.0 green:171/255.0 blue:0 alpha:1];
    nextButton.clipsToBounds = YES;
    nextButton.layer.cornerRadius = 5;
    [nextButton addTarget:self action:@selector(next:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:nextButton];
    
}

#pragma mark ---按钮点击事件---
//下一步
- (void)next:(UIButton *)sender{
    
    [_mobileTextFiled resignFirstResponder];
    if (!_selectButton.selected) {
        
        UIAlertController *alter = [UIAlertController alertControllerWithTitle:@"请勾选值得投用户协议" message:nil preferredStyle:UIAlertControllerStyleAlert];
        [self presentViewController:alter animated:YES completion:nil];
        _removeTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(removeLable) userInfo:nil repeats:NO];
    }else if ([self isMobileNumber:_mobileTextFiled.text] == NO) {
        
        UIAlertController *alter = [UIAlertController alertControllerWithTitle:@"手机号码有误" message:nil preferredStyle:UIAlertControllerStyleAlert];
        [self presentViewController:alter animated:YES completion:nil];
        _removeTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(removeLable) userInfo:nil repeats:NO];
        
    }else{
        //短信验证
        NSDictionary *dict = @{@"mobile":_mobileTextFiled.text, @"action":@"1"};
        [YJJRequest PostrequestwithURL:sendURL dic:dict complete:^(NSData *data) {
            
            NSDictionary *result = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            
            if ([result[@"resultCode"] longValue] == 0) {
                
                RegistNextViewController *registNext = [[RegistNextViewController alloc] init];
                registNext.phone = _mobileTextFiled.text;
                [self.navigationController pushViewController:registNext animated:YES];
                
            }else if([result[@"resultCode"] longValue] == 2){
                
                UIAlertController *alter = [UIAlertController alertControllerWithTitle:@"该号码已注册" message:nil preferredStyle:UIAlertControllerStyleAlert];
                [self presentViewController:alter animated:YES completion:nil];
                _removeTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(removeLable) userInfo:nil repeats:NO];
            }
        

            
        } fail:^(NSError *error) {
            
            UIAlertController *alter = [UIAlertController alertControllerWithTitle:@"发送失败" message:nil preferredStyle:UIAlertControllerStyleAlert];
            [self presentViewController:alter animated:YES completion:nil];
            _removeTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(removeLable) userInfo:nil repeats:NO];
        }];
        
    }
}

- (BOOL)isMobileNumber:(NSString *)mobileNum
{
    
    NSString *regex = @"^(0|86|17951)?(13[0-9]|15[012356789]|17[0678]|18[0-9]|14[57])[0-9]{8}$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    if ([predicate evaluateWithObject:mobileNum]){
        return YES;
    }else{
        return NO;
    }
}

//登录
- (void)join:(UIBarButtonItem *)sender{
    
    JoinViewController *join = [[JoinViewController alloc] init];
    [self.navigationController pushViewController:join animated:YES];
}
//选中
- (void)selectedClick:(UIButton *)sender{
    
    sender.selected = !sender.selected;
    if (sender.selected) {
        [sender setTitle:@"√" forState:UIControlStateNormal];
    }else{
        [sender setTitle:@"" forState:UIControlStateNormal];
    }
}
//导航栏返回
- (void)returnHome:(UIButton *)sender{
    
    [self.navigationController popViewControllerAnimated:YES];
}

//移除提示
- (void)removeLable{
    [self dismissViewControllerAnimated:YES completion:nil];
}


//键盘的return键 点击时就会触发该方法
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    [_mobileTextFiled resignFirstResponder];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    self.tabBarController.tabBar.hidden = NO;
    [_removeTimer invalidate];
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
