//
//  SafeViewController.m
//  zhidetDemo
//
//  Created by 刘璐璐 on 15/12/15.
//  Copyright © 2015年 刘璐璐. All rights reserved.
//

#import "SafeViewController.h"
#import "YJJRequest.h"
#import "ProgressView.h"

@interface SafeViewController ()<UIScrollViewDelegate, UITextFieldDelegate>

@end

@implementation SafeViewController
{
    UIScrollView *_scrollView;
    UILabel *_lineLable;
    UITextField *_oldText;
    UITextField *_newText1;
    UITextField *_newText2;
    UITextField *_emailText;
    UIButton *_upBtn;       //上一个所点击的按钮
    NSString *_email;
    UIView *_mailView;
    UIView *_nomalView;
    UIAlertController *_alter;
    NSTimer *_removeTimer;
    UIButton *_againBtn;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = TableViewBackColor;
    
    [self createNAV];
    
    [self createUI];
}

- (void)createNAV{
    
    UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
    lable.text = @"安全中心";
    lable.textAlignment = NSTextAlignmentCenter;
    lable.textColor = [UIColor whiteColor];
    lable.font = [UIFont systemFontOfSize:20];
    self.navigationItem.titleView = lable;
    UIButton *leftButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 15, 25)];
    [leftButton setBackgroundImage:[UIImage imageNamed:@"nav_return"] forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(returnHome:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
}

- (void)createUI{
    
    NSArray *array = @[@"修改密码", @"绑定邮箱"];
    for (int i = 0; i < 2; i++) {
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(i * (WIDTH / 2), 10, WIDTH / 2, 40)];
        button.backgroundColor = [UIColor whiteColor];
        [button setTitle:array[i] forState:UIControlStateNormal];
        
        if (i == 0) {
            [button setTitleColor:BackColor forState:UIControlStateNormal];
        }else{
            [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        }
        button.tag = i + 1;
        [button addTarget:self action:@selector(changeClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:button];
        
    }
    _lineLable = [[UILabel alloc] initWithFrame:CGRectMake(0, 48, WIDTH / 2, 2)];
    _lineLable.backgroundColor = BackColor;
    [self.view addSubview:_lineLable];
    
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 60, WIDTH, HEIGHT - 125)];
    _scrollView.pagingEnabled = YES;
    _scrollView.bounces = NO;
    _scrollView.delegate = self;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.backgroundColor = [UIColor clearColor];
    _scrollView.contentSize = CGSizeMake(WIDTH * 2, HEIGHT - 125);
    _scrollView.backgroundColor = TableViewBackColor;
    [self.view addSubview:_scrollView];
    
    [self createScrollView1];
//    [self createScrollView2];
    
}

- (void)requestData{
    
    [_againBtn removeFromSuperview];
    UIView *startRequest = [ProgressView startRequest];
    [self.view addSubview:startRequest];
    
    NSDictionary *dict = @{@"token":_token};
    [YJJRequest PostrequestwithURL:EmailJudgeURL dic:dict complete:^(NSData *data) {
        
        NSDictionary *result = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        if ([result[@"resultCode"] longLongValue] == 0) {
            
            [startRequest removeFromSuperview];
            
            NSDictionary *userDic = result[@"user"];
            if ([self validateEmail:userDic[@"email"]] == NO) {
                [self createNoemail];
            }else{
                _email = userDic[@"email"];
                [self createfEmail];
            }
        }else{
            
            [startRequest removeFromSuperview];
            _againBtn = [ProgressView againRequest];
            [_againBtn addTarget:self action:@selector(requestData) forControlEvents:UIControlEventTouchUpInside];
            [self.view addSubview:_againBtn];
            
            UIAlertController *alter = [UIAlertController alertControllerWithTitle:@"获取邮箱信息失败" message:nil preferredStyle:UIAlertControllerStyleAlert];
            [self presentViewController:alter animated:YES completion:nil];
            _removeTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(removeLable) userInfo:nil repeats:NO];
        }
    } fail:^(NSError *error) {
        
        [startRequest removeFromSuperview];
        _againBtn = [ProgressView againRequest];
        [_againBtn addTarget:self action:@selector(requestData) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_againBtn];
        
        UIAlertController *alter = [UIAlertController alertControllerWithTitle:@"获取邮箱信息失败" message:nil preferredStyle:UIAlertControllerStyleAlert];
        [self presentViewController:alter animated:YES completion:nil];
        _removeTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(removeLable) userInfo:nil repeats:NO];
        
    }];
}

#pragma mark ---创建滚动视图的view---

