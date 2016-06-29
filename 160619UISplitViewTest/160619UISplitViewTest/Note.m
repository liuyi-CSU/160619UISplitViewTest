//
//  Note.m
//  160619UISplitViewTest
//
//  Created by 刘意 on 16/6/26.
//  Copyright © 2016年 刘意. All rights reserved.
//

#import "Note.h"

@implementation Note

-(id)initWithDate:(NSDate *)date cont:(NSString *)content{
    self = [super init];
    if (self) {
        self.date = date;
        self.content = content;
    }
    return self;
}

@end
