//
//  FOXFmdbViewController.m
//  FOXFmdb
//
//  Created by 徐惠雨 on 15/8/6.
//  Copyright (c) 2015年 XFoxer. All rights reserved.
//

#import "FOXFmdbViewController.h"
#import "COHttpManager.h"
#import "FmdbTestModel.h"
#import "SVProgressHUD.h"
#import "MJExtension.h"
#import "FmdbImageModel.h"
#import "UIImageView+WebCache.h"


@interface FOXFmdbViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) NSMutableArray *resultArray;

@property (nonatomic, weak) UITableView *tableView;

@end

@implementation FOXFmdbViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setTitle:@"FMDB测试"];
    
    [self requestDataTest];
    
    [self.view addSubview:_tableView = [self createTableView]];
    
}


- (UITableView *)createTableView
{
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStyleGrouped];
    [tableView setBackgroundColor:[UIColor clearColor]];
    [tableView setDataSource:self];
    [tableView setDelegate:self];
    [tableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
    return tableView;
}

#pragma mark - Request Test

- (void)requestDataTest
{
    NSString *requestString = [NSString stringWithFormat:@"http://58.96.188.197/api/country?access_token=qZidICGHUlsvINGJ"];
    
    [SVProgressHUD show];
    [COHttpManager httpGET:requestString params:nil success:^(id json){
        NSString *stauts = [NSString stringWithFormat:@"%@",json[@"success"]];
        if ([stauts isEqualToString:@"1"]) {
            
            NSArray *dataArr = [FmdbTestModel objectArrayWithKeyValuesArray:json[@"data"]];
            
            self.resultArray = [[NSMutableArray alloc]init];
            
            LKDBHelper *helper = [FmdbTestModel getUsingLKDBHelper];
            
            //使用事务来插入数据库
            [helper executeForTransaction:^BOOL(LKDBHelper *helper){
                
                for (FmdbTestModel *testModel in dataArr)
                {
                    BOOL isExist = [helper isExistsModel:testModel];
                    
                    if (isExist) {
                        [helper updateToDB:testModel where:nil];
                    }
                    else
                    {
                        [helper insertToDB:testModel];
                    }
                }
                

                return YES;
            }];
            
            NSMutableArray *dbArray = [FmdbTestModel searchWithWhere:nil orderBy: [NSString stringWithFormat:@"ename ASC"] offset:0 count:[dataArr count]];
            
            
            /*
             * where    查询条件 ，多个条件可以用and连接，查询条件可以是 = ，< , >
             * orderBy  排序 可以设定某个值排序  ASC 和 DESC
             * offset   跳过 几个值 查询
             * count    需要查询的数据个数
             
            NSMutableArray *oneArray = [FmdbTestModel searchWithWhere:[NSString stringWithFormat:@"name = '中国' and ename = 'China' "] orderBy:nil offset:0 count:[dataArr count]];
             
            */
            
            
            [self.resultArray addObjectsFromArray:dbArray];
            [self.tableView reloadData];
            [SVProgressHUD dismiss];
        }
            
    
    } failure:^(NSError *error){
        [SVProgressHUD dismiss];
    }];
    
}

#pragma mark - UITbaleView Delegate & DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.resultArray count];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60.0;
}


- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.00001f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.00001f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *resueIdentity = @"Reuse_Identity";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:resueIdentity];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:resueIdentity];
    }
    
    FmdbTestModel *testModel = self.resultArray[indexPath.row];
    FmdbImageModel *imageModel = testModel.image[0];
    
    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:imageModel.save_path_large]];
    [cell.textLabel setText:testModel.name];
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
