//
//  CTTabbarViewController.m
//  CargoTrace
//
//  Created by yanjing on 13-4-9.
//  Copyright (c) 2013年 efreight. All rights reserved.
//

#import "CTTabbarViewController.h"
#import "WaybillCTTabbarContentViewController.h"
#import "CommonUtil.h"

@interface CTTabbarViewController ()

@end

@implementation CTTabbarViewController

@synthesize ctTabbarView = _ctTabbarView;
@synthesize contentView = _contentView;
@synthesize butAll = _butAll;
@synthesize butHistory = _butHistory;
@synthesize butNormal = _butNormal;
@synthesize contentArray = _contentArray;
@synthesize contentViewController = _contentViewController;

@synthesize messageAlert = _messageAlert;
@synthesize messageAll = _messageAll;
@synthesize  messageHistory = _messageHistory;
@synthesize messageNomarl = _messageNomarl;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
//    self.view = self.ctTabbarView;
    //NSLog(@"-----%@", self.contentArray);
    

//    [self.slideLabel setBackgroundColor: [UIColor colorWithPatternImage:[UIImage  imageNamed:@"tabbarbuts.png"]]];
//    [self.slideLabel setHidden:YES];
    
    [self.butAll setBackgroundImage:[UIImage  imageNamed:@"e_home_tabbtn_h.png"] forState:UIControlStateNormal];
    [self.butHistory setBackgroundImage:[UIImage  imageNamed:@"e_home_tabbtn.png"] forState:UIControlStateNormal];
    [self.butNormal setBackgroundImage:[UIImage  imageNamed:@"e_home_tabbtn.png"] forState:UIControlStateNormal];
//   
//    [self.butNormal setImage:[UIImage  imageNamed:@"tabbarbuts.png"] forState:UIControlStateSelected];
    
    [CommonUtil setLabelRound:self.messageAll cornerRadius:0 borderWidth:0 red:20 green:137 blue:228];
    [CommonUtil setLabelRound:self.messageAlert cornerRadius:0 borderWidth:0 red:253 green:107 blue:5];
    [CommonUtil setLabelRound:self.messageNomarl cornerRadius:0 borderWidth:0 red:117 green:187 blue:66];
    [CommonUtil setLabelRound:self.messageHistory cornerRadius:0 borderWidth:0 red:123 green:123 blue:123];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)addChildTab:(UIViewController *)viewController
{
    self.contentViewController = viewController;
    self.contentView.frame = CGRectMake(0, 5, 320, self.contentView.frame.size.height - 20);
    [self.contentView addSubview:self.contentViewController.view];
    [self.contentViewController.view setFrame: CGRectMake(0, 0, 320, self.contentView.frame.size.height)];
     self.contentViewController.view.autoresizingMask = UIViewAutoresizingFlexibleHeight ;
}

- (void)addChildTabs:(NSMutableArray *)childTabs{
    
    self.contentArray = childTabs;
}

- (void)addCurrentChildTab:(id)childTab
{
    [self.contentView addSubview:((UIViewController*)[self.contentArray objectAtIndex:0]).view];
    if (IS_IPHONE_5) {
        [((UIViewController*)[self.contentArray objectAtIndex:0]).view setFrame: CGRectMake(0, 0, 320, self.contentView.frame.size.height)];
        ((UIViewController*)[self.contentArray objectAtIndex:0]).view.autoresizingMask = UIViewAutoresizingFlexibleHeight ;
        }else{
 
        [((UIViewController*)[self.contentArray objectAtIndex:0]).view setFrame: CGRectMake(0, 0, 320, self.contentView.frame.size.height)];
        ((UIViewController*)[self.contentArray objectAtIndex:0]).view.autoresizingMask = UIViewAutoresizingFlexibleHeight ;

    }
}


- (IBAction)showAll:(id)sender
{
    [MobClick event:@"点击全部分栏标签"];
    [UIView beginAnimations:nil context:nil];//动画开始
    [UIView setAnimationDuration:0.5];
     //self.slideLabel.frame = CGRectMake(0, 0, 80, 46);
    
    [self.butAll setBackgroundImage:[UIImage  imageNamed:@"e_home_tabbtn_h.png"] forState:UIControlStateNormal];
    [self.butHistory setBackgroundImage:[UIImage  imageNamed:@"e_home_tabbtn.png"] forState:UIControlStateNormal];
    [self.butNormal setBackgroundImage:[UIImage  imageNamed:@"e_home_tabbtn.png"] forState:UIControlStateNormal];
    [UIView commitAnimations];

    [self setIndext:0 and:sender];
}
 

- (IBAction)showAlert:(id)sender
{
    [MobClick event:@"点击预警分栏标签"];
    [UIView beginAnimations:nil context:nil];//动画开始
    [UIView setAnimationDuration:0.5];
    //self.slideLabel.frame = CGRectMake(80, 0, 80, 46);
    [self.butAll setBackgroundImage:[UIImage  imageNamed:@"e_home_tabbtn.png"] forState:UIControlStateNormal];
    [self.butHistory setBackgroundImage:[UIImage  imageNamed:@"e_home_tabbtn.png"] forState:UIControlStateNormal];
    [self.butNormal setBackgroundImage:[UIImage  imageNamed:@"e_home_tabbtn.png"] forState:UIControlStateNormal];
    [UIView commitAnimations];
    
    [self setIndext:1 and:sender];
}

- (IBAction)showNormal:(id)sender
{
    [MobClick event:@"点击正常分栏标签"];
    [UIView beginAnimations:nil context:nil];//动画开始
    [UIView setAnimationDuration:0.5];
 
//    self.slideLabel.frame = CGRectMake(160, 0, 80, 46);
    [self.butAll setBackgroundImage:[UIImage  imageNamed:@"e_home_tabbtn.png"] forState:UIControlStateNormal];
    [self.butHistory setBackgroundImage:[UIImage  imageNamed:@"e_home_tabbtn.png"] forState:UIControlStateNormal];
    [self.butNormal setBackgroundImage:[UIImage  imageNamed:@"e_home_tabbtn_g.png"] forState:UIControlStateNormal];
    [UIView commitAnimations];

    [self setIndext:2 and:sender];
}

- (IBAction)showHistory:(id)sender
{
    [MobClick event:@"点击历史分栏标签"];
    [UIView beginAnimations:nil context:nil];//动画开始
    [UIView setAnimationDuration:0.5];
 
    [self.butAll setBackgroundImage:[UIImage  imageNamed:@"e_home_tabbtn.png"] forState:UIControlStateNormal];
    [self.butHistory setBackgroundImage:[UIImage  imageNamed:@"e_home_tabbtn_l.png"] forState:UIControlStateNormal];
    [self.butNormal setBackgroundImage:[UIImage  imageNamed:@"e_home_tabbtn.png"] forState:UIControlStateNormal];
    
    [UIView commitAnimations];
    
    [self setIndext:3 and:sender];
}

- (void)setIndext:(NSInteger)index and:(id)sender
{
    WaybillCTTabbarContentViewController *vc = ((WaybillCTTabbarContentViewController*)[self.contentArray objectAtIndex:0]);
    vc.index = index;
    if (sender)
    {
        vc.isButtonAction = YES;
    }
    else
    {
        vc.isButtonAction = NO;
    }
    [[NSNotificationCenter defaultCenter]postNotificationName:@"tabbarindex" object:nil userInfo:nil];
}

@end
