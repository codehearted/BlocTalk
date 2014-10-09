//
//  DataSource.h
//  BlocTalk
//
//  Created by Murphy on 10/9/14.
//  Copyright (c) 2014 Murphy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataSource : NSObject

+(instancetype) sharedInstance;
@property (nonatomic, strong, readonly) NSArray *contactList;

@end
