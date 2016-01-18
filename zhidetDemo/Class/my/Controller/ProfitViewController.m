//
//  ProfitViewController.m
//  zhidetDemo
//
//  Created by 刘璐璐 on 15/12/15.
//  Copyright © 2015年 刘璐璐. All rights reserved.
//

#import "ProfitViewController.h"
#import "ProfitTableViewCell.h"
#import "YJJRequest.h"
#import "UserModel.h"
#import "ProgressView.h"

@interface ProfitViewController ()<UIScrollViewDelegate, UITableViewDataSource, UITableViewDelegate>

@end

@implementation ProfitViewController
{
    UIScrollView *_scrollView;
    UILabel *_lineLable;
    UITableView *_tableView;
    NSMutableArray *_dataArray;
    UIButton *_upBtn;       //上一个所点击的按钮
    UIButton *_againBtn;  //刷新按钮
    UIView *_startRequest;   //刷新小菊花
    NSTimer *_removeTimer;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = TableViewBackColor;
    
    [self createNAV];
    
    _dataArray = [[NSMutableArray alloc] init];
    
    [self createTableView];
    
    [self requestData];
    
//    [self createUI];

}

- (void)createNAV{
    
    UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
    lable.text = @"我的返利";
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
    
    NSArray *array = @[@"全部", @"审核中", @"审核失败", @"返利"];
    for (int i = 0; i < 4; i++) {
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(i * (WIDTH / 4), 10, WIDTH / 4, 40)];
        button.backgroundColor = [UIColor whiteColor];
        [button setTitle:array[i] forState:UIControlStateNormal];
        
        if (i == 0) {
            [button setTitleColor:BackColor forState:UIControlStateNormal];
        }else{
            [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        }
        button.titleLabel.font = [UIFont systemFontOfSize:15];
        button.tag = i + 1;
        [button addTarget:self action:@selector(changeClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:button];
        
    }
    _lineLable = [[UILabel alloc] initWithFrame:CGRectMake(0, 48, WIDTH / 4, 2)];
    _lineLable.backgroundColor = BackColor;
    [self.view addSubview:_lineLable];
    
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 60, WIDTH, HEIGHT - 170)];
    _scrollView.pagingEnabled = YES;
    _scrollView.bounces = NO;
    _scrollView.delegate = self;
    _scrollView.backgroundColor = [UIColor clearColor];
    _scrollView.contentSize = CGSizeMake(WIDTH * 4, HEIGHT - 170);
    _scrollView.backgroundColor = TableViewBackColor;
    [self.view addSubview:_scrollView];
    
    [self createScrollView];
    
}

- (void)createTableView{
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 10, WIDTH, HEIGHT - 10)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.rowHeight = 100;
    _tableView.backgroundColor = TableViewBackColor;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    
    [_tableView registerClass:[ProfitTableViewCell class] forCellReuseIdentifier:@"profit"];

}



#pragma mark ---数据请求---
- (void)requestData{
    //请求中显示小菊花
    [_againBtn removeFromSuperview];
    _startRequest = [ProgressView startRequest];
    [self.view addSubview:_startRequest];
    
    _tableView.hidden = YES;
    
    NSDictionary *dict = @{@"token":_token};
    [YJJRequest PostrequestwithURL:ProfitURL dic:dict complete:^(NSData *data) {
        
        NSDictionary *resultDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        NSArray *resultArray = resultDic[@"returnMoneyEntityList"];
        if (resultArray.count == 0) {
            
            [_startRequest removeFromSuperview];
            
            UIAlertController *alter = [UIAlertController alertControllerWithTitle:@"暂无返利" message:nil preferredStyle:UIAlertControllerStyleAlert];
            [self presentViewController:alter animated:YES completion:nil];
            _removeTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(removeLable) userInfo:nil repeats:NO];
            [_tableView removeFromSuperview];

        }else{
            
            for (NSDictionary *dict in resultArray) {
                UserModel *model = [[UserModel alloc] init];
                model.headImage = dict[@"companyLogo"];
                model.companyTitle = dict[@"companyTitle"];
                model.creattime = dict[@"creattime"];
                model.money = dict[@"money"];
                model.phone = dict[@"phone"];
                model.returnMoney = dict[@"returnMoney"];
                model.companybg = dict[@"companybg"];
                [_dataArray addObject:model];
            }
            [_tableView reloadData];
            [_startRequest removeFromSuperview];
            _tableView.hidden = NO;
        }
        
    } fail:^(NSError *error) {
        
        _againBtn = [ProgressView againRequest];
        [_againBtn addTarget:self action:@selector(requestData) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_againBtn];
        
        UIAlertController *alter = [UIAlertController alertControllerWithTitle:@"网络错误 请求失败" message:nil preferredStyle:UIAlertControllerStyleAlert];
        [self presentViewController:alter animated:YES completion:nil];
        _removeTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(removeLable) userInfo:nil repeats:NO];
    }];
}

#pragma mark ---创建滚动视图的view---

- (void)createScrollView{
    
    for (int i = 0; i < 4; i++) {
        
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(i * WIDTH, 0, WIDTH, _scrollView.frame.size.height)];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 100;
        _tableView.backgroundColor = TableViewBackColor;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_scrollView addSubview:_tableView];
        
        [_tableView registerClass:[ProfitTableViewCell class] forCellReuseIdentifier:@"profit"];
    }
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
        _lineLable.frame = CGRectMake(sender.frame.origin.x, 48, WIDTH / 4, 2);
        CGPoint point;
        point = CGPointMake(WIDTH * (sender.tag - 1), _scrollView.contentOffset.y);
        _scrollView.contentOffset = point;
    }];
    _upBtn = sender;
}


//导航栏返回按钮
- (void)returnHome:(UIButton *)sender{
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark ---scrollViewDelegate---

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    if (_upBtn == nil) {
        
        _upBtn = (UIButton *)[self.view viewWithTag:1];
    }
    UIButton *button2 = (UIButton *)[self.view viewWithTag:scrollView.contentOffset.x / WIDTH + 1];
        
    [_upBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button2 setTitleColor:BackColor forState:UIControlStateNormal];
    [UIView animateWithDuration:0.1 animations:^{
        _lineLable.frame = CGRectMake(button2.frame.origin.x, 48, WIDTH / 4, 2);
    }];
    _upBtn = button2;
}



#pragma mark ---tableViewDelegate---

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return _dataArray.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    ProfitTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"profit"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    UserModel *model = _dataArray[indexPath.row];
    cell.layer.borderColor = TableViewBackColor.CGColor;
    cell.layer.borderWidth = 1;
    [cell createText:model];
    return cell;
}

//移除提示
- (void)removeLable{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    self.tabBarController.tabBar.hidden = NO;
    [super viewWillDisappear:animated];
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
