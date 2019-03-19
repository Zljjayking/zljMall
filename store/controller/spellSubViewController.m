//
//  spellSubViewController.m
//  Distribution
//
//  Created by hchl on 2018/12/25.
//  Copyright © 2018年 hchl. All rights reserved.
//

#import "spellSubViewController.h"
#import "goodsTableCell.h"
#import "shoppingCartModel.h"
@interface spellSubViewController ()<UITableViewDelegate, UITableViewDataSource>

@property(strong, nonatomic) UITableView *tableView;
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, strong) NSMutableArray *goodsArr;
@property (nonatomic, strong) NSString *shareUrlStr;
@end

@implementation spellSubViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.page = 1;
    self.goodsArr = @[].mutableCopy;
    self.view.backgroundColor = [UIColor whiteColor];
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    [self.view addSubview:self.tableView];
    
#warning 重要 必须赋值
    self.glt_scrollView = self.tableView;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"goodsTableCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"goodsTableCell"];

    
    self.blankV = [[blankView alloc]initWithFrame:CGRectMake(kScreenWidth/2.0-40, self.view.center.y/2.0, 80, 80) imageName:@"noData" title:@"暂无商品数据"];
    
    [self.tableView addSubview:self.blankV];
    self.blankV.hidden = YES;
    [self requestData];
}
- (void)refrshDataComplete:(void (^)(void))complete {
    _complete = complete;
    self.page = 1;
    [self requestData];
}
- (void)requestData {
    NSString *page = [NSString stringWithFormat:@"%ld",self.page];
    NSDictionary *parameter;
    
    parameter = @{@"goodsCategoryId":self.goodsCategoryId,@"userId":self.myInfoM.ID,@"hotGoods":@"0",@"page":page,@"size":@"10"};
    if ([self.goodsCategoryId isEqualToString:@"0"]) {
        parameter = @{@"userId":self.myInfoM.ID,@"hotGoods":@"0",@"page":page,@"size":@"10"};
    }
    [[ZLJNetWorkManager defaultManager] sendRequestMethod:HTTPMethodPOST isLogin:NO isJsonRequest:YES serverUrl:requestHost apiPath:spellGoodsListUrl parameters:parameter progress:^(NSProgress * _Nullable progress) {
        
    } success:^(BOOL isSuccess, id  _Nullable responseObject) {
        [self.tableView.mj_footer endRefreshing];
        NSDictionary *data = [NSDictionary changeType:responseObject];
        NSString *code = data[@"code"];
        NSString *message = data[@"message"];
        if ([code integerValue] == 200) {
            NSArray *dataArr = data[@"data"];
            if ([dataArr isKindOfClass:[NSArray class]]) {
                NSMutableArray *goodsArr = [shoppingCartModel mj_objectArrayWithKeyValuesArray:dataArr];
                for (shoppingCartModel *model in goodsArr) {
                    model.isGroup = @"1";
                }
                if (self.page == 1) {
                    [self.goodsArr removeAllObjects];
                    if (goodsArr.count == 0) {
                        self.blankV.hidden = NO;
                        self.tableView.mj_footer = nil;
                    }else {
                        self.blankV.hidden = YES;
                        self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
                            self.page++;
                            [self requestData];
                        }];
                    }
                }
                if (goodsArr.count < 10) {
                    [self.tableView.mj_footer endRefreshingWithNoMoreData];
                }
                [self.goodsArr addObjectsFromArray:goodsArr];
                
                [self.tableView reloadData];
                if (self.complete) {
                    self.complete();
                }
            }else {
                if (self.page > 1) {
                    self.page --;
                    [MBProgressHUD showError:@"暂无数据" toView:self.view];
                }
                if (self.complete) {
                    self.complete();
                }
            }
        }else {
            if (self.page > 1) {
                self.page --;
            }else {
                self.blankV.hidden = NO;
            }
            [MBProgressHUD showError:message toView:self.view];
            if (self.complete) {
                self.complete();
            }
        }
        
    } failure:^(NSString * _Nullable errorMessage) {
        [self.tableView.mj_footer endRefreshing];
        if (self.page > 1) {
            self.page --;
        }else {
            self.blankV.hidden = NO;
        }
        [MBProgressHUD showError:errorMessage toView:self.view];
        if (self.complete) {
            self.complete();
        }
    }];
}
- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.goodsArr.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return ((kScreenWidth-26)/349.0)*187.0+18.5+62;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    goodsTableCell  *cell = [tableView dequeueReusableCellWithIdentifier:@"goodsTableCell" forIndexPath:indexPath];
    shoppingCartModel *model = self.goodsArr[indexPath.row];
    cell.goodsModel = model;
    NSString *goodsImage = [NSString stringWithFormat:@"%@%@",imageHost,model.goodsPreview];
    NSString *account = [FXObjManager dc_readUserDataForKey:@"account"];
    cell.shareBlock = ^{
        if (![Utils isBlankString:self.myInfoM.userGrade] && [self.myInfoM.userGrade integerValue] <= 1) {
            NSString *shareUrlStr = [NSString stringWithFormat:@"%@app/user/toDetail/%@?mobilePhone=%@",shareHostTest,model.goodsId
                                     ,account];
            if ([model.isGroup isEqualToString:@"1"]) {
                shareUrlStr = [NSString stringWithFormat:shareGroupGoodsHost,model.goodsId,account];
            }
            shareUrlStr = [NSString stringWithFormat:shareGroupGoodsHost,model.goodsId,account];
            NSString *title = [NSString stringWithFormat:@"%@",model.goodsName];
            [self shareGoodsWithUrl:shareUrlStr title:title imageUrl:goodsImage];
        } else {
            [MBProgressHUD showToastText:@"省、市代无法分享" toView:self.navigationController.view];
        }
    };
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSLog(@"第 %ld 行", indexPath.row + 1);
    shoppingCartModel *model = self.goodsArr[indexPath.row];
    if (self.selectBlock) {
        self.selectBlock(model);
    }
}

- (UITableView *)tableView {
    if (!_tableView) {
        CGFloat H = isIphoneX ? (self.view.bounds.size.height - 44 - 64 - 24 - 34) : self.view.bounds.size.height - 44 - 64;
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 44, [UIScreen mainScreen].bounds.size.width, H) style:UITableViewStylePlain];
        _tableView.tableFooterView = [UIView new];
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
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
