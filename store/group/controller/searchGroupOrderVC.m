//
//  searchGroupOrderVC.m
//  Distribution
//
//  Created by hchl on 2019/1/2.
//  Copyright © 2019年 hchl. All rights reserved.
//

#import "searchGroupOrderVC.h"
#import "myOrderTableViewCell.h"
#import "myOrderTwoTableViewCell.h"
#import "myOrderThreeTableViewCell.h"
#import "goodsOrderDetailViewController.h"
#import "logisticsInfoViewController.h"
#import "popUpView.h"
#import <AlipaySDK/AlipaySDK.h>
#import "paySuccessViewController.h"
#import "shoppingCartViewController.h"
#import "groupingViewController.h"
@interface searchGroupOrderVC ()<UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>
@property (nonatomic, strong) UITableView *tableView;
// 搜索到的数据数组
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) UITextField *searchTf;
@property (nonatomic, assign) BOOL isSearching;//判断是否是在搜索中
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, strong) NSString *sortStr;
@property (nonatomic, strong) NSString *orderNo;
@property (nonatomic, strong) NSString *orderId;
@property (nonatomic, strong) popUpView *popView;
@property (nonatomic, assign) NSInteger selectIndex;

@property (nonatomic, strong) popUpView *popUView;
@property (nonatomic, assign) double allPrice;
@property (nonatomic, strong) NSString *payType;
@property (nonatomic, strong) shoppingCartModel *goodsModel;
@property (nonatomic, strong) myGroupModel *selectGroupModel;
@property (nonatomic, strong) NSString *shareUrlStr;
@end

