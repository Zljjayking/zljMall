//
//  searchHistoryFootView.m
//  Distribution
//
//  Created by hchl on 2018/8/2.
//  Copyright © 2018年 hchl. All rights reserved.
//

#import "searchHistoryFootView.h"

@implementation searchHistoryFootView

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    self = [[[NSBundle mainBundle] loadNibNamed:@"searchHistoryFootView" owner:self options:nil] lastObject];
    if (self) {
        self.frame = frame;
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
