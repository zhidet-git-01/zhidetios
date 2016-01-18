//
//  JoinUSTableViewCell.m
//  zhidetDemo
//
//  Created by 刘璐璐 on 15/12/23.
//  Copyright © 2015年 刘璐璐. All rights reserved.
//

#import "JoinUSTableViewCell.h"
#import <UIView+SDAutoLayout.h>

#define thisSize 14

@implementation JoinUSTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self createUI];
    }
    return self;
}

- (void)createUI{
    
    UIView *view1 = [[UIView alloc] init];
    view1.backgroundColor = [UIColor whiteColor];
    view1.layer.borderColor = AwayColor.CGColor;
    view1.layer.borderWidth = 1;
    [self.contentView addSubview:view1];
    
#pragma mark ---销售客服---
    UILabel *lable1 = [[UILabel alloc] init];
    lable1.text = @"销售客服";
    lable1.textColor = BackColor;
    [view1 addSubview:lable1];
    lable1.sd_layout
    .topSpaceToView(view1, 10)
    .leftSpaceToView(view1, 10)
    .widthIs(100)
    .heightIs(20);
    
    UILabel *lineLable = [[UILabel alloc] initWithFrame:CGRectMake(10, 40, view1.frame.size.width - 20, 1)];
    lineLable.backgroundColor = AwayColor;
    [view1 addSubview:lineLable];
    lineLable.sd_layout
    .topSpaceToView(lable1, 5)
    .leftSpaceToView(view1, 10)
    .rightSpaceToView(view1, 10)
    .heightIs(1);
    
    UILabel *placeLable = [[UILabel alloc] init];
    placeLable.text = @"工作地点:";
    placeLable.font = [UIFont systemFontOfSize:wordSize];
    [view1 addSubview:placeLable];
    placeLable.sd_layout
    .topSpaceToView(lineLable, 5)
    .leftSpaceToView(view1, 10)
    .widthIs(80)
    .heightIs(20);
    
    UILabel *place = [[UILabel alloc] init];
    place.textColor = wordColor;
    place.text = @"浙江省杭州市江干区民心路万银国际7楼";
    place.font = [UIFont systemFontOfSize:thisSize];
    [view1 addSubview:place];
    place.sd_layout
    .topSpaceToView(placeLable, 5)
    .leftSpaceToView(view1, 10)
    .rightSpaceToView(view1, 10)
    .heightIs(20);
    
    UILabel *workLable = [[UILabel alloc] init];
    workLable.text = @"岗位职责:";
    workLable.font = [UIFont systemFontOfSize:wordSize];
    [view1 addSubview:workLable];
    workLable.sd_layout
    .topSpaceToView(place, 5)
    .leftSpaceToView(view1, 10)
    .widthIs(80)
    .heightIs(20);
    
    UILabel *work = [[UILabel alloc] init];
    work.font = [UIFont systemFontOfSize:thisSize];
    work.textColor = wordColor;
    work.numberOfLines = 0;
    work.text = [NSString stringWithFormat:@"1、负责客户交流群、在线客服QQ、问答；%@2、负责及时向客户传播和推广公司动态和最新平台返利情况，维护新老用户；%@3、通过电话、QQ、微信等渠道不定期对新客户进行回访和关怀；%@4、及时了解公司合作平台以及活动信息；%@5、完成领导安排的其他工作。%@备注：大学实习生亦可参加报名，金融网站的返利平台客服，无经验可培训。%@简历请投至hr@zhidet.com", @"\n", @"\n", @"\n", @"\n", @"\n", @"\n"];
    //设置行间距
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:work.text];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:5];//调整行间距
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [work.text length])];
    work.attributedText = attributedString;
    [work sizeToFit];
    
    //根据文字和字体计算文字高度
    CGSize size = [work.text boundingRectWithSize:CGSizeMake(WIDTH - 40, MAXFLOAT) options:NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:thisSize]} context:nil].size;
    [view1 addSubview:work];
    work.sd_layout
    .topSpaceToView(workLable, 0)
    .leftSpaceToView(view1, 10)
    .widthIs(WIDTH - 40)
    .heightIs(size.height + 50);
    
    view1.sd_layout
    .topSpaceToView(self.contentView, 10)
    .leftSpaceToView(self.contentView, 10)
    .rightSpaceToView(self.contentView, 10)
    .heightIs(lable1.frame.size.height + place.frame.size.height + placeLable.frame.size.height + workLable.frame.size.height + work.frame.size.height + 50);
   
