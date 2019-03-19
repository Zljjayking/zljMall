//
//  myGroupOrderViewController.m
//  Distribution
//
//  Created by hchl on 2019/1/1.
//  Copyright © 2019年 hchl. All rights reserved.
//

#import "myGroupOrderViewController.h"
#import "popUpView.h"
#import "myOrderTableViewCell.h"
#import "myOrderTwoTableViewCell.h"
#import "myOrderThreeTableViewCell.h"
#import "goodsOrderDetailViewController.h"
#import "logisticsInfoViewController.h"
#import "paySuccessViewController.h"
#import "shoppingCartViewController.h"
#import "baseSearchViewController.h"
#import "myGroupModel.h"
#import <AlipaySDK/AlipaySDK.h>
#import "shoppingCartModel.h"
#import "searchGroupOrderVC.h"
#import "groupingViewController.h"
#import "googsInfoViewController.h"
@interface myGroupOrderViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, strong) UIView *topView;
@property (nonatomic, strong) UIView *smallLine;
@property (nonatomic, strong) NSString *orderStatus;
@property (nonatomic, strong) popUpView *popView;
@property (nonatomic, assign) NSInteger selectIndex;
@property (nonatomic, strong) NSString *orderNo;
@property (nonatomic, strong) NSString *orderId;
@property (nonatomic, strong) popUpView *popUView;
@property (nonatomic, assign) double allPrice;
@property (nonatomic, strong) NSString *payType;
@property (nonatomic, strong) NSString *typeStr;
@property (nonatomic, strong) shoppingCartModel *goodsModel;
@property (nonatomic, strong) myGroupModel *selectGroupModel;
@property (nonatomic, strong) NSString *shareUrlStr;
@end

