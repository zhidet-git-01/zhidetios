//
//  DetailViewController.m
//  zhidetDemo
//
//  Created by 刘璐璐 on 15/12/4.
//  Copyright © 2015年 刘璐璐. All rights reserved.
//

#import "DetailViewController.h"
#import "DetailSectionOneCell.h"
#import "DetailSectionTwoCell.h"
#import "DetailSectionThreeCell.h"
#import "RegistViewController.h"
#import "JoinViewController.h"
#import "BidViewController.h"
#import "platformModel.h"
#import "YJJRequest.h"

@interface DetailViewController ()<UITableViewDelegate,UITableViewDataSource, UITextFieldDelegate>

@end

@implementation DetailViewController
{
    UITableView *_tableView;
    UIButton *_bidButton;
    NSTimer *_removeTimer;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //设置导航栏
    UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
    lable.text = @"投资详情";
    lable.textAlignment = NSTextAlignmentCenter;
    lable.textColor = [UIColor whiteColor];
    lable.font = [UIFont systemFontOfSize:20];
    self.navigationItem.titleView = lable;
    UIButton *leftButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 15, 25)];
    [leftButton setBackgroundImage:[UIImage imageNamed:@"nav_return"] forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(returnHome:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    
    [self createUI];
    
    //接收通知
    [NotiCenter addObserver:self selector:@selector(gotoBid) name:@"Bid" object:nil];
    [NotiCenter addObserver:self selector:@selector(gotoSubmit:) name:@"Submit" object:nil];
}

- (void)createUI{
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, HEIGHT - 115, WIDTH, 50)];
    view.backgroundColor = TableViewBackColor;
    view.layer.borderColor = AwayColor.CGColor;
    view.layer.borderWidth = 1;
    [self.view addSubview:view];
    
    _bidButton = [[UIButton alloc] initWithFrame:CGRectMake(15, 5, WIDTH - 30, 42)];
    _bidButton.backgroundColor = BidColor;
    [_bidButton setTitle:@"马上去投标" forState:UIControlStateNormal];
    _bidButton.clipsToBounds = YES;
    _bidButton.layer.cornerRadius = 22;
    //投标
    [_bidButton addTarget:self action:@selector(gotoBid) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:_bidButton];
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT - 115) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    
    //注册cell
    [_tableView registerClass:[DetailSectionOneCell class] forCellReuseIdentifier:@"sectionOne"];
    [_tableView registerClass:[DetailSectionTwoCell class] forCellReuseIdentifier:@"sectionTwo"];
    [_tableView registerClass:[DetailSectionThreeCell class] forCellReuseIdentifier:@"sectionThree"];

    
}

#pragma mark ---tableViewDelegate---
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
         DetailSectionOneCell *cell = [tableView dequeueReusableCellWithIdentifier:@"sectionOne"];
        
        [cell createModel:_model];
        tableView.rowHeight = 90;
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else if (indexPath.section == 2){
        
        DetailSectionThreeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"sectionThree"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell createText:_model];
        tableView.rowHeight = cell.maxY;
        return cell;
    }
    
    DetailSectionTwoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"sectionTwo"];
    [cell createText:_model];
    tableView.rowHeight = cell.maxY;
    
    //button点击事件
    [cell.registButton addTarget:self action:@selector(gotoRegist:) forControlEvents:UIControlEventTouchUpInside];
    
    [cell.joinButton addTarget:self action:@selector(gotoJoin:) forControlEvents:UIControlEventTouchUpInside];
    
    [cell.nowRButton addTarget:self action:@selector(gotoRegist:) forControlEvents:UIControlEventTouchUpInside];

    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
     return 10;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark ---按钮点击时间---
