//
//  InviteTableViewCell.m
//  zhidetDemo
//
//  Created by 刘璐璐 on 15/12/29.
//  Copyright © 2015年 刘璐璐. All rights reserved.
//

#import "InviteTableViewCell.h"
#import "inviteModel.h"

@implementation InviteTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        for (int i = 0; i < 3; i++) {
            
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(i * WIDTH / 3, 5, WIDTH / 3, 30)];
            label.font = [UIFont systemFontOfSize:13];
            label.numberOfLines = 0;
            label.textAlignment = NSTextAlignmentCenter;
            [self.contentView addSubview:label];
            label.tag = i + 1;
        }
        
    }
    return self;
}

- (void)createLable:(inviteModel *)model{
    
    UILabel *timeLable = (UILabel *)[self.contentView viewWithTag:1];
    UILabel *mobileLable = (UILabel *)[self.contentView viewWithTag:2];
    UILabel *statusLable = (UILabel *)[self.contentView viewWithTag:3];
//    UILabel *remarkLable = (UILabel *)[self.contentView viewWithTag:4];
    
    timeLable.text = model.createttime;
    mobileLable.text = model.mobile;
    if (model.status == 0) {
        statusLable.text = @"未投标";
//        remarkLable.text = @"10元(未激活)";
    }else{
        statusLable.text = @"已投标";
//        remarkLable.text = @"10元";
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
