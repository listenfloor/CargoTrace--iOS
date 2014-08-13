//
//  TreeViewNodeCell.h
//  CargoTrace
//
//  Created by yanjing on 13-4-11.
//  Copyright (c) 2013年 efreight. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TreeViewNode.h"

@interface TreeViewNodeCell : UITableViewCell<UIGestureRecognizerDelegate>

@property (strong, nonatomic) IBOutlet UILabel *cellLabel;
@property (strong, nonatomic) IBOutlet UILabel *vbarLabel;
@property (strong, nonatomic) IBOutlet UIButton *cellButton;
@property (strong, nonatomic) IBOutlet UIButton *bgButton;
@property (strong, strong) TreeViewNode *treeNode;
@property (nonatomic) BOOL isExpanded;
@property (strong, nonatomic) UITapGestureRecognizer *tapGesture;

@property (nonatomic,strong) IBOutlet UILabel *timeLabel;
@property (nonatomic,strong) IBOutlet UILabel *locationLabel;
@property (nonatomic,strong)IBOutlet UILabel *bgLabel;

- (IBAction)expand:(id)sender;
- (void)setTheButtonBackgroundImage:(UIImage *)backgroundImage;

@end