@implementation searchGroupOrderVC
static NSString *myOrderTableViewCellID = @"myOrderTableViewCell";
static NSString *myOrderTwoTableViewCellID = @"myOrderTwoTableViewCell";
static NSString *myOrderThreeTableViewCellID = @"myOrderThreeTableViewCell";
- (UITableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        
        _tableView.tableFooterView = [UIView new];
        [_tableView registerNib:[UINib nibWithNibName:myOrderTableViewCellID bundle:[NSBundle mainBundle]] forCellReuseIdentifier:myOrderTableViewCellID];
        [_tableView registerNib:[UINib nibWithNibName:myOrderTwoTableViewCellID bundle:[NSBundle mainBundle]] forCellReuseIdentifier:myOrderTwoTableViewCellID];
        [_tableView registerNib:[UINib nibWithNibName:myOrderThreeTableViewCellID bundle:[NSBundle mainBundle]] forCellReuseIdentifier:myOrderThreeTableViewCellID];
        
        //        _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        //            [self searchOrderWithString:self.sortStr];
        //        }];
    }
    return _tableView;
}
- (NSMutableArray *)dataArray {
    if (_dataArray == nil) {
        _dataArray = [NSMutableArray arrayWithCapacity:0];
    }
    
    return _dataArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.isWhiteNavi = YES;
    self.page = 1;
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    self.isSearching = NO;
    _tableView.backgroundColor = myWhite;
    
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.naviBarView];
    self.navigationItem.leftBarButtonItem = self.backItem;
    self.naviBarView.alpha = 1;
    [self settitleView];
    
    [self setPopUView];
    [self setPopView];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(yanzheng:) name:@"CallBackResault" object:nil];
}
- (void)settitleView {
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 250*KAdaptiveRateWidth, 30)];//allocate titleView
    UIColor *color =  [UIColor clearColor];
    [titleView setBackgroundColor:color];
    
    UITextField *searchTf = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, 250*KAdaptiveRateWidth, 30)];
    searchTf.placeholder = @"  搜索订单号或商品名称";
    searchTf.delegate = self;
    searchTf.clearButtonMode = UITextFieldViewModeAlways;
    UIView *leftV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 35, 30)];
    leftV.backgroundColor = clear;
    UIImageView *searchImage = [[UIImageView alloc] initWithFrame:CGRectMake(13, 7.5, 15,15)];
    searchImage.image = [UIImage imageNamed:@"nav_icon_search"];
    [leftV addSubview:searchImage];
    searchTf.leftViewMode = UITextFieldViewModeAlways;
    searchTf.layer.cornerRadius = 15;
    searchTf.leftView = leftV;
    searchTf.backgroundColor = RGB(240, 240, 240);
    searchTf.font = [UIFont systemFontOfSize:13];
    searchTf.returnKeyType = UIReturnKeySearch;
    [titleView addSubview:searchTf];
    [searchTf addTarget:self action:@selector(textFieldDidChanged:) forControlEvents:UIControlEventEditingChanged];
    self.searchTf = searchTf;
    
    self.navigationItem.titleView = titleView;
    
}
#pragma mark ===== textFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField endEditing:YES];
    NSString *text = textField.text;
    if (text.length == 0) {
        self.isSearching = NO;
        _tableView.backgroundColor = myWhite;
    } else {
        [self searchingWithText:text];
        
    }
    [self.tableView reloadData];
    return YES;
}
- (void)searchingWithText:(NSString *)text {
    self.isSearching = YES;
    _tableView.backgroundColor = RGB(241, 243, 246);
    self.searchTf.text = text;
    self.sortStr = text;
    self.page = 1;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        if (![Utils isBlankString:self.sortStr]) {
            [self searchOrderWithString:self.sortStr];
        }
        
    }];
    [self.tableView.mj_header beginRefreshing];
    
}
- (void)textFieldDidChanged:(UITextField *)textField {
    if (textField.text.length > 0) {
        //        self.isSearching = YES;
        //        _tableView.backgroundColor = RGB(241, 243, 246);
    }else {
        //        self.isSearching = NO;
        //        _tableView.backgroundColor = myWhite;
        //        self.tableView.mj_footer = nil;
    }
    //    [self.tableView reloadData];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataArray.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 3;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    //    myGroupModel *orderModel = self.dataSource[indexPath.section];
    
    if (indexPath.row == 0) {
        return 41;
    } else if (indexPath.row == 1) {
        return 90;
    } else {
        myGroupModel *orderModel = self.dataArray[indexPath.section];
        if (([orderModel.ptgStatus isEqualToString:@"1"] && (![orderModel.orderStatus isEqualToString:@"90"] && ![orderModel.orderStatus isEqualToString:@"99"] && ![orderModel.orderStatus isEqualToString:@"91"] && ![orderModel.orderStatus isEqualToString:@"92"])) || [orderModel.ptgStatus isEqualToString:@"2"] || [orderModel.ptgStatus isEqualToString:@"3"] ) {
            return 70;
        }
        return 40;
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return nil;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return nil;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    myGroupModel *orderModel = self.dataArray[indexPath.section];
    if (indexPath.row == 0) {
        myOrderTwoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:myOrderTwoTableViewCellID forIndexPath:indexPath];
        
        cell.timeLb.text = [NSString isoTimeToStringWithDateString:orderModel.createTime];
        switch ([orderModel.ptgStatus integerValue]) {
            case 1:
            {
                switch ([orderModel.orderStatus integerValue]) {
                    case 10:
                    case 11:
                        cell.stateLb.text = @"待付款";
                        break;
                    case 90:
                        cell.stateLb.text = @"已撤销";
                        break;
                    case 92:
                    case 99:
                        cell.stateLb.text = @"付款超时自动撤销";
                        break;
                    case 91:
                        cell.stateLb.text = @"拼团失败";
                        break;
                    default:
                        cell.stateLb.text = @"待成团";
                        break;
                }
            }
                break;
            case 2:
            case 3:
                cell.stateLb.text = @"拼团成功";
                break;
            case 0:
            {
                if ([orderModel.payState isEqualToString:@"1"]) {
                    switch ([orderModel.refundStatus integerValue]) {
                        case 1:
                            cell.stateLb.text = @"已过期、已退款";
                            break;
                            
                        default:
                            cell.stateLb.text = @"已过期、待退款";
                            break;
                    }
                }else {
                    cell.stateLb.text = @"已过期、待退款";
                }
            }
                break;
            default:
                cell.stateLb.text = @"待支付";
                break;
        }
        return cell;
    } else if (indexPath.row == 1) {
        myOrderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:myOrderTableViewCellID forIndexPath:indexPath];
        
        cell.groupModel = orderModel;
        
        return cell;
    } else {
        myOrderThreeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:myOrderThreeTableViewCellID forIndexPath:indexPath];
        cell.goodsCountLb.text = [NSString stringWithFormat:@"共%ld件",[orderModel.saleNum integerValue]];
        
        cell.orderPriceLb.text = [NSString stringWithFormat:@"¥%.2f",[orderModel.helpGroupPrice doubleValue]];
        if ([orderModel.isHead isEqualToString:@"1"]) {
            cell.orderPriceLb.text = [NSString stringWithFormat:@"¥%.2f",[orderModel.groupPrice doubleValue]];
        }
        switch ([orderModel.ptgStatus integerValue]) {
            case 1:
            {
                cell.firstBtn.layer.borderColor = redBG.CGColor;
                [cell.firstBtn setTitleColor:redBG forState:UIControlStateNormal];
                cell.firstBtn.hidden = NO;
                cell.secondBtn.hidden = YES;
                cell.thirdBtn.hidden = YES;
                switch ([orderModel.orderStatus integerValue]) {
                    case 10:
                    case 11:
                    {
                        cell.firstBtn.layer.borderColor = myBlueType.CGColor;
                        [cell.firstBtn setTitleColor:myBlueType forState:UIControlStateNormal];
                        [cell.firstBtn setTitle:@"立即付款" forState:UIControlStateNormal];
                        cell.firstBlock = ^{
                            self.selectGroupModel = orderModel;
                            self.goodsModel = [shoppingCartModel new];
                            self.goodsModel.goodsPrice = orderModel.goodsPrice;
                            self.goodsModel.goodsName = orderModel.goodsName;
                            self.goodsModel.groupingGoodsNum = orderModel.groupingGoodsNum;
                            self.goodsModel.groupingPrice = orderModel.helpGroupPrice;
                            self.orderNo = orderModel.orderNo;
                            self.allPrice = [orderModel.helpGroupPrice doubleValue];
                            if ([orderModel.isHead isEqualToString:@"1"]) {
                                self.allPrice = [orderModel.groupPrice doubleValue];
                            }
                            [UIView animateWithDuration:0.2 animations:^{
                                self.popUView.bgView.hidden = NO;
                                self.popUView.frame = CGRectMake(0, kScreenHeight - self.popUView.height, kScreenWidth, self.popUView.height);
                            } completion:^(BOOL finished) {
                                
                            }];
                            
                        };
                        cell.secondBtn.hidden = NO;
                        cell.secondBtn.layer.borderColor = redBG.CGColor;
                        [cell.secondBtn setTitleColor:redBG forState:UIControlStateNormal];
                        [cell.secondBtn setTitle:@"撤销拼团" forState:UIControlStateNormal];
                        cell.secondBlock = ^{
                            self.orderNo = orderModel.orderNo;
                            self.orderId = orderModel.orderId;
                            [UIView animateWithDuration:0.2 animations:^{
                                self.popView.bgView.hidden = NO;
                                self.popView.frame = CGRectMake(0, kScreenHeight - self.popView.height, kScreenWidth, self.popView.height);
                            } completion:^(BOOL finished) {
                                
                            }];
                        };
                    }
                        break;
                    case 90:
                    {
                        cell.firstBtn.layer.borderColor = RGB(120, 120, 120).CGColor;
                        [cell.firstBtn setTitleColor:RGB(120, 120, 120) forState:UIControlStateNormal];
                        [cell.firstBtn setTitle:@"查看订单" forState:UIControlStateNormal];
                        cell.firstBtn.hidden = YES;
                    }
                        break;
                    case 91:
                    case 92:
                    case 99:
                    {
                        cell.firstBtn.layer.borderColor = RGB(120, 120, 120).CGColor;
                        [cell.firstBtn setTitleColor:RGB(120, 120, 120) forState:UIControlStateNormal];
                        [cell.firstBtn setTitle:@"查看订单" forState:UIControlStateNormal];
                        cell.firstBtn.hidden = YES;
                    }
                        break;
                        
                    default:
                    {
                        [cell.firstBtn setTitle:@"邀人参团" forState:UIControlStateNormal];
                        cell.firstBlock = ^{
                            //邀人参团
                            self.selectGroupModel = orderModel;
                            NSString *goodsPreview = [imageHost stringByAppendingString:orderModel.goodsPreview];
                            NSString *title = [@"【库存有限】" stringByAppendingString:orderModel.goodsName];
                            NSString *shareGroupUrl = [NSString stringWithFormat:shareGroupToWeiXinHost,orderModel.groupId,self.accountStr];
                            [self shareGoodsWithUrl:shareGroupUrl title:title imageUrl:goodsPreview];
                        };
                    }
                        break;
                }
            }
                break;
            case 2:
            case 3:
            {
                cell.firstBtn.hidden = NO;
                cell.firstBtn.layer.borderColor = RGB(120, 120, 120).CGColor;
                [cell.firstBtn setTitle:@"查看订单" forState:UIControlStateNormal];
                [cell.firstBtn setTitleColor:RGB(120, 120, 120) forState:UIControlStateNormal];
                cell.firstBlock = ^{
                    //查看订单
                    self.selectGroupModel = orderModel;
                    goodsOrderDetailViewController *OrderDetail = [goodsOrderDetailViewController new];
                    OrderDetail.type = 3;
                    OrderDetail.orderNo = orderModel.orderNo;
                    OrderDetail.hidesBottomBarWhenPushed = YES;
                    OrderDetail.refreshBlock = ^{
                        [self.tableView.mj_header beginRefreshing];
                    };
                    [self.navigationController pushViewController:OrderDetail animated:YES];
                };
                cell.secondBtn.hidden = YES;
                cell.thirdBtn.hidden = YES;
            }
                break;
            case 4:
            {
                cell.firstBtn.layer.borderColor = RGB(120, 120, 120).CGColor;
                [cell.firstBtn setTitle:@"查看订单" forState:UIControlStateNormal];
                [cell.firstBtn setTitleColor:RGB(120, 120, 120) forState:UIControlStateNormal];
                cell.firstBlock = ^{
                    //查看订单
                    
                };
                cell.firstBtn.hidden = YES;
                cell.secondBtn.hidden = YES;
                cell.thirdBtn.hidden = YES;
                
            }
                break;
            default:
            {
                cell.firstBtn.layer.borderColor = RGB(120, 120, 120).CGColor;
                [cell.firstBtn setTitle:@"立即支付" forState:UIControlStateNormal];
                [cell.firstBtn setTitleColor:RGB(120, 120, 120) forState:UIControlStateNormal];
                cell.firstBlock = ^{
                    //立即支付
                    
                };
                cell.firstBtn.hidden = YES;
                cell.secondBtn.hidden = YES;
                cell.thirdBtn.hidden = YES;
            }
                break;
        }
        return cell;
    }
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
    
    NSString *account = [FXObjManager dc_readUserDataForKey:@"account"];
    if ([account isEqualToString:testNum]) {
        [self.tabBarController.view addSubview:self.popUView.bgView];
        [self.tabBarController.view addSubview:self.popUView];
    } else {
        [self.view addSubview:weakSelf.popUView.bgView];
        [self.view addSubview:weakSelf.popUView];
    }
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
        weakSelf.payType = [NSString stringWithFormat:@"%ld",index];
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
                    req.timeStamp           = stamp.intValue;
                    req.package             = @"Sign=WXPay";
                    req.sign                = [data objectForKey:@"sign"];
                    
                    [WXApi sendReq:req];
                    //日志输出
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
    
    
    NSString *orderID = self.orderNo;
    
    paySuccessViewController *paySuccess = [paySuccessViewController new];
    paySuccess.imageTitle = @"submit_success_icon";
    paySuccess.selfTitle = @"支付成功";
    paySuccess.operation = @"下单成功";
    paySuccess.subTitleOne = [NSString stringWithFormat:@"支付金额:%.2f",self.allPrice];
    paySuccess.subTitleTwo = [NSString stringWithFormat:@"订单号:%@",self.orderNo];
    paySuccess.leftBtnTitle = @"查看拼团";
    paySuccess.rightBtnTitle = @"返回首页";
    __weak typeof(paySuccess) weakPaySuccess = paySuccess;
    
    paySuccess.btnBlock = ^(NSInteger leftOrRight) {
        if (leftOrRight == 1) {
            //查看订单详情
            
            [weakPaySuccess dismissViewControllerAnimated:YES completion:^{
                
                groupingViewController *groupingVC = [groupingViewController new];
                groupingVC.groupId = self.selectGroupModel.groupId;
                groupingVC.goodsModel = self.goodsModel;
                groupingVC.type = 1;
                [self.navigationController pushViewController:groupingVC animated:YES];
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
            [self.tableView.mj_header beginRefreshing];
            [self setPopUpView];
        } else {
            [MBProgressHUD showError:@"支付失败" toView:self.navigationController.view];
        }
    } else if ([self.payType isEqualToString:@"1"]) {
        NSString *resultStatus = [NSString stringWithFormat:@"%@",resultDic[@"resultStatus"]];
        NSLog(@"resultStatus == %@",resultStatus);
        if([resultStatus  isEqualToString: @"9000"]){
            NSLog(@"充值成功");
            [self.tableView.mj_header beginRefreshing];
            [self setPopUpView];
        } else {
            [MBProgressHUD showError:@"支付失败" toView:self.navigationController.view];
        }
    }
    
}
- (void)searchOrderWithString:(NSString *)string {
    [MBProgressHUD showMessage:@"加载中..."];
    
    NSString *page = [NSString stringWithFormat:@"%ld",self.page];
    NSDictionary *para = @{@"userId":self.myInfoM.ID,@"size":@"10",@"page":page,@"type":@"4",@"goodsName":string};
    [[ZLJNetWorkManager defaultManager]sendRequestMethod:HTTPMethodPOST isLogin:NO isJsonRequest:YES serverUrl:requestHost apiPath:queryMyPtUrl parameters:para progress:^(NSProgress * _Nullable progress) {
        
    } success:^(BOOL isSuccess, id  _Nullable responseObject) {
        [MBProgressHUD hideHUD];
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        NSDictionary *dataDic = [NSDictionary changeType:responseObject];
        if (dataDic) {
            NSString *code = dataDic[@"code"];
            NSString *msg = dataDic[@"message"];
            if ([code integerValue] == 200) {
                NSMutableArray *dataArr  = [myGroupModel mj_objectArrayWithKeyValuesArray:dataDic[@"data"]];
                
                if ([page integerValue] == 1) {
                    if (dataArr.count == 0) {
                        self.tableView.mj_footer = nil;
                    }else {
                        self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
                            self.page = 1+self.page;
                            [self searchOrderWithString:string];
                        }];
                    }
                }
                if (dataArr.count < 10) {
                    [self.tableView.mj_footer endRefreshingWithNoMoreData];
                }
                if (self.page == 1) {
                    [self.dataArray removeAllObjects];
                }
                [self.dataArray addObjectsFromArray:dataArr];
                [self.tableView reloadData];
                if (self.page == 1) {
                    self.tableView.scrollsToTop = YES;
                }
            } else {
                [MBProgressHUD showError:msg toView:self.navigationController.view];
            }
        } else {
            [MBProgressHUD showError:myRequestError toView:self.navigationController.view];
        }
    } failure:^(NSString * _Nullable errorMessage) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:errorMessage toView:self.navigationController.view];
    }];
}
- (void)shareGoodsWithUrl:(NSString *)url title:(NSString *)title imageUrl:(NSString *)goodsImage{
    NSURL *shareBgUrl = [NSURL URLWithString:goodsImage];
    UIImageView *imageV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    //placeholderImage:[UIImage imageNamed:@"banner"]
    [imageV sd_setImageWithURL:shareBgUrl placeholderImage:[UIImage imageNamed:@"logo_180"] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        //1、创建分享参数
        //[[NSBundle mainBundle] pathForResource:@"banner" ofType:@"png"]
        NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
        
//        NSArray * platforms =@[@(SSDKPlatformSubTypeWechatSession),@(SSDKPlatformSubTypeWechatTimeline)];
//
//
//        SSUIShareSheetConfiguration *config = [[SSUIShareSheetConfiguration alloc] init];
//
//        //设置分享菜单为简洁样式
//        config.style = SSUIActionSheetStyleSystem;
//
//        //设置竖屏有多少个item平台图标显示
//        config.columnPortraitCount = 2;
//
//        //设置横屏有多少个item平台图标显示
//        config.columnLandscapeCount = 2;
//
//        //设置取消按钮标签文本颜色
////        config.cancelButtonTitleColor = [UIColor redColor];
//
//        //设置对齐方式（简约版菜单无居中对齐）
//        config.itemAlignment = SSUIItemAlignmentCenter;
//
//        //设置标题文本颜色
//        //        config.itemTitleColor = [UIColor greenColor];
//
//        //设置分享菜单栏状态栏风格
//        config.statusBarStyle = UIStatusBarStyleDefault;
//
//        //设置支持的页面方向（单独控制分享菜单栏）
//        config.interfaceOrientationMask = UIInterfaceOrientationMaskPortrait|UIInterfaceOrientationMaskLandscape;
//
//        //设置分享菜单栏的背景颜色
//        config.menuBackgroundColor = [UIColor whiteColor];
//
//        //取消按钮是否隐藏，默认不隐藏
//        config.cancelButtonHidden = NO;
//
//        //设置直接分享的平台（不弹编辑界面）
//        config.directSharePlatforms = @[@(SSDKPlatformSubTypeWechatSession),@(SSDKPlatformSubTypeWechatTimeline)];
        SSUIPlatformItem *item_1 = [[SSUIPlatformItem alloc] init];
        item_1.iconNormal = [UIImage imageNamed:@"copy"];//默认版显示的图标
        item_1.iconSimple = [UIImage imageNamed:@"copy"];//简洁版显示的图标
        item_1.platformName = @"复制链接";
        item_1.platformId = @"copy";
        [item_1 addTarget:self action:@selector(copyUrl)];
        self.shareUrlStr = url;
        NSArray * platforms =@[@(SSDKPlatformSubTypeWechatSession),@(SSDKPlatformSubTypeWechatTimeline),@(SSDKPlatformTypeQQ),@(SSDKPlatformTypeSinaWeibo),item_1];
        if (image == nil) {
            image = [UIImage imageNamed:@"logo_180"];
        }
        [shareParams SSDKSetupShareParamsByText:@"快来一起买呀！"
                                         images:image
                                            url:[NSURL URLWithString:url]
                                          title:title
                                           type:SSDKContentTypeAuto];
        
        [ShareSDK showShareActionSheet:nil
                           customItems:platforms
                           shareParams:shareParams
                    sheetConfiguration:nil
                        onStateChanged:^(SSDKResponseState state, SSDKPlatformType platformType, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error, BOOL end) {
                            switch (state) {
                                case SSDKResponseStateSuccess:
                                {
                                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享成功"
                                                                                        message:nil
                                                                                       delegate:nil
                                                                              cancelButtonTitle:@"确定"
                                                                              otherButtonTitles:nil];
                                    [alertView show];
                                    break;
                                }
                                case SSDKResponseStateFail:
                                {
                                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"分享失败"
                                                                                    message:[NSString stringWithFormat:@"%@",error]
                                                                                   delegate:nil
                                                                          cancelButtonTitle:@"OK"
                                                                          otherButtonTitles:nil, nil];
                                    [alert show];
                                    break;
                                }
                                default:
                                    break;
                            }
                        }];
    }];
}
- (void)copyUrl {
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = self.shareUrlStr;
    [MBProgressHUD showSuccess:@"复制成功" toView:self.navigationController.view];
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
    //(popDataArr.count-1)*44+30+73
    self.popView = [[popUpView alloc] initWithFrame:CGRectMake(0, kScreenHeight, kScreenWidth, (popDataArr.count-1)*44+30+73) dataSource:popDataArr];
    self.popView.frame = CGRectMake(0, kScreenHeight, kScreenWidth, (popDataArr.count-1)*44+30+73);
    self.popView.bgView.hidden = YES;
    [self.popView.closeBtn setTitle:@"确定" forState:UIControlStateNormal];
    [self.popView.closeBtn addTarget:self action:@selector(sureBtnClick) forControlEvents:UIControlEventTouchUpInside];
    NSString *account = [FXObjManager dc_readUserDataForKey:@"account"];
    if ([account isEqualToString:testNum]) {
        [self.tabBarController.view addSubview:self.popView.bgView];
        [self.tabBarController.view addSubview:self.popView];
    } else {
        [self.view addSubview:self.popView.bgView];
        [self.view addSubview:self.popView];
    }
    
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
#pragma mark === 撤销订单
- (void)sureBtnClick {
    NSDictionary *para = @{@"orderId":self.orderId,@"cancelReason":[NSString stringWithFormat:@"%ld",self.selectIndex]};
    [[ZLJNetWorkManager defaultManager] sendRequestMethod:HTTPMethodPOST isLogin:NO isJsonRequest:NO serverUrl:requestHost apiPath:deleteOrderUrl parameters:para progress:^(NSProgress * _Nullable progress) {
        
    } success:^(BOOL isSuccess, id  _Nullable responseObject) {
        NSDictionary *dic = [NSDictionary changeType:responseObject];
        NSString *code = dic[@"code"];
        NSString *msg = dic[@"message"];
        if ([code integerValue] == 200) {
            [MBProgressHUD showSuccess:msg toView:self.navigationController.view];
            [self.tableView.mj_header beginRefreshing];
        } else {
            [MBProgressHUD showError:msg toView:self.navigationController.view];
        }
    } failure:^(NSString * _Nullable errorMessage) {
        [MBProgressHUD showError:errorMessage toView:self.navigationController.view];
    }];
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