#pragma mark ---产品经理---
    
    UIView *view2 = [[UIView alloc] init];
    view2.backgroundColor = [UIColor whiteColor];
    view2.layer.borderColor = AwayColor.CGColor;
    view2.layer.borderWidth = 1;
    [self.contentView addSubview:view2];
    
    UILabel *lable2 = [[UILabel alloc] init];
    lable2.text = @"产品经理";
    lable2.textColor = BackColor;
    [view2 addSubview:lable2];
    lable2.sd_layout
    .topSpaceToView(view2, 10)
    .leftSpaceToView(view2, 10)
    .widthIs(80)
    .heightIs(20);
    
    UILabel *lineLable2 = [[UILabel alloc] init];
    lineLable2.backgroundColor = AwayColor;
    [view2 addSubview:lineLable2];
    lineLable2.sd_layout
    .topSpaceToView(lable2, 5)
    .leftSpaceToView(view2, 10)
    .rightSpaceToView(view2, 10)
    .heightIs(1);
    
    UILabel *placeLable2 = [[UILabel alloc] init];
    placeLable2.text = @"工作地点:";
    placeLable2.font = [UIFont systemFontOfSize:wordSize];
    [view2 addSubview:placeLable2];
    placeLable2.sd_layout
    .topSpaceToView(lineLable2, 5)
    .leftSpaceToView(view2, 10)
    .widthIs(80)
    .heightIs(20);
    
    UILabel *place2 = [[UILabel alloc] init];
    place2.textColor = wordColor;
    place2.text = @"浙江省杭州市江干区民心路100号万银国际7楼";
    place2.font = [UIFont systemFontOfSize:thisSize];
    [view2 addSubview:place2];
    place2.sd_layout
    .topSpaceToView(placeLable2, 5)
    .leftSpaceToView(view2, 10)
    .rightSpaceToView(view2, 10)
    .heightIs(20);
    
    UILabel *workLable2 = [[UILabel alloc] init];
    workLable2.text = @"岗位职责:";
    workLable2.font = [UIFont systemFontOfSize:wordSize];
    [view2 addSubview:workLable2];
    workLable2.sd_layout
    .topSpaceToView(place2, 5)
    .leftSpaceToView(view2, 10)
    .widthIs(80)
    .heightIs(20);
    
    UILabel *work2 = [[UILabel alloc] init];
    [view2 addSubview:work2];
    work2.font = [UIFont systemFontOfSize:thisSize];
    work2.textColor = wordColor;
    work2.numberOfLines = 0;
    work2.text = [NSString stringWithFormat:@"1、与金融机构对接，利用大数据、互联网进行进行创返利的平台；%@2、根据业务发展，制定产品规划，并持续改善优化产品；%@3、负责金融相关产品调研、运营模式设计、策划运营活动，达成产品目标，并根据行业和市场的动态，发现潜在商业机会；", @"\n", @"\n"];
    //设置行间距
    NSMutableAttributedString *attributedString2 = [[NSMutableAttributedString alloc] initWithString:work2.text];
    NSMutableParagraphStyle *paragraphStyle2 = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle2 setLineSpacing:5];//调整行间距
    [attributedString2 addAttribute:NSParagraphStyleAttributeName value:paragraphStyle2 range:NSMakeRange(0, [work2.text length])];
    work2.attributedText = attributedString2;
    [work2 sizeToFit];
    
    //根据文字和字体计算文字高度
    CGSize size2 = [work.text boundingRectWithSize:CGSizeMake(WIDTH - 40, MAXFLOAT) options:NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:thisSize]} context:nil].size;
    float height1 = size2.height;
    if (WIDTH > 375) {
        height1 = size2.height - 30;
    }
    work2.sd_layout
    .topSpaceToView(workLable2, 0)
    .leftSpaceToView(view2, 10)
    .rightSpaceToView(view2, 10)
    .heightIs(height1);
    
    UILabel *demandLable2 = [[UILabel alloc] init];
    demandLable2.text = @"招聘要求:";
    demandLable2.font = [UIFont systemFontOfSize:wordSize];
    [view2 addSubview:demandLable2];
    demandLable2.sd_layout
    .topSpaceToView(work2, 0)
    .leftSpaceToView(view2, 10)
    .widthIs(80)
    .heightIs(20);
    
    UILabel *demand2 = [[UILabel alloc] init];
    [view2 addSubview:demand2];
    demand2.font = [UIFont systemFontOfSize:thisSize];
    demand2.textColor = wordColor;
    demand2.numberOfLines = 0;
    demand2.text = [NSString stringWithFormat:@"1、学历不限，2年及以上金融类行业相关领域工作经验；%@2、2年以上银行自身客户经验，具有银行、保险、证券基金公司工作经验优先；%@3、熟练应用Office软件、具备较好的项目管理经验及对于大数据的理解；%@4、具备较好的金融专业知识、丰富的资源及良好的业务开拓和沟通表达能力；%@5、具备良好的沟通技能及团队协作意识，一定的分析能力和逻辑思维能力，具有灵活解决问题能力，可在压力下工作。%@简历请投至hr@zhidet.com", @"\n", @"\n", @"\n", @"\n", @"\n"];
    //设置行间距
    NSMutableAttributedString *attributedString22 = [[NSMutableAttributedString alloc] initWithString:demand2.text];
    NSMutableParagraphStyle *paragraphStyle22 = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle22 setLineSpacing:5];//调整行间距
    [attributedString22 addAttribute:NSParagraphStyleAttributeName value:paragraphStyle22 range:NSMakeRange(0, [demand2.text length])];
    demand2.attributedText = attributedString22;
    [demand2 sizeToFit];
    
    //根据文字和字体计算文字高度
    CGSize size22 = [work.text boundingRectWithSize:CGSizeMake(WIDTH - 40, MAXFLOAT) options:NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:thisSize]} context:nil].size;
    float height22 = size22.height + 100;
    if (WIDTH > 375) {
        height22 = size22.height + 50;
    }
    demand2.sd_layout
    .topSpaceToView(demandLable2, 0)
    .leftSpaceToView(view2, 10)
    .rightSpaceToView(view2, 10)
    .heightIs(height22);
    
    view2.sd_layout
    .topSpaceToView(view1, 10)
    .leftSpaceToView(self.contentView, 10)
    .rightSpaceToView(self.contentView, 10)
    .heightIs(lable2.frame.size.height + placeLable2.frame.size.height + place2.frame.size.height + workLable2.frame.size.height + work2.frame.size.height + demandLable2.frame.size.height + demand2.frame.size.height + 50);
    
    _maxY = view1.frame.size.height + view2.frame.size.height + 30;
    
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
