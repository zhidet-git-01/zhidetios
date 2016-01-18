//
//  FirstViewController.m
//  zhidetDemo
//
//  Created by 刘璐璐 on 15/12/4.
//  Copyright © 2015年 刘璐璐. All rights reserved.
//

#import "FirstViewController.h"
#import "DetailViewController.h"
#import "CLLockVC.h"
#import "ResourceTableViewCell.h"
#import "YJJRequest.h"
#import "platformModel.h"
#import "JoinViewController.h"
#import <UIImageView+WebCache.h>
#import "ProgressView.h"
#import "MJRefresh.h"

@interface FirstViewController ()<UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate, MJRefreshBaseViewDelegate>

@end

@implementation FirstViewController
{
    UITableView *_tableView;
    UITableView *_pullTableView;
    UIButton *_returnTopButton;
    NSString *_appID;    //产品ID
    NSString *_latestVersion;   //产品版本号
    NSString *_trackViewUrl;    //产品链接
    NSString *_trackName;       //产品名称
    NSString *_currentVersion;  //当前版本号
    UIScrollView *_scrollView;
    UIPageControl *_pageControl; //小点点
    NSTimer *_timer;   //定时器
    NSMutableArray *_dataArray;   //平台数据源
    NSArray *_pullArray; //下拉菜单数据源
    UIButton *_rightButton;  //导航栏下拉按钮
    UIButton *_againBtn;  //刷新按钮
    UIView *_startRequest;   //刷新小菊花
    NSTimer *_removeTimer;
    MJRefreshHeaderView *_headView;    //刷新
    BOOL _isRefresh;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //设置导航栏
    [self createNav];
    _isRefresh = NO;
    
    BOOL isSafe = [userDefault boolForKey:@"isSafe"];
    BOOL isJoin = [userDefault boolForKey:@"isJoin"];
    if(!isSafe){
        
    }else if(isJoin){
        
        [CLLockVC showVerifyLockVCInVC:self forgetPwdBlock:^{
            
            [userDefault setBool:NO forKey:@"isSafe"];
            [userDefault setBool:NO forKey:@"isFirstSafe"];
            [userDefault setBool:NO forKey:@"StartSafe"];
            [userDefault setBool:NO forKey:@"isJoin"];
            [CLLockVC clearPwd];
            [NotiCenter postNotificationName:@"DownSafe" object:self userInfo:nil];
            [NotiCenter postNotificationName:@"Exited" object:self userInfo:nil];
            JoinViewController *join = [[JoinViewController alloc] init];
            [self.navigationController pushViewController:join animated:YES];
            
        } successBlock:^(CLLockVC *lockVC, NSString *pwd) {
            [lockVC dismiss:1.0f];
        }];
    }
    
    //数据源初始化
    _pullArray = [[NSMutableArray alloc] init];
    _pullArray = @[@"全部", @"未投标", @"未结束"];
    _dataArray = [[NSMutableArray alloc] init];
    
    //搭建UI
    [self createRefresh];
    [self createUI];
    
    //定时器
    [self time];
    
    //数据请求
    [self requestData];
    
    //版本更新提示
    [self updateAPP];
    
    //接受通知
    [NotiCenter addObserver:self selector:@selector(gotoMoney:) name:@"canBid" object:nil];
    
}
#pragma mark ---设置导航栏---
- (void)createNav{
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 90, 30)];
    imageView.image = [UIImage imageNamed:@"logo-white-all"];
    
    UIImageView *wordImage = [[UIImageView alloc] initWithFrame:CGRectMake(100, 10, 120, 15)];
    wordImage.image = [UIImage imageNamed:@"nav_word"];
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 240, 35)];
    [view addSubview:imageView];
    [view addSubview:wordImage];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:view];
    self.navigationItem.title = @"";
    
    _rightButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    [_rightButton setBackgroundImage:[UIImage imageNamed:@"nav_home_right"] forState:UIControlStateNormal];
    [_rightButton addTarget:self action:@selector(pullClick:) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_rightButton];
}

