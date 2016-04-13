//
//  AddrListEditTableViewCell.h
//  ZKAddrList
//
//  Created by 陈婷 on 16/4/13.
//  Copyright © 2016年 zk. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AddrListEditTableViewCellDelegate <NSObject>

-(void)onAddrDelWithIndex:(NSInteger)index;
-(void)onAddrEditWithIndex:(NSInteger)index;
-(void)onSetDefaultAddrWithIndex:(NSInteger)index;
@end

@interface AddrListEditTableViewCell : UITableViewCell
@property (nonatomic) NSInteger index;
@property (nonatomic,weak) id<AddrListEditTableViewCellDelegate> delegate;
@end
