//
//  searchGoodsViewController.m
//  Distribution
//
//  Created by hchl on 2018/8/1.
//  Copyright © 2018年 hchl. All rights reserved.
//

#import "searchGoodsViewController.h"
#import "shoppingCartViewController.h"
#import "searchHotTableViewCell.h"
#import "searchHistoryFootView.h"
#import "removeHistoryTableViewCell.h"
#import "goodsTableViewCell.h"
#import "goodsTableCell.h"
#import "searchHeaderView.h"
#import "googsInfoViewController.h"
#import "loginAndRegisterViewController.h"
@interface searchGoodsViewController ()<UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>
@property (nonatomic, strong) UISearchController *searchController;
@property (nonatomic, strong) UITableView *tableView;
// 搜索到的数据数组
@property (nonatomic, strong) NSMutableArray *dataArray;
// 搜索结果数组
@property (nonatomic, strong) NSMutableArray *hotSearchArr;
@property (nonatomic, strong) UITextField *searchTf;
@property (nonatomic, assign) CGFloat cellOneheight;
@property (nonatomic, assign) BOOL isSearching;//判断是否是在搜索中
@property (nonatomic, strong) searchHistoryFootView *footView;
@property (nonatomic, strong) searchHeaderView *headerView;
@property (nonatomic, strong) NSMutableArray *searchHistoryArr;
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, strong) NSString *sort;
@property (nonatomic, assign) BOOL paixu;
@property (nonatomic, strong) NSString *shareUrlStr;
@end

