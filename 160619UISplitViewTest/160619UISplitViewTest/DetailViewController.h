//
//  DetailViewController.h
//  160619UISplitViewTest
//
//  Created by 刘意 on 16/6/23.
//  Copyright © 2016年 刘意. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController<UISplitViewControllerDelegate>

@property(nonatomic,copy)NSString *detailItem;

@end
