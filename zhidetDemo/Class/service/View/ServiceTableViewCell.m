//
//  ServiceTableViewCell.m
//  zhidetDemo
//
//  Created by 刘璐璐 on 15/12/15.
//  Copyright © 2015年 刘璐璐. All rights reserved.
//

#import "ServiceTableViewCell.h"
#import "ServiceModel.h"
#import "CustomLable.h"
#import <UIImageView+WebCache.h>
#import <UIView+SDAutoLayout.h>

@implementation ServiceTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        _headImage = [[UIImageView alloc] init];
        _headImage.clipsToBounds = YES;
        _headImage.layer.cornerRadius = 10;
        [self.contentView addSubview:_headImage];
        _headImage.sd_layout
        .leftSpaceToView(self.contentView, 5)
        .topSpaceToView(self.contentView, 10)
        .widthIs(100)
        .heightIs(120);
        
        _nameLable = [[UILabel alloc] init];
        [self.contentView addSubview:_nameLable];
        _nameLable.sd_layout
        .topSpaceToView(self.contentView, 10)
        .leftSpaceToView(_headImage, 10)
        .widthIs(120)
        .heightIs(20);
        
        _phoneLable = [[CustomLable alloc] init];
        _phoneLable.font = [UIFont systemFontOfSize:wordSize];
        _phoneLable.textColor = wordColor;
        [self.contentView addSubview:_phoneLable];
        _phoneLable.sd_layout
        .topSpaceToView(_nameLable, 10)
        .leftSpaceToView(_headImage, 10)
        .widthIs(120)
        .heightIs(20);
        
        _phone = [[UIButton alloc] init];
        [_phone setTitleColor:[UIColor clearColor] forState:UIControlStateNormal];
        [_phone setBackgroundImage:[UIImage imageNamed:@"phone"] forState:UIControlStateNormal];
        [self.contentView addSubview:_phone];
        _phone.sd_layout
        .topSpaceToView(_nameLable, 10)
        .leftSpaceToView(_phoneLable, 10)
        .widthIs(25)
        .heightIs(25);
        
        _qqLable = [[CustomLable alloc] init];
        _qqLable.font = [UIFont systemFontOfSize:wordSize];
        _qqLable.textColor = wordColor;
        [self.contentView addSubview:_qqLable];
        _qqLable.sd_layout
        .topSpaceToView(_phoneLable, 10)
        .leftSpaceToView(_headImage, 10)
        .widthIs(120)
        .heightIs(20);
        
        _qq = [[UIButton alloc] init];
        [_qq setTitleColor:[UIColor clearColor] forState:UIControlStateNormal];
        [_qq setBackgroundImage:[UIImage imageNamed:@"qq"] forState:UIControlStateNormal];
        [self.contentView addSubview:_qq];
        _qq.sd_layout
        .topSpaceToView(_phoneLable, 10)
        .leftSpaceToView(_phoneLable, 10)
        .widthIs(25)
        .heightIs(25);
        
        _wxLable = [[CustomLable alloc] init];
        _wxLable.font = [UIFont systemFontOfSize:wordSize];
        _wxLable.textColor = wordColor;
        [self.contentView addSubview:_wxLable];
        _wxLable.sd_layout
        .topSpaceToView(_qqLable, 10)
        .leftSpaceToView(_headImage, 10)
        .widthIs(120)
        .heightIs(20);
        
        _wx = [[UIButton alloc] init];
        [_wx setTitleColor:[UIColor clearColor] forState:UIControlStateNormal];
        [_wx setBackgroundImage:[UIImage imageNamed:@"wx"] forState:UIControlStateNormal];
        [self.contentView addSubview:_wx];
        _wx.sd_layout
        .topSpaceToView(_qqLable , 10)
        .leftSpaceToView(_wxLable, 10)
        .widthIs(25)
        .heightIs(25);
        
    }
    return self;
}

- (void)awakeFromNib {
    
    _headImage.clipsToBounds = YES;
    _headImage.layer.cornerRadius = 5;
}

- (void)createModel:(ServiceModel *)model{
    
    NSString *urlString = model.headImage;
    NSURL * iconURL = [NSURL URLWithString:urlString];
    UIImage * defaultImage = [UIImage imageNamed:@"loading"];
    [_headImage sd_setImageWithURL:iconURL placeholderImage:defaultImage];
    
    NSURL *tdcUrl = [NSURL URLWithString:model.tdcImage];
    [_tdcimageView sd_setImageWithURL:tdcUrl placeholderImage:defaultImage];
    
    [_qq setTitle:model.qq forState:UIControlStateNormal];
    [_phone setTitle:model.phone forState:UIControlStateNormal];
    [_wx setTitle:model.wx forState:UIControlStateNormal];
    _nameLable.text = [NSString stringWithFormat:@"客服：%@", model.name];
    
    _qqLable.text = model.qq;
    _phoneLable.text = model.phone;
    _wxLable.text = model.wx;

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
