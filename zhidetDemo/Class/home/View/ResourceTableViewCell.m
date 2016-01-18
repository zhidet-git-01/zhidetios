//
//  ResourceTableViewCell.m
//  zhidetDemo
//
//  Created by 刘璐璐 on 15/12/7.
//  Copyright © 2015年 刘璐璐. All rights reserved.
//

#import "ResourceTableViewCell.h"
#import "platformModel.h"
#import <UIImageView+WebCache.h>

@implementation ResourceTableViewCell


- (void)awakeFromNib {
    
    //设置button的圆角
    _getMoneyButton.clipsToBounds = YES;
    _getMoneyButton.layer.cornerRadius = 23;
    
    //设置view的边框
    _underView.layer.borderWidth = 1;
    _underView.layer.borderColor = AwayColor.CGColor;
    
    
}

- (void)createModel:(platformModel *)model{
    
    _platform = model;
    //判断投标是否结束
    if (model.status == 0) {
        
        _getMoneyButton.backgroundColor = BackColor;
        [_getMoneyButton setTitle:@"马上去赚钱" forState:UIControlStateNormal];
        [_getMoneyButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_getMoneyButton addTarget:self action:@selector(getMoney:) forControlEvents:UIControlEventTouchUpInside];
        
        NSString *urlString = [NSString stringWithFormat:@"http://service.zhidet.com/images/%@", model.logolittler];
        NSURL * iconURL = [NSURL URLWithString:urlString];
        UIImage * defaultImage = [UIImage imageNamed:@"loading"];
        [_headImage sd_setImageWithURL:iconURL placeholderImage:defaultImage];
        
        _lable1.textColor = BackColor;
        _lable2.textColor = BackColor;
        _lable3.textColor = BackColor;
        _minLable.textColor = BackColor;
        _maxLable.textColor = BackColor;
        _priceLable.textColor = BidColor;
        
        
    }else{
        
        _getMoneyButton.backgroundColor = AwayColor;
        [_getMoneyButton setTitle:@"投标已结束" forState:UIControlStateNormal];
        [_getMoneyButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [_getMoneyButton addTarget:self action:@selector(getMoney:) forControlEvents:UIControlEventTouchUpInside];
        
        _lable1.textColor = [UIColor grayColor];
        _lable2.textColor = [UIColor grayColor];
        _lable3.textColor = [UIColor grayColor];
        _minLable.textColor = [UIColor grayColor];
        _maxLable.textColor = [UIColor grayColor];
        _priceLable.textColor = [UIColor grayColor];
        
        //得到全局队列
        dispatch_queue_t globalQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        NSString *urlString = [NSString stringWithFormat:@"http://service.zhidet.com/images/%@", model.logolittler];
        
        dispatch_async(globalQueue, ^{
            @autoreleasepool {
                NSURL *url = [NSURL URLWithString:urlString];
                    //同步下载
                NSData *data = [NSData dataWithContentsOfURL:url];
                    //sync同步更新  async异步更新
                dispatch_async(dispatch_get_main_queue(), ^{
                        //更新图片
                    _headImage.image = [UIImage imageWithData:data];
                    _headImage.image = [self grayImage:_headImage.image];
                });
            }
                
        });
    }


    _maxLable.text = model.max;
    _minLable.text = model.min;
    _priceLable.text = [NSString stringWithFormat:@"%@元", model.price];
}

- (void)getMoney:(UIButton *)sender{
    
    //发送通知
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    NSDictionary *dict = @{@"canBid":_platform};
    [nc postNotificationName:@"canBid" object:self userInfo:dict];
 
    
}


-(UIImage *)grayImage:(UIImage *)sourceImage
{
    int bitmapInfo = kCGImageAlphaNone;
    int width = sourceImage.size.width;
    int height = sourceImage.size.height;
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceGray();
    CGContextRef context = CGBitmapContextCreate (nil,
                                                  width,
                                                  height,
                                                  8,      // bits per component
                                                  0,
                                                  colorSpace,
                                                  bitmapInfo);
    CGColorSpaceRelease(colorSpace);
    if (context == NULL) {
        return nil;
    }
    CGContextDrawImage(context,CGRectMake(0, 0, width, height), sourceImage.CGImage);
    UIImage *grayImage = [UIImage imageWithCGImage:CGBitmapContextCreateImage(context)];
    CGContextRelease(context);
    return grayImage;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
