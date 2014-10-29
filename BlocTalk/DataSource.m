//
//  DataSource.m
//  BlocTalk
//
//  Created by Murphy on 10/9/14.
//  Copyright (c) 2014 Murphy. All rights reserved.
//

#import "DataSource.h"
#import "Contact.h"
#import "HomeScreenCollectionViewCell.h"

@interface DataSource ()

@property (nonatomic, strong) NSMutableArray *arrConnectedDevices;

@end

@implementation DataSource

static NSString * const reuseIdentifier = @"contactCollectionCell";

+(instancetype) sharedInstance {
    static dispatch_once_t once;
    static id sharedInstance;
    dispatch_once(&once, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (instancetype) init {
    self = [super init];
    
    if (self) {
        [self addRandomData];
    }
    
    return self;
}

- (void) addRandomData {
    
    Contact *cell1 = [Contact new];
    cell1.firstName = @"Jane";
    cell1.lastName = @"D";
    cell1.thumbnailImage = @"1.jpg";
    cell1.phoneNumber = @"2015552398";
    
    Contact *cell2 = [Contact new];
    cell2.firstName = @"Peter";
    cell2.lastName = @"R";
    cell2.thumbnailImage = @"2.jpg";
    cell2.phoneNumber = @"3331560987";
    
    Contact *cell3 = [Contact new];
    cell3.firstName = @"Mason";
    cell3.lastName = @"P";
    cell3.thumbnailImage = @"3.jpg";
    cell3.phoneNumber = @"5438880123";
    
    Contact *cell4 = [Contact new];
    cell4.firstName = @"John";
    cell4.lastName = @"S";
    cell4.thumbnailImage = @"4.jpg";
    cell4.phoneNumber = @"7124779070";
    
    self.activeConverstations = [NSArray arrayWithObjects:cell1, cell2, cell3, cell4, nil];
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


@end
