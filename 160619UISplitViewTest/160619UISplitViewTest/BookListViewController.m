//
//  BookListViewController.m
//  160619UISplitViewTest
//
//  Created by 刘意 on 16/6/23.
//  Copyright © 2016年 刘意. All rights reserved.
//

#import "BookListViewController.h"
#import "AppDelegate.h"

@interface BookListViewController ()

@end

@implementation BookListViewController{
    AppDelegate *_appDelegate;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //获取应用程序委托
    _appDelegate = [UIApplication sharedApplication].delegate;
    //当该窗口出现时清除选择状态
    self.clearsSelectionOnViewWillAppear = NO;
    //设置该控制安琪作为浮动窗口显示时的大小
    self.preferredContentSize = CGSizeMake(320, _appDelegate.books.count * 45);
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _appDelegate.books.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellId = @"CellId";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellId];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellId];
        
    }
    cell.textLabel.text = [_appDelegate.books objectAtIndex:[indexPath row]];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //控制detailViewController控制器显示用户选中的图书
    self.detailViewController.detailItem = _appDelegate.books[indexPath.row];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
