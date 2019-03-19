//
//  shoppingCartViewController.m
//  Distribution
//
//  Created by hchl on 2018/7/28.
//  Copyright © 2018年 hchl. All rights reserved.
//

#import "shoppingCartViewController.h"
#import "shoppingCartTableViewCell.h"
#import "shoppingCartModel.h"
#import "googsInfoViewController.h"
#import "goodsOrderViewController.h"
@interface shoppingCartViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArr;
@property (nonatomic, strong) NSMutableArray *isWorkArr;
@property (nonatomic, strong) NSMutableArray *isNotWorkArr;

@property (nonatomic, strong) NSMutableArray *selectArr;
@property (nonatomic, strong) UILabel *heji;
@property (nonatomic, strong) UILabel *priceLb;
@property (nonatomic, strong) UIButton *calculateBtn;
@property (nonatomic, strong) UIButton *selectAllBtn;
@property (nonatomic, strong) UIView *bottomBgView;
@property (nonatomic, assign) BOOL isDelete;

@property (nonatomic, strong) UIView *emptyView;
@end

@implementation shoppingCartViewController
static NSString *shoppingCartTableViewCellID = @"shoppingCartTableViewCell";
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-(isIphoneX?tabHeight:50)) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [UIView new];
        _tableView.backgroundColor = FXBGColor;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerNib:[UINib nibWithNibName:shoppingCartTableViewCellID bundle:[NSBundle mainBundle]] forCellReuseIdentifier:shoppingCartTableViewCellID];
    }
    return _tableView;
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self getNetwork];
    
    
    
    if (self.fromWhere == 5) {
        [self.selectArr removeAllObjects];
        self.selectAllBtn.selected = NO;
        [self calculatePrice];
        self.dataArr = @[].mutableCopy;
        [self requestData];
        [self.tableView reloadData];
    } else {
        
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    UILabel *titleLb = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
    titleLb.text = @"购物车";
    titleLb.textColor = myBlack;
    titleLb.font = [UIFont systemFontOfSize:18];
    titleLb.textAlignment = NSTextAlignmentCenter;
    self.navigationItem.titleView = titleLb;
    
    self.isWhiteNavi = YES;
    self.isDelete = NO;
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    
    self.selectArr = [NSMutableArray arrayWithCapacity:0];
    
    [self setUpShoppingCartView];
    
    [self setBottomView];
    // Do any additional setup after loading the view.
}
- (void)requestData {
    [[ZLJNetWorkManager defaultManager]sendRequestMethod:HTTPMethodPOST isLogin:NO isJsonRequest:NO serverUrl:requestHost apiPath:shoppingCartListUrl parameters:@{@"userId":self.myInfoM.ID} progress:^(NSProgress * _Nullable progress) {
        
    } success:^(BOOL isSuccess, id  _Nullable responseObject) {
        [FXObjManager dc_saveUserData:@"1" forKey:BOOLLoadShoppingCart];
        NSDictionary *dataDic = [NSDictionary changeType:responseObject];
        if (dataDic) {
            NSString *code = dataDic[@"code"];
            NSString *msg = dataDic[@"message"];
            if ([code integerValue] == 200) {
                NSMutableArray *dataArray = [shoppingCartModel mj_objectArrayWithKeyValuesArray:dataDic[@"data"]];
                self.isWorkArr = @[].mutableCopy;
                self.isNotWorkArr = @[].mutableCopy;
                for (shoppingCartModel *model in dataArray) {
                    model.isDelete = @"0";
                    if ([model.isshelf isEqualToString:@"0"]) {
                        [self.isNotWorkArr addObject:model];
                    }else {
                        [self.isWorkArr addObject:model];
                    }
                }
                [self.dataArr removeAllObjects];
                [self.dataArr addObjectsFromArray:self.isWorkArr];
                [self.dataArr addObjectsFromArray:self.isNotWorkArr];
                [self.tableView reloadData];
                UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icon_delete"] style:UIBarButtonItemStylePlain target:self action:@selector(deleteBtnClick)];
                self.navigationItem.rightBarButtonItem = rightItem;
            } else {
                [MBProgressHUD showError:msg toView:self.navigationController.view];
            }
            if (self.dataArr.count == 0) {
                self.tableView.hidden = YES;
                self.bottomBgView.hidden = YES;
                self.navigationItem.rightBarButtonItem = nil;
                self.emptyView.hidden = NO;
                
            }else {
                self.tableView.hidden = NO;
                self.bottomBgView.hidden = NO;
                self.emptyView.hidden = YES;
            }
        } else {
            [MBProgressHUD showError:myRequestError toView:self.navigationController.view];
            if (self.dataArr.count == 0) {
                self.tableView.hidden = YES;
                self.bottomBgView.hidden = YES;
                self.navigationItem.rightBarButtonItem = nil;
                self.emptyView.hidden = NO;
            }
        }
    } failure:^(NSString * _Nullable errorMessage) {
        [MBProgressHUD showError:errorMessage toView:self.navigationController.view];
        if (self.dataArr.count == 0) {
            self.tableView.hidden = YES;
            self.bottomBgView.hidden = YES;
            self.navigationItem.rightBarButtonItem = nil;
            self.emptyView.hidden = NO;
        }
    }];
}
- (void)setUpEmptyView {
    
    
    
    self.emptyView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    
    [self.view addSubview:self.emptyView];
    self.emptyView.backgroundColor = myWhite;
    UIImageView *image = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_basket_empty"]];
    image.frame = CGRectMake(0, 0, 80, 80);
    image.center = CGPointMake(kScreenWidth/2.0, kScreenWidth/2.0+40);
    [self.emptyView addSubview:image];
    
    UILabel *label = [[UILabel alloc] init];
    [self.emptyView addSubview:label];
    label.text = @"购物车还没有东西哦～";
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = RGB(51, 51, 51);
    label.font = [UIFont systemFontOfSize:14];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(image.mas_bottom).offset(25);
        make.left.right.equalTo(self.view);
        make.height.mas_equalTo(20);
    }];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.emptyView addSubview:btn];
    [btn addTarget:self action:@selector(goToShopping) forControlEvents:UIControlEventTouchUpInside];
    btn.layer.masksToBounds = YES;
    btn.layer.cornerRadius = 17;
    btn.layer.borderWidth = 1;
    btn.layer.borderColor = myBlueBg.CGColor;
    [btn setTitle:@"去消费" forState:UIControlStateNormal];
    [btn setTitleColor:myBlueType forState:UIControlStateNormal];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(label.mas_bottom).offset(50);
        make.left.equalTo(self.view).offset(kScreenWidth/2.0-75*KAdaptiveRateWidth);
        make.width.mas_equalTo(150*KAdaptiveRateWidth);
        make.height.mas_equalTo(34);
    }];
    
}
- (void)goToShopping {
    if (self.fromWhere != 1) {
        myTabBarController *tab = [myTabBarController new];
        tab.selectedIndex = 0;
        [UIApplication sharedApplication].keyWindow.rootViewController = tab;
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}
- (void)setUpShoppingCartView {
    [self.view addSubview:self.tableView];
    self.naviBarView.alpha = 1;
    
    [self setUpEmptyView];
    
    [self.view addSubview:self.naviBarView];
    
    [self.navigationController.navigationBar setTintColor:RGB(51, 51, 51)];
    

    
//    NSString *isLoad = [FXObjManager dc_readUserDataForKey:BOOLLoadShoppingCart];
    if (self.fromWhere != 5) {
        self.navigationItem.leftBarButtonItem = self.backItem;
        self.dataArr = @[].mutableCopy;
        [self requestData];
        [self.tableView reloadData];
    }
    
}
- (void)setBottomView {
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, kScreenHeight-(isIphoneX?tabHeight:50), kScreenWidth, isIphoneX?tabHeight:50)];
    bgView.backgroundColor = FXBGColor;
    [self.view addSubview:bgView];
    self.bottomBgView = bgView;
    
    if (self.fromWhere == 5) {
        bgView.frame = CGRectMake(0, kScreenHeight-(isIphoneX?tabHeight:50)-tabHeight, kScreenWidth, isIphoneX?tabHeight:50);
    }
    
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 50)];
    bottomView.backgroundColor = myWhite;
    [bgView addSubview:bottomView];
    
    UIButton *calculateBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    calculateBtn.frame = CGRectMake(kScreenWidth - 135*KAdaptiveRateWidth, 0, 135*KAdaptiveRateWidth, 50);
    [calculateBtn setBackgroundImage:[UIImage imageNamed:@"settlement_btn_bg"] forState:UIControlStateNormal];
    [calculateBtn setTitle:@"去结算(0)" forState:UIControlStateNormal];
    calculateBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [bottomView addSubview:calculateBtn];
    [calculateBtn addTarget:self action:@selector(clickBuy) forControlEvents:UIControlEventTouchUpInside];
    self.calculateBtn = calculateBtn;
    calculateBtn.enabled = NO;
    
    UIButton *selectAllBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [bottomView addSubview:selectAllBtn];
    [selectAllBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(bottomView).offset(10);
        make.centerY.equalTo(bottomView);
        make.height.mas_equalTo(25);
        make.width.mas_equalTo(65);
    }];
    [selectAllBtn setTitle:@"全选" forState:UIControlStateNormal];
    selectAllBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [selectAllBtn setImage:[UIImage imageNamed:@"basket_selector"] forState:UIControlStateNormal];
    [selectAllBtn setImage:[UIImage imageNamed:@"basket_selector_on"] forState:UIControlStateSelected];
    selectAllBtn.imageRect = CGRectMake(4, 5, 17, 17);
    selectAllBtn.titleRect = CGRectMake(30, 4, 35, 17);
    [selectAllBtn setTitleColor:RGB(51, 51, 51) forState:UIControlStateNormal];
    [selectAllBtn addTarget:self action:@selector(selectAllBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    self.selectAllBtn = selectAllBtn;
    
    UILabel *heji = [[UILabel alloc] init];
    heji.textColor = RGB(51, 51, 51);
    heji.text = @"合计:";
    heji.font = [UIFont systemFontOfSize:14];
    [bottomView addSubview:heji];
    [heji mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(selectAllBtn.mas_right).offset(10);
        make.centerY.equalTo(bottomView);
        make.height.mas_equalTo(17);
    }];
    self.heji = heji;
    
    UILabel *priceLb = [[UILabel alloc] init];
    priceLb.textColor = myRed;
    priceLb.text = @"¥0.00";
    priceLb.font = [UIFont systemFontOfSize:14];
    [bottomView addSubview:priceLb];
    [priceLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(heji.mas_right);
        make.centerY.equalTo(bottomView);
        make.height.mas_equalTo(17);
    }];
    self.priceLb = priceLb;
    
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArr.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 110*KAdaptiveRateWidth;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    shoppingCartTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:shoppingCartTableViewCellID forIndexPath:indexPath];
    shoppingCartModel *model = self.dataArr[indexPath.row];
    cell.model = model;
    cell.numAddBlock = ^{
        if ([Utils isBlankString:model.limitCount]) {
            NSString *goodsCount = [NSString stringWithFormat:@"%ld",[model.goodsCount integerValue]+1];
            NSDictionary *para = @{@"param":@{@"id":model.ID,@"goodsCount":goodsCount}};
            
            [[ZLJNetWorkManager defaultManager]sendRequestMethod:HTTPMethodPOST isLogin:NO isJsonRequest:YES serverUrl:requestHost apiPath:updateShoppingCartUrl parameters:para progress:^(NSProgress * _Nullable progress) {
                
            } success:^(BOOL isSuccess, id  _Nullable responseObject) {
                NSDictionary *dataDic = [NSDictionary changeType:responseObject];
                if (dataDic) {
                    NSString *code = dataDic[@"code"];
                    NSString *msg = dataDic[@"message"];
                    if ([code integerValue] == 200) {
                        model.goodsCount = goodsCount;
                        [tableView reloadData];
                        [self calculatePrice];
                    }else {
                        [MBProgressHUD showError:msg toView:self.navigationController.view];
                    }
                } else {
                    [MBProgressHUD showError:@"网络故障，操作失败" toView:self.navigationController.view];
                }
            } failure:^(NSString * _Nullable errorMessage) {
                [MBProgressHUD showError:@"网络故障，操作失败" toView:self.navigationController.view];
            }];
            
        }else {
            if ([model.goodsCount integerValue] <= [model.limitCount integerValue]) {
                model.goodsCount = [NSString stringWithFormat:@"%ld",[model.goodsCount integerValue]+1];
                [tableView reloadData];
                [self calculatePrice];
            } else {
                [MBProgressHUD showToastText:@"已达到限制购买数量"];
            }
        }
        
    };
    cell.numCutBlock = ^{
        if ([model.goodsCount integerValue] > 1) {
            NSString *goodsCount = [NSString stringWithFormat:@"%ld",[model.goodsCount integerValue]-1];
            NSDictionary *para = @{@"param":@{@"id":model.ID,@"goodsCount":goodsCount}};
            [[ZLJNetWorkManager defaultManager]sendRequestMethod:HTTPMethodPOST isLogin:NO isJsonRequest:YES serverUrl:requestHost apiPath:updateShoppingCartUrl parameters:para progress:^(NSProgress * _Nullable progress) {
                
            } success:^(BOOL isSuccess, id  _Nullable responseObject) {
                NSDictionary *dataDic = [NSDictionary changeType:responseObject];
                if (dataDic) {
                    NSString *code = dataDic[@"code"];
                    NSString *msg = dataDic[@"message"];
                    if ([code integerValue] == 200) {
                        model.goodsCount = goodsCount;
                        [tableView reloadData];
                        [self calculatePrice];
                    }else {
                        [MBProgressHUD showError:msg toView:self.navigationController.view];
                    }
                } else {
                    [MBProgressHUD showError:@"网络故障，操作失败" toView:self.navigationController.view];
                }
            } failure:^(NSString * _Nullable errorMessage) {
                [MBProgressHUD showError:@"网络故障，操作失败" toView:self.navigationController.view];
            }];
        }
    };
    cell.cartBlock = ^(BOOL select) {
        if (select) {
            [self.selectArr addObject:model];
            if (self.isDelete) {
                if (self.selectArr.count == self.dataArr.count) {
                    self.selectAllBtn.selected = YES;
                }
            }else {
                if (self.selectArr.count == self.isWorkArr.count) {
                    self.selectAllBtn.selected = YES;
                }
            }
            
        } else {
            [self.selectArr removeObject:model];
            self.selectAllBtn.selected = NO;
        }
        model.isSelect = select;
        [tableView reloadData];
        [self calculatePrice];
    };
    return cell;
}
/*改变删除按钮的title*/
//-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return @"删除";
//}

//- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
//    shoppingCartModel *model = self.dataArr[indexPath.row];
//    [self.dataArr removeObjectAtIndex:indexPath.row];
//
//    if (model.isSelect) {
//        [self.selectArr removeObject:model];
//        [self calculatePrice];
//    }
//    if (self.dataArr.count == 0) {
//        [self.tableView removeFromSuperview];
//        [self setUpEmptyView];
//    }
//
//    [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationTop];
//
//    [self deleteShoppingCartWithCartIDs:@[model.ID]];
//}
- (void)deleteShoppingCartWithCartIDs:(NSArray *)selectArr {
    NSMutableArray *ids = @[].mutableCopy;
    NSString *idStr = @"";
    for (int i=0 ; i <selectArr.count ; i++) {
        shoppingCartModel *model = selectArr[i];
        [ids addObject:model.ID];
        if (i == 0) {
            idStr = model.ID;
        } else {
            idStr = [NSString stringWithFormat:@"%@,%@",idStr,model.ID];
        }
    }
    
    [[ZLJNetWorkManager defaultManager]sendRequestMethod:HTTPMethodPOST isLogin:NO isJsonRequest:NO serverUrl:requestHost apiPath:deleteShoppingCartUrl parameters:@{@"ids":idStr} progress:^(NSProgress * _Nullable progress) {
        
    } success:^(BOOL isSuccess, id  _Nullable responseObject) {
        NSDictionary *dataDic = [NSDictionary changeType:responseObject];
        if (dataDic) {
            NSString *code = dataDic[@"code"];
            NSString *msg = dataDic[@"message"];
            if ([code integerValue] == 200) {
                [MBProgressHUD showSuccess:@"删除成功" toView:self.navigationController.view];
                [self.calculateBtn setTitle:@"删除(0)" forState:UIControlStateNormal];
                self.calculateBtn.enabled = NO;
                
                [self requestData];
                
            }else {
                [MBProgressHUD showError:msg toView:self.navigationController.view];
            }
        } else {
            [MBProgressHUD showError:myRequestError toView:self.navigationController.view];
        }
    } failure:^(NSString * _Nullable errorMessage) {
        [MBProgressHUD showError:errorMessage toView:self.navigationController.view];
    }];
}
- (void)calculatePrice {
    if (self.isDelete) {
        if (self.selectArr.count) {
            self.calculateBtn.enabled = YES;
            NSString *btnTitle = [NSString stringWithFormat:@"删除(%ld)",self.selectArr.count];
            [self.calculateBtn setTitle:btnTitle forState:UIControlStateNormal];
        } else {
            self.calculateBtn.enabled = NO;
            NSString *btnTitle = [NSString stringWithFormat:@"删除(0)"];
            [self.calculateBtn setTitle:btnTitle forState:UIControlStateNormal];
        }
    } else {
        double totlePrice = 0.0;
        NSInteger totleCount = 0;
        for (shoppingCartModel *model in self.selectArr) {
            if (![model.isshelf isEqualToString:@"0"]) {
                double price = [model.standardPrice doubleValue];
                if ([model.goodsStandardId isEqualToString:@"0"]) {
                    price = [model.goodsPrice doubleValue];
                }
                
                double count = [model.goodsCount integerValue];
                totlePrice += price*[model.goodsCount integerValue];
                totleCount = count+totleCount;
            }
        }
        if (totlePrice > 0) {
            self.calculateBtn.enabled = YES;
            NSString *btnTitle = [NSString stringWithFormat:@"去结算(%ld)",(long)totleCount];
            [self.calculateBtn setTitle:btnTitle forState:UIControlStateNormal];
        } else {
            NSString *btnTitle = [NSString stringWithFormat:@"去结算(0)"];
            [self.calculateBtn setTitle:btnTitle forState:UIControlStateNormal];
            self.calculateBtn.enabled = NO;
        }
        self.priceLb.text = [NSString stringWithFormat:@"¥%.2f",totlePrice];
    }
}

