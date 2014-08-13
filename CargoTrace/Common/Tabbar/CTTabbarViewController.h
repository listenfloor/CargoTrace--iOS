//
//  CTTabbarViewController.h
//  CargoTrace
//
//  Created by yanjing on 13-4-9.
//  Copyright (c) 2013年 efreight. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CTTabbarViewController : UIViewController

@property (nonatomic,strong) IBOutlet UIView *ctTabbarView;
@property (nonatomic,strong) IBOutlet UIView *contentView;
@property (nonatomic,strong) UIViewController * contentViewController;

@property (nonatomic,strong) IBOutlet UIButton *butAll;
@property (nonatomic,strong) IBOutlet UIButton *butNormal;
@property (nonatomic,strong) IBOutlet UIButton *butHistory;


@property (nonatomic,strong) IBOutlet UILabel *messageAll;
@property (nonatomic,strong) IBOutlet UILabel *messageAlert;
@property (nonatomic,strong) IBOutlet UILabel *messageHistory;
@property (nonatomic,strong) IBOutlet UILabel *messageNomarl;
@property (nonatomic,strong) NSMutableArray * contentArray;


-(void)addChildTabs:(NSMutableArray *)childTabs;
-(void)addCurrentChildTab:(id)childTab;
-(void)addChildTab:(UIViewController *)viewController;

-(IBAction)showAll:(id)sender;
-(IBAction)showNormal:(id)sender;
-(IBAction)showHistory:(id)sender;

@end
