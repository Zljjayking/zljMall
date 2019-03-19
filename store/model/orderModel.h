//
//  orderModel.h
//  Distribution
//
//  Created by hchl on 2018/8/28.
//  Copyright © 2018年 hchl. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface orderModel : NSObject
/**
 {
 "addr_id" = 2;
 address = "\U6c5f\U82cf\U7701\U5357\U4eac\U5e02\U7384\U6b66\U533a\U7384\U6b66\U6e56";
 applyNum = 2;
 applyTime = "2018-11-28T03:58:41.000+0000";
 consignee = "\U5f20";
 "create_time" = "2018-11-26T06:28:39.000+0000";
 dealState = 1;
 discount = 0;
 "goods_category" = 1;
 "goods_id" = 9;
 "goods_name" = "\U8c6a\U534e\U7535\U9500\U673a\U5668\U4eba";
 "goods_preview" = "/2018-09-28/1/624bced184664a3c8ef92ef539fd977e.jpg";
 id = 52;
 isshelf = 0;
 "logistic_code" = shentong;
 "logistic_cost" = 0;
 "logistic_name" = "\U7533\U901a";
 "logistic_no" = 124131313;
 "logistics_cost" = 0;
 "logistics_state" = 40;
 "member_discount" = 218392;
 "order_detail_id" = 63;
 "order_no" = 201811261438767522;
 "order_status" = 20;
 "original_price" = "1200000.01";
 "pay_time" = "2018-11-28T03:37:31.000+0000";
 "pay_type" = 2;
 pictureList =     (
 );
 refundCause = "\U7269\U6d41\U7834\U635f\U5df2\U62d2\U7b7e";
 refundNumber = 201811281140425169;
 remark = "";
 returnId = 26;
 returnLogisticCode = shunfeng;
 returnLogisticName = "\U987a\U4e30";
 returnLogisticNo = 9876543210123;
 returnMoney = 654404;
 "sale_num" = 2;
 "sale_price" = 400000;
 "service_deadline" = 1543635451000;
 "standard_id" = 22;
 "standard_name" = "\U7ebf\U8def";
 "standard_property" = "2000\U7ebf";
 telephone = 15205190057;
 "total_paid" = "981608.01";
 "user_id" = 8;
 }

 */

@property (nonatomic, copy) NSString *order_no;
@property (nonatomic, copy) NSString *pay_type;//1.支付宝 2.微信 3.银行卡
@property (nonatomic, copy) NSString *pay_time;
@property (nonatomic, copy) NSString *goods_name;
@property (nonatomic, copy) NSString *address;
@property (nonatomic, copy) NSString *consignee;
@property (nonatomic, copy) NSString *create_time;
@property (nonatomic, copy) NSString *sale_num;
@property (nonatomic, copy) NSString *logistic_name;
@property (nonatomic, copy) NSString *telephone;
@property (nonatomic, copy) NSString *logistic_no;
@property (nonatomic, copy) NSString *sale_price;
//10-等待付款（待客户付款）, 20-等待发货（客户已付款）, 30-已发货，40-订单完成, 90-已撤销, 99-付款超时自动撤销
@property (nonatomic, copy) NSString *order_status;
@property (nonatomic, copy) NSString *total_pay;
@property (nonatomic, copy) NSString *goods_preview;
@property (nonatomic, copy) NSString *logistic_cost;
@property (nonatomic, copy) NSString *logistics_cost;
@property (nonatomic, copy) NSString *logistic_code;
@property (nonatomic, copy) NSString *original_price;
//物流状态:: 10-待发货, 20-待收货(已发货), 30-已签收 40-退款中 50-退款成功 60-退款失败 70-撤销退款 80-交易完成 99-付款超时自动撤销
@property (nonatomic, copy) NSString *logistics_state;
@property (nonatomic, copy) NSString *total_paid;
@property (nonatomic, copy) NSString *user_id;
@property (nonatomic, copy) NSString *ID;
@property (nonatomic, copy) NSString *logisticInfo;
@property (nonatomic, copy) NSString *standard_name;
@property (nonatomic, copy) NSString *standard_property;
@property (nonatomic, copy) NSString *standard_id;
@property (nonatomic, copy) NSString *goods_id;
@property (nonatomic, copy) NSString *discount;
@property (nonatomic, copy) NSString *member_discount;

@property (nonatomic, copy) NSString *isshelf;
@property (nonatomic, copy) NSString *addr_id;
@property (nonatomic, copy) NSString *goods_category;
@property (nonatomic, copy) NSString *order_detail_id;
@property (nonatomic, copy) NSString *applyNum;
@property (nonatomic, copy) NSString *applyTime;
//处理状态 1、待处理 2、已同意(待退款) 3、已拒绝 4、已退款 5、已撤销  6、退款失败
@property (nonatomic, copy) NSString *dealState;
@property (nonatomic, copy) NSString *refundCause;
@property (nonatomic, copy) NSString *refundNumber;
@property (nonatomic, copy) NSString *remark;
@property (nonatomic, copy) NSString *returnId;
@property (nonatomic, copy) NSString *returnLogisticCode;
@property (nonatomic, copy) NSString *returnLogisticName;
@property (nonatomic, copy) NSString *returnLogisticNo;
@property (nonatomic, copy) NSString *returnMoney;

@property (nonatomic, copy) NSString *service_deadline;
@property (nonatomic, copy) NSString *updateTime;
@property (nonatomic, copy) NSString *goodsState;
@property (nonatomic, copy) NSString *is_spell_group;//订单是否是拼团商品 0-否 1-是
@property (nonatomic, copy) NSString *is_group;//商品是否是拼团商品 0-否 1-是
//orderNumber
@end
