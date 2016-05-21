//
//  ICPPP.h
//  PCL Library
//
//  Created by Hichem Boussetta on 24/05/12.
//  Copyright (c) 2012 Ingenico. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ICISMPDeviceExtension.h"

@protocol ICPPPDelegate;

@interface ICPPP : ICISMPDevice

+(ICPPP *)sharedChannel;

@property (nonatomic, assign) id<ICISMPDeviceDelegate, ICPPPDelegate> delegate;

@property (nonatomic, readonly) NSString * IP;

@property (nonatomic, readonly) NSString * submask;

@property (nonatomic, readonly) NSString * dns;

@property (nonatomic, readonly) NSString * terminalIP;

-(iSMPResult)openChannel;

-(void)closeChannel;

-(void)addiOSToTerminalBridgeOnPort:(NSInteger)port;

-(void)addTerminalToiOSBridgeOnPort:(NSInteger)port;

-(void)addiOSToTerminalBridgeLocalOnPort:(NSInteger)port;

@end

@protocol ICPPPDelegate

-(void)pppChannelDidOpen;

-(void)pppChannelDidClose;

@end

