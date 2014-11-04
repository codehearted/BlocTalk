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

@import AddressBook;

@interface HomeScreenCollectionViewController () <UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, strong) UIRefreshControl *refreshControl;

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
    
    // Initialize refresh control
    self.refreshControl = [[UIRefreshControl alloc] init];
    self.refreshControl.backgroundColor = [UIColor blueColor];
    self.refreshControl.tintColor = [UIColor whiteColor];
    [self.refreshControl addTarget: self
                            action: @selector(reloadData)
                  forControlEvents:UIControlEventValueChanged];
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    UIBarButtonItem *editButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:nil];
    self.navigationItem.rightBarButtonItem = editButton;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Pull-to-Refresh

-(void)reloadData {
    [self.collectionView reloadData];
    
    if (self.refreshControl) {
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"MMM d, h:mm a"];
        NSString *title = [NSString stringWithFormat:@"Last update: %@", [formatter stringFromDate:[NSDate date]]];
        NSDictionary *attrsDictionary = [NSDictionary dictionaryWithObject:[UIColor whiteColor]
                                                                    forKey:NSForegroundColorAttributeName];
        NSAttributedString *attributedTitle = [[NSAttributedString alloc] initWithString:title attributes:attrsDictionary];
        self.refreshControl.attributedTitle = attributedTitle;
        
        [self.refreshControl endRefreshing];
    }
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
    
    NSLog(@"peer %@:%@ (%d)",peerID,peerDisplayName,state);
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

- (IBAction)refresh:(id)sender {
    [self.collectionView reloadData];
    NSLog(@"Refreshed (%d found)",[self.collectionView.dataSource collectionView:self.collectionView numberOfItemsInSection:0]);
}

/*
- (IBAction)browseForPeers:(id)sender {
    MCManager *multipeerMgr = [MCManager sharedInstance];
    [multipeerMgr browseForDevices];

    [self presentViewController:multipeerMgr.browser
                       animated:YES
                     completion:nil];
}

 #pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    NSInteger itemsCount = [DataSource sharedInstance].activeConverstations.count;
    itemsCount = 4;
    NSLog(@"Got %d items",(int)itemsCount);
    return itemsCount;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    HomeScreenCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    Contact *activePeers = [MCManager sharedInstance].activePeers[indexPath.row];
    cell.cellNameLabel.text = activePeers.firstName;
    cell.backgroundColor = [UIColor whiteColor];
    
    
    
    // UIImageView *cellIcon = (UIImageView*)[cell viewWithTag:101];
    // cell.cellImage.image = (indexPath.row % 2 ? [UIImage imageNamed:@"1"] : [UIImage imageNamed:@"2"]);
    Contact *activeConversation = [DataSource sharedInstance].activeConverstations[indexPath.row];
    cell.cellImage.image = [UIImage imageNamed:activeConversation.thumbnailImage];
    cell.cellNameLabel.text = activeConversation.firstName;
    cell.backgroundColor = [UIColor whiteColor];
    // This is just for debug reference - not needed for production
    cell.cellId = indexPath.row;
    
    return cell;
}
*/

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
    // NSObject *itemData = [[collectionView dataSource] getDataForPath:indexPath];
    Contact *activePeers = [[MCManager sharedInstance].activePeers objectAtIndex:indexPath.row];
    self.selectedPersonName = activePeers.firstName;
    NSLog(@"You selected item %@ - %@",[indexPath description], self.selectedPersonName);
    
}

@end
