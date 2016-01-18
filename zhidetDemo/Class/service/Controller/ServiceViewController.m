//
//  NewsViewController.m
//  zhidetDemo
//
//  Created by 刘璐璐 on 15/12/4.
//  Copyright © 2015年 刘璐璐. All rights reserved.
//

#import "ServiceViewController.h"
#import "ServiceTableViewCell.h"
#import "ServiceModel.h"
#import "ChatViewController.h"
#import <AVFoundation/AVFoundation.h>

#define WIDTH [UIScreen mainScreen].bounds.size.width

@interface ServiceViewController ()<UITableViewDataSource, UITableViewDelegate, AVCaptureMetadataOutputObjectsDelegate>
@property(strong,nonatomic) AVCaptureSession *session; // 捕捉会话
@property(strong,nonatomic)  AVCaptureVideoPreviewLayer *previewLayer;  // 二维码生成

@end

@implementation ServiceViewController
{
    UITableView *_tableView;
    NSMutableArray *_dataArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _dataArray = [[NSMutableArray alloc] init];
    NSArray *headArray = @[@"http://service.zhidet.com/images/customServer/kefutch.jpg", @"http://service.zhidet.com/images/customServer/kefuyl.jpg"];
    NSArray *nameArray = @[@"童翀晖", @"袁蕾"];
    NSArray *phoneArray = @[@"17072726759", @"15858240583"];
    NSArray *qqArray = @[@"3157007942", @"2647414940"];
    NSArray *wxArray = @[@"izdt002", @"izdt003"];
    NSArray *ewmArray = @[@"http://service.zhidet.com/images/customServer/izdt002.jpg", @"http://service.zhidet.com/images/customServer/izdt003.jpg"];
    for (int i = 0; i < 2; i++) {
        
        ServiceModel *model = [[ServiceModel alloc] init];
        model.headImage = headArray[i];
        model.name = nameArray[i];
        model.phone = phoneArray[i];
        model.qq = qqArray[i];
        model.wx = wxArray[i];
        model.tdcImage = ewmArray[i];
        [_dataArray addObject:model];
    }
    
    
    UILabel *titleLable = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
    titleLable.textAlignment = NSTextAlignmentCenter;
    titleLable.textColor = [UIColor whiteColor];
    titleLable.text = @"咨询客服";
    titleLable.font = [UIFont systemFontOfSize:20];
    self.navigationItem.titleView = titleLable;
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT - 70) style:UITableViewStylePlain
                  ];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.rowHeight = 140;
    _tableView.backgroundColor = TableViewBackColor;
    _tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    [self.view addSubview:_tableView];
    
    [_tableView registerClass:[ServiceTableViewCell class] forCellReuseIdentifier:@"service"];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark ----tableViewDelegate---
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _dataArray.count;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    ServiceTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"service"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    ServiceModel *model = _dataArray[indexPath.section];
    [cell createModel:model];
    //按钮
    [cell.phone addTarget:self action:@selector(gotoCall:) forControlEvents:UIControlEventTouchUpInside];
    [cell.qq addTarget:self action:@selector(gotoQQ:) forControlEvents:UIControlEventTouchUpInside];
    [cell.wx addTarget:self action:@selector(gotoWX:) forControlEvents:UIControlEventTouchUpInside];
    UILongPressGestureRecognizer *touch = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(readQRcode:)];
    cell.tdcimageView.userInteractionEnabled = YES;
    [cell.tdcimageView addGestureRecognizer:touch];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    

}

#pragma mark ---按钮点击事件---

- (void)gotoCall:(UIButton *)sender{
  
    NSString *str = [NSString stringWithFormat:@"tel://%@", sender.titleLabel.text];
    NSURL *url = [NSURL URLWithString:str];
    if ([[UIApplication sharedApplication] canOpenURL:url]) {
        [[UIApplication sharedApplication] openURL:url];
    }
}

- (void)gotoQQ:(UIButton * )sender{
    
    ChatViewController *chat = [[ChatViewController alloc] init];
    chat.qqStr = sender.titleLabel.text;
    [self.navigationController pushViewController:chat animated:YES];
    
}

- (void)gotoWX:(UIButton *)sender{
   
    NSString *str = [NSString stringWithFormat:@"weixin://%@", sender.titleLabel.text];
    NSURL *url = [NSURL URLWithString:str];
    if ([[UIApplication sharedApplication] canOpenURL:url]) {
        [[UIApplication sharedApplication] openURL:url];
    }
}


#pragma mark - 读取二维码
- (void)readQRcode:(UIGestureRecognizer*) recognizer
{
    // 1. 摄像头设备
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    // 2. 设置输入
    // 因为模拟器是没有摄像头的，因此在此最好做一个判断
    NSError *error = nil;
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:device error:&error];
    if (error) {
        NSLog(@"没有摄像头-%@", error.localizedDescription);
        return;
    }
    
    // 3. 设置输出(Metadata元数据)
    AVCaptureMetadataOutput *output = [[AVCaptureMetadataOutput alloc] init];
    // 3.1 设置输出的代理
    // 说明：使用主线程队列，相应比较同步，使用其他队列，相应不同步，容易让用户产生不好的体验setMetadataObjectsDelegate
    [output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    
    // 4. 拍摄会话
    AVCaptureSession *session = [[AVCaptureSession alloc] init];
    // 添加session的输入和输出
    [session addInput:input];
    [session addOutput:output];
    
    // 4.1 设置输出的格式
    // 提示：一定要先设置会话的输出为output之后，再指定输出的元数据类型！
    [output setMetadataObjectTypes:@[AVMetadataObjectTypeQRCode]];
    
    // 5. 设置预览图层（用来让用户能够看到扫描情况）
    AVCaptureVideoPreviewLayer *preview = [AVCaptureVideoPreviewLayer layerWithSession:session];
    
    // 5.1 设置preview图层的属性
    [preview setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    
    // 5.2 设置preview图层的大小
    [preview setFrame:self.view.bounds];
    
    // 5.3 将图层添加到视图的图层
    [self.view.layer insertSublayer:preview atIndex:0];
    self.previewLayer = preview;
    
    // 6. 启动会话
    [session startRunning];
    
    self.session = session;
}

#pragma mark - 输出代理方法
// 此方法是在识别到QRCode，并且完成转换
// 如果QRCode的内容越大，转换需要的时间就越长
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    // 会频繁的扫描，调用代理方法
    // 1. 如果扫描完成，停止会话
    [self.session stopRunning];
    // 2. 删除预览图层
    [self.previewLayer removeFromSuperlayer];
    
    NSLog(@"%@", metadataObjects);
    
    // 3. 设置界面显示扫描结果
    if (metadataObjects.count > 0) {
        AVMetadataMachineReadableCodeObject *obj = metadataObjects[0];
        // 提示：如果需要对url或者名片等信息进行扫描，可以在此进行扩展！
        NSLog(@"%@", obj.stringValue);
    }
}


@end

