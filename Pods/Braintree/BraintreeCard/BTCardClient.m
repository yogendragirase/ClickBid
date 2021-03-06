#import "BTErrors.h"
#import "BTCardClient_Internal.h"
#import "BTCardNonce_Internal.h"
#import "BTCardRequest.h"
#import "BTClientMetadata.h"
#import "BTHTTP.h"
#import "BTJSON.h"
#import "BTPaymentMethodNonceParser.h"
#import "BTTokenizationService.h"
#if __has_include("BraintreeCore.h")
#import "BTAPIClient_Internal.h"
#import "BTCard_Internal.h"
#else
#import <BraintreeCore/BTAPIClient_Internal.h>
#import <BraintreeCore/BTCard_Internal.h>
#endif

NSString *const BTCardClientErrorDomain = @"com.braintreepayments.BTCardClientErrorDomain";

@interface BTCardClient ()
@end

@implementation BTCardClient

+ (void)load {
    if (self == [BTCardClient class]) {
        [[BTTokenizationService sharedService] registerType:@"Card" withTokenizationBlock:^(BTAPIClient *apiClient, NSDictionary *options, void (^completionBlock)(BTPaymentMethodNonce *paymentMethodNonce, NSError *error)) {
            BTCardClient *client = [[BTCardClient alloc] initWithAPIClient:apiClient];
            [client tokenizeCard:[[BTCard alloc] initWithParameters:options] completion:completionBlock];
        }];
        
        [[BTPaymentMethodNonceParser sharedParser] registerType:@"CreditCard" withParsingBlock:^BTPaymentMethodNonce * _Nullable(BTJSON * _Nonnull creditCard) {
            return [BTCardNonce cardNonceWithJSON:creditCard];
        }];
    }
}

- (instancetype)initWithAPIClient:(BTAPIClient *)apiClient {
    if (!apiClient) {
        return nil;
    }
    if (self = [super init]) {
        self.apiClient = apiClient;
    }
    return self;
}

- (instancetype)init {
    return nil;
}

- (void)tokenizeCard:(BTCard *)card completion:(void (^)(BTCardNonce *tokenizedCard, NSError *error))completion {
    BTCardRequest *request = [[BTCardRequest alloc] initWithCard:card];
    [self tokenizeCard:request options:nil completion:completion];
}


- (void)tokenizeCard:(BTCardRequest *)request options:(NSDictionary *)options completion:(void (^)(BTCardNonce * _Nullable, NSError * _Nullable))completionBlock
{
    if (!self.apiClient) {
        NSError *error = [NSError errorWithDomain:BTCardClientErrorDomain
                                             code:BTCardClientErrorTypeIntegration
                                         userInfo:@{NSLocalizedDescriptionKey: @"BTCardClient tokenization failed because BTAPIClient is nil."}];
        completionBlock(nil, error);
        return;
    }
    
    NSMutableDictionary *parameters = [NSMutableDictionary new];
    if (request.card.parameters) {
        parameters[@"credit_card"] = request.card.parameters;
    }
    parameters[@"_meta"] = @{
                             @"source" : self.apiClient.metadata.sourceString,
                             @"integration" : self.apiClient.metadata.integrationString,
                             @"sessionId" : self.apiClient.metadata.sessionId,
                             };
    if (options) {
        parameters[@"options"] = options;
    }
    if (request.enrollmentAuthCode && request.enrollmentID) {
        NSDictionary *enrollmentDictionary = @{
                                               @"sms_code": request.enrollmentAuthCode,
                                               @"id": request.enrollmentID
                                               };
        if (!parameters[@"options"]) {
            parameters[@"options"] = enrollmentDictionary;
        } else {
            NSMutableDictionary *mutableOptions = [parameters[@"options"] mutableCopy];
            [mutableOptions addEntriesFromDictionary:enrollmentDictionary];
            parameters[@"options"] = mutableOptions;
        }
    }

    [self.apiClient POST:@"v1/payment_methods/credit_cards"
              parameters:parameters
              completion:^(BTJSON *body, __unused NSHTTPURLResponse *response, NSError *error)
     {
         if (error != nil) {
             NSHTTPURLResponse *response = error.userInfo[BTHTTPURLResponseKey];
             NSError *callbackError = error;

             if (response.statusCode == 422) {
                 BTJSON *jsonResponse = error.userInfo[BTHTTPJSONResponseBodyKey];
                 NSDictionary *userInfo = jsonResponse.asDictionary ? @{ BTCustomerInputBraintreeValidationErrorsKey : jsonResponse.asDictionary } : @{};
                 callbackError = [NSError errorWithDomain:BTCardClientErrorDomain
                                                     code:BTCardClientErrorTypeCustomerInputInvalid
                                                 userInfo:userInfo];
             }

             if (request.enrollmentID) {
                 [self sendUnionPayAnalyticsEvent:NO];
             } else {
                 [self sendAnalyticsEventWithSuccess:NO];
             }

             completionBlock(nil, callbackError);
             return;
         }
         
         BTJSON *cardJSON = body[@"creditCards"][0];

         if (request.enrollmentID) {
             [self sendUnionPayAnalyticsEvent:!cardJSON.isError];
         } else {
             [self sendAnalyticsEventWithSuccess:!cardJSON.isError];
         }

         // cardNonceWithJSON returns nil when cardJSON is nil, cardJSON.asError is nil when cardJSON is non-nil
         completionBlock([BTCardNonce cardNonceWithJSON:cardJSON], cardJSON.asError);
     }];
}

#pragma mark - Analytics

- (void)sendAnalyticsEventWithSuccess:(BOOL)success {
    NSString *event = [NSString stringWithFormat:@"ios.%@.card.%@", self.apiClient.metadata.integrationString, success ? @"succeeded" : @"failed"];
    [self.apiClient sendAnalyticsEvent:event];
}

- (void)sendUnionPayAnalyticsEvent:(BOOL)success {
    NSString *event = [NSString stringWithFormat:@"ios.%@.unionpay.nonce-%@", self.apiClient.metadata.integrationString, success ? @"received" : @"failed"];
    [self.apiClient sendAnalyticsEvent:event];
}

@end
