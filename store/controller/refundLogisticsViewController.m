//
//  refundLogisticsViewController.m
//  Distribution
//
//  Created by hchl on 2018/11/15.
//  Copyright © 2018年 hchl. All rights reserved.
//

#import "refundLogisticsViewController.h"
#import "orderGoodsTableViewCell.h"
#import "refundReasonTableViewCell.h"
#import "fillInLogisticTableViewCell.h"

#import "popUpView.h"

#import "logisticsCompanyModel.h"
@interface refundLogisticsViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) popUpView *logisticPopView;
@property (nonatomic, assign) NSInteger selectLogistic;
@property (nonatomic, strong) NSDictionary *selectLogisticDic;
@property (nonatomic, strong) NSMutableArray *logisticsArr;
@end

@implementation refundLogisticsViewController
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-(isIphoneX?89:50)) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = tableViewBgColor;
        //        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.tableFooterView = [UIView new];
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
        [_tableView registerNib:[UINib nibWithNibName:@"orderGoodsTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"orderGoodsTableViewCell"];
        
        [_tableView registerNib:[UINib nibWithNibName:@"refundReasonTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"refundReasonTableViewCell"];
        
        [_tableView registerNib:[UINib nibWithNibName:@"fillInLogisticTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"fillInLogisticTableViewCell"];
        
//        [_tableView registerNib:[UINib nibWithNibName:@"refundFourTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"refundFourTableViewCell"];
//        
//        [_tableView registerNib:[UINib nibWithNibName:@"refundSuccessTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"refundSuccessTableViewCell"];
//        
//        [_tableView registerNib:[UINib nibWithNibName:@"refundInfoTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"refundInfoTableViewCell"];
        
    }
    return _tableView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.isWhiteNavi = YES;
    self.title = @"填写退货物流";
    self.view.backgroundColor = tableViewBgColor;
    
    [self requestLogisticInfo];
    
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.naviBarView];
    self.navigationItem.leftBarButtonItem = self.backItem;
    [self setupBottomView];
}
- (void)requestLogisticInfo {
    [[ZLJNetWorkManager defaultManager]sendRequestMethod:HTTPMethodPOST isLogin:NO isJsonRequest:NO serverUrl:requestHost apiPath:checkLogisticCompanyUrl parameters:nil progress:^(NSProgress * _Nullable progress) {
        
    } success:^(BOOL isSuccess, id  _Nullable responseObject) {
        NSDictionary *data = [NSDictionary changeType:responseObject];
        NSString *code = data[@"code"];
        NSString *msg = data[@"message"];
        if ([code isEqualToString:@"200"]) {
            id dataArr = data[@"data"];
            if ([dataArr isKindOfClass:[NSArray class]]) {
                
            }
            self.logisticsArr = [logisticsCompanyModel mj_objectArrayWithKeyValuesArray:(NSArray *)dataArr];
            [self setLogisticPopViewWithReasonArr:self.logisticsArr];
        }else{
            [MBProgressHUD showError:msg toView:self.view];
        }
    } failure:^(NSString * _Nullable errorMessage) {
        [MBProgressHUD showError:errorMessage toView:self.view];
    }];
}
- (void)setLogisticPopViewWithReasonArr:(NSArray *)refundReasonArr {
    self.selectLogistic = 1;
    NSMutableDictionary *dic = @{@"signImage":@"",@"title":@"请选择货物状态",@"isSelect":@"0",@"isImage":@"0",@"kindCode":@"0",@"describe":@"无"}.mutableCopy;
    NSMutableArray *popDataArr = @[].mutableCopy;
    [popDataArr addObject:dic];
    for ( int i=0 ;i<refundReasonArr.count;i++) {
        logisticsCompanyModel *logisticsModel = refundReasonArr[i];
        NSMutableDictionary *dic;
        if (i == 0) {
            dic = @{@"signImage":@"zhifubao_iconn",@"title":logisticsModel.describe,@"isSelect":@"1",@"isImage":@"0",@"kindCode":logisticsModel.logisticCode,@"describe":logisticsModel.describe}.mutableCopy;
            
        }else {
            dic = @{@"signImage":@"zhifubao_iconn",@"title":logisticsModel.describe,@"isSelect":@"0",@"isImage":@"0",@"kindCode":logisticsModel.logisticCode,@"describe":logisticsModel.describe}.mutableCopy;
        }
        
        [popDataArr addObject:dic];
    }
    
    self.logisticPopView = [[popUpView alloc] initWithFrame:CGRectMake(0, kScreenHeight, kScreenWidth, (popDataArr.count-1)*44+30+73) dataSource:popDataArr];
    self.logisticPopView.frame = CGRectMake(0, kScreenHeight, kScreenWidth, (popDataArr.count-1)*44+30+73);
    self.logisticPopView.bgView.hidden = YES;
    [self.logisticPopView.closeBtn setTitle:@"确定" forState:UIControlStateNormal];
//    [self.logisticPopView.closeBtn addTarget:self action:@selector(sureBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    
    [self.view addSubview:self.logisticPopView.bgView];
    [self.view addSubview:self.logisticPopView];
    
    WEAKSELF
    self.logisticPopView.hideBlock = ^{
        [UIView animateWithDuration:0.2 animations:^{
            weakSelf.logisticPopView.frame = CGRectMake(0, kScreenHeight, kScreenWidth, weakSelf.logisticPopView.height);
        } completion:^(BOOL finished) {
            weakSelf.logisticPopView.bgView.hidden = YES;
        }];
    };
    self.logisticPopView.closeBlock = ^{
        [UIView animateWithDuration:0.2 animations:^{
            weakSelf.logisticPopView.frame = CGRectMake(0, kScreenHeight, kScreenWidth, weakSelf.logisticPopView.height);
        } completion:^(BOOL finished) {
            weakSelf.logisticPopView.bgView.hidden = YES;
        }];
        
        NSMutableDictionary *dic = popDataArr[weakSelf.selectLogistic];
        weakSelf.selectLogisticDic = @{@"logisticName":dic[@"title"],@"logisticCode":dic[@"kindCode"]};
        //        self.applyModel.refundCause =
        [weakSelf.tableView reloadData];
    };
    self.logisticPopView.chooseblock = ^(NSInteger index) {
        weakSelf.selectLogistic = index;
        
    };
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 1) {
        return 2;
    }
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        orderGoodsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"orderGoodsTableViewCell" forIndexPath:indexPath];
        cell.refundBtn.hidden = YES;
        cell.ordermodel = self.model;
        cell.refundStateLb.hidden = YES;
        return cell;
    }else if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            refundReasonTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"refundReasonTableViewCell" forIndexPath:indexPath];
            cell.titleLb.text = @"物流公司";
            cell.contentLb.text = @"请选择物流公司";
            if (![Utils isBlankString:self.selectLogisticDic[@"logisticName"]]) {
                cell.contentLb.text = self.selectLogisticDic[@"logisticName"];
            }
            
            return cell;
        } else {
            fillInLogisticTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"fillInLogisticTableViewCell" forIndexPath:indexPath];
            cell.contentTf.keyboardType = UIKeyboardTypeNumberPad;
            cell.contentTf.tag = 100;
            return cell;
        }
    } else {
        fillInLogisticTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"fillInLogisticTableViewCell" forIndexPath:indexPath];
        cell.contentTf.keyboardType = UIKeyboardTypeNumberPad;
        cell.contentTf.tag = 200;
        cell.titleLb.text = @"联系电话：";
        cell.contentTf.placeholder = @"请填写手机号";
        return cell;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        
        return 86;
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
        if (indexPath.row == 0) {
            [UIView animateWithDuration:0.2 animations:^{
                self.logisticPopView.bgView.hidden = NO;
                self.logisticPopView.frame = CGRectMake(0, kScreenHeight - self.logisticPopView.height, kScreenWidth, self.logisticPopView.height);
            } completion:^(BOOL finished) {
                
            }];
        }
        
    }
}

