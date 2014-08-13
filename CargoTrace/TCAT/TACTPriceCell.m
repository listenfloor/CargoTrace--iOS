//
//  TACTPriceCell.m
//  CargoTrace
//
//  Created by zhouzhi on 13-7-2.
//  Copyright (c) 2013年 efreight. All rights reserved.
//

#import "TACTPriceCell.h"

@implementation TACTPriceCell
@synthesize typeLabel;
@synthesize priceLabel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        UIView *view1 = [[UIView alloc] initWithFrame:CGRectMake(10, 0, 66, 52)];
        view1.backgroundColor = [CommonUtil colorWithHexString:@"#bae0f5"];
        [self addSubview:view1];
        
        UIView *view2 = [[UIView alloc] initWithFrame:CGRectMake(76, 0, 234, 52)];
        view2.backgroundColor = [UIColor whiteColor];
        [self addSubview:view2];
        
        // Initialization code
        typeLabel = [[UILabel alloc] initWithFrame:CGRectMake(40, 0, 80, 38)];
        //typeLabel.font = [UIFont systemFontOfSize:18];
        typeLabel.font = [UIFont fontWithName:@"Helvetica Bold" size:18];
        typeLabel.backgroundColor = [UIColor clearColor];
        typeLabel.textAlignment = NSTextAlignmentCenter;
        typeLabel.center = view1.center;
        typeLabel.textColor = [CommonUtil colorWithHexString:@"#348ac7"];
        [self addSubview:typeLabel];
        
        priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(90, 0, 200, 38)];
        priceLabel.font = [UIFont systemFontOfSize:14];
        priceLabel.backgroundColor = [UIColor clearColor];
        priceLabel.textAlignment = NSTextAlignmentLeft;
        priceLabel.center = CGPointMake(priceLabel.center.x, view2.center.y);
        priceLabel.textColor = [CommonUtil colorWithHexString:@"#348ac7"];
        [self addSubview:priceLabel];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