@implementation searchGoodsViewController
- (UITableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        
        _tableView.tableFooterView = [UIView new];
        [_tableView registerClass:[searchHotTableViewCell class] forCellReuseIdentifier:@"hot"];
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
        [_tableView registerNib:[UINib nibWithNibName:@"removeHistoryTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"remove"];
        [_tableView registerNib:[UINib nibWithNibName:@"goodsTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"goods"];
        [_tableView registerNib:[UINib nibWithNibName:@"goodsTableCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"goodsTableCell"];
    }
    return _tableView;
}

- (NSMutableArray *)dataArray {
    if (_dataArray == nil) {
        _dataArray = [NSMutableArray arrayWithCapacity:0];
    }
    
    return _dataArray;
}

- (NSMutableArray *)hotSearchArr {
    if (_hotSearchArr == nil) {
        _hotSearchArr = [NSMutableArray arrayWithCapacity:0];
        
    }
    
    return _hotSearchArr;
}
#pragma mark == section的foot
- (searchHistoryFootView *)footView {
    if (!_footView) {
        _footView = [[searchHistoryFootView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 44)];
    }
    return _footView;
}
#pragma mark == section的head
- (searchHeaderView *)headerView {
    if (!_headerView) {
        _headerView = [[searchHeaderView alloc] initWithFrame:CGRectMake(0, naviHeight, kScreenWidth, 38)];
        WEAKSELF
        _headerView.block = ^(NSInteger index, BOOL paiXu) {
            weakSelf.page = 1;
#pragma mark == 在这里选择不同的排序模式
            if (index == 2) {
                weakSelf.paixu = paiXu;
                weakSelf.sort = @"goodsPrice";
                [weakSelf requestGoodsWithGoodsName:weakSelf.searchTf.text sort:weakSelf.sort paiXu:weakSelf.paixu];
            } else if (index == 3) {
                weakSelf.paixu = NO;
                weakSelf.sort = [NSString stringWithFormat:@"%d",paiXu];
                [weakSelf requestGoodsWithGoodsName:weakSelf.searchTf.text sort:weakSelf.sort paiXu:NO];
            } else if (index == 1) {
                weakSelf.paixu = NO;
                weakSelf.sort = @"num";
                [weakSelf requestGoodsWithGoodsName:weakSelf.searchTf.text sort:weakSelf.sort paiXu:NO];
            } else if (index == 0) {
                weakSelf.paixu = NO;
                weakSelf.sort = @"createTime";
                [weakSelf requestGoodsWithGoodsName:weakSelf.searchTf.text sort:weakSelf.sort paiXu:NO];
            }
            
        };
    }
    return _headerView;
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self getNetwork];
    if (self.type != 3 && self.type != 4) {
        [self.searchTf becomeFirstResponder];
    }
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.isWhiteNavi = YES;
    self.page = 1;
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    self.isSearching = NO;
    _tableView.backgroundColor = myWhite;
    NSArray *historyArr = [[NSUserDefaults standardUserDefaults] objectForKey:searchHistory];
    self.searchHistoryArr = [NSMutableArray arrayWithArray:historyArr];
    [self.view addSubview:self.tableView];
    
//    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
//        self.page++;
//        [self requestGoodsWithGoodsName:self.searchTf.text sort:self.sort paiXu:self.paixu];
//    }];
    [self.view addSubview:self.naviBarView];

    
    if (self.type != 3) {
        UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [backBtn setImage:[UIImage imageNamed:@"nav_icon_back"] forState:UIControlStateNormal];
        [backBtn setTitle:@"   " forState:UIControlStateNormal];
        backBtn.frame = CGRectMake(0, 0, 34, 20);
        backBtn.imageRect = CGRectMake(0, 0, 12, 20);
        backBtn.titleRect = CGRectMake(14, 0, 20, 20);
        [backBtn addTarget:self action:@selector(clickBackItemToPop) forControlEvents:UIControlEventTouchUpInside];
        self.backItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    }
    self.navigationItem.leftBarButtonItem = self.backItem;
    
    
    self.naviBarView.alpha = 1;
    [self settitleView];
    if (self.type != 3) {
        [self setupView];
        [self requestData];
    }else {
        [self searchingWithText:@""];
    }
    
    self.blankV = [[blankView alloc]initWithFrame:CGRectMake(kScreenWidth/2.0-40, self.view.center.y/2.0+50, 80, 80) imageName:@"noData" title:@"暂无商品数据"];
    [self.tableView addSubview:self.blankV];
    self.blankV.hidden = YES;
}
- (void)requestData {
    [[ZLJNetWorkManager defaultManager] sendRequestMethod:HTTPMethodPOST
                                                  isLogin:NO
                                            isJsonRequest:NO
                                                serverUrl:requestHost
                                                  apiPath:goodsSearchUrl
                                               parameters:nil
                                                 progress:^(NSProgress * _Nullable progress) {
                                                
                                            } success:^(BOOL isSuccess, id  _Nullable responseObject) {
                                                NSDictionary *dataDic = [NSDictionary changeType:responseObject];
                                                if (dataDic) {
                                                    NSString *code = dataDic[@"code"];
                                                    NSString *msg = dataDic[@"message"];
                                                    if ([code integerValue] == 200) {
                                                        NSArray *arr = dataDic[@"data"];
                                                        [self.hotSearchArr addObjectsFromArray:arr];
                                                        
                                                        [self setupView];
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
- (void)settitleView {
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 250*KAdaptiveRateWidth, 30)];//allocate titleView
    UIColor *color =  [UIColor clearColor];
    [titleView setBackgroundColor:color];
    
    UITextField *searchTf = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, 250*KAdaptiveRateWidth, 30)];
    searchTf.placeholder = @"  搜索商品";
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
    
    UIButton *rightBtnOne = [[UIButton alloc] initWithFrame:CGRectMake(20, 0, 30, 40)];
    [rightBtnOne setImage:[UIImage imageNamed:@"home_icon_basket_black"] forState:UIControlStateNormal];
    [rightBtnOne setTitleColor:RGB(20, 20, 20) forState:UIControlStateNormal];
    [rightBtnOne setTitle:@"购物车" forState:UIControlStateNormal];
    rightBtnOne.titleLabel.font = [UIFont systemFontOfSize:8];
    rightBtnOne.titleLabel.textAlignment = NSTextAlignmentCenter;
    rightBtnOne.titleRect = CGRectMake(15, 28, 30, 8);
    rightBtnOne.imageRect = CGRectMake(20, 3, 20, 20);
    [rightBtnOne addTarget:self action:@selector(goToShoppingCart) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *itemOne = [[UIBarButtonItem alloc] initWithCustomView:rightBtnOne];
    self.navigationItem.rightBarButtonItem = itemOne;//@[itemOne,item];
}
- (void)setupView {

    [self calculateHeightWithHeight];
}

- (void)calculateHeightWithHeight {
    UIView *bgview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 300)];
    bgview.hidden = YES;
//    [self.view addSubview:bgview];
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 10, kScreenWidth-10, 17)];
    titleLabel.text = @"热搜";
    titleLabel.font = [UIFont systemFontOfSize:15];
//    [bgview addSubview:titleLabel];
    
    if (self.hotSearchArr.count) {
        float butX = 15;
        float butY = CGRectGetMaxY(titleLabel.frame)+15;
        for(int i = 0; i < self.hotSearchArr.count; i++){
            NSString *sizeStr = self.hotSearchArr[i];;
            //宽度自适应
            NSDictionary *fontDict = @{NSFontAttributeName:[UIFont systemFontOfSize:12]};
            CGRect frame_W = [sizeStr boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:fontDict context:nil];
            
            if (butX+frame_W.size.width+20>kScreenWidth-15) {
                
                butX = 15;
                
                butY += 35;
            }
            
            UIButton *but = [[UIButton alloc]initWithFrame:CGRectMake(butX, butY, frame_W.size.width+20, 23)];
            [but setTitle:sizeStr forState:UIControlStateNormal];
            but.tag = i+1;
            
            [but setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
            [but setTitleColor:[UIColor darkTextColor] forState:UIControlStateNormal];
            but.titleLabel.font = [UIFont systemFontOfSize:12];
            but.layer.cornerRadius = 11.5;
            but.layer.borderColor = [UIColor lightGrayColor].CGColor;
            but.layer.borderWidth = 1;
//            [bgview addSubview:but];
            butX = CGRectGetMaxX(but.frame)+10;
            if (i == self.self.hotSearchArr.count - 1) {
                CGFloat height = CGRectGetMaxY(but.frame)+10;
                self.cellOneheight = height;
                [self.tableView reloadData];
                
            }
        }
        [bgview removeFromSuperview];
    }
}

//进入购物车
- (void)goToShoppingCart {
    NSString *isLogin = [FXObjManager dc_readUserDataForKey:BOOLIsLogin];
    self.isLogout = [isLogin boolValue];
    if (!self.isLogin) {
        loginAndRegisterViewController *loginVC = [loginAndRegisterViewController new];
        UINavigationController *loginNavi = [[UINavigationController alloc] initWithRootViewController:loginVC];
        [self presentViewController:loginNavi animated:YES completion:^{
            
        }];
    }else {
        shoppingCartViewController *cart = [shoppingCartViewController new];
        cart.fromWhere = 2;
        [self.navigationController pushViewController:cart animated:YES];
    }
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (self.isSearching) {
        return 1;
    } else {
        return 2;
    }
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (self.isSearching) {
        return self.dataArray.count;
    } else {
        if (section == 0) {
            return 1;
        } else {
            if (self.searchHistoryArr.count) {
                return self.searchHistoryArr.count+1;
            }
            return 0;
        }
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.isSearching) {
        return ((kScreenWidth-26)/349.0)*187.0+18.5+62;
    } else {
        if (indexPath.section == 0) {
            return self.cellOneheight;
        } else {
            return 44;
        }
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (self.isSearching) {
        return 38;
    } else {
        return 0.01;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (self.isSearching) {
        return 0.01;
    } else {
        if (section == 0) {
            
            if (self.searchHistoryArr.count) {
                return 44;
            }
            return 0.01;
        } else {
            return 0.01;
        }
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (self.isSearching) {
        UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 38)];
        header.backgroundColor = RGB(241, 243, 246);
        return header;
    } else {
        return nil;
    }
    
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if (!self.isSearching) {
        if (section == 0) {
            if (self.searchHistoryArr.count) {
                return self.footView;
            }
        }
    }
    return nil;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.isSearching) {
        shoppingCartModel *model = self.dataArray[indexPath.row];
        goodsTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"goodsTableCell" forIndexPath:indexPath];
        cell.goodsModel = model;
//        goodsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"goods" forIndexPath:indexPath];
//
        NSString *goodsImage = [NSString stringWithFormat:@"%@%@",imageHost,model.goodsPreview];
//        [cell.goodsImageV sd_setImageWithURL:[NSURL URLWithString:goodsImage] placeholderImage:[UIImage imageNamed:@"goods"]];
//        cell.goodsPriceLb.text = [NSString stringWithFormat:@"¥%.2f",[model.goodsPrice doubleValue]];
//        if ([Utils isBlankString:model.vipRebatePrice]) {
//            cell.vipBgImage.hidden = YES;
//
//        }else {
//            cell.vipBgImage.hidden = NO;
//
//            if ([model.vipRebatePrice doubleValue] == 0) {
//                cell.vipBgImage.hidden = YES;
//
//            }
//        }
        cell.shareBlock = ^{
            if (![Utils isBlankString:self.myInfoM.userGrade] && [self.myInfoM.userGrade integerValue] <= 1) {
                NSString *shareUrlStr = [NSString stringWithFormat:@"%@app/user/toDetail/%@?mobilePhone=%@",shareHostTest,model.ID
                                         ,self.accountStr];
                if ([model.isGroup isEqualToString:@"1"]) {
                    shareUrlStr = [NSString stringWithFormat:shareGroupGoodsHost,model.ID,self.accountStr];
                }
                
                NSString *title = [NSString stringWithFormat:@"%@",model.goodsName];
                [self shareGoodsWithUrl:shareUrlStr title:title imageUrl:goodsImage];
                
            } else {
                [MBProgressHUD showToastText:@"省、市代无法分享" toView:self.tabBarController.view];
            }
            
        };
        return cell;
    } else {
        if (indexPath.section == 0 && indexPath.row == 0) {
            searchHotTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"hot" forIndexPath:indexPath];
            cell.buttonArray = self.hotSearchArr;
            //这里执行热搜的搜索
            cell.hotBlock = ^(NSString *hotStr) {
                [self searchingWithText:hotStr];
                [tableView reloadData];
            };
            return cell;
        } else if (indexPath.section == 1 && indexPath.row < self.searchHistoryArr.count){
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
            cell.textLabel.text = self.searchHistoryArr[indexPath.row];
            cell.textLabel.font = [UIFont systemFontOfSize:14];
            cell.textLabel.textColor = RGB(90, 90, 90);
            return cell;
        } else {
            removeHistoryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"remove" forIndexPath:indexPath];
            cell.block = ^{
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:searchHistory];
                [self.searchHistoryArr removeAllObjects];
                [tableView reloadData];
            };
            return cell;
        }
    }
    
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (self.isSearching) {
        googsInfoViewController *goodsInfo = [googsInfoViewController new];
        goodsInfo.fromWhere = 0;
        shoppingCartModel *model = self.dataArray[indexPath.row];
        model.num = @"0";
        goodsInfo.model = model;
        goodsInfo.goodsID = model.ID;
        goodsInfo.goodsPreview = model.goodsPreview;
        goodsInfo.isGroup = [model.isGroup boolValue];
        [self.navigationController pushViewController:goodsInfo animated:YES];
    } else {
        
        if (indexPath.section == 1) {
            NSString *text = self.searchHistoryArr[indexPath.row];
            [self searchingWithText:text];
            [tableView reloadData];
        }
    }
}
#pragma mark ===== textFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField endEditing:YES];
    NSString *text = textField.text;
    if ([Utils isBlankString:text]) {
        if (self.type != 3) {
            self.isSearching = NO;
            _tableView.backgroundColor = myWhite;
            [self.headerView removeFromSuperview];
        } else {
            [self searchingWithText:@""];
        }
    } else {
        [self searchingWithText:text];
        
    }
    [self.tableView reloadData];
    return YES;
}

