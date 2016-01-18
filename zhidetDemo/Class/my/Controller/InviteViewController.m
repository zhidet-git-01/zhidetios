//
//  InviteViewController.m
//  zhidetDemo
//
//  Created by 刘璐璐 on 15/12/15.
//  Copyright © 2015年 刘璐璐. All rights reserved.
//

#import "InviteViewController.h"
#import "YJJRequest.h"
#import "inviteModel.h"
#import "InviteTableViewCell.h"
#import <UMSocial.h>
#import "CustomLable.h"
#import "ProgressView.h"

#define lableSize 14

@interface InviteViewController ()<UIScrollViewDelegate, UITableViewDelegate, UITableViewDataSource>

@end

@implementation InviteViewController
{
    UIScrollView *_scrollView;
    UILabel *_lineLable;
    UIButton *_upBtn;       //上一个所点击的按钮
    UITableView *_tableView;
    NSMutableArray *_dataArray;
    NSTimer *_removeTimer;
    UIButton *_againBtn;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = TableViewBackColor;
    
    _dataArray = [[NSMutableArray alloc] init];
    
    [self createNAV];
    
    [self createUI];
    
    
}

- (void)createNAV{
    
    UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
    lable.text = @"我的邀请";
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
    
    NSArray *array = @[@"邀请方式", @"邀请记录"];
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
    [self createScrollView2];
    
}

#pragma mark ---创建滚动视图的view---

- (void)createScrollView1{
    
    UIView *view1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 300)];
    view1.backgroundColor = [UIColor whiteColor];
    [_scrollView addSubview:view1];
    
    UILabel *lable1 = [[UILabel alloc] initWithFrame:CGRectMake(20, 10, WIDTH - 40, 40)];
    lable1.text = @"用以下方式分享邀请好友，和您的好友一起开始投资返利之旅吧！";
    lable1.textAlignment = NSTextAlignmentCenter;
    lable1.font = [UIFont systemFontOfSize:lableSize];
    lable1.numberOfLines = 2;
    [view1 addSubview:lable1];
    
    UILabel *lineLable = [[UILabel alloc] initWithFrame:CGRectMake(0, 60, WIDTH, 1)];
    lineLable.backgroundColor = AwayColor;
    [view1 addSubview:lineLable];
    
    UILabel *oneLable = [[UILabel alloc] initWithFrame:CGRectMake(10, 70, WIDTH - 20, 20)];
    oneLable.text = @"发送给好友链接方式";
    oneLable.textColor = BackColor;
    oneLable.font = [UIFont systemFontOfSize:wordSize];
    [view1 addSubview:oneLable];
    
    CustomLable *oneWay = [[CustomLable alloc] initWithFrame:CGRectMake(10, 90, WIDTH - 20, 100)];
    oneWay.font = [UIFont systemFontOfSize:lableSize];
    oneWay.text = [NSString stringWithFormat:@"值得投是互联网金融理财（P2P）返利网，通过值得投跳转到平台投资赚的更多。 http://www.zhidet.com/register/to-register?inviteId=%@", _invite];
    oneWay.numberOfLines = 0;
    
    //调整行间距
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:oneWay.text];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:6];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [oneWay.text length])];
    oneWay.attributedText = attributedString;
    [oneWay sizeToFit];
    [view1 addSubview:oneWay];
    
    //根据文字和字体计算文字高度
    CGSize size = [oneWay.text boundingRectWithSize:CGSizeMake(WIDTH - 20, MAXFLOAT) options:NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:wordSize]} context:nil].size;
    oneWay.frame = CGRectMake(10, 100, WIDTH - 20, size.height + 20);
    
    UILabel *twoLable = [[UILabel alloc] initWithFrame:CGRectMake(10, 130 + size.height, WIDTH - 20, 20)];
    twoLable.text = @"分享二维码，邀请好友下载值得投APP。";
    twoLable.font = [UIFont systemFontOfSize:wordSize];
    twoLable.textColor = BackColor;
    [view1 addSubview:twoLable];
    
    UIImageView *tdcImage = [[UIImageView alloc] initWithFrame:CGRectMake(WIDTH / 2 - 50, 160 + size.height, 100, 100)];
    
    // 1.创建过滤器
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    // 2.恢复默认
    [filter setDefaults];
    // 3.给过滤器添加数据
    NSString *dataString = @"http://www.zhidet.com";
    NSData *data = [dataString dataUsingEncoding:NSUTF8StringEncoding];
    [filter setValue:data forKeyPath:@"inputMessage"];
    // 4.获取输出的二维码
    CIImage *outputImage = [filter outputImage];
    //因为生成的二维码模糊，所以通过createNonInterpolatedUIImageFormCIImage:outputImage来获得高清的二维码图片
    // 5.显示二维码
    tdcImage.image = [self createNonInterpolatedUIImageFormCIImage:outputImage withSize:200];
    [view1 addSubview:tdcImage];
    
    UILabel *threeLable = [[UILabel alloc] initWithFrame:CGRectMake(10, 270 + size.height, WIDTH - 20, 20)];
    threeLable.text = @"分享到更多平台邀请好友。";
    threeLable.font = [UIFont systemFontOfSize:wordSize];
    threeLable.textColor = BackColor;
    [view1 addSubview:threeLable];
    
    NSArray *array = @[@"share_weixin", @"share_qq", @"share_weibo"];
    for (int i = 0; i < 3; i++) {
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake( 20 + i * 50, 300 + size.height, 35, 35)];
        [button setBackgroundImage:[UIImage imageNamed:array[i]]forState:UIControlStateNormal];
        [button setTitle:[NSString stringWithFormat:@"%d", i] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor clearColor] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(shareClick:) forControlEvents:UIControlEventTouchUpInside];
        [view1 addSubview:button];
    }
    
    view1.frame = CGRectMake(0, 0, WIDTH, threeLable.frame.size.height + threeLable.frame.origin.y + 55);
}


