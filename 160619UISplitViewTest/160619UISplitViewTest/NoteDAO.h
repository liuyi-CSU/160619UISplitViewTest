//
//  NoteDAO.h
//  160619UISplitViewTest
//
//  Created by 刘意 on 16/6/26.
//  Copyright © 2016年 刘意. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Note.h"
#import "sqlite3.h"

#define DBFILE_NAME @"NotesList.sqlite3"

@interface NoteDAO : NSObject{
    sqlite3 *db;
}

+(NoteDAO*)sharedManager;
-(NSString*)applicationDocumentsDirectoryFile;
- (void)createEditableCopyOfDatabaseIfNeeded;

//插入Note方法
-(int) create:(Note*)model;

//删除Note方法
-(int) remove:(Note*)model;

//修改Note方法
-(int) modify:(Note*)model;

//查询所有数据方法
-(NSMutableArray*) findAll;

//按照主键查询数据方法
-(Note*) findById:(Note*)model;


@end
