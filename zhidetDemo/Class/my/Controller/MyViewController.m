//
//  MyViewController.m
//  zhidetDemo
//
//  Created by 刘璐璐 on 15/12/4.
//  Copyright © 2015年 刘璐璐. All rights reserved.
//

#import "MyViewController.h"
#import "RegistViewController.h"
#import "ForgetPwdViewController.h"
#import "CLLockVC.h"
#import "SafeViewController.h"
#import "InviteViewController.h"
#import "ProfitViewController.h"
#import "CashViewController.h"
#import "YJJRequest.h"
#import "UserModel.h"
#import "ProgressView.h"

@interface MyViewController ()<UITableViewDataSource, UITableViewDelegate,UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate>

@end

@implementation MyViewController
{
    UITableView *_tableView;
    UIView *_view1;//个人
    UIView *_view2;//注册
    UILabel *_headLable;
    NSArray *_textArray;    //各种金额提示
    NSMutableArray *_moneyArray;  //金额
    UITextField *_userText;
    UITextField *_passwordText;
    NSString *_username;
    NSString *_starttime;
    UIButton *_againBtn;  //刷新按钮
    UIView *_startRequest;
    int y; //判断登录视图是否存在
    NSTimer *_removeTimer;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //创建导航栏
    [self createNAV];
    
    
#pragma mark ---初始化数据及视图---
    //数据
    _textArray = [[NSArray alloc] initWithObjects:@"我的返利", @"我要提现", @"邀请好友", @"安全中心", @"退出", nil];
    _moneyArray = [[NSMutableArray alloc] init];
   
    //接收通知
    [NotiCenter addObserver:self selector:@selector(JoinNot) name:@"Joined" object:nil];
    [NotiCenter addObserver:self selector:@selector(ExitNot) name:@"Exited" object:nil];
    
    _view1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT - 65)];
    [self.view addSubview:_view1];
    _view1.hidden = YES;
    _view2 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT - 65)];
    [self.view addSubview:_view2];
    _view2.hidden = YES;
  
    BOOL isJoin = [userDefault boolForKey:@"isJoin"];
    if(!isJoin){
        
        [self creatUI2];
        
    }else{
        
//        [self requestData:@{@"phone":[userDefault stringForKey:@"phone"], @"password":[userDefault stringForKey:@"password"]}];
    }
    
}

#pragma mark ---导航栏---
- (void)createNAV{
    
    _headLable = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
    _headLable.textAlignment = NSTextAlignmentCenter;
    _headLable.textColor = [UIColor whiteColor];
    _headLable.font = [UIFont systemFontOfSize:20];
    self.navigationItem.titleView = _headLable;

}



- (void)creatUI1{
    
    _headLable.text = @"用户中心";
    self.navigationItem.rightBarButtonItem = nil;
    _view2.hidden = YES;
    _view1.hidden = NO;
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 10, WIDTH, HEIGHT - 75) style:UITableViewStylePlain];
    _tableView.backgroundColor = TableViewBackColor;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    if (WIDTH > 320) {
        _tableView.rowHeight = 50;
    }
    [_view1 addSubview:_tableView];
    
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"my"];
    
#pragma mark - 添加头视图
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 210)];
    _tableView.tableHeaderView = headView;
    UIView *view1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 90)];
    view1.backgroundColor = BackColor;
    [headView addSubview:view1];
    
    //头像
    _headButton = [[UIButton alloc] initWithFrame:CGRectMake(10, 10, 70, 70)];
    _headButton.clipsToBounds = YES;
    _headButton.layer.cornerRadius = 35;
    _headButton.layer.borderWidth = 1;
    _headButton.layer.borderColor = [UIColor whiteColor].CGColor;
    [_headButton setImage:[UIImage imageNamed:@"white-tou"] forState:UIControlStateNormal];
    [view1 addSubview:_headButton];
    [_headButton addTarget:self action:@selector(clickButton) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    //用户名
    UILabel *nameLable = [[UILabel alloc] initWithFrame:CGRectMake(90, 20, 200, 20)];
    nameLable.text = [NSString stringWithFormat:@"%@，亲，你好！", _username];
    nameLable.textColor = [UIColor whiteColor];
    nameLable.font = [UIFont systemFontOfSize:14];
    [view1 addSubview:nameLable];
    //注册时间
    UILabel *timeLable = [[UILabel alloc] initWithFrame:CGRectMake(90, 50, 220, 20)];
    timeLable.text = [NSString stringWithFormat:@"注册时间：%@", _starttime];
    timeLable.textColor = [UIColor whiteColor];
    timeLable.font = [UIFont systemFontOfSize:14];
    [view1 addSubview:timeLable];
    
    //账户投资相关信息
    NSArray *array = @[@"累计收益", @"返利", @"注册", @"邀请", @"可用余额", @"提现中", @"已提现", @"待激活"];
    int k = 0;
    for (int i = 0; i < 2; i++) {
        for (int j = 0; j < 4; j++) {
            UIView *view2 = [[UIView alloc] initWithFrame:CGRectMake(j * (WIDTH / 4), (i * 62) + 90, WIDTH / 4 - 2, 60)];
            view2.backgroundColor = [UIColor whiteColor];
            [headView addSubview:view2];
            
            UILabel *nameLable = [[UILabel alloc] initWithFrame:CGRectMake(0, 30, view2.frame.size.width, 20)];
            nameLable.font = [UIFont systemFontOfSize:12];
            nameLable.textAlignment = NSTextAlignmentCenter;
            nameLable.text = array[k];
            [view2 addSubview:nameLable];
            
            UILabel *moneyLable = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, view2.frame.size.width, 20)];
            moneyLable.textAlignment = NSTextAlignmentCenter;
            moneyLable.text = [NSString stringWithFormat:@"%@元", _moneyArray[k]];
            moneyLable.textColor = BidColor;
            k++;
            if (k > 4) {
                moneyLable.textColor = BackColor;
                if (k == 6 || k == 8) {
                    moneyLable.textColor = wordColor;
                }
            }
            [view2 addSubview:moneyLable];
            
        }
    }
    
}

