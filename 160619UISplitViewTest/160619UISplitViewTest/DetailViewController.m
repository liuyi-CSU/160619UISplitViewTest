//
//  DetailViewController.m
//  160619UISplitViewTest
//
//  Created by 刘意 on 16/6/23.
//  Copyright © 2016年 刘意. All rights reserved.
//

#import "DetailViewController.h"
#import "AppDelegate.h"
#import "BookListViewController.h"

@interface DetailViewController ()

@property(nonatomic,strong)UILabel *bookName;
@property(nonatomic,strong)UIImageView *bookCover;

@end

@implementation DetailViewController{
    AppDelegate *_appDelegate;
    //用于记录UISplitViewController自动显示的UIPopoverController
    UIPopoverController *_masterPopoverController;
    //导航条右边的导航按钮，用于打开浮动窗口
    UIBarButtonItem *_bookButton;
    //自定义的浮动窗口
    UIPopoverController *_bookPopoverController;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    CGRect viewBounds = self.view.frame;
    
    //创建、添加显示图书书名的UILabel控件
    self.bookName = [[UILabel alloc]initWithFrame:CGRectMake(0, 80, CGRectGetWidth(viewBounds), 40)];
    self.bookName.font = [UIFont systemFontOfSize:24];
    self.bookName.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:self.bookName];
    
    //创建、添加显示图书封面的UIImageView控件
    self.bookCover = [[UIImageView alloc]initWithFrame:CGRectMake(0, self.bookName.frame.origin.y + self.bookName.frame.size.height + 20, self.view.frame.size.width, self.view.frame.size.height - (self.bookName.frame.origin.y + self.bookName.frame.size.height + 40))];
    self.bookCover.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:self.bookCover];
    
    //获取应用程序委托
    _appDelegate = [UIApplication sharedApplication].delegate;
    //更新界面
    [self configureView];
    
    //控制器右边增加一个导航按钮
    //创建UIBarButtonItem控件，作为导航右边的导航按钮
    _bookButton = [[UIBarButtonItem alloc]initWithTitle:@"选择图书" style:UIBarButtonItemStylePlain target:self action:@selector(touchBookButton)];
    
    //设置右边的导航按钮
    self.navigationItem.rightBarButtonItem = _bookButton;

}

//重新实现系统合成的setDetailItem:方法
-(void)setDetailItem:(id)newDetailItem
{
    //如果Item被更新了
    if (_detailItem!=newDetailItem) {
        _detailItem = newDetailItem;
        //更新视图
        [self configureView];
    }
    //释放_masterPopoverController控件
    if (_masterPopoverController != nil) {
        [_masterPopoverController dismissPopoverAnimated:YES];
    }
}

//使用detailItem来更新界面
-(void)configureView
{
    if (self.detailItem) {
        //使用bookName显示detailItem的内容
        self.bookName.text = self.detailItem;
        //使用bookCover显示detailItem对应的图片
        self.bookCover.image = [UIImage imageNamed:_appDelegate.bookCovers[self.detailItem]];
    }
}

//当分割视图不在固定显示左边导航栏时激发该方法
-(void)splitViewController:(UISplitViewController *)splitViewController willHideViewController:(nonnull UIViewController *)viewController withBarButtonItem:(nonnull UIBarButtonItem *)barButtonItem forPopoverController:(nonnull UIPopoverController *)popoverController
{
    //为导航按钮设置Title
    barButtonItem.title = @"显示浮动导航";
    //为导航条设置左边的按钮
    [self.navigationItem setLeftBarButtonItem:barButtonItem animated:YES];
    //保存显示出来的浮动窗口
    _masterPopoverController = popoverController;
}

//当分割视图固定显示左边导航栏时激发该方法
-(void)splitViewController:(UISplitViewController *)splitViewController willShowViewController:(nonnull UIViewController *)viewController invalidatingBarButtonItem:(nonnull UIBarButtonItem *)barButtonItem
{
    //取消导航条左边的导航按钮
    [self.navigationItem setLeftBarButtonItem:nil animated:YES];
    //将_masterPopoverController设为nil
    _masterPopoverController = nil;
}

//******右边导航按钮方法*****/
//当用户单击右边的导航按钮是激发该方法
-(void)touchBookButton
{
    if (_bookPopoverController == nil) {
        BookListViewController *bookListController = [[BookListViewController alloc]init];
        bookListController.detailViewController = self;
        //创建自定义的UIPopoverController
        _bookPopoverController = [[UIPopoverController alloc]initWithContentViewController:bookListController];
        //指定从bookButton导航按钮上弹出该浮动窗口
        [_bookPopoverController presentPopoverFromBarButtonItem:_bookButton permittedArrowDirections:UIPopoverArrowDirectionLeft animated:YES];
        
    }
    else
    {
        //释放bookPopoverController浮动窗口
        [_bookPopoverController dismissPopoverAnimated:YES];
        _bookPopoverController = nil;
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

@end
