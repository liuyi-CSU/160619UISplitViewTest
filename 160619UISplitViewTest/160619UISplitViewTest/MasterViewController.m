//
//  MasterViewController.m
//  160619UISplitViewTest
//
//  Created by 刘意 on 16/6/23.
//  Copyright © 2016年 刘意. All rights reserved.
//

#import "MasterViewController.h"
#import "AppDelegate.h"

@interface MasterViewController ()

@end

@implementation MasterViewController{
    AppDelegate *_appDelegate;
}

-(void)awakeFromNib
{
    // Uncomment the following line to preserve selection between presentations.
     self.clearsSelectionOnViewWillAppear = NO;
    
    //设置该浮动窗口内容的大小
    self.preferredContentSize = CGSizeMake(320.0, 600.0);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //获取应用程序委托
    _appDelegate = [UIApplication sharedApplication].delegate;
    //创建“编辑”导航按钮
    UIBarButtonItem *editButton = [[UIBarButtonItem alloc]initWithTitle:@"编辑" style:UIBarButtonItemStylePlain target:self action:@selector(toggleEdit)];
    //为导航条的左边添加一个“编辑”导航按钮
    self.navigationItem.leftBarButtonItem = editButton;
    //创建“添加”导航按钮
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc]initWithTitle:@"添加" style:UIBarButtonItemStylePlain target:self action:@selector(insertNewObject:)];
    //为导航条的左边添加一个“添加”导航按钮
    self.navigationItem.rightBarButtonItem = addButton;
    //让该tableView初始选中第一个section的第一行
    [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0] animated:YES scrollPosition:UITableViewScrollPositionBottom];
}

//该事件处理方法用于添加一本新图书
-(void)insertNewObject:(id)sender
{
    //向_appDelegat的books集合中添加一个对象
    [_appDelegate.books insertObject:@"新图书" atIndex:0];
    //以第一个分区、第一行创建NSIndexPath
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    //插入一行
    [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    
}

//该事件处理方法用于切换该表格编辑状态
-(void)toggleEdit
{
    //切换编辑状态
    [self.tableView setEditing:!self.tableView.editing animated:YES];
    if (self.tableView.editing) {
        [self.navigationItem.leftBarButtonItem setTitle:@"完成"];
    }
    else
    {
        [self.navigationItem.leftBarButtonItem setTitle:@"编辑"];
    }
}

//UITableViewDataSource的方法，该方法的返回值控制指定分区包含多少个表格行
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _appDelegate.books.count;
}

//UITableViewDataSource方法，该方法的返回值作为指定NSIndexPath对应的表格行
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellId = @"CellId";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellId];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellId];
    }
    cell.textLabel.text = _appDelegate.books[indexPath.row];
    cell.showsReorderControl = YES;
    return cell;
}

//UITableViewDataSource的方法，该方法的返回值决定NSIndexPath对应的表格行是否可编辑
-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

//UITableViewDataSouce的方法，删除、添加完成都回调该方法
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    //如果执行的是删除操作
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [_appDelegate.books removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
    else if (editingStyle == UITableViewCellEditingStyleInsert)
    {
        
    }
}

//UITableViewDataSource的方法，该方法的返回值控制指定表格行是否可移动
-(BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

//UITablViewDataSource的方法，移动表格行后激发的方法
-(void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath
{
    NSInteger sourceRowNo = sourceIndexPath.row;
    NSInteger destRowNo = destinationIndexPath.row;
    //获取将要移动的数据
    id targetObj = _appDelegate.books[sourceRowNo];
    //从底层将要移动的数据
    [_appDelegate.books removeObjectAtIndex:sourceRowNo];
    //将移动的数据项插入到指定位置
    [_appDelegate.books insertObject:targetObj atIndex:destRowNo];
}

//UITableViewDelegate的方法，该方法的返回值控制指定单元格的编辑风格
-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}

//UITableViewDelegate的方法，当用户选中某个表格行时激发该方法
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *book = _appDelegate.books[indexPath.row];
    //修改detailViewController的detailItem属性
    self.detailViewController.detailItem = book;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:; forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
