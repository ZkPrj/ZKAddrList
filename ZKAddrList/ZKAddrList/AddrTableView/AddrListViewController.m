//
//  AddrListViewController.m
//  ZKAddrList
//
//  Created by 陈婷 on 16/4/13.
//  Copyright © 2016年 zk. All rights reserved.
//

#import "AddrListViewController.h"
#import "AddrDataModel.h"
#import "AddrListTableViewCell.h"
#import "AddrListEditTableViewCell.h"
#import "AddrDetailViewController.h"
@interface AddrListViewController ()<UITableViewDelegate,UITableViewDataSource,AddrDetailViewControllerDelegate,AddrListEditTableViewCellDelegate>
@property (weak, nonatomic) IBOutlet UITableView *addrListTableView;
@property (nonatomic,strong) NSMutableArray *addrDataSrc;
@property (nonatomic) BOOL editNotSave; //如果Ture则为编辑地址，否则为新建地址
@property (nonatomic) NSInteger curEditIndex;
@end



@implementation AddrListViewController
@synthesize addrDataSrc=_addrDataSrc;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setUpSubView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//初始化视图控制器的外观以及其他相关初始配置
-(void)setUpSubView{
    //导航栏标题设置
    self.navigationItem.title = @"地址管理";
    //不让tableview留出空白
    self.automaticallyAdjustsScrollViewInsets = NO;
    //table view 设置
    self.addrListTableView.delegate = self;
    self.addrListTableView.dataSource = self;
    self.addrListTableView.tableHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 0, 0.1)];
    //数据源
    [self fetchAddrDataSrcFromDefault];
    //初始化参数
    self.editNotSave = NO;
}


-(void)saveAddrDataSrc{
    NSMutableArray* array = [[NSMutableArray alloc]init];
    NSData* data;
    for (AddrDataModel *dataModel in self.addrDataSrc) {
        data = [NSKeyedArchiver archivedDataWithRootObject:dataModel];
        [array addObject:data];
    }
    [[NSUserDefaults standardUserDefaults]setObject:[NSArray arrayWithArray:array] forKey:@"addrList"];
}

-(void)fetchAddrDataSrcFromDefault{
    self.addrDataSrc = [[NSMutableArray alloc]init];
    NSArray* array = [[NSUserDefaults standardUserDefaults]objectForKey:@"addrList"];
    for (NSData* data in array) {
        [self.addrDataSrc addObject:[NSKeyedUnarchiver unarchiveObjectWithData:data]];
    }
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - 实现tableview的两个代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    //一个是详细地址，一个是编辑cell
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell* cell = nil;
    static NSString* addrInfoStr = @"AddrListTableViewCell";
    static NSString* addrEditStr = @"AddrListEditTableViewCell";
    if (indexPath.row == 0) {
        cell = [tableView dequeueReusableCellWithIdentifier:addrInfoStr];
        if (!cell) {
            UINib *nib = [UINib nibWithNibName:addrInfoStr bundle:nil];
            [tableView registerNib:nib forCellReuseIdentifier:addrInfoStr];
            cell = [tableView dequeueReusableCellWithIdentifier:addrInfoStr];
        }
        AddrDataModel* dataModel = [_addrDataSrc objectAtIndex:indexPath.section];
        UILabel* nameLbl = [cell viewWithTag:1];
        nameLbl.text = dataModel.name;
        UILabel* telphoneLbl = [cell viewWithTag:2];
        telphoneLbl.text = dataModel.telphone;
        UILabel* detailAddrLbl = [cell viewWithTag:3];
        detailAddrLbl.text = dataModel.detailAddr;
    }else{
        cell = [tableView dequeueReusableCellWithIdentifier:addrEditStr];
        UINib *nib = [UINib nibWithNibName:addrEditStr bundle:nil];
        [tableView registerNib:nib forCellReuseIdentifier:addrEditStr];
        cell = [tableView dequeueReusableCellWithIdentifier:addrEditStr];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        UIButton* btn = [cell viewWithTag:1];
        if (indexPath.section == 0) {
            [btn setImage:[UIImage imageNamed:@"CheckBox_Selected"] forState:UIControlStateNormal];
        }else{
            [btn setImage:[UIImage imageNamed:@"CheckBox_Unselected"] forState:UIControlStateNormal];
        }
        ((AddrListEditTableViewCell*)cell).index = indexPath.section;
        ((AddrListEditTableViewCell*)cell).delegate = self;
    }
    
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _addrDataSrc.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0){
        return 70;
    }else{
        return 50;
    }
}

#pragma mark - 实现AddrEditCell的代理
-(void)onAddrDelWithIndex:(NSInteger)index{
    [self.addrDataSrc removeObjectAtIndex:index];
    [self saveAddrDataSrc];
    [self.addrListTableView reloadData];
}

-(void)onAddrEditWithIndex:(NSInteger)index{
    self.curEditIndex = index;
    self.editNotSave = YES;
    [self jumpToAddAddrPage:[self.addrDataSrc objectAtIndex:index]];
}
-(void)onSetDefaultAddrWithIndex:(NSInteger)index{
    AddrDataModel* dataModel = [self.addrDataSrc objectAtIndex:index];
    [self.addrDataSrc removeObjectAtIndex:index];
    [self.addrDataSrc insertObject:dataModel atIndex:0];
    [self saveAddrDataSrc];
    [self.addrListTableView reloadData];
}

#pragma mark - 实现addrdetail 的代理
-(void)fetchNewAddr:(AddrDataModel*)dataModel{
    //保存地址
    if (!self.editNotSave) {
        [self.addrDataSrc addObject:dataModel];
    }else{
        //编辑地址
        [self.addrDataSrc replaceObjectAtIndex:self.curEditIndex withObject:dataModel];
    }
    
    [self.addrListTableView reloadData];
    [self saveAddrDataSrc];
}

#pragma mark - 响应视图控件
- (IBAction)addNewAddr:(UIButton *)sender {
    self.editNotSave = NO;
    [self jumpToAddAddrPage:nil];
}

-(void)jumpToAddAddrPage:(AddrDataModel*)dataModel{
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    AddrDetailViewController* viewCtl = [story instantiateViewControllerWithIdentifier:@"AddrDetail"];
    viewCtl.delegate = self;
    [viewCtl setUpViewContent:dataModel];
    [self.navigationController pushViewController:viewCtl animated:true];
}


@end
