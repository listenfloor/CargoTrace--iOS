//
//  TreeViewNodeCell.m
//  CargoTrace
//
//  Created by yanjing on 13-4-11.
//  Copyright (c) 2013年 efreight. All rights reserved.
//

#import "TreeViewNodeCell.h"
#import "CommonUtil.h"
@implementation TreeViewNodeCell

@synthesize cellLabel = _cellLabel;
@synthesize vbarLabel = _vbarLabel;
@synthesize cellButton = _cellButton;
@synthesize bgButton = _bgButton;
@synthesize treeNode = _treeNode;
@synthesize isExpanded = _isExpanded;
@synthesize timeLabel = _timeLabel;
@synthesize tapGesture = _tapGesture;
@synthesize bgLabel = _bgLabel;
@synthesize locationLabel = _locationLabel;


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
      
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
     // Configure the view for the selected state
}

- (void)drawRect:(CGRect)rect
{
    CGRect cellFrame = self.cellLabel.frame;
    CGRect buttonFrame = self.cellButton.frame;
    
//    int indentation = self.treeNode.nodeLevel * 25;
    int indentation = self.treeNode.nodeLevel*10;
    cellFrame.origin.x = buttonFrame.size.width + indentation + 5;
    buttonFrame.origin.x = 2 + indentation;
    
    self.cellLabel.frame = cellFrame;
    self.cellButton.frame = buttonFrame;

   // [CommonUtil setButtonRound:self.cellButton cornerRadius:17 borderWidth:2];
    self.backgroundColor = [UIColor colorWithRed:236/255.f green:236/255.f blue:236/255.f alpha:1];
//    self.backgroundView =[[[UIImageView alloc] initWithImage:[UIImage    imageNamed:@"detailcellsetion.png"]]autorelease];
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(expand:)];
     [self.bgLabel setUserInteractionEnabled:YES];
     [self.timeLabel setUserInteractionEnabled:YES];
     [self.locationLabel setUserInteractionEnabled:YES];
     [self.bgLabel addGestureRecognizer:tapGesture];
     [self.timeLabel addGestureRecognizer:tapGesture];
     [self.locationLabel addGestureRecognizer:tapGesture];
    
   }

- (void)setTheButtonBackgroundImage:(UIImage *)backgroundImage
{
  [self.cellButton setBackgroundImage:backgroundImage forState:UIControlStateNormal];
}

- (IBAction)expand:(id)sender
{
    self.treeNode.isExpanded = !self.treeNode.isExpanded;
    [self setSelected:NO];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"TreeNodeButtonClicked" object:self];
}

@end
