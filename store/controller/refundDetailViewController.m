//
//  refundDetailViewController.m
//  Distribution
//
//  Created by hchl on 2018/11/15.
//  Copyright © 2018年 hchl. All rights reserved.
//

#import "refundDetailViewController.h"
#import "refundDetailTableViewCell.h"//高90
#import "refundDetailTwoTableViewCell.h"//高180
#import "refundInfoTableViewCell.h"//高270
#import "refundDetailThreeTableViewCell.h"//高350
#import "refundFourTableViewCell.h"//高270
#import "refundSuccessTableViewCell.h"

#import "refundLogisticsViewController.h"
#import "refundApplyViewController.h"

#import "logisticInfoModel.h"

#import "sallerLogisticInfo.h"

#import "goodsOrderDetailViewController.h"
#import "refundViewController.h"
@interface refundDetailViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSString *jishu;
@property (nonatomic, strong) NSString *returnAddress;//退货地址
@property (nonatomic, strong) NSString *returnPerson;//收货商家姓名
@property (nonatomic, strong) NSString *returnMobile;//收货商家电话
@property (nonatomic, assign) NSInteger goodsState;//是否需要退货
@property (nonatomic, assign) BOOL isSend;//是否寄出

@property (nonatomic, strong) NSString *logisticInfo;
@property (nonatomic, strong) NSString *logisticName;
@property (nonatomic, strong) NSString *logisticTime;

@property (nonatomic, strong) logisticInfoModel *logisticModel;

@property (nonatomic, strong) sallerLogisticInfo *sallerInfoModel;
@end


