//
//  NoteDAO.m
//  160619UISplitViewTest
//
//  Created by 刘意 on 16/6/26.
//  Copyright © 2016年 刘意. All rights reserved.
//

#import "NoteDAO.h"

@implementation NoteDAO

static NoteDAO *sharedManager = nil;
+ (NoteDAO*)sharedManager
{
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        
        sharedManager = [[self alloc] init];
        [sharedManager createEditableCopyOfDatabaseIfNeeded];
        
        
    });
    return sharedManager;
}

-(void)createEditableCopyOfDatabaseIfNeeded
{
    NSString *writableDBPath = [self applicationDocumentsDirectoryFile];
    //转换语言
    const char *cpath = [writableDBPath UTF8String];
    
    //如果返回值为SQLITE_OK，则表示创建成功
    if (sqlite3_open(cpath, &db)!=SQLITE_OK) {
        sqlite3_close(db);
        NSAssert(NO, @"SB，你家的数据库打开失败了。");
    }else{
        char *err;
        //建表的SQL语句，如果不存在则新建表
        NSString *sql = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS Note(cdate TEXT PRIMARY KEY, content TEXT);"];
        //转换语言
        const char *cSql = [sql UTF8String];
        
        if (sqlite3_exec(db, cSql, NULL, NULL, &err)!=SQLITE_OK) {
            sqlite3_close(db);
            NSAssert(NO, @"建表失败");
        }
        sqlite3_close(db);
    }
}

- (NSString *)applicationDocumentsDirectoryFile {
    NSString *documentDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *path = [documentDirectory stringByAppendingPathComponent:DBFILE_NAME];
    
    return path;
}

