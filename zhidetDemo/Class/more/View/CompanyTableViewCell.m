//
//  CompanyTableViewCell.m
//  zhidetDemo
//
//  Created by 刘璐璐 on 15/12/23.
//  Copyright © 2015年 刘璐璐. All rights reserved.
//

#import "CompanyTableViewCell.h"
#import <UIView+SDAutoLayout.h>

@implementation CompanyTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
//        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(WIDTH / 2 - 80, 20, 160, 60)];
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.image = [UIImage imageNamed:@"zhidetImage"];
        [self.contentView addSubview:imageView];
        imageView.sd_layout
        .topSpaceToView(self.contentView,20)
        .centerXEqualToView(self.contentView)
        .heightIs(60)
        .widthIs(160);
        
        UILabel *lineLable = [[UILabel alloc] init];
        lineLable.backgroundColor = AwayColor;
        [self.contentView addSubview:lineLable];
        lineLable.sd_layout
        .topSpaceToView(imageView,15)
        .leftSpaceToView(self.contentView, 10)
        .rightSpaceToView(self.contentView, 10)
        .heightIs(1);
        
        UILabel *contentLable = [[UILabel alloc] init];
        contentLable.text = @"   杭州砂岩网络科技有限公司（值得投）是一家中国首创的P2P分类导航返利平台。当用户通过平台的链接去对应的P2P平台进行投资时，平台会为用户的订单支付给值得投一笔营销费用，值得投把这笔费用的大部分以返利的形式返还给用户，为用户真正意义上实现一次投资，两份收益。";
        contentLable.numberOfLines = 0;
        //根据文字和字体计算文字高度
        CGSize size = [contentLable.text boundingRectWithSize:CGSizeMake(WIDTH - 40, MAXFLOAT) options:NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:wordSize]} context:nil].size;
        contentLable.font = [UIFont systemFontOfSize:wordSize];
        [self.contentView addSubview:contentLable];
        contentLable.sd_layout
        .topSpaceToView(lineLable,15)
        .leftSpaceToView(self.contentView, 10)
        .rightSpaceToView(self.contentView, 10)
        .heightIs(size.height);
        
        UILabel *zdtLable = [[UILabel alloc] init];
        zdtLable.text = @"值得投，一个供用户选择适合自己投资渠道的分类信息返利平台。值得投，互联网金融行为习惯引领者。";
        zdtLable.numberOfLines = 0;
        zdtLable.font = [UIFont systemFontOfSize:wordSize];
        zdtLable.textColor = BackColor;
        [self.contentView addSubview:zdtLable];
        zdtLable.sd_layout
        .topSpaceToView(contentLable,5)
        .leftSpaceToView(self.contentView, 10)
        .rightSpaceToView(self.contentView, 10)
        .heightIs(60);
        
        UIImageView *imageV1 = [[UIImageView alloc] init];
        imageV1.image = [UIImage imageNamed:@"company1"];
        [self.contentView addSubview:imageV1];
        imageV1.sd_layout
        .topSpaceToView(zdtLable,10)
        .leftSpaceToView(self.contentView, 10)
        .rightSpaceToView(self.contentView, 10)
        .heightIs((WIDTH - 20) * 0.5375);
        
        UIImageView *imageV2 = [[UIImageView alloc] init];
        imageV2.image = [UIImage imageNamed:@"company1"];
        [self.contentView addSubview:imageV2];
        imageV2.sd_layout
        .topSpaceToView(imageV1,10)
        .leftSpaceToView(self.contentView, 10)
        .rightSpaceToView(self.contentView, 10)
        .heightIs((WIDTH - 20) * 0.5375);
        
        _maxY = imageV2.frame.size.height + imageV1.frame.size.height + zdtLable.frame.size.height + contentLable.frame.size.height + imageView.frame.size.height + 90;
        NSLog(@"%f", _maxY);
        
    }
    
    return self;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
