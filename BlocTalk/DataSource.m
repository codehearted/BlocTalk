//
//  DataSource.m
//  BlocTalk
//
//  Created by Murphy on 10/9/14.
//  Copyright (c) 2014 Murphy. All rights reserved.
//

#import "DataSource.h"
#import "Contact.h"

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

@end
