//
//  FoundPwdViewController.m
//  zhidetDemo
//
//  Created by 刘璐璐 on 15/12/22.
//  Copyright © 2015年 刘璐璐. All rights reserved.
//

#import "FoundPwdViewController.h"
#import "YJJRequest.h"
#define textWord 14

@interface FoundPwdViewController ()<UITextFieldDelegate>

@end

@implementation FoundPwdViewController
{
    NSTimer *_timer;
    UITextField *_verifyText;
    UITextField *_passwordText;
    UITextField *_pwdText;
    UIAlertController *_alter;
    int s;
    NSTimer *_removeTimer;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = TableViewBackColor;
    s = 60;
    
    UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
    lable.text = @"找回密码";
    lable.font = [UIFont systemFontOfSize:20];
    lable.textAlignment = NSTextAlignmentCenter;
    lable.textColor = [UIColor whiteColor];
    self.navigationItem.titleView = lable;
  
    UIButton *leftButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 15, 25)];
    [leftButton setBackgroundImage:[UIImage imageNamed:@"nav_return"] forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(returnHome:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    
    [self createUI];
}

- (void) createUI{
    
    UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(20, 20, 200, 30)];
    lable.text = @"短信验证码已发送至您的手机";
    lable.font = [UIFont systemFontOfSize:textWord];
    [self.view addSubview:lable];
    
    UIButton *sendButton = [[UIButton alloc] initWithFrame:CGRectMake(220, 20, 90, 30)];
    sendButton.backgroundColor = AwayColor;
    sendButton.clipsToBounds = YES;
    sendButton.layer.cornerRadius = 10;
    sendButton.tag = 1;
    [sendButton setTitle:@"短信验证码" forState:UIControlStateNormal];
    sendButton.titleLabel.font = [UIFont systemFontOfSize:13];
    _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(changeTime) userInfo:nil repeats:YES];
    [sendButton addTarget:self action:@selector(changeT:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:sendButton];
    
    
    _verifyText = [[UITextField alloc] initWithFrame:CGRectMake(20, 60, WIDTH - 40, 40)];
    _verifyText.delegate = self;
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 25, 30)];
    label.text = @"✉️";
    _verifyText.leftView = label;
    _verifyText.leftViewMode = UITextFieldViewModeAlways;
    _verifyText.placeholder = @" 短信验证码";
    _verifyText.font = [UIFont systemFontOfSize:textWord];
    _verifyText.backgroundColor = [UIColor whiteColor];
    _verifyText.layer.cornerRadius = 5;
    _verifyText.clearButtonMode = YES;
    _verifyText.layer.borderColor = AwayColor.CGColor;
    _verifyText.layer.borderWidth = 1;
    [self.view addSubview:_verifyText];
    
    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 25, 30)];
    _passwordText = [[UITextField alloc] initWithFrame:CGRectMake(20, 115, WIDTH - 40, 40)];
    _passwordText.delegate = self;
    label1.text = @"🔒";
    _passwordText.leftView = label1;
    _passwordText.leftViewMode = UITextFieldViewModeAlways;
    _passwordText.placeholder = @" 新密码，6-18位英文字母，数字或字符的组合。";
    _passwordText.font = [UIFont systemFontOfSize:textWord];
    _passwordText.layer.cornerRadius = 5;
    _passwordText.secureTextEntry = YES;
    _passwordText.clearButtonMode = YES;
    _passwordText.layer.borderColor = AwayColor.CGColor;
    _passwordText.layer.borderWidth = 1;
    _passwordText.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_passwordText];
    
    UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 25, 30)];
    _pwdText = [[UITextField alloc] initWithFrame:CGRectMake(20, 170, WIDTH - 40, 40)];
    _pwdText.delegate = self;
    label2.text = @"🔒";
    _pwdText.leftView = label2;
    _pwdText.leftViewMode = UITextFieldViewModeAlways;
    _pwdText.placeholder = @"请再次输入新密码";
    _pwdText.font = [UIFont systemFontOfSize:textWord];
    _pwdText.layer.cornerRadius = 5;
    _pwdText.clearButtonMode = YES;
    _pwdText.secureTextEntry = YES;
    _pwdText.backgroundColor = [UIColor whiteColor];
    _pwdText.layer.borderColor = AwayColor.CGColor;
    _pwdText.layer.borderWidth = 1;
    [self.view addSubview:_pwdText];
    
    UIButton *nextButton = [[UIButton alloc] initWithFrame:CGRectMake(20, 225, WIDTH - 40, 40)];
    [nextButton setTitle:@"确定" forState:UIControlStateNormal];
    nextButton.backgroundColor = [UIColor colorWithRed:255/255.0 green:171/255.0 blue:0 alpha:1];
    nextButton.clipsToBounds = YES;
    nextButton.layer.cornerRadius = 5;
    [nextButton addTarget:self action:@selector(next:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:nextButton];
    
}

