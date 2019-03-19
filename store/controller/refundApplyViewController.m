//
//  refundApplyViewController.m
//  Distribution
//
//  Created by hchl on 2018/11/15.
//  Copyright © 2018年 hchl. All rights reserved.
//

#import "refundApplyViewController.h"
#import "orderGoodsTableViewCell.h"
#import "refundReasonTableViewCell.h"
#import "refundMoneyTableViewCell.h"
#import "refundInstructionTableViewCell.h"
#import "refundUploadTableViewCell.h"

#import "refundDetailViewController.h"

#import "popUpView.h"

#import "refundApplyModel.h"

#import "goodsOrderDetailViewController.h"
@interface refundApplyViewController ()<UITableViewDelegate,UITableViewDataSource,UIActionSheetDelegate,UINavigationControllerDelegate, UIImagePickerControllerDelegate,LDImagePickerDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, assign) BOOL isUnreceived;//是否没收到货yes.没有收到  no.已经收到
@property (nonatomic, strong) popUpView *goodsStatePopView;
@property (nonatomic, assign) NSInteger selectState;
@property (nonatomic, strong) popUpView *reasonPopView;
@property (nonatomic, assign) NSInteger selectReason;
@property (nonatomic, strong) NSDictionary *selectReasonDic;
@property (nonatomic, strong) NSDictionary *selectStateDic;
@property (nonatomic, strong) NSString *LogisticsCost;
@property (nonatomic, strong) NSString *returnMoney;
@property (nonatomic, strong) NSString *refundInstructions;//退款说明
@property (nonatomic, strong) NSString *realReturnMoney;//实际退款金额
@property (nonatomic, strong) NSString *goodsState;//货物状态
@property (nonatomic, assign) BOOL isSelectState;//是否选择了货物状态
@property (nonatomic, assign) NSInteger selectTag;//点击的照片按钮tag
@property (nonatomic, strong) NSString *imageOne;
@property (nonatomic, strong) NSString *imageTwo;
@property (nonatomic, strong) NSString *imageThree;
@property (nonatomic, strong) refundApplyModel *applyModel;
@end