- (void)setupBottomView {
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, kScreenHeight-(isIphoneX?89:50), kScreenWidth, 50)];
    [self.view addSubview:bottomView];
    bottomView.backgroundColor = myWhite;
    
    UIButton *tijiao = [UIButton buttonWithType:UIButtonTypeCustom];
    [tijiao setTitle:@"提交" forState:UIControlStateNormal];
    tijiao.frame = CGRectMake(30, 7.5, kScreenWidth-60, 35);
    tijiao.layer.masksToBounds = YES;
    tijiao.layer.cornerRadius = 17.5;
    tijiao.backgroundColor = myBlueBg;
    [bottomView addSubview:tijiao];
    [tijiao addTarget:self action:@selector(submitClick) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)submitClick {
    
    if ([Utils isBlankString:self.selectLogisticDic[@"logisticCode"]]) {
        [MBProgressHUD showError:@"请选择物流公司" toView:self.view];
        return ;
    }
    //物流单号
    UITextField *textFieldOne = [self.tableView viewWithTag:100];
    if (!textFieldOne.text.length) {
        [MBProgressHUD showError:@"请填写物流单号" toView:self.view];
        return ;
    }
    //联系电话
    UITextField *textFieldTwo = [self.tableView viewWithTag:200];
    if (!textFieldTwo.text.length) {
        [MBProgressHUD showError:@"请填写手机号码" toView:self.view];
        return ;
    }
    
    NSDictionary *parameter = @{@"id":self.model.returnId,@"logisticName":self.selectLogisticDic[@"logisticName"],@"logisticNo":self.selectLogisticDic[@"logisticCode"],@"logisticCode":textFieldOne.text,@"tel":textFieldTwo.text};
    [[ZLJNetWorkManager defaultManager]sendRequestMethod:HTTPMethodPOST isLogin:NO isJsonRequest:YES serverUrl:requestHost apiPath:submitRefundUrl parameters:parameter progress:^(NSProgress * _Nullable progress) {
        
    } success:^(BOOL isSuccess, id  _Nullable responseObject) {
        NSDictionary *data = [NSDictionary changeType:responseObject];
        NSString *code = data[@"code"];
        NSString *msg = data[@"message"];
        if ([code integerValue] == 200) {
            [MBProgressHUD showSuccess:msg toView:self.navigationController.view];
            
            [self.navigationController popViewControllerAnimated:YES];
            if (self.completeBlock) {
                self.model.returnLogisticNo = textFieldOne.text;
                self.model.returnLogisticName = self.selectLogisticDic[@"logisticName"];
                self.model.returnLogisticCode = self.selectLogisticDic[@"logisticCode"];
                self.completeBlock(self.model);
            }
        }else {
            [MBProgressHUD showError:msg toView:self.view];
        }
    } failure:^(NSString * _Nullable errorMessage) {
        [MBProgressHUD showError:errorMessage toView:self.view];
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
