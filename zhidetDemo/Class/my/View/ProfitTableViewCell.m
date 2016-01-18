//
//  ProfitTableViewCell.m
//  zhidetDemo
//
//  Created by 刘璐璐 on 15/12/16.
//  Copyright © 2015年 刘璐璐. All rights reserved.
//

#import "ProfitTableViewCell.h"
#import "UserModel.h"
#import <UIImageView+WebCache.h>

#define minSize 12

@implementation ProfitTableViewCell
{
    UIImageView *_headImage;
    UILabel *_titleLable;
    UILabel *_userLable;
    UILabel *_stateLable;
    UILabel *_timeLable;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        _headImage = [[UIImageView alloc] initWithFrame:CGRectMake(5, 30, 90, 40)];
//        _headImage.clipsToBounds = YES;
//        _headImage.layer.cornerRadius = 40;
        [self.contentView addSubview:_headImage];
        
        _titleLable = [[UILabel alloc] initWithFrame:CGRectMake(100, 10, WIDTH - 100, 20)];
        _titleLable.font = [UIFont systemFontOfSize:wordSize];
        [self.contentView addSubview:_titleLable];
        
        _userLable = [[UILabel alloc] initWithFrame:CGRectMake(100, 35, WIDTH - 100, 15)];
        _userLable.font = [UIFont systemFontOfSize:minSize];
        _userLable.textColor = [UIColor grayColor];
        [self.contentView addSubview:_userLable];
        
        _stateLable = [[UILabel alloc] initWithFrame:CGRectMake(100, 55, WIDTH - 100, 15)];
        _stateLable.font = [UIFont systemFontOfSize:minSize];
        _stateLable.textColor = [UIColor grayColor];
        [self.contentView addSubview:_stateLable];
        
        _timeLable = [[UILabel alloc] initWithFrame:CGRectMake(100, 75, WIDTH - 100, 15)];
        _timeLable.font = [UIFont systemFontOfSize:minSize];
        _timeLable.textColor = [UIColor grayColor];
        [self.contentView addSubview:_timeLable];
    }
    return self;
}

- (void)createText:(UserModel *)model{
 
    NSString *urlString = [NSString stringWithFormat:@"http://service.zhidet.com/images/%@", model.headImage];
    NSURL * iconURL = [NSURL URLWithString:urlString];
    UIImage * defaultImage = [UIImage imageNamed:@"loading"];
    [_headImage sd_setImageWithURL:iconURL placeholderImage:defaultImage];
    
    _titleLable.text = [NSString stringWithFormat:@"%@ %@", model.companyTitle, model.companybg];
    _userLable.text = [NSString stringWithFormat:@"投资账号：%@", model.phone];
    _stateLable.text = [NSString stringWithFormat:@"已返利：%@元", model.returnMoney];
    _stateLable.textColor = BackColor;
    _timeLable.text = [NSString stringWithFormat:@"投标时间：%@", model.creattime];
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
