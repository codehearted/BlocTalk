//
//  HomeScreenCollectionViewController.h
//  BlocTalk
//
//  Created by Murphy on 10/8/14.
//  Copyright (c) 2014 Murphy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeScreenCollectionViewController : UICollectionViewController <UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, strong) NSString *selectedPersonName;
@property (nonatomic, strong) IBOutlet UICollectionView *collectionView;
@property (nonatomic, strong) IBOutlet UITextField *usernameView;
@property (nonatomic, strong) NSMutableArray *arrConnectedPeers;

-(void)peerDidChangeStateWithNotification:(NSNotification *)notification;
-(IBAction)usernameClicked:(id)sender;


@end
