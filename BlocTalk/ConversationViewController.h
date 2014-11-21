//
//  ConversationViewController.h
//  BlocTalk
//
//  Created by Murphy on 10/15/14.
//  Copyright (c) 2014 Murphy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ConversationViewController : UIViewController <UITextFieldDelegate>

@property (strong, nonatomic) NSString *personName;
@property (weak, nonatomic) IBOutlet UITextField *txtMessage;
@property (weak, nonatomic) IBOutlet UITextView *tvChat;

-(IBAction)sendMessage:(id)sender;
-(IBAction)cancelMessage:(id)sender;

-(void)sendMyMessage;
-(void)saveConversationStateToDefaults;

@end
