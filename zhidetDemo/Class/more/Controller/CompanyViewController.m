//
//  AboutWeViewController.m
//  zhidetDemo
//
//  Created by 刘璐璐 on 15/12/15.
//  Copyright © 2015年 刘璐璐. All rights reserved.
//

#import "CompanyViewController.h"
#import "CompanyTableViewCell.h"


@interface CompanyViewController ()<UITableViewDataSource, UITableViewDelegate>

@end

@implementation CompanyViewController
{
    UITableView *_tableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self createNAV];
    [self createUI];
}
- (void)createNAV{
    
    //设置导航栏
    UILabel *titleLable = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
    titleLable.textAlignment = NSTextAlignmentCenter;
    titleLable.textColor = [UIColor whiteColor];
    titleLable.text = _titleStr;
    titleLable.font = [UIFont systemFontOfSize:20];
    self.navigationItem.titleView = titleLable;
    
    UIButton *leftButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 15, 25)];
    [leftButton setBackgroundImage:[UIImage imageNamed:@"nav_return"] forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(returnHome:) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];

}

- (void)createUI{
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT - 16)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:_tableView];
    
    [_tableView registerClass:[CompanyTableViewCell class] forCellReuseIdentifier:@"company"];
    
    //投标跳转的网页
//    UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT - 65)];
//    NSURL *url = [NSURL URLWithString:_urlString];
//    NSURLRequest *request = [NSURLRequest requestWithURL:url];
//    [webView loadRequest:request];
//    [webView setScalesPageToFit:YES];
//    [self.view addSubview:webView];

}

#pragma mark --tableViewDelegate---

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    CompanyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"company"];
    _tableView.rowHeight = cell.maxY;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}



//导航栏返回按钮
- (void)returnHome:(UIButton *)sender{
    
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    self.tabBarController.tabBar.hidden = NO;
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