- (void)selectAllBtnClick:(UIButton *)sender {
    sender.selected = !sender.selected;
    for (shoppingCartModel *model in self.dataArr) {
        model.isSelect = sender.selected;
        
    }
    if (sender.selected) {
        if (!self.isDelete) {
            [self.selectArr addObjectsFromArray:self.isWorkArr];
        }else {
            [self.selectArr addObjectsFromArray:self.dataArr];
        }
        
    } else {
        [self.selectArr removeAllObjects];
    }
    [self.tableView reloadData];
    [self calculatePrice];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    shoppingCartModel *model = self.dataArr[indexPath.row];
    googsInfoViewController *goodsInfo = [googsInfoViewController new];
    goodsInfo.fromWhere = 1;
    goodsInfo.model = model;
    goodsInfo.goodsID = model.goodsId;
    goodsInfo.goodsPreview = model.goodsPreview;
    goodsInfo.isGroup = [model.isGroup boolValue];
    if (self.fromWhere == 5) {
        goodsInfo.hidesBottomBarWhenPushed = YES;
    }
    goodsInfo.refreshBlock = ^{
        
        [self requestData];
    };
    if (![model.isshelf isEqualToString:@"0"]) {
        [self.navigationController pushViewController:goodsInfo animated:YES];
    }
}

