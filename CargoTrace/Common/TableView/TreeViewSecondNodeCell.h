//
//  TreeViewSecondNodeCell.h
//  CargoTrace
//
//  Created by yanjing on 13-4-11.
//  Copyright (c) 2013年 efreight. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TreeViewNode.h"

@interface TreeViewSecondNodeCell : UITableViewCell

 
@property (strong, nonatomic) IBOutlet UILabel *vbarLabel;
@property (retain, strong) TreeViewNode *treeNode;
@property (nonatomic) BOOL isExpanded;
@property (strong, nonatomic) IBOutlet UILabel *dep_land_locationLabel;
@property (strong, nonatomic) IBOutlet UILabel *contentLabel;
@property (strong, nonatomic) IBOutlet UILabel *cargoNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *cargoCodeLabel;
@property (strong, nonatomic) IBOutlet UILabel *time;

- (void)setData:(NSIndexPath *)indexPath;
@end
