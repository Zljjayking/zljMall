//
//  categorySearchViewController.m
//  Distribution
//
//  Created by hchl on 2018/11/16.
//  Copyright © 2018年 hchl. All rights reserved.
//

#import "categorySearchViewController.h"
#import "YHSegmentView.h"
#import "searchHeaderView.h"
#import "categoryGoodsViewController.h"

#import "ClassCategoryTableViewCell.h"
#import "shoppingCartViewController.h"
#import "searchGoodsViewController.h"

#import "ClassGoodsItem.h"
#import "loginAndRegisterViewController.h"
@interface categorySearchViewController ()<UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITextField *searchTf;
@property (nonatomic, strong) UITableView *categoryTableView;
@property (nonatomic, strong) YHSegmentView *segmentView;
@property (nonatomic, assign) BOOL isSearching;
@property (nonatomic, strong) searchHeaderView *headerView;
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, strong) NSString *sort;
@property (nonatomic, assign) BOOL paixu;

@property (nonatomic, strong) NSString *ID;//父类ID
@property (nonatomic, assign) NSInteger selectIndex;//左侧选择的index

@property (nonatomic, strong) NSMutableArray *oneList;//左侧父类
@property (nonatomic, strong) NSMutableArray *twoList;//右边子类
@end

@implementation categorySearchViewController
- (UITableView *)categoryTableView {
    if (!_categoryTableView) {
        _categoryTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, 95, kScreenHeight) style:UITableViewStylePlain];
        _categoryTableView.tableFooterView = [UIView new];
        _categoryTableView.delegate = self;
        _categoryTableView.dataSource = self;
        [_categoryTableView registerClass:[ClassCategoryTableViewCell class] forCellReuseIdentifier:@"ClassCategoryTableViewCell"];
    }
    return _categoryTableView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.isWhiteNavi = YES;
    self.ID = @"-1";//初始传-1
    self.selectIndex = 0;//默认选中第一行
    [self requestData];
    
    [self setupViewCategoryTableView];
    self.navigationItem.leftBarButtonItem = self.backItem;
    [self.view addSubview:self.naviBarView];
    [self settitleView];
}
- (void)requestData {
    
    [[ZLJNetWorkManager defaultManager]sendRequestMethod:HTTPMethodPOST isLogin:NO isJsonRequest:NO serverUrl:requestHost apiPath:goodsClassUrl parameters:@{@"id":self.ID} progress:^(NSProgress * _Nullable progress) {
        
    } success:^(BOOL isSuccess, id  _Nullable responseObject) {
        NSDictionary *dataDic = [NSDictionary changeType:responseObject];
        if (dataDic) {
            NSString *code = dataDic[@"code"];
            NSString *message = dataDic[@"message"];
            if ([code isEqualToString:@"200"]) {
                if ([self.ID isEqualToString:@"-1"]) {
                    NSArray *one = dataDic[@"data"][@"first"];
                    self.oneList = [ClassSubItem mj_objectArrayWithKeyValuesArray:one];
                    [self.categoryTableView reloadData];
                    if (self.oneList.count) {
                        [self.categoryTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];
                    }
                    
                }
                
                NSArray *two = dataDic[@"data"][@"two"];
                
                self.twoList = [ClassGoodsItem mj_objectArrayWithKeyValuesArray:two];
                
                [self setupSegmentView];
            }else {
                [MBProgressHUD showError:message toView:self.view];
            }
        }else {
            [MBProgressHUD showError:@"请求出错，请稍后再试" toView:self.view];
        }
    } failure:^(NSString * _Nullable errorMessage) {
        [MBProgressHUD showError:errorMessage toView:self.view];
    }];
}

- (void)setupSegmentView {
    
    [self.segmentView removeFromSuperview];
    
    NSMutableArray *mutArr = [NSMutableArray array];
    
    NSMutableArray *titleArr = @[].mutableCopy;
    
    for (int i = 0; i < self.twoList.count; i++) {
        ClassGoodsItem *goodsItem = self.twoList[i];
        [titleArr addObject:goodsItem.categoryName];
        categoryGoodsViewController *tabVC = [categoryGoodsViewController new];
        tabVC.index = i;
        tabVC.goodsArr = goodsItem.threeList;
        tabVC.view.frame = CGRectMake(0, 0, kScreenWidth-105, kScreenHeight);
        [mutArr addObject:tabVC];
    }
//    for (int i = 0; i < 10; i++) {
//        [titleArr addObject:[NSString stringWithFormat:@"及时%i",i]];
//        categoryGoodsViewController *tabVC = [categoryGoodsViewController new];
//        tabVC.index = i;
//        
//        tabVC.view.frame = CGRectMake(0, 0, kScreenWidth-105, kScreenHeight);
//        [mutArr addObject:tabVC];
//    }
    YHSegmentView *segmentView = [[YHSegmentView alloc] initWithFrame:CGRectMake(100, CGRectGetMaxY(self.navigationController.navigationBar.frame), kScreenWidth-105, [UIScreen mainScreen].bounds.size.height - CGRectGetMaxY(self.navigationController.navigationBar.frame)) ViewControllersArr:[mutArr copy] TitleArr:titleArr TitleNormalSize:16 TitleSelectedSize:16 SegmentStyle:YHSegementStyleIndicate ParentViewController:self ReturnIndexBlock:^(NSInteger index) {
        NSLog(@"点击了%ld模块",(long)index);
    } ReturnContentClickBlock:^(id object){
        ClassSubItem *item = object;
        searchGoodsViewController *search = [searchGoodsViewController new];
        search.type = 3;
        search.categoryId = item.ID;
        [self.navigationController pushViewController:search animated:YES];
    }];
    self.segmentView = segmentView;
    [self.view addSubview:segmentView];
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
- (void)textFieldDidChanged:(UITextField *)textField {
    
}
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    [textField endEditing:YES];
    searchGoodsViewController *search = [searchGoodsViewController new];
    [self.navigationController pushViewController:search animated:NO];
}
//- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
//
//}
- (void)setupViewCategoryTableView {
    [self.view addSubview:self.categoryTableView];
    
}
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
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.oneList.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ClassCategoryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ClassCategoryTableViewCell" forIndexPath:indexPath];
    ClassSubItem *item = self.oneList[indexPath.row];
    cell.titleLabel.text = item.categoryName;
//    if (self.selectIndex == indexPath.row) {
//        cell.isSelect = YES;
//    }else {
//        cell.isSelect = NO;
//    }
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    ClassSubItem *item = self.oneList[indexPath.row];
    self.ID = item.ID;
    self.selectIndex = indexPath.row;
    [self requestData];
}
#pragma mark ===== textFieldDelegate
//- (BOOL)textFieldShouldReturn:(UITextField *)textField {
//    [textField endEditing:YES];
//    NSString *text = textField.text;
//    if ([Utils isBlankString:text]) {
//        self.isSearching = NO;
//        _tableView.backgroundColor = myWhite;
//        [self.headerView removeFromSuperview];
//    } else {
//        [self searchingWithText:text];
//
//    }
//    [self.tableView reloadData];
//    return YES;
//}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
