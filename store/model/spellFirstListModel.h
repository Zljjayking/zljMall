//
//  spellFirstListModel.h
//  Distribution
//
//  Created by hchl on 2018/12/25.
//  Copyright © 2018年 hchl. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface spellFirstListModel : NSObject
/**
 "id": 68,
 "categoryName": "电子产品",
 "createTime": "2018-12-06T01:27:46.000+0000",
 "flag": 1,
 "threeList": null,
 "parentId": null,
 "categoryImage": null,
 "level": null
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
