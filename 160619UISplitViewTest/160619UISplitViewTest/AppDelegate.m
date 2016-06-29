//
//  AppDelegate.m
//  160619UISplitViewTest
//
//  Created by 刘意 on 16/6/19.
//  Copyright © 2016年 刘意. All rights reserved.
//

#import "AppDelegate.h"
#import "MasterViewController.h"

@implementation AppDelegate

-(BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.books = [NSMutableArray arrayWithObjects:@"1"
                  , @"2"
                  , @"3"
                  , @"4"
                  , @"5"
                  , @"6"
                  , @"7"
                  , @"8"
                  ,nil];
    self.bookCovers = @{
                        @"1": @"IMG_0872.png",
                        @"2": @"IMG_0873.png",
                        @"3": @"IMG_0875.png",
                        @"4": @"IMG_1009.png" ,
                        @"5": @"IMG_1020.png",
                        @"6": @"IMG_1049.png",
                        @"7": @"IMG_1054.png",
                        @"8": @"IMG_1062.png",
                        };

    //创建窗口主程序
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    //创建MasterViewController控制器---左侧导航栏
    MasterViewController *masterController = [[MasterViewController alloc]initWithStyle:UITableViewStyleGrouped];
    //使用UINavigationController包装MasterViewController
    //作用是让MasterViewController上面显示一个导航条
    UINavigationController *masterNavigationController = [[UINavigationController alloc]initWithRootViewController:masterController];
    //创建DetailViewController控制器---右边详细信息
    DetailViewController *detailController = [[DetailViewController alloc]init];
    //使用UINavigationController包装DetailViewController
    //作用：让DetailViewController上面显示一个导航条
    UINavigationController *detailNavigationController = [[UINavigationController alloc]initWithRootViewController:detailController];
    //将DetailViewController设置成MasterViewController的一个属性
    masterController.detailViewController = detailController;
    //创造一个UISplitViewController控制器
    UISplitViewController *splitViewController = [[UISplitViewController alloc]init];
    //为UISplitViewController设置delegate对象
    splitViewController.delegate = detailController;
    //设置UISplitViewController所管理的左右两个UIViewController    
    splitViewController.viewControllers = @[masterNavigationController,detailNavigationController];
    //为window设置根控制器
    self.window.rootViewController = splitViewController;
    [self.window makeKeyAndVisible];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
