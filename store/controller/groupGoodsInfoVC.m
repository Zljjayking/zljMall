//
//  groupGoodsInfoVC.m
//  Distribution
//
//  Created by hchl on 2018/12/26.
//  Copyright © 2018年 hchl. All rights reserved.
//

#import "groupGoodsInfoVC.h"
#import <WebKit/WebKit.h>
#import <WebKit/WKWebView.h>
#import "goodsImagesHeaderView.h"
#import "goodsInfoOverFooterView.h"
#import "goodsInfoCollectionViewCell.h"
#import "goodsInfoTwoCollectionViewCell.h"
#import "myTabBarController.h"
#import "shoppingCartViewController.h"
#import "fxGoodsPopView.h"
#import "shoppingCartModel.h"
#import "goodsOrderViewController.h"
#import <MagicWebViewWebP/MagicWebViewWebPManager.h>
@interface groupGoodsInfoVC ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,WKNavigationDelegate,YBPopupMenuDelegate,UIWebViewDelegate,WKUIDelegate,WKNavigationDelegate>
@property (strong, nonatomic) UIScrollView *scrollerView;
@property (strong, nonatomic) UICollectionView *collectionView;
@property (strong, nonatomic) WKWebView *webView;
@property (strong, nonatomic) UIScrollView *imageScroll;//图文详情页面
@property (nonatomic, strong) UIImageView *detailImage;
@property (nonatomic, assign) CGFloat offset;//偏移量
@property (nonatomic, assign) BOOL ispaged;//scrollerView是否翻页了
@property (nonatomic, strong) NSMutableArray *dataArr;//
@property (nonatomic, strong) UIButton *buyBtn;//购买按钮
@property (nonatomic, strong) UIButton *cartBtn;//购物车按钮
@property (nonatomic, assign) BOOL isCollect;//是否加入收藏1.已经加入 0.未加入
@property (nonatomic, strong) UIButton *collectBtn;//购物车按钮
@property (nonatomic, strong) UIButton *joinCartBtn;//加入购物车按钮
@property (nonatomic, strong) fxGoodsPopView *popView;
@property (nonatomic, strong) NSMutableArray *goodsImagesArray;
@property (nonatomic, strong) goodsImagesHeaderView *headView;
@property (nonatomic, strong) goodsInfoOverFooterView *footView;
@property (nonatomic, assign) CGSize fittingSize;
@property (nonatomic, assign) NSInteger popMenuIndex;

@end

@implementation groupGoodsInfoVC
static NSString *goodsImagesHeaderViewID = @"goodsImagesHeaderView";
static NSString *footViewID = @"footView";
static NSString *goodsInfoOverFooterViewID = @"goodsInfoOverFooterView";
static NSString *goodsInfoCollectionViewCellID = @"goodsInfoCollectionViewCell";
static NSString *goodsInfoTwoCollectionViewCellID = @"goodsInfoTwoCollectionViewCell";

