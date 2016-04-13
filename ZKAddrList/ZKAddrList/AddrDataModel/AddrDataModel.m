//
//  AddrDataModel.m
//  ZKAddrList
//
//  Created by 陈婷 on 16/4/13.
//  Copyright © 2016年 zk. All rights reserved.
//

#import "AddrDataModel.h"

@implementation AddrDataModel

- (void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:self.name forKey:@"name"];
    [aCoder encodeObject:self.telphone forKey:@"telphone"];
    [aCoder encodeObject:self.areaStr forKey:@"areaStr"];
    [aCoder encodeObject:self.detailAddr forKey:@"detailAddr"];
}

- (nullable instancetype)initWithCoder:(NSCoder *)aDecoder{
    self = [super init];
    if (self) {
        self.name = [aDecoder decodeObjectForKey:@"name"];
        self.telphone = [aDecoder decodeObjectForKey:@"telphone"];
        self.areaStr = [aDecoder decodeObjectForKey:@"areaStr"];
        self.detailAddr = [aDecoder decodeObjectForKey:@"detailAddr"];
    }
    return self;
}

@end
