//
//  categoryModel.h
//  Distribution
//
//  Created by hchl on 2018/11/26.
//  Copyright © 2018年 hchl. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface categoryModel : NSObject
/**
 "id": 6,
 "categoryName": "国内",
 "createTime": "2018-11-22T08:53:36.000+0000",
 "flag": 1,
 "threeList": null,
 "parentId": 2,
 "categoryImage": "/2018-11-21/1/7918e05aa43741d290c087cece2d3133.png",
 "level": 3
 */
@property (nonatomic, copy) NSString *ID;
@property (nonatomic, copy) NSString *categoryName;
@property (nonatomic, copy) NSString *createTime;
@property (nonatomic, copy) NSString *flag;
@property (nonatomic, copy) NSString *threeList;
@property (nonatomic, copy) NSString *parentId;
@property (nonatomic, copy) NSString *categoryImage;
@property (nonatomic, copy) NSString *level;

@end

NS_ASSUME_NONNULL_END