/**
 *  根据CIImage生成指定大小的UIImage
 *
 *  @param image CIImage
 *  @param size  图片宽度
 */
- (UIImage *)createNonInterpolatedUIImageFormCIImage:(CIImage *)image withSize:(CGFloat) size
{
    CGRect extent = CGRectIntegral(image.extent);
    CGFloat scale = MIN(size/CGRectGetWidth(extent), size/CGRectGetHeight(extent));
    
    // 1.创建bitmap;
    size_t width = CGRectGetWidth(extent) * scale;
    size_t height = CGRectGetHeight(extent) * scale;
    CGColorSpaceRef cs = CGColorSpaceCreateDeviceGray();
    CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, cs, (CGBitmapInfo)kCGImageAlphaNone);
    CGColorSpaceRelease(cs);
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef bitmapImage = [context createCGImage:image fromRect:extent];
    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
    CGContextScaleCTM(bitmapRef, scale, scale);
    CGContextDrawImage(bitmapRef, extent, bitmapImage);
    
    // 2.保存bitmap到图片
    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
    CGContextRelease(bitmapRef);
    CGImageRelease(bitmapImage);
    UIImage *grayImage =  [UIImage imageWithCGImage:scaledImage];
    CGImageRelease(scaledImage);
    return grayImage;
}

- (void)createScrollView2{

    
    NSArray *array = @[@"加入时间", @"好友账号", @"是否投标"];
    for (int i = 0; i < 3; i++) {
        UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(i * (WIDTH / 3) + WIDTH, 0, WIDTH / 3, 40)];
        lable.backgroundColor = [UIColor whiteColor];
        lable.text = array[i];
        lable.textAlignment = NSTextAlignmentCenter;
        lable.font = [UIFont systemFontOfSize:lableSize];
        [_scrollView addSubview:lable];
        
    }
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(WIDTH, 45, WIDTH, HEIGHT - 170)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor = TableViewBackColor;
    [_scrollView addSubview:_tableView];
    
    [_tableView registerClass:[InviteTableViewCell class] forCellReuseIdentifier:@"invite"];
}