@implementation refundDetailViewController
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = tableViewBgColor;
        //        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.tableFooterView = [UIView new];
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
        [_tableView registerNib:[UINib nibWithNibName:@"refundDetailTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"refundDetailTableViewCell"];
        
        [_tableView registerNib:[UINib nibWithNibName:@"refundDetailTwoTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"refundDetailTwoTableViewCell"];
        
        [_tableView registerNib:[UINib nibWithNibName:@"refundDetailThreeTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"refundDetailThreeTableViewCell"];
        
        [_tableView registerNib:[UINib nibWithNibName:@"refundFourTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"refundFourTableViewCell"];
        
        [_tableView registerNib:[UINib nibWithNibName:@"refundSuccessTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"refundSuccessTableViewCell"];
        
        [_tableView registerNib:[UINib nibWithNibName:@"refundInfoTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"refundInfoTableViewCell"];
        
    }
    return _tableView;
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.isWhiteNavi = YES;
    self.title = @"退款详情";
    self.view.backgroundColor = tableViewBgColor;
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.naviBarView];
    self.navigationItem.leftBarButtonItem = self.backItem;
    
    if (self.type == 2) {
        if ([self.model.goodsState isEqualToString:@"0"]) {//0退货退款 1.未收到货 2.已收到货
            self.goodsState = [self.model.goodsState integerValue];
            if ([Utils isBlankString:self.model.returnLogisticNo]) {
                //未退货 查询退货地址
                [self checkReturnAddress];
                self.isSend = NO;
            }else {
                //已退货
                self.isSend = YES;
                [self checkLogisticInfo];
            }
        }else {
            self.goodsState = 1;
        }
    }
    if (self.type == 3) {
        if ([Utils isBlankString:self.model.returnLogisticNo]) {
            [self checkLogisticInfo];
        }else {
            self.logisticModel = [logisticInfoModel new];
            self.logisticModel.context = @"未查询到物流信息！";
            self.logisticModel.time = @" ";
        }
    }
    if (self.type == 1) {
        self.navigationController.swipeBackEnabled = NO;
    }
    [self.tableView reloadData];
}

- (void)clickBackItemToPop {
    if (self.type == 1) {
        NSArray *vcs = [self.navigationController viewControllers];
        goodsOrderDetailViewController *vc = vcs[2];
        [self.navigationController popToViewController:vc animated:YES];
//        [self.navigationController popViewControllerAnimated:YES];
//        if (self.refreshBlock) {
//            self.refreshBlock();
//        }
        
        self.navigationController.swipeBackEnabled = YES;
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}

- (void)checkReturnAddress {
    [[ZLJNetWorkManager defaultManager] sendRequestMethod:HTTPMethodPOST isLogin:NO isJsonRequest:NO serverUrl:requestHost apiPath:returnAddressUrl parameters:@{@"goodId":self.model.goods_id} progress:^(NSProgress * _Nullable progress) {
        
    } success:^(BOOL isSuccess, id  _Nullable responseObject) {
        NSDictionary *data = [NSDictionary changeType:responseObject];
        NSString *code = data[@"code"];
        NSString *msg = data[@"message"];
        if ([code isEqualToString:@"200"]) {
            NSDictionary *dataDic = data[@"data"];
            self.sallerInfoModel = [sallerLogisticInfo mj_objectWithKeyValues:dataDic];
            self.returnAddress = [NSString stringWithFormat:@"%@%@%@%@",dataDic[@"pro"],dataDic[@"city"],dataDic[@"area"],dataDic[@"des"]];
            self.returnPerson = dataDic[@"receivePerson"];
            self.returnMobile = dataDic[@"receivePhone"];
            [self.tableView reloadData];
        }else {
            [MBProgressHUD showError:msg toView:self.view];
        }
    } failure:^(NSString * _Nullable errorMessage) {
        [MBProgressHUD showError:errorMessage toView:self.view];
    }];
}

- (void)checkLogisticInfo{
    [[ZLJNetWorkManager defaultManager] sendRequestMethod:HTTPMethodPOST isLogin:NO isJsonRequest:NO serverUrl:requestHost apiPath:logisticInfoUrl parameters:@{@"logisticCode":self.model.returnLogisticCode,@"logisticNo":self.model.returnLogisticNo} progress:^(NSProgress * _Nullable progress) {
        
    } success:^(BOOL isSuccess, id  _Nullable responseObject) {
        NSDictionary *data = [NSDictionary changeType:responseObject];
        NSString *code = data[@"code"];
        NSString *msg = data[@"message"];
        if ([code isEqualToString:@"200"]) {
            NSDictionary *logisticInfo = [NSDictionary dictionaryWithJsonString:data[@"data"]];
            
            NSMutableArray *logistics = [logisticInfoModel mj_objectArrayWithKeyValuesArray:logisticInfo];
            self.logisticModel = [logisticInfoModel new];
            if (logistics.count) {
                self.logisticModel = logistics[0];
            }else {
                self.logisticModel.context = @"未查询到物流信息！";
                self.logisticModel.time = @" ";
            }
            [self.tableView reloadData];
        }else {
            [MBProgressHUD showError:msg toView:self.view];
        }
        
    } failure:^(NSString * _Nullable errorMessage) {
        [MBProgressHUD showError:errorMessage toView:self.view];
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        
        if (self.type == 4) {
            return 3;
        }
        return 2;
    }
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            refundDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"refundDetailTableViewCell" forIndexPath:indexPath];
            
            if (![Utils isBlankString:self.model.updateTime]) {
                NSString *dateStr = [NSString isoTimeToStringWithDateString:self.model.updateTime];
                cell.timeLb.text = dateStr;
            }else{
                cell.timeLb.text = @"";
            }
            
            switch (self.type) {
                case 1:
                    
                    break;
                case 2:
                {
                    cell.titleLb.text = @"请退货并填写物流信息";
                    if (self.goodsState == 1) {
                        cell.titleLb.text = @"卖家已同意退款";
                    }else {
                        if (self.isSend) {
                            cell.titleLb.text = @"请等待商家收货并退款";
                        }else {
                            cell.titleLb.text = @"请退货并填写物流信息";
                        }
                    }
                }
                    break;
                case 3:
                    cell.titleLb.text = @"请等待商家收货并退款";
                    break;
                case 4:
                    cell.titleLb.text = @"退款成功";
                    break;
                case 5:
                    cell.titleLb.text = @"退款申请已撤销";
                    break;
                case 6:
                    cell.titleLb.text = @"商家拒绝退款";
                    break;
                case 7:
                    cell.titleLb.text = @"申请退款失败";
                    break;
                default:
                    break;
            }
            return cell;
        } else {
            switch (self.type) {
                case 1:
                {
                    refundDetailTwoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"refundDetailTwoTableViewCell" forIndexPath:indexPath];

                    cell.cancelBlock = ^{
                        [self cancelRefundApply];
                    };
                    cell.modifyBlock = ^{
                        [self modifyRefundApply];
                    };
                    return cell;

                }
                    break;
                case 2:
                {
                    if (self.goodsState == 1) {
                        refundDetailTwoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"refundDetailTwoTableViewCell" forIndexPath:indexPath];
                        
                        cell.cancelBtn.hidden = YES;
                        
                        cell.modifyBtn.layer.masksToBounds = YES;
                        cell.modifyBtn.layer.borderWidth = 0.7;
                        cell.modifyBtn.layer.borderColor = RGB(70, 70, 70).CGColor;
                        [cell.modifyBtn setTitle:@"撤销申请" forState:UIControlStateNormal];
                        [cell.modifyBtn setTitleColor:RGB(70, 70, 70) forState:UIControlStateNormal];
                        
                        cell.titleLb.text = @"商家已同意退款申请，请等待商家退款";
                        
                        cell.oneLb.hidden = YES;
                        cell.OnePointView.hidden = YES;
                        cell.twoLb.hidden = YES;
                        cell.twoPointView.hidden = YES;
                        cell.cancelBlock = ^{
                            [self cancelRefundApply];
                        };
                        cell.modifyBlock = ^{
                            [self cancelRefundApply];
                        };
                        return cell;
                    }else {
                        if (![Utils isBlankString:self.model.returnLogisticNo]) {
                            refundFourTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"refundFourTableViewCell" forIndexPath:indexPath];
                            cell.logisticsNameLb.text = [NSString stringWithFormat:@"退货物流：%@",self.model.returnLogisticName];
                            cell.logisticsDetailLb.text = self.logisticModel.context;
                            cell.logisticTimeLb.text = self.logisticModel.time;
                            cell.cancelApplyBtn.hidden = YES;
                            return cell;
                        }else {
                            refundDetailThreeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"refundDetailThreeTableViewCell" forIndexPath:indexPath];
                            
                            cell.fillInBtnBlock = ^{
                                refundLogisticsViewController *Logistics = [refundLogisticsViewController new];
                                Logistics.model = self.model;
                                Logistics.completeBlock = ^(orderModel * _Nonnull model) {
                                    self.model = model;
                                    self.isSend = YES;
                                    [self checkLogisticInfo];
                                };
//                                Logistics.completeBlock = ^{
//                                    [self.navigationController popViewControllerAnimated:YES];
//                                };
                                [self.navigationController pushViewController:Logistics animated:YES];
                            };
                            if ([Utils isBlankString:self.returnPerson]) {
                                self.returnPerson = @" ";
                            }
                            if ([Utils isBlankString:self.returnAddress]) {
                                self.returnAddress = @" ";
                            }
                            //未退货 查询退货地址
                            cell.consigneeLb.text = [NSString stringWithFormat:@"收件人：%@",self.returnPerson];
                            cell.mobileLb.text = self.returnMobile;
                            cell.placeLb.text = [NSString stringWithFormat:@"收货地址：%@",self.returnAddress];
                            
                            return cell;
                        }
                        
                    }
                    
                }
                    break;
                case 3:
                {
                    refundFourTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"refundFourTableViewCell" forIndexPath:indexPath];
                    cell.cancelApplyBtn.hidden = YES;
                    cell.logisticsNameLb.text = [NSString stringWithFormat:@"退货物流：%@",self.model.returnLogisticName];
                    cell.logisticsDetailLb.text = self.logisticModel.context;
                    cell.logisticTimeLb.text = self.logisticModel.time;
                    return cell;
                }
                    break;
                case 4:
                {
                    refundSuccessTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"refundSuccessTableViewCell" forIndexPath:indexPath];
                    if (indexPath.row == 1) {
                        cell.titleLb.text = @"退回总金额：";
                        cell.contentLb.textColor = myRed;
                        cell.contentLb.text = [NSString stringWithFormat:@"¥%.2f",[self.model.returnMoney doubleValue]];
                    }else {
                        if ([self.model.pay_type integerValue] == 1) {
                            cell.titleLb.text = @"退回支付宝：";
                        }else if ([self.model.pay_type integerValue] == 2) {
                            cell.titleLb.text = @"退回微信：";
                        }else {
                            cell.titleLb.text = @"退回银行卡：";
                        }
                        cell.contentLb.textColor = myGrayColor;
                        cell.contentLb.text = [NSString stringWithFormat:@"¥%.2f",[self.model.returnMoney doubleValue]];
                    }
                    return cell;
                }
                    break;
                case 5:
                case 6:
                case 7:
                {
                    refundDetailTwoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"refundDetailTwoTableViewCell" forIndexPath:indexPath];
                    cell.cancelBtn.hidden = YES;
                    if (self.type == 5) {
                        cell.titleLb.text = @"退款申请已撤销，可以修改申请再次提交";
                    }else if (self.type == 6){
                        cell.titleLb.text = @"商家拒绝了您的退款申请，请联系商家，或修改申请";
                    }else {
                        cell.titleLb.text = @"退款申请失败，请联系商家，或修改申请再次提交";
                    }
                    
                    cell.oneLb.hidden = YES;
                    cell.OnePointView.hidden = YES;
                    cell.twoLb.hidden = YES;
                    cell.twoPointView.hidden = YES;
                    cell.cancelBlock = ^{
                        [self cancelRefundApply];
                    };
                    cell.modifyBlock = ^{
                        [self modifyRefundApply];
                    };
                    return cell;
                }
                    break;
                default:
                    break;
            }
            

        }
    }else {
        refundInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"refundInfoTableViewCell" forIndexPath:indexPath];
        cell.model = self.model;
        return cell;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (indexPath.row == 1) {
            switch (self.type) {
                case 1:
                    return 180;
                    break;
                case 2:
                {
                    
                    if (self.isSend) {
                        return 210;
                    }else if (self.goodsState == 1){
                        return 100;
                    }else {
                        return 340;
                    }

                }
                    break;
                case 3:
                    return 210;
                    break;
                case 4:
                    return 44;
                    break;
                case 5:
                case 6:
                case 7:
                    return 100;
                    break;
                    
                default:
                    return 44;
                    break;
            }
        }else if (indexPath.row == 2){
            return 44;
        }
        return 90;
    }
    return 270;
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
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 10)];
    view.backgroundColor = FXBGColor;
    return view;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return nil;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 1) {
        
    }
}

