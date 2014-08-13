//
//  TCATCityAndPortCell.m
//  CargoTrace
//
//  Created by zhouzhi on 13-7-1.
//  Copyright (c) 2013年 efreight. All rights reserved.
//

#import "TACTCityAndPortCell.h"

@implementation TACTCityAndPortCell
@synthesize portLabel;
@synthesize cityLabel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        portLabel = [[UILabel alloc] initWithFrame:CGRectMake(25, 0, 80, 40)];
        portLabel.font = [UIFont systemFontOfSize:14];
        portLabel.backgroundColor = [UIColor clearColor];
        portLabel.textAlignment = NSTextAlignmentLeft;
        portLabel.textColor = [CommonUtil colorWithHexString:@"#35aaff"];
        [self addSubview:portLabel];
        
        cityLabel = [[UILabel alloc] initWithFrame:CGRectMake(130, 0, 160, 40)];
        cityLabel.font = [UIFont systemFontOfSize:14];
        cityLabel.backgroundColor = [UIColor clearColor];
        cityLabel.textAlignment = NSTextAlignmentRight;
        cityLabel.textColor = [CommonUtil colorWithHexString:@"#35aaff"];
        [self addSubview:cityLabel];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
