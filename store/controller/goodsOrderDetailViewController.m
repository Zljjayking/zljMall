//
//  goodsOrderDetailViewController.m
//  Distribution
//
//  Created by hchl on 2018/8/3.
//  Copyright © 2018年 hchl. All rights reserved.
//

#import "goodsOrderDetailViewController.h"
#import "orderDetialHeadTableViewCell.h"
#import "orderDetailAddressTableViewCell.h"
#import "orderDetailFootTableViewCell.h"
#import "orderDetailFootTwoTableViewCell.h"
#import "orderGoodsTableViewCell.h"
#import "orderOtherTableViewCell.h"
#import "logisticsInfoViewController.h"
#import "orderModel.h"
#import "logisticInfoModel.h"
#import "popUpView.h"
#import <AlipaySDK/AlipaySDK.h>
#import "paySuccessViewController.h"
#import "shoppingCartViewController.h"
#import "refundViewController.h"

#import "refundDetailViewController.h"
#import "googsInfoViewController.h"
@interface goodsOrderDetailViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *goodsArr;
@property (nonatomic, strong) orderModel *model;
@property (nonatomic, strong) NSMutableArray *logisticInfoArr;
@property (nonatomic, assign) double allPrice;
@property (nonatomic, assign) double allGoodsPrice;
@property (nonatomic, assign) NSInteger allCount;
@property (nonatomic, assign) double allLogisticPrice;
@property (nonatomic, assign) double discount;//商品优惠
@property (nonatomic, assign) double memberDiscount;//会员优惠
@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, strong) UIButton *firstBtn;
@property (nonatomic, strong) UIButton *secondBtn;
@property (nonatomic, strong) UIButton *thirdBtn;
@property (nonatomic, strong) popUpView *popView;
@property (nonatomic, assign) NSInteger selectIndex;


@property (nonatomic, strong) popUpView *popUView;
@property (nonatomic, strong) NSString *realPay;
@property (nonatomic, strong) NSString *payType;
@property (nonatomic, assign) BOOL isshelf;

@property (nonatomic, strong) NSString *applyNum;

@end

@implementation goodsOrderDetailViewController
static NSString *orderDetialHeadTableViewCellID = @"orderDetialHeadTableViewCell";
static NSString *orderDetailAddressTableViewCellID = @"orderDetailAddressTableViewCell";
static NSString *orderDetailFootTableViewCellID = @"orderDetailFootTableViewCell";
static NSString *orderDetailFootTwoTableViewCellID = @"orderDetailFootTwoTableViewCell";
static NSString *orderGoodsTableViewCellID = @"orderGoodsTableViewCell";
static NSString *orderOtherTableViewCellID = @"orderOtherTableViewCell";

