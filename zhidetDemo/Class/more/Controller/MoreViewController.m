//
//  SeverViewController.m
//  zhidetDemo
//
//  Created by 刘璐璐 on 15/12/4.
//  Copyright © 2015年 刘璐璐. All rights reserved.
//

#import "MoreViewController.h"
#import "CompanyViewController.h"
#import "JoinUSViewController.h"
#import "CLLockVC.h"
#import "JoinViewController.h"
#import "MessageViewController.h"
#import "ContactViewController.h"

@interface MoreViewController ()<UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate>

@end

@implementation MoreViewController
{
    UITableView *_tableView;
    NSMutableArray *_dataArray;
    NSArray *_urlArray;
    NSString *_size;
    UISwitch *_mySwitch;
    NSTimer *_removeTimer;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //导航栏
    UILabel *titleLable = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
    titleLable.textAlignment = NSTextAlignmentCenter;
    titleLable.textColor = [UIColor whiteColor];
    titleLable.text = @"关于我们";
    titleLable.font = [UIFont systemFontOfSize:20];
    self.navigationItem.titleView = titleLable;
    
    //数据源
    
    _urlArray = @[@"http://mobile.zhidet.com/us/about-us", @"http://mobile.zhidet.com/us/join-us", @"http://mobile.zhidet.com/suggest/to-suggest", @"http://mobile.zhidet.com/us/link-us"];
    
    
    _dataArray = [[NSMutableArray alloc]init];
    NSArray *oneArray = [[NSArray alloc] initWithObjects:@"公司介绍", @"加入我们", @"提建议", @"联系我们", nil];
    NSArray *twoArray = [[NSArray alloc] initWithObjects:@"清除缓存", @"手势密码", nil];
    [_dataArray addObject:oneArray];
    [_dataArray addObject:twoArray];
    
    [self createUI];
    

}

- (void)createUI{
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT - 65) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.rowHeight = 50;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor = [UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:1];
    [self.view addSubview:_tableView];
    
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"aboutWe"];
}

#pragma mark ---tableViewDelegate---
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [_dataArray[section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"aboutWe"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    //赋值
    cell.textLabel.text = [_dataArray[indexPath.section] objectAtIndex:indexPath.row];
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    cell.layer.borderWidth = 1;
    cell.layer.borderColor = [UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:1].CGColor;
    //右边图片
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 15, 20)];
    imageView.image = [UIImage imageNamed:@"we_right"];
    
    //缓存的大小
    UILabel *sizeLable = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 60, 20)];
    //缓存大小
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    NSString *path = [paths lastObject];
    _size = [NSString stringWithFormat:@"%.1fM", [self folderSizeAtPath:path]];
    if ([_size isEqualToString:@"0.0M"]) {
        _size = @"";
    }
    sizeLable.text = _size;
    
    if (indexPath.section == 1 && indexPath.row == 0) {
        //清除缓存右边视图
        cell.accessoryView = sizeLable;
        
    }else if(indexPath.section == 1 && indexPath.row == 1){

        
        _mySwitch = [[UISwitch alloc]initWithFrame:CGRectMake(0, 0, 10, 10)];
        
        
        //接收通知
        [NotiCenter addObserver:self selector:@selector(downSwitch) name:@"DownSafe" object:nil];
        [NotiCenter addObserver:self selector:@selector(upSwitch) name:@"upSafe" object:nil];
        
        BOOL isSafe = [userDefault boolForKey:@"isSafe"];
        BOOL isJoin = [userDefault boolForKey:@"isJoin"];
        if (isSafe && isJoin) {
            [_mySwitch setOn:YES];
        }else{
            [_mySwitch setOn:NO];
        }
        [_mySwitch addTarget:self action:@selector(changeSwitch:) forControlEvents:UIControlEventValueChanged];
        cell.accessoryView = _mySwitch;
        
    }else{
        cell.accessoryView = imageView;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
     if (indexPath.section == 1 && indexPath.row == 0){
        
        //清除缓存
        [self clean];
        if([_size isEqualToString:@"缓存0.0M"]||[self respondsToSelector:@selector(clean)]){
            UIAlertController *alter = [UIAlertController alertControllerWithTitle:@"缓存已清空" message:nil preferredStyle:UIAlertControllerStyleAlert];
            [self presentViewController:alter animated:YES completion:nil];
            _removeTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(removeLable) userInfo:nil repeats:NO];
            
            
        }
    }else if (indexPath.section == 0 && indexPath.row == 0){
        //公司介绍
        CompanyViewController *aboutWe = [[CompanyViewController alloc]init];
        aboutWe.titleStr = [_dataArray[indexPath.section] objectAtIndex:indexPath.row];
        [self.navigationController pushViewController:aboutWe animated:YES];
        
    }else if(indexPath.section == 0 && indexPath.row == 2){
        //提建议
        BOOL isJoin = [userDefault boolForKey:@"isJoin"];
        if(!isJoin){
            
            //没有登录的情况下
            UIAlertController *alter = [UIAlertController alertControllerWithTitle:@"您还未登录" message:nil preferredStyle:UIAlertControllerStyleAlert];
            [self presentViewController:alter animated:YES completion:nil];
            _removeTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(removeLable) userInfo:nil repeats:NO];
            
        }else{
            
            MessageViewController *message = [[MessageViewController alloc] init];
            [self.navigationController pushViewController:message animated:YES];
        }
        
    }else if (indexPath.section == 0 && indexPath.row == 1){
        //加入我们
        JoinUSViewController *joinUs = [[JoinUSViewController alloc] init];
        joinUs.titleStr = [_dataArray[indexPath.section] objectAtIndex:indexPath.row];
        [self.navigationController pushViewController:joinUs animated:YES];
        
    }else if(indexPath.section == 0 && indexPath.row == 3){
        //联系我们
        ContactViewController *contact = [[ContactViewController alloc] init];
        contact.titleStr = [_dataArray[indexPath.section] objectAtIndex:indexPath.row];
        [self.navigationController pushViewController:contact animated:YES];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 10;
}

