//
//  spellViewController.m
//  Distribution
//
//  Created by hchl on 2018/12/25.
//  Copyright © 2018年 hchl. All rights reserved.
//

#import "spellViewController.h"
#import "bannerModel.h"
#import "slideshowView.h"

#import "spellSubViewController.h"
#import "googsInfoViewController.h"
#import "Distribution-Swift.h"

#import "spellFirstListModel.h"

#import "googsInfoViewController.h"
//#define RGBA(r,g,b,a) [UIColor colorWithRed:(float)r/255.0f green:(float)g/255.0f blue:(float)b/255.0f alpha:a]
#define kIPhoneX ([UIScreen mainScreen].bounds.size.height == 812.0)
@interface spellViewController ()<LTSimpleScrollViewDelegate>
@property(copy, nonatomic) NSArray <UIViewController *> *viewControllers;
@property(copy, nonatomic) NSArray <NSString *> *titles;
@property(strong, nonatomic) LTLayout *layout;
@property(strong, nonatomic) LTSimpleManager *managerView;

@property (nonatomic, strong) NSMutableArray *bannerArr;
@property (nonatomic, strong) NSMutableArray *imageArr;

@property (nonatomic, strong) NSMutableArray *firstListArr;
@end

@implementation spellViewController
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NSString *isLoadMicro = [FXObjManager dc_readUserDataForKey:BOOLIsLoadSpell];
    if ([isLoadMicro isEqualToString:@"0"]) {
        [self requestBanner];
    }
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.bannerArr = @[].mutableCopy;
    self.imageArr = @[].mutableCopy;
    UILabel *titleLb = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
    titleLb.text = @"拼团";
    titleLb.textColor = myBlack;
    titleLb.font = [UIFont systemFontOfSize:18];
    titleLb.textAlignment = NSTextAlignmentCenter;
    self.navigationItem.titleView = titleLb;
//    self.title = @"团购";
    
    
}
-(void)setupSubViews {

    [self.view addSubview:self.managerView];
    
    [self.view addSubview:self.naviBarView];
    
    __weak typeof(self) weakSelf = self;
    //配置headerView
    [self.managerView configHeaderView:^UIView * _Nullable{
        return [weakSelf setupHeaderView];
    }];
    
    //pageView点击事件
    [self.managerView didSelectIndexHandle:^(NSInteger index) {
        NSLog(@"点击了 -> %ld", index);
    }];

    //控制器刷新事件
    [self.managerView refreshTableViewHandle:^(UIScrollView * _Nonnull scrollView, NSInteger index) {
        __weak typeof(scrollView) weakScrollView = scrollView;
//        scrollView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
//            __strong typeof(weakScrollView) strongScrollView = weakScrollView;
//            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                NSLog(@"对应控制器的刷新自己玩吧，这里就不做处理了🙂-----%ld", index);
//                [strongScrollView.mj_header endRefreshing];
//            });
//        }];
        scrollView.mj_header = [FXRefreshGifHeader headerWithRefreshingBlock:^{
            
            __strong typeof(weakScrollView) strongScrollView = weakScrollView;
            
            spellSubViewController *testVC = (spellSubViewController *)self.viewControllers[index];
            [testVC refrshDataComplete:^{
                [strongScrollView.mj_header endRefreshing];
            }];
            
        }];
    }];

}
- (UIView *)setupHeaderView {
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, (kScreenWidth/349.0)*187.0+20)];
    headerView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    slideshowView *headV = [[slideshowView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, (kScreenWidth/349.0)*187.0)];
    headV.imageGroupArray = self.imageArr;
    headV.bannerBlock = ^(NSInteger index) {
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
    [headerView addSubview:headV];
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, (kScreenWidth/349.0)*187.0+10, kScreenWidth, 20)];
    view.backgroundColor = myWhite;
    view.layer.cornerRadius = 15;
    [headerView addSubview:view];
    headerView.clipsToBounds = YES;
    return headerView;
}
- (void)requestBanner {
    [MBProgressHUD showMessage:@"加载中..." toView:self.view];
    [[ZLJNetWorkManager defaultManager] sendRequestMethod:HTTPMethodPOST isLogin:NO isJsonRequest:NO serverUrl:requestHost apiPath:spellImagesUrl parameters:nil progress:^(NSProgress * _Nullable progress) {
        
    } success:^(BOOL isSuccess, id  _Nullable responseObject) {
        NSDictionary *dataDic = [NSDictionary changeType:responseObject];
        [FXObjManager dc_saveUserData:@"1" forKey:BOOLIsLoadSpell];
        if (dataDic) {
            NSString *code = dataDic[@"code"];
            NSString *msg = dataDic[@"message"];
            if ([code integerValue] == 200) {
                [self.imageArr removeAllObjects];
                NSArray *dataArr = dataDic[@"data"];
                if ([dataArr isKindOfClass:[NSArray class]]) {
                    self.bannerArr = [bannerModel mj_objectArrayWithKeyValuesArray:dataArr];
                    if (self.bannerArr.count == 0) {
                        [self.bannerArr addObject:@"banner"];
                    }
                    for (bannerModel *model in self.bannerArr) {
                        NSString *imageUrl = [NSString stringWithFormat:@"%@%@",imageHost,model.url];
                        [self.imageArr addObject:imageUrl];
                    }
                }
                
                [self requestCateList];
//                [self.collectionView reloadData];
                
//                [self requestData];
            } else {
                [MBProgressHUD showError:msg toView:self.view];
            }
        } else {
            
            [MBProgressHUD showError:@"请求出错，请稍后再试" toView:self.view];
            
        }
    } failure:^(NSString * _Nullable errorMessage) {
        [MBProgressHUD showError:errorMessage toView:self.view];
    }];
}
- (void)requestCateList {
    [[ZLJNetWorkManager defaultManager]sendRequestMethod:HTTPMethodPOST isLogin:NO isJsonRequest:NO serverUrl:requestHost apiPath:spellFirstListUrl parameters:nil progress:^(NSProgress * _Nullable progress) {
        
    } success:^(BOOL isSuccess, id  _Nullable responseObject) {
        NSDictionary *data = [NSDictionary changeType:responseObject];
        NSString *code = data[@"code"];
        NSString *message = data[@"message"];
        if ([code integerValue] == 200) {
            NSArray *dataArr = data[@"data"];
            if ([dataArr isKindOfClass:[NSArray class]]) {
                self.firstListArr = [spellFirstListModel mj_objectArrayWithKeyValuesArray:dataArr];
                NSMutableArray *titleArr = @[].mutableCopy;
//                spellFirstListModel *firstModel = [spellFirstListModel new];
//                firstModel.ID = @"0";
//                firstModel.categoryName = @"全部";
                [titleArr addObject:@"全部"];
                for (spellFirstListModel *model in self.firstListArr) {
                    [titleArr addObject:model.categoryName];
                }
                self.titles = titleArr;
                [MBProgressHUD hideHUD];
                [self setupSubViews];
            }
        }else {
            [MBProgressHUD showError:message toView:self.view];
        }
    } failure:^(NSString * _Nullable errorMessage) {
        
    }];
}
-(LTSimpleManager *)managerView {
    if (!_managerView) {
        CGFloat Y = naviHeight;
        CGFloat H = isIphoneX ? (self.view.bounds.size.height - Y - 34) : self.view.bounds.size.height - Y;
        
        _managerView = [[LTSimpleManager alloc] initWithFrame:CGRectMake(0, Y, kScreenWidth, H) viewControllers:self.viewControllers titles:self.titles currentViewController:self layout:self.layout titleView:nil];
        /* 设置代理 监听滚动 */
        _managerView.delegate = self;
        
        /* 设置悬停位置 */
        //        _managerView.hoverY = 64;
        
        /* 点击切换滚动过程动画 */
        //        _managerView.isClickScrollAnimation = YES;
        
        /* 代码设置滚动到第几个位置 */
        //        [_managerView scrollToIndexWithIndex:self.viewControllers.count - 1];
        
    }
    return _managerView;
}