#pragma mark == 撤销申请
- (void)cancelRefundApply {
    [[ZLJNetWorkManager defaultManager] sendRequestMethod:HTTPMethodPOST isLogin:NO isJsonRequest:NO serverUrl:requestHost apiPath:cancelRefundUrl parameters:@{@"returnId":self.model.returnId,@"orderDetailId":self.model.order_detail_id} progress:^(NSProgress * _Nullable progress) {
        
    } success:^(BOOL isSuccess, id  _Nullable responseObject) {
        NSDictionary *data = [NSDictionary changeType:responseObject];
        NSString *code = data[@"code"];
        NSString *msg = data[@"message"];
        if ([code integerValue] == 200) {
            [MBProgressHUD showSuccess:@"撤销成功!" toView:self.navigationController.view];
            //需要重新加载我的订单列表
            [FXObjManager dc_saveUserData:@"0" forKey:BOOLLoadMyOrder];
            if (self.fromWhere == 1) {
                NSArray *vcs = [self.navigationController viewControllers];
                goodsOrderDetailViewController *vc = vcs[2];
                [self.navigationController popToViewController:vc animated:YES];
            }else {
                [self.navigationController popViewControllerAnimated:YES];
            }
            
        }else {
            [MBProgressHUD showError:msg toView:self.view];
        }
    } failure:^(NSString * _Nullable errorMessage) {
        [MBProgressHUD showError:errorMessage toView:self.view];
    }];
}
#pragma mark == 修改申请
- (void)modifyRefundApply {
    if (self.fromWhere == 1) {
        if (self.modifyBlock) {
            self.modifyBlock(self.model);
        }
        [self.navigationController popViewControllerAnimated:YES];
        
    }else {
        if (self.type == 5) {
            refundViewController *refundVC = [refundViewController new];
            refundVC.model = self.model;
            
            [self.navigationController pushViewController:refundVC animated:YES];

        }else {
            refundApplyViewController *refundApply = [refundApplyViewController new];
            refundApply.model = self.model;
            refundApply.fromWhere = 2;
            [self.navigationController pushViewController:refundApply animated:YES];
        }
    }
    
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
