//
//  groupingModel.h
//  Distribution
//
//  Created by hchl on 2018/12/28.
//  Copyright © 2018年 hchl. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface groupingModel : NSObject
/**
 groupId 团id
 isHead 是否团长1-是 0-否
 payState 付款状态 1-已付款0-未付款
 phone 手机号
 userName 用户名
 portrait 头像
 countdownTime 成团截止时间
 actNumber 团内现有人数
 cloudsNumber 成团人数
 status 拼团状态 1：拼团中 2：成功（正常情况） 3：帮团成功 0：失败
 successTime 拼成时间
 grade 会员等级
 userType 用户类型2:VIP_NAME 1:DEFAULT_NAME;
 userGrade 5:子账号;4:管理员;3:省代;2:市代;1区代;0:用户
 
 
 "userId": 10,
 "goodsId": 51,
 "goodsStandardId": null,
 "groupId": 4,
 "orderDetailId": 178,
 
 "orderId": 117,
 "createTime": "2018-12-29T09:19:46.000+0000",
 "isHead": 0,
 "groupPrice": 33,
 "payState": 0,
 
 "phone": "17625957141",
 "userName": "xxx",
 "portrait": null,
 "countdownTime": 1546074557254,
 "actNumber": 3,
 
 "cloudsNumber": 33,
 "status": 1,
 "successTime": null,
 "grade": 6,
 "userType": 1,
 
 "userGrade": 0
 */
@property (nonatomic, copy) NSString *userId;
@property (nonatomic, copy) NSString *goodsId;
@property (nonatomic, copy) NSString *goodsStandardId;
@property (nonatomic, copy) NSString *groupId;
@property (nonatomic, copy) NSString *orderDetailId;

@property (nonatomic, copy) NSString *orderId;
@property (nonatomic, copy) NSString *createTime;
@property (nonatomic, copy) NSString *isHead;
@property (nonatomic, copy) NSString *groupPrice;
@property (nonatomic, copy) NSString *payState;

@property (nonatomic, copy) NSString *phone;
@property (nonatomic, copy) NSString *userName;
@property (nonatomic, copy) NSString *portrait;
@property (nonatomic, copy) NSString *countdownTime;
@property (nonatomic, copy) NSString *actNumber;

@property (nonatomic, copy) NSString *cloudsNumber;
@property (nonatomic, copy) NSString *status;
@property (nonatomic, copy) NSString *successTime;
@property (nonatomic, copy) NSString *grade;
@property (nonatomic, copy) NSString *userType;
@property (nonatomic, copy) NSString *userGrade;
@end

NS_ASSUME_NONNULL_END