-(LTLayout *)layout {
    if (!_layout) {
        _layout = [[LTLayout alloc] init];
        _layout.bottomLineHeight = 1.0;
        _layout.bottomLineCornerRadius = 0.0;
        _layout.isNeedScale = NO;
        _layout.titleColor = RGB(51, 51, 51);
        _layout.titleSelectColor = myRed;
        _layout.bottomLineColor = myRed;
        _layout.titleViewBgColor = myWhite;
        _layout.lrMargin = 25;
//        _layout.isAverage = YES;
        /* 更多属性设置请参考 LTLayout 中 public 属性说明 */
    }
    return _layout;
}


//- (NSArray <NSString *> *)titles {
//    if (!_titles) {
//        _titles = @[@"热门", @"精彩推荐", @"科技控", @"游戏"];
//    }
//    return _titles;
//}


-(NSArray <UIViewController *> *)viewControllers {
    if (!_viewControllers) {
        _viewControllers = [self setupViewControllers];
    }
    return _viewControllers;
}


-(NSArray <UIViewController *> *)setupViewControllers {
    NSMutableArray <UIViewController *> *testVCS = [NSMutableArray arrayWithCapacity:0];
    [self.titles enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        spellSubViewController *testVC = [[spellSubViewController alloc] init];
        testVC.selectBlock = ^(shoppingCartModel * _Nonnull model) {
            googsInfoViewController *goodsInfo = [googsInfoViewController new];
            model.num = @"0";
            goodsInfo.model = model;
            goodsInfo.goodsID = model.goodsId;
            goodsInfo.goodsPreview = model.goodsPreview;
            goodsInfo.isGroup = YES;
            [self.navigationController pushViewController:goodsInfo animated:YES];
        };
        if (idx == 0) {
            testVC.goodsCategoryId = @"0";
        }else{
            spellFirstListModel *model = self.firstListArr[idx-1];
            testVC.goodsCategoryId = model.ID;
        }
        
        [testVCS addObject:testVC];
    }];
    return testVCS.copy;
}

-(void)dealloc {
    NSLog(@"%s",__func__);
}

@end
