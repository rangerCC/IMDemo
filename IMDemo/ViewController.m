//
//  ViewController.m
//  IMDemo
//
//  Created by 恒阳 on 15/10/21.
//  Copyright © 2015年 ranger. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *datasource;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.title = @"气泡表格";
    
    self.datasource = [[NSMutableArray alloc] init];
    
    UIImageView *bgImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"background.jpg"]];
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds];
    self.tableView.backgroundView = bgImgView;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.showsHorizontalScrollIndicator = NO;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.view addSubview:self.tableView];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"隔壁老王" style:UIBarButtonItemStyleDone target:self action:@selector(onAddWangMessage:)];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"我" style:UIBarButtonItemStyleDone target:self action:@selector(onAddMyMessage:)];
}

#pragma mark TableView Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_datasource count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row<0 || indexPath.row>_datasource.count) {
        return 0.0;
    }
    
    UIView *view = [_datasource[indexPath.row] objectForKey:@"bubbleView"];
    return view.frame.size.height+10.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"MainCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    NSDictionary *chatInfo = [_datasource objectAtIndex:indexPath.row];
    for (UIView *view in [cell.contentView subviews]) {
        [view removeFromSuperview];
    }
    [cell addSubview:[chatInfo objectForKey:@"bubbleView"]];
    
    return cell;
}

#pragma mark - Tool
- (UIView *)getBubble:(NSString *)bubbleText fromSelf:(BOOL)fromSelf{
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectZero];
    bgView.layer.cornerRadius = 3.0;
    bgView.clipsToBounds = YES;
    
    UIImage *bubbleImage = [UIImage imageNamed:@"message_bg"];
    UIImageView *bubbleView = [[UIImageView alloc] initWithImage:[bubbleImage stretchableImageWithLeftCapWidth:6 topCapHeight:16]];
    
    UIFont *textFont = [UIFont systemFontOfSize:12.0];
    CGSize sizeText = [bubbleText sizeWithFont:textFont constrainedToSize:CGSizeMake(150.0, 1000) lineBreakMode:NSLineBreakByWordWrapping];
    
    UILabel *bubbleLabel = [[UILabel alloc] initWithFrame:CGRectMake(21.0f, 14.0f, sizeText.width+10.0f, sizeText.height+10.0f)];
    bubbleLabel.backgroundColor = [UIColor clearColor];
    bubbleLabel.font = textFont;
    bubbleLabel.numberOfLines = 0;
    bubbleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    bubbleLabel.text = bubbleText;
    bubbleLabel.textColor = [UIColor whiteColor];
    bubbleView.frame = CGRectMake(0, 0, 200.0f, sizeText.height+40.0f);
    
    if (fromSelf) {
        bgView.frame = CGRectMake(120.0f, 10.0, 200.0, sizeText.height+50.0);
    } else {
        bgView.frame = CGRectMake(0, 10.0, 200.0, sizeText.height+50.0);
    }
    
    [bgView addSubview:bubbleView];
    [bgView addSubview:bubbleLabel];
    
    return bgView;
}

- (void)onAddWangMessage:(id)sender{
    UIView *messageView = [self getBubble:@"隔壁老王:Hello World!" fromSelf:NO];
    [self.datasource addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"Hello world!", @"text", @"other", @"speaker", messageView, @"bubbleView", nil]];
    [self.tableView reloadData];
    
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:_datasource.count-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
}

- (void)onAddMyMessage:(id)sender{
    UIView *messageView = [self getBubble:@"我:Hello 你妹!" fromSelf:YES];
    [self.datasource addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"Hello world!", @"text", @"other", @"speaker", messageView, @"bubbleView", nil]];
    [self.tableView reloadData];
    
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:_datasource.count-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
}
@end
