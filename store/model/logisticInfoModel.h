//
//  logisticInfoModel.h
//  Distribution
//
//  Created by hchl on 2018/8/28.
//  Copyright © 2018年 hchl. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface logisticInfoModel : NSObject
/**
 "time": "2018-07-03 12:11:54",
 "ftime": "2018-07-03 12:11:54",
 "context": "客户 签收人: 前台 已签收 感谢使用圆通速递，期待再次为您服务",
 "location": ""
 */
@property (nonatomic, copy) NSString *time;
@property (nonatomic, copy) NSString *ftime;
@property (nonatomic, copy) NSString *context;
@property (nonatomic, copy) NSString *location;
@end