- (void)creatUI2{
    
   
    _headLable.text = @"用户登录";
    y = 1;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"注册" style:UIBarButtonItemStyleDone target:self action:@selector(gotoRegist:)];
    _view1.hidden = YES;
    _view2.hidden = NO;
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 25, 30)];
    _userText = [[UITextField alloc] initWithFrame:CGRectMake(20, 30, WIDTH - 40, 45)];
    _userText.delegate = self;
    label.text = @"📱";
    _userText.leftView = label;
    _userText.leftViewMode = UITextFieldViewModeAlways;
    _userText.placeholder = @"请输入手机号码";
    _userText.font = [UIFont systemFontOfSize:14];
    _userText.layer.cornerRadius = 5;
    _userText.layer.borderWidth = 1;
    _userText.layer.borderColor = AwayColor.CGColor;
    _userText.clearButtonMode = YES;
    
    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 25, 30)];
    _passwordText = [[UITextField alloc] initWithFrame:CGRectMake(20, 95, WIDTH - 40, 45)];
    _passwordText.delegate = self;
    label1.text = @"🔒";
    _passwordText.leftView = label1;
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
    
    [_view2 addSubview:_userText];
    [_view2 addSubview:_passwordText];
    [_view2 addSubview:joinButton];
    [_view2 addSubview:registButton];
    [_view2 addSubview:forgetButton];
}

#pragma mark --tableVeiwDelegate--

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"my"];
    cell.textLabel.text = _textArray[indexPath.row];
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    cell.imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"user-menu-%ld", (long)indexPath.row]];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 10, 15)];
    imageView.image = [UIImage imageNamed:@"we_right"];
    cell.accessoryView = imageView;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.layer.borderColor = TableViewBackColor.CGColor;
    cell.layer.borderWidth = 1;
    cell.userInteractionEnabled = YES;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}

//cell点击事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == 4) {
        //退出
        _passwordText.text = nil;
        _userText.text = nil;
        UIAlertController *alter = [UIAlertController alertControllerWithTitle:@"确定退出登录？" message:nil preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
     
            [userDefault setBool:NO forKey:@"isJoin"];
            
            //发送已经退出的通知 关闭手势密码按钮
            [NotiCenter postNotificationName:@"DownSafe" object:self userInfo:nil];
            if (y == 0) {
                
                [self creatUI2];
                
            }else{
                
                _view1.hidden = YES;
                _headLable.text = @"用户登录";
                _view2.hidden = NO;
            }
            
        }];
        [alter addAction:cancelAction];
        [alter addAction:defaultAction];
        [self presentViewController:alter animated:YES completion:nil];
        
    }else if (indexPath.row == 0){
        //我的返利
        ProfitViewController *profit = [[ProfitViewController alloc] init];
        profit.token = _token;
        [self.navigationController pushViewController:profit animated:YES];
        
    }else if(indexPath.row == 1){
        //我要提现
        CashViewController *cash = [[CashViewController alloc] init];
        cash.token = _token;
        cash.money = _moneyArray[4];
        [self.navigationController pushViewController:cash animated:YES];
        
    }else if(indexPath.row == 2){
        //邀请好友
        InviteViewController *invite = [[InviteViewController alloc] init];
        invite.token = _token;
        invite.invite = _invite;
        [self.navigationController pushViewController:invite animated:YES];
        
    }else {
        //安全中心
        SafeViewController *safe = [[SafeViewController alloc] init];
        safe.token = _token;
        [self.navigationController pushViewController:safe animated:YES];
        
    }
}