- (void)textFieldDidChanged:(UITextField *)textField {
    if (textField.text.length > 0) {
//        self.isSearching = YES;
//        _tableView.backgroundColor = RGB(241, 243, 246);
    }else {
        if (self.type != 3) {
            self.isSearching = NO;
            self.blankV.hidden = YES;
            _tableView.backgroundColor = myWhite;
            [self.headerView removeFromSuperview];
            self.tableView.mj_footer = nil;
        }
    }
    [self.tableView reloadData];
}
- (void)searchingWithText:(NSString *)text {
    [self.view addSubview:self.headerView];
    self.isSearching = YES;
    _tableView.backgroundColor = RGB(241, 243, 246);
    self.searchTf.text = text;
    if (self.type != 3) {
        if ([self.searchHistoryArr containsObject:text]) {
            [self.searchHistoryArr removeObject:text];
        }
        [self.searchHistoryArr insertObject:text atIndex:0];
        [[NSUserDefaults standardUserDefaults] setObject:self.searchHistoryArr forKey:searchHistory];
    }
    
    self.page = 1;
    self.sort = @"createTime";
    [self requestGoodsWithGoodsName:text sort:self.sort paiXu:NO];

}
- (void)requestGoodsWithGoodsName:(NSString *)goodsName sort:(NSString *)sort paiXu:(BOOL)paiXu{
    [MBProgressHUD showMessage:@"加载中"];
    NSString *page = [NSString stringWithFormat:@"%ld",(long)self.page];
    
    NSMutableDictionary *parameters = @{}.mutableCopy;
    if (![Utils isBlankString:goodsName]) {
        parameters = @{@"page":page,@"size":@"10",@"goodsName":goodsName,@"sort":sort,@"paixu":@"1"}.mutableCopy;
    }else {
        parameters = @{@"page":page,@"size":@"10",@"sort":sort,@"paixu":@"1"}.mutableCopy;
    }
    if ([sort isEqualToString:@"goodsPrice"]) {
        if (paiXu) {
            parameters = @{@"page":page,@"size":@"10",@"goodsName":goodsName,@"sort":@"goodsPrice",@"paixu":@"1"}.mutableCopy;//,@"categoryId":self.categoryId
        } else {
            parameters = @{@"page":page,@"size":@"10",@"goodsName":goodsName,@"sort":@"goodsPrice",@"paixu":@"0"}.mutableCopy;
        }
    }
    if (self.type == 3) {
        [parameters setObject:self.categoryId forKey:@"categoryId"];
    }
    if (self.type == 4) {
        [parameters setObject:@"1" forKey:@"flag"];
    }
    [parameters setObject:self.myInfoM.ID forKey:@"userId"];
    
    
    [[ZLJNetWorkManager defaultManager] sendRequestMethod:HTTPMethodPOST isLogin:NO isJsonRequest:YES serverUrl:requestHost apiPath:goodsListUrl parameters:parameters progress:^(NSProgress * _Nullable progress) {
        
    } success:^(BOOL isSuccess, id  _Nullable responseObject) {
        [MBProgressHUD hideHUD];
        NSDictionary *dataDic = [NSDictionary changeType:responseObject];
        [self.tableView.mj_footer endRefreshing];
        if (dataDic) {
            NSString *code = dataDic[@"code"];
            NSString *message = dataDic[@"message"];
            if ([code isEqualToString:@"200"]) {
                NSDictionary *data = dataDic[@"data"];
                if (self.page == 1) {
                    [self.dataArray removeAllObjects];
                }
                if ([data isKindOfClass:[NSDictionary class]]) {
                    NSDictionary *goodsDataDic = dataDic[@"data"];
                    if ([goodsDataDic isKindOfClass:[NSDictionary class]]) {
                        NSArray *dataArr = goodsDataDic[@"goodsList"];
                        NSArray *goodsArr = [shoppingCartModel mj_objectArrayWithKeyValuesArray:dataArr];
                        
                        [self.dataArray addObjectsFromArray:goodsArr];
                        if (self.page == 1 && goodsArr.count == 0) {
                            self.tableView.mj_footer = nil;
                        } else if (self.page == 1 && goodsArr.count != 0){
                            self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
                                self.page++;
                                [self requestGoodsWithGoodsName:self.searchTf.text sort:self.sort paiXu:self.paixu];
                            }];
                        }
                        if (goodsArr.count<10) {
                            [self.tableView.mj_footer endRefreshingWithNoMoreData];
                        }
                        if (self.dataArray.count == 0) {
                            self.blankV.hidden = NO;
                        } else {
                            self.blankV.hidden = YES;
                        }
                    }else {
                        if (self.page == 1) {
                            self.tableView.mj_footer = nil;
                        }else {
                            self.page --;
                        }
                        if (self.dataArray.count == 0) {
                            self.blankV.hidden = NO;
                        } else {
                            self.blankV.hidden = YES;
                        }
                    }
                    
                }else {
                    if (self.page == 1) {
                        self.blankV.hidden = NO;
                        self.tableView.mj_footer = nil;
                        
                    }else {
                        self.page --;
                        [self.tableView.mj_footer endRefreshingWithNoMoreData];
                    }
                }
                
            } else {
                [MBProgressHUD showError:message toView:self.view];
                if (self.page > 1) {
                    self.page --;
                }
            }
            
        } else {
            [MBProgressHUD showError:myRequestError toView:self.view];
            if (self.page > 1) {
                self.page --;
            }
            
        }
        [self.tableView reloadData];
    } failure:^(NSString * _Nullable errorMessage) {
        [MBProgressHUD hideHUD];
        [self.tableView.mj_footer endRefreshing];
        [MBProgressHUD showError:errorMessage toView:self.view];
        if (self.page > 1) {
            self.page --;
        }
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
        [shareParams SSDKSetupShareParamsByText:@"发现一件好货，分享给你，再不点就没了！"
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
- (void)clickBackItemToPop {
    if (self.type == 3 || self.type == 4) {
        [self.navigationController popViewControllerAnimated:YES];
    }else {
        [self.navigationController popViewControllerAnimated:NO];
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
