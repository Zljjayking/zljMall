//
//  shoppingCartModel.m
//  Distribution
//
//  Created by hchl on 2018/7/30.
//  Copyright © 2018年 hchl. All rights reserved.
//

#import "shoppingCartModel.h"

@implementation GoodsCategoryModel
+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"no":@"id",@"title":@"standardProperty",
             };
}
@end
@implementation GoodsImageModel
+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"no":@"id",
             };
}
@end
@implementation shoppingCartModel
+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"ID":@"id",
             };
}
+ (NSDictionary *)objectClassInArray{
    return @{@"goodsStaListVos":[GoodsCategoryModel class],
             @"goodsProListVos":[GoodsImageModel class]
             };
}
@end
