/*
	SDZArrayOfEncuentrows.h
	The implementation of properties and methods for the SDZArrayOfEncuentrows array.
	Generated by SudzC.com
*/
#import "SDZArrayOfEncuentrows.h"

#import "SDZEncuentroWS.h"
@implementation SDZArrayOfEncuentrows

	+ (id) createWithNode: (CXMLNode*) node
	{
		return [[self alloc] initWithNode: node];
	}

	- (id) initWithNode: (CXMLNode*) node
	{
		if(self = [self init]) {
			for(CXMLElement* child in [node children])
			{
				SDZEncuentroWS* value = [[SDZEncuentroWS createWithNode: child] object];
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
			[s appendString: [item serialize: @"EncuentroWS"]];
		}
		return s;
	}
@end