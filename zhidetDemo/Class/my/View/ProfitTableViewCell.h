//
//  ProfitTableViewCell.h
//  zhidetDemo
//
//  Created by 刘璐璐 on 15/12/16.
//  Copyright © 2015年 刘璐璐. All rights reserved.
//

#import <UIKit/UIKit.h>
@class UserModel;

@interface ProfitTableViewCell : UITableViewCell

- (void)createText:(UserModel *)model;

@end
