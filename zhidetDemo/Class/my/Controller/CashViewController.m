//
//  CashViewController.m
//  zhidetDemo
//
//  Created by 刘璐璐 on 15/12/15.
//  Copyright © 2015年 刘璐璐. All rights reserved.
//

#import "CashViewController.h"
#import "CashTableViewCell.h"
#import "YJJRequest.h"
#import "cashModel.h"
#import "ProgressView.h"

@interface CashViewController ()<UIScrollViewDelegate, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>

@end

static int s = 60;

@implementation CashViewController
{
    UIScrollView *_scrollView;
    UILabel *_lineLable;
    UIView *_bankView;     //银行视图
    UIView *_payView;   //支付宝视图
    UIView *_changeView;    //修改视图
    NSTimer *_time;
    UITableView *_tableView;
    UIButton *_chooseButton;
    UIView *_addpayWay;         //已提交视图
    UIView *_noAddpayWay;       //没提交视图
    UIButton *_upBtn;       //上一个所点击的按钮
    UIButton *_upwayBtn;    //上一个所点击支付方式的按钮
    NSArray *_wayArray;
    NSInteger way;
    NSMutableArray *_dataArray;
    NSInteger _show;
    NSTimer *_removeTimer;
    UIView *_startRequest;
    UIButton *_againBtn;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = TableViewBackColor;
    _dataArray = [[NSMutableArray alloc] init];
    
    [self createNAV];
    
    [self createUI];
    
    [self showAndHide];
}

- (void)createNAV{
    
    UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
    lable.text = @"现金提取";
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
    
    NSArray *array = @[@"申请提现", @"提现记录"];
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
        button.titleLabel.font = [UIFont systemFontOfSize:wordSize];
        [button addTarget:self action:@selector(changeClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:button];
        
    }
    _lineLable = [[UILabel alloc] initWithFrame:CGRectMake(0, 48, WIDTH / 2, 2)];
    _lineLable.backgroundColor = BackColor;
    [self.view addSubview:_lineLable];
    
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 60, WIDTH, HEIGHT - 125)];
    _scrollView.pagingEnabled = YES;
    _scrollView.delegate = self;
    _scrollView.bounces = NO;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.backgroundColor = [UIColor clearColor];
    _scrollView.contentSize = CGSizeMake(WIDTH * 2, HEIGHT - 125);
    _scrollView.backgroundColor = TableViewBackColor;
    [self.view addSubview:_scrollView];
    
    [self createScrollView1];
    [self createScrollView2];
    
}

#pragma mark ---数据请求---
- (void)requestData{
    
    [_againBtn removeFromSuperview];
    _startRequest = [ProgressView startRequest];
    
    NSDictionary *dict = @{@"token":_token};
    [YJJRequest PostrequestwithURL:CashWayURL dic:dict complete:^(NSData *data) {
        NSDictionary *result = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
         NSDictionary *listDic = result[@"entity"];
        
        way = [listDic[@"type"] longValue];
        if ([listDic[@"type"] longValue] == 0) {
            //没有绑定
            [self createViewNoAdd];
            
        }else if ([listDic[@"type"] longValue] == 2){
            //已绑定支付宝
            _wayArray = @[@"  支付宝账号:", @"  支付宝姓名:", @"  验   证   码:", @"  提 现 金 额:"];
            _account = listDic[@"account"];
            _userName = listDic[@"nickname"];
            _payid = [listDic[@"id"] integerValue];
            [self createViewAdded];
            
        }else if ([listDic[@"type"] longValue] == 3){
            //已绑定银行卡
            _wayArray = @[@"  银行卡号：", @"  银行户名：", @"  验  证  码：", @"  提现金额："];
            _account = listDic[@"bankaccount"];
            _userName = listDic[@"bankname"];
            _payid = [listDic[@"id"] integerValue];
            [self createViewAdded];
        }else{
            
            [_startRequest removeFromSuperview];
            _againBtn = [ProgressView againRequest];
            [_againBtn addTarget:self action:@selector(requestData) forControlEvents:UIControlEventTouchUpInside];
            [self.view addSubview:_againBtn];
            
            UIAlertController *alter = [UIAlertController alertControllerWithTitle:@"获取信息失败" message:nil preferredStyle:UIAlertControllerStyleAlert];
            [self presentViewController:alter animated:YES completion:nil];
            _removeTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(removeLable) userInfo:nil repeats:NO];
           
        }
        
    } fail:^(NSError *error) {
        
        [_startRequest removeFromSuperview];
        _againBtn = [ProgressView againRequest];
        [_againBtn addTarget:self action:@selector(requestData) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_againBtn];
        
        UIAlertController *alter = [UIAlertController alertControllerWithTitle:@"网络错误 获取信息失败" message:nil preferredStyle:UIAlertControllerStyleAlert];
        [self presentViewController:alter animated:YES completion:nil];
        _removeTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(removeLable) userInfo:nil repeats:NO];
       
    }];

}
//刷新可用余额
- (void)requestDataMoney{
    
    NSDictionary *dict = @{@"phone":[userDefault stringForKey:@"phone"], @"password":[userDefault stringForKey:@"password"]};
    [YJJRequest PostrequestwithURL:LoginURL dic:dict complete:^(NSData *data) {
        NSDictionary *result = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        
        _token = result[@"token"];
        if ([result[@"resultCode"] longValue] == 0) {
            NSDictionary *userDic = result[@"user2"];
            _money = userDic[@"usablemoney"];
            [self requestData];
        }else{
            UIAlertController *alter = [UIAlertController alertControllerWithTitle:@"获取信息失败" message:nil preferredStyle:UIAlertControllerStyleAlert];
            [self presentViewController:alter animated:YES completion:nil];
            _removeTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(removeLable) userInfo:nil repeats:NO];
            
        }

        
    } fail:^(NSError *error) {
        
        UIAlertController *alter = [UIAlertController alertControllerWithTitle:@"网络错误 获取信息失败" message:nil preferredStyle:UIAlertControllerStyleAlert];
        [self presentViewController:alter animated:YES completion:nil];
        _removeTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(removeLable) userInfo:nil repeats:NO];
      
    }];
}
//请求提现记录
- (void)requestCashRecord{
    
    NSDictionary *dict = @{@"operateType":[NSNumber numberWithInteger:3], @"token":_token};
    [YJJRequest PostrequestwithURL:CashRecordURL dic:dict complete:^(NSData *data) {
        
        NSDictionary *resutl = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        if ([resutl[@"resultCode"] longLongValue] == 0) {
            
            NSArray *listArray = resutl[@"traderList"];
            [_dataArray removeAllObjects];
            for (NSDictionary *listDic in listArray) {
                cashModel *model = [[cashModel alloc] init];
                model.updattime = listDic[@"updattime"];
                model.trademoney = listDic[@"trademoney"];
                model.status = listDic[@"status"];
                [_dataArray addObject:model];
            }
            [_tableView reloadData];
            
            if (listArray.count == 0) {
                UIAlertController *alter = [UIAlertController alertControllerWithTitle:@"暂无提现记录" message:nil preferredStyle:UIAlertControllerStyleAlert];
                [self presentViewController:alter animated:YES completion:nil];
                _removeTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(removeLable) userInfo:nil repeats:NO];
            }
            
        }else{
            
            UIAlertController *alter = [UIAlertController alertControllerWithTitle:@"暂无提现记录" message:nil preferredStyle:UIAlertControllerStyleAlert];
            [self presentViewController:alter animated:YES completion:nil];
            _removeTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(removeLable) userInfo:nil repeats:NO];
            
        }
        
        
    } fail:^(NSError *error) {
        
        UIAlertController *alter = [UIAlertController alertControllerWithTitle:@"网络错误 请求失败" message:nil preferredStyle:UIAlertControllerStyleAlert];
        [self presentViewController:alter animated:YES completion:nil];
        _removeTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(removeLable) userInfo:nil repeats:NO];
    
    }];
}



