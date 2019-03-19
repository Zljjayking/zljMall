//
//  addressModel.m
//  Distribution
//
//  Created by hchl on 2018/8/6.
//  Copyright © 2018年 hchl. All rights reserved.
//

#import "addressModel.h"

@implementation addressModel
+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"ID":@"id",
             };
}
- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.ID forKey:@"ID"];
    [aCoder encodeObject:self.userId forKey:@"userId"];
    [aCoder encodeObject:self.pro forKey:@"pro"];
    [aCoder encodeObject:self.city forKey:@"city"];
    [aCoder encodeObject:self.area forKey:@"area"];
    [aCoder encodeObject:self.des forKey:@"des"];
    [aCoder encodeObject:self.def forKey:@"def"];
    [aCoder encodeObject:self.receivePhone forKey:@"receivePhone"];
    [aCoder encodeObject:self.receivePerson forKey:@"receivePerson"];
}
- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self) {
        self.ID = [aDecoder decodeObjectForKey:@"ID"];
        self.userId = [aDecoder decodeObjectForKey:@"userId"];
        self.pro = [aDecoder decodeObjectForKey:@"pro"];
        self.city = [aDecoder decodeObjectForKey:@"city"];
        self.area = [aDecoder decodeObjectForKey:@"area"];
        self.des = [aDecoder decodeObjectForKey:@"des"];
        self.def = [aDecoder decodeObjectForKey:@"def"];
        self.receivePhone = [aDecoder decodeObjectForKey:@"receivePhone"];
        self.receivePerson = [aDecoder decodeObjectForKey:@"receivePerson"];
        
    }
    return self;
}

@end
