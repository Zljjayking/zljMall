//
//  refundApplyModel.h
//  Distribution
//
//  Created by hchl on 2018/11/28.
//  Copyright © 2018年 hchl. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface refundApplyModel : NSObject
/**
 "id": 23,
 "refundNumber": "201811221721329513",
 "orderDetailId": 44,
 "refundInstructions": "商品问题，不想要了",
 "refundCause": 1,
 "userId": 10,
 "applyTime": "2018-11-22T09:29:21.000+0000",
 "dealState": 1,      //处理状态 1、待处理 2、已同意(待退款) 3、已拒绝 4、已退款 5、已撤销
 "logisticName": null,
 "logisticNo": null,
 "logisticCode": null,
 "tel": null,
 "flag": null,
 "returnMoney": 245.4,
 "goodsState": 1,
 "remark": null,
 "pictureUrl": [
 "/2018-09-28/1/0396448311e54a6bb86694ce8c32a561.png",
 "/2018-09-28/1/0396448311e54a6bb86694ce8c32a561.png"
 ]
 */
@property (nonatomic, copy) NSString *ID;
@property (nonatomic, copy) NSString *refundNumber;
@property (nonatomic, copy) NSString *orderDetailId;
@property (nonatomic, copy) NSString *refundInstructions;
@property (nonatomic, copy) NSString *refundCause;
@property (nonatomic, copy) NSString *userId;
@property (nonatomic, copy) NSString *applyTime;
@property (nonatomic, copy) NSString *dealState;
@property (nonatomic, copy) NSString *logisticName;
@property (nonatomic, copy) NSString *logisticNo;
@property (nonatomic, copy) NSString *logisticCode;
@property (nonatomic, copy) NSString *tel;
@property (nonatomic, copy) NSString *flag;
@property (nonatomic, copy) NSString *returnMoney;
@property (nonatomic, copy) NSString *goodsState;
@property (nonatomic, copy) NSString *remark;
@property (nonatomic, copy) NSArray *pictureUrl;
@property (nonatomic, copy) NSString *logisticsCost;
@end

NS_ASSUME_NONNULL_END
