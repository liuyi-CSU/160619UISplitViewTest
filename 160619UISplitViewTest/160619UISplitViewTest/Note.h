//
//  Note.h
//  160619UISplitViewTest
//
//  Created by 刘意 on 16/6/26.
//  Copyright © 2016年 刘意. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Note : NSObject

@property(nonatomic,strong)NSDate *date;
@property(nonatomic,strong)NSString *content;

-(id)initWithDate:(NSDate*)date cont:(NSString*)content;

@end
