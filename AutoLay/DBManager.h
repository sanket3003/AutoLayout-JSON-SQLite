//
//  DBManager.h
//  AutoLay
//
//  Created by Sanket Bhavsar on 12/30/15.
//  Copyright (c) 2015 Sanket Bhavsar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>


@interface DBManager : NSObject

@property (nonatomic, strong) NSString *documentsDirectory;
@property (nonatomic, strong) NSString *databaseFilename;
@property (nonatomic, strong) NSMutableArray *arrResults;

-(void)runQuery:(const char *)query isQueryExecutable:(BOOL)queryExecutable;

-(instancetype)initWithDatabaseFilename:(NSString *)dbFilename;

-(void)copyDatabaseIntoDocumentsDirectory;

@property (nonatomic, strong) NSMutableArray *arrColumnNames;

@property (nonatomic) int affectedRows;

@property (nonatomic) long long lastInsertedRowID;

-(NSArray *)loadDataFromDB:(NSString *)query;

-(void)executeQuery:(NSString *)query;
@end
