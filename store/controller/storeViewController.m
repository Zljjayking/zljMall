//
//  storeViewController.m
//  Distribution
//
//  Created by hchl on 2018/7/23.
//  Copyright © 2018年 hchl. All rights reserved.
//

#import "storeViewController.h"
#import "fxSlideShowHeadView.h"
#import "goodsCollectionViewCell.h"
#import "hotGoodsCollectionViewCell.h"
#import "googsInfoViewController.h"
#import "shoppingCartViewController.h"
#import "searchGoodsViewController.h"
#import "shoppingCartModel.h"
#import "bannerModel.h"
#import "baseWebViewController.h"
#import "AYCheckManager.h"
#import <JPush/JPUSHService.h>
#import "categorySearchViewController.h"

#import "goodsCollectionCell.h"
#import "hotGoodsCollectionCell.h"
#import "spellViewController.h"
#import "loginAndRegisterViewController.h"
@interface storeViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
/* collectionView */
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UIButton *cartBtn;//naviBar购物车按钮
@property (nonatomic, strong) UIButton *msgBtn;//naviBar消息按钮
@property (nonatomic, strong) UIImageView *titleImageV;//naviBar 搜索框
@property (nonatomic, strong) UIImageView *searchImageV;//放大镜
@property (nonatomic, strong) UILabel *titleLabel;//搜索
@property (nonatomic, assign) CGFloat offset;//偏移量
@property (nonatomic, strong) NSMutableArray *goodsArr;
@property (nonatomic, assign) NSInteger page;//请求页
@property (nonatomic, strong) NSMutableArray *bannerArr;
@property (nonatomic, strong) NSMutableArray *imageArr;
@property (nonatomic, strong) NSString *shareUrlStr;
@end