- (void)changeTime{
    
    
    UIButton *sendButton = (UIButton *)[self.view viewWithTag:1];
    [sendButton setTitle:[NSString stringWithFormat:@"再次发送%dS", --s] forState:UIControlStateNormal];
    if (s == -1) {
        [sendButton setTitle:@"再次发送" forState:UIControlStateNormal];
        sendButton.backgroundColor = BackColor;
        //关闭定时器
        [_timer setFireDate:[NSDate distantFuture]];
        s = 60;
    }
    
}

- (void)changeT:(UIButton *)sender{
    
    sender.backgroundColor = AwayColor;
    if (s == 60) {
        NSDictionary *dict = @{@"mobile":_phone, @"action":@"2"};
        [YJJRequest PostrequestwithURL:sendURL dic:dict complete:^(NSData *data) {
            
            NSDictionary *result = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            if ([result[@"resultCode"] longValue] == 0) {
                
                UIAlertController *alter = [UIAlertController alertControllerWithTitle:@"已发送" message:nil preferredStyle:UIAlertControllerStyleAlert];
                [self presentViewController:alter animated:YES completion:nil];
                _removeTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(removeLable) userInfo:nil repeats:NO];
                
            }else if ([result[@"resultCode"] longValue] == 3){
                
                UIAlertController *alter = [UIAlertController alertControllerWithTitle:@"该号码未注册" message:nil preferredStyle:UIAlertControllerStyleAlert];
                [self presentViewController:alter animated:YES completion:nil];
                _removeTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(removeLable) userInfo:nil repeats:NO];
                
            }else if ([result[@"resultCode"] longValue] == 4){
                
                UIAlertController *alter = [UIAlertController alertControllerWithTitle:@"超出每天发送短信次数" message:nil preferredStyle:UIAlertControllerStyleAlert];
                [self presentViewController:alter animated:YES completion:nil];
                _removeTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(removeLable) userInfo:nil repeats:NO];
                sender.backgroundColor = AwayColor;
                [sender setTitle:@"发送短信验证码" forState:UIControlStateNormal];
                sender.userInteractionEnabled = NO;
                [_timer setFireDate:[NSDate distantFuture]];
            }
            
            
        } fail:^(NSError *error) {
            
            UIAlertController *alter = [UIAlertController alertControllerWithTitle:@"发送失败" message:nil preferredStyle:UIAlertControllerStyleAlert];
            [self presentViewController:alter animated:YES completion:nil];
            _removeTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(removeLable) userInfo:nil repeats:NO];
        }];
    }
    [_timer setFireDate:[NSDate distantPast]];
    
}

#pragma mark ---按钮点击事件---

