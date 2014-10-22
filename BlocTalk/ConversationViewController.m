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
@import AddressBook;
@import MultipeerConnectivity;

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
    Contact *person = (Contact*)[DataSource sharedInstance].activeConverstations[selectedRow];
    ABRecordSetValue(contact, kABPersonFirstNameProperty, (__bridge CFTypeRef)(person.firstName), nil);
    ABRecordSetValue(contact, kABPersonLastNameProperty, (__bridge CFTypeRef)(person.lastName), nil);
//    ABRecordSetValue(contact, kABPersonLastNameProperty, (__bridge CFStringRef)[DataSource sharedInstance].activeConverstations[selectedRow].lastName, nil);
    /*
    ABMutableMultiValueRef phoneNumbers = ABMultiValueCreateMutable(kABMultiStringPropertyType);
    ABMultiValueAddValueAndLabel(phoneNumbers(__bridge CFStringRef)contactPhoneNumber, kABPersonPhoneMainLabel, NULL)
    
    ABRecordSetValue(contact, kABPersonPhoneProperty, phoneNumbers, nil);
    
    ABPersonSetImageData(contact, (__bridge CFDataRef)Contact.thumbnailImage, nil);
    */
    ABAddressBookAddRecord(addressBookRef, contact, nil);
    ABAddressBookSave(addressBookRef, nil);
    
}

#pragma mark - MCSessionDelegate

-(void)session:(MCSession *)session
didReceiveData: (NSData *)data
      fromPeer:(MCPeerID *)peerID {
    
    NSString *message = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"%@", message);
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
