//
//  ClassGoodsItem.h
//  Distribution
//
//  Created by hchl on 2018/11/16.
//  Copyright © 2018年 hchl. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ClassSubItem : NSObject
/**
 "id": 17,
 "categoryName": "小明测试3.1.1级目录",
 "threeList": null,
 "createTime": "2018-11-21T10:19:09.000+0000",
 "flag": 1,
 "parentId": 14,
 "categoryImage": null
 */
@property (nonatomic, copy) NSString *ID;

@property (nonatomic, copy) NSString *categoryName;

@property (nonatomic, copy) NSString *createTime;

@property (nonatomic, copy) NSString *flag;

@property (nonatomic, copy) NSString *parentId;

@property (nonatomic, copy) NSString *categoryImage;
@end

@interface ClassGoodsItem : NSObject

/**
 "id": 14,
 "categoryName": "小明测试2.1级目录",
 "threeList":[]
 "createTime": null,
 "flag": null,
 "parentId": null,
 "categoryImage": null
 */

@property (nonatomic, copy) NSString *ID;

@property (nonatomic, copy) NSString *categoryName;

@property (nonatomic, copy) NSString *createTime;

@property (nonatomic, copy) NSString *flag;

@property (nonatomic, copy) NSString *parentId;

@property (nonatomic, copy) NSString *categoryImage;

@property (nonatomic, copy) NSArray <ClassSubItem*>*threeList;
@end

NS_ASSUME_NONNULL_END
