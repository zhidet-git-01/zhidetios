//
//  CashTableViewCell.m
//  zhidetDemo
//
//  Created by 刘璐璐 on 15/12/16.
//  Copyright © 2015年 刘璐璐. All rights reserved.
//

#import "CashTableViewCell.h"
#import "cashModel.h"

@implementation CashTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        for (int i = 0; i < 3; i++) {
            
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(i * WIDTH / 3, 10, WIDTH / 3, 30)];
            label.font = [UIFont systemFontOfSize:12];
            label.numberOfLines = 0;
            label.textAlignment = NSTextAlignmentCenter;
            [self.contentView addSubview:label];
            label.tag = i + 1;
        }
        
    }
    return self;
}

- (void)createModel:(cashModel *)model{
    
    UILabel *timeLable = (UILabel *)[self.contentView viewWithTag:1];
    UILabel *moneyLable = (UILabel *)[self.contentView viewWithTag:2];
    UILabel *stateLable = (UILabel *)[self.contentView viewWithTag:3];
    
    timeLable.text = model.updattime;
    moneyLable.text = [NSString stringWithFormat:@"%@元", model.trademoney];
    if ([model.status longLongValue] == 3) {
        stateLable.text = @"提现中";
        stateLable.textColor = wordColor;
    }else if ([model.status longLongValue] == 4){
        stateLable.textColor = BackColor;
        stateLable.text = @"提现成功";
    }
    
}


- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