#pragma mark ---创建滚动视图的view---

- (void)createScrollView1{
    
    [self requestData];
//    [self createViewAdded];
//    [self createViewNoAdd];
//    [self createChange];
}

//没有绑定支付宝或银行卡的界面
- (void)createViewNoAdd{
    
    _show = 0;
    _addpayWay.hidden = YES;
    _noAddpayWay = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, _scrollView.frame.size.height)];
    [_scrollView addSubview:_noAddpayWay];
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 60)];
    view.backgroundColor = [UIColor whiteColor];
    [_noAddpayWay addSubview:view];
    NSArray *array = @[@"添加支付宝", @"添加银行卡"];
    for (int i = 0; i < 2; i++) {
        
        UIButton *addButton = [[UIButton alloc] initWithFrame:CGRectMake(20 + ((WIDTH - 60) / 2 + 20) * i, 10, (WIDTH - 60) / 2, 40)];
        
        addButton.backgroundColor = BackColor;
        
        if (i != 0) {
            addButton.backgroundColor = [UIColor whiteColor];
            [addButton setTitleColor:wordColor forState:UIControlStateNormal];
        }
        addButton.titleLabel.font = [UIFont systemFontOfSize:wordSize];
        addButton.layer.borderColor = TableViewBackColor.CGColor;
        addButton.layer.borderWidth = 1;
        addButton.tag = i + 10;
        [addButton setTitle:array[i] forState:UIControlStateNormal];
        [addButton addTarget:self action:@selector(addClick:) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:addButton];
    }
    
    _payView = [[UIView alloc] initWithFrame:CGRectMake(0, 70, WIDTH, HEIGHT - 120)];
    [_noAddpayWay addSubview:_payView];
    NSArray *payArray = @[@"  支付宝账号：", @"  支付宝姓名：", @"  验  证  码："];
    
    for (int i = 0; i < 3; i++) {
        
        UILabel *payLable = [[UILabel alloc] initWithFrame:CGRectMake(0, i * 42, 100, 40)];
        payLable.text = payArray[i];
        payLable.font = [UIFont systemFontOfSize:wordSize];
        payLable.backgroundColor = [UIColor whiteColor];
        payLable.textColor = wordColor;
        [_payView addSubview:payLable];
        
        UITextField *payText = [[UITextField alloc] initWithFrame:CGRectMake(100, i * 42, WIDTH - 100, 40)];
        payText.delegate = self;
        payText.placeholder = @"必填";
        payText.font = [UIFont systemFontOfSize:wordSize];
        payText.backgroundColor = [UIColor whiteColor];
        payText.tag = i + payTextTag;
        payText.clearButtonMode = YES;
        [_payView addSubview:payText];
        if (i == 2) {
            payText.frame = CGRectMake(90, i * 42, WIDTH - 200, 40);
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(WIDTH - 110, i * 42, 110, 40)];
            view.backgroundColor = [UIColor whiteColor];
            [_payView addSubview:view];
            [view addSubview:[self createSendButton]];
        }
    }
    UIButton *payButton = [[UIButton alloc] initWithFrame:CGRectMake(20, 42 * 3 + 10, WIDTH - 40, 40)];
    payButton.backgroundColor = BidColor;
    payButton.clipsToBounds = YES;
    [payButton setTitle:@"确认添加" forState:UIControlStateNormal];
    payButton.layer.cornerRadius = 10;
    [payButton addTarget:self action:@selector(addPayWay:) forControlEvents:UIControlEventTouchUpInside];
    [_payView addSubview:payButton];
    
    _bankView = [[UIView alloc] initWithFrame:CGRectMake(0, 70, WIDTH, HEIGHT - 120)];
    [_noAddpayWay addSubview:_bankView];
    
    NSArray *bankArray = @[@"  开户银行：", @"  支行名称：", @"  开 户 名：", @"  银行账号：", @"  验 证 码："];
    
    for (int i = 0; i < 5; i++) {
        
        UILabel *subLable = [[UILabel alloc] initWithFrame:CGRectMake(0, i * 42, 90, 40)];
        subLable.text = bankArray[i];
        subLable.font = [UIFont systemFontOfSize:wordSize];
        subLable.textColor = wordColor;
        subLable.backgroundColor = [UIColor whiteColor];
        [_bankView addSubview:subLable];
        
        if (i == 0) {
            
            subLable.frame = CGRectMake(0, i * 42, WIDTH, 40);
            _chooseButton = [[UIButton alloc] initWithFrame:CGRectMake(90, 10, 100, 20)];
            _chooseButton.titleLabel.font = [UIFont systemFontOfSize:wordSize];
            [_chooseButton setTitle:@"🏦请选择银行" forState:UIControlStateNormal];
            [_chooseButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
            _chooseButton.backgroundColor = AwayColor;
            [_chooseButton addTarget:self action:@selector(chooseBank:) forControlEvents:UIControlEventTouchUpInside];
            [_bankView addSubview:_chooseButton];
            
        }else{
            
            UITextField *subText = [[UITextField alloc] initWithFrame:CGRectMake(90, i * 42, WIDTH - 90, 40)];
            subText.delegate = self;
            subText.placeholder = @"必填";
            subText.tag = i + bankTextTag;
            subText.font = [UIFont systemFontOfSize:wordSize];
            subText.backgroundColor = [UIColor whiteColor];
            subText.clearButtonMode = YES;
            [_bankView addSubview:subText];
            
            if (i == 4) {
                subText.frame = CGRectMake(90, i * 42, WIDTH - 200, 40);
                UIView *view = [[UIView alloc] initWithFrame:CGRectMake(WIDTH - 110, i * 42, 110, 40)];
                view.backgroundColor = [UIColor whiteColor];
                [_bankView addSubview:view];
                [view addSubview:[self createSendButton]];
            }
        }

    }
    UIButton *bankButton = [[UIButton alloc] initWithFrame:CGRectMake(20, 42 * 5 + 10, WIDTH - 40, 40)];
    bankButton.backgroundColor = BidColor;
    bankButton.clipsToBounds = YES;
    [bankButton setTitle:@"确认添加" forState:UIControlStateNormal];
    bankButton.layer.cornerRadius = 10;
    [bankButton addTarget:self action:@selector(addBankWay:) forControlEvents:UIControlEventTouchUpInside];
    [_bankView addSubview:bankButton];
    _bankView.hidden = YES;

}

