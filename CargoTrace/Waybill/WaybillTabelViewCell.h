//
//  WaybillTabelViewCell.h
//  CargoTrace
//
//  Created by yanjing on 13-4-15.
//  Copyright (c) 2013年 efreight. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WaybillTabelViewCell;

typedef enum {
	WaybillTabelViewCellDirectionRight = 0,
	WaybillTabelViewCellDirectionLeft,
	WaybillTabelViewCellDirectionBoth,
	WaybillTabelViewCellDirectionNone,
} WaybillTabelViewCellDirection;

@protocol WaybillTabelViewCellDelegate <NSObject>

@optional
- (BOOL)cellShouldReveal:(WaybillTabelViewCell *)cell;
- (void)cellDidBeginPan:(WaybillTabelViewCell *)cell;
- (void)cellDidReveal:(WaybillTabelViewCell *)cell;
- (void)cellDidPad:(WaybillTabelViewCell *)cell Direction:(NSInteger)direction;
@end

@interface WaybillTabelViewCell : UITableViewCell

@property(nonatomic,strong) IBOutlet UILabel * bigLetter;
@property(nonatomic,strong) IBOutlet UILabel * simpleState;
@property(nonatomic,strong) IBOutlet UILabel * detailState;
@property(nonatomic,strong) IBOutlet UILabel * detailNumber;
@property(nonatomic,strong) IBOutlet UILabel * detailAirpostInfo;
@property(nonatomic,strong) IBOutlet UILabel * time;
@property(nonatomic,strong) IBOutlet UIImageView *nanImage;
@property(nonatomic,strong) UIView *colorView;
@property(nonatomic,strong) UIView *backView;
@property(nonatomic,strong) UIView *leftView;
@property(nonatomic,strong) UIImageView *leftImageView;
@property(nonatomic,strong) UIImageView *rightImageView;
@property(nonatomic,strong) IBOutlet UIImageView *arrowImageView;
@property (nonatomic, assign, getter = isRevealing) BOOL revealing;
@property (nonatomic, assign) id <WaybillTabelViewCellDelegate> delegate;
@property (nonatomic, assign) WaybillTabelViewCellDirection direction;
@property (nonatomic, assign) BOOL shouldBounce;
@property CGFloat pixelsToReveal;
@property NSInteger location;

- (void)laySubviews;

@end