static NSString *lastNum_;
static NSArray *lastSeleArray_;
- (UIScrollView *)scrollerView
{
    if (!_scrollerView) {
        _scrollerView = [[UIScrollView alloc] initWithFrame:CGRectZero];
        _scrollerView.backgroundColor = redBG;
        _scrollerView.contentSize = CGSizeMake(kScreenWidth, kScreenHeight * 2);
        _scrollerView.pagingEnabled = YES;
        _scrollerView.scrollEnabled = NO;
        
    }
    return _scrollerView;
}
- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
        layout.minimumLineSpacing = 0;//y
        layout.minimumInteritemSpacing = 0;//x
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.showsVerticalScrollIndicator = NO;
        
        [_collectionView registerClass:[goodsImagesHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:goodsImagesHeaderViewID];
        [_collectionView registerClass:[goodsInfoOverFooterView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:goodsInfoOverFooterViewID];
        [_collectionView registerNib:[UINib nibWithNibName:goodsInfoCollectionViewCellID bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:goodsInfoCollectionViewCellID];
        [_collectionView registerNib:[UINib nibWithNibName:goodsInfoTwoCollectionViewCellID bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:goodsInfoTwoCollectionViewCellID];
    }
    return _collectionView;
}

- (WKWebView *)webView
{
    if (!_webView) {
        _webView = [[WKWebView alloc] initWithFrame:CGRectZero];
        _webView.scrollView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
        _webView.UIDelegate = self;
        _webView.navigationDelegate = self;
        _webView.scrollView.scrollIndicatorInsets = _webView.scrollView.contentInset;
    }
    return _webView;
}
- (UIScrollView *)imageScroll {
    if (!_imageScroll) {
        _imageScroll = [[UIScrollView alloc] initWithFrame:CGRectZero];
        _imageScroll.backgroundColor = FXBGColor;
    }
    return _imageScroll;
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self getNetwork];
    if (!self.ispaged) {
        CGFloat imageOffsetY = self.offset;
        [self setNaviBarItemsAndAlphaWithOffset:imageOffsetY];
    } else {
        self.naviBarView.alpha = 1.0;
        self.scrollerView.contentOffset = CGPointMake(0, kScreenHeight);
    }
    
    
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.isWhiteNavi = YES;
    
    self.navigationController.swipeBackEnabled = NO;
    // 注册协议支持webP
    [[MagicWebViewWebPManager shareManager] registerMagicURLProtocolWebView:self.webView];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    self.offset = 0.0;
    self.ispaged = NO;
    self.isCollect = NO;
    self.goodsImagesArray = @[].mutableCopy;
    
    self.dataArr = @[@{@"title":@"服务",@"detail":@"在线充值",@"image":@""},
                     @{@"title":@"规格",@"detail":@"选择 参数型号",@"image":@"list_right_icon_choice"}
                     ].mutableCopy;
    
    [self setUpUIs];
    [self requestData];
    [self setUpViewScroller];
    [self setNaviBar];
    
}


- (void)setUpUIs {
    self.view.backgroundColor = FXBGColor;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.extendedLayoutIncludesOpaqueBars = YES;
    self.edgesForExtendedLayout = UIRectEdgeTop;
    
    self.collectionView.backgroundColor = FXBGColor;
    self.scrollerView.backgroundColor = FXBGColor;
    self.imageScroll.backgroundColor = FXBGColor;
    self.scrollerView.frame = CGRectMake(0, (iOS11Later?-naviHeight:0), kScreenWidth, kScreenHeight+(iOS11Later?naviHeight:0));
    
    [self.view addSubview:self.scrollerView];
    
    
    self.collectionView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight+naviHeight-(isIphoneX?tabHeight:50));
    [self.scrollerView addSubview:self.collectionView];
    
    //图文详情页
    //    self.imageScroll.frame = CGRectMake(0, kScreenHeight, kScreenWidth, kScreenHeight-naviHeight-50);
    //    [self.scrollerView addSubview:self.imageScroll];
    
    UIButton * titleBtn= [UIButton buttonWithType:UIButtonTypeCustom];
    titleBtn.imageView.transform = CGAffineTransformRotate(titleBtn.imageView.transform, M_PI); //旋转
    [titleBtn setImage:[UIImage imageNamed:@"Details_Btn_Up"] forState:UIControlStateNormal];
    [titleBtn setTitle:@"下拉返回商品详情" forState:UIControlStateNormal];
    titleBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [titleBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    //    [self.imageScroll addSubview:titleBtn];
    titleBtn.frame = CGRectMake(0, -30, kScreenWidth, 30);
    [self.webView.scrollView addSubview:titleBtn];
    
    
    
    
#pragma mark === 这里是9月26号修改图文详情
    self.webView.frame = CGRectMake(0, 30, kScreenWidth, 1);
    
    self.naviBarView.alpha = 0;
    [self.view addSubview:self.naviBarView];
    //初始化
    lastSeleArray_ = [NSArray array];
    lastNum_ = 0;
    
    
    [self setBottomView];
    
}
- (void)requestData {
    if ([Utils isBlankString:self.goodsID]) {
        [self.collectionView removeFromSuperview];
        [MBProgressHUD showError:@"商品ID有误" toView:self.view];
    }else {
        [MBProgressHUD showMessage:@"加载中..."];
        [[ZLJNetWorkManager defaultManager] sendRequestMethod:HTTPMethodPOST isLogin:NO isJsonRequest:NO serverUrl:requestHost apiPath:goodsDetailedInfoUrl parameters:@{@"goodsId":self.goodsID,@"userId":self.myInfoM.ID} progress:^(NSProgress * _Nullable progress) {
            
        } success:^(BOOL isSuccess, id  _Nullable responseObject) {
            NSDictionary *dataDic = [NSDictionary changeType:responseObject];
            
            if (dataDic) {
                NSString *code = dataDic[@"code"];
                NSString *message = dataDic[@"message"];
                if ([code isEqualToString:@"200"]) {
                    self.model = [shoppingCartModel mj_objectWithKeyValues:dataDic[@"data"][@"goodsInfo"]];
                    self.model.goodsId = self.goodsID;
                    
                    if ([self.model.isHouse isEqualToString:@"1"]) {
                        [self.collectBtn setTitle:@"取消加入" forState:UIControlStateNormal];
                        [self.collectBtn setImage:[UIImage imageNamed:@"collection_pre"] forState:UIControlStateNormal];
                        self.isCollect = YES;
                    }
                    
                    if ([self.model.goodsCategory isEqualToString:@"0"]) {
                        self.dataArr[0] = @{@"title":@"服务",@"detail":@"快递",@"image":@""};
                    }
                    NSMutableArray *images = @[].mutableCopy;
                    for (int i=0;i<self.model.goodsProListVos.count;i++) {
                        GoodsImageModel *model = self.model.goodsProListVos[i];
                        if (i == 0) {
                            self.goodsPreview = model.goodsPreview;
                        }
                        [images addObject:[imageHost stringByAppendingString:model.goodsPreview]];
                    }
                    
                    self.model.goodsPreview = self.goodsPreview;
                    self.model.images = images;
                    [self setUpGoodsUIWebView];
                    [self.collectionView reloadData];
                    [MBProgressHUD hideHUD];
                } else {
                    [self.collectionView reloadData];
                    [MBProgressHUD hideHUD];
                    [MBProgressHUD showError:message toView:self.view];
                }
            } else {
                [self.collectionView reloadData];
                [MBProgressHUD showError:@"请求失败,请稍后再试" toView:self.view];
            }
            
        } failure:^(NSString * _Nullable errorMessage) {
            [MBProgressHUD hideHUD];
            [MBProgressHUD showError:errorMessage toView:self.view];
        }];
    }
    
}
- (void)setBottomView {
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, kScreenHeight-(isIphoneX?tabHeight:50), kScreenWidth, isIphoneX?tabHeight:50)];
    bgView.backgroundColor = FXBGColor;
    [self.view addSubview:bgView];
    
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 50)];
    bottomView.backgroundColor = myWhite;
    [bgView addSubview:bottomView];
    
    self.collectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.collectBtn setTitle:@"加入精选" forState:UIControlStateNormal];
    self.collectBtn.titleLabel.font = [UIFont systemFontOfSize:10];
    [self.collectBtn setTitleColor:RGB(51, 51, 51) forState:UIControlStateNormal];
    self.collectBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.collectBtn setImage:[UIImage imageNamed:@"collection"] forState:UIControlStateNormal];
    [self.collectBtn addTarget:self action:@selector(clickToCollect) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:self.collectBtn];
    self.collectBtn.frame = CGRectMake(0, 0, 60, 50);
    self.collectBtn.titleRect = CGRectMake(0, 33, 60, 12);
    self.collectBtn.imageRect = CGRectMake(18, 8, 22, 22);
    
    self.cartBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.cartBtn setTitle:@"购物车" forState:UIControlStateNormal];
    self.cartBtn.titleLabel.font = [UIFont systemFontOfSize:10];
    [self.cartBtn setTitleColor:RGB(51, 51, 51) forState:UIControlStateNormal];
    self.cartBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.cartBtn setImage:[UIImage imageNamed:@"home_icon_basket_black"] forState:UIControlStateNormal];
    [self.cartBtn addTarget:self action:@selector(clickToCart) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:self.cartBtn];
    self.cartBtn.frame = CGRectMake(60, 0, 60, 50);
    self.cartBtn.titleRect = CGRectMake(0, 33, 60, 12);
    self.cartBtn.imageRect = CGRectMake(18, 8, 22, 22);
    
    self.joinCartBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.joinCartBtn.backgroundColor = RGB(51, 51, 51);
    self.joinCartBtn.titleLabel.font = sysFont;
    [self.joinCartBtn setTitle:@"加入购物车" forState:UIControlStateNormal];
    self.joinCartBtn.frame = CGRectMake(120, 0, (kScreenWidth-120)/2.0+1, 50);
    [bottomView addSubview:self.joinCartBtn];
    [self.joinCartBtn addTarget:self action:@selector(clickToJoinCartAndBuy) forControlEvents:UIControlEventTouchUpInside];
    
    self.buyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.buyBtn.titleLabel.font = sysFont;
    [self.buyBtn setBackgroundImage:[UIImage imageNamed:@"settlement_btn_bg"] forState:UIControlStateNormal];
    [self.buyBtn setTitle:@"立即购买" forState:UIControlStateNormal];
    self.buyBtn.frame = CGRectMake(120+(kScreenWidth-120)/2.0, 0, (kScreenWidth-120)/2.0, 50);
    [bottomView addSubview:self.buyBtn];
    [self.buyBtn addTarget:self action:@selector(clickToBuy) forControlEvents:UIControlEventTouchUpInside];
    
    
}
#pragma mark == 加入精选或取消加入
- (void)clickToCollect {
    if (self.isCollect) {
        [self.collectBtn setTitle:@"加入精选" forState:UIControlStateNormal];
        [self.collectBtn setImage:[UIImage imageNamed:@"collection"] forState:UIControlStateNormal];
    } else {
        [self.collectBtn setTitle:@"取消加入" forState:UIControlStateNormal];
        [self.collectBtn setImage:[UIImage imageNamed:@"collection_pre"] forState:UIControlStateNormal];
    }
    self.isCollect = !self.isCollect;
    NSString *house = [NSString stringWithFormat:@"%d",self.isCollect];
    [self setHouseStatusWithHouse:house];
}
#pragma mark == 加入精选或取消加入网络请求
- (void)setHouseStatusWithHouse:(NSString *)house {
    [[ZLJNetWorkManager defaultManager] sendRequestMethod:HTTPMethodPOST isLogin:NO isJsonRequest:NO serverUrl:requestHost apiPath:collectionGoodsUrl parameters:@{@"goodsId":self.goodsID,@"houseStatus":house,@"userId":self.myInfoM.ID} progress:^(NSProgress * _Nullable progress) {
        
    } success:^(BOOL isSuccess, id  _Nullable responseObject) {
        NSDictionary *dic = [NSDictionary changeType:responseObject];
        NSString *code = dic[@"code"];
        NSString *msg = dic[@"message"];
        if ([code isEqualToString:@"200"]) {
            if ([house isEqualToString:@"1"]) {
                [MBProgressHUD showSuccess:@"加入成功" toView:self.view];
            } else {
                [MBProgressHUD showSuccess:@"取消成功" toView:self.view];
            }
            //需要重新加载精选列表
            [FXObjManager dc_saveUserData:@"0" forKey:BOOLIsLoadMicro];
        }else {
            [MBProgressHUD showSuccess:msg toView:self.view];
        }
    } failure:^(NSString * _Nullable errorMessage) {
        [MBProgressHUD showError:errorMessage toView:self.view];
    }];
}
- (void)clickToCart {
    if (self.fromWhere == 1) {
        if (self.refreshBlock) {
            self.refreshBlock();
        }
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        shoppingCartViewController *shoppingCart = [shoppingCartViewController new];
        shoppingCart.fromWhere = 1;
        [self.navigationController pushViewController:shoppingCart animated:YES];
        [self.headView.detailsV.player pause];
    }
    
}
- (void)clickToJoinCartAndBuy {
    if (![Utils isBlankString:self.myInfoM.userGrade] && [self.myInfoM.userGrade integerValue] == 0) {
        NSString *signTextStr;
        if (self.isGroup) {
            signTextStr = [NSString stringWithFormat:@"会员立减：¥%.2f",[self.model.vipRebatePrice doubleValue]];
        }
        self.popView = [[fxGoodsPopView alloc]initWithCatetory:self.model.goodsStaListVos model:self.model height:366 title:@"加入购物车和立即购买" superView:self.navigationController.view isShowSign:self.isGroup signText:signTextStr];
        self.popView.frame = CGRectMake(0, kScreenHeight, kScreenWidth, 366);
        [self.navigationController.view addSubview:self.popView.bgView];
        [self.navigationController.view addSubview:self.popView];
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
        self.popView.bgView.hidden = NO;
        [UIView animateWithDuration:0.2 animations:^{
            self.popView.frame = CGRectMake(0, kScreenHeight-isIphoneX*33-366, kScreenWidth, 366);
        }];
        WEAKSELF
        self.popView.isPopBlock = ^{
            weakSelf.navigationController.interactivePopGestureRecognizer.enabled = YES;
            
        };
        self.popView.tapBlankBlock = ^(shoppingCartModel *model) {
            weakSelf.model = model;
            
            
            if ([Utils isBlankString:weakSelf.model.standardProperty]) {
                weakSelf.dataArr[1] = @{@"title":@"规格",@"detail":@"选择 参数型号",@"image":@"list_right_icon_choice"};
            } else {
                weakSelf.dataArr[1] = @{@"title":@"规格",@"detail":weakSelf.model.standardProperty,@"image":@"list_right_icon_choice"};
            }
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:2 inSection:0];
            [weakSelf.collectionView reloadItemsAtIndexPaths:@[indexPath]];
        };
        self.popView.addToCartBlcok = ^(shoppingCartModel *model) {
            if (model != nil) {
                [weakSelf addTOShoppingCartWithModel:model];
            }
        };
        self.popView.buyBlock = ^(shoppingCartModel *model) {
            if (model != nil) {
                [weakSelf.headView.detailsV.player pause];
                goodsOrderViewController *goodsOrder = [goodsOrderViewController new];
                weakSelf.model.goodsStandardId = model.goodsStandardId;
                goodsOrder.goodsArr = @[model];
                goodsOrder.type = 2;
                [weakSelf.navigationController pushViewController:goodsOrder animated:YES];
            }
        };
    } else {
        [MBProgressHUD showToastText:@"省、市、区代无法购买商品" toView:self.navigationController.view];
    }
}
- (void)clickToBuy {
    if (![Utils isBlankString:self.myInfoM.userGrade] && [self.myInfoM.userGrade integerValue] == 0) {
        NSString *signTextStr;
        if (self.isGroup) {
            signTextStr = [NSString stringWithFormat:@"全部订单完成后，赚¥0.00到可提现金额"];
        }
        self.popView = [[fxGoodsPopView alloc]initWithCatetory:self.model.goodsStaListVos model:self.model height:366 title:@"立即购买" superView:self.navigationController.view isShowSign:self.isGroup signText:signTextStr];
        self.popView.frame = CGRectMake(0, kScreenHeight, kScreenWidth, 366);
        [self.navigationController.view addSubview:self.popView.bgView];
        [self.navigationController.view addSubview:self.popView];
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
        self.popView.bgView.hidden = NO;
        [UIView animateWithDuration:0.2 animations:^{
            self.popView.frame = CGRectMake(0, kScreenHeight-isIphoneX*33-366, kScreenWidth, 366);
        }];
        WEAKSELF
        self.popView.isPopBlock = ^{
            weakSelf.navigationController.interactivePopGestureRecognizer.enabled = YES;
        };
        self.popView.buyBlock = ^(shoppingCartModel *model) {
            if (model != nil) {
                [weakSelf.headView.detailsV.player pause];
                goodsOrderViewController *goodsOrder = [goodsOrderViewController new];
                weakSelf.model.goodsStandardId = model.goodsStandardId;
                goodsOrder.goodsArr = @[model];
                goodsOrder.type = 2;
                [weakSelf.navigationController pushViewController:goodsOrder animated:YES];
            }
        };
    } else {
        [MBProgressHUD showToastText:@"省、市、区代无法购买商品" toView:self.navigationController.view];
    }
}
- (void)setNaviBar {
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftBtn setBackgroundImage:[UIImage imageNamed:@"details_nav_back"] forState:UIControlStateNormal];
    leftBtn.frame = CGRectMake(0, 0, 30, 30);
    [leftBtn addTarget:self action:@selector(clickToBack) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightBtn setBackgroundImage:[UIImage imageNamed:@"details_nav_more"] forState:UIControlStateNormal];
    rightBtn.frame = CGRectMake(0, 0, 30, 30);
    rightBtn.isShowBadge = NO;
    [rightBtn addTarget:self action:@selector(clickMore:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItem = rightItem;
}
- (void)clickToBack {
    [self.navigationController popViewControllerAnimated:YES];
    [self.headView.detailsV.player.playerLayer removeFromSuperlayer];
    self.headView.detailsV.player.playerLayer = nil;
    self.headView.detailsV.player.player = nil;
}
- (void)clickMore:(UIButton *)item {
    self.popMenuIndex = -1;
    //    NSArray *titleArr = @[@"消息",@"首页",@"我的",@"分享"];
    //    NSArray *iconArr = @[@"dropdown_menu_news",@"dropdown_menu_home",@"dropdown_menu_personal",@"dropdown_menu_share"];
    //    NSArray *msgArr = @[@"2",@"0",@"0",@"0"];
    NSArray *titleArr = @[@"首页",@"我的",@"分享"];
    NSArray *iconArr = @[@"dropdown_menu_home",@"dropdown_menu_personal",@"dropdown_menu_share"];
    NSArray *msgArr = @[@"0",@"0",@"0"];
    
    NSString *account = [FXObjManager dc_readUserDataForKey:@"account"];
    if ([account isEqualToString:testNum]) {
        titleArr = @[@"首页",@"我的"];
        iconArr = @[@"dropdown_menu_home",@"dropdown_menu_personal"];
        msgArr = @[@"0",@"0"];
    }
    [YBPopupMenu showAtPoint:CGPointMake(kScreenWidth-35*KAdaptiveRateWidth, 30+stateBarHeight) titles:titleArr icons:iconArr msgs:msgArr menuWidth:120 otherSettings:^(YBPopupMenu *popupMenu) {
        popupMenu.dismissOnSelected = NO;
        popupMenu.isShowShadow = YES;
        popupMenu.delegate = self;
        popupMenu.offset = 10;
        popupMenu.type = YBPopupMenuTypeDefault;
        popupMenu.rectCorner = UIRectCornerBottomLeft | UIRectCornerBottomRight | UIRectCornerTopLeft | UIRectCornerTopRight;
        //        popupMenu...;
    }];
}
#pragma mark - <UICollectionViewDataSource>
- (NSInteger) collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 3;
}
- (UICollectionViewCell *) collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.item == 0) {
        goodsInfoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:goodsInfoCollectionViewCellID forIndexPath:indexPath];
        cell.goodsPriceLabel.text = [NSString stringWithFormat:@"¥%.2f",[self.model.goodsPrice doubleValue]];
        cell.goodsDetailsLb.text = self.model.goodsName;
        cell.expressageLb.text = [NSString stringWithFormat:@"快递费:¥%.2f",[self.model.fare doubleValue]];
        if ([Utils isBlankString:self.model.fare] || [self.model.fare doubleValue] == 0) {
            cell.expressageLb.text = @"快递费:免运费";
        }
        cell.salesVolumeLb.text = [NSString stringWithFormat:@"月销:%@件",[Utils isBlankString:self.model.num]?@"0":self.model.num];
        cell.placeLb.hidden = YES;
        if (![Utils isBlankString:self.model.vipRebatePrice]) {
            if ([self.model.vipRebatePrice doubleValue] != 0) {
                cell.vipRebateLb.hidden = NO;
                cell.vipRebateLb.text = [NSString stringWithFormat:@" 会员立减：¥%.2f ",[self.model.vipRebatePrice doubleValue]];
            }
        }
        
        cell.shareBlock = ^{
            if (![Utils isBlankString:self.myInfoM.userGrade] && [self.myInfoM.userGrade integerValue] <= 1) {
                NSString *shareUrlStr = [NSString stringWithFormat:@"%@app/user/toDetail/%@?mobilePhone=%@",shareHostTest,self.goodsID
                                         ,self.accountStr];
                NSString *goodsImage = [NSString stringWithFormat:@"%@%@",imageHost,self.goodsPreview];
                NSString *title = [NSString stringWithFormat:@"%@",self.model.goodsName];
                [self shareGoodsWithUrl:shareUrlStr title:title imageUrl:goodsImage];
                
                //                baseWebViewController *webVC = [baseWebViewController new];
                //                NSString *url = [@"app/user/qrcode/" stringByAppendingString:[FXObjManager dc_readUserDataForKey:@"account"]];
                //                webVC.urlStr = [shareHost stringByAppendingString:url];
                //                UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:webVC];
                //                nav.navigationBar.tintColor = [UIColor colorWithRed:0.322 green:0.322 blue:0.322 alpha:1.00];
                //                webVC.naviTitle = @"邀请新人赚赏金";
                //                webVC.navigationController.navigationBar.translucent = NO;
                //                [self presentViewController:nav animated:YES completion:nil];
            } else {
                [MBProgressHUD showToastText:@"省、市代无法分享" toView:self.navigationController.view];
            }
        };
        return cell;
    } else {
        goodsInfoTwoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:goodsInfoTwoCollectionViewCellID forIndexPath:indexPath];
        if (self.dataArr.count>indexPath.item-1) {
            NSDictionary *data = self.dataArr[indexPath.item-1];
            cell.titleLb.text = data[@"title"];
            cell.detailLb.text = data[@"detail"];
            cell.signImage.image = [UIImage imageNamed:data[@"image"]];
        }
        
        return cell;
    }
    
    
}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    UICollectionReusableView *reusableView = nil;
    if (kind == UICollectionElementKindSectionHeader) {
        if (indexPath.section == 0) {
            self.headView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:goodsImagesHeaderViewID forIndexPath:indexPath];
            self.headView.model = self.model;
            if ([Utils isBlankString:self.model.goodsVideo]) {
                self.headView.isHaveVideo = @"0";
                self.headView.shufflingArray = self.model.images;
            } else {
                NSString *videoUrl = [videoHost stringByAppendingString:self.model.goodsVideo];
                NSMutableArray *imageAndVideoArr = [NSMutableArray arrayWithObject:videoUrl];
                [imageAndVideoArr addObjectsFromArray:self.model.images];
                self.headView.isHaveVideo = @"1";
                self.headView.goodsPreview = self.goodsPreview;
                self.headView.shufflingArray = imageAndVideoArr;
                
            }
            reusableView = self.headView;
        }
    } else {
        self.footView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:goodsInfoOverFooterViewID forIndexPath:indexPath];
        reusableView = self.footView;
    }
    return reusableView;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSString *title = self.model.goodsName;
    CGFloat height = [FXSpeedy fx_calculateTextSizeWithText:title WithTextFont:[UIFont systemFontOfSize:14] WithMaxW:350*KAdaptiveRateWidth].height+80;
    return (indexPath.item == 0) ? CGSizeMake(kScreenWidth, height) : CGSizeMake(kScreenWidth, 40);
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    return CGSizeMake(kScreenWidth, 375*KAdaptiveRateWidth);
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
    return CGSizeMake(kScreenWidth, 30+self.fittingSize.height);
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.item == 2) {
        [self clickToJoinCartAndBuy];
    }
}