- (UITableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, naviHeight, kScreenWidth, kScreenHeight-naviHeight-50-(isIphoneX?39:0)) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [UIView new];
        _tableView.backgroundColor = FXBGColor;
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
        [_tableView registerNib:[UINib nibWithNibName:orderDetialHeadTableViewCellID bundle:[NSBundle mainBundle]] forCellReuseIdentifier:orderDetialHeadTableViewCellID];
        
        [_tableView registerNib:[UINib nibWithNibName:orderDetailAddressTableViewCellID bundle:[NSBundle mainBundle]] forCellReuseIdentifier:orderDetailAddressTableViewCellID];
        
        [_tableView registerNib:[UINib nibWithNibName:orderDetailFootTableViewCellID bundle:[NSBundle mainBundle]] forCellReuseIdentifier:orderDetailFootTableViewCellID];
        
        [_tableView registerNib:[UINib nibWithNibName:orderDetailFootTwoTableViewCellID bundle:[NSBundle mainBundle]] forCellReuseIdentifier:orderDetailFootTwoTableViewCellID];
        
        [_tableView registerNib:[UINib nibWithNibName:orderGoodsTableViewCellID bundle:[NSBundle mainBundle]] forCellReuseIdentifier:orderGoodsTableViewCellID];
        
        [_tableView registerNib:[UINib nibWithNibName:orderOtherTableViewCellID bundle:[NSBundle mainBundle]] forCellReuseIdentifier:orderOtherTableViewCellID];
    }
    return _tableView;
}
- (UIButton *)firstBtn {
    if (!_firstBtn) {
        _firstBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _firstBtn.layer.masksToBounds = YES;
        _firstBtn.layer.cornerRadius = 14;
        _firstBtn.layer.borderWidth = 0.7;
        _firstBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        [_firstBtn addTarget:self action:@selector(bottomBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _firstBtn;
}
- (UIButton *)secondBtn {
    if (!_secondBtn) {
        _secondBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _secondBtn.layer.masksToBounds = YES;
        _secondBtn.layer.cornerRadius = 14;
        _secondBtn.layer.borderWidth = 0.7;
        _secondBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        [_secondBtn addTarget:self action:@selector(bottomBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _secondBtn;
}
- (UIButton *)thirdBtn {
    if (!_thirdBtn) {
        _thirdBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _thirdBtn.layer.masksToBounds = YES;
        _thirdBtn.layer.cornerRadius = 14;
        _thirdBtn.layer.borderWidth = 0.7;
        _thirdBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        [_thirdBtn addTarget:self action:@selector(bottomBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _thirdBtn;
}
- (UIView *)bottomView {
    if (!_bottomView) {
        _bottomView = [[UIView alloc] initWithFrame:CGRectZero];
        _bottomView.backgroundColor = myWhite;
        
        [_bottomView addSubview:self.firstBtn];
        [_bottomView addSubview:self.secondBtn];
        [_bottomView addSubview:self.thirdBtn];
//        WEAKSELF
        [self.firstBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.bottomView).offset(-12);
            make.centerY.equalTo(self.bottomView);
            make.width.mas_equalTo(75);
            make.height.mas_equalTo(28);
        }];
        [self.secondBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.firstBtn.mas_left).offset(-10);
            make.centerY.equalTo(self.bottomView);
            make.width.mas_equalTo(75);
            make.height.mas_equalTo(28);
        }];
        [self.thirdBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.secondBtn.mas_left).offset(-10);
            make.centerY.equalTo(self.bottomView);
            make.width.mas_equalTo(75);
            make.height.mas_equalTo(28);
        }];
    }
    return _bottomView;
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self requestData];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.logisticInfoArr = @[].mutableCopy;
    self.title = @"订单详情";
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setImage:[UIImage imageNamed:@"nav_icon_back"] forState:UIControlStateNormal];
    [backBtn setTitle:@"   " forState:UIControlStateNormal];
    backBtn.frame = CGRectMake(0, 0, 34, 20);
    backBtn.imageRect = CGRectMake(0, 0, 12, 20);
    backBtn.titleRect = CGRectMake(14, 0, 20, 20);
    [backBtn addTarget:self action:@selector(clickBackItemToPop) forControlEvents:UIControlEventTouchUpInside];
    if (self.type == 1) {
        self.navigationController.swipeBackEnabled = NO;
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    }
    
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.naviBarView];
    self.naviBarView.alpha = 1;
    [self.view addSubview:self.bottomView];
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.view.mas_bottom).offset(isIphoneX?-39:0);
        make.height.mas_equalTo(50);
    }];
    
    // Do any additional setup after loading the view.
}
- (void)setPopUView {
    WEAKSELF
    NSMutableDictionary *dic = @{@"signImage":@"",@"title":@"请选择支付方式",@"isSelect":@"1"}.mutableCopy;
    NSMutableDictionary *dic1 = @{@"signImage":@"zhifubao_icon",@"title":@"支付宝",@"isSelect":@"0"}.mutableCopy;
    NSMutableDictionary *dic2 = @{@"signImage":@"weixin_icon",@"title":@"微信",@"isSelect":@"0"}.mutableCopy;
    //    NSMutableDictionary *dic3 = @{@"signImage":@"bank_icon",@"title":@"银行卡",@"isSelect":@"0"}.mutableCopy;
    //    NSArray *popDataArr = @[dic,dic1,dic2,dic3];
    NSArray *popDataArr = @[dic,dic1,dic2];
    self.popUView = [[popUpView alloc] initWithFrame:CGRectMake(0, kScreenHeight, kScreenWidth, (popDataArr.count-1)*44+30+73) dataSource:popDataArr];
    self.popUView.frame = CGRectMake(0, kScreenHeight, kScreenWidth, (popDataArr.count-1)*44+30+73);
    self.popUView.bgView.hidden = YES;
    [self.view addSubview:weakSelf.popUView.bgView];
    [self.view addSubview:weakSelf.popUView];
    
    self.popUView.hideBlock = ^{
        [UIView animateWithDuration:0.2 animations:^{
            weakSelf.popUView.frame = CGRectMake(0, kScreenHeight, kScreenWidth, weakSelf.popUView.height);
        } completion:^(BOOL finished) {
            weakSelf.popUView.bgView.hidden = YES;
        }];
    };
    
    self.popUView.closeBlock = ^{
        [UIView animateWithDuration:0.2 animations:^{
            weakSelf.popUView.frame = CGRectMake(0, kScreenHeight, kScreenWidth, weakSelf.popUView.height);
        } completion:^(BOOL finished) {
            weakSelf.popUView.bgView.hidden = YES;
            
        }];
    };
#pragma mark == 调取支付
    self.popUView.chooseblock = ^(NSInteger index) {
        weakSelf.payType = [NSString stringWithFormat:@"%ld",(long)index];
        //支付
        [weakSelf toPay:weakSelf.payType];
        [UIView animateWithDuration:0.2 animations:^{
            weakSelf.popUView.frame = CGRectMake(0, kScreenHeight, kScreenWidth, weakSelf.popUView.height);
        } completion:^(BOOL finished) {
            weakSelf.popUView.bgView.hidden = YES;
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

- (void)setPopUpView {
    
    NSString *orderNO = self.orderNo;
    
    paySuccessViewController *paySuccess = [paySuccessViewController new];
    paySuccess.imageTitle = @"submit_success_icon";
    paySuccess.selfTitle = @"支付成功";
    paySuccess.operation = @"下单成功";
    paySuccess.subTitleOne = [NSString stringWithFormat:@"支付金额:%.2f",self.allPrice];
    paySuccess.subTitleTwo = [NSString stringWithFormat:@"订单号:%@",self.orderNo];
    paySuccess.leftBtnTitle = @"查看订单";
    paySuccess.rightBtnTitle = @"返回首页";
    __weak typeof(paySuccess) weakPaySuccess = paySuccess;
    
    paySuccess.btnBlock = ^(NSInteger leftOrRight) {
        if (leftOrRight == 1) {
            //查看订单详情
            
            [weakPaySuccess dismissViewControllerAnimated:YES completion:^{
                
                goodsOrderDetailViewController *detail = [goodsOrderDetailViewController new];
                detail.type = 1;
                detail.orderNo = orderNO;
                [self.navigationController pushViewController:detail animated:YES];
            }];
        } else {
            
            [UIApplication sharedApplication].keyWindow.rootViewController = [myTabBarController new];
        }
    };
    UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:paySuccess];
    [self presentViewController:navi animated:YES completion:^{
        
    }];
    
}

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
        }
    } else if ([self.payType isEqualToString:@"1"]) {
        NSString *resultStatus = [NSString stringWithFormat:@"%@",resultDic[@"resultStatus"]];
        NSLog(@"resultStatus == %@",resultStatus);
        if([resultStatus  isEqualToString: @"9000"]){
            NSLog(@"充值成功");
            [self setPopUpView];
        } else {
            [MBProgressHUD showError:@"支付失败" toView:self.navigationController.view];
        }
    }
}

