/*
 SoapDelegate.h
 Interfaces for the concrete SoapHandler class.
 Author:	Jason Kichline, Mechanicsburg, Pennsylvania USA
*/

#import "SoapFault.h"
#import "SoapDelegate.h"

@interface SoapHandler : NSObject <SoapDelegate>
{
}

- (void) onload: (id) value;
- (void) onerror: (NSError*) error;
- (void) onfault: (SoapFault*) fault;

@end