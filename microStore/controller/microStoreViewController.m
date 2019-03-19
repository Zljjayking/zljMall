//
//  microStoreViewController.m
//  Distribution
//
//  Created by hchl on 2018/11/19.
//  Copyright © 2018年 hchl. All rights reserved.
//

#import "microStoreViewController.h"
#import "goodsTableViewCell.h"
#import "goodsTableCell.h"
#import "microGoodsTableViewCell.h"
#import "microGoodsTableCell.h"
#import "categoryView.h"
#import "editBottomView.h"

#import "shoppingCartModel.h"
#import "categoryModel.h"

#import "googsInfoViewController.h"
#import "searchGoodsViewController.h"
@interface microStoreViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
// 数据数组
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, strong) NSIndexPath *editingIndexPath;
@property (nonatomic, strong) NSString *classTitle;
@property (nonatomic, strong) UIButton *classBtn;
@property (nonatomic, strong) NSMutableArray *goodsArr;
@property (nonatomic, strong) categoryView *categoryV;
@property (nonatomic, strong) editBottomView *bottomV;
@property (nonatomic, assign) NSInteger categorySelectIndex;
@property (nonatomic, strong) NSMutableArray *categoryArr;
@property (nonatomic, strong) NSString *categoryId;
@property (nonatomic, strong) NSMutableArray *editGoodsArr;//预备编辑商品id的数组
@property (nonatomic, assign) BOOL isEdit;//是否在编辑的状态
@property (nonatomic, assign) BOOL isAllSelect;//是否全选
@property (nonatomic, assign) BOOL isChangeClass;//是否切换了分类
@property (nonatomic, strong) NSString *shareUrlStr;
@property (nonatomic, strong) UIButton *editBtn;
@end