@implementation refundApplyViewController
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-(isIphoneX?89:50)) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = tableViewBgColor;
        //        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.tableFooterView = [UIView new];
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
        [_tableView registerNib:[UINib nibWithNibName:@"orderGoodsTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"orderGoodsTableViewCell"];
        [_tableView registerNib:[UINib nibWithNibName:@"refundReasonTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"refundReasonTableViewCell"];
        [_tableView registerNib:[UINib nibWithNibName:@"refundMoneyTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"refundMoneyTableViewCell"];
        [_tableView registerNib:[UINib nibWithNibName:@"refundInstructionTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"refundInstructionTableViewCell"];
        [_tableView registerNib:[UINib nibWithNibName:@"refundUploadTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"refundUploadTableViewCell"];
        
    }
    return _tableView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.isWhiteNavi = YES;
    self.title = @"申请退款";
    self.view.backgroundColor = RGB(241, 243, 246);
    
    
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.naviBarView];
    self.navigationItem.leftBarButtonItem = self.backItem;
    [self setupBottomView];
    
    self.isSelectState = NO;
    self.applyModel = [refundApplyModel new];
    [self requestReasonWithOrderDetailId:self.model.order_detail_id returnType:@"0"];
    self.isUnreceived = NO;
    if (self.type == 2) {
        
        [self setGoodsStatePopView];
        
    }else {
        self.applyModel.goodsState = @"0";
    }
    
    if (self.fromWhere == 2) {
        [self requestApplicationDetail];
    }
}
- (void)setGoodsStatePopView {
    self.selectState = 1;
    NSMutableDictionary *dic = @{@"signImage":@"",@"title":@"请选择货物状态",@"isSelect":@"0",@"isImage":@"0"}.mutableCopy;
    NSMutableDictionary *dic1 = @{@"signImage":@"zhifubao_iconn",@"title":@"未收到货",@"isSelect":@"1",@"isImage":@"0"}.mutableCopy;
    NSMutableDictionary *dic2 = @{@"signImage":@"weixin_iconn",@"title":@"已收到货",@"isSelect":@"0",@"isImage":@"0"}.mutableCopy;
    
    NSArray *popDataArr = @[dic,dic1,dic2];
    CGFloat hight = (popDataArr.count-1)*44+30+73;
    if ((popDataArr.count-1)*44+30+73 >= (kScreenHeight-naviHeight)*0.7) {
        hight = (kScreenHeight-naviHeight)*0.7;
    }
    CGRect rect = CGRectMake(0, kScreenHeight, kScreenWidth, hight);
    self.goodsStatePopView = [[popUpView alloc] initWithFrame:rect dataSource:popDataArr];
    
    self.goodsStatePopView.frame = rect;
    self.goodsStatePopView.bgView.hidden = YES;
    [self.goodsStatePopView.closeBtn setTitle:@"确定" forState:UIControlStateNormal];
    [self.goodsStatePopView.closeBtn addTarget:self action:@selector(sureBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.goodsStatePopView.bgView];
    [self.view addSubview:self.goodsStatePopView];
    
    WEAKSELF
    self.goodsStatePopView.hideBlock = ^{
        [UIView animateWithDuration:0.2 animations:^{
            weakSelf.goodsStatePopView.frame = CGRectMake(0, kScreenHeight, kScreenWidth, weakSelf.goodsStatePopView.height);
        } completion:^(BOOL finished) {
            weakSelf.goodsStatePopView.bgView.hidden = YES;
        }];
    };
    self.goodsStatePopView.closeBlock = ^{
        [UIView animateWithDuration:0.2 animations:^{
            weakSelf.goodsStatePopView.frame = CGRectMake(0, kScreenHeight, kScreenWidth, weakSelf.goodsStatePopView.height);
        } completion:^(BOOL finished) {
            weakSelf.goodsStatePopView.bgView.hidden = YES;
        }];
        
        weakSelf.isSelectState = YES;
        if (weakSelf.selectState == 1) {
            [weakSelf requestReasonWithOrderDetailId:weakSelf.model.order_detail_id returnType:@"1"];
            weakSelf.isUnreceived = YES;
            weakSelf.selectStateDic = @{@"state":@"未收到货",@"stateCode":@"1"};
        }else {
            [weakSelf requestReasonWithOrderDetailId:weakSelf.model.order_detail_id returnType:@"2"];
            weakSelf.isUnreceived = NO;
            weakSelf.selectStateDic = @{@"state":@"已收到货",@"stateCode":@"2"};
        }
        
        weakSelf.selectReasonDic = nil;
        
        [weakSelf.tableView reloadData];
        
    };
    self.goodsStatePopView.chooseblock = ^(NSInteger index) {
        weakSelf.selectState = index;
        
        
        //        [UIView animateWithDuration:0.2 animations:^{
        //            weakSelf.popView.frame = CGRectMake(0, kScreenHeight, kScreenWidth, weakSelf.popView.height);
        //        } completion:^(BOOL finished) {
        //            weakSelf.popView.bgView.hidden = YES;
        //            [weakSelf.tableView reloadData];
        //        }];
    };
}
- (void)requestReasonWithOrderDetailId:(NSString *)orderDetailId returnType:(NSString *)returnType {
    self.goodsState = returnType;
    self.applyModel.goodsState = returnType;
    [[ZLJNetWorkManager defaultManager] sendRequestMethod:HTTPMethodPOST isLogin:NO isJsonRequest:NO serverUrl:requestHost apiPath:refundReasonUrl parameters:@{@"orderDetailId":orderDetailId,@"returnType":returnType} progress:^(NSProgress * _Nullable progress) {
        
    } success:^(BOOL isSuccess, id  _Nullable responseObject) {
        NSDictionary *data = [NSDictionary changeType:responseObject];
        NSString *code = data[@"code"];
        NSString *msg = data[@"message"];
        if ([code isEqualToString:@"200"]) {
            
            NSArray *refundReasonArr = data[@"data"][@"refundReason"];
            self.LogisticsCost = data[@"data"][@"LogisticsCost"];
            self.returnMoney = data[@"data"][@"returnMoney"];
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:2];
            [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
            if (self.type == 1) {
                [self setReasonPopViewWithReasonArr:refundReasonArr];
            }else {
                if (self.isSelectState) {
                    [self setReasonPopViewWithReasonArr:refundReasonArr];
                }
            }
            
        }else {
            [MBProgressHUD showError:msg toView:self.view];
        }
    } failure:^(NSString * _Nullable errorMessage) {
        [MBProgressHUD showError:errorMessage toView:self.view];
    }];
}
- (void)setReasonPopViewWithReasonArr:(NSArray *)refundReasonArr {
    self.selectReason = 1;
    NSMutableDictionary *dic = @{@"signImage":@"",@"title":@"请选择退款原因",@"isSelect":@"0",@"isImage":@"0",@"kindCode":@"0",@"describe":@"无"}.mutableCopy;
    NSMutableArray *popDataArr = @[].mutableCopy;
    [popDataArr addObject:dic];
    for ( int i=0 ;i<refundReasonArr.count;i++) {
        NSDictionary *reasonDis = refundReasonArr[i];
        NSMutableDictionary *dic;
        if (i == 0) {
            dic = @{@"signImage":@"zhifubao_iconn",@"title":reasonDis[@"describe"],@"isSelect":@"1",@"isImage":@"0",@"kindCode":reasonDis[@"kindCode"],@"describe":reasonDis[@"describe"]}.mutableCopy;
            
        }else {
            dic = @{@"signImage":@"zhifubao_iconn",@"title":reasonDis[@"describe"],@"isSelect":@"0",@"isImage":@"0",@"kindCode":reasonDis[@"kindCode"],@"describe":reasonDis[@"describe"]}.mutableCopy;
        }
        
        [popDataArr addObject:dic];
    }
    
    CGFloat hight = (popDataArr.count-1)*44+30+73;
    if ((popDataArr.count-1)*44+30+73 >= (kScreenHeight-naviHeight)*0.7) {
        hight = (kScreenHeight-naviHeight)*0.7;
    }
    CGRect rect = CGRectMake(0, kScreenHeight, kScreenWidth, hight);
//    if ((popDataArr.count-1)*44 >= (kScreenHeight - naviHeight) * 0.7) {
//        self.reasonPopView.frame = CGRectMake(0, kScreenHeight, kScreenWidth, 400+30+73);
//    }
    self.reasonPopView = [[popUpView alloc] initWithFrame:rect dataSource:popDataArr];
    self.reasonPopView.frame = rect;
    
    self.reasonPopView.bgView.hidden = YES;
    [self.reasonPopView.closeBtn setTitle:@"确定" forState:UIControlStateNormal];
    [self.reasonPopView.closeBtn addTarget:self action:@selector(sureBtnClick) forControlEvents:UIControlEventTouchUpInside];

    
    [self.view addSubview:self.reasonPopView.bgView];
    [self.view addSubview:self.reasonPopView];
    
    WEAKSELF
    self.reasonPopView.hideBlock = ^{
        [UIView animateWithDuration:0.2 animations:^{
            weakSelf.reasonPopView.frame = CGRectMake(0, kScreenHeight, kScreenWidth, weakSelf.reasonPopView.height);
        } completion:^(BOOL finished) {
            weakSelf.reasonPopView.bgView.hidden = YES;
        }];
    };
    self.reasonPopView.closeBlock = ^{
        [UIView animateWithDuration:0.2 animations:^{
            weakSelf.reasonPopView.frame = CGRectMake(0, kScreenHeight, kScreenWidth, weakSelf.reasonPopView.height);
        } completion:^(BOOL finished) {
            weakSelf.reasonPopView.bgView.hidden = YES;
        }];
        
        NSMutableDictionary *dic = popDataArr[weakSelf.selectReason];
        weakSelf.selectReasonDic = @{@"reason":dic[@"title"],@"reasonCode":dic[@"kindCode"]};
//        self.applyModel.refundCause =
        [weakSelf.tableView reloadData];
    };
    self.reasonPopView.chooseblock = ^(NSInteger index) {
        weakSelf.selectReason = index;
        
    };
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0 || section == 3) {
        return 1;
    }
    if (section == 1) {
        if (self.type == 1) {
            return 1;
        }
    }
    return 2;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        orderGoodsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"orderGoodsTableViewCell" forIndexPath:indexPath];
        cell.refundBtn.hidden = YES;
        cell.ordermodel = self.model;
        cell.refundStateLb.hidden = YES;
        return cell;
    }else if (indexPath.section == 1) {
        refundReasonTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"refundReasonTableViewCell" forIndexPath:indexPath];
        if (self.type == 2) {
            if (indexPath.row == 1) {
                cell.titleLb.text = @"退款原因：";
                cell.contentLb.text = @"请选择";
                if (![Utils isBlankString:self.selectReasonDic[@"reason"]]) {
                    cell.contentLb.text = self.selectReasonDic[@"reason"];
                }
            }else {
                cell.titleLb.text = @"货物状态：";
                cell.contentLb.text = @"请选择";
                if (![Utils isBlankString:self.selectStateDic[@"state"]]) {
                    cell.contentLb.text = self.selectStateDic[@"state"];
                }
                
            }
        } else {
            cell.titleLb.text = @"退款原因：";
            cell.contentLb.text = @"请选择";
            if (![Utils isBlankString:self.selectReasonDic[@"reason"]]) {
                cell.contentLb.text = self.selectReasonDic[@"reason"];
            }
            
        }
        return cell;
    }else if (indexPath.section == 3) {
        refundUploadTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"refundUploadTableViewCell" forIndexPath:indexPath];
        cell.ImageClickBlock = ^(NSInteger index) {
            self.selectTag = index;
            [self ImageBtnClick];
        };
        return cell;
    } else {
        if (indexPath.row == 0) {
            refundMoneyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"refundMoneyTableViewCell" forIndexPath:indexPath];
            cell.signLb.text = [NSString stringWithFormat:@"最多¥%.2f，含发货邮费¥%.2f",[self.returnMoney doubleValue],[self.LogisticsCost doubleValue]];
            cell.contentTf.text = [NSString stringWithFormat:@"%.2f",[self.returnMoney doubleValue]];
            if (self.isUnreceived) {
                cell.contentTf.enabled = NO;
            }else {
                cell.contentTf.enabled = YES;
            }
            if (self.type == 1) {
                cell.contentTf.enabled = NO;
            }
            
            cell.contentTf.tag = 100;
            return cell;
        }else {
            refundInstructionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"refundInstructionTableViewCell" forIndexPath:indexPath];
            cell.contentTv.tag = 200;
            if (![Utils isBlankString:self.applyModel.refundInstructions]) {
                cell.contentTv.text = self.applyModel.refundInstructions;
            }
            if (cell.contentTv.text.length) {
                cell.placeHolderLb.hidden = YES;
            }else {
                cell.placeHolderLb.hidden = NO;
            }
            return cell;
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 86;
    }else if (indexPath.section == 1){
        return 44;
    }else if (indexPath.section == 3){
        return 89+99*KAdaptiveRateWidth;
    }else {
        if (indexPath.row == 0) {
            return 74;
        }else {
            return 85;
        }
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 0.01;
    }
    return 10;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 10)];
    view.backgroundColor = FXBGColor;
    return view;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return nil;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UITextField *tf = [tableView viewWithTag:100];
    UITextView *tv = [tableView viewWithTag:200];
    [tf endEditing:YES];
    [tv endEditing:YES];
    if (self.type == 1) {
        if (indexPath.section == 1) {
            [UIView animateWithDuration:0.2 animations:^{
                self.reasonPopView.bgView.hidden = NO;
                self.reasonPopView.frame = CGRectMake(0, kScreenHeight - self.reasonPopView.height, kScreenWidth, self.reasonPopView.height);
            } completion:^(BOOL finished) {
                
            }];
        }
    }else {
        if (indexPath.section == 1) {
            if (indexPath.row == 0) {
                [UIView animateWithDuration:0.2 animations:^{
                    self.goodsStatePopView.bgView.hidden = NO;
                    self.goodsStatePopView.frame = CGRectMake(0, kScreenHeight - self.goodsStatePopView.height, kScreenWidth, self.goodsStatePopView.height);
                } completion:^(BOOL finished) {
                    
                }];
            }else {
                [UIView animateWithDuration:0.2 animations:^{
                    self.reasonPopView.bgView.hidden = NO;
                    self.reasonPopView.frame = CGRectMake(0, kScreenHeight - self.reasonPopView.height, kScreenWidth, self.reasonPopView.height);
                } completion:^(BOOL finished) {
                    
                }];
            }
            
        }else if (indexPath.section == 2){
            
        }
    }
    
}
- (void)setupBottomView {
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, kScreenHeight-(isIphoneX?89:50), kScreenWidth, 50)];
    [self.view addSubview:bottomView];
    bottomView.backgroundColor = myWhite;
    
    UIButton *tijiao = [UIButton buttonWithType:UIButtonTypeCustom];
    [tijiao setTitle:@"提交" forState:UIControlStateNormal];
    tijiao.frame = CGRectMake(30, 7.5, kScreenWidth-60, 35);
    tijiao.layer.masksToBounds = YES;
    tijiao.layer.cornerRadius = 17.5;
    tijiao.backgroundColor = myBlueBg;
    [bottomView addSubview:tijiao];
    [tijiao addTarget:self action:@selector(submitClick) forControlEvents:UIControlEventTouchUpInside];
    
}