//已经绑定支付宝或银行卡的界面
- (void)createViewAdded{
    
    _show = 1;
    _addpayWay = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, _scrollView.frame.size.height)];
    [_scrollView addSubview:_addpayWay];
    
    UIView *PayView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT - 70)];
    [_addpayWay addSubview:PayView];
    
    for (int i = 0; i < 4; i++) {
        
        UILabel *payLable = [[UILabel alloc] initWithFrame:CGRectMake(0, i * 42, 90, 40)];
        payLable.text = _wayArray[i];
        payLable.font = [UIFont systemFontOfSize:wordSize];
        payLable.backgroundColor = [UIColor whiteColor];
        payLable.textColor = wordColor;
        [PayView addSubview:payLable];
        
        UITextField *payText = [[UITextField alloc] initWithFrame:CGRectMake(90, i * 42, WIDTH - 90, 40)];
        payText.delegate = self;
        payText.placeholder = @"必填";
        payText.font = [UIFont systemFontOfSize:wordSize];
        payText.backgroundColor = [UIColor whiteColor];
        payText.tag = i + payTextTag;
        [PayView addSubview:payText];
        
        if (i == 0) {
            
            UIButton *changeButton = [[UIButton alloc] initWithFrame:CGRectMake(WIDTH - 50, 10, 40, 20)];
            [changeButton setTitle:@"修改" forState:UIControlStateNormal];
            [changeButton setTitleColor:BackColor forState:UIControlStateNormal];
            changeButton.titleLabel.font = [UIFont systemFontOfSize:wordSize];
            [changeButton addTarget:self action:@selector(updataWay:) forControlEvents:UIControlEventTouchUpInside];
            changeButton.userInteractionEnabled = YES;
            [PayView addSubview:changeButton];
        }
        if (i == 0) {
            payText.enabled = NO;
            payText.text = _account;
        }
        if ( i == 1) {
            payText.enabled = NO;
            payText.text = _userName;
        }
        if (i == 2) {
            
            payText.frame = CGRectMake(90, i * 42, WIDTH - 200, 40);
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(WIDTH - 110, i * 42, 110, 40)];
            view.backgroundColor = [UIColor whiteColor];
            [_addpayWay addSubview:view];
            [view addSubview:[self createSendButton]];
        }
    }
    UILabel *canLable = [[UILabel alloc] initWithFrame:CGRectMake(10, 42 * 4 + 5, 110, 20)];
    canLable.text = @"您本次可提现：";
    canLable.font = [UIFont systemFontOfSize:wordSize];
    canLable.textColor = wordColor;
    [PayView addSubview:canLable];
    
    UILabel *canMoneyLable = [[UILabel alloc] initWithFrame:CGRectMake(120, 42 * 4 + 5, 80, 20)];
    if ([_money integerValue] <= 10) {
        canMoneyLable.text = @"0元";
        
    }else{
        canMoneyLable.text = [NSString stringWithFormat:@"%@元", _money];
    }
    canMoneyLable.textColor = BidColor;
    canLable.font = [UIFont systemFontOfSize:wordSize];
    [PayView addSubview:canMoneyLable];
    
    UILabel *minLable = [[UILabel alloc] initWithFrame:CGRectMake(200, 42 * 4 + 5, 120, 20)];
    minLable.text = @"(提现需大于10元)";
    minLable.font = [UIFont systemFontOfSize:14];
    minLable.textColor = wordColor;
    [PayView addSubview:minLable];
    
    UIButton *payButton = [[UIButton alloc] initWithFrame:CGRectMake(5, 42 * 4 + 30, WIDTH - 10, 40)];
    payButton.backgroundColor = BidColor;
    payButton.clipsToBounds = YES;
    [payButton setTitle:@"确认提现" forState:UIControlStateNormal];
    payButton.layer.cornerRadius = 10;
    [payButton addTarget:self action:@selector(cashClick:) forControlEvents:UIControlEventTouchUpInside];
    [PayView addSubview:payButton];
    
    UILabel *explainLable = [[UILabel alloc] initWithFrame:CGRectMake(10, 42 * 4 + 90, 120, 20)];
    explainLable.text = @"提现到账说明：";
    explainLable.font = [UIFont fontWithName:@"" size:wordSize];
    explainLable.textColor = wordColor;
    [PayView addSubview:explainLable];
    
    UILabel *explain = [[UILabel alloc] initWithFrame:CGRectMake(10, 42 * 4 + 120, WIDTH - 20, 80)];
    explain.textColor = wordColor;
    explain.text = [NSString stringWithFormat:@"1.工作日内09：00-17：00，提现到支付宝两小时内到账，提现到银行卡次日到账。%@2.其他时间提现，均次日到账。", @"\n"];
    explain.font = [UIFont systemFontOfSize:13];
    explain.numberOfLines = 0;
    [PayView addSubview:explain];

    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:explain.text];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    
    [paragraphStyle setLineSpacing:5];//调整行间距
    
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [explain.text length])];
    explain.attributedText = attributedString;
    [explain sizeToFit];
}
//修改视图
- (void)createChange{
    
    _show = 2;
    _changeView = [[UIView alloc] initWithFrame:CGRectMake(0, 10, WIDTH, HEIGHT - 120)];
    [_scrollView addSubview:_changeView];
    if (way == 3) {
        
        NSArray *bankArray = @[@"  开户银行：", @"  支行名称：", @"  开 户 名：", @"  银行账号：", @"  验 证 码："];
        
        for (int i = 0; i < 5; i++) {
            
            UILabel *subLable = [[UILabel alloc] initWithFrame:CGRectMake(0, i * 42, 90, 40)];
            subLable.text = bankArray[i];
            subLable.font = [UIFont systemFontOfSize:wordSize];
            subLable.textColor = wordColor;
            subLable.backgroundColor = [UIColor whiteColor];
            [_changeView addSubview:subLable];
            
            if (i == 0) {
                
                subLable.frame = CGRectMake(0, i * 42, WIDTH, 40);
                _chooseButton = [[UIButton alloc] initWithFrame:CGRectMake(90, 10, 100, 20)];
                _chooseButton.titleLabel.font = [UIFont systemFontOfSize:wordSize];
                [_chooseButton setTitle:@"🏦请选择银行" forState:UIControlStateNormal];
                [_chooseButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
                _chooseButton.backgroundColor = AwayColor;
                [_chooseButton addTarget:self action:@selector(chooseBank:) forControlEvents:UIControlEventTouchUpInside];
                [_changeView addSubview:_chooseButton];
                
            }else{
                
                UITextField *subText = [[UITextField alloc] initWithFrame:CGRectMake(90, i * 42, WIDTH - 90, 40)];
                subText.delegate = self;
                subText.placeholder = @"必填";
                subText.tag = i + bankTextTag;
                subText.font = [UIFont systemFontOfSize:wordSize];
                subText.backgroundColor = [UIColor whiteColor];
                subText.clearButtonMode = YES;
                [_changeView addSubview:subText];
                
                if (i == 4) {
                    subText.frame = CGRectMake(90, i * 42, WIDTH - 200, 40);
                    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(WIDTH - 110, i * 42, 110, 40)];
                    view.backgroundColor = [UIColor whiteColor];
                    [_changeView addSubview:view];
                    [view addSubview:[self createSendButton]];
                }
            }
            
        }
        UIButton *bankButton = [[UIButton alloc] initWithFrame:CGRectMake(20, 42 * 5 + 10, WIDTH - 40, 40)];
        bankButton.backgroundColor = BidColor;
        bankButton.clipsToBounds = YES;
        [bankButton setTitle:@"确认添加" forState:UIControlStateNormal];
        bankButton.layer.cornerRadius = 10;
        [bankButton addTarget:self action:@selector(sureChangeBank:) forControlEvents:UIControlEventTouchUpInside];
        [_changeView addSubview:bankButton];
        
    }else{
        
        NSArray *payArray = @[@"  支付宝账号：", @"  支付宝姓名：", @"  验  证  码："];
        
        for (int i = 0; i < 3; i++) {
            
            UILabel *payLable = [[UILabel alloc] initWithFrame:CGRectMake(0, i * 42, 100, 40)];
            payLable.text = payArray[i];
            payLable.font = [UIFont systemFontOfSize:wordSize];
            payLable.backgroundColor = [UIColor whiteColor];
            payLable.textColor = wordColor;
            [_changeView addSubview:payLable];
            
            UITextField *payText = [[UITextField alloc] initWithFrame:CGRectMake(100, i * 42, WIDTH - 100, 40)];
            payText.delegate = self;
            payText.placeholder = @"必填";
            payText.font = [UIFont systemFontOfSize:wordSize];
            payText.backgroundColor = [UIColor whiteColor];
            payText.tag = i + payTextTag;
            payText.clearButtonMode = YES;
            [_changeView addSubview:payText];
            if (i == 2) {
                payText.frame = CGRectMake(90, i * 42, WIDTH - 200, 40);
                UIView *view = [[UIView alloc] initWithFrame:CGRectMake(WIDTH - 110, i * 42, 110, 40)];
                view.backgroundColor = [UIColor whiteColor];
                [_changeView addSubview:view];
                [view addSubview:[self createSendButton]];
            }
        }
        UIButton *payButton = [[UIButton alloc] initWithFrame:CGRectMake(20, 42 * 3 + 10, WIDTH - 40, 40)];
        payButton.backgroundColor = BidColor;
        payButton.clipsToBounds = YES;
        [payButton setTitle:@"确认修改" forState:UIControlStateNormal];
        payButton.layer.cornerRadius = 10;
        [payButton addTarget:self action:@selector(sureChangePay:) forControlEvents:UIControlEventTouchUpInside];
        [_changeView addSubview:payButton];

    }
}


