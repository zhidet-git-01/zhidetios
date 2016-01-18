//
//  DetailSectionTwoCell.m
//  zhidetDemo
//
//  Created by 刘璐璐 on 15/12/7.
//  Copyright © 2015年 刘璐璐. All rights reserved.
//

#import "DetailSectionTwoCell.h"
#import "platformModel.h"
#import <UIView+SDAutoLayout.h>
#import "YJJRequest.h"

#define StepSize 13

@implementation DetailSectionTwoCell
{
    BOOL _isJoin;
    UILabel *attentionLable;
    UILabel *stepLable;
    UIView *changeView;  //步骤二动态view
    int y;
    UILabel *_accountLable;
    CGFloat _upHeight;
}

- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        UILabel *titleLable = [[UILabel alloc] init];
        titleLable.text = @"投标攻略";
        titleLable.font = [UIFont systemFontOfSize:18];
        [self.contentView addSubview:titleLable];
        titleLable.sd_layout
        .leftSpaceToView(self.contentView, 10)
        .topSpaceToView(self.contentView, 5)
        .widthIs(80)
        .heightIs(30);
        
        UILabel *tishiLable = [[UILabel alloc] init];
        tishiLable.font = [UIFont systemFontOfSize:StepSize];
        tishiLable.text = @"(手指左右滑动查看攻略)";
        [self.contentView addSubview:tishiLable];
        tishiLable.sd_layout
        .leftSpaceToView(titleLable, 0)
        .topSpaceToView(self.contentView, 10)
        .widthIs(150)
        .heightIs(20);
        
        //线
        UILabel *lineLable = [[UILabel alloc] init];
        lineLable.backgroundColor = AwayColor;
        [self.contentView addSubview:lineLable];
        lineLable.sd_layout
        .leftSpaceToView(self.contentView, 0)
        .topSpaceToView(titleLable, 5)
        .rightSpaceToView(self.contentView, 0)
        .heightIs(1);
        
        //滚动视图
        int startX = (WIDTH - 42 * 4) / 2;
        for (int i = 0; i < 4; i++) {
            
            UIButton *button = [[UIButton alloc] init];
            button.clipsToBounds = YES;
            button.layer.cornerRadius = 15;
            button.backgroundColor = AwayColor;
            [button setTitle:[NSString stringWithFormat:@"%d", i + 1] forState:UIControlStateNormal];
            button.tag = i + 1+80;
            [self.contentView addSubview:button];
            button.sd_layout
            .topSpaceToView(lineLable, 5)
            .leftSpaceToView(self.contentView, i * 42 + startX)
            .widthIs(30)
            .heightIs(30);
            if (i == 0) {
                button.sd_layout
                .heightIs(34)
                .widthIs(34);
                button.backgroundColor = BackColor;
            }
            
        }
        
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.userInteractionEnabled = YES;
        _scrollView.bounces = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.contentSize = CGSizeMake(WIDTH * 4, 360);
        _scrollView.pagingEnabled = YES;
        _scrollView.delegate = self;
        [self.contentView addSubview:_scrollView];
        _scrollView.sd_layout
        .topSpaceToView(lineLable, 40)
        .leftSpaceToView(self.contentView, 0)
        .widthIs(WIDTH)
        .heightIs(360);
        
        [self createUI1];
        [self createUI2];
        [self createUI3];
        [self createUI4];
        
        
    }
    return self;
}