- (void)sureBtnClick {
    
}


#pragma mark === 上传图片

- (void)ImageBtnClick {
    UIActionSheet *action = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"从相册选取", nil];
    [action showInView:self.navigationController.view];
}
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        //拍照
        //        [self takePhone];
        LDImagePicker *imagePicker = [LDImagePicker sharedInstance];
        imagePicker.delegate = self;
        [imagePicker showImagePickerWithType:buttonIndex InViewController:self Scale:0.75];
        
    } else if (buttonIndex == 1) {
        //从相册选取
        //        [self takeLocalPhoto];
        LDImagePicker *imagePicker = [LDImagePicker sharedInstance];
        imagePicker.delegate = self;
        [imagePicker showOriginalImagePickerWithType:buttonIndex InViewController:self];
        
    }
}
//打开照相机拍照
-(void)takePhone{
    
    UIImagePickerController *picker = [[UIImagePickerController alloc]init];
    [picker.navigationBar setBarTintColor:myWhite];
    
    [picker.navigationBar setTranslucent:NO];
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    picker.delegate = self;
    //    picker.allowsEditing = YES;
    [self presentViewController:picker animated:YES completion:^{
        NSLog(@"打开了照相机");
    }];
}
//打开本地相册
-(void)takeLocalPhoto{
    
    UIImagePickerController *picker = [[UIImagePickerController alloc]init];
    UIFont *font = [UIFont systemFontOfSize:17];
    NSDictionary *textAttributes = @{
                                     NSFontAttributeName : font,
                                     NSForegroundColorAttributeName : RGB(51, 51, 51)
                                     };
    picker.navigationBar.titleTextAttributes = textAttributes;
    [picker.navigationBar setBarTintColor:myWhite];
    [picker.navigationBar setTranslucent:NO];
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    picker.delegate = self;
    //设置图片可被编辑
    picker.allowsEditing = YES;
    [self presentViewController:picker animated:YES completion:^{
        NSLog(@"打开了相册");
    }];
}
#pragma mark -- UIImagePickerView

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    UIImage * image = [info objectForKey: @"UIImagePickerControllerOriginalImage"];
    NSData *imageData = [self getDataWitdImgae:image];
    if (imageData.length>300*1024) {
        if (imageData.length>1024*1024) {//1M以及以上
            imageData=UIImageJPEGRepresentation(image, 0.1);
        }else if (imageData.length>512*1024) {//0.5M-1M
            imageData=UIImageJPEGRepresentation(image, 0.5);
        }else if (imageData.length>300*1024) {//0.25M-0.5M
            imageData=UIImageJPEGRepresentation(image, 0.9);
        }
    }
    
    [self uploadImageWithImageData:imageData image:image];
    
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePicker:(LDImagePicker *)imagePicker didFinished:(UIImage *)editedImage{
    
    NSData *imageData = [self getDataWitdImgae:editedImage];
    
    if (imageData.length>300*1024) {
        if (imageData.length>1024*1024) {//1M以及以上
            imageData=UIImageJPEGRepresentation(editedImage, 0.05);
        }else if (imageData.length>512*1024) {//0.5M-1M
            imageData=UIImageJPEGRepresentation(editedImage, 0.2);
        }else if (imageData.length>300*1024) {//0.25M-0.5M
            imageData=UIImageJPEGRepresentation(editedImage, 0.5);
        }
    }
    
    [self uploadImageWithImageData:imageData image:editedImage];

}
- (void)imagePickerDidCancel:(LDImagePicker *)imagePicker{
    
}

