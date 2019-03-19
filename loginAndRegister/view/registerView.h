//
//  registerView.h
//  Distribution
//
//  Created by hchl on 2018/7/24.
//  Copyright © 2018年 hchl. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^registerBlock)(NSString *mobile,NSString *vcode,NSString *referrer,NSString *pwd);

typedef void(^protocolBtnBlock)(void);
@interface registerView : UIView<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *mobileTF;
@property (weak, nonatomic) IBOutlet UITextField *vCodetf;
@property (weak, nonatomic) IBOutlet UIButton *vCodeBtn;
@property (weak, nonatomic) IBOutlet UITextField *referrerTF;
@property (weak, nonatomic) IBOutlet UITextField *pwdTF;
@property (weak, nonatomic) IBOutlet UIButton *registerBtn;
@property (weak, nonatomic) IBOutlet UIButton *protocolBtn;
@property (nonatomic, strong) NSString *mobile;//用来记录发送验证码的手机号码
@property (nonatomic, copy) registerBlock registBlock;
@property (nonatomic, copy) protocolBtnBlock protocolBlock;
@property (nonatomic, assign) BOOL isClickGetYanZheng;
@end
