//
//  ServiceTableViewCell.h
//  zhidetDemo
//
//  Created by 刘璐璐 on 15/12/15.
//  Copyright © 2015年 刘璐璐. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomLable.h"
@class ServiceModel;

@interface ServiceTableViewCell : UITableViewCell

@property (strong, nonatomic)UIImageView *headImage;
@property (strong, nonatomic)UILabel *nameLable;
@property (strong, nonatomic)UIButton *phone;
@property (strong, nonatomic)UIButton *qq;
@property (strong, nonatomic)UIButton *wx;
@property (strong, nonatomic)CustomLable *phoneLable;
@property (strong, nonatomic)CustomLable *qqLable;
@property (strong, nonatomic)CustomLable *wxLable;
@property (strong, nonatomic)UIImageView *tdcimageView;

- (void)createModel:(ServiceModel *)model;

@end