#pragma mark---搭建UI---
- (void)createUI{
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT - 65) style:UITableViewStylePlain
                  ];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.rowHeight = 265;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    
    UINib *nib = [UINib nibWithNibName:@"ResourceTableViewCell" bundle:nil];
    [_tableView registerNib:nib forCellReuseIdentifier:@"home"];
    
    //刷新
    _headView = [MJRefreshHeaderView header];
    _headView.scrollView = _tableView;
    _headView.delegate = self;
    
#pragma mark - ---添加头视图---
    
    //图片轮播
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, WIDTH, WIDTH * 0.4125)];
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, WIDTH * 0.4125)];
    _scrollView.contentSize = CGSizeMake(WIDTH * 3, WIDTH * 0.4125);
    _scrollView.backgroundColor = [UIColor clearColor];
    _scrollView.pagingEnabled = YES;
    _scrollView.delegate = self;
    _scrollView.showsHorizontalScrollIndicator = NO;
    [backButton addSubview:_scrollView];
    [self photoDataRequest];

    _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, _scrollView.frame.size.height - 20, WIDTH, 20)];
    _pageControl.numberOfPages = 3;
    [backButton addSubview:_pageControl];
    _pageControl.pageIndicatorTintColor = [UIColor whiteColor];
    _pageControl.currentPageIndicatorTintColor = [UIColor greenColor];
    _tableView.tableHeaderView = backButton;
    
       //返回顶部的button
    _returnTopButton = [[UIButton alloc] initWithFrame:CGRectMake(WIDTH - 30, HEIGHT - 150, 30, 30)];
    [_returnTopButton setBackgroundImage:[UIImage imageNamed:@"returnTop"] forState:UIControlStateNormal];
    [_returnTopButton addTarget:self action:@selector(returnTop) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_returnTopButton];
    _returnTopButton.hidden = YES;
    
    
}

#pragma mark ---刷新提示---
- (void)createRefresh{
    
    //刷新按钮
//    _refreshButton = [[UIButton alloc] initWithFrame:CGRectMake(WIDTH / 2 - 30, 220, 60, 20)];
//    [_refreshButton setTitle:@"点我刷新" forState:UIControlStateNormal];
//    [_refreshButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    _refreshButton.titleLabel.font = [UIFont systemFontOfSize:wordSize];
//    [_refreshButton addTarget:self action:@selector(refreshClick) forControlEvents:UIControlEventTouchUpInside];
//    
//    //请求中显示小菊花
//    _activity = [[UIActivityIndicatorView alloc]initWithFrame:CGRectMake(WIDTH / 2 - 5, 200, 10, 10)];
//    _activity.color = [UIColor blackColor];
    
}

#pragma mark ---图片数据请求---
- (void) photoDataRequest{
    
    [YJJRequest requestwithURL:PhotoURL dic:nil complete:^(NSData *data) {
        
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        NSArray *adList = dict[@"adList"];
        for (NSDictionary *photoDic in adList) {
            static int i = 0;
            UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(i++ * WIDTH, 0, WIDTH, WIDTH * 0.4125)];
            [button setTitle:photoDic[@"adPrdUrl"] forState:UIControlStateNormal];
            [button setTitleColor:[UIColor clearColor] forState:UIControlStateNormal];
            [button addTarget:self action:@selector(photoClick:) forControlEvents:UIControlEventTouchUpInside];
            
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, WIDTH * 0.4125)];
            NSString *urlString = photoDic[@"adPicUrl"];
            NSURL * iconURL = [NSURL URLWithString:urlString];
            UIImage * defaultImage = [UIImage imageNamed:@"loading"];
            [imageView sd_setImageWithURL:iconURL placeholderImage:defaultImage];
            
            [button addSubview:imageView];
            [_scrollView addSubview:button];
            
        }
        
    } fail:^(NSError *error) {
        
    }];
    
}

