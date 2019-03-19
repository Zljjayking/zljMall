//
//  addressViewController.m
//  Distribution
//  Created by hchl on 2018/8/6.
//  Copyright © 2018年 hchl. All rights reserved.

#import "addressViewController.h"
#import "addressModel.h"
#import "addressMagTableViewCell.h"
#import "editAddressViewController.h"

@interface addressViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) UITableView *tableView;
@end

@implementation addressViewController
static NSString *addressMagTableViewCellID = @"addressMagTableViewCell";
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-(isIphoneX?tabHeight:50)) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = RGB(241, 243, 246);
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.tableFooterView = [UIView new];
        [_tableView registerNib:[UINib nibWithNibName:addressMagTableViewCellID bundle:[NSBundle mainBundle]] forCellReuseIdentifier:addressMagTableViewCellID];
    }
    return _tableView;
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self getNetwork];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.isWhiteNavi = YES;
    self.view.backgroundColor = RGB(241, 243, 246);
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.naviBarView];
    self.navigationItem.leftBarButtonItem = self.backItem;
    self.title = @"收货管理";
    self.blankV = [[blankView alloc]initWithFrame:CGRectMake(kScreenWidth/2.0-40, self.view.center.y/2.0-0, 80, 80) imageName:@"noData" title:@"暂无地址信息"];
    
    [self.tableView addSubview:self.blankV];
    self.blankV.hidden = YES;
    self.dataSource = @[].mutableCopy;
    [self requestData];
    [self setBottomView];
    [self.tableView reloadData];
    self.blankV = [[blankView alloc]initWithFrame:CGRectMake(kScreenWidth/2.0-40, self.view.center.y/2.0-0, 80, 80) imageName:@"noData" title:@"暂无地址数据"];
    [self.tableView addSubview:self.blankV];
    self.blankV.hidden = YES;
}
- (void)requestData {
    NSString *apiPath = [NSString stringWithFormat:@"%@%@",addressMagUrl,self.myInfoM.ID];
    [[ZLJNetWorkManager defaultManager]sendRequestMethod:HTTPMethodPOST isLogin:NO isJsonRequest:NO serverUrl:requestHost apiPath:apiPath parameters:nil progress:^(NSProgress * _Nullable progress) {
        
    } success:^(BOOL isSuccess, id  _Nullable responseObject) {
        NSDictionary *dataDic = [NSDictionary changeType:responseObject];
        if (dataDic) {
            NSString *code = dataDic[@"code"];
            NSString *msg = dataDic[@"message"];
            if ([code integerValue] == 200) {
                self.dataSource = [addressModel mj_objectArrayWithKeyValuesArray:dataDic[@"data"]];
                for (int i=0;i<self.dataSource.count;i++) {
                    addressModel *model = self.dataSource[i];
                    if ([model.def boolValue]) {
                        [self.dataSource exchangeObjectAtIndex:i withObjectAtIndex:0];
                    }
                }
                if (self.dataSource.count == 0) {
                    self.blankV.hidden = NO;
                } else {
                    self.blankV.hidden = YES;
                }
                [self.tableView reloadData];
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
- (void)setBottomView {
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, kScreenHeight-(isIphoneX?tabHeight:50), kScreenWidth, isIphoneX?tabHeight:50)];
    bgView.backgroundColor = FXBGColor;
    [self.view addSubview:bgView];
    
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 50)];
    bottomView.backgroundColor = myWhite;
    [bgView addSubview:bottomView];
    
    UIButton *addAddressBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [addAddressBtn setBackgroundImage:[UIImage imageWithColor:RGB(43, 131, 250)] forState:UIControlStateNormal];
    [addAddressBtn setImage:[UIImage imageNamed:@"address_add_icon"] forState:UIControlStateNormal];
    addAddressBtn.frame = CGRectMake(20, 5, kScreenWidth-40, 40);
    [addAddressBtn setTitle:@"新建地址" forState:UIControlStateNormal];
    addAddressBtn.imageRect = CGRectMake(kScreenWidth/2.0-60, 11.5, 17, 17);
    addAddressBtn.titleRect = CGRectMake(kScreenWidth/2.0-30, 0, 100, 40);
    addAddressBtn.titleLabel.font = sysFont;
    addAddressBtn.layer.masksToBounds = YES;
    addAddressBtn.layer.cornerRadius = 20;
    [addAddressBtn addTarget:self action:@selector(addAddress) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:addAddressBtn];
    
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    addressMagTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:addressMagTableViewCellID forIndexPath:indexPath];
    addressModel *model = self.dataSource[indexPath.row];
    cell.model = model;
    cell.defaultBlcok = ^(BOOL isDefault) {
        for (addressModel *model in self.dataSource) {
            model.def = @"0";
        }
        //这里设置默认地址
        model.def = @"1";
        [tableView reloadData];
    };
    cell.editBlock = ^{
        editAddressViewController *edit = [editAddressViewController new];
        edit.model = model;
        edit.type = 2;
        edit.refreshBlcok = ^{
            //这里发起请求，刷新数据
            [self requestData];
        };
        [self.navigationController pushViewController:edit animated:YES];
    };
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    addressModel *model = self.dataSource[indexPath.row];
    if (self.addressModelBlock) {
        self.addressModelBlock(model);
        [self.navigationController popViewControllerAnimated:YES];
    }
}
/*改变删除按钮的title*/
-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    addressModel *model = self.dataSource[indexPath.row];
    [self.dataSource removeObject:model];
    //执行删除地址操作
    if (self.dataSource.count == 0) {
        [self.tableView removeFromSuperview];
    } else {
        if (indexPath.row == 0) {
            addressModel *model = self.dataSource[0];
            model.def = @"1";
            //执行更改默认地址操作
            
        }
    }
    [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationTop];
//    [self performSelector:@selector(reloadCellData) withObject:nil afterDelay:0.5];
    [self deleteAddressWithModel:model];
}
- (void)deleteAddressWithModel:(addressModel*)model {
    NSString *apiPath = [NSString stringWithFormat:@"%@%@",deleteAddressUrl,model.ID];
    [[ZLJNetWorkManager defaultManager] sendRequestMethod:HTTPMethodPOST isLogin:NO isJsonRequest:NO serverUrl:requestHost apiPath:apiPath parameters:nil progress:^(NSProgress * _Nullable progress) {
        
    } success:^(BOOL isSuccess, id  _Nullable responseObject) {
        NSDictionary *dataDic = [NSDictionary changeType:responseObject];
        if (dataDic) {
            NSString *code = dataDic[@"code"];
            NSString *msg = dataDic[@"message"];
            if ([code integerValue] == 200) {
                [MBProgressHUD showSuccess:@"删除成功" toView:self.navigationController.view];
            }else {
                [MBProgressHUD showError:msg toView:self.navigationController.view];
            }
        }else {
            [MBProgressHUD showError:@"网络故障,操作失败" toView:self.navigationController.view];
        }
    } failure:^(NSString * _Nullable errorMessage) {
        [MBProgressHUD showError:@"网络故障,操作失败" toView:self.navigationController.view];
    }];
}
- (void)reloadCellData {
    [self.tableView reloadData];
}
- (void)addAddress {
    editAddressViewController *edit = [editAddressViewController new];
    edit.type = 1;
    edit.refreshBlcok = ^{
        //这里发起请求，刷新数据
        [self requestData];
    };
    [self.navigationController pushViewController:edit animated:YES];
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