#pragma mark -- 图片转Data
-(NSData  *)getDataWitdImgae:(UIImage *)originalImage{
    
    NSData *baseData = UIImageJPEGRepresentation(originalImage, 0.5);
    return baseData;
    
}

- (void)uploadImageWithImageData:(NSData*)imageData image:(UIImage *)image{
    [[ZLJNetWorkManager defaultManager]sendPOSTRequestWithserverUrl:requestHost apiPath:uploadIamgeUrl parameters:@{@"fileType":@"CREDENTIALS",@"uid":self.myInfoM.ID,@"rename":@"",@"file":imageData} imageArray:@[image] targetWidth:200 progress:^(NSProgress * _Nullable progress) {
        
    } success:^(BOOL isSuccess, id  _Nullable responseObject) {
        NSDictionary *dic = responseObject;
        NSString *code = [NSString stringWithFormat:@"%@",dic[@"code"]];
        NSString *errorMsg = [NSString stringWithFormat:@"%@",dic[@"message"]];
        NSString *imageUrl = dic[@"data"];
        NSString *headImageUrl = [imageHost stringByAppendingString:imageUrl];
        
        if ([code isEqualToString:@"200"]) {
            switch (self.selectTag) {
                case 1:
                {
                    self.imageOne = imageUrl;
                    UIButton *imageOneBtn = [self.tableView viewWithTag:1];
                    [imageOneBtn sd_setBackgroundImageWithURL:[NSURL URLWithString:headImageUrl] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"refundUpload"]];
                }
                    break;
                case 2:
                {
                    self.imageTwo = imageUrl;
                    UIButton *imageTwoBtn = [self.tableView viewWithTag:2];
                    [imageTwoBtn sd_setBackgroundImageWithURL:[NSURL URLWithString:headImageUrl] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"refundUpload"]];
                }
                    break;
                case 3:
                {
                    self.imageThree = imageUrl;
                    UIButton *imageThreeBtn = [self.tableView viewWithTag:2];
                    [imageThreeBtn sd_setBackgroundImageWithURL:[NSURL URLWithString:headImageUrl] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"refundUpload"]];
                }
                    break;
                    
                default:
                    break;
            }
        } else {
            [MBProgressHUD showError:errorMsg toView:self.navigationController.view];
        }
    } failure:^(NSString * _Nullable error) {
        [MBProgressHUD showError:myRequestError toView:self.navigationController.view];
    }];
}

