//
//  MCManager.m
//  BlocTalk
//
//  Created by Murphy on 10/27/14.
//  Copyright (c) 2014 Murphy. All rights reserved.
//

#import "MCManager.h"
#import "Contact.h"

@import MultipeerConnectivity;

@implementation MCManager


+(instancetype) sharedInstance {
    static dispatch_once_t once;
    static id sharedInstance;
    dispatch_once(&once, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

-(id)init {
    self = [super init];
    
    if (self)  {
        _peerID = nil;
        _session = nil;
        _browser = nil;
        _advertiser = nil;
    }
    
    return self;
}

#pragma mark - Public method implementation

-(void)setupPeerAndSessionWithDisplayName:(NSString *)displayName{
    _peerID = [[MCPeerID alloc] initWithDisplayName:displayName];
    
    _session = [[MCSession alloc] initWithPeer:_peerID];
    _session.delegate = self;
    
    _advertiser = [[MCNearbyServiceAdvertiser alloc] initWithPeer:_peerID discoveryInfo:nil serviceType:@"chat-files"];
    _advertiser.delegate = self;
    [_advertiser startAdvertisingPeer];
    self.advertiser = _advertiser; // Used to keep strong reference
    
    _browser = [[MCNearbyServiceBrowser alloc] initWithPeer:_peerID serviceType:@"chat-files"];
    _browser.delegate = self;
    [_browser startBrowsingForPeers];
}

#pragma mark - MCSession Delegate method implementation

-(void)session:(MCSession *)session peer:(MCPeerID *)peerID didChangeState:(MCSessionState)state {
    NSDictionary *dict = @{@"peerID": peerID,
                           @"state": [NSNumber numberWithInt:state]
                           };
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"MCDidChangeStateNotification"
                                                        object:nil
                                                      userInfo:dict];
}

-(void)session:(MCSession *)session didReceiveData:(NSData *)data fromPeer:(MCPeerID *)peerID {
    NSDictionary *dict = @{@"data": data,
                           @"peerID": peerID,
                           @"textData": [[NSString alloc] initWithData:data
                                                              encoding:NSUTF8StringEncoding]
                           };

    [[NSNotificationCenter defaultCenter] postNotificationName:@"MCDidReceiveDataNotification"
                                                        object:nil
                                                      userInfo:dict];
}

-(void)session:(MCSession *)session didStartReceivingResourceWithName:(NSString *)resourceName fromPeer:(MCPeerID *)peerID withProgress:(NSProgress *)progress {
    
}

-(void)session:(MCSession *)session didFinishReceivingResourceWithName:(NSString *)resourceName fromPeer:(MCPeerID *)peerID atURL:(NSURL *)localURL withError:(NSError *)error {
    
}

-(void)session:(MCSession *)session didReceiveStream:(NSInputStream *)stream withName:(NSString *)streamName fromPeer:(MCPeerID *)peerID {
    
}

-(void)session:(MCSession *)session didReceiveCertificate:(NSArray *)certificate fromPeer:(MCPeerID *)peerID certificateHandler:(void (^)(BOOL))certificateHandler {
    
    certificateHandler(YES);
}

/*
 #pragma mark - MCBrowserViewControllerDelegate method implementation

-(void)browserViewControllerDidFinish:(MCBrowserViewController *)browserViewController{
    [self.browser dismissViewControllerAnimated:YES completion:nil];
}


-(void)browserViewControllerWasCancelled:(MCBrowserViewController *)browserViewController{
    [self.browser dismissViewControllerAnimated:YES completion:nil];
}
*/

#pragma mark - MCNearbyServiceBrowserDelegate

-(void)browser:(MCNearbyServiceBrowser *)browser foundPeer:(MCPeerID *)peerID withDiscoveryInfo:(NSDictionary *)info {
    
    [_browser invitePeer:peerID toSession:_session withContext:nil timeout:30.0];
    Contact *newPeer = [[Contact alloc] init];
    newPeer.peerID = peerID;
    newPeer.firstName = @"Fred";
    self.activePeers = [NSArray arrayWithObject:newPeer];
    
    [_browser stopBrowsingForPeers];
}

-(void)browser:(MCNearbyServiceBrowser *)browser lostPeer:(MCPeerID *)peerID {
    
}

#pragma mark - MCNearbyServiceAdvertiserDelegate

-(void)advertiser:(MCNearbyServiceAdvertiser *)advertiser didReceiveInvitationFromPeer:(MCPeerID *)peerID withContext:(NSData *)context invitationHandler:(void (^)(BOOL, MCSession *))invitationHandler {
    
    _session = [[MCSession alloc] initWithPeer:_peerID];
    _session.delegate = self;
    
    invitationHandler(YES, _session);
}

@end