#pragma mark ---请求数据---
- (void)requestData{
    
    
    //请求中显示进度
    if (_isRefresh == NO) {
        
        _tableView.hidden = YES;
        _startRequest = [ProgressView startRequest];
        [self.view addSubview:_startRequest];
    }
    
    [YJJRequest requestwithURL:HomeURL dic:nil complete:^(NSData *data) {
        
        NSDictionary *resultDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        NSArray *companyListArray = resultDict[@"companyList"];
        [_dataArray removeAllObjects];
        for (NSDictionary *companyDict in companyListArray) {
            platformModel *model = [[platformModel alloc] init];
            model.activity = companyDict[@"activity"];
            model.info = companyDict[@"info"];
            model.prizeplan = companyDict[@"prizeplan"];
            model.recommendreason = companyDict[@"recommendreason"];
            model.title = companyDict[@"title"];
            model.regfound = companyDict[@"regfound"];
            model.starttime = companyDict[@"starttime"];
            model.logolittler = companyDict[@"logolittler"];
            model.officialsite = companyDict[@"mobilesite"];
            model.online = [companyDict[@"online"] integerValue];
            model.status = [companyDict[@"status"] integerValue];
            model.companyid = companyDict[@"id"];
            
            //字符切割
            NSString *string = companyDict[@"background"];
            NSArray *array = [string componentsSeparatedByString:@";"];
            for (int i = 0; i < array.count; i++) {
                if (i == 0) {
                    //获得百分比
                    NSArray *percentageArray = [array[i] componentsSeparatedByString:@"~"];
                    for (int j = 0; j < percentageArray.count; j++) {
                        NSArray *endArray = [percentageArray[j] componentsSeparatedByString:@"%"];
                        if (j == 0) {
                            model.min = endArray[0];
                        }else{
                            model.max = endArray[0];
                        }
                    }
                }else if (i == 1){
                    //公司背景
                    model.companyBack = array[i];
                }
            }
            
            //获取值得投最高奖励
            NSArray *moneyArray = [companyDict[@"prizeplan"] componentsSeparatedByString:@";"];
            model.price = [moneyArray lastObject];
            
            if (model.online == 0) {
                //在线添加到数据源
                [_dataArray addObject:model];
            }
        }
        
        [_tableView reloadData];
        [_headView endRefreshing];
        _isRefresh = NO;
        //移除小菊花
        [_startRequest removeFromSuperview];
        _tableView.hidden = NO;
        
        
    } fail:^(NSError *error) {
        
        if (_isRefresh == NO) {
            
            [_startRequest removeFromSuperview];
            _againBtn = [ProgressView againRequest];
            [_againBtn addTarget:self action:@selector(refreshClick) forControlEvents:UIControlEventTouchUpInside];
            [self.view addSubview:_againBtn];
        }
        
        [_headView endRefreshing];
        UIAlertController *alter = [UIAlertController alertControllerWithTitle:@"网络错误" message:nil preferredStyle:UIAlertControllerStyleAlert];
        [self presentViewController:alter animated:YES completion:nil];
        _removeTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(removeLable) userInfo:nil repeats:NO];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark ----tableViewDelegate---
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (tableView == _tableView) {
        return _dataArray.count;
    }
    return 3;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (tableView == _tableView) {
        
        ResourceTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"home"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:1];
        
        platformModel *model = _dataArray[indexPath.row];
        
        [cell createModel:model];
        
        return cell;
    }
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"pull"];
    cell.textLabel.text = _pullArray[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (tableView == _pullTableView) {
    
        _rightButton.selected = !_rightButton.selected;
        [_pullTableView removeFromSuperview];
        
        if (indexPath.row == 0) {
           
        }else if(indexPath.row == 1){
            
        }else if(indexPath.row == 2){
           
        }
        
        
    }
}
//删除定时器
-(void)removeNSTimer
{
    [_timer invalidate];
    _timer = nil;
}
#pragma mark ---scorllerView代理方法

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if (scrollView == _scrollView) {
        [self removeNSTimer];
    }
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView == _tableView) {

        if (scrollView.contentOffset.y > HEIGHT / 2) {
            _returnTopButton.hidden = NO;
        }else{
            _returnTopButton.hidden = YES;
        }
    }else if(scrollView == _scrollView){
        
        
        int page = scrollView.contentOffset.x / WIDTH;
        _pageControl.currentPage = page;
    }
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if(scrollView == _scrollView){
        int page = scrollView.contentOffset.x / WIDTH;
        _pageControl.currentPage = page;
        [self time];
    }
    
}

