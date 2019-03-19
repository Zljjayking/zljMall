//
//  logisticsCompanyModel.h
//  Distribution
//
//  Created by hchl on 2018/11/29.
//  Copyright © 2018年 hchl. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface logisticsCompanyModel : NSObject
/**
 "id": 1,
 "typeCode": null,
 "kindCode": 1,
 "describe": "申通",
 "createTime": null,
 "flag": null,
 "logisticCode": "shentong",
 "goodsState": null
 */
@property (nonatomic, copy) NSString *ID;
@property (nonatomic, copy) NSString *typeCode;
@property (nonatomic, copy) NSString *kindCode;
@property (nonatomic, copy) NSString *describe;
@property (nonatomic, copy) NSString *createTime;
@property (nonatomic, copy) NSString *flag;
@property (nonatomic, copy) NSString *logisticCode;
@property (nonatomic, copy) NSString *goodsState;

@end

NS_ASSUME_NONNULL_END
