//
//  loginView.h
//  Distribution
//
//  Created by hchl on 2018/7/24.
//  Copyright © 2018年 hchl. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^loginBlock)(NSString *phone,NSString *pwd);
typedef void(^findPwdBtnBlock)(void);
@interface loginView : UIView<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *phoneIcon;
@property (weak, nonatomic) IBOutlet UIImageView *pwdIcon;
@property (weak, nonatomic) IBOutlet UITextField *phoneTF;
@property (weak, nonatomic) IBOutlet UITextField *pwdTF;
@property (weak, nonatomic) IBOutlet UIView *phoneLineView;
@property (weak, nonatomic) IBOutlet UIView *pwdLineView;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
@property (weak, nonatomic) IBOutlet UIButton *forgetBtn;


@property (nonatomic, copy) findPwdBtnBlock findPwdBlock;
@property (nonatomic, copy) loginBlock loginblock;
@end
