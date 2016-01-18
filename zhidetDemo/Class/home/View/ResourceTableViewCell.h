//
//  ResourceTableViewCell.h
//  zhidetDemo
//
//  Created by 刘璐璐 on 15/12/7.
//  Copyright © 2015年 刘璐璐. All rights reserved.
//

#import <UIKit/UIKit.h>
@class platformModel;

@interface ResourceTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *minLable;
@property (weak, nonatomic) IBOutlet UILabel *maxLable;
@property (weak, nonatomic) IBOutlet UILabel *priceLable;
@property (weak, nonatomic) IBOutlet UIButton *getMoneyButton;
@property (weak, nonatomic) IBOutlet UIView *underView;
@property (weak, nonatomic) IBOutlet UIImageView *lefttopImage;
@property (weak, nonatomic) IBOutlet UIImageView *headImage;
@property (weak, nonatomic) IBOutlet UILabel *lable1;
@property (weak, nonatomic) IBOutlet UILabel *lable2;
@property (weak, nonatomic) IBOutlet UILabel *lable3;


@property platformModel *platform;

- (void)createModel:(platformModel *)model;

@end
