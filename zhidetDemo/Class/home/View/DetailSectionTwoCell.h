//
//  DetailSectionTwoCell.h
//  zhidetDemo
//
//  Created by 刘璐璐 on 15/12/7.
//  Copyright © 2015年 刘璐璐. All rights reserved.
//

#import <UIKit/UIKit.h>

@class platformModel;
@interface DetailSectionTwoCell : UITableViewCell<UIScrollViewDelegate, UITextFieldDelegate>

@property(nonatomic, strong)UIScrollView *scrollView;
@property(nonatomic, strong)UIButton *registButton;
@property(nonatomic, strong)UIButton *joinButton;
@property(nonatomic, strong)UIButton *nowRButton;
@property(nonatomic, strong)UIButton *submitButton;

@property(nonatomic, strong)UILabel *lable1;
@property(nonatomic, strong)UILabel *lable2;
@property(nonatomic, strong)UILabel *numberLable;
@property(nonatomic, strong)UILabel *Lable;
@property(nonatomic, strong)UILabel *demandLable;
@property(nonatomic, strong)UIView *view1;
@property(nonatomic, strong)UIButton *button;
@property(nonatomic, strong)UITextField *textView;


// 表示最高值
@property (nonatomic, assign) CGFloat maxY;

- (void)createText:(platformModel *)model;


@end
