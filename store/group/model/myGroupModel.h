//
//  myGroupModel.h
//  Distribution
//
//  Created by hchl on 2019/1/1.
//  Copyright © 2019年 hchl. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface myGroupModel : NSObject
/**
 groupId 拼团团ID
 orderDetailId 订单详情ID
 orderId 订单ID
 createTime 创建时间
 isHead 是否团长 1：是 0：否
 goodsName 商品名称
 discountPrice 各种折扣后此件商品实际支付价格（含运费）
 logisticsCost 运费
 saleNum 商品数量
 salePrice 商品原价
 ptgStatus 拼团的状态.状态 1：拼团中 2：成功（正常情况） 3：帮团成功 0：失败  null:待支付
 standardName 商品规格名称
 standardProperty 商品规格属性
 groupPrice 开团价,单位:元
 helpGroupPrice 参团价,单位:元
 refundStatus 拼团失败时退款状态
 orderStatus 订单状态:10-等待付款（待客户付款）, 20-等待发货（客户已付款）, 30-已发货，40-订单完成, 50-待成团（结合是否是拼团订单使用） 90-已撤销, 99-付款超时自动撤销
 goodsPrice 商品价格（原价）
 groupingGoodsNum 已拼多少件
 */
@property (nonatomic, copy) NSString *groupId;
@property (nonatomic, copy) NSString *orderDetailId;
@property (nonatomic, copy) NSString *orderId;
@property (nonatomic, copy) NSString *createTime;
@property (nonatomic, copy) NSString *isHead;
@property (nonatomic, copy) NSString *goodsName;
@property (nonatomic, copy) NSString *discountPrice;
@property (nonatomic, copy) NSString *logisticsCost;
@property (nonatomic, copy) NSString *saleNum;
@property (nonatomic, copy) NSString *salePrice;
@property (nonatomic, copy) NSString *ptgStatus;
@property (nonatomic, copy) NSString *standardName;
@property (nonatomic, copy) NSString *standardProperty;
@property (nonatomic, copy) NSString *groupPrice;
@property (nonatomic, copy) NSString *helpGroupPrice;
@property (nonatomic, copy) NSString *refundStatus;
@property (nonatomic, copy) NSString *orderStatus;
@property (nonatomic, copy) NSString *goodsPreview;
@property (nonatomic, copy) NSString *orderNo;
@property (nonatomic, copy) NSString *goodsPrice;
@property (nonatomic, copy) NSString *groupingGoodsNum;
@property (nonatomic, copy) NSString *totalPaid;
@property (nonatomic, copy) NSString *payState;
@end

NS_ASSUME_NONNULL_END
