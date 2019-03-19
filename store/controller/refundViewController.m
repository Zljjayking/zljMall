//
//  refundViewController.m
//  Distribution
//
//  Created by hchl on 2018/11/15.
//  Copyright © 2018年 hchl. All rights reserved.
//

#import "refundViewController.h"
#import "orderGoodsTableViewCell.h"
#import "ServiceTypeTableViewCell.h"


#import "refundApplyViewController.h"

@interface refundViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@end

@implementation refundViewController
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-(isIphoneX?tabHeight:50)) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = RGB(241, 243, 246);
        //        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.tableFooterView = [UIView new];
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
        [_tableView registerNib:[UINib nibWithNibName:@"orderGoodsTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"orderGoodsTableViewCell"];
        [_tableView registerNib:[UINib nibWithNibName:@"ServiceTypeTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"ServiceTypeTableViewCell"];
        
    }
    return _tableView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.isWhiteNavi = YES;
    self.title = @"选择服务类型";
    self.view.backgroundColor = RGB(241, 243, 246);
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.naviBarView];
    self.navigationItem.leftBarButtonItem = self.backItem;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    }
    return 2;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        orderGoodsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"orderGoodsTableViewCell" forIndexPath:indexPath];
        cell.refundBtn.hidden = YES;
        cell.ordermodel = self.model;
        cell.refundStateLb.hidden = YES;
        return cell;
    }else {
        ServiceTypeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ServiceTypeTableViewCell" forIndexPath:indexPath];
        if (indexPath.row == 1) {
            cell.imageV.image = [UIImage imageNamed:@"tuiKuan"];
            cell.titleLb.text = @"仅退款";
            cell.contentLb.text = @"未收到货(包含未签收)，或与卖家协商同意仅退款";
        }
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 86;
    }
    return 70;
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
        refundApplyViewController *apply = [refundApplyViewController new];
        apply.model = self.model;
        apply.type = indexPath.row+1;
        apply.fromWhere = 1;
        [self.navigationController pushViewController:apply animated:YES];
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