//下一步
- (void)next:(UIButton *)sender{
    
    [_passwordText resignFirstResponder];
    [_pwdText resignFirstResponder];
    [_verifyText resignFirstResponder];
    if (_verifyText.text.length == 0) {
        //验证码为空
        UIAlertController *alter = [UIAlertController alertControllerWithTitle:@"验证码不能为空" message:nil preferredStyle:UIAlertControllerStyleAlert];
        [self presentViewController:alter animated:YES completion:nil];
        _removeTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(removeLable) userInfo:nil repeats:NO];
        
    }else  if([self validatePassword:_passwordText.text] == NO){
        //密码输入有误
        UIAlertController *alter = [UIAlertController alertControllerWithTitle:@"密码不符合要求" message:nil preferredStyle:UIAlertControllerStyleAlert];
        [self presentViewController:alter animated:YES completion:nil];
        _removeTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(removeLable) userInfo:nil repeats:NO];
        
    }else if([_passwordText.text isEqualToString:_pwdText.text] == NO){
        //两次密码输入不一致
        UIAlertController *alter = [UIAlertController alertControllerWithTitle:@"两次密码输入不一致" message:nil preferredStyle:UIAlertControllerStyleAlert];
        [self presentViewController:alter animated:YES completion:nil];
        _removeTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(removeLable) userInfo:nil repeats:NO];
        
    }else{
        
        NSDictionary *dict = @{@"phoneNum":_phone, @"password":_passwordText.text, @"passsure":_pwdText.text, @"vcode":_verifyText.text};
        [YJJRequest PostrequestwithURL:foundPwdURL dic:dict complete:^(NSData *data) {
            
            NSDictionary *result = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            if([result[@"resultCode"] longValue] == 0){
                
                _alter = [UIAlertController alertControllerWithTitle:@"设置成功" message:nil preferredStyle:UIAlertControllerStyleAlert];
                [self presentViewController:_alter animated:YES completion:nil];
                _removeTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(removeLable) userInfo:nil repeats:NO];
                [userDefault setObject:_phone forKey:@"phone"];
                [userDefault setObject:_passwordText.text forKey:@"password"];
                //发送已经登录通知
                [NotiCenter postNotificationName:@"Joined" object:self userInfo:nil];
                
                
                
            }else if([result[@"resultCode"] integerValue] == 5){
                
                UIAlertController *alter = [UIAlertController alertControllerWithTitle:@"验证码错误或失效" message:nil preferredStyle:UIAlertControllerStyleAlert];
                [self presentViewController:alter animated:YES completion:nil];
                _removeTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(removeLable) userInfo:nil repeats:NO];
                
            }else if([result[@"resultCode"] longValue] == 6){
                
                UIAlertController *alter = [UIAlertController alertControllerWithTitle:@"验证码超时" message:nil preferredStyle:UIAlertControllerStyleAlert];
                [self presentViewController:alter animated:YES completion:nil];
                _removeTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(removeLable) userInfo:nil repeats:NO];
                
            }else if([result[@"resultCode"] longValue] == 7){
                
                UIAlertController *alter = [UIAlertController alertControllerWithTitle:@"请求失败" message:nil preferredStyle:UIAlertControllerStyleAlert];
                [self presentViewController:alter animated:YES completion:nil];
                _removeTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(removeLable) userInfo:nil repeats:NO];
            }else if([result[@"resultCode"] longValue] == 8){
                
                UIAlertController *alter = [UIAlertController alertControllerWithTitle:@"服务器错误" message:nil preferredStyle:UIAlertControllerStyleAlert];
                [self presentViewController:alter animated:YES completion:nil];
                _removeTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(removeLable) userInfo:nil repeats:NO];
            }else{
                
                UIAlertController *alter = [UIAlertController alertControllerWithTitle:@"提交失败" message:nil preferredStyle:UIAlertControllerStyleAlert];
                [self presentViewController:alter animated:YES completion:nil];
                _removeTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(removeLable) userInfo:nil repeats:NO];
            }
            
            
        } fail:^(NSError *error) {
            
            
            UIAlertController *alter = [UIAlertController alertControllerWithTitle:@"提交失败" message:nil preferredStyle:UIAlertControllerStyleAlert];
            [self presentViewController:alter animated:YES completion:nil];
            _removeTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(removeLable) userInfo:nil repeats:NO];
        }];
    }
    
    
    
}
//密码判断
- (BOOL) validatePassword:(NSString *)passWord
{
    NSString *passWordRegex = @"^[a-zA-Z0-9]{6,18}+$";
    NSPredicate *passWordPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",passWordRegex];
    return [passWordPredicate evaluateWithObject:passWord];
}

//移除提示
- (void)removeLable{
    if ([_alter.title isEqualToString:@"设置成功"]) {
        [self dismissViewControllerAnimated:YES completion:nil];
        [self.navigationController popToRootViewControllerAnimated:YES];
    }else{
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}


//导航栏返回
- (void)returnHome:(UIButton *)sender{
    
    [self.navigationController popViewControllerAnimated:YES];
}

//键盘的return键 点击时就会触发该方法
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    [_passwordText resignFirstResponder];
    [_pwdText resignFirstResponder];
    [_verifyText resignFirstResponder];
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