#pragma mark ---提现纪录---
- (void)createScrollView2{
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(WIDTH, 0, WIDTH, HEIGHT - 135)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor = TableViewBackColor;
    [_scrollView addSubview:_tableView];
    
    //头视图
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 50)];
    view.backgroundColor = [UIColor whiteColor];
    NSArray *array = @[@"提现时间", @"提现金额", @"状态"];
    for (int i = 0; i < 3; i++) {
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(i * WIDTH / 3, 10, WIDTH / 3, 30)];
        label.textAlignment = NSTextAlignmentCenter;
        label.text = array[i];
        label.font = [UIFont systemFontOfSize:wordSize];
        [view addSubview:label];
    }
    _tableView.tableHeaderView = view;
    
    [_tableView registerClass:[CashTableViewCell class] forCellReuseIdentifier:@"cash"];
    
}
//创建短信验证按钮
- (UIButton *)createSendButton{
    
    UIButton *sendButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 5, 100, 30)];
    sendButton.backgroundColor = BackColor;
    sendButton.titleLabel.font = [UIFont systemFontOfSize:12];
    [sendButton setTitle:@"发送短信验证码" forState:UIControlStateNormal];
    sendButton.clipsToBounds = YES;
    [sendButton addTarget:self action:@selector(sendMessage:) forControlEvents:UIControlEventTouchUpInside];
    sendButton.layer.cornerRadius = 15;
    sendButton.tag = 60;
    return sendButton;
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
        [self requestCashRecord];
    }
    _upBtn = sender;
}