//插入Note方法
-(int)create:(Note *)model
{
    NSString *path = [self applicationDocumentsDirectoryFile];
    const char *cpath = [path UTF8String];
    
    //①打开数据库
    if (sqlite3_open(cpath, &db)!=SQLITE_OK) {
        sqlite3_close(db);
        NSAssert(NO, @"你家的数据库打开失败了。");
    }
    else{
        NSString *sql = @"INSERT OR REPLACE INTO note(cdate,content) VALUES(?,?)";
        const char* cSql = [sql UTF8String];
        
        sqlite3_stmt *statement;
        
        //②预处理SQL语句过程
        if (sqlite3_prepare_v2(db, cSql, -1, &statement, NULL)==SQLITE_OK) {
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
            [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
            NSString *strDate = [dateFormatter stringFromDate:model.date];
            const char *cDate = [strDate UTF8String];
            
            const char *cContent = [model.content UTF8String];
            
            //③绑定参数开始
            sqlite3_bind_text(statement, 1, cDate, -1, NULL);
            sqlite3_bind_text(statement, 2, cContent, -1, NULL);
            
            //④执行插入
            if (sqlite3_step(statement)!=SQLITE_DONE) {
                NSAssert(NO, @"插入数据失败");
            }
        }
        //⑤释放资源
        sqlite3_finalize(statement);
        sqlite3_close(db);
    }
    return 0;
}

//删除Note方法
-(int)remove:(Note *)model
{
    NSString *path = [self applicationDocumentsDirectoryFile];
    const char *cpath = [path UTF8String];
    if (sqlite3_open(cpath, &db)!=SQLITE_OK) {
        sqlite3_close(db);
        NSAssert(NO, @"数据库打开失败。");
    }
    else
    {
        NSString *sql = @"DELETE from note where cdate = ?";
        const char *cSql = [sql UTF8String];
        
        sqlite3_stmt *statement;
        
        //预处理过程
        if (sqlite3_prepare_v2(db, cSql, -1, &statement, NULL)==SQLITE_OK) {
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
            [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
            NSString *strDate = [dateFormatter stringFromDate:model.date];
            const char *cDate = [strDate UTF8String];
            
            //绑定参数开始
            sqlite3_bind_text(statement, 1, cDate, -1, NULL);
            //执行
            if (sqlite3_step(statement)!=SQLITE_DONE) {
                NSAssert(NO, @"删除数据失败");
            }
        }
        sqlite3_finalize(statement);
        sqlite3_close(db);
    }
    return 0;
}

//修改Note方法
-(int)modify:(Note *)model
{
    NSString *path = [self applicationDocumentsDirectoryFile];
    const char *cpath = [path UTF8String];
    
    if (sqlite3_open(cpath, &db)!=SQLITE_OK) {
        sqlite3_close(db);
        NSAssert(NO, @"数据库打开失败");
        
    }
    else
    {
        NSString *sql = @"UPDATE note set content =? where cdate =?";
        const char *cSql = [sql UTF8String];
        
        sqlite3_stmt *statement;
        
        if (sqlite3_prepare_v2(db, cSql, -1, &statement, NULL)==SQLITE_OK) {
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
            [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
            NSString *strDate = [dateFormatter stringFromDate:model.date];
            const char *cDate = [strDate UTF8String];
            const char *cContent = [model.content UTF8String];
            
            //绑定参数开始
            sqlite3_bind_text(statement, 1, cContent, -1, NULL);
            sqlite3_bind_text(statement, 2, cDate, -1, NULL);
            //执行插入
            if (sqlite3_step(statement)!=SQLITE_DONE) {
                NSAssert(NO, @"修改数据失败");
            }
        }
        sqlite3_finalize(statement);
        sqlite3_close(db);
    }
    return 0;
}

//查询所有数据方法
-(NSMutableArray*)findAll
{
    NSMutableArray *listData = [[NSMutableArray alloc]init];
    
    NSString *path = [self applicationDocumentsDirectoryFile];
    const char *cpath = [path UTF8String];
    
    if (sqlite3_open(cpath, &db)!=SQLITE_OK) {
        sqlite3_close(db);
        NSAssert(NO, @"报告老板,您的数据库打开失败");
    }
    else
    {
        NSString *sql = @"SELECT cdate, content FROM Note";
        const char *cSql = [sql UTF8String];
        
        sqlite3_stmt *statement;
        //预处理过程
        if (sqlite3_prepare_v2(db, cSql, -1, &statement, NULL)==SQLITE_OK) {
            NSDateFormatter *dateForematter = [[NSDateFormatter alloc]init];
            [dateForematter setDateFormat:@" yyyy-MM-dd HH:mm:ss"];
            
            //执行
            //如果有数据返回SQLITE_ROW
            while (sqlite3_step(statement)==SQLITE_ROW) {
                char *bufDate = (char *)sqlite3_column_text(statement, 0);
                NSString *strDate = [[NSString alloc]initWithUTF8String:bufDate];NSDate *date = [dateForematter dateFromString:strDate];
                
                char *bufContent = (char *)sqlite3_column_text(statement, 1);
                NSString *strContent = [[NSString alloc]initWithUTF8String:bufContent];
                
                Note *note = [[Note alloc]initWithDate:date cont:strContent];
                
                [listData addObject:note];
            }
        }
        sqlite3_finalize(statement);
        sqlite3_close(db);
    }
    return listData;
}

//按主键的查询数据方法
-(Note*)findById:(Note *)model
{
    NSString *path = [self applicationDocumentsDirectoryFile];
    const char *cpath = [path UTF8String];
    if (sqlite3_open(cpath, &db)!=SQLITE_OK) {
        sqlite3_close(db);
        NSAssert(NO, @"数据库打开失败了。。。");
    }
    else{
        NSString *sql = @"SELECT cdate,content FROM Note where cdate =?";
        const char *cSql = [sql UTF8String];
        
        sqlite3_stmt *statement;
        //预处理过程
        if (sqlite3_prepare_v2(db, cSql, -1, &statement, NULL)==SQLITE_OK) {
            //准备参数
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
            [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
            NSString *strDate = [dateFormatter stringFromDate:model.date];
            const char *cDate = [strDate UTF8String];
            
            //绑定参数开始
            sqlite3_bind_text(statement, 1, cDate, -1, NULL);
            
            //执行
            if (sqlite3_step(statement) == SQLITE_ROW) {
                
                char *bufDate = (char *) sqlite3_column_text(statement, 0);
                NSString *strDate = [[NSString alloc] initWithUTF8String: bufDate];
                NSDate *date = [dateFormatter dateFromString:strDate];
                
                char *bufContent = (char *) sqlite3_column_text(statement, 1);
                NSString * strContent = [[NSString alloc] initWithUTF8String: bufContent];
                
                Note* note = [[Note alloc] initWithDate:date cont:strContent];
                
                sqlite3_finalize(statement);
                sqlite3_close(db);
                
                return note;
            }

        }
        sqlite3_finalize(statement);
        sqlite3_close(db);
    }
    return nil;
}

@end