#pragma mark ----------------刷新代理方法
- (void) refreshViewBeginRefreshing:(MJRefreshBaseView *)refreshView{
    _isRefresh = YES;
    if (refreshView == _headView) {
        
        [self refreshClick];
    }
    
}

#pragma mark ---跳转至详情页面---
//提交
- (void)gotoMoney:(NSNotification *)notify{
    
    DetailViewController *detail = [[DetailViewController alloc] init];
    detail.model = notify.userInfo[@"canBid"];
    if ([notify.userInfo[@"canBid"] status] == 0) {
        [self.navigationController pushViewController:detail animated:YES];
    }else{
        
        UIAlertController *alter = [UIAlertController alertControllerWithTitle:@"投标已结束" message:nil preferredStyle:UIAlertControllerStyleAlert];
        [self presentViewController:alter animated:YES completion:nil];

        _removeTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(removeLable) userInfo:nil repeats:NO];
    }
    
}


#pragma mark ---按钮点击事件---
- (void)returnTop{
    
    [_tableView setContentOffset:CGPointMake(0, 0) animated:YES];
}


//定时器
- (void)time{
    
    _timer = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(change) userInfo:nil repeats:YES];
    //添加到runloop中
    [[NSRunLoop mainRunLoop]addTimer:_timer forMode:NSRunLoopCommonModes];
}
//定时器所触发方法 实现滚动图片
- (void)change{
    
    if (_scrollView.contentOffset.x >= WIDTH * 2 ) {
        
        [UIView animateWithDuration:0.2 animations:^{
            CGPoint point;
            point = CGPointMake(0, 0);
            _scrollView.contentOffset = point;
        }];
        
    }else{
        [UIView animateWithDuration:0.2 animations:^{
            CGPoint point;
            point = CGPointMake(_scrollView.contentOffset.x + WIDTH, _scrollView.contentOffset.y);
            _scrollView.contentOffset = point;
        }];
        
    }
    
}

- (void)photoClick:(UIButton *)sender{
    
    [YJJRequest requestwithURL:sender.titleLabel.text dic:nil complete:^(NSData *data) {
        NSDictionary *result = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        if ([result[@"resultCode"] longLongValue] == 0) {
            platformModel *model = [[platformModel alloc] init];
            NSDictionary *companyDict = result[@"companySingle"];
            model.activity = companyDict[@"activity"];
            model.info = companyDict[@"info"];
            model.prizeplan = companyDict[@"prizeplan"];
            model.recommendreason = companyDict[@"recommendreason"];
            model.title = companyDict[@"title"];
            model.regfound = companyDict[@"regfound"];
            model.starttime = companyDict[@"starttime"];
            model.logolittler = companyDict[@"logolittler"];
            model.officialsite = companyDict[@"mobilesite"];
            model.online = [companyDict[@"online"] integerValue];
            model.status = [companyDict[@"status"] integerValue];
            model.companyid = companyDict[@"id"];
            
            //字符切割
            NSString *string = companyDict[@"background"];
            NSArray *array = [string componentsSeparatedByString:@";"];
            for (int i = 0; i < array.count; i++) {
                if (i == 0) {
                    //获得百分比
                    NSArray *percentageArray = [array[i] componentsSeparatedByString:@"~"];
                    for (int j = 0; j < percentageArray.count; j++) {
                        NSArray *endArray = [percentageArray[j] componentsSeparatedByString:@"%"];
                        if (j == 0) {
                            model.min = endArray[0];
                        }else{
                            model.max = endArray[0];
                        }
                    }
                }else if (i == 1){
                    //公司背景
                    model.companyBack = array[i];
                }
            }
            
            //获取值得投最高奖励
            NSArray *moneyArray = [companyDict[@"prizeplan"] componentsSeparatedByString:@";"];
            model.price = [moneyArray lastObject];
            DetailViewController *detail = [[DetailViewController alloc] init];
            detail.model = model;
            [self.navigationController pushViewController:detail animated:YES];
            
        }else{
            UIAlertController *alter = [UIAlertController alertControllerWithTitle:@"投标已结束" message:nil preferredStyle:UIAlertControllerStyleAlert];
            [self presentViewController:alter animated:YES completion:nil];
            _removeTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(removeLable) userInfo:nil repeats:NO];
        }
        
    } fail:^(NSError *error) {
        
        UIAlertController *alter = [UIAlertController alertControllerWithTitle:@"网络错误" message:nil preferredStyle:UIAlertControllerStyleAlert];
        [self presentViewController:alter animated:YES completion:nil];
        _removeTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(removeLable) userInfo:nil repeats:NO];
    }];
}

