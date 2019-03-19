//
//  groupingHeaderView.m
//  Distribution
//
//  Created by hchl on 2018/12/27.
//  Copyright © 2018年 hchl. All rights reserved.
//

#import "groupingHeaderView.h"
#import "grouperHeaderCollectionCell.h"
@implementation groupingHeaderView
//- (UICollectionView *)grouperCollectionView {
//    if (!_grouperCollectionView) {
//        UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
//        layout.minimumLineSpacing = 0;//y
//        layout.minimumInteritemSpacing = 0;//x
//        UICollectionView *collectionV = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
//        __weak typeof(collectionV) weakCollectionV = collectionV;
//        _grouperCollectionView = weakCollectionV;
//        _grouperCollectionView.delegate = self;
//        _grouperCollectionView.dataSource = self;
//        _grouperCollectionView.showsVerticalScrollIndicator = NO;
//        _grouperCollectionView.showsHorizontalScrollIndicator = NO;
//        [_grouperCollectionView registerNib:[UINib nibWithNibName:@"grouperHeaderCollectionCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"grouperHeaderCollectionCell"];
//    }
//    return _grouperCollectionView;
//}
- (void)awakeFromNib {
    [super awakeFromNib];
    self.goodsNameLB.font = [UIFont boldSystemFontOfSize:15];
    self.timeOneLb.font = [UIFont boldSystemFontOfSize:13];
    self.timeOneLb.layer.masksToBounds = YES;
    self.timeOneLb.layer.cornerRadius = 3;
    self.timeTwoLb.font = [UIFont boldSystemFontOfSize:13];
    self.timeTwoLb.layer.masksToBounds = YES;
    self.timeTwoLb.layer.cornerRadius = 3;
    self.timeThreeLb.font = [UIFont boldSystemFontOfSize:13];
    self.timeThreeLb.layer.masksToBounds = YES;
    self.timeThreeLb.layer.cornerRadius = 3;
    
    self.leftOneLb.font = [UIFont boldSystemFontOfSize:14];
    self.leftTwoLb.font = [UIFont boldSystemFontOfSize:14];
    self.leftTwoLb.textColor = myRed;
    self.leftThreeLb.font = [UIFont boldSystemFontOfSize:14];
    
    self.shareBtn.layer.masksToBounds = YES;
    self.shareBtn.layer.cornerRadius = 20;
    self.shareBtn.layer.borderColor = myRed.CGColor;
    self.shareBtn.layer.borderWidth = 0.7;
    [self.shareBtn setTitleColor:myRed forState:UIControlStateNormal];
    [self.shareBtn setTitleColor:myWhite forState:UIControlStateHighlighted];
    [self.shareBtn setBackgroundImage:[UIImage imageWithColor:myWhite] forState:UIControlStateNormal];
    [self.shareBtn setBackgroundImage:[UIImage imageWithColor:myRed] forState:UIControlStateHighlighted];
    [self.shareBtn addTarget:self action:@selector(shareGroup) forControlEvents:UIControlEventTouchUpInside];
    
    self.grouperCollectionView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self addSubview:self.grouperCollectionView];
    [self.grouperCollectionView registerNib:[UINib nibWithNibName:@"grouperHeaderCollectionCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"grouperHeaderCollectionCell"];
    self.grouperCollectionView.delegate = self;
    self.grouperCollectionView.dataSource = self;

}
- (void)setGroupModel:(groupingModel *)groupModel {
    _groupModel = groupModel;
    [self.grouperCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.timeOneLb.mas_bottom).offset(10);
        make.centerX.equalTo(self.mas_centerX).offset(-5);
        make.width.mas_equalTo(3*64*KAdaptiveRateWidth);
        make.height.mas_equalTo(64*KAdaptiveRateWidth);
    }];
//    NSString *time = @"100";
//    CGFloat width = [time widthWithFont:[UIFont boldSystemFontOfSize:13] constrainedToHeight:20];
//    self.timeOneLb.text = @"100";
    
