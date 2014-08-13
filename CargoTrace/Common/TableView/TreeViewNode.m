//
//  TreeViewNode.m
//  CargoTrace
//
//  Created by yanjing on 13-4-11.
//  Copyright (c) 2013年 efreight. All rights reserved.
//

#import "TreeViewNode.h"

@implementation TreeViewNode
@synthesize nodeChildren = _nodeChildren;
@synthesize isExpanded = isExpanded;
@synthesize nodeLocation = _nodelocation;
@synthesize nodeDate = _nodeDate;
@synthesize nodeTime  =  _nodeTime;
@synthesize nodeLevel = _nodeLevel;
@synthesize sectionIndex = _sectionIndex;
@synthesize rowIndex = _rowIndex;
@synthesize nodeAirportdep = _nodeAirportdep;
@synthesize nodeAirportland = _nodeAirportland;
@synthesize nodeCargocode = _nodeCargocode;
@synthesize nodeCargoname = _nodeCargoname;
@synthesize nodeTracecode = _nodeTracecode;
@synthesize isAlarm = _isAlarm;
@synthesize isFirstTrace = _isFirstTrace;

@synthesize sort = _sort;
@synthesize kind = _kind;
 

@end