@implementation storeViewController
static NSString *const goodsCollectionViewCellID = @"goodsCollectionViewCell";
static NSString *const hotGoodsCollectionViewCellID = @"hotGoodsCollectionViewCell";
static NSString *const goodsCollectionCellID = @"goodsCollectionCell";
static NSString *const hotGoodsCollectionCellID = @"hotGoodsCollectionCell";

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.frame = CGRectMake(0, -naviHeight, kScreenWidth, kScreenHeight+naviHeight - tabHeight);
        _collectionView.showsVerticalScrollIndicator = NO;
        [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
        [_collectionView registerClass:[fxSlideShowHeadView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"head"];
        [_collectionView registerNib:[UINib nibWithNibName:goodsCollectionViewCellID bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:goodsCollectionViewCellID];
        [_collectionView registerNib:[UINib nibWithNibName:hotGoodsCollectionViewCellID bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:hotGoodsCollectionViewCellID];
        [_collectionView registerNib:[UINib nibWithNibName:goodsCollectionCellID bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:goodsCollectionCellID];
        [_collectionView registerNib:[UINib nibWithNibName:hotGoodsCollectionCellID bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:hotGoodsCollectionCellID];
        [self.view addSubview:_collectionView];
    }
    return _collectionView;
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self getNetwork];
    NSString *isCheck = [FXObjManager dc_readUserDataForKey:BOOLCheckVersion];
    
    if (![Utils isBlankString:isCheck] && ![isCheck boolValue]) {
        AYCheckManager *checkManger = [AYCheckManager sharedCheckManager];
        checkManger.countryAbbreviation = @"cn";
        [checkManger checkVersionWithAlertTitle:@"发现新版本" nextTimeTitle:@"" confimTitle:@"前往更新" skipVersionTitle:@""];
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.page = 1;
    self.goodsArr = @[].mutableCopy;
    self.bannerArr = @[].mutableCopy;
    self.imageArr = @[].mutableCopy;
    [self setNavigationBar];
    [self requestBanner];
    [self setUpView];
    NSArray *fontFamilies = [UIFont familyNames];
    for (NSString *fontFamily in fontFamilies)
    {
        NSArray *fontNames = [UIFont fontNamesForFamilyName:fontFamily];
        NSLog (@">>> fontFamily : %@ , fontNames : %@", fontFamily, fontNames);
    }
    
    self.blankV = [[blankView alloc]initWithFrame:CGRectMake(kScreenWidth/2.0-40, self.collectionView.center.y+100, 80, 80) imageName:@"noData" title:@"暂无商品数据"];
    
    [self.collectionView addSubview:self.blankV];
    self.blankV.hidden = YES;
    
    if (![[NSUserDefaults standardUserDefaults] boolForKey:BOOLFORKEY]) {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:BOOLFORKEY];
        [self requestAppInfo];
    }
}
- (void)requestAppInfo {
    [[ZLJNetWorkManager defaultManager] sendRequestMethod:HTTPMethodPOST isLogin:NO isJsonRequest:NO serverUrl:requestHost apiPath:appInfoUrl parameters:nil progress:^(NSProgress * _Nullable progress) {
        
    } success:^(BOOL isSuccess, id  _Nullable responseObject) {
        NSDictionary *dataDic = [NSDictionary changeType:responseObject];
        NSString *code = dataDic[@"code"];
        
        if ([code integerValue] == 200) {
            NSDictionary *dic = dataDic[@"data"];
            [FXObjManager dc_saveUserData:dic forKey:appInfoStr];
            
        }
    } failure:^(NSString * _Nullable errorMessage) {
        
    }];
}

- (void)requestBanner {
    
    [[ZLJNetWorkManager defaultManager] sendRequestMethod:HTTPMethodPOST isLogin:NO isJsonRequest:NO serverUrl:requestHost apiPath:bannerUrl parameters:nil progress:^(NSProgress * _Nullable progress) {
        
    } success:^(BOOL isSuccess, id  _Nullable responseObject) {
        NSDictionary *dataDic = [NSDictionary changeType:responseObject];
        if (dataDic) {
            NSString *code = dataDic[@"code"];
            NSString *msg = dataDic[@"message"];
            if ([code integerValue] == 200) {
                [self.imageArr removeAllObjects];
                self.bannerArr = [bannerModel mj_objectArrayWithKeyValuesArray:dataDic[@"data"][@"banners"]];
                if (self.bannerArr.count == 0) {
                    [self.bannerArr addObject:@"banner"];
                }
                for (bannerModel *model in self.bannerArr) {
                    NSString *imageUrl = [NSString stringWithFormat:@"%@%@",imageHost,model.url];
                    [self.imageArr addObject:imageUrl];
                }
                [self.collectionView reloadData];
                
                [self requestData];
            } else {
                NSString *showError = [FXObjManager dc_readUserDataForKey:BOOLShowError];
                if (![showError isEqualToString:@"0"]) {
                    [MBProgressHUD showError:msg toView:self.view];
                    [FXObjManager dc_saveUserData:@"1" forKey:BOOLShowError];
                }
            }
        } else {
            NSString *showError = [FXObjManager dc_readUserDataForKey:BOOLShowError];
            if (![showError isEqualToString:@"0"]) {
                [MBProgressHUD showError:@"请求出错，请稍后再试" toView:self.view];
                [FXObjManager dc_saveUserData:@"1" forKey:BOOLShowError];
            }
            
        }
    } failure:^(NSString * _Nullable errorMessage) {
        NSString *showError = [FXObjManager dc_readUserDataForKey:BOOLShowError];
        if (![showError isEqualToString:@"0"]) {
            [MBProgressHUD showError:errorMessage toView:self.view];
            [FXObjManager dc_saveUserData:@"1" forKey:BOOLShowError];
        }
        
    }];
}
- (void)requestData {
    
    [MBProgressHUD showMessage:@"加载中" toView:self.view];
    NSString *page = [NSString stringWithFormat:@"%ld",(long)self.page];
    NSDictionary *paramaters = @{@"page":page,@"size":@"10",@"house":@"0",@"paixu":@"1",@"userId":self.myInfoM.ID,@"flag":@"0"};
    [[ZLJNetWorkManager defaultManager] sendRequestMethod:HTTPMethodPOST isLogin:NO isJsonRequest:YES serverUrl:requestHost apiPath:goodsListUrl parameters:paramaters progress:^(NSProgress * _Nullable progress) {
        
    } success:^(BOOL isSuccess, id  _Nullable responseObject) {
        NSDictionary *dataDic = [NSDictionary changeType:responseObject];
        [self.collectionView.mj_header endRefreshing];
        [self.collectionView.mj_footer endRefreshing];
        if (dataDic) {
            NSString *code = dataDic[@"code"];
            NSString *message = dataDic[@"message"];
            
            if ([code isEqualToString:@"200"]) {
                NSDictionary *goodsDataDic = dataDic[@"data"];
                if ([goodsDataDic isKindOfClass:[NSDictionary class]]) {
                    NSArray *dataArr = dataDic[@"data"][@"goodsList"];
                    //2.3.8.9
                    NSArray *goodsArr = [shoppingCartModel mj_objectArrayWithKeyValuesArray:dataArr];
                    if (self.page == 1) {
                        [self.goodsArr removeAllObjects];
                        if (goodsArr.count == 0) {
                            self.collectionView.mj_footer = nil;
                        } else {
                            self.collectionView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
                                self.page ++;
                                [self requestData];
                            }];
                        }
                    }
                    [self.goodsArr addObjectsFromArray:goodsArr];
                    if (goodsArr.count<10) {
                        [self.collectionView.mj_footer endRefreshingWithNoMoreData];
                    }
                    if (self.goodsArr.count == 0) {
                        self.blankV.hidden = NO;
                    } else {
                        self.blankV.hidden = YES;
                    }
                }else {
                    if (self.page == 1) {
                        [self.goodsArr removeAllObjects];
                        self.collectionView.mj_footer = nil;
                    }else {
                        self.page --;
                    }
                    if (self.goodsArr.count == 0) {
                        self.blankV.hidden = NO;
                    } else {
                        self.blankV.hidden = YES;
                    }
                }
                
            } else {
                
                NSString *showError = [FXObjManager dc_readUserDataForKey:BOOLShowError];
                if (![showError isEqualToString:@"0"]) {
                    [MBProgressHUD showError:message toView:self.view];
                    [FXObjManager dc_saveUserData:@"1" forKey:BOOLShowError];
                }
                if (self.page > 1) {
                    self.page --;
                }else {
                    self.collectionView.mj_footer = nil;
                    self.blankV.hidden = NO;
                    self.blankV.centerImage = @"loadFailed";
                    self.blankV.signTitle = @"加载失败，请稍后重试";
                }
            }
            
        } else {
            NSString *showError = [FXObjManager dc_readUserDataForKey:BOOLShowError];
            if (![showError isEqualToString:@"0"]) {
                [MBProgressHUD showError:@"请求出错，请稍后再试" toView:self.view];
                [FXObjManager dc_saveUserData:@"1" forKey:BOOLShowError];
            }
            
            if (self.page > 1) {
                self.page --;
            }else {
                self.collectionView.mj_footer = nil;
                self.blankV.hidden = NO;
                self.blankV.centerImage = @"loadFailed";
                self.blankV.signTitle = @"加载失败，请稍后重试";
            }
            
        }
        
        [self.collectionView reloadData];
    } failure:^(NSString * _Nullable errorMessage) {
        [self.collectionView.mj_header endRefreshing];
        [self.collectionView.mj_footer endRefreshing];
        NSString *showError = [FXObjManager dc_readUserDataForKey:BOOLShowError];
        if (![showError isEqualToString:@"0"]) {
            [MBProgressHUD showError:errorMessage toView:self.view];
            [FXObjManager dc_saveUserData:@"1" forKey:BOOLShowError];
        }
        
        if (self.page > 1) {
            self.page --;
        } else {
            self.collectionView.mj_footer = nil;
            self.blankV.hidden = NO;
            self.blankV.centerImage = @"loadFailed";
            self.blankV.signTitle = @"加载失败，请稍后重试";
        }
        
    }];
    [MBProgressHUD hideHUDForView:self.view];
    
}
- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent; //返回白色
    //return UIStatusBarStyleDefault;    //返回黑色
}
- (void)setDataArray {
    
    
    for (int i=0; i<self.goodsArr.count; i++) {
        shoppingCartModel *model = self.goodsArr[i];
        NSMutableArray *images = @[].mutableCopy;
        for (GoodsImageModel *imageModel in model.goodsProListVos) {
            [images addObject:imageModel.goodsPreview];
        }
        model.images = images;
        
    }
    
    //显示加载中
}
- (void)setUpView {
    self.collectionView.backgroundColor = myWhite;
    self.collectionView.mj_header = [FXRefreshGifHeader headerWithRefreshingBlock:^{
        [FXSpeedy fx_callFeedback]; //触动
        self.page = 1;
        [self requestBanner];
        
    }];
    self.collectionView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        self.page++;
        [self requestData];
    }];
    [self.view addSubview:self.naviBarView];
    
}
- (void)setNavigationBar {
    UIButton *rightBtnOne = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 40)];
    [rightBtnOne setImage:[UIImage imageNamed:@"home_icon_basket"] forState:UIControlStateNormal];
    [rightBtnOne setTitle:@"购物车" forState:UIControlStateNormal];
    rightBtnOne.titleLabel.font = [UIFont systemFontOfSize:8];
    rightBtnOne.titleLabel.textAlignment = NSTextAlignmentCenter;
    rightBtnOne.titleRect = CGRectMake(5, 28, 30, 8);
    rightBtnOne.imageRect = CGRectMake(10, 3, 20, 20);
    self.cartBtn = rightBtnOne;
    [rightBtnOne addTarget:self action:@selector(goToShoppingCart) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *rightBtnTwo = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBtnTwo.frame =  CGRectMake(0, 0, 30, 40);
    [rightBtnTwo setImage:[UIImage imageNamed:@"categorySearch"] forState:UIControlStateNormal];
    [rightBtnTwo setTitle:@"分类" forState:UIControlStateNormal];
    rightBtnTwo.titleLabel.font = [UIFont systemFontOfSize:8];
    rightBtnTwo.titleLabel.textAlignment = NSTextAlignmentCenter;
    rightBtnTwo.titleRect = CGRectMake(0, 28, 30, 8);
    rightBtnTwo.imageRect = CGRectMake(5, 3, 20, 20);
    self.msgBtn = rightBtnTwo;
    [rightBtnTwo addTarget:self action:@selector(goToCategorySearch) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *itemOne = [[UIBarButtonItem alloc] initWithCustomView:self.cartBtn];
    UIBarButtonItem *itemTwo = [[UIBarButtonItem alloc] initWithCustomView:self.msgBtn];
    NSArray *itemArr = @[itemOne];
//    NSArray *itemArr = @[itemOne];
    self.navigationItem.rightBarButtonItem = itemOne;
    self.navigationItem.leftBarButtonItem = itemTwo;
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0+(itemArr.count==2?270*KAdaptiveRateWidth:310*KAdaptiveRateWidth), 30)];
    titleView.backgroundColor = [UIColor clearColor];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickToSearch)];
    [titleView addGestureRecognizer:tap];
