//
//  sallerLogisticInfo.h
//  Distribution
//
//  Created by hchl on 2018/11/29.
//  Copyright © 2018年 hchl. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface sallerLogisticInfo : NSObject
/**
 
 addtime = "2018-11-21T10:17:28.000+0000";
 area = "\U7384\U6b66\U533a";
 city = "\U5357\U4eac\U5e02";
 des = "\U6cb3\U897f\U4e07\U8fbeC\U5ea71602\U5ba4";
 flag = 1;
 id = 3;
 pro = "\U6c5f\U82cf\U7701";
 receivePerson = "\U6d4b\U8bd51";
 receivePhone = 13011111111;
 userId = 113;

 */
@property (nonatomic, copy) NSString *addtime;
@property (nonatomic, copy) NSString *area;
@property (nonatomic, copy) NSString *city;
@property (nonatomic, copy) NSString *des;
@property (nonatomic, copy) NSString *flag;
@property (nonatomic, copy) NSString *ID;
@property (nonatomic, copy) NSString *pro;
@property (nonatomic, copy) NSString *receivePerson;
@property (nonatomic, copy) NSString *receivePhone;
@property (nonatomic, copy) NSString *userId;
@end

NS_ASSUME_NONNULL_END
