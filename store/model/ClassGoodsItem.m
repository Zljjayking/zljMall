//
//  ClassGoodsItem.m
//  Distribution
//
//  Created by hchl on 2018/11/16.
//  Copyright © 2018年 hchl. All rights reserved.
//

#import "ClassGoodsItem.h"

@implementation ClassSubItem

+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"ID":@"id",
             };
}

@end

@implementation ClassGoodsItem
+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"ID":@"id",
             };
}
+ (NSDictionary *)objectClassInArray{
    return @{@"threeList":[ClassSubItem class]
             };
}
@end
