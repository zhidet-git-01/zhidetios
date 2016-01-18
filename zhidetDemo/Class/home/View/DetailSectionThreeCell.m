//
//  DetailSectionThreeCell.m
//  zhidetDemo
//
//  Created by 刘璐璐 on 15/12/7.
//  Copyright © 2015年 刘璐璐. All rights reserved.
//

#import "DetailSectionThreeCell.h"
#import "platformModel.h"
#import <UIView+SDAutoLayout.h>

@implementation DetailSectionThreeCell
{
    UILabel *introduce;
}

- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        UILabel *titleLable = [[UILabel alloc] init];
        titleLable.text = @"平台信息";
        titleLable.font = [UIFont systemFontOfSize:18];
        [self.contentView addSubview:titleLable];
        titleLable.sd_layout
        .topSpaceToView(self.contentView, 5)
        .leftSpaceToView(self.contentView, 10)
        .widthIs(100)
        .heightIs(30);
        
        //线
        UILabel *lineLable = [[UILabel alloc] init];
        lineLable.backgroundColor = AwayColor;
        [self.contentView addSubview:lineLable];
        lineLable.sd_layout
        .topSpaceToView(titleLable, 5)
        .leftSpaceToView(self.contentView, 0)
        .rightSpaceToView(self.contentView, 0)
        .heightIs(1);
        
        //固定lable
        NSArray *array = @[@"平台名称:",@"上线时间:",@"年化收益:",@"注册资金:",@"平台背景:",@"推荐理由:"];
        for (int i = 0; i < 6; i++) {
            
            UILabel *lable = [[UILabel alloc] init];
            lable.text = array[i];
            lable.font = [UIFont systemFontOfSize:wordSize];
            [self.contentView addSubview:lable];
            lable.sd_layout
            .topSpaceToView(lineLable, i * 25 + 5)
            .leftSpaceToView(self.contentView, 10)
            .widthIs(80)
            .heightIs(20);
        }
        
        //平台名称
        _nameLable = [[UILabel alloc] init];
        _nameLable.font = [UIFont systemFontOfSize:wordSize];
        [self.contentView addSubview:_nameLable];
        _nameLable.sd_layout
        .topSpaceToView(lineLable, 5)
        .leftSpaceToView(self.contentView, 90)
        .rightSpaceToView(self.contentView, 10)
        .heightIs(20);
        
        //上线时间
        _timeLable = [[UILabel alloc] init];
        _timeLable.font = [UIFont systemFontOfSize:wordSize];
        [self.contentView addSubview:_timeLable];
        _timeLable.sd_layout
        .topSpaceToView(_nameLable, 5)
        .leftSpaceToView(self.contentView, 90)
        .rightSpaceToView(self.contentView , 10)
        .heightIs(20);
        
        //年化收益
        _profitLable = [[UILabel alloc] init];
        _profitLable.font = [UIFont systemFontOfSize:wordSize];
        [self.contentView addSubview:_profitLable];
        _profitLable.sd_layout
        .topSpaceToView(_timeLable, 5)
        .leftSpaceToView(self.contentView, 90)
        .rightSpaceToView(self.contentView, 10)
        .heightIs(20);
        
        //注册资金
        _moneyLable = [[UILabel alloc] init];
        _moneyLable.font = [UIFont systemFontOfSize:wordSize];
        [self.contentView addSubview:_moneyLable];
        _moneyLable.sd_layout
        .topSpaceToView(_profitLable, 5)
        .leftSpaceToView(self.contentView, 90)
        .rightSpaceToView(self.contentView, 10)
        .heightIs(20);
        
        //平台背景
        _backLable = [[UILabel alloc] init];
        _backLable.font = [UIFont systemFontOfSize:wordSize];
        [self.contentView addSubview:_backLable];
        _backLable.sd_layout
        .topSpaceToView(_moneyLable, 5)
        .leftSpaceToView(self.contentView, 90)
        .rightSpaceToView(self.contentView, 10)
        .heightIs(20);
        
    }
    return self;
}

- (void)createText:(platformModel *)model{
    
    [_resonLable removeFromSuperview];
    [_introduceLable removeFromSuperview];
    [introduce removeFromSuperview];
    
    _nameLable.text = model.title;
    _timeLable.text = model.starttime;
    _profitLable.text = [NSString stringWithFormat:@"%@％ ~ %@％", model.min, model.max];
    _moneyLable.text = model.regfound;
    _backLable.text = model.companyBack;
    
    //推荐理由 高度自适应
    _resonLable = [[UILabel alloc] init];
    _resonLable.text = model.recommendreason;
    _resonLable.numberOfLines = 0;
    _resonLable.font = [UIFont systemFontOfSize:wordSize];
    //根据文字和字体计算文字高度
    CGSize size = [_resonLable.text boundingRectWithSize:CGSizeMake(WIDTH - 100, MAXFLOAT) options:NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:wordSize]} context:nil].size;
    [self.contentView addSubview:_resonLable];
    _resonLable.sd_layout
    .topSpaceToView(_backLable, 5)
    .leftSpaceToView(self.contentView, 90)
    .rightSpaceToView(self.contentView, 10)
    .heightIs(size.height);
    
    
    //固定lable
    introduce = [[UILabel alloc] init];
    introduce.text = @"平台介绍:";
    introduce.font = [UIFont systemFontOfSize:wordSize];
    [self.contentView addSubview:introduce];
    introduce.sd_layout
    .topSpaceToView(_resonLable, 5)
    .leftSpaceToView(self.contentView, 10)
    .widthIs(80)
    .heightIs(20);
    
    //平台介绍高度自适应
    _introduceLable = [[UILabel alloc] init];
    _introduceLable.text = model.info;
    _introduceLable.numberOfLines = 0;
    _introduceLable.font = [UIFont systemFontOfSize:wordSize];
    CGSize introduceSize = [_introduceLable.text boundingRectWithSize:CGSizeMake(WIDTH - 100, MAXFLOAT) options:NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:wordSize]} context:nil].size;
    [self.contentView addSubview:_introduceLable];
    _introduceLable.sd_layout
    .topSpaceToView(_resonLable, 5)
    .leftSpaceToView(self.contentView, 90)
    .rightSpaceToView(self.contentView, 10)
    .heightIs(introduceSize.height);
    
    _maxY = _introduceLable.frame.size.height + _resonLable.frame.size.height + _nameLable.frame.size.height + _backLable.frame.size.height + _moneyLable.frame.size.height + _profitLable.frame.size.height + _timeLable.frame.size.height + 80;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
