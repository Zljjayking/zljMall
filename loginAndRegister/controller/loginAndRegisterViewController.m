//
//  loginAndRegisterViewController.m
//  Distribution
//
//  Created by hchl on 2018/7/24.
//  Copyright © 2018年 hchl. All rights reserved.
//

#import "loginAndRegisterViewController.h"
#import "loginView.h"
#import "registerView.h"

#import "myTabBarController.h"
#import "changePwdViewController.h"
#import "agreementViewController.h"
#import "DHGuidePageHUD.h"
#import "ADViewController.h"
#import "AYCheckManager.h"
#import <JPush/JPUSHService.h>
@interface loginAndRegisterViewController ()
@property (nonatomic, strong) UINavigationController *navi;
@property (nonatomic, strong) loginView *loginV;
@property (nonatomic, strong) registerView *registerV;
@property (nonatomic, strong) UIScrollView *scrollV;

@property (nonatomic, strong) UIButton *loginBtn;
@property (nonatomic, strong) UIButton *registerBtn;
@property (nonatomic, strong) UIView *lineV;

@property (nonatomic, strong) UIButton *closeBtn;
@property (nonatomic, strong) NSString *phone;
@end

@implementation loginAndRegisterViewController
- (loginView *)loginV {
    if (!_loginV) {
        _loginV = [[loginView alloc] initWithFrame:CGRectMake(25, 0, kScreenWidth-50, 260)];
        _loginV.layer.cornerRadius = 20;
        _loginV.backgroundColor = clear;
    }
    return _loginV;
}
- (registerView *)registerV {
    if (!_registerV) {
        _registerV = [[registerView alloc] initWithFrame:CGRectMake(kScreenWidth + 25, 0, kScreenWidth-50, 400)];
        _registerV.layer.cornerRadius = 20;
        _registerV.backgroundColor = clear;
    }
    return _registerV;
}
- (UIScrollView *)scrollV {
    if (!_scrollV) {
        _scrollV = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 168*KAdaptiveRateHeight, kScreenWidth, 400)];
        _scrollV.backgroundColor = clear;
        _scrollV.contentSize = CGSizeMake(kScreenWidth*2, 400);
        _scrollV.pagingEnabled = YES;
        _scrollV.showsHorizontalScrollIndicator = NO;
        _scrollV.scrollEnabled = NO;
    }
    return _scrollV;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @" ";
//    [JPUSHService setTags:nil alias:@"" callbackSelector:@selector(tagsAliasCallback:tags:alias:) object:self];
    // 设置APP引导页
//    if (![[NSUserDefaults standardUserDefaults] boolForKey:BOOLFORKEY]) {
//        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:BOOLFORKEY];
//        
//        NSArray *imageArray = @[[UIImage imageNamed:@"1"],[UIImage imageNamed:@"2"],[UIImage imageNamed:@"3"],[UIImage imageNamed:@"4"]];
//        DHGuidePageHUD *guidePage = [[DHGuidePageHUD alloc] dh_initWithFrame:self.view.frame imageArray:imageArray buttonIsHidden:NO];
//        guidePage.isFirst = ^{
//            
//        };
//        [self.navigationController.view addSubview:guidePage];
//    }
    
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:[UIColor clearColor]] forBarMetrics:UIBarMetricsDefault];
    self.view.backgroundColor = [UIColor grayColor];
    
    [self setUpUIs];
    
}


- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
}
- (void)setUpUIs {
    UIImageView *imageV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    imageV.image = [UIImage imageNamed:@"login_bg"];
    [self.view addSubview:imageV];
    
    UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [closeBtn setBackgroundImage:[UIImage imageNamed:@"icon_close"] forState:UIControlStateNormal];
    [self.navigationController.view addSubview:closeBtn];
    self.closeBtn = closeBtn;
    closeBtn.hidden = YES;
    if (self.isCheck) {
        closeBtn.hidden = NO;
        if (self.isLogout) {
            closeBtn.hidden = YES;
        }
    }
    closeBtn.frame = CGRectMake(kScreenWidth-55, 25, 35, 35);
    [closeBtn addTarget:self action:@selector(closeBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    self.loginBtn = [UIButton czh_buttonWithTarget:self action:@selector(lgoinViewAppear) frame:CGRectMake(kScreenWidth/2.0-110*KAdaptiveRateWidth, 104*KAdaptiveRateHeight, 110*KAdaptiveRateWidth, 33) titleColor:myWhite titleFont:[UIFont systemFontOfSize:20] title:@"登录"];
    [self.view addSubview:self.loginBtn];
    self.registerBtn = [UIButton czh_buttonWithTarget:self action:@selector(registerViewAppear) frame:CGRectMake(kScreenWidth/2.0, 104*KAdaptiveRateHeight, 110*KAdaptiveRateWidth, 33) titleColor:myWhite titleFont:[UIFont systemFontOfSize:20] title:@"注册"];
    [self.view addSubview:self.registerBtn];
    
    self.lineV = [[UIView alloc] initWithFrame:CGRectMake(self.loginBtn.x+20, self.loginBtn.y+self.loginBtn.height+1, 110*KAdaptiveRateWidth-40, 2)];
    self.lineV.backgroundColor = myWhite;
    [self.view addSubview:self.lineV];
    
    [self.view addSubview:self.scrollV];
    [self.scrollV addSubview:self.loginV];
    [self.scrollV addSubview:self.registerV];
    WEAKSELF
    self.loginV.loginblock = ^(NSString *phone, NSString *pwd) {
        if (phone) {
            weakSelf.phone = phone;
        }
        if (![phone isEqualToString:testNum]) {
            [FXObjManager dc_saveUserData:@"0" forKey:BOOLIsChecking];
        }else {
            [FXObjManager dc_saveUserData:@"1" forKey:BOOLIsChecking];
        }
        [FXObjManager dc_saveUserData:@"0" forKey:BOOLLoadOther];
        [FXObjManager dc_saveUserData:@"0" forKey:BOOLLoadMyRec];
        [FXObjManager dc_saveUserData:@"0" forKey:BOOLLoadMyOrder];
        [FXObjManager dc_saveUserData:@"0" forKey:BOOLLoadShoppingCart];
        [FXObjManager dc_saveUserData:@"0" forKey:BOOLCheckVersion];
        [FXObjManager dc_saveUserData:@"0" forKey:BOOLIsFirstMicro];
        [FXObjManager dc_saveUserData:@"0" forKey:BOOLIsLoadMicro];
        
        NSDictionary *appInfoDic = [FXObjManager dc_readUserDataForKey:appInfoStr];
        if (!appInfoDic) {
            [weakSelf requestAppInfo];
        } else {
            NSString *isChecking = [FXObjManager dc_readUserDataForKey:BOOLIsChecking];
            NSString *isLogin = [FXObjManager dc_readUserDataForKey:BOOLIsLogin];
            if ([isChecking boolValue] && [isLogin boolValue]) {
                if ([phone isEqualToString:testNum]) {
                    [weakSelf dismissViewControllerAnimated:YES completion:^{
                        
                    }];
                }else {
                    [UIApplication sharedApplication].keyWindow.rootViewController = [myTabBarController new];
                }
            }else {
                [UIApplication sharedApplication].keyWindow.rootViewController = [myTabBarController new];
            }
            
//            AYCheckManager *checkManger = [AYCheckManager sharedCheckManager];
//            checkManger.countryAbbreviation = @"cn";
//            [checkManger checkVersionWithAlertTitle:@"发现新版本" nextTimeTitle:@"" confimTitle:@"前往更新" skipVersionTitle:@""];
        }
        [FXObjManager dc_saveUserData:@"1" forKey:BOOLIsLogin];
        [FXObjManager dc_saveUserData:@"0" forKey:BOOLIsLogout];
    };
    self.loginV.findPwdBlock = ^{
        
        [weakSelf findPwd];
    };
    
    self.registerV.registBlock = ^(NSString *mobile, NSString *vcode, NSString *referrer, NSString *pwd) {
        //注册
        if (referrer) {
            [[ZLJNetWorkManager defaultManager] sendRequestMethod:HTTPMethodPOST isLogin:NO isJsonRequest:NO serverUrl:requestHost apiPath:registerUrl parameters:@{@"mobilePhone":mobile,@"checkCode":vcode,@"referrerPhone":referrer,@"password":pwd} progress:^(NSProgress * _Nullable progress) {
                
            } success:^(BOOL isSuccess, id  _Nullable responseObject) {
                NSDictionary *dic = [NSDictionary changeType:responseObject];
                if (dic) {
                    NSString *code = dic[@"code"];
                    NSString *msg = dic[@"message"];
                    if ([code isEqualToString:@"200"]) {
                        [MBProgressHUD showSuccess:@"注册成功"];
                        [weakSelf lgoinViewAppear];
                        weakSelf.loginV.phoneTF.text = mobile;
                    } else {
                        [MBProgressHUD showError:msg toView:weakSelf.view];
                    }
                }
            } failure:^(NSString * _Nullable errorMessage) {
                [MBProgressHUD showError:errorMessage];
            }];
        } else {
            [[ZLJNetWorkManager defaultManager] sendRequestMethod:HTTPMethodPOST isLogin:NO isJsonRequest:NO serverUrl:requestHost apiPath:registerUrl parameters:@{@"mobilePhone":mobile,@"checkCode":vcode,@"password":pwd} progress:^(NSProgress * _Nullable progress) {
                
            } success:^(BOOL isSuccess, id  _Nullable responseObject) {
                NSDictionary *dic = [NSDictionary changeType:responseObject];
                if (dic) {
                    NSString *code = dic[@"code"];
                    NSString *msg = dic[@"message"];
                    if ([code isEqualToString:@"200"]) {
                        [MBProgressHUD showSuccess:@"注册成功"];
                    } else {
                        [MBProgressHUD showError:msg toView:weakSelf.view];
                    }
                }
            } failure:^(NSString * _Nullable errorMessage) {
                [MBProgressHUD showError:errorMessage toView:weakSelf.view];
            }];
        }
    };
    self.registerV.protocolBlock = ^{
        agreementViewController *agreement = [agreementViewController new];
        NSDictionary *appInfoDic = [FXObjManager dc_readUserDataForKey:appInfoStr];
        NSArray *agreementList = appInfoDic[@"list"];
        for (NSDictionary *agreementDic in agreementList) {
            if ([agreementDic[@"type"] isEqualToString:@"1"]) {
                agreement.agreementStr = agreementDic[@"content"];
            }
        }
        agreement.type = 1;
        [weakSelf.navigationController pushViewController:agreement animated:YES];
    };
}
- (void)lgoinViewAppear {
    [UIView animateWithDuration:0.3 animations:^{
        [self.scrollV setContentOffset:CGPointMake(0, 0)];
        self.lineV.frame = CGRectMake(self.loginBtn.x+20, self.loginBtn.y+self.loginBtn.height+1, 110*KAdaptiveRateWidth-40, 2);
    }];
    
}
- (void)closeBtnClick {
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}
- (void)registerViewAppear {
    
    [UIView animateWithDuration:0.3 animations:^{
        [self.scrollV setContentOffset:CGPointMake(kScreenWidth, 0)];
        self.lineV.frame = CGRectMake(self.registerBtn.x+20, self.registerBtn.y+self.registerBtn.height+1, 110*KAdaptiveRateWidth-40, 2);
    }];
    
}

- (void)pushAd {
//    ADViewController *advc = [[ADViewController alloc] init];
//    [self.navigationController pushViewController:advc animated:YES];
}

- (void)findPwd {
    changePwdViewController *changePwd = [changePwdViewController new];
    changePwd.titleStr = @"忘记密码";
    changePwd.type = 2;
    [self.navigationController pushViewController:changePwd animated:YES];

}

- (void)requestAppInfo {

    [[ZLJNetWorkManager defaultManager] sendRequestMethod:HTTPMethodPOST isLogin:NO isJsonRequest:NO serverUrl:requestHost apiPath:appInfoUrl parameters:nil progress:^(NSProgress * _Nullable progress) {
        
    } success:^(BOOL isSuccess, id  _Nullable responseObject) {
        
        NSDictionary *dataDic = [NSDictionary changeType:responseObject];
        NSString *code = dataDic[@"code"];
        NSString *msg = dataDic[@"message"];
        if ([code integerValue] == 200) {
            NSDictionary *dic = dataDic[@"data"];
            [FXObjManager dc_saveUserData:dic forKey:appInfoStr];
//            [UIApplication sharedApplication].keyWindow.rootViewController = [myTabBarController new];
            NSString *isChecking = [FXObjManager dc_readUserDataForKey:BOOLIsChecking];
            NSString *isLogin = [FXObjManager dc_readUserDataForKey:BOOLIsLogin];
            if ([isChecking boolValue] && [isLogin boolValue]) {
                if ([self.phone isEqualToString:testNum]) {
                    [self dismissViewControllerAnimated:YES completion:^{
                        
                    }];
                }else {
                    [UIApplication sharedApplication].keyWindow.rootViewController = [myTabBarController new];
                }
            }else {
                [UIApplication sharedApplication].keyWindow.rootViewController = [myTabBarController new];
            }
        } else {
            [MBProgressHUD showError:msg toView:self.navigationController.view];
        }
        
    } failure:^(NSString * _Nullable errorMessage) {
        
        [MBProgressHUD showError:errorMessage toView:self.navigationController.view];
    }];
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
