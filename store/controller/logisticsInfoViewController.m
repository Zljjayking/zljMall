//
//  logisticsInfoViewController.m
//  Distribution
//
//  Created by hchl on 2018/8/11.
//  Copyright © 2018年 hchl. All rights reserved.
//

#import "logisticsInfoViewController.h"
#import "logisticsNowTableViewCell.h"
#import "logisticsHeadTableViewCell.h"
#import "logisticsBeforTableViewCell.h"
#import "logisticInfoModel.h"
@interface logisticsInfoViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArr;
@end

@implementation logisticsInfoViewController
static NSString *logisticsNowTableViewCellID = @"logisticsNowTableViewCell";
static NSString *logisticsHeadTableViewCellID = @"logisticsHeadTableViewCell";
static NSString *logisticsBeforTableViewCellID = @"logisticsBeforTableViewCell";
- (UITableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [UIView new];
        _tableView.backgroundColor = FXBGColor;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
        
        [_tableView registerNib:[UINib nibWithNibName:logisticsNowTableViewCellID bundle:[NSBundle mainBundle]] forCellReuseIdentifier:logisticsNowTableViewCellID];
        
        [_tableView registerNib:[UINib nibWithNibName:logisticsHeadTableViewCellID bundle:[NSBundle mainBundle]] forCellReuseIdentifier:logisticsHeadTableViewCellID];
        
        [_tableView registerNib:[UINib nibWithNibName:logisticsBeforTableViewCellID bundle:[NSBundle mainBundle]] forCellReuseIdentifier:logisticsBeforTableViewCellID];
    }
    return _tableView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"物流信息";
    if (self.type == 2) {
        [self requestData];
    } else {
        [self setUpUI];
    }
    
    
}
- (void)setUpUI {
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.naviBarView];
    self.naviBarView.alpha = 1;
    self.navigationItem.leftBarButtonItem = self.backItem;
    
    self.blankV = [[blankView alloc]initWithFrame:CGRectMake(kScreenWidth/2.0-40, self.view.center.y/2.0-0, 80, 80) imageName:@"noData" title:@"暂无物流信息"];
    
    [self.tableView addSubview:self.blankV];
    self.blankV.hidden = YES;
    if (self.logisticArr.count == 0) {
        self.blankV.hidden = NO;
    }
    
    
}
- (void)requestData {
    [MBProgressHUD showMessage:@"加载中..."];
    [[ZLJNetWorkManager defaultManager]sendRequestMethod:HTTPMethodPOST isLogin:NO isJsonRequest:NO serverUrl:requestHost apiPath:logisticInfoUrl parameters:@{@"logisticCode":self.logisticCode,@"logisticNo":self.logistic_no} progress:^(NSProgress * _Nullable progress) {
        
    } success:^(BOOL isSuccess, id  _Nullable responseObject) {
        [MBProgressHUD hideHUD];
        NSDictionary *dataDic = [NSDictionary changeType:responseObject];
        if (dataDic) {
            NSString *code = dataDic[@"code"];
            NSString *message = dataDic[@"message"];
            if ([code integerValue] == 200) {
                NSDictionary *logisticInfo = [NSDictionary dictionaryWithJsonString:dataDic[@"data"]];
                self.logisticArr = [logisticInfoModel mj_objectArrayWithKeyValuesArray:logisticInfo[@"data"]];
                [self setUpUI];
            } else {
                [MBProgressHUD showError:message toView:self.navigationController.view];
            }
        }else {
            [MBProgressHUD showError:myRequestError toView:self.navigationController.view];
        }
    } failure:^(NSString * _Nullable errorMessage) {
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:errorMessage toView:self.navigationController.view];
    }];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    }else {
        return self.logisticArr.count;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 62;
    } else {
        if (indexPath.row == 0) {
            return 105;
        }
    }
    return 72;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 0) {
        return 10;
    }
    return 0.01;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if (section == 0) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 10)];
        view.backgroundColor = FXBGColor;
        return view;
    }
    return nil;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return nil;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        logisticsHeadTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:logisticsHeadTableViewCellID forIndexPath:indexPath];
        cell.nameLb.text = self.logistic_name;
        cell.numLb.text = self.logistic_no;
        return cell;
    } else {
        logisticInfoModel *model = self.logisticArr[indexPath.row];
        if (indexPath.row == 0) {
            logisticsNowTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:logisticsNowTableViewCellID forIndexPath:indexPath];
            cell.titleLb.text = model.context;
            cell.timeLb.text = model.time;
            return cell;
        } else {
            logisticsBeforTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:logisticsBeforTableViewCellID forIndexPath:indexPath];
            if (indexPath.row == self.logisticArr.count-1) {
                cell.nextView.hidden = YES;
            } else {
                cell.nextView.hidden = NO;
            }
            cell.titleLb.text = model.context;
            cell.timeLb.text = model.time;
            return cell;
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