#pragma mark ---数据请求---
- (void)requestData:(NSDictionary *)dict{
    
    _view2.hidden = YES;
    //加载中 显示小菊花
    _startRequest = [ProgressView startRequest];
    [self.view addSubview:_startRequest];
    [self.view sendSubviewToBack:_startRequest];
    
    [YJJRequest PostrequestwithURL:LoginURL dic:dict complete:^(NSData *data) {
        
        [_startRequest removeFromSuperview];
        NSDictionary *result = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        if([result[@"resultCode"] longValue] == 1){
            
            _view2.hidden = NO;
            //密码错误
            UIAlertController *alter = [UIAlertController alertControllerWithTitle:@"密码错误" message:nil preferredStyle:UIAlertControllerStyleAlert];
            [self presentViewController:alter animated:YES completion:nil];
            _removeTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(removeLable) userInfo:nil repeats:NO];
           
            
        }else if ([result[@"resultCode"] longValue] == 3){
            
            _view2.hidden = NO;
            //用户名不存在
            UIAlertController *alter = [UIAlertController alertControllerWithTitle:@"用户名不存在" message:nil preferredStyle:UIAlertControllerStyleAlert];
            [self presentViewController:alter animated:YES completion:nil];
            _removeTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(removeLable) userInfo:nil repeats:NO];
            
        }else if ([result[@"resultCode"] longValue] == 2){
            
            _view2.hidden = NO;
            //系统错误
            UIAlertController *alter = [UIAlertController alertControllerWithTitle:@"系统错误" message:nil preferredStyle:UIAlertControllerStyleAlert];
            [self presentViewController:alter animated:YES completion:nil];
            _removeTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(removeLable) userInfo:nil repeats:NO];
            
        }else{
            
            _token = result[@"token"];
            [_moneyArray removeAllObjects];
            if ([result[@"resultCode"] longValue] == 0) {
                NSDictionary *userDic = result[@"user2"];
                [_moneyArray addObject:userDic[@"summoney"]];
                [_moneyArray addObject:userDic[@"returnmoney"]];
                [_moneyArray addObject:userDic[@"registermoney"]];
                [_moneyArray addObject:userDic[@"investmoney"]];
                [_moneyArray addObject:userDic[@"usablemoney"]];
                [_moneyArray addObject:userDic[@"coldmoney"]];
                [_moneyArray addObject:userDic[@"fetchmoney"]];
                [_moneyArray addObject:userDic[@"waitactivemoney"]];
                
                _starttime = userDic[@"creattime"];
                _username = userDic[@"phone"];
                _invite = userDic[@"id"];
                
                [self creatUI1];
                
                [userDefault setBool:YES forKey:@"isJoin"];
                [userDefault setBool:YES forKey:@"isFirstJoin"];
                
                //将token值传递到更多界面
                [userDefault setObject:_token forKey:@"token"];
                
                //发送已经登录的通知  如果已设置手势密码 打开手势密码
                [NotiCenter postNotificationName:@"upSafe" object:self userInfo:nil];
                
                //判断是否第一次设置手势密码
                if(![CLLockVC hasPwd] && ![userDefault boolForKey:@"isFirstSafe"]) {
                    
                    UIAlertController *alter = [UIAlertController alertControllerWithTitle:@"提示" message:@"为了您的帐号更安全，请设置手势密码" preferredStyle:UIAlertControllerStyleAlert];
                    
                    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                        [userDefault setBool:YES forKey:@"isFirstSafe"];
                        [userDefault setBool:NO forKey:@"StartSafe"];
                        [self.navigationController popToRootViewControllerAnimated:YES];
                    }];
                    UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        
                        
                        [userDefault setBool:YES forKey:@"isSafe"];
                        [userDefault setBool:YES forKey:@"StartSafe"];
                        [userDefault setBool:YES forKey:@"isFirstSafe"];
                        [CLLockVC showSettingLockVCInVC:self successBlock:^(CLLockVC *lockVC, NSString *pwd) {
                            [lockVC dismiss:1.0f];
                        }];
                        [self.navigationController popToRootViewControllerAnimated:YES];
                    }];
                    [alter addAction:cancelAction];
                    [alter addAction:defaultAction];
                    [self presentViewController:alter
                                       animated:YES completion:nil];
                }
                
                
                [self.navigationController popToRootViewControllerAnimated:YES];

            }
        
        }
        
    } fail:^(NSError *error) {
        
        [_startRequest removeFromSuperview];
        _againBtn = [ProgressView againRequest];
        [_againBtn addTarget:self action:@selector(refresh) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_againBtn];
        
        UIAlertController *alter = [UIAlertController alertControllerWithTitle:@"网络错误" message:nil preferredStyle:UIAlertControllerStyleAlert];
        [self presentViewController:alter animated:YES completion:nil];
        _removeTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(removeLable) userInfo:nil repeats:NO];
    }];
}




