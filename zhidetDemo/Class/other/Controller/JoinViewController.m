//
//  MyViewController.m
//  zhidetDemo
//
//  Created by 刘璐璐 on 15/12/4.
//  Copyright © 2015年 刘璐璐. All rights reserved.
//

#import "JoinViewController.h"
#import "RegistViewController.h"
#import "CLLockVC.h"
#import "MyViewController.h"
#import "BasicTabBarController.h"
#import "ForgetPwdViewController.h"
#import "YJJRequest.h"
@interface JoinViewController ()<UITextFieldDelegate>

@end

@implementation JoinViewController
{
    UITextField *_userText;
    UITextField *_passwordText;
    NSTimer *_removeTimer;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    
    //设置导航栏
    UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
    lable.text = @"用户登录";
    lable.textAlignment = NSTextAlignmentCenter;
    lable.textColor = [UIColor whiteColor];
    lable.font = [UIFont systemFontOfSize:20];
    self.navigationItem.titleView = lable;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"注册" style:UIBarButtonItemStyleDone target:self action:@selector(gotoRegist:)];
    UIButton *leftButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 15, 25)];
    [leftButton setBackgroundImage:[UIImage imageNamed:@"nav_return"] forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(returnHome:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    
    [self createUI];

}


- (void)createUI{
    
    
    _userText = [[UITextField alloc] initWithFrame:CGRectMake(20, 30, WIDTH - 40, 45)];
    _userText.delegate = self;
    UILabel *userLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 25, 30)];
    userLabel.text = @"📱";
    _userText.leftView = userLabel;
    _userText.leftViewMode = UITextFieldViewModeAlways;
    _userText.placeholder = @"请输入手机号码";
    _userText.font = [UIFont systemFontOfSize:14];
    _userText.layer.cornerRadius = 5;
    _userText.layer.borderWidth = 1;
    _userText.layer.borderColor = AwayColor.CGColor;
    _userText.clearButtonMode = YES;
    
    _passwordText = [[UITextField alloc] initWithFrame:CGRectMake(20, 95, WIDTH - 40, 45)];
    _passwordText.delegate = self;
    UILabel *pwdLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 25, 30)];
    pwdLabel.text = @"🔒";
    _passwordText.leftView = pwdLabel;
    _passwordText.leftViewMode = UITextFieldViewModeAlways;
    _passwordText.font = [UIFont systemFontOfSize:14];
    _passwordText.placeholder = @"请输入登陆密码";
    _passwordText.layer.cornerRadius = 5;
    _passwordText.layer.borderWidth = 1;
    _passwordText.layer.borderColor = AwayColor.CGColor;
    _passwordText.clearButtonMode = YES;
    _passwordText.secureTextEntry = YES;
    UIButton *joinButton = [[UIButton alloc] initWithFrame:CGRectMake(20, 160, WIDTH - 40, 40)];
    joinButton.clipsToBounds = YES;
    joinButton.layer.cornerRadius = 10;
    [joinButton setTitle:@"马上登陆" forState:UIControlStateNormal];
    joinButton.backgroundColor = BidColor;
    [joinButton addTarget:self action:@selector(gotoJoin:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *registButton = [[UIButton alloc] initWithFrame:CGRectMake(20, 220, WIDTH - 40, 40)];
    [registButton setTitle:@"注册领取10元红包" forState:UIControlStateNormal];
    registButton.backgroundColor = BackColor;
    registButton.clipsToBounds = YES;
    registButton.layer.cornerRadius = 10;
    [registButton addTarget:self action:@selector(gotoRegist:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *forgetButton = [[UIButton alloc] initWithFrame:CGRectMake(WIDTH / 2 - 40, 280, 80, 20)];
    [forgetButton setTitle:@"忘记密码?" forState:UIControlStateNormal];
    [forgetButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [forgetButton addTarget:self action:@selector(forgetPassword:) forControlEvents:UIControlEventTouchUpInside];
    forgetButton.titleLabel.font = [UIFont systemFontOfSize:wordSize];
    
    [self.view addSubview:_userText];
    [self.view addSubview:_passwordText];
    [self.view addSubview:joinButton];
    [self.view addSubview:registButton];
    [self.view addSubview:forgetButton];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark ---按钮点击事件---
- (void)gotoRegist:(UIButton *)sender{
    
    RegistViewController *regist = [[RegistViewController alloc] init];
    [self.navigationController pushViewController:regist animated:YES];
}

- (void)gotoJoin:(UIButton *)sender{
    
    [_userText resignFirstResponder];
    [_passwordText resignFirstResponder];
    if ([_userText.text isEqualToString:@""] || [_passwordText.text isEqualToString:@""]) {
        
        UIAlertController *alter = [UIAlertController alertControllerWithTitle:@"请输入账号密码" message:nil preferredStyle:UIAlertControllerStyleAlert];
        [self presentViewController:alter animated:YES completion:nil];
        _removeTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(removeLable) userInfo:nil repeats:NO];
        
    }else {
        
        [userDefault setObject:_userText.text forKey:@"phone"];
        [userDefault setObject:_passwordText.text forKey:@"password"];
        
        [YJJRequest PostrequestwithURL:LoginURL dic:@{@"phone":_userText.text, @"password":_passwordText.text} complete:^(NSData *data) {
            
            NSDictionary *result = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            if([result[@"resultCode"] longValue] == 1){
                
                //密码错误
                UIAlertController *alter = [UIAlertController alertControllerWithTitle:@"密码错误" message:nil preferredStyle:UIAlertControllerStyleAlert];
                [self presentViewController:alter animated:YES completion:nil];
                _removeTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(removeLable) userInfo:nil repeats:NO];
                
            }else if ([result[@"resultCode"] longValue] == 3){
                //用户名不存在
                UIAlertController *alter = [UIAlertController alertControllerWithTitle:@"用户名不存在" message:nil preferredStyle:UIAlertControllerStyleAlert];
                [self presentViewController:alter animated:YES completion:nil];
               _removeTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(removeLable) userInfo:nil repeats:NO];
                
            }else if ([result[@"resultCode"] longValue] == 2){
                
                //系统错误
                UIAlertController *alter = [UIAlertController alertControllerWithTitle:@"系统错误" message:nil preferredStyle:UIAlertControllerStyleAlert];
                [self presentViewController:alter animated:YES completion:nil];
                _removeTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(removeLable) userInfo:nil repeats:NO];
                
            }else{
                
                
                
                [userDefault setBool:YES forKey:@"isJoin"];
                [userDefault setBool:YES forKey:@"isFirstJoin"];
                
                //发送已经登录通知
                [NotiCenter postNotificationName:@"Joined" object:self userInfo:nil];
                
                [self.navigationController popToRootViewControllerAnimated:YES];
                
                }
                
            
            
        } fail:^(NSError *error) {

            UIAlertController *alter = [UIAlertController alertControllerWithTitle:@"登录失败" message:nil preferredStyle:UIAlertControllerStyleAlert];
            [self presentViewController:alter animated:YES completion:nil];
            _removeTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(removeLable) userInfo:nil repeats:NO];
            
        }];

    }
    
 
}

- (void)forgetPassword:(UIButton *)sender{
    
    ForgetPwdViewController *fotgetPwd = [[ForgetPwdViewController alloc] init];
    [self.navigationController pushViewController:fotgetPwd animated:YES];
}


//导航栏返回按钮
- (void)returnHome:(UIButton *)sender{
    
    [self.navigationController popViewControllerAnimated:YES];
}

//移除lable
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
    
    [_userText resignFirstResponder];
    [_passwordText resignFirstResponder];
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
