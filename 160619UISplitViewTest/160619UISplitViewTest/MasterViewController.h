//
//  MasterViewController.h
//  160619UISplitViewTest
//
//  Created by 刘意 on 16/6/23.
//  Copyright © 2016年 刘意. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DetailViewController.h"


@interface MasterViewController : UITableViewController

@property(nonatomic,weak)DetailViewController *detailViewController;

@end
