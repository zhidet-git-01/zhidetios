//
//  ContactViewController.m
//  zhidetDemo
//
//  Created by 刘璐璐 on 15/12/24.
//  Copyright © 2015年 刘璐璐. All rights reserved.
//

#import "ContactViewController.h"
#import <UIView+SDAutoLayout.h>

@interface ContactViewController ()

@end

@implementation ContactViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
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
    
    NSArray *array1 = @[@"电话：", @"地址：", @"邮编："];
    NSArray *array2 = @[@"400-827-8270", @"浙江省杭州市江干区民心路100号万银国际7楼", @"310000"];
    
    UILabel *nameLable = [[UILabel alloc] init];
    nameLable.text = @"杭州砂岩网络科技有限公司";
    nameLable.font = [UIFont systemFontOfSize:16];
    [self.view addSubview:nameLable];
    nameLable.sd_layout
    .topSpaceToView(self.view, 20)
    .leftSpaceToView(self.view, 20)
    .rightSpaceToView(self.view, 20)
    .heightIs(20);
    
    for (int i = 0; i < 3; i++) {
        
        UILabel *phoneLable = [[UILabel alloc] init];
        phoneLable.text = array1[i];
        phoneLable.font = [UIFont systemFontOfSize:16];
        [self.view addSubview:phoneLable];
        phoneLable.sd_layout
        .topSpaceToView(nameLable, 5 + i * 30)
        .leftSpaceToView(self.view, 20)
        .widthIs(50)
        .heightIs(30);
        
        UILabel *phone = [[UILabel alloc] init];
        phone.text = array2[i];
        phone.numberOfLines = 0;
        phone.textColor = wordColor;
        phone.font = [UIFont systemFontOfSize:14];
        [self.view addSubview:phone];
        phone.sd_layout
        .topSpaceToView(nameLable, 5 + i * 30)
        .leftSpaceToView(phoneLable, 0)
        .rightSpaceToView(self.view, 5)
        .heightIs(30);
        
    }
    
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.image = [UIImage imageNamed:@"add-map"];
    [self.view addSubview:imageView];
    imageView.sd_layout
    .topSpaceToView(self.view, 140)
    .leftSpaceToView(self.view, 20)
    .rightSpaceToView(self.view, 20)
    .heightIs(WIDTH - 40);
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