//支付方式
- (void)addClick:(UIButton *)sender{

    
    if (_upwayBtn == nil) {
        
        _upwayBtn = (UIButton *)[self.view viewWithTag:10];
    }
    
    [_upwayBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    _upwayBtn.backgroundColor = [UIColor whiteColor];
    
    sender.backgroundColor = BackColor;
    [sender setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    _upwayBtn = sender;
    
    if (sender.tag == 10) {
        _bankView.hidden = YES;
        _payView.hidden = NO;
    }else{
        _bankView.hidden = NO;
        _payView.hidden = YES;
    }
    
    s = 60;
    [_time setFireDate:[NSDate distantFuture]];
    UIButton *sendButton;
    if(_payView.hidden == NO){
        sendButton = (UIButton *)[_payView viewWithTag:60];
    }else if(_bankView.hidden == NO){
        sendButton = (UIButton *)[_bankView viewWithTag:60];
    }
    [sendButton setTitle:@"发送短信验证码" forState:UIControlStateNormal];
    sendButton.userInteractionEnabled = YES;
    sendButton.backgroundColor = BackColor;
}

//选择开户银行
- (void)chooseBank:(UIButton *)sender{
    
    
    UIButton *view = [UIButton buttonWithType:UIButtonTypeCustom];
    view.frame = CGRectMake(90, 30, 100, 120);
    view.backgroundColor = AwayColor;
    
    view.tag = 100;
    
    //循环创建距离按钮
    NSArray *array = @[@"工商银行", @"农业银行", @"建设银行", @"中国银行"];
    for (int i = 0; i < 4; i++) {
        UIButton *awayB = [[UIButton alloc] initWithFrame:CGRectMake(0, i * 30, 100, 30)];
        [awayB setTitle:array[i] forState:UIControlStateNormal];
        [awayB setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        awayB.layer.cornerRadius = 5;
        awayB.titleLabel.font = [UIFont systemFontOfSize:wordSize];
        [awayB addTarget:self action:@selector(changeBank:) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:awayB];
    }
    if (_bankView.hidden == NO) {
        [_bankView addSubview:view];
    }
     if (_changeView.hidden == NO){
        [_changeView addSubview:view];
    }
    
}
//选择银行
- (void)changeBank:(UIButton *)sender{
    
     [_chooseButton setTitle:sender.titleLabel.text forState:UIControlStateNormal];
    if (_changeView.hidden == NO) {
        
        UIView *view = (UIView *)[_changeView viewWithTag:100];
        [view removeFromSuperview];
    }
    if (_bankView.hidden == NO) {
        
        UIView *view = (UIView *)[_bankView viewWithTag:100];
        [view removeFromSuperview];
    }
   
}

//发送短信验证码
- (void)sendMessage:(UIButton *)sender{
    s = 60;
    sender.backgroundColor = AwayColor;
    NSDictionary *dict;
    if (_show == 0) {
        dict = @{@"token":_token, @"mobile":[userDefault stringForKey:@"phone"], @"action":@"3"};
    }else if(_show == 2){
       dict = @{@"token":_token, @"mobile":[userDefault stringForKey:@"phone"], @"action":@"3"};
    }else{
        dict = @{@"token":_token, @"mobile":[userDefault stringForKey:@"phone"], @"action":@"4"};
    }
    if (s == 60) {
        
        [YJJRequest PostrequestwithURL:sendURL dic:dict complete:^(NSData *data) {
            
            NSDictionary *result = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            if ([result[@"resultCode"] integerValue] == 0) {
        
                UIAlertController *alter = [UIAlertController alertControllerWithTitle:@"已发送" message:nil preferredStyle:UIAlertControllerStyleAlert];
                [self presentViewController:alter animated:YES completion:nil];
                _removeTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(removeLable) userInfo:nil repeats:NO];
                _time = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(changeTime) userInfo:nil repeats:YES];
                sender.userInteractionEnabled = YES;
                
                
            }else if ([result[@"resultCode"] integerValue] == 4){
                
                UIAlertController *alter = [UIAlertController alertControllerWithTitle:@"超出每天短信发送次数" message:nil preferredStyle:UIAlertControllerStyleAlert];
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

//再次发送倒计时
- (void)changeTime{

    UIButton *sendButton;
    if(_show == 0){
        if(_payView.hidden == NO){
            sendButton = (UIButton *)[_payView viewWithTag:60];
            
        }else if(_bankView.hidden == NO){
            sendButton = (UIButton *)[_bankView viewWithTag:60];
        }
    }else if(_show == 1){
        sendButton = (UIButton *)[_addpayWay viewWithTag:60];
    }else if(_show == 2){
        sendButton = (UIButton *)[_changeView viewWithTag:60];
    }
    sendButton.userInteractionEnabled = NO;
    [sendButton setTitle:[NSString stringWithFormat:@"再次发送%dS", --s] forState:UIControlStateNormal];
    if (s == -1) {
        [sendButton setTitle:@"再次发送" forState:UIControlStateNormal];
        sendButton.backgroundColor = BackColor;
        //关闭定时器
        [_time setFireDate:[NSDate distantFuture]];
        _time = nil;
        sendButton.userInteractionEnabled = YES;
        s = 60;
    }
    
}

//添加支付宝提现方式
- (void)addPayWay:(UIButton *)sender{
    
    [self hideKeyboard];
    UITextField *userText = (UITextField *)[_payView viewWithTag:payTextTag];
    UITextField *nameText = (UITextField *)[_payView viewWithTag:payTextTag + 1];
    UITextField *verifyText = (UITextField *)[_payView viewWithTag:payTextTag + 2];

    
    if ([userText.text isEqualToString:@""]) {
        
        //没有输入账号的情况下
        UIAlertController *alter = [UIAlertController alertControllerWithTitle:@"请先输入账号" message:nil preferredStyle:UIAlertControllerStyleAlert];
        [self presentViewController:alter animated:YES completion:nil];
        _removeTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(removeLable) userInfo:nil repeats:NO];
       
        
    }else if ([nameText.text isEqualToString:@""]){
        //没有输入名字的情况下
        UIAlertController *alter = [UIAlertController alertControllerWithTitle:@"请先输入名字" message:nil preferredStyle:UIAlertControllerStyleAlert];
        [self presentViewController:alter animated:YES completion:nil];
        _removeTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(removeLable) userInfo:nil repeats:NO];
        
    }else if ([verifyText.text isEqualToString:@""] == YES){
        
        //验证码错误的情况下
        UIAlertController *alter = [UIAlertController alertControllerWithTitle:@"验证码不能为空" message:nil preferredStyle:UIAlertControllerStyleAlert];
        [self presentViewController:alter animated:YES completion:nil];
        _removeTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(removeLable) userInfo:nil repeats:NO];
        
    }
    else{
        //全对
        
        NSDictionary *dict = @{@"vcode":verifyText.text, @"account":userText.text, @"nickname":nameText.text, @"token":_token, @"bankoralipayid":[NSNumber numberWithInteger:0]};
        [YJJRequest PostrequestwithURL:addPayURL dic:dict complete:^(NSData *data) {
            
            NSDictionary *result = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            if ([result[@"resultCode"] longLongValue] == 0) {
                
                s = 60;
                [_time setFireDate:[NSDate distantFuture]];
                UIButton *sendButton;
                if(_addpayWay.hidden == NO){
                    sendButton = (UIButton *)[_addpayWay viewWithTag:60];}
                else{
                    sendButton = (UIButton *)[_changeView viewWithTag:60];
                }
                [sendButton setTitle:@"发送短信验证码" forState:UIControlStateNormal];
                sendButton.backgroundColor = BackColor;
                
                UIAlertController *alter = [UIAlertController alertControllerWithTitle:@"绑定成功" message:nil preferredStyle:UIAlertControllerStyleAlert];
                [self presentViewController:alter animated:YES completion:nil];
                _removeTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(removeLable) userInfo:nil repeats:NO];
                [_noAddpayWay removeFromSuperview];
                [self requestData];
                
                
            }else if ([result[@"resultCode"] longLongValue] == 7){
                
                UIAlertController *alter = [UIAlertController alertControllerWithTitle:@"账号错误" message:nil preferredStyle:UIAlertControllerStyleAlert];
                [self presentViewController:alter animated:YES completion:nil];
                _removeTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(removeLable) userInfo:nil repeats:NO];
                
            }else if ([result[@"resultCode"] longLongValue] == 4){
                
                UIAlertController *alter = [UIAlertController alertControllerWithTitle:@"绑定支付宝过多" message:nil preferredStyle:UIAlertControllerStyleAlert];
                [self presentViewController:alter animated:YES completion:nil];
                _removeTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(removeLable) userInfo:nil repeats:NO];
                
            }else if ([result[@"resultCode"] longLongValue] == 5){
                
                UIAlertController *alter = [UIAlertController alertControllerWithTitle:@"验证码错误或失效" message:nil preferredStyle:UIAlertControllerStyleAlert];
                [self presentViewController:alter animated:YES completion:nil];
                _removeTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(removeLable) userInfo:nil repeats:NO];
                
            }else if ([result[@"resultCode"] longLongValue] == 6){
                
                UIAlertController *alter = [UIAlertController alertControllerWithTitle:@"验证码超时" message:nil preferredStyle:UIAlertControllerStyleAlert];
                [self presentViewController:alter animated:YES completion:nil];
                _removeTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(removeLable) userInfo:nil repeats:NO];
                
            }else{
                
                UIAlertController *alter = [UIAlertController alertControllerWithTitle:@"请求绑定失败" message:nil preferredStyle:UIAlertControllerStyleAlert];
                [self presentViewController:alter animated:YES completion:nil];
                _removeTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(removeLable) userInfo:nil repeats:NO];
            }
            
            
        } fail:^(NSError *error) {
            
            UIAlertController *alter = [UIAlertController alertControllerWithTitle:@"请求绑定失败" message:nil preferredStyle:UIAlertControllerStyleAlert];
            [self presentViewController:alter animated:YES completion:nil];
            _removeTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(removeLable) userInfo:nil repeats:NO];
    
        }];
    }
}
//添加银行卡提现方式
- (void)addBankWay:(UIButton *)sender{

    [self hideKeyboard];
    UITextField *subText = (UITextField *)[_bankView viewWithTag:bankTextTag + 1];
    UITextField *nameText = (UITextField *)[_bankView viewWithTag:bankTextTag + 2];
    UITextField *userText = (UITextField *)[_bankView viewWithTag:bankTextTag + 3];
    UITextField *verifyText = (UITextField *)[_bankView viewWithTag:bankTextTag + 4];
 
    if ([_chooseButton.titleLabel.text isEqualToString:@"🏦请选择银行"]) {
        UIAlertController *alter = [UIAlertController alertControllerWithTitle:@"请选择开户银行" message:nil preferredStyle:UIAlertControllerStyleAlert];
        [self presentViewController:alter animated:YES completion:nil];
        _removeTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(removeLable) userInfo:nil repeats:NO];

        
    }else if ([subText.text isEqualToString:@""]) {
        UIAlertController *alter = [UIAlertController alertControllerWithTitle:@"请先输入支行名称" message:nil preferredStyle:UIAlertControllerStyleAlert];
        [self presentViewController:alter animated:YES completion:nil];
        _removeTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(removeLable) userInfo:nil repeats:NO];
        
    }else if ([nameText.text isEqualToString:@""]){
        UIAlertController *alter = [UIAlertController alertControllerWithTitle:@"请先输入开户名" message:nil preferredStyle:UIAlertControllerStyleAlert];
        [self presentViewController:alter animated:YES completion:nil];
        _removeTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(removeLable) userInfo:nil repeats:NO];
        
    }else if([userText.text isEqualToString:@""]){
        UIAlertController *alter = [UIAlertController alertControllerWithTitle:@"请先输入银行账号" message:nil preferredStyle:UIAlertControllerStyleAlert];
        [self presentViewController:alter animated:YES completion:nil];
        _removeTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(removeLable) userInfo:nil repeats:NO];
        
    }else if ([verifyText.text isEqualToString:@""]){
        UIAlertController *alter = [UIAlertController alertControllerWithTitle:@"请先输入验证码" message:nil preferredStyle:UIAlertControllerStyleAlert];
        [self presentViewController:alter animated:YES completion:nil];
        _removeTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(removeLable) userInfo:nil repeats:NO];

        
    }else{
        
        NSDictionary *dict = @{@"bankoralipayid":[NSNumber numberWithInteger:0], @"token":_token, @"vcode":verifyText.text ,@"bankname":_chooseButton.titleLabel.text, @"accountname":nameText.text, @"banknum":userText.text,@"branch":subText.text };
        [YJJRequest PostrequestwithURL:addBankURL dic:dict complete:^(NSData *data) {
            NSDictionary *result = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            
            if ([result[@"resultCode"] longLongValue] == 0) {
                
                s = 60;
                [_time setFireDate:[NSDate distantFuture]];
                
                UIButton *sendButton;
                if(_addpayWay != nil){
                    sendButton = (UIButton *)[_addpayWay viewWithTag:60];}
                else if(_changeView != nil){
                    sendButton = (UIButton *)[_changeView viewWithTag:60];
                }else if(_noAddpayWay != nil){
                    if (_bankView.hidden == NO) {
                        sendButton = (UIButton *)[_bankView viewWithTag:60];
                    }else if(_payView.hidden == NO){
                        sendButton = (UIButton *)[_payView viewWithTag:60];
                    }
                }
                [sendButton setTitle:@"发送短信验证码" forState:UIControlStateNormal];
                sendButton.backgroundColor = BackColor;
                
                UIAlertController *alter = [UIAlertController alertControllerWithTitle:@"绑定成功" message:nil preferredStyle:UIAlertControllerStyleAlert];
                [self presentViewController:alter animated:YES completion:nil];
                _removeTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(removeLable) userInfo:nil repeats:NO];
                [_noAddpayWay removeFromSuperview];
                [self requestData];
                
            }else if ([result[@"resultCode"] longLongValue] == -3){
                
                UIAlertController *alter = [UIAlertController alertControllerWithTitle:@"请输入正确的银行卡号" message:nil preferredStyle:UIAlertControllerStyleAlert];
                [self presentViewController:alter animated:YES completion:nil];
                _removeTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(removeLable) userInfo:nil repeats:NO];
                
            }else if ([result[@"resultCode"] longLongValue] == 100){
                
                UIAlertController *alter = [UIAlertController alertControllerWithTitle:@"银行卡绑定过多" message:nil preferredStyle:UIAlertControllerStyleAlert];
                [self presentViewController:alter animated:YES completion:nil];
                _removeTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(removeLable) userInfo:nil repeats:NO];
                
            }else if ([result[@"resultCode"] longLongValue] == 6){
                
                UIAlertController *alter = [UIAlertController alertControllerWithTitle:@"验证码错误或失效" message:nil preferredStyle:UIAlertControllerStyleAlert];
                [self presentViewController:alter animated:YES completion:nil];
                _removeTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(removeLable) userInfo:nil repeats:NO];
                
            }else{
                
                UIAlertController *alter = [UIAlertController alertControllerWithTitle:@"绑定失败" message:nil preferredStyle:UIAlertControllerStyleAlert];
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

//修改支付宝或银行卡账号
- (void)updataWay:(UIButton *)sender{
    
    
    [_addpayWay removeFromSuperview];
    [self createChange];
    s = 60;
    [_time setFireDate:[NSDate distantFuture]];
    UIButton *sendButton;
    if(_addpayWay != nil){
        sendButton = (UIButton *)[_addpayWay viewWithTag:60];
    }else if(_changeView != nil){
        sendButton = (UIButton *)[_changeView viewWithTag:60];
    }
    [sendButton setTitle:@"发送短信验证码" forState:UIControlStateNormal];
    sendButton.backgroundColor = BackColor;
    
}


//确定提现
- (void)cashClick:(UIButton *)sender{
    
    [self hideKeyboard];
    
    UITextField *moneyText = (UITextField *)[_addpayWay viewWithTag:payTextTag + 3];
    UITextField *verifyText = (UITextField *)[_addpayWay viewWithTag:payTextTag + 2];
    if ([verifyText.text isEqualToString:@""]) {
        
        UIAlertController *alter = [UIAlertController alertControllerWithTitle:@"请先输入验证码" message:nil preferredStyle:UIAlertControllerStyleAlert];
        [self presentViewController:alter animated:YES completion:nil];
        _removeTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(removeLable) userInfo:nil repeats:NO];
        
    }else if ([moneyText.text isEqualToString:@""]){
        
        UIAlertController *alter = [UIAlertController alertControllerWithTitle:@"请先输入提现金额" message:nil preferredStyle:UIAlertControllerStyleAlert];
        [self presentViewController:alter animated:YES completion:nil];
        _removeTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(removeLable) userInfo:nil repeats:NO];
        
    }else{
        
        NSDictionary *dict;
        if (way == 2) {
            
            dict = @{@"token":_token,@"vcode":verifyText.text, @"money":[NSNumber numberWithInteger:[moneyText.text integerValue]],@"paytype":[NSNumber numberWithInteger:1]};
        }else{
            
            dict = @{@"token":_token,@"vcode":verifyText.text, @"money":[NSNumber numberWithInteger:[moneyText.text integerValue]],@"paytype":[NSNumber numberWithInteger:2]};
        }
        
        
        [YJJRequest PostrequestwithURL:SureCashURL dic:dict complete:^(NSData *data) {
            
            NSDictionary *result = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            
            if ([result[@"resultCode"] longLongValue] == 0) {
                
                
                _payView.hidden = YES;
                s = 60;
                [_time setFireDate:[NSDate distantFuture]];
                UIButton *sendButton;
                if(_addpayWay.hidden == NO){
                    sendButton = (UIButton *)[_addpayWay viewWithTag:60];
                }else if(_changeView.hidden == NO){
                    sendButton = (UIButton *)[_changeView viewWithTag:60];
                }
                [sendButton setTitle:@"发送短信验证码" forState:UIControlStateNormal];
                sendButton.backgroundColor = BackColor;
                UIAlertController *alter = [UIAlertController alertControllerWithTitle:@"申请成功" message:nil preferredStyle:UIAlertControllerStyleAlert];
                [self presentViewController:alter animated:YES completion:nil];
                _removeTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(removeLable) userInfo:nil repeats:NO];
                [_addpayWay removeFromSuperview];
                [self requestDataMoney];
                
            }else if ([result[@"resultCode"] longLongValue] == -2){
                
                UIAlertController *alter = [UIAlertController alertControllerWithTitle:@"提现金额必须超过10元" message:nil preferredStyle:UIAlertControllerStyleAlert];
                [self presentViewController:alter animated:YES completion:nil];
                _removeTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(removeLable) userInfo:nil repeats:NO];
                
            }else if ([result[@"resultCode"] longLongValue] == -3){
                
                UIAlertController *alter = [UIAlertController alertControllerWithTitle:@"提现金额不足" message:nil preferredStyle:UIAlertControllerStyleAlert];
                [self presentViewController:alter animated:YES completion:nil];
                _removeTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(removeLable) userInfo:nil repeats:NO];
                
            }else if ([result[@"resultCode"] longLongValue] == -5 || [result[@"resultCode"] longLongValue] == -6){
                
                UIAlertController *alter = [UIAlertController alertControllerWithTitle:@"验证码错误或失效" message:nil preferredStyle:UIAlertControllerStyleAlert];
                [self presentViewController:alter animated:YES completion:nil];
                _removeTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(removeLable) userInfo:nil repeats:NO];
                
            }else{
                UIAlertController *alter = [UIAlertController alertControllerWithTitle:@"申请失败" message:nil preferredStyle:UIAlertControllerStyleAlert];
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
//确认修改银行卡
- (void)sureChangeBank:(UIButton *)sender{
   
    [self hideKeyboard];
    
    UITextField *subText = (UITextField *)[_changeView viewWithTag:bankTextTag + 1];
    UITextField *nameText = (UITextField *)[_changeView viewWithTag:bankTextTag + 2];
    UITextField *userText = (UITextField *)[_changeView viewWithTag:bankTextTag + 3];
    UITextField *verifyText = (UITextField *)[_changeView viewWithTag:bankTextTag + 4];
    
    
    if ([_chooseButton.titleLabel.text isEqualToString:@"🏦请选择银行"]) {
        UIAlertController *alter = [UIAlertController alertControllerWithTitle:@"请选择开户银行" message:nil preferredStyle:UIAlertControllerStyleAlert];
        [self presentViewController:alter animated:YES completion:nil];
        _removeTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(removeLable) userInfo:nil repeats:NO];
        
    }else if ([subText.text isEqualToString:@""]) {
        UIAlertController *alter = [UIAlertController alertControllerWithTitle:@"请先输入支行名称" message:nil preferredStyle:UIAlertControllerStyleAlert];
        [self presentViewController:alter animated:YES completion:nil];
        _removeTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(removeLable) userInfo:nil repeats:NO];
        
    }else if ([nameText.text isEqualToString:@""]){
        UIAlertController *alter = [UIAlertController alertControllerWithTitle:@"请先输入开户名" message:nil preferredStyle:UIAlertControllerStyleAlert];
        [self presentViewController:alter animated:YES completion:nil];
        _removeTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(removeLable) userInfo:nil repeats:NO];
        
    }else if([userText.text isEqualToString:@""]){
        UIAlertController *alter = [UIAlertController alertControllerWithTitle:@"请先输入银行账号" message:nil preferredStyle:UIAlertControllerStyleAlert];
        [self presentViewController:alter animated:YES completion:nil];
        _removeTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(removeLable) userInfo:nil repeats:NO];
        
    }else if ([verifyText.text isEqualToString:@""]){
        UIAlertController *alter = [UIAlertController alertControllerWithTitle:@"请先输入验证码" message:nil preferredStyle:UIAlertControllerStyleAlert];
        [self presentViewController:alter animated:YES completion:nil];
        _removeTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(removeLable) userInfo:nil repeats:NO];
        
    }else{
        
        NSDictionary *dict = @{@"bankoralipayid":[NSNumber numberWithInteger:1], @"token":_token, @"vcode":verifyText.text ,@"bankname":_chooseButton.titleLabel.text, @"accountname":nameText.text, @"banknum":userText.text,@"branch":subText.text };
        [YJJRequest PostrequestwithURL:addBankURL dic:dict complete:^(NSData *data) {
            NSDictionary *result = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            
            if ([result[@"resultCode"] longLongValue] == 0) {
                
                s = 60;
                [_time setFireDate:[NSDate distantFuture]];
                
                UIButton *sendButton;
                if(_addpayWay.hidden == NO){
                    sendButton = (UIButton *)[_addpayWay viewWithTag:60];}
                else{
                    sendButton = (UIButton *)[_changeView viewWithTag:60];
                }
                [sendButton setTitle:@"发送短信验证码" forState:UIControlStateNormal];
                sendButton.backgroundColor = BackColor;
                
                UIAlertController *alter = [UIAlertController alertControllerWithTitle:@"修改成功" message:nil preferredStyle:UIAlertControllerStyleAlert];
                [self presentViewController:alter animated:YES completion:nil];
                _removeTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(removeLable) userInfo:nil repeats:NO];
                [_changeView removeFromSuperview];
                [self requestData];
                
            }else if ([result[@"resultCode"] longLongValue] == -3){
                
                UIAlertController *alter = [UIAlertController alertControllerWithTitle:@"请输入正确的银行卡号" message:nil preferredStyle:UIAlertControllerStyleAlert];
                [self presentViewController:alter animated:YES completion:nil];
                _removeTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(removeLable) userInfo:nil repeats:NO];
                
            }else if ([result[@"resultCode"] longLongValue] == 100){
                
                UIAlertController *alter = [UIAlertController alertControllerWithTitle:@"银行卡绑定过多" message:nil preferredStyle:UIAlertControllerStyleAlert];
                [self presentViewController:alter animated:YES completion:nil];
                _removeTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(removeLable) userInfo:nil repeats:NO];
                
            }else if ([result[@"resultCode"] longLongValue] == 6){
                
                UIAlertController *alter = [UIAlertController alertControllerWithTitle:@"验证码错误或失效" message:nil preferredStyle:UIAlertControllerStyleAlert];
                [self presentViewController:alter animated:YES completion:nil];
                _removeTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(removeLable) userInfo:nil repeats:NO];
                
            }else{
                
                UIAlertController *alter = [UIAlertController alertControllerWithTitle:@"修改失败" message:nil preferredStyle:UIAlertControllerStyleAlert];
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

//确认修改支付宝
- (void)sureChangePay:(UIButton *)sender{

    [self hideKeyboard];
    
    UITextField *userText = (UITextField *)[_changeView viewWithTag:payTextTag];
    UITextField *nameText = (UITextField *)[_changeView viewWithTag:payTextTag + 1];
    UITextField *verifyText = (UITextField *)[_changeView viewWithTag:payTextTag + 2];
    if ([userText.text isEqualToString:@""]) {
        
        //没有输入账号的情况下
        UIAlertController *alter = [UIAlertController alertControllerWithTitle:@"请先输入账号" message:nil preferredStyle:UIAlertControllerStyleAlert];
        [self presentViewController:alter animated:YES completion:nil];
        _removeTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(removeLable) userInfo:nil repeats:NO];
        
        
    }else if ([nameText.text isEqualToString:@""]){
        //没有输入名字的情况下
        UIAlertController *alter = [UIAlertController alertControllerWithTitle:@"请先输入名字" message:nil preferredStyle:UIAlertControllerStyleAlert];
        [self presentViewController:alter animated:YES completion:nil];
       _removeTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(removeLable) userInfo:nil repeats:NO];
        
    }else if ([verifyText.text isEqualToString:@""] == YES){
        
        //验证码错误的情况下
        UIAlertController *alter = [UIAlertController alertControllerWithTitle:@"验证码不能为空" message:nil preferredStyle:UIAlertControllerStyleAlert];
        [self presentViewController:alter animated:YES completion:nil];
        _removeTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(removeLable) userInfo:nil repeats:NO];
    }
    else{
        //全对
        NSDictionary *dict = @{@"vcode":verifyText.text, @"account":userText.text, @"nickname":nameText.text, @"token":_token, @"bankoralipayid":[NSNumber numberWithInteger:1]};
        [YJJRequest PostrequestwithURL:addPayURL dic:dict complete:^(NSData *data) {
            
            NSDictionary *result = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            if ([result[@"resultCode"] longLongValue] == 0) {
                
                s = 60;
                [_time setFireDate:[NSDate distantFuture]];
                UIButton *sendButton;
                if(_addpayWay.hidden == NO){
                    sendButton = (UIButton *)[_addpayWay viewWithTag:60];}
                else{
                    sendButton = (UIButton *)[_changeView viewWithTag:60];
                }
                [sendButton setTitle:@"发送短信验证码" forState:UIControlStateNormal];
                sendButton.backgroundColor = BackColor;
                
                UIAlertController *alter = [UIAlertController alertControllerWithTitle:@"绑定成功" message:nil preferredStyle:UIAlertControllerStyleAlert];
                [self presentViewController:alter animated:YES completion:nil];
                _removeTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(removeLable) userInfo:nil repeats:NO];
                [_changeView removeFromSuperview];
                [self requestData];
                
                
            }else if ([result[@"resultCode"] longLongValue] == 7){
                
                UIAlertController *alter = [UIAlertController alertControllerWithTitle:@"账号错误" message:nil preferredStyle:UIAlertControllerStyleAlert];
                [self presentViewController:alter animated:YES completion:nil];
                _removeTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(removeLable) userInfo:nil repeats:NO];
                
            }else if ([result[@"resultCode"] longLongValue] == 4){
                
                UIAlertController *alter = [UIAlertController alertControllerWithTitle:@"绑定支付宝过多" message:nil preferredStyle:UIAlertControllerStyleAlert];
                [self presentViewController:alter animated:YES completion:nil];
                _removeTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(removeLable) userInfo:nil repeats:NO];
                
            }else if ([result[@"resultCode"] longLongValue] == 5){
                
                UIAlertController *alter = [UIAlertController alertControllerWithTitle:@"验证码错误或失效" message:nil preferredStyle:UIAlertControllerStyleAlert];
                [self presentViewController:alter animated:YES completion:nil];
                _removeTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(removeLable) userInfo:nil repeats:NO];
                
            }else if ([result[@"resultCode"] longLongValue] == 6){
                
                UIAlertController *alter = [UIAlertController alertControllerWithTitle:@"验证码超时" message:nil preferredStyle:UIAlertControllerStyleAlert];
                [self presentViewController:alter animated:YES completion:nil];
                _removeTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(removeLable) userInfo:nil repeats:NO];
                
            }else{
                
                UIAlertController *alter = [UIAlertController alertControllerWithTitle:@"修改失败" message:nil preferredStyle:UIAlertControllerStyleAlert];
                [self presentViewController:alter animated:YES completion:nil];
                _removeTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(removeLable) userInfo:nil repeats:NO];
            }
            
            
        } fail:^(NSError *error) {
            
            UIAlertController *alter = [UIAlertController alertControllerWithTitle:@"请求修改失败" message:nil preferredStyle:UIAlertControllerStyleAlert];
            [self presentViewController:alter animated:YES completion:nil];
            _removeTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(removeLable) userInfo:nil repeats:NO];
        }];

    }

}

