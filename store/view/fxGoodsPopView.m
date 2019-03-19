//
//  fxGoodsPopView.m
//  Distribution
//
//  Created by hchl on 2018/7/31.
//  Copyright © 2018年 hchl. All rights reserved.
//

#import "fxGoodsPopView.h"
#import "goodsPopHeadTableViewCell.h"
#import "goodsPopSpecificationTableViewCell.h"
#import "goodsPopCountTableViewCell.h"
@implementation fxGoodsPopView
static NSString *PopHead = @"PopHead";
static NSString *PopSpecification = @"PopSpecification";
static NSString *PopGoodsCount = @"PopGoodsCount";
- (fxGoodsPopView *)initWithCatetory:(NSArray *)array model:(shoppingCartModel *)model height:(CGFloat)height title:(NSString *)title superView:(UIView *)superView isShowSign:(BOOL)isShowSign signText:(NSString *)signText{
    self = [super initWithFrame:CGRectMake(0, 0, kScreenWidth, height)];
    if (self) {
        self.superView = superView;
        self.title = title;
        self.model = model;
        self.backgroundColor = [UIColor whiteColor];
        self.layer.borderWidth = 1;
        self.layer.borderColor = [UIColor colorWithWhite:0 alpha:0.05].CGColor;
        self.cellOneheight = 120;
        self.specification = model.standardProperty;
        self.goodsPrice = model.goodsPrice;
        if ([title isEqualToString:@"立即开团"]) {
            self.goodsPrice = model.groupPrice;
        }else if ([title isEqualToString:@"立即参团"]){
            self.goodsPrice = model.groupingPrice;
        }
        self.isShowSign = isShowSign;
        self.signText = signText;
        if (![Utils isBlankString:model.standardProperty]) {
            self.goodsPrice = model.standardPrice;
        }
        
        if ([Utils isBlankString:model.sizeStr]) {
            self.specification = @"";
        }
        self.goodsCount = @"1";
        if (array != nil && array.count != 0) {
            self.specificationArray = array;
            [self calculateHeightWithHeight:height];
        } else {
            self.cellOneheight = 10;
        }
        
        
        UILabel *signLabel = [[UILabel alloc] init];
        signLabel.text = @"";
        signLabel.textAlignment = NSTextAlignmentCenter;
        signLabel.frame = CGRectMake(0, 0, kScreenWidth, 25);
        signLabel.font = [UIFont systemFontOfSize:15];
        [self addSubview:signLabel];
        
        UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 25, kScreenWidth, 0.5)];
        lineView.backgroundColor = RGBA(200, 200, 200, 1);
        [self addSubview:lineView];
        
        self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 4, kScreenWidth, height-4-50)];
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self addSubview:self.tableView];
        self.tableView.tableFooterView = [UIView new];
        [self.tableView registerNib:[UINib nibWithNibName:@"goodsPopHeadTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:PopHead];
        [self.tableView registerClass:[goodsPopSpecificationTableViewCell class] forCellReuseIdentifier:PopSpecification];
        [self.tableView registerClass:[goodsPopCountTableViewCell class] forCellReuseIdentifier:PopGoodsCount];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        
        if ([title isEqualToString:@"加入购物车和立即购买"]) {
            UIButton *addBut = [UIButton buttonWithType:UIButtonTypeCustom];
            addBut.frame = CGRectMake(0, height - 50, kScreenWidth/2.0+0.5, 50);
            [self addSubview:addBut];
            addBut.titleLabel.font = sysFont;
            [addBut addTarget:self action:@selector(addToCartClick:) forControlEvents:UIControlEventTouchUpInside];
            [addBut setTitle:@"加入购物车" forState:UIControlStateNormal];
            [addBut setBackgroundColor:RGB(51, 51, 51)];
            
            UIButton *buyBut = [UIButton buttonWithType:UIButtonTypeCustom];
            buyBut.frame = CGRectMake(kScreenWidth/2.0-0.5, height - 50, kScreenWidth/2.0+0.5, 50);
            [self addSubview:buyBut];
            buyBut.titleLabel.font = sysFont;
            [buyBut addTarget:self action:@selector(ToBuyClick:) forControlEvents:UIControlEventTouchUpInside];
            [buyBut setTitle:@"立即购买" forState:UIControlStateNormal];
            [buyBut setBackgroundImage:[UIImage imageNamed:@"settlement_btn_bg"] forState:UIControlStateNormal];
        } else {
            
            UIButton *buyBut = [UIButton buttonWithType:UIButtonTypeCustom];
            buyBut.frame = CGRectMake(-1, height - 50, kScreenWidth+1, 50);
            [self addSubview:buyBut];
            buyBut.titleLabel.font = sysFont;
            [buyBut addTarget:self action:@selector(ToBuyClick:) forControlEvents:UIControlEventTouchUpInside];
            [buyBut setTitle:title forState:UIControlStateNormal];
            [buyBut setBackgroundImage:[UIImage imageNamed:@"settlement_btn_bg"] forState:UIControlStateNormal];
        }
        
        
        
        _bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
        _bgView.backgroundColor = RGBA(10, 10, 10, 0.5);
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapToHid)];
        [_bgView addGestureRecognizer:tap];
    }
    return self;
}
- (void)calculateHeightWithHeight:(CGFloat)height {
    UIView *bgview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, height)];
    bgview.hidden = YES;
    [self addSubview:bgview];
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 10, kScreenWidth-10, 17)];
    titleLabel.text = @"商品规格";
    titleLabel.font = [UIFont systemFontOfSize:15];
    [bgview addSubview:titleLabel];
    
    if (self.specificationArray.count) {
        float butX = 15;
        float butY = CGRectGetMaxY(titleLabel.frame)+15;
        for(int i = 0; i < self.specificationArray.count; i++){
            GoodsCategoryModel *model = self.specificationArray[i];
            NSString *sizeStr = model.title;
            //宽度自适应
            NSDictionary *fontDict = @{NSFontAttributeName:[UIFont systemFontOfSize:13]};
            CGRect frame_W = [sizeStr boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:fontDict context:nil];
            
            if (butX+frame_W.size.width+20>kScreenWidth-15) {
                
                butX = 15;
                
                butY += 40;
            }
            
            UIButton *but = [[UIButton alloc]initWithFrame:CGRectMake(butX, butY, frame_W.size.width+20, 28)];
            [but setTitle:sizeStr forState:UIControlStateNormal];
            but.tag = i+1;
            
            [but setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
            [but setTitleColor:[UIColor darkTextColor] forState:UIControlStateNormal];
            but.titleLabel.font = [UIFont systemFontOfSize:13];
            but.layer.cornerRadius = 14;
            but.layer.borderColor = [UIColor lightGrayColor].CGColor;
            but.layer.borderWidth = 1;
            [bgview addSubview:but];
            butX = CGRectGetMaxX(but.frame)+10;
            if (i == self.specificationArray.count - 1) {
                CGFloat height = CGRectGetMaxY(but.frame)+10;
                self.cellOneheight = height;
                [self.tableView reloadData];
                [bgview removeFromSuperview];
            }
        }
    }
}
- (void)tapToHid {
    self.model.goodsStandardId = @"";
    self.model.standardProperty = @"";
    if (![Utils isBlankString:self.model.goodsStandardId]) {
        if (self.tapBlankBlock) {
            self.tapBlankBlock(self.model);
        }
    } else {
        _isPopBlock();
        if (self.addToCartBlcok != nil) {
            self.addToCartBlcok(nil);
        }
    }
    self.bgView.hidden = YES;
    [UIView animateWithDuration:0.2 animations:^{
        self.frame = CGRectMake(0, kScreenHeight, kScreenWidth, 300);
    }completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 1) {
        return self.cellOneheight;
    } else if (indexPath.row == 0) {
        if (self.isShowSign) {
            return 130;
        }
        return 120;
    }
    return 50;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        goodsPopHeadTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:PopHead forIndexPath:indexPath];
        NSString *goodsImage = [imageHost stringByAppendingString:self.model.goodsPreview];
        [cell.headImage sd_setImageWithURL:[NSURL URLWithString:goodsImage] placeholderImage:[UIImage imageNamed:@"goods"]];

        cell.priceLb.text = [NSString stringWithFormat:@"¥%.2f",[self.goodsPrice doubleValue]];
        cell.repertoryLb.text = [NSString stringWithFormat:@"库存：%@件",self.model.stock];
        if (![Utils isBlankString:self.signText]) {
            cell.signLb.text = self.signText;
        }else {
            cell.signLb.text = @" ";
        }
        return cell;
    } else if (indexPath.row == 1) {
        goodsPopSpecificationTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:PopSpecification forIndexPath:indexPath];
        if (self.model.goodsStandardId) {
            cell.selectID = self.model.goodsStandardId;
            
        }
        
        cell.buttonArray = self.specificationArray;
        
        cell.specificationBlock = ^(GoodsCategoryModel *model) {
            if (model) {
                if ([self.title isEqualToString:@"立即开团"]) {
                    self.goodsPrice = model.openPrice;
                    self.model.standardPrice = model.openPrice;
                    if ([model.groupStaRebatePrice doubleValue] > 0) {
                        self.signText = [NSString stringWithFormat:@"全部订单完成后，赚¥%.2f到可提现金额",[model.groupStaRebatePrice doubleValue]];
                    }else {
                        self.signText = @"";
                    }
                }else if ([self.title isEqualToString:@"立即参团"]) {
                    self.goodsPrice = model.joinPrice;
                    self.model.standardPrice = model.joinPrice;
                }else {
                    self.goodsPrice = model.standardPrice;
                    self.model.standardPrice = model.standardPrice;
                    if ([self.title isEqualToString:@"加入购物车和立即购买"] && self.isShowSign) {
                        if ([model.vipStaRebatePrice doubleValue] > 0) {
                            self.signText = [NSString stringWithFormat:@"会员立减：¥%.2f",[model.vipStaRebatePrice doubleValue]];
                        }else {
                            self.signText = @"";
                        }
                    }
                    
                }
                self.model.goodsStandardId = model.no;
                self.model.standardProperty = model.title;
                self.specification = model.title;
            } else {
                self.model.goodsStandardId = @"";
                self.model.standardProperty = @"";
                self.specification = @"";
                if ([self.title isEqualToString:@"立即开团"]) {
                    self.goodsPrice = self.model.groupPrice;
                }else if ([self.title isEqualToString:@"立即参团"]) {
                    self.goodsPrice = self.model.groupingPrice;
                }else {
                    self.goodsPrice = self.model.goodsPrice;
                }
                self.model.standardPrice = @"";
            }
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
            [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        };
        return cell;
    } else {
        goodsPopCountTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:PopGoodsCount forIndexPath:indexPath];
        __block goodsPopCountTableViewCell *weakCell = cell;
        
        cell.numAddBlock =^(){
//            if ([self.title isEqualToString:@"立即开团"] || [self.title isEqualToString:@"立即参团"]) {
//                [MBProgressHUD showToastText:@"已达到限购数量" toView:self];
//                return ;
//            }else {
//
//            }
            if ([Utils isBlankString:self.model.limitCount]) {
                if ([self.goodsCount integerValue] < [self.model.stock integerValue]) {
                    NSInteger count = [weakCell.numberLabel.text integerValue];
                    count++;
                    NSString *numStr = [NSString stringWithFormat:@"%ld",(long)count];
                    weakCell.numberLabel.text = numStr;
                    self.goodsCount = numStr;
                }else {
                    [MBProgressHUD showToastText:@"已达到限购数量"];
                }
            } else {
                if ([self.goodsCount integerValue] < [self.model.limitCount integerValue]) {
                    NSInteger count = [weakCell.numberLabel.text integerValue];
                    count++;
                    NSString *numStr = [NSString stringWithFormat:@"%ld",(long)count];
                    weakCell.numberLabel.text = numStr;
                    self.goodsCount = numStr;
                }else {
                    [MBProgressHUD showToastText:@"已达到限购数量"];
                }
            }
        };
        
        cell.numCutBlock =^(){

            NSInteger count = [weakCell.numberLabel.text integerValue];
            count--;
            if(count <= 0){
                return ;
            }
            NSString *numStr = [NSString stringWithFormat:@"%ld",(long)count];
            weakCell.numberLabel.text = numStr;
            self.goodsCount = numStr;
        };
        return cell;
    }


}
- (void)addToCartClick:(UIButton *)sender {
    if ([self.goodsCount integerValue] > [self.model.stock integerValue]) {
        [MBProgressHUD showToastText:@"选购数量不能大于库存" toView:self];
        return ;
    }
    if (self.specificationArray.count) {
        if (![Utils isBlankString:self.model.goodsStandardId]) {
            _isPopBlock();
            self.bgView.hidden = YES;
            [UIView animateWithDuration:0.2 animations:^{
                self.frame = CGRectMake(0, kScreenHeight, kScreenWidth, 300);
            }completion:^(BOOL finished) {
                [self removeFromSuperview];
            }];
            if (self.addToCartBlcok != nil) {
                self.model.count = self.goodsCount;
                self.addToCartBlcok(self.model);
            }
        } else {
            [MBProgressHUD showToastText:@"请选择型号参数"];
        }
    } else {
        self.model.goodsStandardId = @"0";
        _isPopBlock();
        self.bgView.hidden = YES;
        [UIView animateWithDuration:0.2 animations:^{
            self.frame = CGRectMake(0, kScreenHeight, kScreenWidth, 300);
        }completion:^(BOOL finished) {
            [self removeFromSuperview];
        }];
        if (self.addToCartBlcok != nil) {
            self.model.count = self.goodsCount;
            self.addToCartBlcok(self.model);
        }
    }
    
    
}
- (void)ToBuyClick:(UIButton *)sender {
    if ([self.goodsCount integerValue] > [self.model.stock integerValue]) {
        [MBProgressHUD showToastText:@"选购数量不能大于库存" toView:self];
        return ;
    }
    if (self.specificationArray.count) {
        if (![Utils isBlankString:self.model.goodsStandardId]) {
            _isPopBlock();
            self.bgView.hidden = YES;
            [UIView animateWithDuration:0.2 animations:^{
                self.frame = CGRectMake(0, kScreenHeight, kScreenWidth, 300);
            }completion:^(BOOL finished) {
                [self removeFromSuperview];
            }];
            if (self.buyBlock != nil) {
                self.model.goodsCount = self.goodsCount;
                self.buyBlock(self.model);
            }
        } else {
            [MBProgressHUD showToastText:@"请选择型号参数"];
        }
    } else {
        self.model.goodsStandardId = @"0";
        _isPopBlock();
        self.bgView.hidden = YES;
        [UIView animateWithDuration:0.2 animations:^{
            self.frame = CGRectMake(0, kScreenHeight, kScreenWidth, 300);
        }completion:^(BOOL finished) {
            [self removeFromSuperview];
        }];
        if (self.buyBlock != nil) {
            self.model.goodsCount = self.goodsCount;
            self.buyBlock(self.model);
        }
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
