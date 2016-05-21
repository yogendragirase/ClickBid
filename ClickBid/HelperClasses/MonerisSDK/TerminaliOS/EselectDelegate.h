//
//  EselectDelegate.h
//  PaydPro
//
//  Created by Nick Tolomiczenko on 11/9/2013.
//
//

#import <Foundation/Foundation.h>

@protocol EselectDelegate <NSObject>

-(void)receiptReady:(NSDictionary *)receipt;

-(void)terminalBecameReady;
-(void)terminalBecameBusy;

@optional
-(void)pospadDidConnect;
-(void)pospadDidDisconnect;

@end