- (void)createScrollView1{
    
    
    UILabel *oldLable = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 120, 40)];
    oldLable.text = @"  请输入旧密码：";
    oldLable.font = [UIFont systemFontOfSize:wordSize];
    oldLable.backgroundColor = [UIColor whiteColor];
    [_scrollView addSubview:oldLable];
    
    _oldText = [[UITextField alloc] initWithFrame:CGRectMake(120, 0, WIDTH - 120, 40)];
    _oldText.delegate = self;
    _oldText.placeholder = @"必填";
    _oldText.font = [UIFont systemFontOfSize:wordSize];
    _oldText.backgroundColor = [UIColor whiteColor];
    _oldText.secureTextEntry = YES;
    [_scrollView addSubview:_oldText];
    
    UILabel *newLable1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 42, 120, 40)];
    newLable1.text = @"  请输入新密码：";
    newLable1.font = [UIFont systemFontOfSize:wordSize];
    newLable1.backgroundColor = [UIColor whiteColor];
    [_scrollView addSubview:newLable1];
    
    _newText1 = [[UITextField alloc] initWithFrame:CGRectMake(120, 42, WIDTH - 120, 40)];
    _newText1.delegate = self;
    _newText1.placeholder = @"必填";
    _newText1.clearButtonMode = YES;
    _newText1.font = [UIFont systemFontOfSize:wordSize];
    _newText1.backgroundColor = [UIColor whiteColor];
    _newText1.secureTextEntry = YES;
    [_scrollView addSubview:_newText1];
    
    UILabel *newLable2 = [[UILabel alloc] initWithFrame:CGRectMake(0, 84, 120, 40)];
    newLable2.text = @"  再输入新密码：";
    newLable2.font = [UIFont systemFontOfSize:wordSize];
    newLable2.backgroundColor = [UIColor whiteColor];
    [_scrollView addSubview:newLable2];
    
    _newText2 = [[UITextField alloc] initWithFrame:CGRectMake(120, 84, WIDTH - 120, 40)];
    _newText2.delegate = self;
    _newText2.placeholder = @"必填";
    _newText2.clearButtonMode = YES;
    _newText2.font = [UIFont systemFontOfSize:wordSize];
    _newText2.backgroundColor = [UIColor whiteColor];
    _newText2.secureTextEntry = YES;
    [_scrollView addSubview:_newText2];
    
    
    UIButton *updataButton = [[UIButton alloc] initWithFrame:CGRectMake(20, 140, WIDTH - 40, 40)];
    updataButton.backgroundColor = BidColor;
    [updataButton setTitle:@"确认修改" forState:UIControlStateNormal];
    updataButton.clipsToBounds = YES;
    updataButton.layer.cornerRadius = 10;
    [updataButton addTarget:self action:@selector(gotoUpdata:) forControlEvents:UIControlEventTouchUpInside];
    [_scrollView addSubview:updataButton];
    
    
}

- (void)createNoemail{
    
    _nomalView = [[UIView alloc] init];
    _nomalView.frame = CGRectMake(WIDTH, 0, WIDTH, 100);
    [_scrollView addSubview:_nomalView];
    
    UILabel *emailLable = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 40)];
    emailLable.text = @"  请输入邮箱：";
    emailLable.font = [UIFont systemFontOfSize:wordSize];
    emailLable.backgroundColor = [UIColor whiteColor];
    [_nomalView addSubview:emailLable];
    
    _emailText = [[UITextField alloc] initWithFrame:CGRectMake(100, 0, WIDTH - 100, 40)];
    _emailText.placeholder = @"必填";
    [_emailText setAutocapitalizationType:UITextAutocapitalizationTypeNone];
    _emailText.font = [UIFont systemFontOfSize:wordSize];
    _emailText.backgroundColor = [UIColor whiteColor];
    _emailText.clearButtonMode = YES;
    [_nomalView addSubview:_emailText];
    
    UIButton *updataButton = [[UIButton alloc] initWithFrame:CGRectMake(20, 60, WIDTH - 40, 40)];
    updataButton.backgroundColor = BidColor;
    if ([_email isEqualToString:@""]) {
        [updataButton setTitle:@"确认绑定" forState:UIControlStateNormal];
    }else{
        [updataButton setTitle:@"确认修改" forState:UIControlStateNormal];
    }
    updataButton.clipsToBounds = YES;
    updataButton.layer.cornerRadius = 10;
    [updataButton addTarget:self action:@selector(gototTie:) forControlEvents:UIControlEventTouchUpInside];
    [_nomalView addSubview:updataButton];
}