#pragma mark ---按钮点击事件---
//注册
- (void)gotoRegist:(UIButton *)sender{
    
    RegistViewController *regist = [[RegistViewController alloc] init];
    [self.navigationController pushViewController:regist animated:YES];
}
//登录
- (void)gotoJoin:(UIButton *)sender{
    
    [_userText resignFirstResponder];
    [_passwordText resignFirstResponder];
    if ([_userText.text isEqualToString:@""] || [_passwordText.text isEqualToString:@""]) {

        UIAlertController *alter = [UIAlertController alertControllerWithTitle:@"请输入账号和密码" message:nil preferredStyle:UIAlertControllerStyleAlert];
        [self presentViewController:alter animated:YES completion:nil];
        _removeTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(removeLable) userInfo:nil repeats:NO];
    
    }else{
        
        [self requestData:@{@"phone":_userText.text, @"password":_passwordText.text}];
        [userDefault setObject:_userText.text forKey:@"phone"];
        [userDefault setObject:_passwordText.text forKey:@"password"];
    
        
    }
    
    
}
//登录通知
- (void)JoinNot{
    
    _view2.hidden = YES;
    [self requestData:@{@"phone":[userDefault stringForKey:@"phone"], @"password":[userDefault stringForKey:@"password"]}];
}


//忘记密码
- (void)forgetPassword:(UIButton *)sender{
    
    ForgetPwdViewController *forgetPwd = [[ForgetPwdViewController alloc] init];
    [self.navigationController pushViewController:forgetPwd animated:YES];
}

//刷新
- (void)refresh{
    
    [_againBtn removeFromSuperview];
    [self requestData:@{@"phone":[userDefault stringForKey:@"phone"], @"password":[userDefault stringForKey:@"password"]}];
}

//键盘的return键 点击时就会触发该方法
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}
//收键盘
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    [_userText resignFirstResponder];
    [_passwordText resignFirstResponder];
}

//退出登录的通知
- (void)ExitNot{
    
    _view2.hidden = NO;
    _view1.hidden = YES;
}


//移除提示
- (void)removeLable{
    
   [self dismissViewControllerAnimated:YES completion:nil];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 头像点击方法
- (void)clickButton
{
    UIAlertController *alter = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *defaultAction1 = [UIAlertAction actionWithTitle:@"图库" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        // 显示照片选择控制器
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc]init];
        
        [imagePicker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
        // 2) 是否允许编辑
        [imagePicker setAllowsEditing:YES];
        
        // 3) 设置代理
        imagePicker.delegate = self;
        
        imagePicker.navigationBar.tintColor = [UIColor blackColor];
        // 4) 显示照片选择控制器，显示modal窗口
        [self presentViewController:imagePicker animated:YES completion:nil];
       
    }];
    UIAlertAction *defaultAction2 = [UIAlertAction actionWithTitle:@"相机" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        // 显示照片选择控制器
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc]init];
        [imagePicker setSourceType:UIImagePickerControllerSourceTypeCamera];
        [imagePicker setAllowsEditing:YES];
        imagePicker.delegate = self;
        imagePicker.navigationBar.tintColor = [UIColor blackColor];
        [self presentViewController:imagePicker animated:YES completion:nil];
    }];
    [alter addAction:cancelAction];
    [alter addAction:defaultAction1];
    [alter addAction:defaultAction2];
    [self presentViewController:alter animated:YES completion:nil];
    
}

#pragma mark - UIImagePicker代理方法
//照片选择完成的代理方法
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    // 获取编辑后的照片
    UIImage *image = info[@"UIImagePickerControllerEditedImage"];
  
    [self dismissViewControllerAnimated:YES completion:^{
        
        // 设置照片
        [_headButton setImage:image forState:UIControlStateNormal];
        
    }];
}

//视图将要显示时调用
- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    if ([userDefault stringForKey:@"phone"] && [userDefault stringForKey:@"password"] && [userDefault boolForKey:@"isJoin"]) {
        [self requestData:@{@"phone":[userDefault stringForKey:@"phone"], @"password":[userDefault stringForKey:@"password"]}];
    }else if (y == 0) {
        
        [self creatUI2];
        
    }else{
        
        _view1.hidden = YES;
        _headLable.text = @"用户登录";
        _view2.hidden = NO;
    }
    self.tabBarController.tabBar.hidden = NO;
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [_removeTimer invalidate];
}

@end