#pragma mark == 查看退款申请 准备修改
- (void)requestApplicationDetail {
    [[ZLJNetWorkManager defaultManager] sendRequestMethod:HTTPMethodPOST isLogin:NO isJsonRequest:NO serverUrl:requestHost apiPath:editRefundUrl parameters:@{@"returnId":self.model.returnId} progress:^(NSProgress * _Nullable progress) {
        
    } success:^(BOOL isSuccess, id  _Nullable responseObject) {
        NSDictionary *data = [NSDictionary changeType:responseObject];
        NSString *code = data[@"code"];
        NSString *msg = data[@"message"];
        if ([code integerValue] == 200) {
            self.applyModel = [refundApplyModel mj_objectWithKeyValues:data[@"data"]];
            if ([self.applyModel.goodsState isEqualToString:@"0"]) {
                self.type = 1;
                [self requestReasonWithOrderDetailId:self.model.order_detail_id returnType:@"0"];
            }else {
                self.type = 2;
                
                [self setGoodsStatePopView];
                if ([self.applyModel.goodsState isEqualToString:@"1"]) {
                    [self requestReasonWithOrderDetailId:self.model.order_detail_id returnType:@"1"];
                    self.isUnreceived = YES;
                    self.isSelectState = 1;
                    self.selectStateDic = @{@"state":@"未收到货",@"stateCode":@"1"};
                }else {
                    [self requestReasonWithOrderDetailId:self.model.order_detail_id returnType:@"2"];
                    self.isUnreceived = YES;
                    self.isSelectState = 2;
                    self.selectStateDic = @{@"state":@"已收到货",@"stateCode":@"2"};
                }
            }
            self.selectReasonDic = @{@"reason":self.model.refundCause,@"reasonCode":self.applyModel.refundCause};
            
            self.returnMoney = self.applyModel.returnMoney;
            self.LogisticsCost = self.applyModel.logisticsCost;
            
            int i=0;
            for (NSString *imageStr in self.applyModel.pictureUrl) {
                NSString *headImageUrl = [imageHost stringByAppendingString:imageStr];
                if (i==0) {
                    self.imageOne = imageStr;
                    
                    UIButton *imageOneBtn = [self.tableView viewWithTag:1];
                    [imageOneBtn sd_setBackgroundImageWithURL:[NSURL URLWithString:headImageUrl] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"refundUpload"]];
                }else if (i == 1){
                    self.imageTwo = imageStr;
                    
                    UIButton *imageOneBtn = [self.tableView viewWithTag:2];
                    [imageOneBtn sd_setBackgroundImageWithURL:[NSURL URLWithString:headImageUrl] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"refundUpload"]];
                }else {
                    self.imageThree = imageStr;
                    
                    UIButton *imageOneBtn = [self.tableView viewWithTag:3];
                    [imageOneBtn sd_setBackgroundImageWithURL:[NSURL URLWithString:headImageUrl] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"refundUpload"]];
                }
                i++;
            }
            
            [self.tableView reloadData];
        }else {
            [MBProgressHUD showError:msg toView:self.view];
        }
    } failure:^(NSString * _Nullable errorMessage) {
        [MBProgressHUD showError:errorMessage toView:self.view];
    }];
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (self.fromWhere == 1) {
        self.navigationController.swipeBackEnabled = NO;
    }
    
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if (self.fromWhere == 1) {
//        if (self.refreshBlock) {
//            self.refreshBlock();
//        }
    }
}

