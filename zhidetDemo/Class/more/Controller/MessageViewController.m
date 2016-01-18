//
//  MessageViewController.m
//  zhidetDemo
//
//  Created by 刘璐璐 on 15/12/22.
//  Copyright © 2015年 刘璐璐. All rights reserved.
//

#import "MessageViewController.h"
#import "YJJRequest.h"

@interface MessageViewController ()<UITextViewDelegate>

@end

@implementation MessageViewController
{
    UILabel *_placeholderLable;
    UITextView *_messageText;
    NSTimer *_removeTimer;
    UIAlertController *_alter;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = TableViewBackColor;
    
    [self createNAV];
    [self createUI];
}

- (void)createNAV{
    
    //设置导航栏
    UILabel *titleLable = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
    titleLable.textAlignment = NSTextAlignmentCenter;
    titleLable.textColor = [UIColor whiteColor];
    titleLable.text = @"提建议";
    titleLable.font = [UIFont systemFontOfSize:20];
    self.navigationItem.titleView = titleLable;
    
    UIButton *leftButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 15, 25)];
    [leftButton setBackgroundImage:[UIImage imageNamed:@"nav_return"] forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(returnHome:) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
}


- (void)createUI{
    
    _messageText = [[UITextView alloc] initWithFrame:CGRectMake(20, 20, WIDTH - 40, 200)];
    [_messageText setAutocapitalizationType:UITextAutocapitalizationTypeNone];
    _messageText.delegate = self;
    _messageText.font = [UIFont systemFontOfSize:wordSize];
    _messageText.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_messageText];
    
    _placeholderLable = [[UILabel alloc]initWithFrame:CGRectMake(2, 5, WIDTH - 42, 20)];
    _placeholderLable.font = [UIFont systemFontOfSize:wordSize];
    _placeholderLable.text = @"请输入您的建议内容(100字以内)";
    _placeholderLable.textColor = TableViewBackColor;
    _placeholderLable.enabled = NO;
    [_messageText addSubview:_placeholderLable];
    
    UIButton *submitButton = [[UIButton alloc]initWithFrame:CGRectMake(20, 240, WIDTH - 40, 40)];
    submitButton.backgroundColor = BidColor;
    submitButton.clipsToBounds = YES;
    submitButton.layer.cornerRadius = 5;
    [submitButton addTarget:self action:@selector(submitClick:) forControlEvents:UIControlEventTouchUpInside];
    [submitButton setTitle:@"提交" forState:UIControlStateNormal];
    [self.view addSubview:submitButton];
}

-(void)textViewDidChange:(UITextView *)textView
{
    
    if ([textView.text isEqualToString:@""]) {
        _placeholderLable.text = @"请输入您的建议内容(100字以内)";
    }else{
        _placeholderLable.text = @"";
    }
}

- (void)submitClick:(UIButton *)sender{

    [_messageText resignFirstResponder];
    if ([_messageText.text isEqualToString:@""]) {
        
        UIAlertController *alter = [UIAlertController alertControllerWithTitle:@"内容不能为空" message:nil preferredStyle:UIAlertControllerStyleAlert];
        [self presentViewController:alter animated:YES completion:nil];
        _removeTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(removeLable) userInfo:nil repeats:NO];
    }else if(_messageText.text.length > 100){
        
        UIAlertController *alter = [UIAlertController alertControllerWithTitle:@"输入内容太长了" message:nil preferredStyle:UIAlertControllerStyleAlert];
        [self presentViewController:alter animated:YES completion:nil];
        _removeTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(removeLable) userInfo:nil repeats:NO];
    }else{
        
        NSDictionary *dic = @{@"token":[userDefault stringForKey:@"token"], @"content":_messageText.text};
        [YJJRequest PostrequestwithURL:MessageURL dic:dic complete:^(NSData *data) {
            
            NSDictionary *result = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            if([result[@"resultCode"] longValue] == 0){
                
                _alter = [UIAlertController alertControllerWithTitle:@"提交成功" message:nil preferredStyle:UIAlertControllerStyleAlert];
                [self presentViewController:_alter animated:YES completion:nil];
                _removeTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(removeLable) userInfo:nil repeats:NO];
                
            }else{
                
                UIAlertController *alter = [UIAlertController alertControllerWithTitle:@"提交失败" message:nil preferredStyle:UIAlertControllerStyleAlert];
                [self presentViewController:alter animated:YES completion:nil];
                _removeTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(removeLable) userInfo:nil repeats:NO];
            }
            
        } fail:^(NSError *error) {
            
        }];
    }
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    [_messageText resignFirstResponder];

    
}

//导航栏返回按钮
- (void)returnHome:(UIButton *)sender{
    
    [self.navigationController popViewControllerAnimated:YES];
}

//移除提示
- (void)removeLable{
    
    if ([_alter.title isEqualToString:@"提交成功"]) {
        
        [self dismissViewControllerAnimated:YES completion:nil];
        [self.navigationController popViewControllerAnimated:YES];
        
    }else{
        
        [self dismissViewControllerAnimated:YES completion:nil];
    }
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