#pragma mark === 这里是9月26号修改图文详情。 webview 的代理
- (void)webViewDidFinishLoad:(UIWebView *)webView {
    //    CGFloat height = webView.scrollView.contentSize.height;
    //    self.fittingSize = CGSizeMake(kScreenWidth, height);
    //    webView.frame = CGRectMake(0, 30, kScreenWidth, self.fittingSize.height);
    webView.scrollView.scrollEnabled = NO;
    [self.footView addSubview:webView];
    //    [self.collectionView reloadData];
    [webView.scrollView addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew context:nil];
}
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    webView.scrollView.scrollEnabled = NO;
    [webView evaluateJavaScript:@"document.body.offsetHeight" completionHandler:^(id data, NSError * _Nullable error) {
        CGFloat height = [data floatValue];
        //ps:js可以是上面所写，也可以是document.body.scrollHeight;在WKWebView中前者offsetHeight获取自己加载的html片段，高度获取是相对准确的，但是若是加载的是原网站内容，用这个获取，会不准确，改用后者之后就可以正常显示，这个情况是我尝试了很多次方法才正常显示的
        CGRect webFrame = webView.frame;
        webFrame.size.height = height;
        //        webView.frame = webFrame;
        self.fittingSize = CGSizeMake(kScreenWidth, height);
        webView.frame = CGRectMake(0, 30, kScreenWidth, self.fittingSize.height);
        [self.footView addSubview:webView];
        [self.collectionView reloadData];
    }];
}
#pragma mark === 这里是9月26号修改图文详情。
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if (object == self.webView.scrollView) {
        if ([keyPath isEqualToString:@"contentSize"]) {
            self.fittingSize = [self.webView sizeThatFits:CGSizeZero];
            self.webView.frame = CGRectMake(0, 30, kScreenWidth, self.fittingSize.height);
            self.webView.scrollView.scrollEnabled = NO;
            [self.footView addSubview:self.webView];
            [self.collectionView reloadData];
        }
    }
    
}
#pragma mark - 视图滚动
- (void)setUpViewScroller{
    WEAKSELF
#pragma mark === 这里是9月26号修改图文详情
    //    self.collectionView.mj_footer = [MJRefreshBackFooter footerWithRefreshingBlock:^{
    //
    //        self.ispaged = YES;
    //        [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionLayoutSubviews animations:^{
    //
    //            weakSelf.scrollerView.contentOffset = CGPointMake(0, kScreenHeight);
    //
    //            self.naviBarView.alpha = 1.0;
    //
    //        } completion:^(BOOL finished) {
    //            [weakSelf.collectionView.mj_footer endRefreshing];
    //
    //        }];
    //    }];
    
    
    
    //    self.imageScroll.mj_header = [MJRefreshHeader headerWithRefreshingBlock:^{
    //        self.ispaged = NO;
    //        [UIView animateWithDuration:0.8 animations:^{
    //
    //            weakSelf.scrollerView.contentOffset = CGPointMake(0, 0);
    //
    //        } completion:^(BOOL finished) {
    //            self.naviBarView.alpha = self.offset/(naviHeight+80)*1.0;
    //            if (self.offset/(naviHeight+80)*1.0 < 0.7) {
    //
    //            } else {
    //
    //            }
    //            [weakSelf.imageScroll.mj_header endRefreshing];
    //
    //        }];
    //
    //    }];
    self.webView.scrollView.mj_header = [MJRefreshHeader headerWithRefreshingBlock:^{
        self.ispaged = NO;
        [UIView animateWithDuration:0.5 animations:^{
            
            weakSelf.scrollerView.contentOffset = CGPointMake(0, 0);
            
        } completion:^(BOOL finished) {
            self.naviBarView.alpha = self.offset/(naviHeight+80)*1.0;
            if (self.offset/(naviHeight+80)*1.0 < 0.7) {
                //                [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
                //                [self.navigationController.navigationBar setTintColor:myWhite];
            } else {
                //                [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
                //                [self.navigationController.navigationBar setTintColor:RGB(20, 20, 20)];
            }
            [weakSelf.webView.scrollView.mj_header endRefreshing];
            
        }];
        
    }];
}
#pragma mark - 记载图文详情
- (void)setUpGoodsUIWebView
{
    //    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"https://www.baidu.com/"]];
    /**
     @"<html> \n"
     "<head> \n"
     "<meta name=\"viewport\" content=\"initial-scale=1.0, maximum-scale=1.0, user-scalable=no\" /> \n"
     "<style type=\"text/css\"> \n"
     "body {font-size:15px;}\n"
     "</style> \n"
     "</head> \n"
     "<body>"
     "<script type='text/javascript'>"
     "window.onload = function(){\n"
     "var $img = document.getElementsByTagName('img');\n"
     "for(var p in  $img){\n"
     " $img[p].style.width = '100%%';\n"
     "$img[p].style.height ='auto'\n"
     "}\n"
     "}"
     "</script>%@"
     "</body>"
     "</html>"
     */
    
    /**
     <h3 class="module-title" style="font-size:14px;background:#FFFFFF;font-weight:400;color:#666666;font-family:Helvetica, sans-serif;">
     <img class="lazyImg" src="https://img.alicdn.com/imgextra/i2/3963165285/TB2_b55pUOWBKNjSZKzXXXfWFXa_!!3963165285.jpg" style="width:1903px;" />
     </h3>
     <div class="module-content" style="margin:0px;padding:0px;color:#051B28;font-family:Helvetica, sans-serif;font-size:12px;background-color:#FFFFFF;">
     <div class="mui-custommodule mdv-custommodule" style="margin:0px;padding:0px;">
     <div class="mui-custommodule-item" style="margin:0px;padding:0px;">
     <img class="lazyImg" src="https://img.alicdn.com/imgextra/i4/3963165285/TB2c.XLp77mBKNjSZFyXXbydFXa_!!3963165285.jpg" style="width:1903px;" />
     </div>
     <div class="mui-custommodule-item" style="margin:0px;padding:0px;">
     <img class="lazyImg" src="https://img.alicdn.com/imgextra/i1/3963165285/TB2lS50pSYTBKNjSZKbXXXJ8pXa_!!3963165285.jpg" style="width:1903px;" />
     </div>
     <div class="mui-custommodule-item" style="margin:0px;padding:0px;">
     <br />
     </div>
     </div>
     </div>
     */
    //    self.model.goodsDetail = [NSString stringWithFormat:@"<h3 class=\"module-title\" style=\"font-size:14px;background:#FFFFFF;font-weight:400;color:#666666;font-family:Helvetica, sans-serif;\"> \n"
    //                              "<img class=\"lazyImg\" src=\"https://img.alicdn.com/imgextra/i2/3963165285/TB2_b55pUOWBKNjSZKzXXXfWFXa_!!3963165285.jpg\" style=\"width:1903px;\" /> \n"
    //                              "</h3> \n"
    //                              "<div class=\"module-content\" style=\"margin:0px;padding:0px;color:#051B28;font-family:Helvetica, sans-serif;font-size:12px;background-color:#FFFFFF;\"> \n"
    //                              "<div class=\"mui-custommodule mdv-custommodule\" style=\"margin:0px;padding:0px;\"> \n"
    //                              "<div class=\"mui-custommodule-item\" style=\"margin:0px;padding:0px;\"> \n"
    //                              "<img class=\"lazyImg\" src=\"https://img.alicdn.com/imgextra/i4/3963165285/TB2c.XLp77mBKNjSZFyXXbydFXa_!!3963165285.jpg\" style=\"width:1903px;\" /> \n"
    //                              "</div>"
    //                              "</div>"
    //                              "</div>"
    //                              ];
    NSString *htmls = [NSString stringWithFormat:@"<html> \n"
                       "<head> \n"
                       "<meta name=\"viewport\" content=\"initial-scale=1.0, maximum-scale=1.0, user-scalable=no\" /> \n"
                       "<style>img{max-width: 100%%; width:auto; height:auto!important;}</style> \n"
                       "</head> \n"
                       "<body> \n"
                       "%@ \n"
                       "</body>"
                       "</html>",self.model.goodsDetail];
    
    [self.webView loadHTMLString:htmls baseURL:nil];
}
#pragma mark - <UIScrollViewDelegate>
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView == self.collectionView) {
        //图片上下偏移量
        CGFloat imageOffsetY = scrollView.contentOffset.y;
        self.offset = imageOffsetY;
        if (self.ispaged == NO) {
            
            [self setNaviBarItemsAndAlphaWithOffset:imageOffsetY];
        }
        
    }
}
- (void)setNaviBarItemsAndAlphaWithOffset:(CGFloat)imageOffsetY {
    if (imageOffsetY < 0) {
        self.naviBarView.alpha = 0;
    } else {
        self.naviBarView.alpha = imageOffsetY/(naviHeight+80)*1.0;
        if (imageOffsetY/(naviHeight+80)*1.0 >= 0.7) {
            //            [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
            //            [self.navigationController.navigationBar setTintColor:RGB(20, 20, 20)];
            //                [self.cartBtn setImage:[UIImage imageNamed:@"home_icon_basket_black"] forState:UIControlStateNormal];
            //                [self.cartBtn setTitleColor:RGB(20, 20, 20) forState:UIControlStateNormal];
            //
            //                [self.msgBtn setImage:[UIImage imageNamed:@"home_icon_news_black"] forState:UIControlStateNormal];
            //                [self.msgBtn setTitleColor:RGB(20, 20, 20) forState:UIControlStateNormal];
            //
            //                self.titleImageV.image = [UIImage imageNamed:@"search_bg_gray"];
            //
            //                self.searchImageV.image = [UIImage imageNamed:@"nav_icon_search"];
            //
            //                self.titleLabel.textColor = RGB(153, 153, 153);
            
        } else {
            //            [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
            //            [self.navigationController.navigationBar setTintColor:myWhite];
            //                [self.cartBtn setImage:[UIImage imageNamed:@"home_icon_basket"] forState:UIControlStateNormal];
            //                [self.cartBtn setTitleColor:myWhite forState:UIControlStateNormal];
            //
            //                [self.msgBtn setImage:[UIImage imageNamed:@"home_icon_news"] forState:UIControlStateNormal];
            //                [self.msgBtn setTitleColor:myWhite forState:UIControlStateNormal];
            //
            //                self.titleImageV.image = [UIImage imageNamed:@"search_bg_white"];
            //
            //                self.searchImageV.image = [UIImage imageNamed:@"home_icon_search"];
            //
            //                self.titleLabel.textColor = myWhite;
        }
    }
}
- (void)ybPopupMenu:(YBPopupMenu *)ybPopupMenu didSelectedAtIndex:(NSInteger)index {
    self.popMenuIndex = index;
    
    [ybPopupMenu dismiss];
}
- (void)ybPopupMenuDidDismiss {
    switch (self.popMenuIndex) {
        case 10:
        {
            //消息
        }
            break;
        case 0:
        {
            //首页
            [self.headView.detailsV.player.playerLayer removeFromSuperlayer];
            self.headView.detailsV.player.playerLayer = nil;
            self.headView.detailsV.player.player = nil;
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
            break;
        case 1:
        {
            //我的
            [self.headView.detailsV.player.playerLayer removeFromSuperlayer];
            self.headView.detailsV.player.playerLayer = nil;
            self.headView.detailsV.player.player = nil;
            myTabBarController *tab = [myTabBarController new];
            tab.selectedIndex = 4;
            [UIApplication sharedApplication].keyWindow.rootViewController = tab;
        }
            break;
        case 2:
        {
            //分享
            if (![Utils isBlankString:self.myInfoM.userGrade] && [self.myInfoM.userGrade integerValue] <= 1) {
                //                baseWebViewController *webVC = [baseWebViewController new];
                //                NSString *url = [@"app/user/qrcode/" stringByAppendingString:[FXObjManager dc_readUserDataForKey:@"account"]];
                //                webVC.urlStr = [shareHost stringByAppendingString:url];
                //                UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:webVC];
                //                nav.navigationBar.tintColor = [UIColor colorWithRed:0.322 green:0.322 blue:0.322 alpha:1.00];
                //                webVC.naviTitle = @"邀请新人赚赏金";
                //                webVC.navigationController.navigationBar.translucent = NO;
                //                [self presentViewController:nav animated:YES completion:nil];
                NSString *shareUrlStr = [NSString stringWithFormat:@"%@app/user/toDetail/%@?mobilePhone=%@",shareHostTest,self.goodsID
                                         ,self.accountStr];
                NSString *goodsImage = [NSString stringWithFormat:@"%@%@",imageHost,self.goodsPreview];
                NSString *title = [NSString stringWithFormat:@"%@",self.model.goodsName];
                [self shareGoodsWithUrl:shareUrlStr title:title imageUrl:goodsImage];
            } else {
                [MBProgressHUD showToastText:@"省、市代无法分享" toView:self.navigationController.view];
            }
        }
            break;
        default:
            break;
    }
    
}
#pragma mark === 加入购物车
- (void)addTOShoppingCartWithModel:(shoppingCartModel *)model {
    
    [[ZLJNetWorkManager defaultManager]sendRequestMethod:HTTPMethodPOST isLogin:NO isJsonRequest:YES serverUrl:requestHost apiPath:addToShoppingCartUrl parameters:@{@"param":@{@"list":@[@{@"userId":self.myInfoM.ID,@"goodsId":self.goodsID,@"goodsStandardId":model.goodsStandardId,@"goodsCount":model.count}]}} progress:^(NSProgress * _Nullable progress) {
        
    } success:^(BOOL isSuccess, id  _Nullable responseObject) {
        NSDictionary *dataDic = [NSDictionary changeType:responseObject];
        if (dataDic) {
            NSString *code = dataDic[@"code"];
            NSString *msg = dataDic[@"message"];
            if ([code integerValue] == 200) {
                [MBProgressHUD showSuccess:@"加入购物车成功" toView:self.view];
            } else {
                [MBProgressHUD showError:msg toView:self.view];
            }
        } else {
            [MBProgressHUD showError:myRequestError toView:self.view];
        }
    } failure:^(NSString * _Nullable errorMessage) {
        [MBProgressHUD showError:errorMessage toView:self.view];
    }];
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if (self.ispaged) {
        self.scrollerView.contentOffset = CGPointMake(0, kScreenHeight);
    }
    //    self.headView.detailsV.player.videoMaskView.playBtn.hidden = YES;
    self.navigationController.swipeBackEnabled = YES;
}
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
}