- (void)clickBackItemToPop {
    if (self.fromWhere == 1) {
//        NSArray *vcs = [self.navigationController viewControllers];
//        goodsOrderDetailViewController *vc = vcs[2];
//        [self.navigationController popToViewController:vc animated:YES];
        [self.navigationController popViewControllerAnimated:YES];
    }else {
        [self.navigationController popViewControllerAnimated:YES];
    }
    
    
}

#pragma mark === 提交申请事件
- (void)submitClick {
    
    if ([Utils isBlankString:self.selectReasonDic[@"reasonCode"]]) {
        [MBProgressHUD showToastText:@"请选择退款原因" toView:self.view];
        return ;
    }
    
    UITextField *tf = [self.tableView viewWithTag:100];
    UITextView *tv = [self.tableView viewWithTag:200];
    
    if ([tf.text doubleValue] > [self.returnMoney doubleValue]) {
        [MBProgressHUD showToastText:@"退款金额错误" toView:self.view];
        return ;
    }
    NSMutableDictionary *dic = @{@"orderDetailId":self.model.order_detail_id,@"userId":self.myInfoM.ID,@"refundCause":self.selectReasonDic[@"reasonCode"],@"returnMoney":tf.text,@"goodsState":self.goodsState}.mutableCopy;;
    
    if (tv.text.length) {
        [dic setObject:tv.text forKey:@"refundInstructions"];
    }
    NSMutableArray *pictureUrl = @[].mutableCopy;
    if (![Utils isBlankString:self.imageOne]) {
        [pictureUrl addObject:self.imageOne];
    }
    if (![Utils isBlankString:self.imageTwo]) {
        [pictureUrl addObject:self.imageTwo];
    }
    if (![Utils isBlankString:self.imageThree]) {
        [pictureUrl addObject:self.imageThree];
    }
    if (pictureUrl.count) {
        [dic setObject:pictureUrl forKey:@"pictureUrl"];
    }
    if (self.fromWhere == 2) {
        [dic setObject:self.applyModel.ID forKey:@"id"];
    }else if (self.fromWhere == 1){
        if (![Utils isBlankString:self.model.returnId]) {
            [dic setObject:self.model.returnId forKey:@"id"];
        }
    }
    [[ZLJNetWorkManager defaultManager] sendRequestMethod:HTTPMethodPOST isLogin:NO isJsonRequest:YES serverUrl:requestHost apiPath:submitRefundUrl parameters:dic progress:^(NSProgress * _Nullable progress) {
        
    } success:^(BOOL isSuccess, id  _Nullable responseObject) {
        /*
         applyNum = 1;
         applyTime = "2018-11-29T11:32:57.145+0000";
         dealState = 1;
         flag = 1;
         goodsState = 0;
         id = 32;
         logisticCode = "";
         logisticName = "";
         logisticNo = "";
         orderDetailId = 75;
         refundCause = 1;
         refundInstructions = "\U7684\U5566";
         refundNumber = 201811291957233625;
         remark = "";
         returnMoney = "82.40000000000001";
         tel = "";
         updateTime = "2018-11-29T11:32:57.145+0000";
         userId = 8;
         */
        
        NSDictionary *data = [NSDictionary changeType:responseObject];
        NSString *code = data[@"code"];
        NSString *msg = data[@"message"];
        if ([code isEqualToString:@"200"]) {
            [MBProgressHUD showSuccess:@"提交成功" toView:self.navigationController.view];
            NSDictionary *dataDic = data[@"data"];
            //需要重新加载我的订单列表
            [FXObjManager dc_saveUserData:@"0" forKey:BOOLLoadMyOrder];
            if (self.fromWhere == 2) {
                [self.navigationController popViewControllerAnimated:YES];
            }else {
                refundDetailViewController *detail = [refundDetailViewController new];
                detail.hidesBottomBarWhenPushed = YES;
                self.model.refundNumber = dataDic[@"refundNumber"];
                self.model.applyTime = dataDic[@"applyTime"];
                self.model.refundCause = self.selectReasonDic[@"reason"];
                self.model.returnId = dataDic[@"id"];
                self.model.returnMoney = tf.text;
                self.model.updateTime = dataDic[@"updateTime"];
                self.model.applyNum = self.model.sale_num;
                self.model.order_detail_id = dataDic[@"orderDetailId"];
                detail.model = self.model;
                detail.fromWhere = 1;
                detail.type = 1;
                detail.modifyBlock = ^(orderModel * _Nonnull model) {
                    //初始进入申请，然后直接修改
                };
                detail.refreshBlock = ^{
                    //                    [self.navigationController popViewControllerAnimated:YES];
                };
                [self.navigationController pushViewController:detail animated:YES];
            }
            
        }else {
            [MBProgressHUD showError:msg toView:self.view];
        }
    } failure:^(NSString * _Nullable errorMessage) {
        [MBProgressHUD showError:errorMessage toView:self.view];
    }];
    
    
}
@end
