/*
	SDZArrayOfMensajews.h
	The implementation of properties and methods for the SDZArrayOfMensajews array.
	Generated by SudzC.com
*/
#import "SDZArrayOfMensajews.h"

#import "SDZMensajeWS.h"
@implementation SDZArrayOfMensajews

	+ (id) createWithNode: (CXMLNode*) node
	{
		return [[self alloc] initWithNode: node];
	}

	- (id) initWithNode: (CXMLNode*) node
	{
		if(self = [self init]) {
			for(CXMLElement* child in [node children])
			{
				SDZMensajeWS* value = [[SDZMensajeWS createWithNode: child] object];
				if(value != nil) {
					[self addObject: value];
				}
			}
		}
		return self;
	}
	
	+ (NSMutableString*) serialize: (NSArray*) array
	{
		NSMutableString* s = [NSMutableString string];
		for(id item in array) {
			[s appendString: [item serialize: @"MensajeWS"]];
		}
		return s;
	}
@end