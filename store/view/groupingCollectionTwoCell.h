//
//  groupingCollectionTwoCell.h
//  Distribution
//
//  Created by hchl on 2018/12/27.
//  Copyright © 2018年 hchl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "spellModel.h"
NS_ASSUME_NONNULL_BEGIN
typedef void(^joinGroupBlcok)(spellModel *model);
@interface groupingCollectionTwoCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *headImage;
@property (weak, nonatomic) IBOutlet UILabel *nameLb;
@property (weak, nonatomic) IBOutlet UILabel *mobileLb;
@property (weak, nonatomic) IBOutlet UIButton *joinBtn;
@property (weak, nonatomic) IBOutlet UILabel *poorNumLb;
@property (weak, nonatomic) IBOutlet UILabel *poorTimeLb;
@property (nonatomic, strong) spellModel *spellmodel;
@property (nonatomic, copy) joinGroupBlcok joinBlock;
@property (nonatomic, strong) dispatch_source_t timer;
@end

NS_ASSUME_NONNULL_END