#pragma mark ---请求数据---
- (void)requestData{
    
    [_againBtn removeFromSuperview];
    UIView *startRequest = [ProgressView startRequest];
    [self.view addSubview:startRequest];
    
    NSString *urlString = [NSString stringWithFormat:inviteURL, _token];
    [YJJRequest requestwithURL:urlString dic:nil complete:^(NSData *data) {
        
        NSDictionary *result = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        if ([result[@"resultCode"] longValue] == 0) {
            
            [startRequest removeFromSuperview];
            NSArray *listArray = result[@"inviteEntityList"];
            if (listArray.count == 0) {
                
                UIAlertController *alter = [UIAlertController alertControllerWithTitle:@"暂无邀请记录" message:nil preferredStyle:UIAlertControllerStyleAlert];
                [self presentViewController:alter animated:YES completion:nil];
                _removeTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(removeLable) userInfo:nil repeats:NO];
                
            }else{
                [_dataArray removeAllObjects];
                for (NSDictionary *listDic in listArray) {
                    inviteModel *model = [[inviteModel alloc] init];
                    model.createttime = listDic[@"creattime"];
                    model.inviteID = [listDic[@"id"] integerValue];
                    model.mobile = listDic[@"mobile"];
                    model.remark = listDic[@"remark"];
                    model.status = [listDic[@"status"] integerValue];
                    [_dataArray addObject:model];
                }
            }
            [_tableView reloadData];
        }
            
        
    } fail:^(NSError *error) {
       
        [startRequest removeFromSuperview];
        _againBtn = [ProgressView againRequest];
        [_againBtn addTarget:self action:@selector(requestData) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_againBtn];
        
        UIAlertController *alter = [UIAlertController alertControllerWithTitle:@"网络错误 请求失败" message:nil preferredStyle:UIAlertControllerStyleAlert];
        [self presentViewController:alter animated:YES completion:nil];
        _removeTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(removeLable) userInfo:nil repeats:NO];
    }];
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
        [_dataArray removeAllObjects];
        [self requestData];
    }
    _upBtn = sender;
}

- (void)shareClick:(UIButton *)sender{
    
    if ([sender.titleLabel.text isEqualToString:@"2"]) {
        [[UMSocialControllerService defaultControllerService] setShareText:@"我通过值得投投资理财，返利多多。https://itunes.apple.com/us/app/zhi-de-tou/id1071751271?mt=8" shareImage:[UIImage imageNamed:@"icon"] socialUIDelegate:nil];        //设置分享内容和回调对象
        [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToSina].snsClickHandler(self,[UMSocialControllerService defaultControllerService],YES);
    }
    if ([sender.titleLabel.text isEqualToString:@"0"]) {
        
        if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"weixin://"]]){
            
            [UMSocialSnsService presentSnsIconSheetView:self appKey:@"568b9a68e0f55a45bb0009d2" shareText:@"我通过值得投投资理财，返利多多。https://itunes.apple.com/us/app/zhi-de-tou/id1071751271?mt=8" shareImage:[UIImage imageNamed:@"icon"] shareToSnsNames:@[UMShareToWechatSession,UMShareToWechatTimeline,UMShareToWechatFavorite] delegate:nil];
        }else{
            UIAlertController *alter = [UIAlertController alertControllerWithTitle:@"您的设备未安装微信" message:nil preferredStyle:UIAlertControllerStyleAlert];
            [self presentViewController:alter animated:YES completion:nil];
            _removeTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(removeLable) userInfo:nil repeats:NO];
          
        }

    }
    if ([sender.titleLabel.text isEqualToString:@"1"]) {
        
        if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"mqq://"]]) {
            
            [UMSocialSnsService presentSnsIconSheetView:self appKey:@"568b9a68e0f55a45bb0009d2" shareText:@"我通过值得投投资理财，返利多多。https://itunes.apple.com/us/app/zhi-de-tou/id1071751271?mt=8" shareImage:[UIImage imageNamed:@"icon.png"] shareToSnsNames:@[UMShareToQQ,UMShareToQzone] delegate:nil];
            
        }else{
            UIAlertController *alter = [UIAlertController alertControllerWithTitle:@"您的设备未安装QQ" message:nil preferredStyle:UIAlertControllerStyleAlert];
            [self presentViewController:alter animated:YES completion:nil];
            _removeTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(removeLable) userInfo:nil repeats:NO];
        }

        
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
    
}

#pragma mark ---表格代理方法---
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    InviteTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"invite"];
    inviteModel *model = _dataArray[indexPath.row];
    [cell createLable:model];
    cell.layer.borderColor = TableViewBackColor.CGColor;
    cell.layer.borderWidth = 1;
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