//    if (width > 20) {
//        [self.timeOneLb mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.width.mas_equalTo(width+5);
//        }];
//    }else {
//        [self.timeOneLb mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.width.mas_equalTo(20);
//        }];
//    }
    
}
- (void)setGrouperArr:(NSArray *)grouperArr {
    _grouperArr = grouperArr;
    if (grouperArr.count) {
        self.grouperCollectionView.hidden = NO;
        [self.grouperCollectionView reloadData];
        self.groupModel = grouperArr[0];
        CGFloat collectionVWidth = grouperArr.count*64*KAdaptiveRateWidth;
        if (collectionVWidth >= kScreenWidth) {
            collectionVWidth = kScreenWidth - 26;
        }
        [self.spellHeaderImageV sd_setImageWithURL:[NSURL URLWithString:[imageHost stringByAppendingString:self.groupModel.portrait]] placeholderImage:[UIImage imageNamed:@"user_info_default"]];
        self.spellHeaderNameLb.text = self.groupModel.userName;
        self.mobileLb.text = self.groupModel.phone;
        if (self.groupModel.phone.length == 11) {
            self.mobileLb.text = [self.groupModel.phone stringByReplacingCharactersInRange:NSMakeRange(3, 4) withString:@"****"];
        }
        if (self.isGrouped) {
            self.leftOneLb.hidden = YES;
            self.leftTwoLb.hidden = YES;
            self.leftThreeLb.hidden = YES;
//            self.leftFourLb.hidden = YES;
            self.timeOneLb.hidden = YES;
            self.timeTwoLb.hidden = YES;
            self.timeThreeLb.hidden = YES;
            self.hourLb.hidden = YES;
            self.minuteLb.hidden = YES;
            self.stateLb.text = @"拼团完成";
            self.leftFourLb.text = @"拼团成功啦,宝贝正在飞奔而来～";
            self.shareBtn.hidden = YES;
            [self.grouperCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.goodsView.mas_bottom).offset(37);
                make.centerX.equalTo(self.mas_centerX).offset(-5);
                make.width.mas_equalTo(collectionVWidth);
                make.height.mas_equalTo(64*KAdaptiveRateWidth);
            }];
        }else {
            self.leftTwoLb.text = [NSString stringWithFormat:@"%ld",[self.groupModel.cloudsNumber integerValue]-[self.groupModel.actNumber integerValue]];
            [self.grouperCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.timeOneLb.mas_bottom).offset(10);
                make.centerX.equalTo(self.mas_centerX).offset(-5);
                make.width.mas_equalTo(collectionVWidth);
                make.height.mas_equalTo(64*KAdaptiveRateWidth);
            }];
            dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
            self.timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
            // 每秒执行一次
            dispatch_source_set_timer(self.timer, dispatch_walltime(NULL, 0), 1 * NSEC_PER_SEC, 0);
            dispatch_source_set_event_handler(self.timer, ^{
                long long time = [self.groupModel.countdownTime longLongValue] - ([[NSDate date] timeIntervalSince1970]*1000);
                if (time >= 0) {
                    long long second = (time/1000);
                    int h = (int)second/3600;//时
                    int m = (int)(second%3600)/60;//分
                    int s = (int)second%60;//秒
                    //                int ms = (int)(time - second*1000)/100;//毫秒取百位
                    dispatch_async(dispatch_get_main_queue(), ^{
                        NSString *hourStr = [NSString stringWithFormat:@"%02d",h];
                        CGFloat width = [hourStr widthWithFont:[UIFont boldSystemFontOfSize:13] constrainedToHeight:20];
                        self.timeOneLb.text = hourStr;
                        
                        if (width > 20) {
                            [self.timeOneLb mas_makeConstraints:^(MASConstraintMaker *make) {
                                make.width.mas_equalTo(width+5);
                            }];
                        }else {
                            [self.timeOneLb mas_makeConstraints:^(MASConstraintMaker *make) {
                                make.width.mas_equalTo(20);
                            }];
                        }
                        self.timeTwoLb.text = [NSString stringWithFormat:@"%02d",m];
                        self.timeThreeLb.text = [NSString stringWithFormat:@"%02d",s];
                    });
                }else {
                    dispatch_source_cancel(self.timer);
                    dispatch_async(dispatch_get_main_queue(), ^{
                        self.leftFourLb.text = @"该拼团已失效";
                    });
                }
                
            });
            dispatch_resume(self.timer);
        }
    }else {
        self.grouperCollectionView.hidden = YES;
    }
}
- (void)setGoodsModel:(shoppingCartModel *)goodsModel {
    _goodsModel = goodsModel;
    [self.spellGoodsImage sd_setImageWithURL:[NSURL URLWithString:[imageHost stringByAppendingString:goodsModel.goodsPreview]] placeholderImage:[UIImage imageNamed:@"goods"]];
    self.goodsNameLB.text = goodsModel.goodsName;
    self.groupPriceLb.text = [NSString stringWithFormat:@"¥%.2f",[goodsModel.groupingPrice doubleValue]];
    self.originalPriceLb.text = [NSString stringWithFormat:@"%.2f",[goodsModel.goodsPrice doubleValue]];
    self.groupNumLb.text = goodsModel.groupingGoodsNum;
}
- (void)setIsGrouped:(BOOL)isGrouped {
    _isGrouped = isGrouped;
}
- (NSInteger) collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.grouperArr.count;
}
- (UICollectionViewCell *) collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    grouperHeaderCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"grouperHeaderCollectionCell" forIndexPath:indexPath];
    cell.groupModel = self.grouperArr[indexPath.item];
    return cell;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(64*KAdaptiveRateWidth, 64*KAdaptiveRateWidth);
}
#pragma mark - X间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}
#pragma mark - Y间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}
- (void)dealloc {
    dispatch_source_cancel(self.timer);
}
- (void)shareGroup {
    if (self.shareBlock) {
        self.shareBlock(self.goodsModel);
    }
}
@end
