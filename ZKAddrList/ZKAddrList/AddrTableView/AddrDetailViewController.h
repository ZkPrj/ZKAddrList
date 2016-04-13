//
//  AddrDetailViewController.h
//  ZKAddrList
//
//  Created by 陈婷 on 16/4/13.
//  Copyright © 2016年 zk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AddrDataModel.h"

@protocol AddrDetailViewControllerDelegate <NSObject>

-(void)fetchNewAddr:(AddrDataModel*)dataModel;

@end

@interface AddrDetailViewController : UIViewController
@property (nonatomic,weak) id<AddrDetailViewControllerDelegate> delegate;
-(void)setUpViewContent:(AddrDataModel*)dataModel;
@end
	