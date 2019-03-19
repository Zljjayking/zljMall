//
//  goodsOrderViewController.m
//  Distribution
//
//  Created by hchl on 2018/8/3.
//  Copyright © 2018年 hchl. All rights reserved.
//

#import "goodsOrderViewController.h"
#import "orderSiteTableViewCell.h"
#import "orderSiteTwoTableViewCell.h"
#import "orderGoodsTableViewCell.h"
#import "orderOtherTableViewCell.h"
#import "orderBottomView.h"
#import "shoppingCartModel.h"
#import "googsInfoViewController.h"
#import "addressViewController.h"
#import "paySuccessViewController.h"
#import "goodsOrderDetailViewController.h"
#import "addressModel.h"
#import "popUpView.h"
#import <AlipaySDK/AlipaySDK.h>
#import "WXApi.h"
#import "groupingViewController.h"
#import "myGroupOrderViewController.h"
@interface goodsOrderViewController ()<UITableViewDelegate,UITableViewDataSource,WXApiDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) orderBottomView *bottomView;
@property (nonatomic, strong) NSArray *titleArr;
@property (nonatomic, strong) addressModel *addressModel;
@property (nonatomic, strong) popUpView *popView;
@property (nonatomic, strong) NSString *realPay;
/*
 "originalPrice": 744,
 "totalPaid": 566.48,
 "discount": 74.4,
 "memberDiscount": 114.12,
 "logisticCost": 11
 */
@property (nonatomic, strong) NSString *originalPrice;
@property (nonatomic, strong) NSString *totalPaid;
@property (nonatomic, strong) NSString *discount;
@property (nonatomic, strong) NSString *memberDiscount;
@property (nonatomic, strong) NSString *logisticCost;
@property (nonatomic, strong) NSString *orderNo;
@property (nonatomic, strong) NSString *payType;//1.支付宝   2.微信
@end

@implementation goodsOrderViewController

static NSString *orderSiteTableViewCellID = @"orderSiteTableViewCell";
static NSString *orderSiteTwoTableViewCellID = @"orderSiteTwoTableViewCell";
static NSString *orderGoodsTableViewCellID = @"orderGoodsTableViewCell";
static NSString *orderOtherTableViewCellID = @"orderOtherTableViewCell";