- (void)createfEmail{
    
    _mailView = [[UIView alloc] init];
    _mailView.frame = CGRectMake(WIDTH, 0, WIDTH, 100);
    [_scrollView addSubview:_mailView];
    
    UILabel *emailLable = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 40)];
    emailLable.text = @"  已绑定邮箱：";
    emailLable.font = [UIFont systemFontOfSize:wordSize];
    emailLable.backgroundColor = [UIColor whiteColor];
    [_mailView addSubview:emailLable];
    
    UITextField *emailText1 = [[UITextField alloc] initWithFrame:CGRectMake(100, 0, WIDTH - 100, 40)];
    emailText1.enabled = NO;
    emailText1.text = _email;
    emailText1.font = [UIFont systemFontOfSize:wordSize];
    emailText1.backgroundColor = [UIColor whiteColor];
    emailText1.clearButtonMode = YES;
    [_mailView addSubview:emailText1];
    
    UIButton *updataButton = [[UIButton alloc] initWithFrame:CGRectMake(20, 60, WIDTH - 40, 40)];
    updataButton.backgroundColor = BidColor;
    [updataButton setTitle:@"修改邮箱" forState:UIControlStateNormal];
    updataButton.clipsToBounds = YES;
    updataButton.layer.cornerRadius = 10;
    [updataButton addTarget:self action:@selector(gototChange:) forControlEvents:UIControlEventTouchUpInside];
    [_mailView addSubview:updataButton];
}

