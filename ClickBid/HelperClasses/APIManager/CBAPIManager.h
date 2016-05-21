//
//  CBAPIManager.h
//  ClickBid
//
//  Created by Pushpendra on 06/05/16.
//  Copyright © 2016 Syscraft. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CBAPIManager : NSObject

+(void)PostRequestToApiUrl:(NSString *)StrUrl WithParam:(NSDictionary *)Dict WithSuccess:(void(^)(id response))success failure:(void(^)(NSError *error))failure;
+(void)GetRequestToApiUrl:(NSString *)strUrl WithSuccess:(void(^)(id response))success failure:(void(^)(NSError *error))failure;
+(void)GetRequestToLoginApiUrl:(NSString *)strUrl withHeader:(NSDictionary *)dictHeader WithSuccess:(void(^)(id response))success failure:(void(^)(NSError *error))failure;


+(void)PUTRequestToApiUrl:(NSString *)StrUrl WithParam:(NSDictionary *)Dict WithSuccess:(void(^)(id response))success failure:(void(^)(NSError *error))failure;



@end