#pragma mark === 购买 和 删除
- (void)clickBuy {
    if (self.isDelete) {
        [self deleteShoppingCartWithCartIDs:self.selectArr];
    } else {
        goodsOrderViewController *goodsOrder = [goodsOrderViewController new];
        goodsOrder.goodsArr = self.selectArr;
        if (self.fromWhere == 5) {
            goodsOrder.hidesBottomBarWhenPushed = YES;
        }
        goodsOrder.type = 1;
        [self.navigationController pushViewController:goodsOrder animated:YES];
    }
    
}
- (void)deleteBtnClick {
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancelBtnClick)];
    self.navigationItem.rightBarButtonItem = rightItem;
    self.isDelete = YES;
    self.priceLb.hidden = YES;
    self.heji.hidden = YES;
    self.calculateBtn.enabled = NO;
    [self.calculateBtn setTitle:@"删除(0)" forState:UIControlStateNormal];
    for (shoppingCartModel *model in self.dataArr) {
        model.isSelect = NO;
        model.isDelete = @"1";
    }
    self.selectAllBtn.selected = NO;
    [self.selectArr removeAllObjects];
    [self.tableView reloadData];
}
- (void)cancelBtnClick {
    self.isDelete = NO;
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icon_delete"] style:UIBarButtonItemStylePlain target:self action:@selector(deleteBtnClick)];
    self.navigationItem.rightBarButtonItem = rightItem;
    self.priceLb.hidden = NO;
    self.heji.hidden = NO;
    self.calculateBtn.enabled = NO;
    [self.calculateBtn setTitle:@"去结算(0)" forState:UIControlStateNormal];
    for (shoppingCartModel *model in self.dataArr) {
        model.isSelect = NO;
        model.isDelete = @"0";
    }
    self.selectAllBtn.selected = NO;
    [self.selectArr removeAllObjects];
    [self.tableView reloadData];
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