//注册
- (void)gotoRegist:(UIButton *)sender{
    
    RegistViewController *regist = [[RegistViewController alloc] init];
    [self.navigationController pushViewController:regist animated:YES];
    
}
//登录
- (void)gotoJoin:(UIButton *)sender{
    
    JoinViewController *join = [[JoinViewController alloc] init];
    [self.navigationController pushViewController:join animated:YES];
}
//提交
- (void)gotoSubmit:(NSNotification *)notify{
    
    BOOL isJoin = [userDefault boolForKey:@"isJoin"];
    if (isJoin) {
        
        if ([notify.userInfo[@"submit"] isEqualToString:@""]) {
            //没有输入
            UIAlertController *alter = [UIAlertController alertControllerWithTitle:@"输入不能为空" message:nil preferredStyle:UIAlertControllerStyleAlert];
            [self presentViewController:alter animated:YES completion:nil];
            _removeTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(removeLable) userInfo:nil repeats:NO];
            
        }else if ( [self isMobileNumber:notify.userInfo[@"submit"]] == NO){
            //输入有误
            UIAlertController *alter = [UIAlertController alertControllerWithTitle:@"输入账号有误" message:nil preferredStyle:UIAlertControllerStyleAlert];
            [self presentViewController:alter animated:YES completion:nil];
            _removeTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(removeLable) userInfo:nil repeats:NO];
        
        }else{
            //账号匹配
            NSDictionary *dict = @{@"token":[userDefault stringForKey:@"token"], @"companyid":_model.companyid, @"account":notify.userInfo[@"submit"]};
            [YJJRequest PostrequestwithURL:SubmitURL dic:dict complete:^(NSData *data) {
                
                NSDictionary *result = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                if([result[@"resultCode"] integerValue] == 0){
                    
                    UIAlertController *alter = [UIAlertController alertControllerWithTitle:@"提交成功" message:nil preferredStyle:UIAlertControllerStyleAlert];
                    [self presentViewController:alter animated:YES completion:nil];
                    _removeTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(removeLable) userInfo:nil repeats:NO];
                    
                    
                }else{
                    
                    UIAlertController *alter = [UIAlertController alertControllerWithTitle:@"已发送" message:nil preferredStyle:UIAlertControllerStyleAlert];
                    [self presentViewController:alter animated:YES completion:nil];
                    _removeTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(removeLable) userInfo:nil repeats:NO];
                }
                
            } fail:^(NSError *error) {
                
                UIAlertController *alter = [UIAlertController alertControllerWithTitle:@"提交失败" message:nil preferredStyle:UIAlertControllerStyleAlert];
                [self presentViewController:alter animated:YES completion:nil];
                _removeTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(removeLable) userInfo:nil repeats:NO];
            }];
            
            
        }
        
    }else{
        //没有登录的情况下
        UIAlertController *alter = [UIAlertController alertControllerWithTitle:@"您还未登录" message:nil preferredStyle:UIAlertControllerStyleAlert];
        [self presentViewController:alter animated:YES completion:nil];
        _removeTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(removeLable) userInfo:nil repeats:NO];
    }
}

- (BOOL)isMobileNumber:(NSString *)mobileNum
{
        
    NSString *regex = @"^(0|86|17951)?(13[0-9]|15[012356789]|17[678]|18[0-9]|14[57])[0-9]{8}$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    if ([predicate evaluateWithObject:mobileNum]){
        return YES;
    }else{
        return NO;
}
}
    //投标
- (void)gotoBid{

    BOOL isJoin = [userDefault boolForKey:@"isJoin"];
    BOOL isFirstJoin = [userDefault boolForKey:@"isFirstJoin"];
    if (isJoin) {
        
        BidViewController *bid = [[BidViewController alloc] init];
        bid.officialsite = _model.officialsite;
        bid.navTitle = _model.title;
        [self.navigationController pushViewController:bid animated:YES];
        
    }else if (isFirstJoin){
        
        JoinViewController *join = [[JoinViewController alloc] init];
        [self.navigationController pushViewController:join animated:YES];
        
    }else{
        
        RegistViewController *regist = [[RegistViewController alloc] init];
        [self.navigationController pushViewController:regist animated:YES];
    }
    
}

//导航栏返回按钮
- (void)returnHome:(UIButton *)sender{
    
    [self.navigationController popViewControllerAnimated:YES];
}

//点击return 按钮 键盘消失
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

//移除提示
- (void)removeLable{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    [self viewDidLoad];
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
