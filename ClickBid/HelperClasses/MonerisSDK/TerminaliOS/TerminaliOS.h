//
//  TerminaliOS.h
//  TerminaliOS
//
//  Created by Nick Tolomiczenko on 11/19/2013.
//  Christian Malek on 11/26/2013.
//

#import <Foundation/Foundation.h>
#import "EselectDelegate.h"

@interface TerminaliOS : NSObject

@property (nonatomic, strong) NSString *storeId;
@property (nonatomic, strong) NSString *apiToken;
@property (nonatomic, strong) NSString *eSelectHost;
@property (nonatomic, strong) NSString *ecrNo;
@property (nonatomic, strong) NSString *serialNo;
@property (nonatomic, unsafe_unretained) id<EselectDelegate> delegate;

-(id)initWithDelegate:(id<EselectDelegate>) delegate;
-(id)initWithDelegate:(id<EselectDelegate>) delegate allowingTip:(BOOL)tipEnabled;

-(NSString *)getTerminalId;
-(NSString *)getSerialNo;
-(BOOL)isTerminalReady;
-(BOOL)isPospadConnected;

-(void)initialization;
-(void)batchclose;

-(void)reset;


-(void)purchase:(NSDictionary *)params;
-(void)preauth:(NSDictionary *)params;
-(void)completion:(NSDictionary *)params;
-(void)purchaseCorrection:(NSDictionary *)params;
-(void)refund:(NSDictionary *)params;
-(void)forcePost:(NSDictionary *)params;
-(void)retrieveMCEmvData;
-(void)retrieveTerminalId;
-(void)setTipEnabled:(BOOL)tipEnabled;
-(void)setKeepAliveInterval:(double)seconds;
@end
