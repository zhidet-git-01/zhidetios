//
//  DetailSectionThreeCell.h
//  zhidetDemo
//
//  Created by 刘璐璐 on 15/12/7.
//  Copyright © 2015年 刘璐璐. All rights reserved.
//

#import <UIKit/UIKit.h>

@class platformModel;
@interface DetailSectionThreeCell : UITableViewCell

@property(nonatomic, strong)UILabel *nameLable;
@property(nonatomic, strong)UILabel *timeLable;
@property(nonatomic, strong)UILabel *backLable;
@property(nonatomic, strong)UILabel *profitLable;
@property(nonatomic, strong)UILabel *moneyLable;
@property(nonatomic, strong)UILabel *resonLable;
@property(nonatomic, strong)UILabel *introduceLable;
// 表示最高值
@property (nonatomic, assign) CGFloat maxY;

- (void)createText:(platformModel *)model;

@end
