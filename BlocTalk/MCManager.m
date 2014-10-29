//
//  MCManager.m
//  BlocTalk
//
//  Created by Murphy on 10/27/14.
//  Copyright (c) 2014 Murphy. All rights reserved.
//

#import "MCManager.h"

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
    [self advertiseSelf:YES];
}


-(void)setupMCBrowser{
    _browser = [[MCBrowserViewController alloc] initWithServiceType:@"chat-files" session:_session];
}


-(void)advertiseSelf:(BOOL)shouldAdvertise{
    if (shouldAdvertise) {
        _advertiser = [[MCAdvertiserAssistant alloc] initWithServiceType:@"chat-files"
                                                           discoveryInfo:nil
                                                                 session:_session];
        [_advertiser start];
    }
    else{
        [_advertiser stop];
        _advertiser = nil;
    }
}

-(void)browseForDevices {
    [self setupMCBrowser];
    [[self browser] setDelegate:self];
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
                           @"peerID": peerID
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

#pragma mark - MCBrowserViewControllerDelegate method implementation

-(void)browserViewControllerDidFinish:(MCBrowserViewController *)browserViewController{
    [self.browser dismissViewControllerAnimated:YES completion:nil];
}


-(void)browserViewControllerWasCancelled:(MCBrowserViewController *)browserViewController{
    [self.browser dismissViewControllerAnimated:YES completion:nil];
}

@end
