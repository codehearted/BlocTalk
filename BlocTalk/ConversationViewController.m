//
//  ConversationViewController.m
//  BlocTalk
//
//  Created by Murphy on 10/15/14.
//  Copyright (c) 2014 Murphy. All rights reserved.
//

#import "ConversationViewController.h"

@interface ConversationViewController ()
@property (strong, nonatomic) IBOutlet UITextField *textTestField;

@end

@implementation ConversationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = self.personName;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    UIBarButtonItem *archiveButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemOrganize target:self action:nil];
    self.navigationItem.rightBarButtonItem = archiveButton;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
