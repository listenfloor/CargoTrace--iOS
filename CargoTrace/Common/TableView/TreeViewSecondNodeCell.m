//
//  TreeViewSecondNodeCell.m
//  CargoTrace
//
//  Created by yanjing on 13-4-11.
//  Copyright (c) 2013年 efreight. All rights reserved.
//

#import "TreeViewSecondNodeCell.h"

@implementation TreeViewSecondNodeCell

@synthesize vbarLabel = _vbarLabel;
@synthesize treeNode = _treeNode;
@synthesize isExpanded = _isExpanded;
@synthesize cargoCodeLabel = _cargoCodeLabel;
@synthesize cargoNameLabel = _cargoNameLabel;
@synthesize contentLabel = _contentLabel;
@synthesize time = _time;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
        self.contentLabel = [[UILabel alloc] init];
        self.contentLabel.backgroundColor = [UIColor clearColor];
        [self.contentLabel setFont:[UIFont systemFontOfSize:14]];
        self.contentLabel.textColor = [CommonUtil colorWithHexString:@"#888888"];
        self.cargoNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 72, 24)];
        self.cargoNameLabel.backgroundColor = [UIColor clearColor];
        self.cargoNameLabel.textAlignment = NSTextAlignmentCenter;
        [self.cargoNameLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:12]];
        self.cargoCodeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 72, 30)];
        self.cargoCodeLabel.backgroundColor = [UIColor clearColor];
        self.cargoCodeLabel.textAlignment = NSTextAlignmentCenter;
        [self.cargoCodeLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:24]];
        self.time = [[UILabel alloc] init];
        self.time.backgroundColor = [UIColor clearColor];
        [self.time setFont:[UIFont fontWithName:@"Helvetica-Bold" size:14]];
        [self addSubview:self.contentLabel];
        [self addSubview:self.time];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setData:(NSIndexPath *)indexPath
{
    CGFloat dep_landX = 20.0;
    CGFloat dep_landX_normal = 67.0;
    CGFloat dep_landY = 15.0;
    UIFont *cellFont = [UIFont systemFontOfSize:14];
    
    if (self.treeNode.nodeDate == nil || [self.treeNode.nodeDate isEqualToString:@""])
    {
        if (self.treeNode.isFirstTrace || self.treeNode.isAlarm)
        {
            CGFloat contentWidth = 285.0;
            CGSize constraintSize = CGSizeMake(contentWidth, MAXFLOAT);
            self.contentLabel.text = self.treeNode.nodeContent;
            CGSize everyLineHeight = [self.contentLabel.text sizeWithFont:cellFont];
            CGSize labelSize = [self.contentLabel.text sizeWithFont:cellFont constrainedToSize:constraintSize lineBreakMode:NSLineBreakByWordWrapping];
            
            self.contentLabel.frame = CGRectMake(dep_landX + 5, dep_landY, contentWidth, labelSize.height);
            self.contentLabel.numberOfLines = ceil(labelSize.height/everyLineHeight.height);
        }
        else
        {
            CGFloat contentWidth = 290.0;
            CGSize constraintSize = CGSizeMake(contentWidth, MAXFLOAT);
            self.contentLabel.text = self.treeNode.nodeContent;
            CGSize everyLineHeight = [self.contentLabel.text sizeWithFont:cellFont];
            CGSize labelSize = [self.contentLabel.text sizeWithFont:cellFont constrainedToSize:constraintSize lineBreakMode:NSLineBreakByWordWrapping];
            
            self.contentLabel.frame = CGRectMake(dep_landX, dep_landY, contentWidth, labelSize.height);
            self.contentLabel.numberOfLines = ceil(labelSize.height/everyLineHeight.height);
        }
        
        self.frame = CGRectMake(0, 0, 320, self.contentLabel.frame.origin.y + self.contentLabel.frame.size.height + dep_landY);
        self.contentView.frame = CGRectMake(0, 0, 320, self.contentLabel.frame.origin.y + self.contentLabel.frame.size.height + dep_landY);
        if (!self.treeNode.isAlarm && self.frame.size.height < 75)
        {
            self.frame = CGRectMake(0, 0, 320, 75);
            self.contentView.frame = CGRectMake(0, 0, 320, 75);
        }
    }
    else
    {
        NSArray *mouthArray = [NSArray arrayWithObjects:@"JAN", @"FEB", @"MAR", @"APR", @"MAY", @"JUN", @"JUL", @"AUG", @"SEP", @"OCT", @"NOV", @"DEC", nil];
        int mouth = [[self.treeNode.nodeDate substringToIndex:2] intValue];
        NSString *strMouth = [mouthArray objectAtIndex:mouth - 1];
        NSString *strDay = [[self.treeNode.nodeDate substringFromIndex:3] substringToIndex:2];
        
        if (self.treeNode.nodeTime == nil || [self.treeNode.nodeTime isEqualToString:@""])
        {
            CGFloat contentWidth = 225.0;
            CGSize constraintSize = CGSizeMake(contentWidth, MAXFLOAT);
            self.contentLabel.text = self.treeNode.nodeContent;
            CGSize everyLineHeight = [self.contentLabel.text sizeWithFont:cellFont];
            CGSize labelSize = [self.contentLabel.text sizeWithFont:cellFont constrainedToSize:constraintSize lineBreakMode:NSLineBreakByWordWrapping];
            
            self.contentLabel.frame = CGRectMake(dep_landX_normal, dep_landY, contentWidth, labelSize.height);
            self.contentLabel.numberOfLines = ceil(labelSize.height/everyLineHeight.height);
            
            self.frame = CGRectMake(0, 0, 320, self.contentLabel.frame.origin.y + self.contentLabel.frame.size.height + dep_landY);
            self.contentView.frame = CGRectMake(0, 0, 320, self.contentLabel.frame.origin.y + self.contentLabel.frame.size.height + dep_landY);
            if (!self.treeNode.isAlarm && self.frame.size.height < 75)
            {
                self.frame = CGRectMake(0, 0, 320, 75);
                self.contentView.frame = CGRectMake(0, 0, 320, 75);
            }
            
            UIView *dateView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
            dateView.center = CGPointMake(35, self.frame.size.height/2);
            self.cargoCodeLabel.frame = CGRectMake(0, 0, 40, 24);
            self.cargoNameLabel.frame = CGRectMake(0, 24, 40, 16);
            self.cargoCodeLabel.text = strDay;
            self.cargoNameLabel.text = strMouth;
            [dateView addSubview:self.cargoCodeLabel];
            [dateView addSubview:self.cargoNameLabel];
            [self addSubview:dateView];
        }
        else
        {
            CGFloat contentWidth = 225.0;
            CGSize constraintSize = CGSizeMake(contentWidth, MAXFLOAT);
            
            UIImageView *clock = [[UIImageView alloc] initWithFrame:CGRectMake(dep_landX_normal, dep_landY + 3, 14, 14)];
            if (self.treeNode.isFirstTrace)
            {
                clock.image = [CommonUtil CreateImage:@"e_detail_time_h" withType:@"png"];
            }
            else
            {
                clock.image = [CommonUtil CreateImage:@"e_detail_time" withType:@"png"];
            }
            [self addSubview:clock];
            
            self.time.frame = CGRectMake(dep_landX_normal + 20, dep_landY, 100, 20);
            self.time.text = self.treeNode.nodeTime;
            
            self.contentLabel.text = self.treeNode.nodeContent;
            CGSize everyLineHeight = [self.contentLabel.text sizeWithFont:cellFont];
            CGSize labelSize = [self.contentLabel.text sizeWithFont:cellFont constrainedToSize:constraintSize lineBreakMode:NSLineBreakByWordWrapping];
            
            self.contentLabel.frame = CGRectMake(dep_landX_normal, dep_landY + 25, contentWidth, labelSize.height);
            self.contentLabel.numberOfLines = ceil(labelSize.height/everyLineHeight.height);
            
            self.frame = CGRectMake(0, 0, 320, self.contentLabel.frame.origin.y + self.contentLabel.frame.size.height + dep_landY);
            self.contentView.frame = CGRectMake(0, 0, 320, self.contentLabel.frame.origin.y + self.contentLabel.frame.size.height + dep_landY);
            if (!self.treeNode.isAlarm && self.frame.size.height < 75)
            {
                self.frame = CGRectMake(0, 0, 320, 75);
                self.contentView.frame = CGRectMake(0, 0, 320, 75);
            }
            
            UIView *dateView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
            dateView.center = CGPointMake(35, self.frame.size.height/2);
            self.cargoCodeLabel.frame = CGRectMake(0, 0, 40, 24);
            self.cargoNameLabel.frame = CGRectMake(0, 24, 40, 16);
            self.cargoCodeLabel.text = strDay;
            self.cargoNameLabel.text = strMouth;
            [dateView addSubview:self.cargoCodeLabel];
            [dateView addSubview:self.cargoNameLabel];
            [self addSubview:dateView];
        }
    }
  
    if (self.treeNode.isFirstTrace)
    {
        UIView *tmpView1 = [[UIView alloc] initWithFrame:CGRectMake(10, 0, 5, self.frame.size.height)];
        tmpView1.backgroundColor = [CommonUtil colorWithHexString:@"#3584bd"];
        [self.contentView insertSubview:tmpView1 atIndex:0];
        UIView *tmpView = [[UIView alloc] initWithFrame:CGRectMake(15, 0, 295, self.frame.size.height)];
        tmpView.backgroundColor = [CommonUtil colorWithHexString:@"#55a6e0"];
        [self.contentView insertSubview:tmpView atIndex:0];
        self.contentLabel.textColor = [UIColor whiteColor];
        self.cargoNameLabel.textColor = [UIColor whiteColor];
        self.cargoCodeLabel.textColor = [UIColor whiteColor];
        self.time.textColor = [UIColor whiteColor];
    }
    else if (self.treeNode.isAlarm)
    {
        UIView *tmpView1 = [[UIView alloc] initWithFrame:CGRectMake(10, 0, 5, self.frame.size.height)];
        tmpView1.backgroundColor = [CommonUtil colorWithHexString:@"#ff6900"];
        [self.contentView insertSubview:tmpView1 atIndex:0];
        UIView *tmpView = [[UIView alloc] initWithFrame:CGRectMake(15, 0, 295, self.frame.size.height)];
        tmpView.backgroundColor = [CommonUtil colorWithHexString:@"#ff9256"];
        [self.contentView insertSubview:tmpView atIndex:0];
        self.contentLabel.textColor = [UIColor whiteColor];
        self.cargoNameLabel.textColor = [UIColor whiteColor];
        self.cargoCodeLabel.textColor = [UIColor whiteColor];
        self.time.textColor = [UIColor whiteColor];
    }
    else
    {
        UIView *tmpView = [[UIView alloc] initWithFrame:CGRectMake(10, 0, 300, self.frame.size.height)];
        tmpView.backgroundColor = [UIColor whiteColor];
        [self.contentView insertSubview:tmpView atIndex:0];
        self.cargoNameLabel.textColor = [CommonUtil colorWithHexString:@"#55a6e0"];
        self.cargoCodeLabel.textColor = [CommonUtil colorWithHexString:@"#55a6e0"];
        self.time.textColor = [CommonUtil colorWithHexString:@"#888888"];
    }
}


@end
