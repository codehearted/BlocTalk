//
//  ConversationViewController.m
//  BlocTalk
//
//  Created by Murphy on 10/15/14.
//  Copyright (c) 2014 Murphy. All rights reserved.
//

#import "ConversationViewController.h"
#import "DataSource.h"
#import "Contact.h"
#import "AppDelegate.h"
#import "ConverstationView.h"
#import "MCManager.h"

@import AddressBook;
@import MultipeerConnectivity;

@interface ConversationViewController ()

@property (strong, nonatomic) AppDelegate *appDelegate;


-(void)didReceiveDataWithNotification:(NSNotification *)notification;

@end

@implementation ConversationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSString *txtMessage = [defaults objectForKey:@"txtMessage"];
    NSString *tvChat = [defaults objectForKey:@"tvChat"];
    
    _txtMessage.text = txtMessage;
    _tvChat.text = tvChat;
    
    self.title = self.personName;
    
    _appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    _txtMessage.delegate = self;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didReceiveDataWithNotification:)
                                                 name:@"MCDidReceiveDataNotification"
                                               object:nil];
    
}

/*
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    UIBarButtonItem *archiveButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemOrganize target:self action:nil];
    self.navigationItem.rightBarButtonItem = archiveButton;
}
 */

-(void)viewWillDisappear:(BOOL)animated {
    
    [self.view endEditing:YES];
    
    [self saveConversationStateToDefaults];
    [super viewWillDisappear:animated];
    
}

-(void)saveConversationStateToDefaults {
    NSString *txtMessage = [self.txtMessage text];
    NSString *tvChat = [self.tvChat text];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:txtMessage forKey:@"txtMessage"];
    [defaults setObject:tvChat forKey:@"tvChat"];
}

/*
-(void)loadView {
    CGRect frame = [UIScreen mainScreen].bounds;
    UIView *backgroundView = [[UIView alloc] initWithFrame:frame];
    
    CGRect textFieldRect = CGRectMake(40, 70, 240, 30);
    UITextField *textField = [[UITextField alloc] initWithFrame:textFieldRect];
    
    textField.borderStyle = UITextBorderStyleRoundedRect;
    textField.placeholder = @"Your message ...";
    
    [backgroundView addSubview:textField];
}
 */

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITextField Delegate method implementation

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    [self sendMyMessage];
    return YES;
}

#pragma mark - IBAction method implementation

-(IBAction)sendMessage:(id)sender {
    
    [self sendMyMessage];
}

-(IBAction)cancelMessage:(id)sender {
    [_txtMessage resignFirstResponder];
}

#pragma mark - Private method implementation

-(void)sendMyMessage {
    NSString *message = self.txtMessage.text;
    
    if ([[MCManager sharedInstance] sendMessage:message]) {
        
        [_tvChat setText:[_tvChat.text stringByAppendingString:[NSString stringWithFormat:@"I wrote:\n%@\n\n", message]]];
        
        NSLog(@"Message sent: %@", _txtMessage.text);
        [_txtMessage setText:@""];
        [_txtMessage resignFirstResponder];
    } else {
        // something went wrong
        NSLog(@"Message failed to send: %@", _txtMessage.text);

    }
    
    [self saveConversationStateToDefaults];
    
}

-(void)didReceiveDataWithNotification:(NSNotification *)notification {
    MCPeerID *peerID = [[notification userInfo] objectForKey:@"peerID"];
    NSString *peerDisplayName = peerID.displayName;
    
    NSString *receivedText = [notification.userInfo objectForKey:@"textData"];
    NSLog(@"Message received: %@", receivedText);
    /*
    [_tvChat performSelectorOnMainThread:@selector(setText:)
                              withObject:[_tvChat.text stringByAppendingString:[NSString stringWithFormat:@"%@ wrote\n%@\n\n", peerDisplayName, receivedText]]
                           waitUntilDone:NO];
     /*/
    NSString *convo = [MCManager sharedInstance].historyByPeer[peerDisplayName];
    [_tvChat performSelectorOnMainThread:@selector(setText:)
                              withObject:convo
                           waitUntilDone:YES];
    
    [self performSelectorOnMainThread:@selector(saveConversationStateToDefaults)
                           withObject:nil
                        waitUntilDone:NO];
    
}

/*
#pragma mark - Adding Contact

-(IBAction)addContactButton:(id)sender {
    
    if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusDenied || ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusRestricted) {
        NSLog(@"Denied");
        UIAlertView *cantAddContactAlert = [[UIAlertView alloc] initWithTitle:@"Cannot Add Contact" message:@"You must give the app permission to add the contact first" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [cantAddContactAlert show];
    } else if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusAuthorized) {
        NSLog(@"Authorized");
        [self addPersonToContactList:sender];
    } else {
        NSLog(@"Not determined");
        ABAddressBookRequestAccessWithCompletion(ABAddressBookCreateWithOptions(NULL, nil), ^(bool granted, CFErrorRef error) {
            if (!granted) {
                NSLog(@"Just denied");
                return;
            }
            NSLog(@"Just authorized");
            [self addPersonToContactList:sender];
        });
    }
}

-(void)addPersonToContactList: (UIButton *) addContactButton {
    
    ABAddressBookRef addressBookRef = ABAddressBookCreateWithOptions(NULL, nil);
    ABRecordRef contact = ABPersonCreate();
    NSInteger selectedRow = 0; // placeholder, should be filled in with selected row of collectionView
    Contact *person = (Contact*)[MCManager sharedInstance].activePeers[selectedRow];
    ABRecordSetValue(contact, kABPersonFirstNameProperty, (__bridge CFTypeRef)(person.firstName), nil);
    ABRecordSetValue(contact, kABPersonLastNameProperty, (__bridge CFTypeRef)(person.lastName), nil);
    //    ABRecordSetValue(contact, kABPersonLastNameProperty, (__bridge CFStringRef)[DataSource sharedInstance].activeConverstations[selectedRow].lastName, nil);
   
     ABMutableMultiValueRef phoneNumbers = ABMultiValueCreateMutable(kABMultiStringPropertyType);
     ABMultiValueAddValueAndLabel(phoneNumbers(__bridge CFStringRef)contactPhoneNumber, kABPersonPhoneMainLabel, NULL)
     
     ABRecordSetValue(contact, kABPersonPhoneProperty, phoneNumbers, nil);
     
     ABPersonSetImageData(contact, (__bridge CFDataRef)Contact.thumbnailImage, nil);
 
    ABAddressBookAddRecord(addressBookRef, contact, nil);
    ABAddressBookSave(addressBookRef, nil);
    
}
*/

@end