//    titleView
    UIImageView *imageV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"search_bg_white"]];
    imageV.frame = CGRectMake(10*KAdaptiveRateWidth, 0, 240*KAdaptiveRateWidth, 30);
    [titleView addSubview:imageV];
    self.titleImageV = imageV;
    
    UIImageView *searchImageV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"home_icon_search"]];
    searchImageV.frame = CGRectMake(15, 6.5, 17, 17);
    [imageV addSubview:searchImageV];
    self.searchImageV = searchImageV;
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(40, 10, 100, 10)];
    titleLabel.textColor = myWhite;
    titleLabel.text = @"搜索商品";
    titleLabel.font = [UIFont systemFontOfSize:12];
    [imageV addSubview:titleLabel];
    self.titleLabel = titleLabel;
    
    self.navigationItem.titleView = titleView;
}
- (void)clickToSearch {
    searchGoodsViewController *search = [searchGoodsViewController new];
    search.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:search animated:NO];
}
- (void)goToShoppingCart {
    NSString *isLogin = [FXObjManager dc_readUserDataForKey:BOOLIsLogin];
    self.isLogin = [isLogin boolValue];
    if (!self.isLogin) {
        loginAndRegisterViewController *loginVC = [loginAndRegisterViewController new];
        UINavigationController *loginNavi = [[UINavigationController alloc] initWithRootViewController:loginVC];
        [self presentViewController:loginNavi animated:YES completion:^{
            
        }];
    }else {
        shoppingCartViewController *shoppingCart = [shoppingCartViewController new];
        shoppingCart.fromWhere = 1;
        shoppingCart.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:shoppingCart animated:YES];
    }
    
}
- (void)goToCategorySearch {
    categorySearchViewController *categorySearch = [categorySearchViewController new];
    categorySearch.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:categorySearch animated:YES];
}
#pragma mark - <UICollectionViewDataSource>
- (NSInteger) numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.goodsArr.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    shoppingCartModel *model = self.goodsArr[indexPath.item];
    NSString *account = [FXObjManager dc_readUserDataForKey:@"account"];
    if (indexPath.item == 0) {
        hotGoodsCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:hotGoodsCollectionCellID forIndexPath:indexPath];
        cell.goodsModel = model;
        
        NSString *goodsImage = [NSString stringWithFormat:@"%@%@",imageHost,model.goodsPreview];

        cell.shareBlock = ^{
            if (![Utils isBlankString:self.myInfoM.userGrade] && [self.myInfoM.userGrade integerValue] <= 1) {
                NSString *shareUrlStr = [NSString stringWithFormat:@"%@app/user/toDetail/%@?mobilePhone=%@",shareHostTest,model.ID
                                         ,account];
                if ([model.isGroup isEqualToString:@"1"]) {
                    shareUrlStr = [NSString stringWithFormat:shareGroupGoodsHost,model.ID,account];
                }
                NSString *title = [NSString stringWithFormat:@"%@",model.goodsName];
                [self shareGoodsWithUrl:shareUrlStr title:title imageUrl:goodsImage];

            } else {
                [MBProgressHUD showToastText:@"省、市代无法分享" toView:self.navigationController.view];
            }
        };
        return cell;
    } else {
        goodsCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:goodsCollectionCellID forIndexPath:indexPath];
        cell.goodsModel = model;
        NSString *goodsImage = [NSString stringWithFormat:@"%@%@",imageHost,model.goodsPreview];

        cell.shareBlock = ^{
            if (![Utils isBlankString:self.myInfoM.userGrade] && [self.myInfoM.userGrade integerValue] <= 1) {
                NSString *shareUrlStr = [NSString stringWithFormat:@"%@app/user/toDetail/%@?mobilePhone=%@",shareHostTest,model.ID
                                         ,account];
                if ([model.isGroup isEqualToString:@"1"]) {
                    shareUrlStr = [NSString stringWithFormat:shareGroupGoodsHost,model.ID,account];
                }
                NSString *title = [NSString stringWithFormat:@"%@",model.goodsName];
                [self shareGoodsWithUrl:shareUrlStr title:title imageUrl:goodsImage];
                
            } else {
                [MBProgressHUD showToastText:@"省、市代无法分享" toView:self.navigationController.view];
            }
        };
        return cell;
    }
}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    UICollectionReusableView *reusableview = nil;
    if (kind == UICollectionElementKindSectionHeader){
        fxSlideShowHeadView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"head" forIndexPath:indexPath];
        headerView.buttonView.hidden = NO;
        NSString *account = [FXObjManager dc_readUserDataForKey:@"account"];
        if ([account isEqualToString:testNum]) {
            self.imageArr = @[@"banner1",@"banner2",@"banner3",@"banner4"].mutableCopy;
            headerView.buttonView.hidden = YES;
        }
        headerView.imageGroupArray = self.imageArr;
        headerView.subButtonBlock = ^(NSInteger index) {
#pragma mark == 按钮的点击事件
            if (index == 1) {
//                spellViewController *spell = [spellViewController new];
//                spell.hidesBottomBarWhenPushed = YES;
//                [self.navigationController pushViewController:spell animated:YES];
                self.tabBarController.selectedIndex = 1;
            }else if (index == 2){
                self.tabBarController.selectedIndex = 3;
            }else {
                [self goToCategorySearch];
            }
        };
        headerView.bannerBlock = ^(NSInteger index) {
#pragma mark == 点击banner事件
            id obj = self.bannerArr[index];
            if ([obj isKindOfClass:[NSString class]]) {
                
            } else {
                bannerModel *bannerM = obj;
                if ([bannerM.type isEqualToString:@"1"]) {
                    if (![Utils isBlankString:bannerM.action]) {
                        baseWebViewController *webVC = [baseWebViewController new];
                        webVC.urlStr = bannerM.action;
                        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:webVC];
                        nav.navigationBar.tintColor = [UIColor colorWithRed:0.322 green:0.322 blue:0.322 alpha:1.00];
                        webVC.navigationController.navigationBar.translucent = NO;
                        [self presentViewController:nav animated:YES completion:nil];
                    }
                } else if ([bannerM.type isEqualToString:@"2"]){
                    if (![Utils isBlankString:bannerM.action]) {
                        googsInfoViewController *goodsInfo = [googsInfoViewController new];
                        goodsInfo.hidesBottomBarWhenPushed = YES;
                        goodsInfo.goodsID = bannerM.action;
                        [self.navigationController pushViewController:goodsInfo animated:YES];
                    }
                }
            }
        };
        reusableview = headerView;
    }
    return reusableview;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
