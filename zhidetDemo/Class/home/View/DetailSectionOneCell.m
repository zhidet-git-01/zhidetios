//
//  DetailSectionOneCell.m
//  zhidetDemo
//
//  Created by 刘璐璐 on 15/12/7.
//  Copyright © 2015年 刘璐璐. All rights reserved.
//

#import "DetailSectionOneCell.h"
#import "platformModel.h"
#import "UIImageView+WebCache.h"
#import <UIView+SDAutoLayout.h>

@implementation DetailSectionOneCell
{
    NSTimer *_timer;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        _headImage = [[UIImageView alloc] init];
        _headImage.clipsToBounds = YES;
        _headImage.layer.cornerRadius = 10;
        [self.contentView addSubview:_headImage];
        _headImage.sd_layout
        .leftSpaceToView(self.contentView, 10)
        .topSpaceToView(self.contentView, 20)
        .widthIs(120)
        .heightIs(50);
        
        
        _nameLable = [[UILabel alloc] initWithFrame:CGRectMake(130, 20, WIDTH - 140, 20)];
        [self.contentView addSubview:_nameLable];
        _nameLable.sd_layout
        .topSpaceToView(self.contentView, 20)
        .leftSpaceToView(_headImage, 10)
        .rightSpaceToView(self.contentView, 10)
        .heightIs(20);
        
        _activeLable = [[UILabel alloc] init];
        _activeLable.font = [UIFont systemFontOfSize:13];
        _activeLable.numberOfLines = 0;
        _activeLable.textColor = BidColor;
        [self.contentView addSubview:_activeLable];
        _activeLable.sd_layout
        .topSpaceToView(_nameLable, 5)
        .leftSpaceToView(_headImage, 10)
        .rightSpaceToView(self.contentView, 10)
        .heightIs(40);
        
        
        _headImage.clipsToBounds = YES;
        _headImage.layer.cornerRadius = 10;

        
    }
    return self;
}

- (void)awakeFromNib {
    // Initialization code
    
}

- (void)createTime{
    
    _dayButton.clipsToBounds = YES;
    _dayButton.layer.cornerRadius = 4;
    
    _hourButton.clipsToBounds = YES;
    _hourButton.layer.cornerRadius = 4;
    
    _mButton.clipsToBounds = YES;
    _mButton.layer.cornerRadius = 4;
    
    _sButton.clipsToBounds = YES;
    _sButton.layer.cornerRadius = 4;
    
    _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(changeTime) userInfo:nil repeats:YES];

}

- (void)changeTime{

    NSInteger s = [_sButton.titleLabel.text integerValue];
    if (s == 0 ) {
        
        [_sButton setTitle:[NSString stringWithFormat:@"%d", 59] forState:UIControlStateNormal];
        NSInteger m = [_mButton.titleLabel.text integerValue];
        
        
        if (m == 0) {
            [_mButton setTitle:[NSString stringWithFormat:@"%ld", (long)--m] forState:UIControlStateNormal];
            NSInteger h = [_hourButton.titleLabel.text integerValue];
            if (h == 0) {
               [_mButton setTitle:[NSString stringWithFormat:@"%d", 59] forState:UIControlStateNormal];
                NSInteger day = [_dayButton.titleLabel.text integerValue];
                if (day == 0) {
                    
                }else{
                    [_hourButton setTitle:[NSString stringWithFormat:@"%ld", (long)--day] forState:UIControlStateNormal];
                }
            }else{
                [_hourButton setTitle:[NSString stringWithFormat:@"%ld", (long)--h] forState:UIControlStateNormal];
            }
        }else{
            
            [_mButton setTitle:[NSString stringWithFormat:@"%ld", (long)--m] forState:UIControlStateNormal];
        }
    }else{
        
        [_sButton setTitle:[NSString stringWithFormat:@"%ld", (long)--s] forState:UIControlStateNormal];
    }
}

- (void)createModel:(platformModel *)model{
    
    NSString *urlString = [NSString stringWithFormat:@"http://service.zhidet.com/images/%@", model.logolittler];
    NSURL * iconURL = [NSURL URLWithString:urlString];
    UIImage * defaultImage = [UIImage imageNamed:@"loading"];
    [_headImage sd_setImageWithURL:iconURL placeholderImage:defaultImage];
    
    _nameLable.text = model.title;
    _activeLable.text = model.activity;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