#pragma mark ---按钮点击事件---
//改变视图
- (void)changeClick:(UIButton *)sender{
    
    if (_upBtn == nil) {
        
       _upBtn = (UIButton *)[self.view viewWithTag:1];
    }
    
    [_upBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [sender setTitleColor:BackColor forState:UIControlStateNormal];
    [UIView animateWithDuration:0.2 animations:^{
        _lineLable.frame = CGRectMake(sender.frame.origin.x, 48, WIDTH / 2, 2);
        CGPoint point;
        point = CGPointMake(WIDTH * (sender.tag - 1), _scrollView.contentOffset.y);
        _scrollView.contentOffset = point;
    }];
    
    if (_scrollView.contentOffset.x >= WIDTH) {
        
        [self requestData];
    }
    _upBtn = sender;
}

//确认修改
- (void)gotoUpdata:(UIButton *)sender{
    
    
    [_oldText resignFirstResponder];
    [_newText1 resignFirstResponder];
    [_newText2 resignFirstResponder];
    
    if([_oldText.text isEqualToString:@""]){
        
        UIAlertController *alter = [UIAlertController alertControllerWithTitle:@"请输入旧密码" message:nil preferredStyle:UIAlertControllerStyleAlert];
        [self presentViewController:alter animated:YES completion:nil];
        _removeTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(removeLable) userInfo:nil repeats:NO];
        
    }else if ([self validatePassword:_newText1.text] == NO) {
        
        UIAlertController *alter = [UIAlertController alertControllerWithTitle:@"密码6-18位字母数字组成" message:nil preferredStyle:UIAlertControllerStyleAlert];
        [self presentViewController:alter animated:YES completion:nil];
        _removeTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(removeLable) userInfo:nil repeats:NO];
        
    }else if ([_newText1.text isEqualToString:_newText2.text] == NO) {
        
        UIAlertController *alter = [UIAlertController alertControllerWithTitle:@"两次密码输入不一致" message:nil preferredStyle:UIAlertControllerStyleAlert];
        [self presentViewController:alter animated:YES completion:nil];
        _removeTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(removeLable) userInfo:nil repeats:NO];
    }else if ([_newText1.text isEqualToString:_oldText.text] == YES) {
        
        UIAlertController *alter = [UIAlertController alertControllerWithTitle:@"新密码不能跟旧密码相同" message:nil preferredStyle:UIAlertControllerStyleAlert];
        [self presentViewController:alter animated:YES completion:nil];
        _removeTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(removeLable) userInfo:nil repeats:NO];
    }else{
        
        NSDictionary *dict = @{@"orgPassword":_oldText.text, @"newPassword":_newText1.text, @"newPassword2":_newText2.text, @"token":_token};
        [YJJRequest PostrequestwithURL:updataPwdURL dic:dict complete:^(NSData *data) {
            NSDictionary *result = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            if ([result[@"resultCode"] longValue] == 0) {
                
                _alter = [UIAlertController alertControllerWithTitle:@"修改成功" message:nil preferredStyle:UIAlertControllerStyleAlert];
                [self presentViewController:_alter animated:YES completion:nil];
                _removeTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(removeLable) userInfo:nil repeats:NO];
                
                //发送已经退出的通知 关闭手势密码按钮
                [NotiCenter postNotificationName:@"DownSafe" object:self userInfo:nil];
                
                
            }else if([result[@"resultCode"] longValue] == -2){
                
                UIAlertController *alter = [UIAlertController alertControllerWithTitle:@"旧密码错误" message:nil preferredStyle:UIAlertControllerStyleAlert];
                [self presentViewController:alter animated:YES completion:nil];
                _removeTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(removeLable) userInfo:nil repeats:NO];
                
            }else if ([result[@"resultCode"] longValue] == -4){
                
                UIAlertController *alter = [UIAlertController alertControllerWithTitle:@"请求被拒" message:nil preferredStyle:UIAlertControllerStyleAlert];
                [self presentViewController:alter animated:YES completion:nil];
                _removeTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(removeLable) userInfo:nil repeats:NO];
            }

        } fail:^(NSError *error) {
            UIAlertController *alter = [UIAlertController alertControllerWithTitle:@"请求失败" message:nil preferredStyle:UIAlertControllerStyleAlert];
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

//确认绑定
- (void)gototTie:(UIButton *)sender{
    
    [_emailText resignFirstResponder];
    
    if ([self validateEmail:_emailText.text]) {
        
        NSDictionary *dict = @{@"mail":_emailText.text, @"token":_token};
        [YJJRequest PostrequestwithURL:EmailURL dic:dict complete:^(NSData *data) {

            NSDictionary *result = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            
            NSLog(@"%@", result);
            if ([result[@"resultCode"] longValue] == 0) {
                UIAlertController *alter = [UIAlertController alertControllerWithTitle:@"绑定成功" message:nil preferredStyle:UIAlertControllerStyleAlert];
                [self presentViewController:alter animated:YES completion:nil];
                _removeTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(removeLable) userInfo:nil repeats:NO];
                [_nomalView removeFromSuperview];
                [self requestData];
                
            }else if([result[@"resultCode"] longValue] == -1){
                
                UIAlertController *alter = [UIAlertController alertControllerWithTitle:@"邮箱格式错误" message:nil preferredStyle:UIAlertControllerStyleAlert];
                [self presentViewController:alter animated:YES completion:nil];
                _removeTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(removeLable) userInfo:nil repeats:NO];
            }else if([result[@"resultCode"] longValue] == 1){
                
                UIAlertController *alter = [UIAlertController alertControllerWithTitle:@"账号错误" message:nil preferredStyle:UIAlertControllerStyleAlert];
                [self presentViewController:alter animated:YES completion:nil];
                _removeTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(removeLable) userInfo:nil repeats:NO];
            }
            
        } fail:^(NSError *error) {
            
            UIAlertController *alter = [UIAlertController alertControllerWithTitle:@"请求失败" message:nil preferredStyle:UIAlertControllerStyleAlert];
            [self presentViewController:alter animated:YES completion:nil];
            _removeTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(removeLable) userInfo:nil repeats:NO];
    
        }];
        
    }else{
        
        UIAlertController *alter = [UIAlertController alertControllerWithTitle:@"请输入正确邮箱" message:nil preferredStyle:UIAlertControllerStyleAlert];
        [self presentViewController:alter animated:YES completion:nil];
        _removeTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(removeLable) userInfo:nil repeats:NO];
    }
    
}
//邮箱判断
- (BOOL) validateEmail:(NSString *)email
{
    
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}

- (void)gototChange:(UIButton *)button{
    
    [_mailView removeFromSuperview];
    [self createNoemail];
}

//导航栏返回按钮
- (void)returnHome:(UIButton *)sender{
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark ---scrollViewDelegate---

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    if (_scrollView.contentOffset.x >= WIDTH) {
        [self requestData];
    }
    if (_upBtn == nil) {
        
        _upBtn = (UIButton *)[self.view viewWithTag:1];
    }
    UIButton *button2 = (UIButton *)[self.view viewWithTag:scrollView.contentOffset.x / WIDTH + 1];
    
    [_upBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button2 setTitleColor:BackColor forState:UIControlStateNormal];
    [UIView animateWithDuration:0.1 animations:^{
        _lineLable.frame = CGRectMake(button2.frame.origin.x, 48, WIDTH / 2, 2);
    }];
    _upBtn = button2;
}

//移除提示
- (void)removeLable{
    if ([_alter.title isEqualToString:@""]) {
        [self dismissViewControllerAnimated:YES completion:nil];
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    
}
#pragma mark ---收键盘---
//键盘的return键 点击时就会触发该方法
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [_oldText resignFirstResponder];
    [_newText1 resignFirstResponder];
    [_newText2 resignFirstResponder];
    [_emailText resignFirstResponder];
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