//        if (indexPath.item == 0) {
//            return CGSizeMake(kScreenWidth , 250*KAdaptiveRateWidth);
//        }
//        return CGSizeMake(kScreenWidth , 200*KAdaptiveRateWidth);
        if (indexPath.item == 0) {
            return CGSizeMake(kScreenWidth , ((kScreenWidth-26)/349.0)*187.0+66.5+62);
        }
        return CGSizeMake(kScreenWidth , ((kScreenWidth-26)/349.0)*187.0+18.5+62);

    }
    return CGSizeZero;
}
#pragma mark - head宽高
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    
    if (section == 0) {
        NSString *account = [FXObjManager dc_readUserDataForKey:@"account"];
        if ([account isEqualToString:testNum]) {
            return CGSizeMake(kScreenWidth, 230*KAdaptiveRateWidth); //图片滚动的宽高
        }
        return CGSizeMake(kScreenWidth, 315*KAdaptiveRateWidth); //图片滚动的宽高
    }
    return CGSizeZero;
}
#pragma mark - foot宽高
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
    return CGSizeZero;
}

#pragma mark - <UICollectionViewDelegateFlowLayout>
#pragma mark - X间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return (section == 5) ? 4 : 0;
}
#pragma mark - Y间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return (section == 5) ? 4 : 0;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        shoppingCartModel *model = self.goodsArr[indexPath.item];
        googsInfoViewController *goodsInfo = [googsInfoViewController new];
        goodsInfo.hidesBottomBarWhenPushed = YES;
        model.num = @"0";
        goodsInfo.model = model;
        goodsInfo.goodsID = model.ID;
        goodsInfo.goodsPreview = model.goodsPreview;
        goodsInfo.isGroup = [model.isGroup boolValue];
        [self.navigationController pushViewController:goodsInfo animated:YES];
    }
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    //图片上下偏移量
    CGFloat imageOffsetY = scrollView.contentOffset.y+naviHeight;
    [self setNaviBarItemsAndAlphaWithOffset:imageOffsetY];
}
- (void)setNaviBarItemsAndAlphaWithOffset:(CGFloat)imageOffsetY {
    self.offset = imageOffsetY;
    if (imageOffsetY < 0) {
        self.naviBarView.alpha = 0;
    } else {
        self.naviBarView.alpha = imageOffsetY/(naviHeight+80)*1.0;
        if (imageOffsetY/(naviHeight+80)*1.0 >= 0.7) {
            [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
//            [self.navigationController.navigationBar setTintColor:RGB(20, 20, 20)];
            [self.cartBtn setImage:[UIImage imageNamed:@"home_icon_basket_black"] forState:UIControlStateNormal];
            [self.cartBtn setTitleColor:RGB(20, 20, 20) forState:UIControlStateNormal];
            
            [self.msgBtn setImage:[UIImage imageNamed:@"categorySearch_black"] forState:UIControlStateNormal];
            [self.msgBtn setTitleColor:RGB(20, 20, 20) forState:UIControlStateNormal];
            
            self.titleImageV.image = [UIImage imageNamed:@"search_bg_gray"];
            
            self.searchImageV.image = [UIImage imageNamed:@"nav_icon_search"];
            
            self.titleLabel.textColor = RGB(153, 153, 153);
            
        } else {
            [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
//            [self.navigationController.navigationBar setTintColor:myWhite];
            [self.cartBtn setImage:[UIImage imageNamed:@"home_icon_basket"] forState:UIControlStateNormal];
            [self.cartBtn setTitleColor:myWhite forState:UIControlStateNormal];
            
            [self.msgBtn setImage:[UIImage imageNamed:@"categorySearch"] forState:UIControlStateNormal];
            [self.msgBtn setTitleColor:myWhite forState:UIControlStateNormal];
            
            self.titleImageV.image = [UIImage imageNamed:@"search_bg_white"];
            
            self.searchImageV.image = [UIImage imageNamed:@"home_icon_search"];
            
            self.titleLabel.textColor = myWhite;
        }
    }
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    CGFloat imageOffsetY = self.offset;
    [self setNaviBarItemsAndAlphaWithOffset:imageOffsetY];
}
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
//    self.naviBarView.alpha = 0;
}


- (void)pushAd {
//    ADViewController *advc = [[ADViewController alloc] init];
//    [self.navigationController pushViewController:advc animated:YES];
}

- (void)shareGoodsWithUrl:(NSString *)url title:(NSString *)title imageUrl:(NSString *)goodsImage{
    NSURL *shareBgUrl = [NSURL URLWithString:goodsImage];
    UIImageView *imageV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    //placeholderImage:[UIImage imageNamed:@"banner"]
    [imageV sd_setImageWithURL:shareBgUrl placeholderImage:[UIImage imageNamed:@"banner"] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
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
        NSData *imageData = [self compressOriginalImage:image toMaxDataSizeKBytes:30];
        UIImage *shareImage = [UIImage imageWithData:imageData];
        if (imageData.length>32*1024) {
            imageData = [self compressOriginalImage:shareImage toMaxDataSizeKBytes:30];
            shareImage = [UIImage imageWithData:imageData];
        }
        [shareParams SSDKSetupShareParamsByText:@"发现一件好货，分享给你，再不点就没了！"
                                         images:shareImage
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
