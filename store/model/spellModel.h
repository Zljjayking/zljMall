//
//  spellModel.h
//  Distribution
//
//  Created by hchl on 2018/12/27.
//  Copyright © 2018年 hchl. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface spellModel : NSObject
/**
 ptgId 拼团组ID
 tel 团长手机号
 username 团长昵称
 portrait 团长头像
 lackNum 差几人成团
 actNum 实际参团的人数
 countdownTime 当前团截止时间,毫秒值
 */
@property (nonatomic, copy) NSString *ptgId;
@property (nonatomic, copy) NSString *tel;
@property (nonatomic, copy) NSString *username;
@property (nonatomic, copy) NSString *portrait;
@property (nonatomic, copy) NSString *lackNum;
@property (nonatomic, copy) NSString *actNum;
@property (nonatomic, copy) NSString *countdownTime;
@end

NS_ASSUME_NONNULL_END
