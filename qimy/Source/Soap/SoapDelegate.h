/*
 SoapDelegate.h
 Interfaces for the SoapDelegate protocol.
 Author:	Jason Kichline, Mechanicsburg, Pennsylvania USA
 */

#import "SoapFault.h"

@protocol SoapDelegate <NSObject>

- (void) onload: (id) value;

@optional
- (void) onerror: (NSError*) error;
- (void) onfault: (SoapFault*) fault;

@end