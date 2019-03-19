//
//  registerView.m
//  Distribution
//
//  Created by hchl on 2018/7/24.
//  Copyright © 2018年 hchl. All rights reserved.
//

#import "registerView.h"

@implementation registerView
- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    self = [[[NSBundle mainBundle] loadNibNamed:@"registerView" owner:self options:nil] lastObject];
    if (self) {
        self.frame = frame;
        self.registerBtn.layer.masksToBounds = YES;
        self.registerBtn.layer.cornerRadius = 17.5;
        [self.registerBtn addTarget:self action:@selector(registerBtnClick) forControlEvents:UIControlEventTouchUpInside];
        
        self.vCodeBtn.layer.masksToBounds = YES;
        self.vCodeBtn.layer.cornerRadius = 12.5;
        [self.vCodeBtn addTarget:self action:@selector(sendVcode) forControlEvents:UIControlEventTouchUpInside];
        self.vCodeBtn.enabled = NO;
        
        
        [self.mobileTF setValue:[UIColor whiteColor]
                    forKeyPath:@"_placeholderLabel.textColor"];
        self.mobileTF.clearButtonMode = UITextFieldViewModeAlways;
        self.mobileTF.keyboardType = UIKeyboardTypeNumberPad;
        [self.mobileTF addTarget:self action:@selector(textDidChange:) forControlEvents:UIControlEventEditingChanged];
        self.mobileTF.delegate = self;
        
        [self.vCodetf setValue:[UIColor whiteColor]
                    forKeyPath:@"_placeholderLabel.textColor"];
        self.vCodetf.clearButtonMode = UITextFieldViewModeAlways;
        self.vCodetf.keyboardType = UIKeyboardTypePhonePad;
        self.vCodetf.delegate = self;
        
        [self.referrerTF setValue:[UIColor whiteColor]
                    forKeyPath:@"_placeholderLabel.textColor"];
        self.referrerTF.clearButtonMode = UITextFieldViewModeAlways;
        self.referrerTF.keyboardType = UIKeyboardTypeNumberPad;
        [self.referrerTF addTarget:self action:@selector(textDidChange:) forControlEvents:UIControlEventEditingChanged];
        self.referrerTF.delegate = self;
        
        [self.pwdTF setValue:[UIColor whiteColor]
                    forKeyPath:@"_placeholderLabel.textColor"];
        [self.pwdTF addTarget:self action:@selector(textDidChange:) forControlEvents:UIControlEventEditingChanged];
        self.pwdTF.clearButtonMode = UITextFieldViewModeAlways;
        self.pwdTF.secureTextEntry = YES;
        self.pwdTF.delegate = self;
        self.isClickGetYanZheng = NO;
        
        
        [self.protocolBtn addTarget:self action:@selector(protocolBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}
- (void)textDidChange:(UITextField *)textfeild {
    NSString *text = textfeild.text;
    
    if (textfeild == self.mobileTF) {
        if (text.length > 11) {
            textfeild.text = [text substringToIndex:11];
        }
        if (!self.isClickGetYanZheng) {
            if (textfeild.text.length == 11 ) {
                self.vCodeBtn.enabled = YES;
                [self.vCodeBtn setBackgroundImage:[UIImage imageWithColor:myWhite] forState:UIControlStateNormal];
                [self.vCodeBtn setTitleColor:myBlueType forState:UIControlStateNormal];
            } else {
                self.vCodeBtn.enabled = NO;
                [self.vCodeBtn setBackgroundImage:[UIImage imageWithColor:[UIColor lightGrayColor]] forState:UIControlStateNormal];
                [self.vCodeBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
            }
        }
    } else if (textfeild == self.pwdTF) {
        if (text.length > 20) {
            textfeild.text = [text substringToIndex:20];
        }
    } else if (textfeild == self.referrerTF) {
        if (text.length > 11) {
            textfeild.text = [text substringToIndex:11];
        }
    }
}
- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (textField == self.mobileTF) {
        self.mobile = self.mobileTF.text;
    }
}
- (void)registerBtnClick {
    [self.mobileTF endEditing:YES];
    [self.pwdTF endEditing:YES];
    [self.vCodetf endEditing:YES];
    [self.referrerTF endEditing:YES];
    if (self.mobileTF.text.length == 11 && self.pwdTF.text.length >= 6 && self.vCodetf.text.length == 6) {
        if (self.registBlock) {
            self.registBlock(self.mobileTF.text, self.vCodetf.text, self.referrerTF.text, self.pwdTF.text);
        }
    } else {
        if (self.mobileTF.text.length < 11) {
            [MBProgressHUD showError:@"注册手机号码有误"];
        }
        if (self.pwdTF.text.length < 6) {
            [MBProgressHUD showError:@"密码要大于6位"];
        }
        if (self.vCodetf.text.length < 6) {
            [MBProgressHUD showError:@"验证码格式有误"];
        }

    }
}
- (void)sendVcode {
    [self.mobileTF endEditing:YES];
    
    NSString *apiPath = [NSString stringWithFormat:sendMsgUrl,self.mobileTF.text,@"2"];
    [[ZLJNetWorkManager defaultManager] sendRequestMethod:HTTPMethodGET isLogin:NO isJsonRequest:NO serverUrl:requestHost apiPath:apiPath parameters:nil progress:^(NSProgress * _Nullable progress) {
        
    } success:^(BOOL isSuccess, id  _Nullable responseObject) {

    } failure:^(NSString * _Nullable errorMessage) {
        
    }];
    [self performSelector:@selector(reflashGetKeyBt:) withObject:[NSNumber numberWithInt:60] afterDelay:0];
}
//倒数
- (void)reflashGetKeyBt:(NSNumber *)second {
    if ([second integerValue] == 0) {
        self.vCodeBtn.enabled = YES;
        [self.vCodeBtn setBackgroundImage:[UIImage imageWithColor:myWhite] forState:UIControlStateNormal];
        [self.vCodeBtn setTitleColor:myBlueType forState:UIControlStateNormal];
        [self.vCodeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
        self.isClickGetYanZheng = NO;
    } else {
        self.isClickGetYanZheng = YES;
        self.vCodeBtn.enabled = NO;
        [self.vCodeBtn setBackgroundImage:[UIImage imageWithColor:[UIColor lightGrayColor]] forState:UIControlStateNormal];
        [self.vCodeBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        int i = [second intValue];
        if (i == 60) {
            [self.vCodeBtn setTitle:@"验证码已发送" forState:UIControlStateNormal];
        } else{
            NSString *text = [NSString stringWithFormat:@"%i秒后重发",i];
            [self.vCodeBtn setTitle:text forState:UIControlStateNormal];
        }
        
        [self performSelector:@selector(reflashGetKeyBt:) withObject:[NSNumber numberWithInt:i-1] afterDelay:1];
    }
}
- (void)protocolBtnClick {
    if (self.protocolBlock) {
        self.protocolBlock();
    }
}
@end
