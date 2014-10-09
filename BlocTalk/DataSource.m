//
//  DataSource.m
//  BlocTalk
//
//  Created by Murphy on 10/9/14.
//  Copyright (c) 2014 Murphy. All rights reserved.
//

#import "DataSource.h"

@interface DataSource ()

@property (nonatomic, strong) NSArray *contactList;

@end

@implementation DataSource

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
    NSMutableArray *randomContacts = [NSMutableArray array];
    
    self.contactList = randomContacts;
}

@end