#pragma mark ---滚动视图上的显示视图---
#pragma mark ---步骤1---
- (void)createUI1{
    
    stepLable = [[UILabel alloc] init];
    stepLable.text = @"第一步：注册账号";
    stepLable.backgroundColor = LableColor;
    stepLable.textAlignment = NSTextAlignmentCenter;
    stepLable.layer.borderColor = AwayColor.CGColor;
    stepLable.layer.borderWidth = 1;
    [_scrollView addSubview:stepLable];
    stepLable.sd_layout
    .topSpaceToView(_scrollView, 10)
    .leftSpaceToView(_scrollView, 10)
    .rightSpaceToView(_scrollView, 10)
    .heightIs(30);
    
    //
    UIView *view11 = [[UIView alloc]init];
    view11.layer.borderWidth = 1;
    view11.layer.borderColor = AwayColor.CGColor;
    [_scrollView addSubview:view11];
    view11.sd_layout
    .topSpaceToView(stepLable, 0)
    .leftSpaceToView(_scrollView, 10)
    .rightSpaceToView(_scrollView, 10)
    .heightIs(50);
 
    
    UILabel *lable2 = [[UILabel alloc] init];
    lable2.tag = 100;
    lable2.font = [UIFont systemFontOfSize:StepSize];
    [view11 addSubview:lable2];
    lable2.sd_layout
    .topSpaceToView(view11, 10)
    .leftSpaceToView(view11, 10)
    .rightSpaceToView(view11, 10)
    .heightIs(30);
    
    
    //注意事项
    attentionLable = [[UILabel alloc] initWithFrame:CGRectMake(10, 110, WIDTH - 20, 30)];
    attentionLable.text = @"注意事项";
    attentionLable.backgroundColor = LableColor;
    attentionLable.textAlignment = NSTextAlignmentCenter;
    attentionLable.layer.borderColor = AwayColor.CGColor;
    attentionLable.layer.borderWidth = 1;
    [_scrollView addSubview:attentionLable];
    attentionLable.sd_layout
    .topSpaceToView(view11, 10)
    .leftSpaceToView(_scrollView, 10)
    .rightSpaceToView(_scrollView, 10)
    .heightIs(30);
    
    UIView *view22 = [[UIView alloc] init];
    view22.layer.borderColor = AwayColor.CGColor;
    view22.layer.borderWidth = 1;
    [_scrollView addSubview:view22];
    view22.sd_layout
    .topSpaceToView(attentionLable, 0)
    .leftSpaceToView(_scrollView, 10)
    .rightSpaceToView(_scrollView, 10)
    .heightIs(130);
    
    UILabel *atLable1 = [[UILabel alloc] init];
    atLable1.text = @"1、为保证获得返利，请你在注册第三方平台账户时，手机、用户身份信息真实有效并于值得投保持一致。";
    atLable1.font = [UIFont systemFontOfSize:StepSize];
    atLable1.numberOfLines = 0;
    [view22 addSubview:atLable1];
    atLable1.sd_layout
    .topSpaceToView(view22, 10)
    .leftSpaceToView(view22, 10)
    .rightSpaceToView(view22, 10)
    .heightIs(60);
    
    UILabel *atLable2 = [[UILabel alloc] initWithFrame:CGRectMake(10, 65, WIDTH - 40, 60)];
    atLable2.text = @"2、跳转后仔细核对合作平台标的信息，请按照［值得投］起投和上限标准，投错或少投则不计入返利。";
    atLable2.font = [UIFont systemFontOfSize:StepSize];
    atLable2.numberOfLines = 0;
    [view22 addSubview:atLable2];
    atLable2.sd_layout
    .topSpaceToView(atLable1, 5)
    .leftSpaceToView(view22, 10)
    .rightSpaceToView(view22, 10)
    .heightIs(60);
    
   
}
#pragma mark ---步骤2---
- (void)createUI2{
    
    UILabel *stepLable2 = [[UILabel alloc] init];
    stepLable2.text = @"第二步：选择并投标";
    stepLable2.backgroundColor = LableColor;
    stepLable2.textAlignment = NSTextAlignmentCenter;
    stepLable2.layer.borderColor = AwayColor.CGColor;
    stepLable2.layer.borderWidth = 1;
    [_scrollView addSubview:stepLable2];
    stepLable2.sd_layout
    .topSpaceToView(_scrollView, 10)
    .leftSpaceToView(_scrollView, WIDTH + 10)
    .widthIs(WIDTH - 20)
    .heightIs(30);
    
    _demandLable = [[UILabel alloc] init];
    _demandLable.text = @"奖励要求";
    _demandLable.backgroundColor = LableColor;
    _demandLable.textAlignment = NSTextAlignmentCenter;
    _demandLable.layer.borderColor = AwayColor.CGColor;
    _demandLable.layer.borderWidth = 1;
    [_scrollView addSubview:_demandLable];
    _demandLable.sd_layout
    .topSpaceToView(stepLable2, 0)
    .leftSpaceToView(_scrollView, WIDTH + 10)
    .widthIs((WIDTH - 20) * 0.8)
    .heightIs(30);
    
    
    _Lable = [[UILabel alloc] init];
    _Lable.text = @"奖励";
    _Lable.backgroundColor = LableColor;
    _Lable.textAlignment = NSTextAlignmentCenter;
    _Lable.layer.borderColor = AwayColor.CGColor;
    _Lable.layer.borderWidth = 1;
    [_scrollView addSubview:_Lable];
    _Lable.sd_layout
    .leftSpaceToView(_demandLable, 0)
    .topSpaceToView(stepLable2, 0)
    .widthIs((WIDTH - 20) * 0.2)
    .heightIs(30);
    
}
#pragma mark ---步骤3---
- (void)createUI3{
    
    UILabel *stepLable3 = [[UILabel alloc] init];
    stepLable3.text = @"第三步：提交账号";
    stepLable3.backgroundColor = LableColor;
    stepLable3.textAlignment = NSTextAlignmentCenter;
    stepLable3.layer.borderColor = AwayColor.CGColor;
    stepLable3.layer.borderWidth = 1;
    [_scrollView addSubview:stepLable3];
    stepLable3.sd_layout
    .topSpaceToView(_scrollView, 10)
    .leftSpaceToView(_scrollView, WIDTH * 2 + 10)
    .widthIs(WIDTH - 20)
    .heightIs(30);
    
    
    UIView *view = [[UIView alloc] init];
    view.tag = 1;
    view.layer.borderWidth = 1;
    view.layer.borderColor = AwayColor.CGColor;
    [_scrollView addSubview:view];
    view.sd_layout
    .topSpaceToView(stepLable3, 0)
    .leftSpaceToView(_scrollView, WIDTH * 2 + 10)
    .widthIs(WIDTH - 20)
    .heightIs(150);
    
    UILabel *userLable = [[UILabel alloc] init];
    userLable.text = @"提交在标地平台注册的账号:";
    userLable.font = [UIFont systemFontOfSize:wordSize];
    [view addSubview:userLable];
    userLable.sd_layout
    .topSpaceToView(view,10)
    .leftSpaceToView(view, 10)
    .widthIs(190)
    .heightIs(30);
    
    _textView = [[UITextField alloc] init];
    _textView.delegate = self;
    _textView.layer.borderColor = AwayColor.CGColor;
    _textView.layer.borderWidth = 1;
    _textView.clearButtonMode = YES;
    [view addSubview:_textView];
    _textView.sd_layout
    .topSpaceToView(userLable, 5)
    .leftSpaceToView(view, 30)
    .widthIs(160)
    .heightIs(30);
    
    _submitButton = [[UIButton alloc] init];
    _submitButton.backgroundColor = BidColor;
    [_submitButton setTitle:@"提交" forState:UIControlStateNormal];
    _submitButton.clipsToBounds = YES;
    _submitButton.layer.cornerRadius = 5;
    _submitButton.userInteractionEnabled = YES;
    [_submitButton addTarget:self action:@selector(gotoSubmit:) forControlEvents:UIControlEventTouchUpInside];
    _submitButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [view addSubview:_submitButton];
    _submitButton.sd_layout
    .topSpaceToView(userLable, 5)
    .leftSpaceToView(_textView, 5)
    .widthIs(60)
    .heightIs(30);

    
    UILabel *tLable = [[UILabel alloc] init];
    tLable.text = @"温馨提示：";
    tLable.font = [UIFont systemFontOfSize:15];
    [view addSubview:tLable];
    tLable.sd_layout
    .topSpaceToView(_textView, 5)
    .leftSpaceToView(view, 10)
    .widthIs(80)
    .heightIs(30);
    
    UILabel *contentLable = [[UILabel alloc] init];
    contentLable.text = @"投资成功后务必在上方提交标地平台的账户，并保证正确";
    contentLable.font = [UIFont systemFontOfSize:StepSize];
    contentLable.numberOfLines = 0;
    [view addSubview:contentLable];
    contentLable.sd_layout
    .topSpaceToView(_textView, 5)
    .leftSpaceToView(tLable, 0)
    .rightSpaceToView(view, 10)
    .heightIs(40);
    
}
#pragma mark ---步骤4---
- (void)createUI4{
    
    UILabel *stepLable4 = [[UILabel alloc] init];
    stepLable4.text = @"第四步：账号审核";
    stepLable4.backgroundColor = LableColor;
    stepLable4.textAlignment = NSTextAlignmentCenter;
    stepLable4.layer.borderColor = AwayColor.CGColor;
    stepLable4.layer.borderWidth = 1;
    [_scrollView addSubview:stepLable4];
    stepLable4.sd_layout
    .topSpaceToView(_scrollView, 10)
    .leftSpaceToView(_scrollView, WIDTH * 3 + 10)
    .widthIs(WIDTH - 20)
    .heightIs(30);
    
    UIView *view = [[UIView alloc] init];
    view.layer.borderWidth = 1;
    view.layer.borderColor = AwayColor.CGColor;
    [_scrollView addSubview:view];
    view.sd_layout
    .topSpaceToView(stepLable4, 0)
    .leftSpaceToView(_scrollView, WIDTH * 3 + 10)
    .widthIs(WIDTH - 20)
    .heightIs(100);
    
    UILabel *lable1 = [[UILabel alloc] init];
    lable1.text = @"①如您已完成投资，那就赶紧在前一步提交账号吧，通过审核后，您将获得我们的返利哦！";
    lable1.font = [UIFont systemFontOfSize:14];
    lable1.numberOfLines = 0;
    [view addSubview:lable1];
    lable1.sd_layout
    .topSpaceToView(view, 15)
    .leftSpaceToView(view, 10)
    .rightSpaceToView(view, 10)
    .heightIs(40);
    
    UILabel *lable2 = [[UILabel alloc] initWithFrame:CGRectMake(10, 65, WIDTH - 40, 20)];
    lable2.text = @"②如您还未投资，那就赶紧投资拿返利吧！";
    lable2.font = [UIFont systemFontOfSize:14];
    lable2.numberOfLines = 0;
    [view addSubview:lable2];
    lable2.sd_layout
    .topSpaceToView(lable1, 10)
    .leftSpaceToView(view, 10)
    .rightSpaceToView(view, 10)
    .heightIs(20);

 }

