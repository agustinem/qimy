/*
 SoapRequest.h
 Interface definition of the request object used to manage asynchronous requests.
 Author:	Jason Kichline, Mechanicsburg, Pennsylvania USA
*/

#import "SoapHandler.h"
#import "SoapService.h"

extern NSString* const SoapRequestDidStartNotification;
extern NSString* const SoapRequestDidUpdateProgressNotification;
extern NSString* const SoapRequestDidFinishNotification;
extern NSString* const SoapRequestDidFailNotification;
extern NSString* const SoapRequestProgressKey;

typedef void (^SoapRequestCompletionBlock)(BOOL succeeded, id output, SoapFault* fault, NSError* error);
typedef void (^SoapRequestProgressBlock)(float progress);

@interface SoapRequest : NSObject {
	NSURL* url;
	NSString* soapAction;
	NSString* username;
	NSString* password;
	id postData;
	NSMutableData* receivedData;
	NSURLConnection* conn;
	SoapHandler* handler;
	id deserializeTo;
	SEL action;
	BOOL logging;
	id<SoapDelegate> defaultHandler;
	long long expectedContentLength;
}

@property (retain, nonatomic) NSURL* url;
@property (retain, nonatomic) NSString* soapAction;
@property (retain, nonatomic) NSString* username;
@property (retain, nonatomic) NSString* password;
@property (retain, nonatomic) id postData;
@property (retain, nonatomic) NSMutableData* receivedData;
@property (retain, nonatomic) SoapHandler* handler;
@property (retain, nonatomic) id deserializeTo;
@property SEL action;
@property BOOL logging;
@property (retain, nonatomic) id<SoapDelegate> defaultHandler;
@property (nonatomic, strong) SoapRequestCompletionBlock completionBlock;
@property (nonatomic, strong) SoapRequestProgressBlock progressBlock;

+(SoapRequest*)create:(SoapHandler*)handler urlString:(NSString*)urlString soapAction:(NSString*)soapAction postData:(NSString*)postData deserializeTo:(id) deserializeTo;
+(SoapRequest*)create:(SoapHandler*)handler action:(SEL)action urlString:(NSString*)urlString soapAction:(NSString*)soapAction postData:(NSString*)postData deserializeTo:(id) deserializeTo;
+(SoapRequest*)create:(SoapHandler*)handler action:(SEL)action service:(SoapService*)service soapAction:(NSString*)soapAction postData:(NSString*)postData deserializeTo:(id) deserializeTo;

+(SoapRequest*)createWithURL:(NSURL*)url soapAction:(NSString*)soapAction postData:(NSString*)postData deserializeTo:(id)deserializeTo completionBlock:(SoapRequestCompletionBlock)completionBlock;
+(SoapRequest*)createWithService:(SoapService*)service soapAction:(NSString*)soapAction postData:(NSString*)postData deserializeTo:(id)deserializeTo completionBlock:(SoapRequestCompletionBlock)completionBlock;

- (BOOL)cancel;
- (void)send;
- (void)handleError:(NSError*)error;
- (void)handleFault:(SoapFault*)fault;
- (void)handleSuccess:(id)output;

@end