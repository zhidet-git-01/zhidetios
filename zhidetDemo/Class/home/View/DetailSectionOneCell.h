//
//  DetailSectionOneCell.h
//  zhidetDemo
//
//  Created by 刘璐璐 on 15/12/7.
//  Copyright © 2015年 刘璐璐. All rights reserved.
//

#import <UIKit/UIKit.h>

@class platformModel;
@interface DetailSectionOneCell : UITableViewCell

@property (strong, nonatomic) UIImageView *headImage;
@property (strong, nonatomic) UILabel *nameLable;
@property (strong, nonatomic) UILabel *activeLable;

@property (strong, nonatomic) UIButton *dayButton;
@property (strong, nonatomic) UIButton *hourButton;
@property (strong, nonatomic) UIButton *mButton;
@property (strong, nonatomic) UIButton *sButton;

- (void)createModel:(platformModel *)model;

@end
