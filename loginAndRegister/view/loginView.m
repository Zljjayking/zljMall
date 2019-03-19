//
//  loginView.m
//  Distribution
//
//  Created by hchl on 2018/7/24.
//  Copyright © 2018年 hchl. All rights reserved.
//

#import "loginView.h"

@implementation loginView
- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    self = [[[NSBundle mainBundle] loadNibNamed:@"loginView" owner:self options:nil] lastObject];
    if (self) {
        self.frame = frame;
        self.loginBtn.layer.masksToBounds = YES;
        self.loginBtn.layer.cornerRadius = 17.5;
        [self.loginBtn addTarget:self action:@selector(loginBtnClick) forControlEvents:UIControlEventTouchUpInside];
        
        
        self.phoneTF.backgroundColor = clear;
        self.phoneTF.tag = 1;
        [self.phoneTF setValue:[UIColor whiteColor]
                  forKeyPath:@"_placeholderLabel.textColor"];
        self.phoneTF.layer.borderColor = clear.CGColor;
        self.phoneTF.layer.borderWidth = 0;
        self.phoneTF.clearButtonMode = UITextFieldViewModeAlways;
        self.phoneTF.keyboardType = UIKeyboardTypeNumberPad;
        [self.phoneTF addTarget:self action:@selector(textDidChange:) forControlEvents:UIControlEventEditingChanged];
        self.phoneTF.delegate = self;
        NSString *account = [FXObjManager dc_readUserDataForKey:@"account"];
        NSString *isCheck = [FXObjManager dc_readUserDataForKey:BOOLIsChecking];
        if (![Utils isBlankString:account] && ![isCheck boolValue]) {
            self.phoneTF.text = account;
        }
        
        self.pwdTF.backgroundColor = clear;
        self.pwdTF.tag = 2;
        [self.pwdTF setValue:[UIColor whiteColor]
                    forKeyPath:@"_placeholderLabel.textColor"];
        self.pwdTF.layer.borderColor = clear.CGColor;
        self.pwdTF.layer.borderWidth = 0;
        self.pwdTF.delegate = self;
        self.pwdTF.clearButtonMode = UITextFieldViewModeAlways;
//        [self.pwdTF addTarget:self action:@selector(textDidChange:) forControlEvents:UIControlEventEditingChanged];
        self.pwdTF.secureTextEntry = YES;
        
        [self.forgetBtn addTarget:self action:@selector(forgetBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

- (void)textDidChange:(UITextField *)textfeild {
    NSString *text = textfeild.text;
    if (text.length > 11) {
        textfeild.text = [text substringToIndex:11];
    }
}
- (void)loginBtnClick {
    if (self.phoneTF.text.length == 11 && self.pwdTF.text.length ) {
        //登陆
        [self.phoneTF endEditing:YES];
        [self.pwdTF endEditing:YES];
        [MBProgressHUD showMessage:@"正在登录"];
        NSString *pwdStr = [NSString MD5ForLower32Bate:self.pwdTF.text];
        [[ZLJNetWorkManager defaultManager] sendRequestMethod:HTTPMethodPOST isLogin:YES isJsonRequest:NO serverUrl:requestHost apiPath:loginUrl parameters:@{@"username":self.phoneTF.text,@"password":pwdStr,@"grant_type":@"password"} progress:^(NSProgress * _Nullable progress) {
            
        } success:^(BOOL isSuccess, id  _Nullable responseObject) {
            NSDictionary *dic = [NSDictionary changeType:responseObject];
            if (dic) {
                [FXObjManager dc_saveUserData:self.phoneTF.text forKey:@"account"];
                [FXObjManager dc_saveUserData:self.pwdTF.text forKey:@"pwd"];
                [FXObjManager dc_saveUserData:dic forKey:loginResponse];
                [self requestMyInfoData];
                
            }
            [MBProgressHUD hideHUD];
        } failure:^(NSString * _Nullable errorMessage) {
            [MBProgressHUD hideHUD];
            [MBProgressHUD showError:errorMessage];
            
        }];
        
    } else {
        [MBProgressHUD showError:@"账号或密码格式错误"];
    }
}
- (void)requestMyInfoData {
    [[ZLJNetWorkManager defaultManager] sendRequestMethod:HTTPMethodPOST isLogin:NO isJsonRequest:NO serverUrl:requestHost apiPath:myInfoUrl parameters:nil progress:^(NSProgress * _Nullable progress) {
        
    } success:^(BOOL isSuccess, id  _Nullable responseObject) {
        
        NSDictionary *dataDic = [NSDictionary changeType:responseObject];
        if (dataDic) {
            NSString *code = dataDic[@"code"];
            NSString *msg = dataDic[@"message"];
            NSDictionary *data = dataDic[@"data"];
            
            if ([code isEqualToString:@"200"]) {
                if ([data isKindOfClass:[NSDictionary class]] && [data allKeys].count >= 1) {
                    [[myInfoMananger sharedPersonalInfoManager]setLoginPeopleInfo:data];
                    if (self.loginblock) {
                        self.loginblock(self.phoneTF.text, self.pwdTF.text);
                    }
                    NSString *userID = data[@"id"];
                    [JPUSHService setTags:nil aliasInbackground:userID];
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        
                        [JPUSHService setTags:nil alias:userID fetchCompletionHandle:^(int iResCode, NSSet *iTags, NSString *iAlias){
                            
                        }];
                        
                    });
                }
                
            } else {
                [MBProgressHUD showError:msg];
            }
        } else {

        }
    } failure:^(NSString * _Nullable errorMessage) {
//        [MBProgressHUD showError:errorMessage toView:self.view];
    }];
    
}
- (void)forgetBtnClick {
    if (self.findPwdBlock) {
        self.findPwdBlock();
    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
