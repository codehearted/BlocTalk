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

@end
