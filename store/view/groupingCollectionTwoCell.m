//
//  groupingCollectionTwoCell.m
//  Distribution
//
//  Created by hchl on 2018/12/27.
//  Copyright © 2018年 hchl. All rights reserved.
//

#import "groupingCollectionTwoCell.h"

@implementation groupingCollectionTwoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.headImage.layer.cornerRadius = 16.5;
    self.joinBtn.layer.masksToBounds = YES;
    self.joinBtn.layer.cornerRadius = 12;
    [self.joinBtn setBackgroundColor:myRed];
    [self.joinBtn addTarget:self action:@selector(joinGroupClick) forControlEvents:UIControlEventTouchUpInside];
}
- (void)setSpellmodel:(spellModel *)spellmodel {
    _spellmodel = spellmodel;
    NSString *haedUrl = [imageHost stringByAppendingString:spellmodel.portrait];
    [self.headImage sd_setImageWithURL:[NSURL URLWithString:haedUrl] placeholderImage:[UIImage imageNamed:@"user_info_default"]];
    self.nameLb.text = spellmodel.username;
    if (spellmodel.tel.length == 11) {
        self.mobileLb.text = [spellmodel.tel stringByReplacingCharactersInRange:NSMakeRange(3, 4) withString:@"****"];
    }else {
        self.mobileLb.text = spellmodel.tel;
    }
    NSString *poorNumStr = [NSString stringWithFormat:@"还差%@人拼成",spellmodel.lackNum];
    NSMutableAttributedString *attributStr = [[NSMutableAttributedString alloc] initWithString:poorNumStr];
    [attributStr addAttributes:@{NSForegroundColorAttributeName:myRed} range:NSMakeRange(2, spellmodel.lackNum.length+1)];
    self.poorNumLb.attributedText = attributStr;
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    self.timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    // 每秒执行一次
    WEAKSELF
    dispatch_source_set_timer(self.timer, dispatch_walltime(NULL, 0), 0.1 * NSEC_PER_SEC, 0);
    dispatch_source_set_event_handler(self.timer, ^{
        long long time = [spellmodel.countdownTime longLongValue] - ([[NSDate date] timeIntervalSince1970]*1000);
        if (time >= 0) {
            long long second = (time/1000);
            int h = (int)second/3600;//时
            int m = (int)(second%3600)/60;//分
            int s = (int)second%60;//秒
            int ms = (int)(time - second*1000)/100;//毫秒取百位
            dispatch_async(dispatch_get_main_queue(), ^{
                weakSelf.poorTimeLb.text = [NSString stringWithFormat:@"剩余%02d:%02d:%02d.%d",h,m,s,ms];
            });
        }else {
            dispatch_source_cancel(self.timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                weakSelf.poorTimeLb.text = @"该拼团已失效";
            });
        }
        
    });
    dispatch_resume(self.timer);
}
- (void)joinGroupClick {
    if (self.joinBlock) {
        self.joinBlock(self.spellmodel);
    }
}
- (void)dealloc {
    dispatch_source_cancel(self.timer);
    NSLog(@"self.timer停止了");
}
@end
