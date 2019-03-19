//
//  agreementViewController.m
//  Distribution
//
//  Created by hchl on 2018/9/8.
//  Copyright © 2018年 hchl. All rights reserved.
//

#import "agreementViewController.h"
#import <WebKit/WebKit.h>
@interface agreementViewController ()
@property (strong, nonatomic) UIWebView *webView;
@end

@implementation agreementViewController
- (UIWebView *)webView
{
    if (!_webView) {
        _webView = [[UIWebView alloc] initWithFrame:CGRectZero];
        _webView.scrollView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
        _webView.scrollView.scrollIndicatorInsets = _webView.scrollView.contentInset;
    }
    return _webView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    switch (self.type) {
        case 1:
            self.title = @"注册协议";
            break;
        case 2:
            self.title = @"充值协议";
            break;
        default:
            self.title = @"购买协议";
            break;
    }
    self.webView.frame = CGRectMake(0, naviHeight, kScreenWidth, kScreenHeight-naviHeight);
    [self.view addSubview:self.webView];
    [self.view addSubview:self.naviBarView];
    NSString *htmls = [NSString stringWithFormat:@"<html> \n"
                       "<head> \n"
                       "<meta name=\"viewport\" content=\"initial-scale=1.0, maximum-scale=1.0, user-scalable=no\" /> \n"
                       "<style>img{max-width: 100%%; width:auto; height:auto!important;}</style> \n"
                       "</head> \n"
                       "<body> \n"
                       "%@ \n"
                       "</body>"
                       "</html>",self.agreementStr];
    
    [self.webView loadHTMLString:htmls baseURL:nil];
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
