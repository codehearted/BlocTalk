//
//  ContactList.h
//  BlocTalk
//
//  Created by Murphy on 10/15/14.
//  Copyright (c) 2014 Murphy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MultipeerConnectivity/MultipeerConnectivity.h>

@interface Contact : NSObject

@property (strong, nonatomic) MCPeerID *peerID;
@property (strong, nonatomic) NSString *thumbnailImage;
@property (strong, nonatomic) NSString *firstName;
@property (strong, nonatomic) NSString *lastName;
@property (strong, nonatomic) NSString *phoneNumber;

@end