- (void)setPopView {
    self.selectIndex = 1;
    NSMutableDictionary *dic = @{@"signImage":@"",@"title":@"请选择取消原因",@"isSelect":@"0",@"isImage":@"0"}.mutableCopy;
    NSMutableDictionary *dic1 = @{@"signImage":@"zhifubao_iconn",@"title":@"我不想买了",@"isSelect":@"1",@"isImage":@"0"}.mutableCopy;
    NSMutableDictionary *dic2 = @{@"signImage":@"weixin_iconn",@"title":@"信息填写错误，重新拍",@"isSelect":@"0",@"isImage":@"0"}.mutableCopy;
    NSMutableDictionary *dic3 = @{@"signImage":@"bank_iconn",@"title":@"卖家缺货",@"isSelect":@"0",@"isImage":@"0"}.mutableCopy;
    NSMutableDictionary *dic4 = @{@"signImage":@"bank_iconn",@"title":@"同城见面交易",@"isSelect":@"0",@"isImage":@"0"}.mutableCopy;
    NSMutableDictionary *dic5 = @{@"signImage":@"bank_iconn",@"title":@"其他原因",@"isSelect":@"0",@"isImage":@"0"}.mutableCopy;
    NSArray *popDataArr = @[dic,dic1,dic2,dic3,dic4,dic5];
    
    self.popView = [[popUpView alloc] initWithFrame:CGRectMake(0, kScreenHeight, kScreenWidth, (popDataArr.count-1)*44+30+73) dataSource:popDataArr];
    self.popView.frame = CGRectMake(0, kScreenHeight, kScreenWidth, (popDataArr.count-1)*44+30+73);
    self.popView.bgView.hidden = YES;
    [self.popView.closeBtn setTitle:@"确定" forState:UIControlStateNormal];
    [self.popView.closeBtn addTarget:self action:@selector(sureBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.popView.bgView];
    [self.view addSubview:self.popView];
    WEAKSELF
    
    self.popView.hideBlock = ^{
        [UIView animateWithDuration:0.2 animations:^{
            weakSelf.popView.frame = CGRectMake(0, kScreenHeight, kScreenWidth, weakSelf.popView.height);
        } completion:^(BOOL finished) {
            weakSelf.popView.bgView.hidden = YES;
        }];
    };
    self.popView.closeBlock = ^{
        [UIView animateWithDuration:0.2 animations:^{
            weakSelf.popView.frame = CGRectMake(0, kScreenHeight, kScreenWidth, weakSelf.popView.height);
        } completion:^(BOOL finished) {
            weakSelf.popView.bgView.hidden = YES;
        }];
    };
    self.popView.chooseblock = ^(NSInteger index) {
        weakSelf.selectIndex = index;
//        [UIView animateWithDuration:0.2 animations:^{
//            weakSelf.popView.frame = CGRectMake(0, kScreenHeight, kScreenWidth, weakSelf.popView.height);
//        } completion:^(BOOL finished) {
//            weakSelf.popView.bgView.hidden = YES;
//            [weakSelf.tableView reloadData];
//        }];
    };
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    self.navigationController.swipeBackEnabled = YES;
}
- (void)requestData {
    [[ZLJNetWorkManager defaultManager]sendRequestMethod:HTTPMethodPOST isLogin:NO isJsonRequest:NO serverUrl:requestHost apiPath:orderDetailUrl parameters:@{@"orderId":self.orderNo} progress:^(NSProgress * _Nullable progress) {
        
    } success:^(BOOL isSuccess, id  _Nullable responseObject) {
        NSDictionary *dataDic = [NSDictionary changeType:responseObject];
        if (dataDic) {
            NSString *code = dataDic[@"code"];
            NSString *msg = dataDic[@"message"];
            if ([code integerValue] == 200) {
                NSArray *data = dataDic[@"data"];
                NSMutableArray *dataArr = [NSMutableArray arrayWithArray:data];
                
                NSDictionary *logisticInfoDic = [dataArr lastObject];
                self.applyNum = logisticInfoDic[@"applyNum"];
                
                if ([[logisticInfoDic allKeys] containsObject:@"logisticInfo"]) {
                    [dataArr removeLastObject];
                }
//                [dataArr removeLastObject];
//                NSDictionary *logisticInfo = [NSDictionary dictionaryWithJsonString:logisticInfoDic[@"logisticInfo"]];

                self.allPrice = 0;
                self.allGoodsPrice = 0;
                self.allLogisticPrice = 0;
                self.discount = 0;
                self.memberDiscount = 0;
                self.isshelf = YES;
                self.isHideBottom = NO;
                
                self.goodsArr = [orderModel mj_objectArrayWithKeyValuesArray:dataArr];
                for (orderModel *model in self.goodsArr) {
                    self.allPrice = [model.total_paid doubleValue];
                    self.allGoodsPrice = [model.original_price doubleValue];
                    self.allLogisticPrice = [model.logistic_cost doubleValue];
                    self.discount = [model.discount doubleValue];
                    self.memberDiscount = [model.member_discount doubleValue];
                    if ([model.isshelf isEqualToString:@"0"]) {
                        self.isshelf = NO;
                        self.isHideBottom = YES;
                    }
                }
                
                [self.tableView reloadData];
                
//                if ([logisticInfo isKindOfClass:[NSDictionary class]]) {
//
//                    self.logisticInfoArr = [logisticInfoModel mj_objectArrayWithKeyValuesArray:logisticInfo[@"data"]];
//                    self.goodsArr = [orderModel mj_objectArrayWithKeyValuesArray:dataArr];
//                    for (orderModel *model in self.goodsArr) {
//                        self.allPrice = [model.total_paid doubleValue];
//                        self.allGoodsPrice = [model.original_price doubleValue];
//                        self.allLogisticPrice = [model.logistic_cost doubleValue];
//                        self.discount = [model.discount doubleValue];
//                        self.memberDiscount = [model.member_discount doubleValue];
//                        if ([model.isshelf isEqualToString:@"0"]) {
//                            self.isshelf = NO;
//                        }
//                    }
//                    [self.tableView reloadData];
//                } else {
//
//                }
                
                if (self.isHideBottom) {
                    [self.bottomView removeFromSuperview];
                    self.tableView.frame = CGRectMake(0, naviHeight, kScreenWidth, kScreenHeight-naviHeight);
                }
                
                orderModel *model = self.goodsArr[0];
                switch ([model.order_status integerValue]) {
                    case 10:
                    {
                        self.firstBtn.layer.borderColor = redBG.CGColor;
                        [self.firstBtn setTitle:@"撤销订单" forState:UIControlStateNormal];
                        [self.firstBtn setTitleColor:redBG forState:UIControlStateNormal];
                        
                        self.secondBtn.layer.borderColor = myBlueType.CGColor;
                        [self.secondBtn setTitle:@"立即支付" forState:UIControlStateNormal];
                        [self.secondBtn setTitleColor:myBlueType forState:UIControlStateNormal];
                        
                        self.firstBtn.hidden = NO;
                        if (!self.isshelf) {
                            self.secondBtn.hidden = YES;
                        } else {
                            self.secondBtn.hidden = NO;
                        }
                        
                        self.thirdBtn.hidden = YES;
                        
                        [self setPopUView];
                        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(yanzheng:) name:@"CallBackResault" object:nil];
                        [self setPopView];
                    }
                        break;
                    case 20:
                    {
                        self.firstBtn.layer.borderColor = myBlueType.CGColor;
                        [self.firstBtn setTitle:@"再次购买" forState:UIControlStateNormal];
                        [self.firstBtn setTitleColor:myBlueType forState:UIControlStateNormal];
                        
                        if (!self.isshelf) {
                            self.firstBtn.hidden = YES;
                        } else {
                            self.firstBtn.hidden = NO;
                        }
                        
                        self.secondBtn.hidden = YES;
                        self.thirdBtn.hidden = YES;
                    }
                        break;
                    case 30:
                    {
                        self.firstBtn.layer.borderColor = redBG.CGColor;
                        [self.firstBtn setTitle:@"确认收货" forState:UIControlStateNormal];
                        [self.firstBtn setTitleColor:redBG forState:UIControlStateNormal];
                        
//                        self.secondBtn.layer.borderColor = RGB(51, 51, 51).CGColor;
//                        [self.secondBtn setTitle:@"查看物流" forState:UIControlStateNormal];
//                        [self.secondBtn setTitleColor:RGB(51, 51, 51) forState:UIControlStateNormal];
                        
                        self.secondBtn.layer.borderColor = myBlueType.CGColor;
                        [self.secondBtn setTitle:@"再次购买" forState:UIControlStateNormal];
                        [self.secondBtn setTitleColor:myBlueType forState:UIControlStateNormal];
                        
                        self.firstBtn.hidden = NO;
                        if (!self.isshelf) {
                            self.secondBtn.hidden = YES;
                        } else {
                            self.secondBtn.hidden = NO;
                        }
                        self.thirdBtn.hidden = YES;
                    }
                        break;
                    case 40:
                    {
                        
                        if (!self.isshelf) {
                            self.firstBtn.layer.borderColor = myBlueType.CGColor;
                            [self.firstBtn setTitle:@"查看物流" forState:UIControlStateNormal];
                            [self.firstBtn setTitleColor:myBlueType forState:UIControlStateNormal];
                            
                            self.firstBtn.hidden = YES;
                            self.secondBtn.hidden = YES;
                            self.thirdBtn.hidden = YES;
                        } else {
                            self.firstBtn.layer.borderColor = myBlueType.CGColor;
                            [self.firstBtn setTitle:@"再次购买" forState:UIControlStateNormal];
                            [self.firstBtn setTitleColor:myBlueType forState:UIControlStateNormal];
                            
                            self.secondBtn.layer.borderColor = myBlueType.CGColor;
                            [self.secondBtn setTitle:@"查看物流" forState:UIControlStateNormal];
                            [self.secondBtn setTitleColor:myBlueType forState:UIControlStateNormal];
                            
                            self.firstBtn.hidden = NO;
                            self.secondBtn.hidden = YES;
                            self.thirdBtn.hidden = YES;
                        }
                        
                    }
                        break;
                    case 90:
                    {
                        self.firstBtn.layer.borderColor = myBlueType.CGColor;
                        [self.firstBtn setTitle:@"再次购买" forState:UIControlStateNormal];
                        [self.firstBtn setTitleColor:myBlueType forState:UIControlStateNormal];
                        
                        if (!self.isshelf) {
                            self.firstBtn.hidden = YES;
                        } else {
                            self.firstBtn.hidden = NO;
                        }
                        self.secondBtn.hidden = YES;
                        self.thirdBtn.hidden = YES;
                    }
                        break;
                    case 99:
                    {
                        
                        self.firstBtn.layer.borderColor = myBlueType.CGColor;
                        [self.firstBtn setTitle:@"再次购买" forState:UIControlStateNormal];
                        [self.firstBtn setTitleColor:myBlueType forState:UIControlStateNormal];
                        
                        if (!self.isshelf) {
                            self.firstBtn.hidden = YES;
                        } else {
                            self.firstBtn.hidden = NO;
                        }
                        self.secondBtn.hidden = YES;
                        self.thirdBtn.hidden = YES;
                    }
                        break;
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
- (void)clickBackItemToPop {
    [self.navigationController popToRootViewControllerAnimated:YES];
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.swipeBackEnabled = YES;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 0:
        case 3:
            return 1;
            break;
        case 1:
            return self.goodsArr.count;
            break;
        default:
            return 5;
            break;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 3) {
        return 0.01;
    }
    return 10;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    orderModel *model = self.goodsArr[0];
    switch (indexPath.section) {
//        case 0:
//            return 90;
//            break;
        case 0:
            return 63;
            break;
        case 1:
        {
            orderModel *orderM = self.goodsArr[indexPath.row];
            
            if ([model.order_status integerValue] == 20 || [model.order_status integerValue] == 30 || [model.order_status integerValue] == 40) {
                
                if (![Utils isBlankString:orderM.logistic_no]) {
                    return 126;
                }else {
                    if ([orderM.applyNum isEqualToString:@"0"]) {
                        
                        if (![Utils isBlankString:orderM.service_deadline]) {
                            NSString *deadline = [Utils transportToTime:[orderM.service_deadline longLongValue]];
                            NSString *dateNow = [Utils dateToString:[NSDate date] withDateFormat:@"YYYY-MM-dd HH:mm:ss"];
                            if ([Utils compareTwoDateWithMinDate:deadline DateFormat:@"YYYY-MM-dd HH:mm:ss" MaxDate:dateNow]) {
                                return 86;
                            }else {
                                return 126;
                            }
                        } else {
                            return 86;
                        }
                    }else if ([orderM.applyNum integerValue] >= 3){
//                        return 86;
                        return 126;
                    } else {
                        return 126;
                    }
                }
                
            }
            return 86;
        }
            break;
        case 3:
        {
            
            if ([model.order_status integerValue] != 20 && [model.order_status integerValue] != 30 && [model.order_status integerValue] != 40) {
                return 40;
            } else {
                return 90;
            }
            
        }
            break;
        default:
            return 40;
            break;
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return nil;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 10)];
    view.backgroundColor = FXBGColor;
    return view;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 10) {
        orderDetialHeadTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:orderDetialHeadTableViewCellID forIndexPath:indexPath];
        //10-等待付款（待客户付款）, 20-等待发货（客户已付款）, 30-已发货，40-订单完成, 90-已撤销, 99-付款超时自动撤销
        if (self.goodsArr.count) {
            orderModel *model = self.goodsArr[0];
            switch ([model.order_status integerValue]) {
                case 10:
                {
                    cell.deliverState.text = @"等待付款";
                    cell.logisticsMsg.text = @"暂无物流信息";
                    cell.timeLb.text = @"";
                }
                    break;
                case 20:
                {
                    cell.deliverState.text = @"等待发货";
                    cell.logisticsMsg.text = @"暂无物流信息";
                    cell.timeLb.text = @"";
                }
                    break;
                case 30:
                {
                    if (self.logisticInfoArr.count == 0) {
                        cell.deliverState.text = @"卖家已发货";
                        cell.logisticsMsg.text = @"暂无物流信息";
                        cell.timeLb.text = @"";
                    } else {
                        logisticInfoModel *model = self.logisticInfoArr[0];
                        cell.deliverState.text = @"卖家已发货";
                        cell.logisticsMsg.text = model.context;
                        cell.timeLb.text = model.time;
                        
                    }
                }
                    break;
                case 40:
                {
                    
                    cell.deliverState.text = @"订单已完成";
                    cell.logisticsMsg.text = @"";
                    cell.timeLb.text = @"";
                    if (self.logisticInfoArr.count) {
                        logisticInfoModel *model = [self.logisticInfoArr lastObject];
                        cell.logisticsMsg.text = model.context;
                        cell.timeLb.text = model.time;
                    }
                }
                    break;
                case 90:
                {
                    cell.deliverState.text = @"订单已撤销";
                    cell.logisticsMsg.text = @"";
                    cell.timeLb.text = @"";
                }
                    break;
                default:
                {
                    cell.deliverState.text = @"订单已超时";
                    cell.logisticsMsg.text = @"";
                    cell.timeLb.text = @"";
                }
                    break;
            }
        }
        
        return cell;
    }else if (indexPath.section == 0){
        orderDetailAddressTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:orderDetailAddressTableViewCellID forIndexPath:indexPath];
        if (self.goodsArr.count) {
            orderModel *model = self.goodsArr[0];
            cell.nameLb.text = model.consignee;
            cell.mobileLb.text = model.telephone;
            cell.addressLb.text = model.address;
        }
        return cell;
    }else if (indexPath.section == 1){
        orderGoodsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:orderGoodsTableViewCellID forIndexPath:indexPath];
        orderModel *model = self.goodsArr[indexPath.row];
        cell.ordermodel = model;
        
        [cell.refundBtn setTitle:@"申请退款" forState:UIControlStateNormal];
        cell.refundBtn.layer.masksToBounds = YES;
        cell.refundBtn.layer.cornerRadius = 13;
        cell.refundBtn.layer.borderColor = myGrayColor.CGColor;
        cell.refundBtn.layer.borderWidth = 0.7;
        
        [cell.logisticsBtn setTitle:@"查看物流" forState:UIControlStateNormal];
        [cell.logisticsBtn setTitleColor:myBlueType forState:UIControlStateNormal];
        cell.logisticsBtn.layer.masksToBounds = YES;
        cell.logisticsBtn.layer.cornerRadius = 13;
        cell.logisticsBtn.layer.borderColor = myBlueType.CGColor;
        cell.logisticsBtn.layer.borderWidth = 0.7;
        
        cell.refundBlock = ^{
            if ([Utils isBlankString:model.dealState]) {
                refundViewController *refundVC = [refundViewController new];
                refundVC.model = model;
                
                [self.navigationController pushViewController:refundVC animated:YES];
            } else {
                switch ([model.dealState integerValue]) {
                    case 1:
                    {
                        refundDetailViewController *refundDetail = [refundDetailViewController new];
                        refundDetail.type = 1;
                        refundDetail.model = model;
                        [self.navigationController pushViewController:refundDetail animated:YES];
                    }
                        break;
                    case 2:
                    {
                        refundDetailViewController *refundDetail = [refundDetailViewController new];
                        refundDetail.type = 2;
                        refundDetail.model = model;
                        [self.navigationController pushViewController:refundDetail animated:YES];
                    }
                        break;
                    case 3:
                    {
                        refundDetailViewController *refundDetail = [refundDetailViewController new];
                        refundDetail.type = 6;
                        refundDetail.model = model;
                        [self.navigationController pushViewController:refundDetail animated:YES];                    }
                        break;
                    case 4:
                    {
                        refundDetailViewController *refundDetail = [refundDetailViewController new];
                        refundDetail.type = 4;
                        refundDetail.model = model;
                        [self.navigationController pushViewController:refundDetail animated:YES];
                    }
                        break;
                    case 5:
                    {
//                        refundViewController *refundVC = [refundViewController new];
//                        refundVC.model = model;
//
//                        [self.navigationController pushViewController:refundVC animated:YES];
                        refundDetailViewController *refundDetail = [refundDetailViewController new];
                        refundDetail.type = 5;
                        refundDetail.model = model;
                        [self.navigationController pushViewController:refundDetail animated:YES];
                    }
                        break;
                    case 6:
                    {
                        refundDetailViewController *refundDetail = [refundDetailViewController new];
                        refundDetail.type = 7;
                        refundDetail.model = model;
                        [self.navigationController pushViewController:refundDetail animated:YES];
                    }
                        break;
                    case 7:
                    {
                        refundDetailViewController *refundDetail = [refundDetailViewController new];
                        refundDetail.type = 2;
                        refundDetail.model = model;
                        [self.navigationController pushViewController:refundDetail animated:YES];
                    }
                        break;
                    case 8:
                    {
                        refundDetailViewController *refundDetail = [refundDetailViewController new];
                        refundDetail.type = 3;
                        refundDetail.model = model;
                        [self.navigationController pushViewController:refundDetail animated:YES];
                    }
                        break;
                    default:
                        
                        break;
                }
            }
//            switch ([model.logistics_state integerValue])  {
//                case 10:
//                case 20:
//                case 30:
//                {
//                    
//                }
//                    break;
//                case 40:
//                {
//                    if ([Utils isBlankString:model.dealState]) {
//                        
//                    }
//                }
//                    break;
//                case 50:
//                {
//                    
//                }
//                    break;
//                case 60:
//                {
//                    
//                }
//                    break;
//                case 70:
//                {
//                    
//                }
//                    break;
//                    
//                    
//            }
            
        };
        cell.logisticBlock = ^{
            [self goToLogisticVCWithOrderModel:model];
        };
        
        
        
        switch ([model.logistics_state integerValue])  {
            case 10:
            case 20:
            case 30:
            {
                cell.refundBtn.hidden = NO;
                
                
            }
                break;
            case 40:
            case 41:
            case 42:
            case 43:
            {
                cell.refundBtn.hidden = NO;
                
            }
                break;
            case 50:
            {
                cell.refundBtn.hidden = NO;
                
            }
                break;
            case 60:
            {
                cell.refundBtn.hidden = NO;
            }
                break;
            case 70:
            {
                cell.refundBtn.hidden = NO;
            }
                break;
            case 80:
            {
                cell.refundBtn.hidden = NO;
                [cell.refundBtn setTitle:@"申请售后" forState:UIControlStateNormal];
                
            }
                break;
                
            default:
            {
                cell.refundBtn.hidden = YES;
                
            }
                break;
        }
        if (![Utils isBlankString:model.dealState]) {
            [cell.refundBtn setTitle:@"退款详情" forState:UIControlStateNormal];
            if ([model.logistics_state integerValue] == 80) {
                [cell.refundBtn setTitle:@"售后详情" forState:UIControlStateNormal];
            }
        }
        if (![Utils isBlankString:model.logistic_no]) {
            cell.logisticsBtn.hidden = NO;

        } else {
            cell.logisticsBtn.hidden = YES;
        }
        
        if ([model.applyNum isEqualToString:@"0"]) {
            
            if (![Utils isBlankString:model.service_deadline]) {
                NSString *deadline = [Utils transportToTime:[model.service_deadline longLongValue]];
                NSString *dateNow = [Utils dateToString:[NSDate date] withDateFormat:@"YYYY-MM-dd HH:mm:ss"];
                if ([Utils compareTwoDateWithMinDate:deadline DateFormat:@"YYYY-MM-dd HH:mm:ss" MaxDate:dateNow]) {
                    cell.refundBtn.hidden = YES;
                    cell.logisticsBtn.hidden = YES;
                    if (![Utils isBlankString:model.logistic_no]) {
                        cell.refundBtn.hidden = NO;
                        [cell.refundBtn setTitle:@"查看物流" forState:UIControlStateNormal];
                        [cell.refundBtn setTitleColor:myBlueType forState:UIControlStateNormal];
                        cell.refundBtn.layer.borderColor = myBlueType.CGColor;
                        cell.refundBlock = ^{
                            [self goToLogisticVCWithOrderModel:model];
                        };
                    } else {
                        cell.refundBtn.hidden = YES;
                    }
                }else {
//                    cell.refundBtn.hidden = NO;
                }
            }else {
                cell.logisticsBtn.hidden = YES;
                
                if (![Utils isBlankString:model.logistic_no]) {
                    cell.refundBtn.hidden = NO;
                    [cell.refundBtn setTitle:@"查看物流" forState:UIControlStateNormal];
                    [cell.refundBtn setTitleColor:myBlueType forState:UIControlStateNormal];
                    cell.refundBtn.layer.borderColor = myBlueType.CGColor;
                    cell.refundBlock = ^{
                        [self goToLogisticVCWithOrderModel:model];
                    };
                } else {
                    cell.refundBtn.hidden = YES;
                }
            }
        } else if ([model.applyNum integerValue] >= 3) {
//            cell.logisticsBtn.hidden = YES;
//
//            if (![Utils isBlankString:model.logistic_no]) {
//                cell.refundBtn.hidden = NO;
//                [cell.refundBtn setTitle:@"查看物流" forState:UIControlStateNormal];
//                [cell.refundBtn setTitleColor:myBlueType forState:UIControlStateNormal];
//            } else {
//                cell.refundBtn.hidden = YES;
//            }

        } else {
//            cell.refundBtn.hidden = NO;
        }
        if ([model.order_status integerValue] != 20 && [model.order_status integerValue] != 30 && [model.order_status integerValue] != 40) {
            cell.refundBtn.hidden = YES;
            cell.logisticsBtn.hidden = YES;
        }
        return cell;
    }else if (indexPath.section == 2){
        orderOtherTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:orderOtherTableViewCellID forIndexPath:indexPath];
        if (indexPath.row == 0) {
            cell.titleLb.text = @"商品总额";
            cell.titleLb.textColor = RGB(102, 102, 102);
            cell.contentLb.textColor = RGB(102, 102, 102);
            cell.contentLb.text = [NSString stringWithFormat:@"¥%.2f",self.allGoodsPrice];
        } else if (indexPath.row == 1){
            cell.titleLb.text = @"运费";
            cell.titleLb.textColor = RGB(102 , 102, 102);
            cell.contentLb.textColor = RGB(102, 102, 102);
            cell.contentLb.text = [NSString stringWithFormat:@"¥%.2f",self.allLogisticPrice];
        } else if (indexPath.row == 2){
            cell.titleLb.text = @"商品折扣";
            cell.titleLb.textColor = RGB(102 , 102, 102);
            cell.contentLb.textColor = RGB(102, 102, 102);
            cell.contentLb.text = [NSString stringWithFormat:@"-¥%.2f",self.discount];
        } else if (indexPath.row == 3){
            cell.titleLb.text = @"会员优惠";
            cell.titleLb.textColor = RGB(102 , 102, 102);
            cell.contentLb.textColor = RGB(102, 102, 102);
            cell.contentLb.text = [NSString stringWithFormat:@"-¥%.2f",self.memberDiscount];
        } else {
            cell.titleLb.text = @"订单总价";
            cell.titleLb.textColor = RGB(51, 51, 51);
            cell.contentLb.textColor = myRed;
            cell.contentLb.text = [NSString stringWithFormat:@"¥%.2f",self.allPrice];
        }
        return cell;
    }else {
        orderModel *model = self.goodsArr[0];
        if ([model.order_status integerValue] != 20 && [model.order_status integerValue] != 30 && [model.order_status integerValue] != 40) {
            orderDetailFootTwoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:orderDetailFootTwoTableViewCellID forIndexPath:indexPath];
            cell.orderIDLb.text = [NSString stringWithFormat:@"订单编号:%@",model.order_no];
            cell.fuzhiBlock = ^{
                UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
                pasteboard.string = model.order_no;
                [MBProgressHUD showSuccess:@"复制成功" toView:self.navigationController.view];
            };
            return cell;
        } else {
            orderDetailFootTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:orderDetailFootTableViewCellID forIndexPath:indexPath];
            cell.fuzhiBlock = ^{
                UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
                pasteboard.string = model.order_no;
                [MBProgressHUD showSuccess:@"复制成功" toView:self.navigationController.view];
            };
            cell.orderIDLb.text = [NSString stringWithFormat:@"订单编号：%@",model.order_no];
            switch ([model.pay_type integerValue]) {
                case 1:
                    cell.payMethodLb.text = @"支付方式：支付宝";
                    break;
                case 2:
                    cell.payMethodLb.text = @"支付方式：微信";
                    break;
                default:
                    cell.payMethodLb.text = @"支付方式：银行卡";
                    break;
            }
            
            cell.payTimeLb.text = [@"付款时间：" stringByAppendingString:@"未知"];
            if (![Utils isBlankString:model.pay_time]) {
                NSString *payTime = [NSString isoTimeToStringWithDateString:model.pay_time];
                cell.payTimeLb.text = [@"付款时间：" stringByAppendingString:payTime];
            }
            
            
            return cell;
        }
        
    }
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    orderModel *model = self.goodsArr[indexPath.row];
    NSLog(@"%@",model);
    if (indexPath.section == 1) {
        if ([model.isshelf isEqualToString:@"0"]) {
            return ;
        }
        shoppingCartModel *goodsModel = [shoppingCartModel new];
        googsInfoViewController *goodsInfo = [googsInfoViewController new];
        goodsInfo.hidesBottomBarWhenPushed = YES;
        goodsModel.num = @"0";
        goodsModel.goodsName = model.goods_name;
        goodsModel.fare = @"0";
        goodsModel.goodsPrice = @"0";
        goodsInfo.model = goodsModel;
        goodsInfo.goodsID = model.goods_id;
        goodsInfo.goodsPreview = model.goods_preview;
        goodsInfo.isGroup = [model.is_group boolValue];
        [self.navigationController pushViewController:goodsInfo animated:YES];
    }
}
#pragma mark === 底部按钮点击事件
- (void)bottomBtnClick:(UIButton *)sender {
    orderModel *model = self.goodsArr[0];
    if ([sender.titleLabel.text isEqualToString:@"撤销订单"]) {
        [UIView animateWithDuration:0.3 animations:^{
            self.popView.bgView.hidden = NO;
            self.popView.frame = CGRectMake(0, kScreenHeight - self.popView.height, kScreenWidth, self.popView.height);
        } completion:^(BOOL finished) {
            
        }];
    }else if ([sender.titleLabel.text isEqualToString:@"再次购买"]){
        [self buyAgianWithGoodsArray:self.goodsArr];
    }else if ([sender.titleLabel.text isEqualToString:@"确认收货"]){
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"确认收货" message:@"收否确认收货？" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self sureToReceivingGoodsWithOrderNo:model.ID];
        }];
        [alert addAction:cancelAction];
        [alert addAction:sureAction];
        [self presentViewController:alert animated:YES completion:nil];
    }else if ([sender.titleLabel.text isEqualToString:@"查看物流"]){
        [self goToLogisticVCWithOrderModel:model];
    }else if ([sender.titleLabel.text isEqualToString:@"立即支付"]){
        [UIView animateWithDuration:0.2 animations:^{
            self.popUView.bgView.hidden = NO;
            self.popUView.frame = CGRectMake(0, kScreenHeight - self.popUView.height, kScreenWidth, self.popUView.height);
        } completion:^(BOOL finished) {
            
        }];
    }
}
#pragma mark == 查看物流
- (void)goToLogisticVCWithOrderModel:(orderModel *)model {
    
    logisticsInfoViewController *logisticsInfo = [logisticsInfoViewController new];
    logisticsInfo.logistic_name = model.logistic_name;
    logisticsInfo.logistic_no = model.logistic_no;
    logisticsInfo.logisticCode = model.logistic_code;
//    logisticsInfo.logisticArr = self.logisticInfoArr;
    logisticsInfo.type = 2;
    switch ([model.order_status integerValue]) {
        case 10:
        {
            //@"等待付款";
            //@"暂无物流信息";
            [MBProgressHUD showToastText:@"暂无物流信息"];
        }
            break;
        case 20:
        case 30:
        case 40:
        {
            //@"等待发货";
            //@"暂无物流信息";
            [self.navigationController pushViewController:logisticsInfo animated:YES];
        }
            break;
//        case 30:
//        {
//            [self.navigationController pushViewController:logisticsInfo animated:YES];
//        }
//            break;
//        case 40:
//        {
//
//            [self.navigationController pushViewController:logisticsInfo animated:YES];
//            //@"订单已完成";
//            //model.context;
//            //model.time;
//        }
//            break;
        case 90:
        {
            //@"订单已撤销";
            //@"";
            [MBProgressHUD showToastText:@"订单已撤销"];
        }
            break;
        default:
        {
            //@"订单已超时";
            [MBProgressHUD showToastText:@"订单已超时"];
        }
            break;
    }
}
#pragma mark === 确认收货点击事件
- (void)sureToReceivingGoodsWithOrderNo:(NSString *)orderNo {
    [[ZLJNetWorkManager defaultManager]sendRequestMethod:HTTPMethodPOST isLogin:NO isJsonRequest:NO serverUrl:requestHost apiPath:confirmReceiptUrl parameters:@{@"id":orderNo} progress:^(NSProgress * _Nullable progress) {
        
    } success:^(BOOL isSuccess, id  _Nullable responseObject) {
        NSDictionary *dataDic = [NSDictionary changeType:responseObject];
        NSString *code = dataDic[@"code"];
        NSString *msg = dataDic[@"message"];
        if ([code integerValue] == 200) {
            [MBProgressHUD showSuccess:msg toView:self.navigationController.view];
            [self requestData];
        }else {
            [MBProgressHUD showError:msg toView:self.navigationController.view];
        }
    } failure:^(NSString * _Nullable errorMessage) {
        [MBProgressHUD showError:errorMessage toView:self.navigationController.view];
    }];
}
#pragma mark == 再次购买
- (void)buyAgianWithGoodsArray:(NSArray *)goodsArray{
    if (self.type == 3) {
        orderModel *model = goodsArray[0];
        shoppingCartModel *goodsModel = [shoppingCartModel new];
        googsInfoViewController *goodsInfo = [googsInfoViewController new];
        goodsInfo.hidesBottomBarWhenPushed = YES;
        goodsModel.num = @"0";
        goodsModel.goodsName = model.goods_name;
        goodsModel.fare = @"0";
        goodsModel.goodsPrice = @"0";
        goodsInfo.model = goodsModel;
        goodsInfo.goodsID = model.goods_id;
        goodsInfo.goodsPreview = model.goods_preview;
        goodsInfo.isGroup = YES;
        [self.navigationController pushViewController:goodsInfo animated:YES];
    }else {
        NSMutableArray *list = @[].mutableCopy;
        for (orderModel *model in goodsArray) {
            
            NSDictionary *dic = @{@"userId":self.myInfoM.ID,@"goodsId":model.goods_id,@"goodsStandardId":@"0",@"goodsCount":model.sale_num};
            if (![Utils isBlankString:model.standard_id]) {
                dic = @{@"userId":self.myInfoM.ID,@"goodsId":model.goods_id,@"goodsStandardId":model.standard_id,@"goodsCount":model.sale_num};
            }
            
            [list addObject:dic];
        }
        [[ZLJNetWorkManager defaultManager]sendRequestMethod:HTTPMethodPOST isLogin:NO isJsonRequest:YES serverUrl:requestHost apiPath:addToShoppingCartUrl parameters:@{@"param":@{@"list":list}} progress:^(NSProgress * _Nullable progress) {
            
        } success:^(BOOL isSuccess, id  _Nullable responseObject) {
            NSDictionary *dataDic = [NSDictionary changeType:responseObject];
            if (dataDic) {
                NSString *code = dataDic[@"code"];
                NSString *msg = dataDic[@"message"];
                if ([code integerValue] == 200) {
                    shoppingCartViewController *shopping = [shoppingCartViewController new];
                    shopping.fromWhere = 1;
                    [self.navigationController pushViewController:shopping animated:YES];
                    
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
}
#pragma mark === 撤销订单
- (void)sureBtnClick {
    orderModel *model = self.goodsArr[0];
    [[ZLJNetWorkManager defaultManager] sendRequestMethod:HTTPMethodPOST isLogin:NO isJsonRequest:NO serverUrl:requestHost apiPath:deleteOrderUrl parameters:@{@"orderId":model.ID,@"cancelReason":[NSString stringWithFormat:@"%ld",self.selectIndex]} progress:^(NSProgress * _Nullable progress) {
        
    } success:^(BOOL isSuccess, id  _Nullable responseObject) {
        NSDictionary *dic = [NSDictionary changeType:responseObject];
        NSString *code = dic[@"code"];
        NSString *msg = dic[@"message"];
        if ([code integerValue] == 200) {
            [MBProgressHUD showSuccess:msg toView:self.navigationController.view];
            if (self.refreshBlock) {
                self.refreshBlock();
            }
            [self.navigationController popViewControllerAnimated:YES];
            
        } else {
            [MBProgressHUD showError:msg toView:self.navigationController.view];
        }
    } failure:^(NSString * _Nullable errorMessage) {
        [MBProgressHUD showError:errorMessage toView:self.navigationController.view];
    }];
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
