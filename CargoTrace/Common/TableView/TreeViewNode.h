//
//  TreeViewNode.h
//  CargoTrace
//
//  Created by yanjing on 13-4-11.
//  Copyright (c) 2013年 efreight. All rights reserved.


#import <Foundation/Foundation.h>

@interface TreeViewNode : NSObject

@property (nonatomic) NSUInteger nodeLevel;
@property (nonatomic) BOOL isExpanded;
@property (nonatomic, strong) NSString * nodeLocation;
@property (nonatomic, strong) NSString * nodeDate;
@property (nonatomic, strong) NSString * nodeTime;


@property (nonatomic, strong) NSString * nodeContent;
@property (nonatomic, strong) NSString * nodeCargocode;
@property (nonatomic, strong) NSString * nodeCargoname;
@property (nonatomic, strong) NSString *nodeAirportdep;
@property (nonatomic, strong) NSString * nodeAirportland;
@property (nonatomic, strong) NSString * nodeTracecode;


@property (nonatomic, strong) NSMutableArray *nodeChildren;
@property (nonatomic, assign) int sectionIndex;
@property (nonatomic, assign) int rowIndex;
@property (nonatomic, assign) BOOL isAlarm;
@property (nonatomic, assign) BOOL isFirstTrace;

@property (nonatomic, assign) BOOL sort;
@property (nonatomic, assign) int kind;

@end