- (UITableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = FXBGColor;
        _tableView.tableFooterView = [UIView new];
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
        [_tableView registerNib:[UINib nibWithNibName:orderSiteTableViewCellID bundle:[NSBundle mainBundle]] forCellReuseIdentifier:orderSiteTableViewCellID];
        [_tableView registerNib:[UINib nibWithNibName:orderSiteTwoTableViewCellID bundle:[NSBundle mainBundle]] forCellReuseIdentifier:orderSiteTwoTableViewCellID];
        [_tableView registerNib:[UINib nibWithNibName:orderGoodsTableViewCellID bundle:[NSBundle mainBundle]] forCellReuseIdentifier:orderGoodsTableViewCellID];
        [_tableView registerNib:[UINib nibWithNibName:orderOtherTableViewCellID bundle:[NSBundle mainBundle]] forCellReuseIdentifier:orderOtherTableViewCellID];
    }
    return _tableView;
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self getNetwork];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    self.isWhiteNavi = YES;
    self.view.backgroundColor = FXBGColor;
    self.title = @"提交订单";
    self.navigationItem.leftBarButtonItem = self.backItem;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(yanzheng:) name:@"CallBackResault" object:nil];
    [self requestData];
    [self requestAddress];
}
- (void)requestData {
    [MBProgressHUD showMessage:@"加载中..."];
    NSMutableArray *list = @[].mutableCopy;
    for (shoppingCartModel *model in self.goodsArr) {
        NSDictionary *dic = @{@"goodsId":model.goodsId,@"saleNum":model.goodsCount};
        if ([model.goodsStandardId integerValue] != 0) {
            dic = @{@"goodsId":model.goodsId,@"goodsStandardId":model.goodsStandardId,@"saleNum":model.goodsCount};
        }
        
        [list addObject:dic];
    }
    NSDictionary *param = @{@"param":@{@"userId":self.myInfoM.ID,@"list":list}};
    NSString *apiPath = settleAccountsUrl;
    if (self.isGroup) {
        NSString *isHead = [NSString stringWithFormat:@"%d",self.isHead];
        param = @{@"param":@{@"userId":self.myInfoM.ID,@"isHead":isHead,@"list":list}};
        apiPath = toSettlementUrl;
        if ([isHead isEqualToString:@"0"]) {
            param = @{@"param":@{@"userId":self.myInfoM.ID,@"groupId":self.groupId,@"isHead":isHead,@"list":list}};
        }
    }
    
    [[ZLJNetWorkManager defaultManager]sendRequestMethod:HTTPMethodPOST isLogin:NO isJsonRequest:YES serverUrl:requestHost apiPath:apiPath parameters:param progress:^(NSProgress * _Nullable progress) {
        
    } success:^(BOOL isSuccess, id  _Nullable responseObject) {
        [MBProgressHUD hideHUD];
        NSDictionary *dataDic = [NSDictionary changeType:responseObject];
        if (dataDic) {
            NSString *code = dataDic[@"code"];
            NSString *msg = dataDic[@"message"];
            if ([code integerValue] == 200) {
                NSDictionary *data = dataDic[@"data"];
                self.originalPrice = data[@"originalPrice"];
                self.totalPaid = data[@"totalPaid"];
                self.discount = data[@"discount"];
                self.memberDiscount = data[@"memberDiscount"];
                self.logisticCost = data[@"logisticCost"];
                [self setUpUI];
            } else {
                [MBProgressHUD showError:msg toView:self.navigationController.view];
                [self.navigationController popViewControllerAnimated:YES];
            }
            
        }else {
            [MBProgressHUD showError:@"结算出错" toView:self.navigationController.view];
            [self.navigationController popViewControllerAnimated:YES];
        }
    } failure:^(NSString * _Nullable errorMessage) {
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:@"结算出错" toView:self.navigationController.view];
        [self.navigationController popViewControllerAnimated:YES];
    }];
}
- (void)requestAddress {
    NSString *apiPath = [NSString stringWithFormat:@"%@%@",addressMagUrl,self.myInfoM.ID];
    [[ZLJNetWorkManager defaultManager]sendRequestMethod:HTTPMethodPOST isLogin:NO isJsonRequest:NO serverUrl:requestHost apiPath:apiPath parameters:nil progress:^(NSProgress * _Nullable progress) {
        
    } success:^(BOOL isSuccess, id  _Nullable responseObject) {
        NSDictionary *dataDic = [NSDictionary changeType:responseObject];
        if (dataDic) {
            NSString *code = dataDic[@"code"];
            NSString *msg = dataDic[@"message"];
            if ([code integerValue] == 200) {
                NSMutableArray *addressArr = [addressModel mj_objectArrayWithKeyValuesArray:dataDic[@"data"]];
                for (int i=0;i<addressArr.count;i++) {
                    addressModel *model = addressArr[i];
                    if ([model.def boolValue]) {
                        [addressArr exchangeObjectAtIndex:i withObjectAtIndex:0];
                    }
                }
                if (addressArr.count != 0) {
                    self.addressModel = addressArr[0];
                }
                [self.tableView reloadData];
            } else {
                [MBProgressHUD showError:msg toView:self.view];
            }
        } else {
            [MBProgressHUD showError:myRequestError toView:self.view];
        }
    } failure:^(NSString * _Nullable errorMessage) {
        [MBProgressHUD showError:errorMessage toView:self.view];
    }];
}
- (void)setUpUI {
//    NSData *defaultAddresData = [FXObjManager dc_readUserDataForKey:defaultAddres];
//
//    self.addressModel = [NSKeyedUnarchiver unarchiveObjectWithData:defaultAddresData];
    
    double totalPrice = 0.0;
    for (shoppingCartModel *model in self.goodsArr) {
        
        if ([model.goodsStandardId isEqualToString:@"0"] || [Utils isBlankString:model.goodsStandardId]) {
            totalPrice = totalPrice + [model.goodsPrice doubleValue]*[model.goodsCount integerValue];
        } else {
            totalPrice = totalPrice + [model.standardPrice doubleValue]*[model.goodsCount integerValue];
        }
        
    }
    
    NSString *total = [NSString stringWithFormat:@"¥%.2f",[self.originalPrice doubleValue]];
    
    if ([Utils isBlankString:total]) {
        total = [NSString stringWithFormat:@"¥%.2f",totalPrice];
    }
    
    NSString *discount = [NSString stringWithFormat:@"-¥%.2f",[self.discount doubleValue]];
    NSString *memberDiscount = [NSString stringWithFormat:@"-¥%.2f",[self.memberDiscount doubleValue]];
    NSString *logisticCost = [NSString stringWithFormat:@"¥%.2f",[self.logisticCost doubleValue]];
    self.titleArr = @[@{@"title":@"配送方式",@"content":@"快递"},
                      @{@"title":@"商品总额",@"content":total},
                      @{@"title":@"商品折扣",@"content":discount},
                      @{@"title":@"会员优惠",@"content":memberDiscount},
                      @{@"title":@"运费",@"content":logisticCost}];
    //    self.goodsArr = @[@"1",@"2",@"3"];
    self.tableView.frame = CGRectMake(0, naviHeight, kScreenWidth, kScreenHeight-naviHeight-(isIphoneX?tabHeight:50));
    [self.view addSubview:self.tableView];
    
    [self.view addSubview:self.naviBarView];
    self.naviBarView.alpha = 1;
    
    [self setBottomView];
    
    WEAKSELF
    NSMutableDictionary *dic = @{@"signImage":@"",@"title":@"请选择支付方式",@"isSelect":@"1"}.mutableCopy;
    NSMutableDictionary *dic1 = @{@"signImage":@"zhifubao_icon",@"title":@"支付宝",@"isSelect":@"0"}.mutableCopy;
    NSMutableDictionary *dic2 = @{@"signImage":@"weixin_icon",@"title":@"微信",@"isSelect":@"0"}.mutableCopy;
    //    NSMutableDictionary *dic3 = @{@"signImage":@"bank_icon",@"title":@"银行卡",@"isSelect":@"0"}.mutableCopy;
    //    NSArray *popDataArr = @[dic,dic1,dic2,dic3];
    NSArray *popDataArr = @[dic,dic1,dic2];
    self.popView = [[popUpView alloc] initWithFrame:CGRectMake(0, kScreenHeight, kScreenWidth, (popDataArr.count-1)*44+30+73) dataSource:popDataArr];
    self.popView.frame = CGRectMake(0, kScreenHeight, kScreenWidth, (popDataArr.count-1)*44+30+73);
    self.popView.bgView.hidden = YES;
    [self.view addSubview:weakSelf.popView.bgView];
    [self.view addSubview:weakSelf.popView];
    
    self.popView.hideBlock = ^{
        if (weakSelf.isGroup) {
            myGroupOrderViewController *myGroup = [myGroupOrderViewController new];
            myGroup.hidesBottomBarWhenPushed = YES;
            myGroup.type = 1;
            [weakSelf.navigationController pushViewController:myGroup animated:YES];
        }else {
            [UIView animateWithDuration:0.2 animations:^{
                weakSelf.popView.frame = CGRectMake(0, kScreenHeight, kScreenWidth, weakSelf.popView.height);
            } completion:^(BOOL finished) {
                weakSelf.popView.bgView.hidden = YES;
                goodsOrderDetailViewController *orderDetail = [goodsOrderDetailViewController new];
                orderDetail.orderNo = weakSelf.orderNo;
                orderDetail.type = 1;
                [weakSelf.navigationController pushViewController:orderDetail animated:YES];
            }];
        }
//        groupingViewController *groupingVC = [groupingViewController new];
//        groupingVC.groupId = weakSelf.groupId;
//        groupingVC.goodsModel = weakSelf.goodsArr[0];
//        groupingVC.type = 1;
//        [weakSelf.navigationController pushViewController:groupingVC animated:YES];
        
    };
    self.popView.closeBlock = ^{
        [UIView animateWithDuration:0.2 animations:^{
            weakSelf.popView.frame = CGRectMake(0, kScreenHeight, kScreenWidth, weakSelf.popView.height);
        } completion:^(BOOL finished) {
            weakSelf.popView.bgView.hidden = YES;
            if (weakSelf.isGroup) {
                myGroupOrderViewController *myGroup = [myGroupOrderViewController new];
                myGroup.hidesBottomBarWhenPushed = YES;
                myGroup.type = 1;
                [weakSelf.navigationController pushViewController:myGroup animated:YES];
            }else {
                goodsOrderDetailViewController *orderDetail = [goodsOrderDetailViewController new];
                orderDetail.orderNo = weakSelf.orderNo;
                orderDetail.type = 1;
                [weakSelf.navigationController pushViewController:orderDetail animated:YES];
            }
        }];
    };
#pragma mark == 调取支付
    self.popView.chooseblock = ^(NSInteger index) {
        weakSelf.payType = [NSString stringWithFormat:@"%ld",index];
        //支付
        [weakSelf toPay:weakSelf.payType];
        [UIView animateWithDuration:0.2 animations:^{
            weakSelf.popView.frame = CGRectMake(0, kScreenHeight, kScreenWidth, weakSelf.popView.height);
        } completion:^(BOOL finished) {
            weakSelf.popView.bgView.hidden = YES;
            [weakSelf.tableView reloadData];
        }];
    };
}
- (void)toPay:(NSString*)index {
    
    [[ZLJNetWorkManager defaultManager]sendRequestMethod:HTTPMethodPOST isLogin:NO isJsonRequest:NO serverUrl:requestHost apiPath:payUrl parameters:@{@"orderNo":self.orderNo,@"payType":index} progress:^(NSProgress * _Nullable progress) {
        
    } success:^(BOOL isSuccess, id  _Nullable responseObject) {
        NSDictionary *dataDic = [NSDictionary changeType:responseObject];
        if (dataDic) {
            NSString *code = dataDic[@"code"];
            NSString *msg = dataDic[@"message"];
            if ([code integerValue] == 200) {
                NSDictionary *data = dataDic[@"data"];
                if ([index isEqualToString:@"1"]) {
                    NSString *orderPay = data[@"alipay"];
                    
                    [[AlipaySDK defaultService] payOrder:orderPay fromScheme:alipayAppScheme callback:^(NSDictionary *resultDic) {
                        NSLog(@"reslut = %@",resultDic);
                        NSString *resultStatus = [NSString stringWithFormat:@"%@",resultDic[@"resultStatus"]];
                        
                        NSLog(@"resultStatus == %@",resultStatus);
                        if([resultStatus  isEqualToString: @"9000"]){
                            [self setPopUpView];
                            NSLog(@"充值成功");
                        } else {
                            [MBProgressHUD showError:@"支付失败" toView:self.navigationController.view];
                        }
                    }];
                } else {
                    /*
                     "nonce_str": "9Oof5g3fFylGIotu",
                     "package": "WXPay",
                     "appid": "wx31c0e99441aae57d",
                     "sign": "B2FB691835C639AE4465D904F06E15C8",
                     "trade_type": "APP",
                     "return_msg": "OK",
                     "result_code": "SUCCESS",
                     "mch_id": "1514067251",
                     "return_code": "SUCCESS",
                     "prepay_id": "wx10180835036052cca946c0d62698353525",
                     "timestamp": "1536574115"
                     */
                    NSMutableString *stamp  = [data objectForKey:@"timestamp"];
                    //调起微信支付
                    PayReq* req             = [[PayReq alloc] init];
                    req.partnerId           = [data objectForKey:@"mch_id"];
                    req.prepayId            = [data objectForKey:@"prepay_id"];
                    req.nonceStr            = [data objectForKey:@"nonce_str"];
                    req.timeStamp           = (UInt32)stamp.longLongValue;
                    req.package             = @"Sign=WXPay";
                    req.sign                = [data objectForKey:@"sign"];
                    
                    [WXApi sendReq:req];
//                    //日志输出
//                    NSLog(@"appid=%@\npartid=%@\nprepayid=%@\nnoncestr=%@\ntimestamp=%ld\npackage=%@\nsign=%@",[data objectForKey:@"appid"],req.partnerId,req.prepayId,req.nonceStr,(long)req.timeStamp,req.package,req.sign );
                }
            }else {
                [MBProgressHUD showError:msg toView:self.navigationController.view];
            }
        }else {
            [MBProgressHUD showError:myRequestError toView:self.navigationController.view];
        }
    } failure:^(NSString * _Nullable errorMessage) {
        [MBProgressHUD showError:errorMessage toView:self.navigationController.view];
    }];
}
#pragma mark == 底部视图
- (void)setBottomView {
    
    self.bottomView = [[orderBottomView alloc] initWithFrame:CGRectMake(0, kScreenHeight-(isIphoneX?tabHeight:50), kScreenWidth, 50)];
    double totalPrice = 0.0;
    for (shoppingCartModel *model in self.goodsArr) {
        totalPrice = totalPrice + [model.standardPrice doubleValue]*[model.goodsCount integerValue];
        if ([model.goodsStandardId isEqualToString:@"0"]) {
            totalPrice = totalPrice + [model.goodsPrice doubleValue]*[model.goodsCount integerValue];
        }
    }
    totalPrice = totalPrice+[self.logisticCost doubleValue]-[self.discount doubleValue]-[self.memberDiscount doubleValue];
    self.realPay = [NSString stringWithFormat:@"¥%.2f",[self.totalPaid doubleValue]];
    if ([Utils isBlankString:self.totalPaid]) {
        self.realPay = [NSString stringWithFormat:@"¥%.2f",totalPrice];
    }
    self.bottomView.priceLb.text = self.realPay;
    
    WEAKSELF
    self.bottomView.submitblock = ^{
        //提交订单
        [weakSelf submiteOrder];
    };
    [self.view addSubview:self.bottomView];
}
- (void)submiteOrder {
    if ([Utils isBlankString:self.addressModel.receivePerson]) {
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:@"请选择收货地址" toView:self.navigationController.view];
        return ;
    }
    [MBProgressHUD showMessage:@"提交中..."];
    NSString *address = [NSString stringWithFormat:@"%@%@%@%@",self.addressModel.pro,self.addressModel.city,self.addressModel.area,self.addressModel.des];
    NSMutableArray *goodsList = @[].mutableCopy;
    for (shoppingCartModel *model in self.goodsArr) {
        NSDictionary *modelDic = @{@"goodsId":model.goodsId,@"goodsStandardId":model.goodsStandardId,@"saleNum":model.goodsCount};
        
        if (self.type == 1) {
            modelDic = @{@"shoppingCartId":model.ID,@"goodsId":model.goodsId,@"goodsStandardId":model.goodsStandardId,@"saleNum":model.goodsCount};
            
        }
        if ([model.goodsStandardId isEqualToString:@"0"]) {
            modelDic = @{@"goodsId":model.goodsId,@"saleNum":model.goodsCount};
            if (self.type == 1) {
                modelDic = @{@"shoppingCartId":model.ID,@"goodsId":model.goodsId,@"saleNum":model.goodsCount};
            }
        }
        [goodsList addObject:modelDic];
    }
    
    
    NSDictionary *parameter = @{@"param":@{@"userId":self.myInfoM.ID,@"consignee":self.addressModel.receivePerson,@"addrId":self.addressModel.ID,@"address":address,@"telephone":self.addressModel.receivePhone,@"list":goodsList}};
    NSString *apiPath = createOrderUrl;
    if (self.isGroup) {
        NSString *isHead = [NSString stringWithFormat:@"%d",self.isHead];
        apiPath = createPtOrderUrl;
        if (self.isHead) {
            parameter = @{@"param":@{@"userId":self.myInfoM.ID,@"consignee":self.addressModel.receivePerson,@"addrId":self.addressModel.ID,@"address":address,@"telephone":self.addressModel.receivePhone,@"isHead":isHead,@"list":goodsList}};
        }else {
            parameter = @{@"param":@{@"userId":self.myInfoM.ID,@"consignee":self.addressModel.receivePerson,@"addrId":self.addressModel.ID,@"address":address,@"telephone":self.addressModel.receivePhone,@"isHead":isHead,@"groupId":self.groupId,@"list":goodsList}};
        }
    }
    [[ZLJNetWorkManager defaultManager] sendRequestMethod:HTTPMethodPOST isLogin:NO isJsonRequest:YES serverUrl:requestHost apiPath:apiPath parameters:parameter progress:^(NSProgress * _Nullable progress) {
        
    } success:^(BOOL isSuccess, id  _Nullable responseObject) {
        NSDictionary *dataDic = [NSDictionary changeType:responseObject];
        [MBProgressHUD hideHUD];
        if (dataDic) {
            NSString *code = dataDic[@"code"];
            NSString *msg = dataDic[@"message"];
            if ([code integerValue] == 200) {
                
                if (self.isGroup) {
                    NSDictionary *data = dataDic[@"data"];
                    if (self.isHead) {
                        self.groupId = data[@"groupId"];
                    }
                    self.orderNo = data[@"orderNo"];
                }else {
                    self.orderNo = dataDic[@"data"];
                }
                [UIView animateWithDuration:0.2 animations:^{
                    self.popView.bgView.hidden = NO;
                    self.popView.frame = CGRectMake(0, kScreenHeight - self.popView.height, kScreenWidth, self.popView.height);
                } completion:^(BOOL finished) {
                    
                }];
            }else {
                [MBProgressHUD showError:msg toView:self.navigationController.view];
            }
        } else {
            [MBProgressHUD showError:@"生成订单失败" toView:self.navigationController.view];
        }
    } failure:^(NSString * _Nullable errorMessage) {
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:errorMessage toView:self.navigationController.view];
    }];
    
}
- (void)setPopUpView {
    
    paySuccessViewController *paySuccess = [paySuccessViewController new];
    paySuccess.imageTitle = @"submit_success_icon";
    paySuccess.selfTitle = @"支付成功";
    paySuccess.operation = @"下单成功";
    paySuccess.subTitleOne = [NSString stringWithFormat:@"支付金额:%@",self.realPay];
    paySuccess.subTitleTwo = [NSString stringWithFormat:@"订单号:%@",self.orderNo];
    NSString *leftBtnTitle = @"查看订单";
    if (self.isGroup) {
        leftBtnTitle = @"查看拼团";
    }
    paySuccess.leftBtnTitle = leftBtnTitle;
    paySuccess.rightBtnTitle = @"返回首页";
    __weak typeof(paySuccess) weakPaySuccess = paySuccess;
    paySuccess.btnBlock = ^(NSInteger leftOrRight) {
        if (leftOrRight == 1) {
            //查看订单详情
            [weakPaySuccess dismissViewControllerAnimated:YES completion:^{
                if (self.isGroup) {
                    groupingViewController *groupingVC = [groupingViewController new];
                    groupingVC.groupId = self.groupId;
                    groupingVC.goodsModel = self.goodsArr[0];
                    groupingVC.type = 1;
                    [self.navigationController pushViewController:groupingVC animated:YES];
                }else {
                    goodsOrderDetailViewController *detail = [goodsOrderDetailViewController new];
                    detail.type = 1;
                    detail.orderNo = self.orderNo;
                    [self.navigationController pushViewController:detail animated:YES];
                }
            }];
        } else {
            
            [UIApplication sharedApplication].keyWindow.rootViewController = [myTabBarController new];
        }
    };
    UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:paySuccess];
    [self presentViewController:navi animated:YES completion:^{
        
    }];

}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.goodsArr.count+2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    } else if (section <= self.goodsArr.count) {
        return 2;
    } else {
        return self.titleArr.count-1;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 85;
    } else if (indexPath.section <= self.goodsArr.count) {
        if (indexPath.row == 0) {
            return 85;
        }
    }
    return 44;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 0.01;
    }
    return 10;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 10)];
    view.backgroundColor = FXBGColor;
    return view;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return nil;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if ([self.addressModel.def boolValue]) {
            orderSiteTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:orderSiteTableViewCellID forIndexPath:indexPath];
            cell.backgroundColor = myWhite;
            cell.address = self.addressModel;
            return cell;
        } else {
            orderSiteTwoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:orderSiteTwoTableViewCellID forIndexPath:indexPath];
            cell.backgroundColor = myWhite;
            cell.address = self.addressModel;
            return cell;
        }
        
    } else if (indexPath.section <= self.goodsArr.count){
        if (indexPath.row == 0) {
            shoppingCartModel *model = self.goodsArr[indexPath.section-1];
            orderGoodsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:orderGoodsTableViewCellID forIndexPath:indexPath];
            cell.model = model;
            return cell;
        } else {
            orderOtherTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:orderOtherTableViewCellID forIndexPath:indexPath];
            NSDictionary *dic = self.titleArr[0];
            cell.titleLb.text = dic[@"title"];
            cell.contentLb.text = dic[@"content"];
            return cell;
        }
    } else {
        orderOtherTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:orderOtherTableViewCellID forIndexPath:indexPath];
        NSDictionary *dic = self.titleArr[indexPath.row+1];
        cell.titleLb.text = dic[@"title"];
        cell.contentLb.text = dic[@"content"];
        return cell;
    }
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 1) {
        if (indexPath.row < self.goodsArr.count) {
//            shoppingCartModel *model = self.goodsArr[indexPath.row];
//            googsInfoViewController *goodsInfo = [googsInfoViewController new];
//            goodsInfo.model = model;
//            goodsInfo.goodsID = model.goodsId;
//            [self.navigationController pushViewController:goodsInfo animated:YES];
        }
    } else if (indexPath.section == 0){
        addressViewController *addressMag = [addressViewController new];
        addressMag.addressModelBlock = ^(addressModel *model) {
            self.addressModel = model;
            self.tableView.frame = CGRectMake(0, naviHeight, kScreenWidth, kScreenHeight-(isIphoneX?tabHeight:50));
            [self.tableView reloadData];
        };
        [self.navigationController pushViewController:addressMag animated:YES];
    }
}
#pragma mark === 消息
- (void)yanzheng:(NSNotification *)noti {
    NSDictionary *resultDic  = noti.userInfo;
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"CallBackResault" object:nil];
    if ([self.payType isEqualToString:@"2"]) {
        NSString *resultStatus = [NSString stringWithFormat:@"%@",resultDic[@"errCode"]];
        if ([resultStatus isEqualToString:@"0"]) {
            NSLog(@"充值成功");
            [self setPopUpView];
        } else {
            [MBProgressHUD showError:@"支付失败" toView:self.navigationController.view];
            if (self.isGroup) {
                myGroupOrderViewController *myGroup = [myGroupOrderViewController new];
                myGroup.hidesBottomBarWhenPushed = YES;
                myGroup.type = 1;
                [self.navigationController pushViewController:myGroup animated:YES];
            }else {
                goodsOrderDetailViewController *detail = [goodsOrderDetailViewController new];
                detail.type = 1;
                detail.orderNo = self.orderNo;
                [self.navigationController pushViewController:detail animated:YES];
            }
        }
    } else if ([self.payType isEqualToString:@"1"]) {
        NSString *resultStatus = [NSString stringWithFormat:@"%@",resultDic[@"resultStatus"]];
        NSLog(@"resultStatus == %@",resultStatus);
        if([resultStatus  isEqualToString: @"9000"]){
            NSLog(@"充值成功");
            [self setPopUpView];
        } else {
            [MBProgressHUD showError:@"支付失败" toView:self.navigationController.view];
            if (self.isGroup) {
                myGroupOrderViewController *myGroup = [myGroupOrderViewController new];
                myGroup.hidesBottomBarWhenPushed = YES;
                myGroup.type = 1;
                [self.navigationController pushViewController:myGroup animated:YES];
            }else {
                goodsOrderDetailViewController *detail = [goodsOrderDetailViewController new];
                detail.type = 1;
                detail.orderNo = self.orderNo;
                [self.navigationController pushViewController:detail animated:YES];
            }
            
        }
        
    }
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
