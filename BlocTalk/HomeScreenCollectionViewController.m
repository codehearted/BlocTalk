//
//  HomeScreenCollectionViewController.m
//  BlocTalk
//
//  Created by Murphy on 10/8/14.
//  Copyright (c) 2014 Murphy. All rights reserved.
//

#import "HomeScreenCollectionViewController.h"
#import "HomeScreenCollectionViewCell.h"
#import "DataSource.h"
#import "Contact.h"
#import "ConversationViewController.h"
#import "MCManager.h"
#import "AppDelegate.h"

@import AddressBook;

@interface HomeScreenCollectionViewController () <UICollectionViewDataSource, UICollectionViewDelegate>


@end

@implementation HomeScreenCollectionViewController

static NSString * const reuseIdentifier = @"contactCollectionCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.collectionView.dataSource = [DataSource sharedInstance];
    self.clearsSelectionOnViewWillAppear = NO;
    self.selectedPersonName = @"";
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(peerDidChangeStateWithNotification:)
                                                 name:@"MCDidChangeStateWithNotification"
                                               object:nil];
    
    _arrConnectedPeers = [[NSMutableArray alloc] init];
    
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    // Add edit bar to handle conversations (delete, archive, mulitselect)
    // UIBarButtonItem *editButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:nil];
    // self.navigationItem.rightBarButtonItem = editButton;
    
    // UIBarButtonItem *refreshButton = [[UIBarButtonItem alloc] initWithTitle:@"Refresh" style:UIBarButtonItemStylePlain target:@selector(refresh:) action:nil];
    // self.navigationItem.leftBarButtonItem = refreshButton;
    
    self.navigationItem.leftBarButtonItem.title = (@"%@", [[UIDevice currentDevice] name]);
    //.text = @"test";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    NSIndexPath *path = [[self.collectionView indexPathsForSelectedItems] lastObject];
    
    Contact *activePeer = [MCManager sharedInstance].activePeers[path.row];
    NSString *name = [activePeer firstName];
 
    NSLog(@"Going to path for cell %ld (%@)",(long)path.row,name);

    [(ConversationViewController*)[segue destinationViewController] setPersonName:name];
}

#pragma mark Multipeer

-(void)peerDidChangeStateWithNotification:(NSNotification *)notification{
    MCPeerID *peerID = [[notification userInfo] objectForKey:@"peerID"];
    NSString *peerDisplayName = peerID.displayName;
    MCSessionState state = [[[notification userInfo] objectForKey:@"state"] intValue];
    
    NSLog(@"peer %@:%@ (%ld)",peerID,peerDisplayName,state);
    if (state != MCSessionStateConnecting) {
        if (state == MCSessionStateConnected) {
            [_arrConnectedPeers addObject:peerDisplayName];
        }
        else if (state == MCSessionStateNotConnected){
            if ([_arrConnectedPeers count] > 0) {
                NSUInteger indexOfPeer = [_arrConnectedPeers indexOfObject: peerDisplayName];
                [_arrConnectedPeers removeObjectAtIndex:indexOfPeer];
            }
        }
        
        [self.collectionView reloadData];
    }
}

#pragma mark IBActions

-(IBAction)usernameClicked:(id)sender {
    NSLog(@"Username changed to %@",[sender title]);
}

- (IBAction)refresh:(id)sender {
    [self.collectionView reloadData];
    NSLog(@"Refreshed (%d found)",[self.collectionView.dataSource collectionView:self.collectionView numberOfItemsInSection:0]);
}


#pragma mark <UICollectionViewDelegate>

// Uncomment this method to specify if the specified item should be highlighted during tracking
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}


// Uncomment this method to specify if the specified item should be selected
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

/*
// Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	return NO;
}

- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	
}
*/

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    Contact *activePeers = [[MCManager sharedInstance].activePeers objectAtIndex:indexPath.row];
    self.selectedPersonName = activePeers.firstName;
    NSLog(@"You selected item %@ - %@",[indexPath description], self.selectedPersonName);
    
}

@end