#pragma mark ---手势密码开关事件---
- (void)changeSwitch:(UISwitch *)myswitch{

    
    if (myswitch.isOn) {
        //打开状态

        BOOL isJoin = [userDefault boolForKey:@"isJoin"];
        
        if (isJoin) {
            //已经登录的情况下
            
            NSLog(@"＝＝＝%d",[userDefault boolForKey:@"StartSafe"] );
            if ([userDefault boolForKey:@"StartSafe"]) {
                
                [userDefault setBool:YES forKey:@"isSafe"];
                [CLLockVC showVerifyLockVCInVC:self forgetPwdBlock:^{
                    
                    [userDefault setBool:NO forKey:@"isSafe"];
                    [userDefault setBool:NO forKey:@"StartSafe"];
                    [userDefault setBool:NO forKey:@"isFirstSafe"];
                    [userDefault setBool:NO forKey:@"isJoin"];
                    [CLLockVC clearPwd];
                    //发送已经退出的通知 关闭手势密码按钮
                    [NotiCenter postNotificationName:@"DownSafe" object:self userInfo:nil];
                    [NotiCenter postNotificationName:@"Exited" object:self userInfo:nil];
                    JoinViewController *join = [[JoinViewController alloc] init];
                    [self.navigationController pushViewController:join animated:YES];
                    
                } successBlock:^(CLLockVC *lockVC, NSString *pwd) {
                    
                    [lockVC dismiss:1.0f];
          
                }];
            }else{
               
                
                [userDefault setBool:YES forKey:@"StartSafe"];
                [userDefault setBool:YES forKey:@"isSafe"];
                [CLLockVC showSettingLockVCInVC:self successBlock:^(CLLockVC *lockVC, NSString *pwd) {
                    [lockVC dismiss:1.0f];
                }];
//                [self.navigationController popViewControllerAnimated:YES];
            }
            
            
        }else{
            //没有登录的情况下
            [myswitch setOn:NO];
            UIAlertController *alter = [UIAlertController alertControllerWithTitle:@"您还未登录" message:nil preferredStyle:UIAlertControllerStyleAlert];
            [self presentViewController:alter animated:YES completion:nil];
            _removeTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(removeLable) userInfo:nil repeats:NO];
            
        }
        
    }else{
        //关闭状态
        [userDefault setBool:NO forKey:@"isSafe"];
        UIAlertController *alter = [UIAlertController alertControllerWithTitle:@"已关闭手势解锁" message:nil preferredStyle:UIAlertControllerStyleAlert];
        [self presentViewController:alter animated:YES completion:nil];
        _removeTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(removeLable) userInfo:nil repeats:NO];
       
    }
    

}

//未登录的状态下关闭手势按钮
- (void)downSwitch{
    
//    [userDefault setBool:NO forKey:@"isSafe"];
    [_mySwitch setOn:NO];
}

- (void)upSwitch{
    
    if ([userDefault boolForKey:@"isSafe"]) {
        
        [_mySwitch setOn:YES];
    }
    
}


#pragma mark --------清除缓存的方法-----------
- (void)clean
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    NSString *path = [paths lastObject];
    _size = [NSString stringWithFormat:@"缓存%.1fM",[self folderSizeAtPath:path]];
    [_tableView reloadData];
    NSArray *files = [[NSFileManager defaultManager]subpathsAtPath:path];
    for (NSString *p in files) {
        NSError *error;
        NSString *Path = [path stringByAppendingPathComponent:p];
        if([[NSFileManager defaultManager]fileExistsAtPath:Path]){
            [[NSFileManager defaultManager]removeItemAtPath:Path error:&error];
        }
    }
}
- (long long)fileSizeAtPath:(NSString *)filePath
{
    NSFileManager *manager = [NSFileManager defaultManager];
    if([manager fileExistsAtPath:filePath]){
        return [[manager attributesOfItemAtPath:filePath error:nil]fileSize];
    }
    return 0;
}
- (float)folderSizeAtPath:(NSString *)folderPath
{
    NSFileManager *manager = [NSFileManager defaultManager];
    if(![manager fileExistsAtPath:folderPath]){
        return 0;
    }else{
        NSEnumerator *childFilesEnumerator = [[manager subpathsAtPath:folderPath] objectEnumerator];
        NSString* fileName;
        long long folderSize = 0;
        while ((fileName = [childFilesEnumerator nextObject]) != nil){
            NSString* fileAbsolutePath = [folderPath stringByAppendingPathComponent:fileName];
            folderSize += [self fileSizeAtPath:fileAbsolutePath];
        }
        return folderSize/(1024.0*1024.0);
    }
}

//移除lable
//移除提示
- (void)removeLable{
    [self dismissViewControllerAnimated:YES completion:nil];
}



- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = NO;
}
- (void)viewDidDisappear:(BOOL)animated{
    
    [super viewDidDisappear:animated];
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
