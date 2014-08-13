//
//  CustomerServiceCell.h
//  CargoTrace
//
//  Created by zhouzhi on 13-12-12.
//  Copyright (c) 2013年 efreight. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CustomerServiceCell;

typedef enum {
	CustomerServiceCellDirectionRight = 0,
	CustomerServiceCellDirectionLeft,
	CustomerServiceCellDirectionBoth,
	CustomerServiceCellDirectionNone,
} CustomerServiceCellDirection;

@protocol CustomerServiceCellDelegate <NSObject>

@optional
- (BOOL)cellShouldReveal:(CustomerServiceCell *)cell;
- (void)cellDidBeginPan:(CustomerServiceCell *)cell;
- (void)cellDidReveal:(CustomerServiceCell *)cell;
- (void)cellDidPad:(CustomerServiceCell *)cell Direction:(NSInteger)direction;
@end

@interface CustomerServiceCell : UITableViewCell
@property(nonatomic,strong) IBOutlet UILabel *mContent;
@property(nonatomic,strong) UIView *colorView;
@property(nonatomic,strong) UIView *backView;
@property(nonatomic,strong) UIView *leftView;
@property(nonatomic,strong) UIImageView *leftImageView;
@property(nonatomic,strong) UIImageView *rightImageView;
@property (nonatomic, assign, getter = isRevealing) BOOL revealing;
@property (nonatomic, assign) id <CustomerServiceCellDelegate> delegate;
@property (nonatomic, assign) CustomerServiceCellDirection direction;
@property (nonatomic, assign) BOOL shouldBounce;
@property CGFloat pixelsToReveal;
@property NSInteger location;

- (void)laySubviews;
@end
