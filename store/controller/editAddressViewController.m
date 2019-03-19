//
//  editAddressViewController.m
//  Distribution
//
//  Created by hchl on 2018/8/7.
//  Copyright © 2018年 hchl. All rights reserved.
//

#import "editAddressViewController.h"
#import "CZHAddressPickerView.h"
#import "AddressPickerHeader.h"
#import "addAddressTableViewCell.h"
#import "addAddressTwoTableViewCell.h"
#import "addAddressThreeTableViewCell.h"
@interface editAddressViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,UITextViewDelegate>
@property (nonatomic, strong) NSMutableDictionary *dataDic;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSString *pro;
@property (nonatomic, strong) NSString *city;
@property (nonatomic, strong) NSString *area;
@property (nonatomic, strong) NSArray *titleArr;
@end

@implementation editAddressViewController
static NSString *addAddressTableViewCellID = @"addAddressTableViewCell";
static NSString *addAddressTwoTableViewCellID = @"addAddressTwoTableViewCell";
static NSString *addAddressThreeTableViewCellID = @"addAddressThreeTableViewCell";
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-(isIphoneX?tabHeight:50)) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = RGB(241, 243, 246);
//        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.tableFooterView = [UIView new];
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
        [_tableView registerNib:[UINib nibWithNibName:addAddressTableViewCellID bundle:[NSBundle mainBundle]] forCellReuseIdentifier:addAddressTableViewCellID];
        [_tableView registerNib:[UINib nibWithNibName:addAddressTwoTableViewCellID bundle:[NSBundle mainBundle]] forCellReuseIdentifier:addAddressTwoTableViewCellID];
        [_tableView registerNib:[UINib nibWithNibName:addAddressThreeTableViewCellID bundle:[NSBundle mainBundle]] forCellReuseIdentifier:addAddressThreeTableViewCellID];
        
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
    self.titleArr = @[@"收货人姓名（请使用真实姓名）",@"手机号码",@"所在地区"];
    self.view.backgroundColor = RGB(241, 243, 246);
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.naviBarView];
    self.navigationItem.leftBarButtonItem = self.backItem;
    self.title = @"添加地址";
    if (self.type == 2) {
        self.title = @"修改地址";
        self.pro = self.model.pro;
        self.city = self.model.city;
        self.area = self.model.area;
        
    }
    UIButton *saveBtn = [UIButton czh_buttonWithTarget:self action:@selector(clickSave) frame:CGRectMake(0, 0, 35, 40) titleColor:RGB(51, 51, 51) titleFont:sysFont title:@"保存"];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:saveBtn];
    self.navigationItem.rightBarButtonItem = rightItem;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 4;
    }else {
        return 1;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 44;
    }else {
        return 10;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0 && indexPath.row == 3 ) {
        return 112;
    }
    return 44;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return nil;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 44)];
        view.backgroundColor = FXBGColor;
        UILabel *la = [[UILabel alloc] initWithFrame:CGRectMake(16, 0, 100, 44)];
        la.text = @"地址信息";
        la.font = [UIFont systemFontOfSize:14];
        [view addSubview:la];
        return view;
    } else {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 10)];
        view.backgroundColor = FXBGColor;
        return view;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (indexPath.row < 3) {
            addAddressTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:addAddressTableViewCellID forIndexPath:indexPath];
            if (indexPath.row == 2) {
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                cell.inputView.userInteractionEnabled = NO;
                if (self.type == 2) {
                    cell.inputView.text = [NSString stringWithFormat:@"%@ %@ %@",self.model.pro,self.model.city,self.model.area];
                }
            } else {
                cell.inputView.userInteractionEnabled = YES;
                if (indexPath.row == 1) {
                    cell.inputView.keyboardType = UIKeyboardTypePhonePad;
                    [cell.inputView addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
                    if (self.type == 2) {
                        cell.inputView.text = self.model.receivePhone;
                    }
                } else {
                    if (self.type == 2) {
                        cell.inputView.text = self.model.receivePerson;
                    }
                }
            }
            cell.inputView.delegate = self;
            cell.inputView.tag = indexPath.row+1;
            cell.inputView.placeholder = self.titleArr[indexPath.row];
            
            
            return cell;
        } else {
            addAddressTwoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:addAddressTwoTableViewCellID forIndexPath:indexPath];
            cell.inputView.tag = 4;
            if (self.type == 2) {
                cell.inputView.text = self.model.des;
                cell.placeHolderLb.hidden = YES;
            }
            return cell;
        }
    } else {
        addAddressThreeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:addAddressThreeTableViewCellID forIndexPath:indexPath];
        cell.isDefSwitch.tag = 100;
        if (self.type == 2) {
            cell.isDefSwitch.on = [self.model.def boolValue];
        }
        
        return cell;
    }
}
//保存地址
- (void)clickSave {
    
    UISwitch *isDefS = [self.tableView viewWithTag:100];
    NSString *isDef = [NSString stringWithFormat:@"%d",isDefS.on];
    UITextView *textV = [self.tableView viewWithTag:4];
    [textV endEditing:YES];
    NSMutableArray *dataArr = @[].mutableCopy;
    for (int i=0; i<3; i++) {
        UITextField *textF = [self.tableView viewWithTag:i+1];
        [textF endEditing:YES];
        [dataArr addObject:textF.text];
    }
    
    NSLog(@"%@ %@ %@",isDef,textV.text,dataArr);
    
    if (dataArr.count == 3 && ![Utils isBlankString:textV.text]) {
        //新建地址
        
        if (self.type == 1) {
            NSDictionary *parameters = @{@"receivePerson":dataArr[0],@"receivePhone":dataArr[1],@"pro":self.pro,@"city":self.city,@"area":self.area,@"des":textV.text,@"def":isDef,@"id":@"0"};
            NSString *apiPath = [NSString stringWithFormat:@"%@%@",addAddressUrl,self.myInfoM.ID];
            [[ZLJNetWorkManager defaultManager]sendRequestMethod:HTTPMethodPOST isLogin:NO isJsonRequest:YES serverUrl:requestHost apiPath:apiPath parameters:parameters progress:^(NSProgress * _Nullable progress) {
                
            } success:^(BOOL isSuccess, id  _Nullable responseObject) {
                NSDictionary *dataDic = [NSDictionary changeType:responseObject];
                if (dataDic) {
                    NSString *code = dataDic[@"code"];
                    NSString *msg = dataDic[@"message"];
                    if ([code integerValue] == 200) {
                        [MBProgressHUD showSuccess:@"新建成功" toView:self.navigationController.view];
                        if (self.refreshBlcok) {
                            self.refreshBlcok();
                        }
                        addressModel *model = [addressModel mj_objectWithKeyValues:parameters];
                        if ([model.def isEqualToString:@"1"]) {
                            NSData *addressData = [NSKeyedArchiver archivedDataWithRootObject:model];
                            [FXObjManager dc_saveUserData:addressData forKey:defaultAddres];
                        }
                        [self.navigationController popViewControllerAnimated:YES];
                    } else {
                        [MBProgressHUD showError:msg toView:self.navigationController.view];
                    }
                } else {
                    [MBProgressHUD showError:myRequestError toView:self.navigationController.view];
                }
            } failure:^(NSString * _Nullable errorMessage) {
                [MBProgressHUD showError:errorMessage toView:self.navigationController.view];
            }];
        } else {
            //修改地址
            NSDictionary *parameters = @{@"receivePerson":dataArr[0],@"receivePhone":dataArr[1],@"pro":self.pro,@"city":self.city,@"area":self.area,@"des":textV.text,@"def":isDef,@"id":self.model.ID};
            NSString *apiPath = [NSString stringWithFormat:@"%@%@",updateAddressUrl,self.myInfoM.ID];
            [[ZLJNetWorkManager defaultManager]sendRequestMethod:HTTPMethodPOST isLogin:NO isJsonRequest:YES serverUrl:requestHost apiPath:apiPath parameters:parameters progress:^(NSProgress * _Nullable progress) {
                
            } success:^(BOOL isSuccess, id  _Nullable responseObject) {
                NSDictionary *dataDic = [NSDictionary changeType:responseObject];
                if (dataDic) {
                    NSString *code = dataDic[@"code"];
                    NSString *msg = dataDic[@"message"];
                    if ([code integerValue] == 200) {
                        [MBProgressHUD showSuccess:@"修改成功" toView:self.navigationController.view];
                        if (self.refreshBlcok) {
                            self.refreshBlcok();
                        }
                        addressModel *model = [addressModel mj_objectWithKeyValues:parameters];
                        if ([model.def isEqualToString:@"1"]) {
                            NSData *addressData = [NSKeyedArchiver archivedDataWithRootObject:model];
                            [FXObjManager dc_saveUserData:addressData forKey:defaultAddres];
                        }
                        [self.navigationController popViewControllerAnimated:YES];
                    } else {
                        [MBProgressHUD showError:msg toView:self.navigationController.view];
                    }
                } else {
                    [MBProgressHUD showError:myRequestError toView:self.navigationController.view];
                }
            } failure:^(NSString * _Nullable errorMessage) {
                [MBProgressHUD showError:errorMessage toView:self.navigationController.view];
            }];
        }
        
    } else {
        [MBProgressHUD showError:@"请填写完整信息" toView:self.navigationController.view];
    }
    
}
- (void)textFieldDidEndEditing:(UITextField *)textField {
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITextView *textV = [self.tableView viewWithTag:4];
    [textV endEditing:YES];
    
    for (int i=0; i<3; i++) {
        UITextField *textF = [self.tableView viewWithTag:i+1];
        [textF endEditing:YES];
    }
    addAddressTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (indexPath.section == 0 && indexPath.row == 2) {
        [CZHAddressPickerView areaPickerViewWithAreaBlock:^(NSString *province, NSString *city, NSString *area) {
            cell.inputView.text = [NSString stringWithFormat:@"%@ %@ %@",province,city,area];
            self.pro = province;
            self.city = city;
            self.area = area;
        }];

    }
}
- (void)textFieldDidChange:(UITextField *)textField {
    if (textField.text.length > 11) {
        textField.text = [textField.text substringToIndex:11];
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
