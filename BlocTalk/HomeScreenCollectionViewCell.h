//
//  HomeScreenCollectionViewCell.h
//  BlocTalk
//
//  Created by Murphy on 10/9/14.
//  Copyright (c) 2014 Murphy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeScreenCollectionViewCell : UICollectionViewCell
@property (strong, nonatomic) IBOutlet UIImageView *cellImage;
@property (strong, nonatomic) IBOutlet UILabel *cellNameLabel;
@property (assign, atomic)      NSInteger cellId;


@end