- (void)shareGoodsWithUrl:(NSString *)url title:(NSString *)title imageUrl:(NSString *)goodsImage{
    NSURL *shareBgUrl = [NSURL URLWithString:goodsImage];
    UIImageView *imageV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    //placeholderImage:[UIImage imageNamed:@"banner"]
    [imageV sd_setImageWithURL:shareBgUrl placeholderImage:[UIImage imageNamed:@"banner"] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        //1、创建分享参数
        //[[NSBundle mainBundle] pathForResource:@"banner" ofType:@"png"]
        NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
        [shareParams SSDKSetupShareParamsByText:@"发现一件好货，分享给你，再不点就没了！"
                                         images:image
                                            url:[NSURL URLWithString:url]
                                          title:title
                                           type:SSDKContentTypeAuto];
        //        [ShareSDK showShareActionSheet:nil
        //                                 items:nil
        //                           shareParams:shareParams
        //                   onShareStateChanged:^(SSDKResponseState state, SSDKPlatformType platformType, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error, BOOL end) {
        //                       switch (state) {
        //                           case SSDKResponseStateSuccess:
        //                           {
        //                               UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享成功" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        //                               [alertView show];
        //                           }
        //                               break;
        //                           case SSDKResponseStateFail:
        //                           {
        //                               UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"分享失败"  message:[NSString stringWithFormat:@"%@",error] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        //                               [alert show];
        //                           }
        //                               break;
        //                           default:
        //                               break;
        //                       }
        //
        //                   }];
        [ShareSDK showShareActionSheet:nil
                           customItems:nil
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