@implementation myGroupOrderViewController
static NSString *myOrderTableViewCellID = @"myOrderTableViewCell";
static NSString *myOrderTwoTableViewCellID = @"myOrderTwoTableViewCell";
static NSString *myOrderThreeTableViewCellID = @"myOrderThreeTableViewCell";

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = FXBGColor;
        _tableView.tableFooterView = [UIView new];
        _tableView.mj_header = [FXRefreshGifHeader headerWithRefreshingBlock:^{
            self.page = 1;
            [self requestData];
        }];
        _tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            self.page = 1+self.page;
            [self requestData];
        }];
        [_tableView registerNib:[UINib nibWithNibName:myOrderTableViewCellID bundle:[NSBundle mainBundle]] forCellReuseIdentifier:myOrderTableViewCellID];
        [_tableView registerNib:[UINib nibWithNibName:myOrderTwoTableViewCellID bundle:[NSBundle mainBundle]] forCellReuseIdentifier:myOrderTwoTableViewCellID];
        [_tableView registerNib:[UINib nibWithNibName:myOrderThreeTableViewCellID bundle:[NSBundle mainBundle]] forCellReuseIdentifier:myOrderThreeTableViewCellID];
    }
    return _tableView;
}
- (UIView *)topView {
    if (!_topView) {
        _topView = [[UIView alloc] initWithFrame:CGRectMake(0, naviHeight, kScreenWidth, 40)];
        _topView.backgroundColor = myWhite;
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 40-0.5, kScreenWidth, 0.5)];
        [_topView addSubview:line];
        line.backgroundColor = RGB(240, 240, 240);
        
        CGFloat leftAndRightMargin = 20*KAdaptiveRateWidth;
        CGFloat btnW = 45;
        CGFloat btnH = 35;
        CGFloat seperator = (kScreenWidth - leftAndRightMargin*2 - btnW*5)/4.0;
        
        UIButton *allBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        allBtn.tag = 1;
        allBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        allBtn.frame = CGRectMake(leftAndRightMargin, 6, btnW, btnH);
        [allBtn setTitle:@"全部" forState:UIControlStateNormal];
        [allBtn setTitleColor:myGrayColor forState:UIControlStateNormal];
        [allBtn setTitleColor:myBlueType forState:UIControlStateSelected];
        allBtn.selected = YES;
        [_topView addSubview:allBtn];
        [allBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        UIButton *chuangKeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        chuangKeBtn.tag = 2;
        chuangKeBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        chuangKeBtn.frame = CGRectMake(leftAndRightMargin+btnW+seperator, 6, btnW, btnH);
        [chuangKeBtn setTitle:@"待付款" forState:UIControlStateNormal];
        [chuangKeBtn setTitleColor:myGrayColor forState:UIControlStateNormal];
        [chuangKeBtn setTitleColor:myBlueType forState:UIControlStateSelected];
        chuangKeBtn.selected = NO;
        [_topView addSubview:chuangKeBtn];
        [chuangKeBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        UIButton *puTongBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        puTongBtn.tag = 3;
        puTongBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        puTongBtn.frame = CGRectMake(leftAndRightMargin+btnW*2+seperator*2, 6, btnW, btnH);
        [puTongBtn setTitle:@"待成团" forState:UIControlStateNormal];
        [puTongBtn setTitleColor:myGrayColor forState:UIControlStateNormal];
        [puTongBtn setTitleColor:myBlueType forState:UIControlStateSelected];
        puTongBtn.selected = NO;
        [_topView addSubview:puTongBtn];
        [puTongBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        UIButton *daishouBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        daishouBtn.tag = 4;
        daishouBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        daishouBtn.frame = CGRectMake(leftAndRightMargin+btnW*3+seperator*3, 6, btnW, btnH);
        [daishouBtn setTitle:@"已成功" forState:UIControlStateNormal];
        [daishouBtn setTitleColor:myGrayColor forState:UIControlStateNormal];
        [daishouBtn setTitleColor:myBlueType forState:UIControlStateSelected];
        daishouBtn.selected = NO;
        [_topView addSubview:daishouBtn];
        [daishouBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        UIButton *guoqiBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        guoqiBtn.tag = 5;
        guoqiBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        guoqiBtn.frame = CGRectMake(leftAndRightMargin+btnW*4+seperator*4, 6, btnW, btnH);
        [guoqiBtn setTitle:@"已过期" forState:UIControlStateNormal];
        [guoqiBtn setTitleColor:myGrayColor forState:UIControlStateNormal];
        [guoqiBtn setTitleColor:myBlueType forState:UIControlStateSelected];
        guoqiBtn.selected = NO;
        [_topView addSubview:guoqiBtn];
        [guoqiBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        UIView *bgV = [[UIView alloc] initWithFrame:CGRectMake(leftAndRightMargin+2.5, 40-1, btnW-5, 1)];
        bgV.backgroundColor = myBlueType;
        [_topView addSubview:bgV];
        self.smallLine = bgV;
    }
    return _topView;
}
- (void)btnClick:(UIButton *)sender {
    [UIView animateWithDuration:0.2 animations:^{
        self.smallLine.frame = CGRectMake(sender.x+2.5, 39, 40, 1);
    }];
    
    for (int i=0; i<5; i++) {
        UIButton *btn = [self.topView viewWithTag:i+1];
        btn.selected = NO;
    }
    sender.selected = !sender.selected;
    switch (sender.tag) {
        case 1:
        {
            self.typeStr = @"4";
        }
            break;
        case 2:
        {
            self.typeStr = @"3";
        }
            break;
        case 3:
        {
            self.typeStr = @"1";
        }
            break;
        case 4:
        {
            self.typeStr = @"2";
        }
            break;
        default:
        {
            self.typeStr = @"0";
        }
            break;
    }
    [self.tableView.mj_header beginRefreshing];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (self.type == 1) {
        self.navigationController.swipeBackEnabled = NO;
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的拼团";
    self.page = 1;
    self.typeStr = @"4";
    self.dataSource = @[].mutableCopy;
    
    [self.view addSubview:self.topView];
    [self.view addSubview:self.tableView];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.topView.mas_bottom);
        make.left.right.bottom.equalTo(self.view);
    }];
    [self.view addSubview:self.naviBarView];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav_icon_search"] style:UIBarButtonItemStylePlain target:self action:@selector(rightItemClick)];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(yanzheng:) name:@"CallBackResault" object:nil];
    self.blankV = [[blankView alloc]initWithFrame:CGRectMake(kScreenWidth/2.0-40, self.view.center.y/2.0-0, 80, 80) imageName:@"noData" title:@"暂无数据"];
    [self.tableView addSubview:self.blankV];
    self.blankV.hidden = YES;
    [self requestData];
    [self setPopUView];
    [self setPopView];
    
    if (self.type == 1) {
        UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [backBtn setImage:[UIImage imageNamed:@"nav_icon_back"] forState:UIControlStateNormal];
        [backBtn setTitle:@"   " forState:UIControlStateNormal];
        backBtn.frame = CGRectMake(0, 0, 34, 20);
        backBtn.imageRect = CGRectMake(0, 0, 12, 20);
        backBtn.titleRect = CGRectMake(14, 0, 20, 20);
        [backBtn addTarget:self action:@selector(clickBackItemToPop) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
        
        self.navigationItem.leftBarButtonItem = backItem;
    }
}
- (void)clickBackItemToPop {
    for (UIViewController *controller in self.navigationController.viewControllers) {
        if ([controller isKindOfClass:[googsInfoViewController class]]) {
            googsInfoViewController *googsInfoVC =(googsInfoViewController *)controller;
            [self.navigationController popToViewController:googsInfoVC animated:YES];
        }
    }
}
- (void)requestData {
    //    [MBProgressHUD showMessage:@"加载中..."];
    
    NSString *page = [NSString stringWithFormat:@"%ld",(long)self.page];
    NSDictionary *para = @{@"userId":self.myInfoM.ID,@"size":@"10",@"page":page,@"type":self.typeStr,@"goodsName":@""};
    [[ZLJNetWorkManager defaultManager]sendRequestMethod:HTTPMethodPOST isLogin:NO isJsonRequest:YES serverUrl:requestHost apiPath:queryMyPtUrl parameters:para progress:^(NSProgress * _Nullable progress) {
        
    } success:^(BOOL isSuccess, id  _Nullable responseObject) {
        //        [MBProgressHUD hideHUD];
        
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        NSDictionary *dataDic = [NSDictionary changeType:responseObject];
        if (dataDic) {
            NSString *code = dataDic[@"code"];
            NSString *msg = dataDic[@"message"];
            if ([code integerValue] == 200) {
                NSMutableArray *dataArr  = [myGroupModel mj_objectArrayWithKeyValuesArray:dataDic[@"data"]];
                
                if ([page integerValue] == 1) {
                    [self.dataSource removeAllObjects];
                    if (dataArr.count == 0) {
                        self.tableView.mj_footer = nil;
                    }else {
                        self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
                            self.page = 1+self.page;
                            [self requestData];
                        }];
                    }
                }
                if (dataArr.count < 10) {
                    [self.tableView.mj_footer endRefreshingWithNoMoreData];
                }
                [self.dataSource addObjectsFromArray:dataArr];
                
                if (self.dataSource.count) {
                    self.blankV.hidden = YES;
                } else {
                    self.blankV.hidden = NO;
                }
                [self.tableView reloadData];
            } else {
                if (self.page > 1) {
                    self.page --;
                }
                if (self.page == 1) {
                    self.tableView.mj_footer = nil;
                }
                [MBProgressHUD showError:msg toView:self.navigationController.view];
            }
        } else {
            if (self.page > 1) {
                self.page --;
            }
            [MBProgressHUD showError:myRequestError toView:self.navigationController.view];
        }
    } failure:^(NSString * _Nullable errorMessage) {
        if (self.page > 1) {
            self.page --;
        }
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        //        [MBProgressHUD hideHUD];
        if (self.page == 1) {
            self.tableView.mj_footer = nil;
        }
        [MBProgressHUD showError:errorMessage toView:self.navigationController.view];
    }];
}
- (void)rightItemClick {
    searchGroupOrderVC *searchOrder = [searchGroupOrderVC new];
    searchOrder.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:searchOrder animated:YES];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataSource.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 3;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) {
        return 41;
    } else if (indexPath.row == 1) {
        return 90;
    } else {
        myGroupModel *orderModel = self.dataSource[indexPath.section];
        if ([orderModel.ptgStatus isEqualToString:@"1"] ) {
            if (![orderModel.orderStatus isEqualToString:@"90"] && ![orderModel.orderStatus isEqualToString:@"99"] && ![orderModel.orderStatus isEqualToString:@"91"] && ![orderModel.orderStatus isEqualToString:@"92"]) {
                return 70;
            }
        }else if ( [orderModel.ptgStatus isEqualToString:@"2"] || [orderModel.ptgStatus isEqualToString:@"3"]){
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
    myGroupModel *orderModel = self.dataSource[indexPath.section];
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
                    cell.stateLb.text = @"已失败";
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
        
        cell.orderPriceLb.text = [NSString stringWithFormat:@"¥%.2f",[orderModel.totalPaid doubleValue]];
//        if ([orderModel.isHead isEqualToString:@"1"]) {
//            cell.orderPriceLb.text = [NSString stringWithFormat:@"¥%.2f",[orderModel.groupPrice doubleValue]];
//        }
        switch ([orderModel.ptgStatus integerValue]) {
            case 1:
            {
                cell.firstBtn.layer.borderColor = redBG.CGColor;
                [cell.firstBtn setTitleColor:redBG forState:UIControlStateNormal];
                cell.secondBtn.hidden = YES;
                cell.thirdBtn.hidden = YES;
                switch ([orderModel.orderStatus integerValue]) {
                    case 10:
                    case 11:
                    {
                        cell.firstBtn.hidden = NO;
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
                            self.goodsModel.goodsPreview = orderModel.goodsPreview;
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
                        cell.firstBtn.hidden = NO;
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
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    myGroupModel *orderModel = self.dataSource[indexPath.section];
    if ([orderModel.orderStatus integerValue] == 50) {
        shoppingCartModel *goodsModel = [shoppingCartModel new];
        goodsModel.goodsPrice = orderModel.goodsPrice;
        goodsModel.goodsName = orderModel.goodsName;
        goodsModel.groupingGoodsNum = orderModel.groupingGoodsNum;
        goodsModel.groupingPrice = orderModel.helpGroupPrice;
        goodsModel.goodsPreview = orderModel.goodsPreview;
        groupingViewController *groupingVC = [groupingViewController new];
        groupingVC.groupId = orderModel.groupId;
        groupingVC.goodsModel = goodsModel;
        groupingVC.type = 2;
        [self.navigationController pushViewController:groupingVC animated:YES];
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
                groupingVC.type = 2;
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
- (void)shareGoodsWithUrl:(NSString *)url title:(NSString *)title imageUrl:(NSString *)goodsImage{
    NSURL *shareBgUrl = [NSURL URLWithString:goodsImage];
    UIImageView *imageV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    //placeholderImage:[UIImage imageNamed:@"banner"]
    [imageV sd_setImageWithURL:shareBgUrl placeholderImage:[UIImage imageNamed:@"banner"] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
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
////        config.itemTitleColor = [UIColor greenColor];
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
        NSData *imageData = [self compressOriginalImage:image toMaxDataSizeKBytes:30];
        UIImage *shareImage = [UIImage imageWithData:imageData];
        if (imageData.length>30*1024) {
            imageData = [self compressOriginalImage:shareImage toMaxDataSizeKBytes:30];
            shareImage = [UIImage imageWithData:imageData];
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
- (NSData *)compressOriginalImage:(UIImage *)image toMaxDataSizeKBytes:(CGFloat)size{
    NSData * data = UIImageJPEGRepresentation(image, 1.0);
    CGFloat dataKBytes = data.length/1000.0;
    CGFloat maxQuality = 0.9f;
    CGFloat lastData = dataKBytes;
    while (dataKBytes > size && maxQuality > 0.01f) {
        maxQuality = maxQuality - 0.01f;
        data = UIImageJPEGRepresentation(image, maxQuality);
        dataKBytes = data.length / 1000.0;
        if (lastData == dataKBytes) {
            break;
        }else{
            lastData = dataKBytes;
        }
    }
    
    return data;
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
