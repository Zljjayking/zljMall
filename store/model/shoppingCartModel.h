//
//  shoppingCartModel.h
//  Distribution
//
//  Created by hchl on 2018/7/30.
//  Copyright © 2018年 hchl. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GoodsCategoryModel : NSObject
@property (nonatomic, copy) NSString *no;//型号ID
@property (nonatomic, copy) NSString *title;//型号名称
@property (nonatomic, copy) NSString *count;//库存数量
@property (nonatomic, copy) NSString *standardPrice;//规格属性价格
@property (nonatomic, copy) NSString *standardProperty;//规格属性
@property (nonatomic, copy) NSString *createTime;//创建时间
@property (nonatomic, copy) NSString *joinPrice;//参团价
@property (nonatomic, copy) NSString *openPrice;//开团价
@property (nonatomic, copy) NSString *vipStaRebatePrice;//会员立减
@property (nonatomic, copy) NSString *groupStaRebatePrice;//开团赚
@end

@interface GoodsImageModel : NSObject
@property (nonatomic, copy) NSString *ID;//型号ID
@property (nonatomic, copy) NSString *goodsId;//型号名称
@property (nonatomic, copy) NSString *goodsPreview;//图片
@property (nonatomic, copy) NSString *isown;//
@property (nonatomic, copy) NSString *createTime;
@end

@interface shoppingCartModel : NSObject
@property (nonatomic, copy) NSString *ID;
@property (nonatomic, copy) NSString *goodsId;//
@property (nonatomic, copy) NSString *goodsName;//商品名称
@property (nonatomic, copy) NSArray *images;//商品的图片
@property (nonatomic, copy) NSString *goodsPreview;//商品预览图片
@property (nonatomic, copy) NSString *goodsPrice;//商品价格
@property (nonatomic, copy) NSString *limitCount;//限购数量
@property (nonatomic, copy) NSString *goodsVideo;//视频
@property (nonatomic, copy) NSString *goodsCategory;//类别(0:实物 1:虚拟)
@property (nonatomic, copy) NSString *stock;//库存
@property (nonatomic, copy) NSString *userId;//用户id
@property (nonatomic, copy) NSString *fare;//运费
@property (nonatomic, copy) NSString *num;//月销量
@property (nonatomic, copy) NSString *ishot;//是否热门(0:否 1:是)
@property (nonatomic, copy) NSString *volume;//月销量
@property (nonatomic, copy) NSString *goodsDetail;//商品详情
@property (nonatomic, copy) NSString *goodsDiscount;//折扣
@property (nonatomic, copy) NSString *isHouse;//是否加入收藏 1.已加入 空未加入
@property (nonatomic, copy) NSString *isVip;//是否参与打折 1.参与 0.不参与
//购物车里的信息
@property (nonatomic, copy) NSString *isshelf;//是否上架
@property (nonatomic, copy) NSString *goodsCount;//购物车里的数量
@property (nonatomic, copy) NSString *goodsStandardId;//购物车里的型号ID
@property (nonatomic, copy) NSString *standardName;//购物车里的型号参数名称（内存。颜色）
@property (nonatomic, copy) NSString *standardPrice;//购物车里的规格属性价格
@property (nonatomic, copy) NSString *standardProperty;//购物车里的规格属性

@property (nonatomic, copy) NSString *isDelete;//是否是删除购物车状态
@property (nonatomic, copy) NSString *deliverPlace;//发货地

@property (nonatomic, copy) NSString *count;//加入购物车或购买的数量
/**
 1.购物车里的属性 是否被选中
 2.精选里是的属性 是否被选中
 */
@property (nonatomic, assign) BOOL isSelect;

@property (nonatomic, copy) NSString *categoryID;//选中的型号样式ID
@property (nonatomic, copy) NSString *sizeStr;//选中的样式名称
@property (nonatomic, copy) NSString *vipRebatePrice;//会员折扣价
@property (nonatomic, copy) NSString *groupingNum;//拼团人数
@property (nonatomic, copy) NSString *groupingPrice;//拼团价格
@property (nonatomic, copy) NSString *groupingGoodsNum;//拼团商品数量
@property (nonatomic, copy) NSString *isGroup;//是否参与拼团
@property (nonatomic, copy) NSString *groupPrice;//开团价
@property (nonatomic, copy) NSString *groupRebatePrice;//开团赚多少钱
//在去结算的时候用
@property (nonatomic, copy) NSString *isHead;//是否是开团 1.开团 0.参团
@property (nonatomic, copy) NSString *hotGoods;//拼团爆品。1.是 0.否

@property (nonatomic, copy) NSArray <GoodsCategoryModel *> *goodsStaListVos;//型号的数组
@property (nonatomic, copy) NSArray <GoodsImageModel *> *goodsProListVos;//商品图片
@end


