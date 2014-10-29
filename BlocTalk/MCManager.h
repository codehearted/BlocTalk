//
//  MCManager.h
//  BlocTalk
//
//  Created by Murphy on 10/27/14.
//  Copyright (c) 2014 Murphy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MultipeerConnectivity/MultipeerConnectivity.h>

@interface MCManager : NSObject <MCSessionDelegate, MCBrowserViewControllerDelegate>

@property (nonatomic, strong) MCPeerID *peerID;
@property (nonatomic, strong) MCSession *session;
@property (nonatomic, strong) MCBrowserViewController *browser;
@property (nonatomic, strong) MCAdvertiserAssistant *advertiser;

+(instancetype) sharedInstance;

-(void)setupPeerAndSessionWithDisplayName:(NSString *)displayName;
-(void)setupMCBrowser;
-(void)advertiseSelf:(BOOL)shouldAdvertise;
-(void)browseForDevices;

@end
