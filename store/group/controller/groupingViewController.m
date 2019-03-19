//
//  groupingViewController.m
//  Distribution
//
//  Created by hchl on 2018/12/27.
//  Copyright © 2018年 hchl. All rights reserved.
//

#import "groupingViewController.h"
#import "groupingHeaderView.h"
#import "groupingModel.h"
#import "goodsCollectionCell.h"
#import "hotGoodsCollectionCell.h"
#import "goodsInfoTwoCollectionCell.h"
#import "googsInfoViewController.h"

@interface groupingViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property (nonatomic, strong) UICollectionView *groupingCollection;
@property (nonatomic, strong) NSMutableArray *hotGroupArray;
@property (nonatomic, strong) NSMutableArray *grouperArray;
@property (nonatomic, strong) NSString *shareUrlStr;
@end

@implementation groupingViewController
- (UICollectionView *)groupingCollection {
    if (!_groupingCollection) {
        UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
        layout.minimumLineSpacing = 0;//y
        layout.minimumInteritemSpacing = 0;//x
        _groupingCollection = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _groupingCollection.delegate = self;
        _groupingCollection.dataSource = self;
        _groupingCollection.backgroundColor = myWhite;
        _groupingCollection.showsVerticalScrollIndicator = NO;
        _groupingCollection.showsHorizontalScrollIndicator = NO;
        [_groupingCollection registerNib:[UINib nibWithNibName:@"goodsCollectionCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"goodsCollectionCell"];
        [_groupingCollection registerNib:[UINib nibWithNibName:@"hotGoodsCollectionCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"hotGoodsCollectionCell"];
        [_groupingCollection registerNib:[UINib nibWithNibName:@"goodsInfoTwoCollectionCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"goodsInfoTwoCollectionCell"];
        [_groupingCollection registerNib:[UINib nibWithNibName:@"groupingHeaderView" bundle:[NSBundle mainBundle]] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"groupingHeaderView"];
        [_groupingCollection registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"footer"];
    }
    return _groupingCollection;
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (self.type == 1) {
        self.navigationController.swipeBackEnabled = NO;
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.groupingCollection.frame = CGRectMake(0, naviHeight, kScreenWidth, kScreenHeight-naviHeight);
    self.navigationController.swipeBackEnabled = NO;
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setImage:[UIImage imageNamed:@"nav_icon_back"] forState:UIControlStateNormal];
    [backBtn setTitle:@"   " forState:UIControlStateNormal];
    backBtn.frame = CGRectMake(0, 0, 34, 20);
    backBtn.imageRect = CGRectMake(0, 0, 12, 20);
    backBtn.titleRect = CGRectMake(14, 0, 20, 20);
    [backBtn addTarget:self action:@selector(clickBackItemToPop) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    
    self.navigationItem.leftBarButtonItem = backItem;
    [self.view addSubview:self.groupingCollection];
    self.title = @"拼团详情";
    [self.view addSubview:self.naviBarView];
    [self requestData];
    [self requestHotGroup];
}
- (void)clickBackItemToPop {
    if (self.type == 1) {
        for (UIViewController *controller in self.navigationController.viewControllers) {
            if ([controller isKindOfClass:[googsInfoViewController class]]) {
                googsInfoViewController *googsInfoVC =(googsInfoViewController *)controller;
                [self.navigationController popToViewController:googsInfoVC animated:YES];
            }
        }
    }else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}
- (void)requestData {
    [[ZLJNetWorkManager defaultManager]sendRequestMethod:HTTPMethodPOST isLogin:NO isJsonRequest:NO serverUrl:requestHost apiPath:paymentSuccessfulPageUrl parameters:@{@"groupId":self.groupId} progress:^(NSProgress * _Nullable progress) {
        
    } success:^(BOOL isSuccess, id  _Nullable responseObject) {
        NSDictionary *dataDic = [NSDictionary changeType:responseObject];
        NSString *code = dataDic[@"code"];
        NSString *message = dataDic[@"message"];
        if ([code isEqualToString:@"200"]) {
            NSArray *dataArr = dataDic[@"data"];
            if ([dataArr isKindOfClass:[NSArray class]]) {
                self.grouperArray = [groupingModel mj_objectArrayWithKeyValuesArray:dataArr];
                __block NSUInteger headIndex = 0;
                [self.grouperArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    groupingModel *groupModel = obj;
                    if ([groupModel.isHead isEqualToString:@"1"]) {
                        headIndex = idx;
                    }
                }];
                [self.grouperArray exchangeObjectAtIndex:headIndex withObjectAtIndex:0];
                
                [self.groupingCollection reloadData];
            }
        }else {
            [MBProgressHUD showError:message toView:self.view];
        }
    } failure:^(NSString * _Nullable errorMessage) {
        [MBProgressHUD showError:errorMessage toView:self.view];
    }];
}
//获取热门拼团
- (void)requestHotGroup {
    
    NSDictionary *parameter = @{@"userId":self.myInfoM.ID,@"hotGoods":@"1",@"page":@"1",@"size":@"6"};
    [[ZLJNetWorkManager defaultManager] sendRequestMethod:HTTPMethodPOST isLogin:NO isJsonRequest:YES serverUrl:requestHost apiPath:spellGoodsListUrl parameters:parameter progress:^(NSProgress * _Nullable progress) {
        
    } success:^(BOOL isSuccess, id  _Nullable responseObject) {
        NSDictionary *data = [NSDictionary changeType:responseObject];
        NSString *code = data[@"code"];
//        NSString *message = data[@"message"];
        if ([code integerValue] == 200) {
            NSArray *dataArr = data[@"data"];
            if ([dataArr isKindOfClass:[NSArray class]]) {
                self.hotGroupArray = [shoppingCartModel mj_objectArrayWithKeyValuesArray:dataArr];
                for (shoppingCartModel *model in self.hotGroupArray) {
                    model.isGroup = @"1";
                }
                [self.groupingCollection reloadData];
            }else {
//                [MBProgressHUD showError:@"暂无数据" toView:self.view];
            }
        }else {
            
//            [MBProgressHUD showError:message toView:self.view];
        }
    } failure:^(NSString * _Nullable errorMessage) {
        
//        [MBProgressHUD showError:errorMessage toView:self.view];
    }];
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.hotGroupArray.count+1;
}
- (UICollectionViewCell *) collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSString *account = [FXObjManager dc_readUserDataForKey:@"account"];
    if (indexPath.item == 0) {
        goodsInfoTwoCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"goodsInfoTwoCollectionCell" forIndexPath:indexPath];
        return cell;
    }else if (indexPath.item == 1){
        hotGoodsCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"hotGoodsCollectionCell" forIndexPath:indexPath];
        cell.signImageV.image = [UIImage imageNamed:@"hot_group_bg"];
        shoppingCartModel *model = self.hotGroupArray[indexPath.item-1];
        cell.goodsModel = model;
        NSString *goodsImage = [NSString stringWithFormat:@"%@%@",imageHost,model.goodsPreview];
        cell.shareBlock = ^{
            if (![Utils isBlankString:self.myInfoM.userGrade] && [self.myInfoM.userGrade integerValue] <= 1) {
                NSString *shareUrlStr = [NSString stringWithFormat:@"%@app/user/toDetail/%@?mobilePhone=%@",shareHostTest,model.goodsId
                                         ,account];
                
                NSString *title = [NSString stringWithFormat:@"%@",model.goodsName];
                [self shareGoodsWithUrl:shareUrlStr title:title imageUrl:goodsImage];
                
            } else {
                [MBProgressHUD showToastText:@"省、市代无法分享" toView:self.navigationController.view];
            }
        };
        return cell;
    }else {
        goodsCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"goodsCollectionCell" forIndexPath:indexPath];
        shoppingCartModel *model = self.hotGroupArray[indexPath.item-1];
        cell.goodsModel = model;
        NSString *goodsImage = [NSString stringWithFormat:@"%@%@",imageHost,model.goodsPreview];
        cell.shareBlock = ^{
            if (![Utils isBlankString:self.myInfoM.userGrade] && [self.myInfoM.userGrade integerValue] <= 1) {
                NSString *shareUrlStr = [NSString stringWithFormat:@"%@app/user/toDetail/%@?mobilePhone=%@",shareHostTest,model.ID
                                         ,account];
                
                NSString *title = [NSString stringWithFormat:@"%@",model.goodsName];
                [self shareGoodsWithUrl:shareUrlStr title:title imageUrl:goodsImage];
                
            } else {
                [MBProgressHUD showToastText:@"省、市代无法分享" toView:self.navigationController.view];
            }
        };
        return cell;
    }
    
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.item >= 1) {
        shoppingCartModel *model = self.hotGroupArray[indexPath.item-1];
        googsInfoViewController *goodsInfo = [googsInfoViewController new];
        goodsInfo.hidesBottomBarWhenPushed = YES;
        model.num = @"0";
        goodsInfo.model = model;
        goodsInfo.goodsID = model.goodsId;
        goodsInfo.goodsPreview = model.goodsPreview;
        goodsInfo.isGroup = [model.isGroup boolValue];
        [self.navigationController pushViewController:goodsInfo animated:YES];
    }
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.item == 0) {
        return CGSizeMake(kScreenWidth, 100);
    }else if (indexPath.item == 1){
        return CGSizeMake(kScreenWidth , ((kScreenWidth-26)/349.0)*187.0+66.5+62);
    }
    return CGSizeMake(kScreenWidth , ((kScreenWidth-26)/349.0)*187.0+18.5+62);
    
}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    UICollectionReusableView *reusableView = nil;
    
    if (kind == UICollectionElementKindSectionHeader) {
        groupingHeaderView *header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"groupingHeaderView" forIndexPath:indexPath];
        groupingModel *model = self.grouperArray[0];
        if ([model.status isEqualToString:@"2"] || [model.status isEqualToString:@"3"]) {
            header.isGrouped = YES;
        }else {
            header.isGrouped = NO;
        }
        header.grouperArr = self.grouperArray;
        header.goodsModel = self.goodsModel;
        header.shareBlock = ^(shoppingCartModel * _Nonnull goodsModel) {
            NSString *goodsImage = [NSString stringWithFormat:@"%@%@",imageHost,goodsModel.goodsPreview];
            if (![Utils isBlankString:self.myInfoM.userGrade] && [self.myInfoM.userGrade integerValue] <= 1) {
                NSString *shareUrlStr = [NSString stringWithFormat:shareGroupToWeiXinHost,self.groupId,self.accountStr];
                
                NSString *title = [NSString stringWithFormat:@"【库存有限】%@",goodsModel.goodsName];
                [self shareGroupGoodsWithUrl:shareUrlStr title:title imageUrl:goodsImage];
                
            } else {
                [MBProgressHUD showToastText:@"省、市代无法分享" toView:self.navigationController.view];
            }
        };
        reusableView = header;
    }else {
        reusableView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"footer" forIndexPath:indexPath];
        reusableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    }
    return reusableView;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    if (self.grouperArray.count) {
        groupingModel *model = self.grouperArray[0];
        if ([model.status isEqualToString:@"2"] || [model.status isEqualToString:@"3"]) {
            return CGSizeMake(kScreenWidth, 281+64*KAdaptiveRateWidth-45);
        }else {
            return CGSizeMake(kScreenWidth, 281+64*KAdaptiveRateWidth);
        }
    }
    return CGSizeMake(kScreenWidth, 281+64*KAdaptiveRateWidth-28);
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
    return CGSizeMake(kScreenWidth, 0.01);
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

- (void)shareGroupGoodsWithUrl:(NSString *)url title:(NSString *)title imageUrl:(NSString *)goodsImage{
    NSURL *shareBgUrl = [NSURL URLWithString:goodsImage];
    UIImageView *imageV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    //placeholderImage:[UIImage imageNamed:@"banner"]
    [imageV sd_setImageWithURL:shareBgUrl placeholderImage:[UIImage imageNamed:@"logo_180"] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        //1、创建分享参数
        //[[NSBundle mainBundle] pathForResource:@"banner" ofType:@"png"]
        NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
//
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
//        //        config.cancelButtonTitleColor = [UIColor redColor];
//
//        //设置对齐方式（简约版菜单无居中对齐）
//        config.itemAlignment = SSUIItemAlignmentCenter;
//
//        //设置标题文本颜色
//        //        config.itemTitleColor = [UIColor greenColor];
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
        if (imageData.length>32*1024) {
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