#pragma mark ---scrollview代理方法---

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    int x = _scrollView.contentOffset.x / WIDTH;
    [self changeColor:x + 1];
    
}

- (void)changeColor:(int)x{
    
    if (y == 0) {
        y = 1;
    }
    if (x != y) {
        UIButton *nowButton = (UIButton *)[self.contentView viewWithTag:x+80];
        UIButton *upButton = (UIButton *)[self.contentView viewWithTag:y+80];
        [UIView animateWithDuration:0.1 animations:^{
            
            nowButton.backgroundColor = BackColor;
            CGRect nowframe = CGRectMake(nowButton.frame.origin.x, nowButton.frame.origin.y, 34, 34);
            nowButton.layer.cornerRadius = 17;
            nowButton.frame = nowframe;
            
            upButton.backgroundColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1];
            CGRect upframe = CGRectMake(upButton.frame.origin.x, upButton.frame.origin.y, 30, 30);
            upButton.layer.cornerRadius = 15;
            upButton.frame = upframe;
            
        }];

        y = x;
    }
    

}
#pragma mark ---动态---
- (void)createText:(platformModel *)model{
    
    [changeView removeFromSuperview];
    changeView.userInteractionEnabled = YES;
    
    UILabel *lable2 = (UILabel *)[self.contentView viewWithTag:100];
    lable2.text = [NSString stringWithFormat:@"注册成为%@用户，并完成实名认证", model.title];
    
    NSArray *prizeplanArray = [model.prizeplan componentsSeparatedByString:@";"];
    NSMutableArray *array1 = [[NSMutableArray alloc] init];
    NSMutableArray *array2 = [[NSMutableArray alloc] init];
    for (int i = 0; i < prizeplanArray.count; i++) {
        
        if (i % 2 == 0) {
            
            [array1 addObject:prizeplanArray[i]];
            
        }else{
            
            [array2 addObject:prizeplanArray[i]];
        }
    }
    
    changeView = [[UIView alloc] init];
    [_scrollView addSubview:changeView];
    changeView.sd_layout
    .topSpaceToView(_scrollView, 70)
    .leftSpaceToView(_scrollView, WIDTH + 10)
    .widthIs(WIDTH - 20)
    .heightIs(200);
    
    _numberLable = [[UILabel alloc] init];
    _numberLable.numberOfLines = 3;
    _numberLable.layer.borderWidth = 1;
    _numberLable.layer.borderColor = AwayColor.CGColor;
    _numberLable.textAlignment = NSTextAlignmentCenter;
    if (array1.count == 1) {
        _numberLable.text = @"一";
    }else if(array1.count == 2){
        _numberLable.text = @"二选一";
    }else if(array1.count == 3){
        _numberLable.text = @"三选一";
    }else{
        _numberLable.text = @"四选一";
    }
    [changeView addSubview:_numberLable];

    for (int i = 0; i < array1.count; i++) {
        _view1 = [[UILabel alloc] init];
        _view1.layer.borderWidth = 1;
        _view1.userInteractionEnabled = YES;
        _view1.layer.borderColor = AwayColor.CGColor;
        [changeView addSubview:_view1];
        _view1.sd_layout
        .topSpaceToView(changeView, _upHeight)
        .leftSpaceToView(changeView, 30)
        .widthIs((WIDTH - 20) * 0.8 - 30)
        .heightIs(50);
        
        _lable1 = [[UILabel alloc] init];
        _lable1.text = [NSString stringWithFormat:@"首次投资%@元即可获得%@元奖励", array1[i], array2[i]];
        _lable1.font = [UIFont systemFontOfSize:13];
        _lable1.numberOfLines = 0;
        [_view1 addSubview:_lable1];
        
        //根据文字和字体计算文字高度
        CGSize size = [_lable1.text boundingRectWithSize:CGSizeMake(_demandLable.frame.size.width - 40, MAXFLOAT) options:NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13]} context:nil].size;
        
        if (i == 0) {
            _upHeight = 0;
        }
        
        //投标按钮
        _button = [[UIButton alloc] init];
        _button.backgroundColor = BidColor;
        _button.clipsToBounds = YES;
        _button.layer.cornerRadius = 4;
        _button.userInteractionEnabled = YES;
        _button.titleLabel.font = [UIFont systemFontOfSize:StepSize];
        [_button setTitle:@"马上去投标" forState:UIControlStateNormal];
        [_button addTarget:self action:@selector(gotoBid:) forControlEvents:UIControlEventTouchUpInside];
        [_view1 addSubview:_button];
        
        //更改视图的大小

        _lable1.sd_layout
        .topSpaceToView(_view1, 5)
        .leftSpaceToView(_view1, 5)
        .rightSpaceToView(_view1, 5)
        .heightIs(size.height);

        _button.sd_layout
        .topSpaceToView(_lable1, 2)
        .leftSpaceToView(_view1, 2)
        .widthIs(70)
        .heightIs(20);
        
        _view1.sd_layout
        .heightIs(size.height + 32);
        
    
        UILabel *lable2 = [[UILabel alloc] init];
        lable2.text = [NSString stringWithFormat:@"%@元", array2[i]];
        lable2.textAlignment = NSTextAlignmentCenter;
        lable2.font = [UIFont systemFontOfSize:13];
        lable2.layer.borderWidth = 1;
        lable2.layer.borderColor = AwayColor.CGColor;
        [changeView addSubview:lable2];
        lable2.sd_layout
        .topSpaceToView(changeView, _upHeight)
        .leftSpaceToView(_view1, 0)
        .rightSpaceToView(changeView, 0)
        .heightIs(size.height + 32);
        
        _upHeight += (size.height + 32);
        
        _numberLable.sd_layout
        .topSpaceToView(changeView, 0)
        .leftSpaceToView(changeView, 0)
        .widthIs(30)
        .heightIs(_upHeight);

        changeView.sd_layout
        .heightIs(_upHeight);
    }

    
    _maxY = changeView.frame.size.height + _demandLable.frame.size.height + 150;
    if (_maxY < 370) {
        _maxY = 370;
    }
    
    
    if ([userDefault boolForKey:@"isJoin"]) {
        
        UIView *view = (UIView *)[self.contentView viewWithTag:1];
        NSDictionary *dic = @{@"token":[userDefault objectForKey:@"token"], @"companyid":model.companyid};
        
        [YJJRequest PostrequestwithURL:SubmitJudge dic:dic complete:^(NSData *data) {
            
            NSDictionary *result = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            if ([result[@"resultCode"] longLongValue] == 0) {
                
                NSDictionary *user = result[@"usercompanyRel"];
                NSString *account = user[@"account"];
                
                _accountLable = [[UILabel alloc] init];
                _accountLable.font = [UIFont systemFontOfSize:wordSize];
                _accountLable.text = account;
                [view addSubview:_accountLable];
                _accountLable.sd_layout
                .topSpaceToView(view, 10)
                .leftSpaceToView(view, 200)
                .widthIs(100)
                .heightIs(30);
                
                [_submitButton setTitle:@"修改" forState:UIControlStateNormal];
            }
            
        } fail:^(NSError *error) {
            
        }];
    }
}

#pragma mark ---按钮点击时间---
//提交
- (void)gotoSubmit:(UIButton *)sender{
    
    [_textView resignFirstResponder];
    //发送提交通知;
    NSDictionary *dict = @{@"submit":_textView.text};
    [NotiCenter postNotificationName:@"Submit" object:self userInfo:dict];
    
}
//键盘的return键 点击时就会触发该方法
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    return YES;
}


//投标
- (void)gotoBid:(UIButton *)sender{
    
    //发送投标通知
    [NotiCenter postNotificationName:@"Bid" object:self userInfo:nil];
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