//导航栏返回按钮
- (void)returnHome:(UIButton *)sender{
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark ---scrollViewDelegate---

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    if (scrollView == _scrollView) {
        
        if (_scrollView.contentOffset.x >= WIDTH) {
            [self requestCashRecord];
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
    
    
}

#pragma mark ---tableViewDelegate---

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    CashTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cash"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.layer.borderColor = TableViewBackColor.CGColor;
    cell.layer.borderWidth = 1;
    cashModel *model = _dataArray[indexPath.row];
    [cell createModel:model];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 1;
}


#pragma mark ---键盘上移---
- (void)showAndHide
{
    //此通知是键盘弹起时自动触发，不需要人为干预
    //第一个参传谁发的通知。第二个传方法名。第三个。通知名。第四个。对接受通知对象的一个过滤。（谁感兴趣）
    [NotiCenter addObserver:self selector:@selector(show:) name:UIKeyboardWillShowNotification object:nil];
    
    //键盘要消失时触发的通知
    [NotiCenter addObserver:self selector:@selector(hide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)show:(NSNotification *)noti
{
    
    //rect获取键盘的高度
//    CGRect rect = [[noti.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
//    CGFloat height = rect.size.height;
    //把view上移动键盘的高度
    
    if (_changeView != nil) {
        
        if ( way == 3) {
           [ UIView animateWithDuration:[noti.userInfo [UIKeyboardAnimationCurveUserInfoKey]doubleValue] animations:^{
                //            self.view.transform = CGAffineTransformMakeTranslation(0, -height + 180);
                self.view.frame = CGRectMake(0, -20, WIDTH, HEIGHT);
            }];
        }else{
            [UIView animateWithDuration:[noti.userInfo [UIKeyboardAnimationCurveUserInfoKey]doubleValue] animations:^{
                self.view.frame = CGRectMake(0, 65, WIDTH, HEIGHT);
            }];
        }
        
    }else{
        
            
        [UIView animateWithDuration:[noti.userInfo [UIKeyboardAnimationCurveUserInfoKey]doubleValue] animations:^{
        self.view.frame = CGRectMake(0, -60, WIDTH, HEIGHT);
            }];
    }
    
    
}

- (void)hide:(NSNotification *)noti
{
    [UIView animateWithDuration:[noti.userInfo[UIKeyboardAnimationCurveUserInfoKey]  doubleValue]animations:^{
        self.view.frame = CGRectMake(0, 64, WIDTH, HEIGHT);
    }];
}

#pragma mark ---收键盘---

//键盘的return键 点击时就会触发该方法
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

- (void)hideKeyboard{
    
    UITextField *nameText = (UITextField *)[_addpayWay viewWithTag:payTextTag + 2];
    UITextField *userText = (UITextField *)[_addpayWay viewWithTag:payTextTag + 3];
    [userText resignFirstResponder];
    [nameText resignFirstResponder];
    
    
    UITextField *userText1 = (UITextField *)[_changeView viewWithTag:payTextTag];
    UITextField *nameText1 = (UITextField *)[_changeView viewWithTag:payTextTag + 1];
    UITextField *verifyText1 = (UITextField *)[_changeView viewWithTag:payTextTag + 2];
    
    [userText1 resignFirstResponder];
    [nameText1 resignFirstResponder];
    [verifyText1 resignFirstResponder];
    
    
    UITextField *subText2 = (UITextField *)[_bankView viewWithTag:bankTextTag + 1];
    UITextField *nameText2 = (UITextField *)[_bankView viewWithTag:bankTextTag + 2];
    UITextField *userText2 = (UITextField *)[_bankView viewWithTag:bankTextTag + 3];
    UITextField *verifyText2 = (UITextField *)[_bankView viewWithTag:bankTextTag + 4];
    [subText2 resignFirstResponder];
    [nameText2 resignFirstResponder];
    [userText2 resignFirstResponder];
    [verifyText2 resignFirstResponder];
    
    UITextField *userText3 = (UITextField *)[_payView viewWithTag:payTextTag];
    UITextField *nameText3 = (UITextField *)[_payView viewWithTag:payTextTag + 1];
    UITextField *verifyText3 = (UITextField *)[_payView viewWithTag:payTextTag + 2];
    [userText3 resignFirstResponder];
    [nameText3 resignFirstResponder];
    [verifyText3 resignFirstResponder];
    
    UITextField *subText4 = (UITextField *)[_changeView viewWithTag:bankTextTag + 1];
    UITextField *nameText4 = (UITextField *)[_changeView viewWithTag:bankTextTag + 2];
    UITextField *userText4 = (UITextField *)[_changeView viewWithTag:bankTextTag + 3];
    UITextField *verifyText4 = (UITextField *)[_changeView viewWithTag:bankTextTag + 4];
    [subText4 resignFirstResponder];
    [nameText4 resignFirstResponder];
    [userText4 resignFirstResponder];
    [verifyText4 resignFirstResponder];
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