@implementation microStoreViewController
- (categoryView *)categoryV {
    if (!_categoryV) {
        _categoryV = [[categoryView alloc] initWithFrame:CGRectMake(0, naviHeight+35, kScreenWidth, kScreenHeight-naviHeight-35)];
    }
    return _categoryV;
}
- (editBottomView *)bottomV {
    if (!_bottomV) {
        _bottomV = [[editBottomView alloc] initWithFrame:CGRectMake(0, kScreenHeight-50-tabHeight, kScreenWidth, 50)];
    }
    return _bottomV;
}
- (UITableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, naviHeight+35, kScreenWidth, kScreenHeight-naviHeight-tabHeight-35) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        
        _tableView.tableFooterView = [UIView new];

        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
        [_tableView registerNib:[UINib nibWithNibName:@"goodsTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"goodsTableViewCell"];
        [_tableView registerNib:[UINib nibWithNibName:@"goodsTableCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"goodsTableCell"];
        //microGoodsTableViewCell
        [_tableView registerNib:[UINib nibWithNibName:@"microGoodsTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"microGoodsTableViewCell"];
        [_tableView registerNib:[UINib nibWithNibName:@"microGoodsTableCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"microGoodsTableCell"];
    }
    return _tableView;
}
- (NSMutableArray *)dataArray {
    if (_dataArray == nil) {
        _dataArray = [NSMutableArray arrayWithCapacity:0];
    }
    
    return _dataArray;
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self getNetwork];
    [self requestCategory];
    NSString *isLoadMicro = [FXObjManager dc_readUserDataForKey:BOOLIsLoadMicro];
    if ([isLoadMicro isEqualToString:@"0"]) {
        [self requestData];
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    self.isWhiteNavi = YES;
    self.page = 1;
    self.categorySelectIndex = 0;
    self.categoryArr = @[].mutableCopy;
    self.goodsArr = @[].mutableCopy;
    self.classTitle = @"全部类目";
    
    self.isEdit = NO;
    self.editGoodsArr = @[].mutableCopy;
    self.isChangeClass = NO;
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    UILabel *titleLb = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
    titleLb.text = @"我的精选";
    titleLb.textColor = myBlack;
    titleLb.font = [UIFont systemFontOfSize:18];
    titleLb.textAlignment = NSTextAlignmentCenter;
    self.navigationItem.titleView = titleLb;
    
    self.tableView.backgroundColor = FXBGColor;
    self.tableView.mj_header = [FXRefreshGifHeader headerWithRefreshingBlock:^{
        [FXSpeedy fx_callFeedback]; //触动
        self.page = 1;
        [self requestData];
    }];
    self.view.backgroundColor = FXBGColor;
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.naviBarView];
#pragma mark == 底部编辑view
    [self.view addSubview:self.bottomV];
    WEAKSELF
    self.bottomV.selectAllBlock = ^(BOOL isSelect) {
        [weakSelf.editGoodsArr removeAllObjects];
        for (shoppingCartModel* model in weakSelf.goodsArr) {
            model.isSelect = isSelect;
            if (isSelect) {
//                [weakSelf.editGoodsArr addObject:[NSNumber numberWithInteger:[model.ID integerValue]]];
                [weakSelf.editGoodsArr addObject:model.ID];
            }
        }
        weakSelf.isAllSelect = isSelect;
        [weakSelf.tableView reloadData];
        
    };
    self.bottomV.editBlock = ^(NSInteger btnIndex) {
        if (btnIndex == 1) {
            if (weakSelf.editGoodsArr.count) {
//                [weakSelf editBtnClick:weakSelf.editBtn];
                [weakSelf setHouseStatusWithGoodsIds:weakSelf.editGoodsArr];
                
            }
        }else {
            if (weakSelf.editGoodsArr.count) {
                NSString *ids;
                for (int i=0; i<weakSelf.editGoodsArr.count; i++) {
                    NSString *goodsId = weakSelf.editGoodsArr[i];
                    if (i == 0) {
                        ids = goodsId;
                    }else {
                        ids = [NSString stringWithFormat:@"%@,%@",ids,goodsId];
                    }
                }
                NSString *shareListUrl = [NSString stringWithFormat:shareListToWeiXinHost,weakSelf.accountStr,ids];
                [weakSelf shareListGoodsWithUrl:shareListUrl title:@"爆品好货！难得一见！速度！" imageUrl:@"123"];
            }
        }
    };
    self.bottomV.hidden = YES;
    
    self.line.backgroundColor = [UIColor clearColor];
    self.naviBarView.alpha = 1;
    
    [self setupTopView];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav_icon_search"] style:UIBarButtonItemStylePlain target:self action:@selector(searchClick)];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    self.blankV = [[blankView alloc]initWithFrame:CGRectMake(kScreenWidth/2.0-40, self.view.center.y/2.0+50, 80, 80) imageName:@"noData" title:@"暂无数据"];
    [self.tableView addSubview:self.blankV];
    self.blankV.hidden = YES;
}
- (void)requestCategory {
    [[ZLJNetWorkManager defaultManager] sendRequestMethod:HTTPMethodPOST isLogin:NO isJsonRequest:NO serverUrl:requestHost apiPath:microStoreCategoryListUrl parameters:@{@"userId":self.myInfoM.ID} progress:^(NSProgress * _Nullable progress) {
        
    } success:^(BOOL isSuccess, id  _Nullable responseObject) {
        NSDictionary *dic = [NSDictionary changeType:responseObject];
        NSString *code = dic[@"code"];
        NSString *msg = dic[@"message"];
        if ([code integerValue] == 200) {
            NSArray *data = dic[@"data"];
            self.categoryArr = [categoryModel mj_objectArrayWithKeyValuesArray:data];
            categoryModel *firstModel = [categoryModel new];
            firstModel.categoryName = @"全部类目";
            [self.categoryArr insertObject:firstModel atIndex:0];
        }else {
            [MBProgressHUD showError:msg toView:self.view];
        }
    } failure:^(NSString * _Nullable errorMessage) {
        [MBProgressHUD showError:errorMessage toView:self.view];
    }];
}
- (void)requestData {
    NSString *isFirstLoad = [FXObjManager dc_readUserDataForKey:BOOLIsFirstMicro];
    if ([isFirstLoad isEqualToString:@"0"]) {
        [MBProgressHUD showMessage:@"加载中" toView:self.view];
    }
    [FXObjManager dc_saveUserData:@"1" forKey:BOOLIsLoadMicro];
    NSString *page = [NSString stringWithFormat:@"%ld",(long)self.page];
    NSDictionary *paramater = @{@"page":page,@"size":@"10",@"paixu":@"1",@"userId":self.myInfoM.ID,@"flag":@"1"};
    if (![Utils isBlankString:self.categoryId]) {
        paramater = @{@"page":page,@"size":@"10",@"paixu":@"1",@"userId":self.myInfoM.ID,@"categoryId":self.categoryId,@"flag":@"1"};
    }
    
    
    [[ZLJNetWorkManager defaultManager] sendRequestMethod:HTTPMethodPOST isLogin:NO isJsonRequest:YES serverUrl:requestHost apiPath:goodsListUrl parameters:paramater progress:^(NSProgress * _Nullable progress) {
        
    } success:^(BOOL isSuccess, id  _Nullable responseObject) {
        NSDictionary *dataDic = [NSDictionary changeType:responseObject];
        [self.tableView.mj_header endRefreshingWithCompletionBlock:^{
            if (self.page == 1) {
                [self.tableView setContentOffset:CGPointMake(0,0) animated:NO];
            }
        }];
        [self.tableView.mj_footer endRefreshing];
        [FXObjManager dc_saveUserData:@"1" forKey:BOOLIsFirstMicro];
        if (dataDic) {
            NSString *code = dataDic[@"code"];
            NSString *message = dataDic[@"message"];
            if ([code isEqualToString:@"200"]) {
                NSDictionary *goodsDataDic = dataDic[@"data"];
                if ([goodsDataDic isKindOfClass:[NSDictionary class]]) {
                    NSArray *dataArr = goodsDataDic[@"goodsList"];
                    //2.3.8.9
                    NSArray *goodsArr = [shoppingCartModel mj_objectArrayWithKeyValuesArray:dataArr];
                    if (self.page == 1) {
                        [self.goodsArr removeAllObjects];
                        if (goodsArr.count == 0) {
                            self.tableView.mj_footer = nil;
                        } else {
                            self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
                                self.page ++;
                                [self requestData];
                            }];
                        }
                    }
                    for (shoppingCartModel *model in goodsArr) {
                        model.isSelect = NO;
                        if (self.isAllSelect) {
                            model.isSelect = YES;
//                            [self.editGoodsArr addObject:[NSNumber numberWithInteger:[model.ID integerValue]]];
                            [self.editGoodsArr addObject:model.ID];
                        }
                    }
                    
                    [self.goodsArr addObjectsFromArray:goodsArr];
                    if (goodsArr.count<10) {
                        [self.tableView.mj_footer endRefreshingWithNoMoreData];
                    }
                    if (self.goodsArr.count == 0) {
                        self.blankV.hidden = NO;
                    } else {
                        self.blankV.hidden = YES;
                    }
                } else {
                    if (self.page == 1) {
                        [self.goodsArr removeAllObjects];
                        self.tableView.mj_footer = nil;
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
                
                [MBProgressHUD showError:message toView:self.view];
                if (self.page > 1) {
                    self.page --;
                }else {
                    self.tableView.mj_footer.hidden = YES;
                }
            }
            
        } else {
            
            [MBProgressHUD showError:@"请求出错，请稍后再试" toView:self.view];
            
            if (self.page > 1) {
                self.page --;
            }else {
                self.tableView.mj_footer.hidden = YES;
            }
            
        }
        
        [self.tableView reloadData];
    } failure:^(NSString * _Nullable errorMessage) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        [MBProgressHUD showError:errorMessage toView:self.view];
        
        if (self.page > 1) {
            self.page --;
        } else {
            self.tableView.mj_footer.hidden = YES;
        }
        
    }];
    [MBProgressHUD hideHUDForView:self.view];
}
- (void)setupTopView {
    
    CGFloat width = [self.classTitle widthWithFont:[UIFont systemFontOfSize:13] constrainedToHeight:15]+5;
    UIButton *classBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    classBtn.frame = CGRectMake(15, naviHeight, width+30, 35);
    [self.view addSubview:classBtn];
    [classBtn setTitle:self.classTitle forState:UIControlStateNormal];
    [classBtn setTitle:self.classTitle forState:UIControlStateSelected];
    [classBtn setTitleColor:myBlack forState:UIControlStateNormal];
    [classBtn setTitleColor:myBlack forState:UIControlStateSelected];
    [classBtn setImage:[UIImage imageNamed:@"xiangxia"] forState:UIControlStateNormal];
    [classBtn setImage:[UIImage imageNamed:@"xiangshang"] forState:UIControlStateSelected];
    [classBtn addTarget:self action:@selector(classBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    classBtn.titleRect = CGRectMake(10, 5, width, 25);
    classBtn.imageRect = CGRectMake(width+10, 12.5, 10, 10);
    classBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    self.classBtn = classBtn;
    
    UIButton *editBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    editBtn.frame = CGRectMake(kScreenWidth - 40 - 13, naviHeight, 40, 35);
    [editBtn setTitle:@"选择" forState:UIControlStateNormal];
    [editBtn setTitle:@"完成" forState:UIControlStateSelected];
    [editBtn setTitleColor:myBlack forState:UIControlStateNormal];
    [editBtn setTitleColor:myBlack forState:UIControlStateSelected];
    editBtn.titleLabel.font = [UIFont boldSystemFontOfSize:15];
    editBtn.titleRect = CGRectMake(0, 0, 40, 35);
    editBtn.titleLabel.textAlignment = NSTextAlignmentRight;
    [self.view addSubview:editBtn];
    self.editBtn = editBtn;
    [editBtn addTarget:self action:@selector(editBtnClick:) forControlEvents:UIControlEventTouchUpInside];
}
- (void)editBtnClick:(UIButton *)sender {
    sender.selected = !sender.selected;
    self.isEdit = sender.selected;
    [self.tableView reloadData];
    self.bottomV.hidden = !sender.selected;
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.goodsArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    shoppingCartModel *model = self.goodsArr[indexPath.row];
    if (self.isEdit) {
        microGoodsTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"microGoodsTableCell" forIndexPath:indexPath];
        cell.goodsModel = model;
//        microGoodsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"microGoodsTableViewCell" forIndexPath:indexPath];
//
//        cell.goodsModel = model;
        
        cell.shareBlock = ^{
            if (![Utils isBlankString:self.myInfoM.userGrade] && [self.myInfoM.userGrade integerValue] <= 1) {
                NSString *shareUrlStr = [NSString stringWithFormat:@"%@app/user/toDetail/%@?mobilePhone=%@",shareHostTest,model.ID
                                         ,self.accountStr];
                
                NSString *title = [NSString stringWithFormat:@"%@",model.goodsName];
                NSString *goodsImage = [NSString stringWithFormat:@"%@%@",imageHost,model.goodsPreview];
                [self shareGoodsWithUrl:shareUrlStr title:title imageUrl:goodsImage];
            } else {
                [MBProgressHUD showToastText:@"省、市代无法分享" toView:self.navigationController.view];
            }
        };
        cell.selectBlcok = ^(shoppingCartModel * _Nonnull model) {
            if (model.isSelect == YES) {
//                [self.editGoodsArr addObject:[NSNumber numberWithInteger:[model.ID integerValue]]];
                [self.editGoodsArr addObject:model.ID];
            }else {
//                [self.editGoodsArr removeObject:[NSNumber numberWithInteger:[model.ID integerValue]]];
                [self.editGoodsArr removeObject:model.ID];
            }
            if (self.editGoodsArr.count == self.goodsArr.count) {
                self.bottomV.selectAllBtn.selected = YES;
                self.isAllSelect = YES;
            }else {
                self.bottomV.selectAllBtn.selected = NO;
                self.isAllSelect = NO;
            }
        };
        return cell;
    }else {
        goodsTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"goodsTableCell" forIndexPath:indexPath];
        cell.goodsModel = model;
//        goodsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"goodsTableViewCell" forIndexPath:indexPath];
//
//        cell.goodsModel = model;
        
        cell.shareBlock = ^{
            if (![Utils isBlankString:self.myInfoM.userGrade] && [self.myInfoM.userGrade integerValue] <= 1) {
                NSString *shareUrlStr = [NSString stringWithFormat:@"%@app/user/toDetail/%@?mobilePhone=%@",shareHostTest,model.ID
                                         ,self.accountStr];
                
                NSString *title = [NSString stringWithFormat:@"%@",model.goodsName];
                NSString *goodsImage = [NSString stringWithFormat:@"%@%@",imageHost,model.goodsPreview];
                [self shareGoodsWithUrl:shareUrlStr title:title imageUrl:goodsImage];
            } else {
                [MBProgressHUD showToastText:@"省、市代无法分享" toView:self.navigationController.view];
            }
        };
        return cell;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return ((kScreenWidth-26)/349.0)*187.0+18.5+62;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    shoppingCartModel *model = self.goodsArr[indexPath.item];
    model.num = @"0";
    googsInfoViewController *goodsInfo = [googsInfoViewController new];
    goodsInfo.hidesBottomBarWhenPushed = YES;
    goodsInfo.model = model;
    goodsInfo.goodsID = model.ID;
    goodsInfo.goodsPreview = model.goodsPreview;
    goodsInfo.isGroup = [model.isGroup boolValue];
    [self.navigationController pushViewController:goodsInfo animated:YES];
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return !self.isEdit;
}
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    //    return @"删除";
    
    return @" ";
}
- (void)tableView:(UITableView *)tableView willBeginEditingRowAtIndexPath:(NSIndexPath *)indexPath{
    self.editingIndexPath = indexPath;
    [self.view setNeedsLayout];   // 触发-(void)viewDidLayoutSubviews
}

- (void)tableView:(UITableView *)tableView didEndEditingRowAtIndexPath:(NSIndexPath *)indexPath{
    
//    [self.goodsArr removeObjectAtIndex:indexPath.row];
    self.editingIndexPath = nil;
}

- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    
    if (self.editingIndexPath){
        [self configSwipeButtons];
    }
}
#pragma mark - configSwipeButtons
- (void)configSwipeButtons{
    // 获取选项按钮的reference
    if (@available(iOS 11.0, *)){
        
        // iOS 11层级 (Xcode 9编译): UITableView -> UISwipeActionPullView
        for (UIView *subview in self.tableView.subviews)
        {
            NSLog(@"%@-----%zd",subview,subview.subviews.count);
            if ([subview isKindOfClass:NSClassFromString(@"UISwipeActionPullView")] && [subview.subviews count] >= 1)
            {
                // 和iOS 10的按钮顺序相反
                
                subview.backgroundColor = FXBGColor;
                UIButton *deleteButton = subview.subviews[0];
                [self configDeleteButton:deleteButton];
            }
        }
    }else{
        // iOS 8-10层级: UITableView -> UITableViewCell -> UITableViewCellDeleteConfirmationView
        goodsTableViewCell *tableCell = [self.tableView cellForRowAtIndexPath:self.editingIndexPath];
        for (UIView *subview in tableCell.subviews)
        {
            if ([subview isKindOfClass:NSClassFromString(@"UITableViewCellDeleteConfirmationView")])
            {
                UIView *confirmView = (UIView *)[subview.subviews firstObject];
                
                //改背景颜色
                
                confirmView.backgroundColor = FXBGColor;
                
                for (UIView *sub in confirmView.subviews)
                {
                    //添加图片
                    if ([sub isKindOfClass:NSClassFromString(@"UIView")]) {
                        
                        UIView *deleteView = sub;
                        UIImageView *imageView = [[UIImageView alloc] init];
                        imageView.image = [UIImage imageNamed:@"icon_delete_red"];
                        [deleteView addSubview:imageView];
                        
                        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
                            make.centerX.equalTo(deleteView);
                            make.centerY.equalTo(deleteView);
                        }];
                    }
                }
                break;
            }
        }
    }
}
- (void)configDeleteButton:(UIButton*)deleteButton{
    if (deleteButton) {
        [deleteButton setImage:[UIImage imageNamed:@"icon_delete_red"] forState:UIControlStateNormal];
        [deleteButton addTarget:self action:@selector(deleteAction:) forControlEvents:UIControlEventAllTouchEvents];
        [deleteButton setBackgroundColor:FXBGColor];
        
    }
}
// 点击左滑出现的按钮时触发
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    //执行删除逻辑
    shoppingCartModel *model = self.goodsArr[indexPath.row];
    [self.goodsArr removeObjectAtIndex:indexPath.row];
    if (!self.goodsArr.count) {
        self.blankV.hidden = NO;
        tableView.mj_footer = nil;
    }
    [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    
    [self setHouseStatusWithGoodsID:model.ID];
}

//按钮的点击操作
- (void)deleteAction:(UIButton *)sender{
    [self.view setNeedsLayout];
    [sender setBackgroundColor:FXBGColor];
}

- (void)searchClick {
    searchGoodsViewController *search = [searchGoodsViewController new];
    search.hidesBottomBarWhenPushed = YES;
    search.type = 4;
    [self.navigationController pushViewController:search animated:NO];
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
            image = [UIImage imageNamed:@"banner"];
        }
        NSData *imageData = [self compressOriginalImage:image toMaxDataSizeKBytes:30];
        UIImage *shareImage = [UIImage imageWithData:imageData];
        if (imageData.length>32*1024) {
            imageData = [self compressOriginalImage:shareImage toMaxDataSizeKBytes:30];
            shareImage = [UIImage imageWithData:imageData];
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
- (void)classBtnClick:(UIButton *)sender {
    if (!sender.selected) {
        self.categoryV.selectIndex = self.categorySelectIndex;
        self.categoryV.categoryArr = self.categoryArr;
        WEAKSELF
        self.categoryV.selectBlock = ^(NSInteger index) {
            [weakSelf.categoryV removeFromSuperview];
            if (weakSelf.categorySelectIndex != index) {
                weakSelf.categorySelectIndex = index;
                
                [weakSelf.editGoodsArr removeAllObjects];
                weakSelf.isAllSelect = NO;
                weakSelf.bottomV.selectAllBtn.selected = NO;
                
                categoryModel *model = weakSelf.categoryArr[index];
                weakSelf.classTitle = model.categoryName;
                CGFloat width = [weakSelf.classTitle widthWithFont:[UIFont systemFontOfSize:13] constrainedToHeight:15]+5;
                sender.frame = CGRectMake(15, naviHeight, width+30, 35);
                [sender setTitle:weakSelf.classTitle forState:UIControlStateNormal];
                [sender setTitle:weakSelf.classTitle forState:UIControlStateSelected];
                sender.titleRect = CGRectMake(10, 5, width, 25);
                sender.imageRect = CGRectMake(width+10, 12.5, 10, 10);
                weakSelf.categoryId = @"";
                if (![Utils isBlankString:model.ID]) {
                    weakSelf.categoryId = model.ID;
                }
                [FXObjManager dc_saveUserData:@"0" forKey:BOOLIsFirstMicro];
                [weakSelf.tableView.mj_header beginRefreshing];
            }
            sender.selected = !sender.selected;
        };
        [self.view addSubview:self.categoryV];
    }else {
        [self.categoryV removeFromSuperview];
    }
    sender.selected = !sender.selected;
}

- (void)setHouseStatusWithGoodsID:(NSString *)goodsID {
    [[ZLJNetWorkManager defaultManager] sendRequestMethod:HTTPMethodPOST isLogin:NO isJsonRequest:NO serverUrl:requestHost apiPath:collectionGoodsUrl parameters:@{@"goodsId":goodsID,@"houseStatus":@"0",@"userId":self.myInfoM.ID} progress:^(NSProgress * _Nullable progress) {
        
    } success:^(BOOL isSuccess, id  _Nullable responseObject) {
        NSDictionary *dic = [NSDictionary changeType:responseObject];
        NSString *code = dic[@"code"];
        NSString *msg = dic[@"message"];
        if ([code isEqualToString:@"200"]) {
            [MBProgressHUD showSuccess:@"取消成功" toView:self.view];
        }else {
            [MBProgressHUD showSuccess:msg toView:self.view];
        }
        [self requestCategory];
    } failure:^(NSString * _Nullable errorMessage) {
        [MBProgressHUD showError:errorMessage toView:self.view];
    }];
}
- (void)setHouseStatusWithGoodsIds:(NSArray *)goodsIds {
    NSString *goodsId = [goodsIds componentsJoinedByString:@","];
    NSDictionary *paramater = @{@"goodsId":goodsId,@"houseStatus":@"0",@"userId":self.myInfoM.ID};
    
    [[ZLJNetWorkManager defaultManager] sendRequestMethod:HTTPMethodPOST isLogin:NO isJsonRequest:NO serverUrl:requestHost apiPath:collectionGoodsUrl parameters:paramater progress:^(NSProgress * _Nullable progress) {

    } success:^(BOOL isSuccess, id  _Nullable responseObject) {
        NSDictionary *dic = [NSDictionary changeType:responseObject];
        NSString *code = dic[@"code"];
        NSString *msg = dic[@"message"];
        if ([code isEqualToString:@"200"]) {
            [MBProgressHUD showSuccess:@"取消成功" toView:self.view];
            [self.editGoodsArr removeAllObjects];
            self.bottomV.selectAllBtn.selected = NO;
            self.isAllSelect = NO;
        }else {
            [MBProgressHUD showSuccess:msg toView:self.view];
        }
        [self requestCategory];
        [self.tableView.mj_header beginRefreshing];
    } failure:^(NSString * _Nullable errorMessage) {
        [MBProgressHUD showError:errorMessage toView:self.view];
    }];
}
- (void)shareListGoodsWithUrl:(NSString *)url title:(NSString *)title imageUrl:(NSString *)goodsImage{
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
        [shareParams SSDKSetupShareParamsByText:@"这些精选商品错过就损失大了！"
                                         images:[UIImage imageNamed:@"logo_180"]
                                            url:[NSURL URLWithString:url]
                                          title:@"爆品好货！难得一见！速度！"
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
    
    
    
    //1、创建分享参数
    //[[NSBundle mainBundle] pathForResource:@"banner" ofType:@"png"]
//    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
//
//    NSArray * platforms =@[@(SSDKPlatformSubTypeWechatSession),@(SSDKPlatformSubTypeWechatTimeline)];
//
//
//    SSUIShareSheetConfiguration *config = [[SSUIShareSheetConfiguration alloc] init];
//
//    //设置分享菜单为简洁样式
//    config.style = SSUIActionSheetStyleSystem;
//
//    //设置竖屏有多少个item平台图标显示
//    config.columnPortraitCount = 2;
//
//    //设置横屏有多少个item平台图标显示
//    config.columnLandscapeCount = 2;
//
//    //设置取消按钮标签文本颜色
//    //        config.cancelButtonTitleColor = [UIColor redColor];
//
//    //设置对齐方式（简约版菜单无居中对齐）
//    config.itemAlignment = SSUIItemAlignmentCenter;
//
//    //设置标题文本颜色
//    //        config.itemTitleColor = [UIColor greenColor];
//
//    //设置分享菜单栏状态栏风格
//    config.statusBarStyle = UIStatusBarStyleDefault;
//
//    //设置支持的页面方向（单独控制分享菜单栏）
//    config.interfaceOrientationMask = UIInterfaceOrientationMaskPortrait|UIInterfaceOrientationMaskLandscape;
//
//    //设置分享菜单栏的背景颜色
//    config.menuBackgroundColor = [UIColor whiteColor];
//
//    //取消按钮是否隐藏，默认不隐藏
//    config.cancelButtonHidden = NO;
//
//    //设置直接分享的平台（不弹编辑界面）
//    config.directSharePlatforms = @[@(SSDKPlatformSubTypeWechatSession),@(SSDKPlatformSubTypeWechatTimeline)];
//
//    [shareParams SSDKSetupShareParamsByText:@"这些精选商品错过就损失大了！"
//                                     images:[UIImage imageNamed:@"logo_180"]
//                                        url:[NSURL URLWithString:url]
//                                      title:@"爆品好货！难得一见！速度！"
//                                       type:SSDKContentTypeAuto];

//    [ShareSDK showShareActionSheet:nil
//                       customItems:platforms
//                       shareParams:shareParams
//                sheetConfiguration:config
//                    onStateChanged:^(SSDKResponseState state, SSDKPlatformType platformType, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error, BOOL end) {
//                        switch (state) {
//                            case SSDKResponseStateSuccess:
//                            {
//                                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享成功"
//                                                                                    message:nil
//                                                                                   delegate:nil
//                                                                          cancelButtonTitle:@"确定"
//                                                                          otherButtonTitles:nil];
//                                [alertView show];
//                                break;
//                            }
//                            case SSDKResponseStateFail:
//                            {
//                                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"分享失败"
//                                                                                message:[NSString stringWithFormat:@"%@",error]
//                                                                               delegate:nil
//                                                                      cancelButtonTitle:@"OK"
//                                                                      otherButtonTitles:nil, nil];
//                                [alert show];
//                                break;
//                            }
//                            default:
//                                break;
//                        }
//                    }];
    
    
    
//    NSURL *shareBgUrl = [NSURL URLWithString:goodsImage];
//    UIImageView *imageV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
//    [imageV sd_setImageWithURL:shareBgUrl placeholderImage:[UIImage imageNamed:@"banner"] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
//
//    }];
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
@end
