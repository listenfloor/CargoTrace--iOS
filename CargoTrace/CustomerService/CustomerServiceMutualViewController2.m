//
//  ViewController.m
//  ChatMessageTableViewController
//
//  Created by Yongchao on 21/11/13.
//  Copyright (c) 2013 Yongchao. All rights reserved.
//

#import "CustomerServiceMutualViewController.h"




@interface CustomerServiceMutualViewController () <JSMessagesViewDelegate, JSMessagesViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (strong, nonatomic) NSMutableArray *messageArray;
@property (nonatomic,strong) UIImage *willSendImage;
@property (strong, nonatomic) NSMutableArray *timestamps;

@end

@implementation CustomerServiceMutualViewController

@synthesize messageArray;


#pragma mark - View lifecycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.delegate = self;
    self.dataSource = self;
    
    self.title = @"ChatMessage";
    
    self.messageArray = [NSMutableArray array];
    self.timestamps = [NSMutableArray array];
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.messageArray.count;
}

#pragma mark - Messages view delegate
- (void)sendPressed:(UIButton *)sender withText:(NSString *)text
{
    [self.messageArray addObject:[NSDictionary dictionaryWithObject:text forKey:@"Text"]];
    
    [self.timestamps addObject:[NSDate date]];
    
    if((self.messageArray.count - 1) % 2)
        [JSMessageSoundEffect playMessageSentSound];
    else
        [JSMessageSoundEffect playMessageReceivedSound];
    
    [self finishSend];
}

- (void)cameraPressed:(id)sender{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:picker animated:YES completion:NULL];
}

- (JSBubbleMessageType)messageTypeForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return (indexPath.row % 2) ? JSBubbleMessageTypeIncoming : JSBubbleMessageTypeOutgoing;
}

- (JSBubbleMessageStyle)messageStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return JSBubbleMessageStyleFlat;
}

- (JSBubbleMediaType)messageMediaTypeForRowAtIndexPath:(NSIndexPath *)indexPath{
    if([[self.messageArray objectAtIndex:indexPath.row] objectForKey:@"Text"]){
        return JSBubbleMediaTypeText;
    }else if ([[self.messageArray objectAtIndex:indexPath.row] objectForKey:@"Image"]){
        return JSBubbleMediaTypeImage;
    }
    
    return -1;
}

- (UIButton *)sendButton
{
    return [UIButton defaultSendButton];
}

- (JSMessagesViewTimestampPolicy)timestampPolicy
{
    /*
     JSMessagesViewTimestampPolicyAll = 0,
     JSMessagesViewTimestampPolicyAlternating,
     JSMessagesViewTimestampPolicyEveryThree,
     JSMessagesViewTimestampPolicyEveryFive,
     JSMessagesViewTimestampPolicyCustom
     */
    return JSMessagesViewTimestampPolicyAlternating;
}

- (JSMessagesViewAvatarPolicy)avatarPolicy
{
    /*
     JSMessagesViewAvatarPolicyIncomingOnly = 0,
     JSMessagesViewAvatarPolicyBoth,
     JSMessagesViewAvatarPolicyNone
     */
    return JSMessagesViewAvatarPolicyBoth;
}

- (JSAvatarStyle)avatarStyle
{
    /*
     JSAvatarStyleCircle = 0,
     JSAvatarStyleSquare,
     JSAvatarStyleNone
     */
    return JSAvatarStyleNone;
}

- (JSInputBarStyle)inputBarStyle
{
    /*
     JSInputBarStyleDefault,
     JSInputBarStyleFlat
     
     */
    return JSInputBarStyleFlat;
}

//  Optional delegate method
//  Required if using `JSMessagesViewTimestampPolicyCustom`
//
//  - (BOOL)hasTimestampForRowAtIndexPath:(NSIndexPath *)indexPath
//

#pragma mark - Messages view data source
- (NSString *)textForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if([[self.messageArray objectAtIndex:indexPath.row] objectForKey:@"Text"]){
        return [[self.messageArray objectAtIndex:indexPath.row] objectForKey:@"Text"];
    }
    return nil;
}

- (NSDate *)timestampForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [self.timestamps objectAtIndex:indexPath.row];
}

- (UIImage *)avatarImageForIncomingMessage
{
    return [UIImage imageNamed:@"demo-avatar-jobs"];
}

- (UIImage *)avatarImageForOutgoingMessage
{
    return [UIImage imageNamed:@"demo-avatar-woz"];
}

- (id)dataForRowAtIndexPath:(NSIndexPath *)indexPath{
    if([[self.messageArray objectAtIndex:indexPath.row] objectForKey:@"Image"]){
        return [[self.messageArray objectAtIndex:indexPath.row] objectForKey:@"Image"];
    }
    return nil;
    
}

#pragma UIImagePicker Delegate

#pragma mark - Image picker delegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
	NSLog(@"Chose image!  Details:  %@", info);
    
    self.willSendImage = [info objectForKey:UIImagePickerControllerEditedImage];
    [self.messageArray addObject:[NSDictionary dictionaryWithObject:self.willSendImage forKey:@"Image"]];
    [self.timestamps addObject:[NSDate date]];
    [self.tableView reloadData];
    [self scrollToBottomAnimated:YES];
    
	
    [self dismissViewControllerAnimated:YES completion:NULL];
    
}


- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:NULL];
    
}


@end


//@interface CustomerServiceMutualViewController ()
//
//@end
//
//@implementation CustomerServiceMutualViewController

//- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
//{
//    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
//    if (self) {
//        // Custom initialization
//    }
//    return self;
//}
//
//- (void)viewDidLoad
//{
//    [super viewDidLoad];
//    // Do any additional setup after loading the view from its nib.
//    self.textFieldImg.frame = CGRectMake(0, self.view.frame.size.height - self.textFieldImg.frame.size.height - 64, self.textFieldImg.frame.size.width, self.textFieldImg.frame.size.height);
//    self.tableView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - self.textFieldImg.frame.size.height);
//    self.textField.frame = CGRectMake(self.textField.frame.origin.x, self.textFieldImg.frame.origin.y + 4, self.textField.frame.size.width, self.textField.frame.size.height);
//    self.textFieldBtn.frame = CGRectMake(self.textFieldBtn.frame.origin.x, self.textFieldImg.frame.origin.y, self.textFieldBtn.frame.size.width, self.textFieldBtn.frame.size.height);
//
//    [self setNavbar];
//}
//
//- (void)didReceiveMemoryWarning
//{
//    [super didReceiveMemoryWarning];
//    // Dispose of any resources that can be recreated.
//}
//
//#pragma mark  -  导航栏 设置
//- (void)setNavbar
//{
//    self.title = self.mTitle;
//    [self.navigationController.navigationBar setBarStyle: UIBarStyleBlack];
//    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navbarbg.png"] forBarMetrics:UIBarMetricsDefault];
//
//    UIButton *rodoButton = [[UIButton alloc] initWithFrame:CGRectMake(10, 12, 30, 20)];
//    rodoButton.backgroundColor = [UIColor clearColor];
//    [rodoButton addTarget:self action:@selector(goback) forControlEvents:UIControlEventTouchUpInside];
//    [rodoButton setImage:[UIImage imageNamed:@"e_back_arrow.png"] forState: UIControlStateNormal];
//
//    //创建redo按钮
//    UIBarButtonItem *redoButtonItem = [[UIBarButtonItem alloc]initWithCustomView:rodoButton];
//    self.navigationItem.leftBarButtonItem = redoButtonItem;
//}
//
//- (void)goback
//{
//    [self.navigationController popViewControllerAnimated:YES];
//}
//
//#pragma mark  - 点击 屏幕 关闭 键盘
//- (void)backgroundTap:(id)sender
//{
//    //NSLog(@"backgroundTap");
//
//    UIView *tempview  = self.view;
//
//    // When the user presses return, take focus away from the text field so that the keyboard is dismissed.
//    NSTimeInterval animationDuration = 0.30f;
//    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
//    [UIView setAnimationDuration:animationDuration];
//
//    CGRect rect = CGRectMake(0.0f, 0.0f, tempview.frame.size.width, tempview.frame.size.height);
//    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
//    {
//        rect = CGRectMake(0.0f, 64.0f, tempview.frame.size.width, tempview.frame.size.height);
//    }
//    tempview.frame = rect;
//
//    [UIView commitAnimations];
//    [self.textField resignFirstResponder];
//}
//
//- (void)textFieldDidBeginEditing:(UITextField *)textField
//{
//    UIView *tempview  = self.view;
//
//    //NSLog(@"textFieldDidBeginEditing");
//    CGRect frame = self.textField.frame;
//    int offset = frame.origin.y - (tempview.frame.size.height - 235.0);//键盘高度216
//
//    NSTimeInterval animationDuration = 0.30f;
//    [UIView beginAnimations:@"ResizeForKeyBoard" context:nil];
//    [UIView setAnimationDuration:animationDuration];
//    float width = tempview.frame.size.width;
//    float height = tempview.frame.size.height;
//
//    if(offset > 0)
//    {
//        CGRect rect = CGRectMake(0.0f, -offset + 44, width, height);
//        tempview.frame = rect;
//    }
//
//    [UIView commitAnimations];
//}
//
//- (BOOL)textFieldShouldReturn:(UITextField *)textField
//{
//    [textField resignFirstResponder];
//
//    if (textField == self.textField)
//    {
//        [self backgroundTap:nil];
//    }
//
//    return YES;
//}
//
//#pragma mark - tabelView fuctions
//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return 44;
//}
//
//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
//{
//    return  1;
//}
//
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    return  1;
//}
//
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    static NSString *CellIdentifier = @"CustomerServiceMutualCell";
//
//    CustomerServiceMutualCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
//
//    if (cell == nil) {
//        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"CustomerServiceMutualCell" owner:self options:nil];
//        cell = [nib objectAtIndex:0];
//    }
//
//    cell.textLabel.text = @"小可:你好，请问有什么我可以帮助你的？";
//    cell.selectionStyle = UITableViewCellSelectionStyleNone;
//
//    return cell;
//
//}
//
//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//
//}