//下拉菜单
- (void)pullClick:(UIButton *)sender{
    
    sender.selected = !sender.selected;
    if (sender.selected) {
        
        
        
        _pullTableView = [[UITableView alloc] initWithFrame:CGRectMake(WIDTH - 110, 0, 105, 90)];
        _pullTableView.rowHeight = 30;
        _pullTableView.backgroundColor = [UIColor whiteColor];
        _pullTableView.delegate = self;
        _pullTableView.dataSource = self;
        [self.view addSubview:_pullTableView];
        
        [_pullTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"pull"];
        
    }else{
        
        [_pullTableView removeFromSuperview];
    }
}

//刷新
- (void)refreshClick{
    [_againBtn removeFromSuperview];
    [self requestData];
    [self photoDataRequest];
}

//移除提示
- (void)removeLable{
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark ---版本更新---
- (void)updateAPP{
    
    //查询最新版本号
    _appID = @"1071751271";
    NSString *urlStr = [NSString stringWithFormat:@"http://itunes.apple.com/lookup?id=%@", _appID];
    [YJJRequest requestwithURL:urlStr dic:nil complete:^(NSData *data) {
        NSDictionary *appInfoDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        NSArray *resultsArray = [appInfoDic objectForKey:@"results"];
        if (![resultsArray count]) {
            return;
        }
        NSDictionary *infoDic = [resultsArray objectAtIndex:0];
        _latestVersion = [infoDic objectForKey:@"version"];;
        _trackViewUrl = [infoDic objectForKey:@"trackViewUrl"];
        _trackName = [infoDic objectForKey:@"trackName"];
        
        
        //获取当前的版本号
        NSDictionary *infoDict = [[NSBundle mainBundle] infoDictionary];
        _currentVersion = [infoDict objectForKey:@"CFBundleVersion"];
        
        double doubleCurrentVersion = [_currentVersion doubleValue];
        double doubleUpdataVersion = [_latestVersion doubleValue];
        
        if (doubleCurrentVersion < doubleUpdataVersion) {
            UIAlertController *alter = [UIAlertController alertControllerWithTitle:@"版本更新" message:[NSString stringWithFormat:@"发现新版本(%@),是否升级？",_latestVersion] preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"稍后再说" style:UIAlertActionStyleCancel handler:nil];
            UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"立即更新" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {

                [[UIApplication sharedApplication]openURL:[NSURL URLWithString:_trackViewUrl]];
            }];
            [alter addAction:cancelAction];
            [alter addAction:defaultAction];
            [self presentViewController:alter animated:YES completion:nil];
        }else{
//            
//            UIAlertController *alter = [UIAlertController alertControllerWithTitle:@"已是最新版本" message:nil preferredStyle:UIAlertControllerStyleAlert];
//            UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
//            [alter addAction:defaultAction];
//            [self presentViewController:alter animated:YES completion:nil];
        }
        
    } fail:^(NSError *error) {

        NSLog(@"最新版本");
    }];
    

}
- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = NO;
    [_removeTimer invalidate];
}
- (void)dealloc{
    [_headView free];
}

@end
