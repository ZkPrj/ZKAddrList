//
//  AddrDataModel.h
//  ZKAddrList
//
//  Created by 陈婷 on 16/4/13.
//  Copyright © 2016年 zk. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AddrDataModel : NSObject<NSCoding>
@property (nonatomic,copy) NSString* name;
@property (nonatomic,copy) NSString* telphone;
@property (nonatomic,copy) NSString* detailAddr;
@property (nonatomic,copy) NSString* areaStr;
@end
