/*
	SDZArrayOfBloqueows.h
	The implementation of properties and methods for the SDZArrayOfBloqueows array.
	Generated by SudzC.com
*/
#import "SDZArrayOfBloqueows.h"

#import "SDZBloqueoWS.h"
@implementation SDZArrayOfBloqueows

	+ (id) createWithNode: (CXMLNode*) node
	{
		return [[self alloc] initWithNode: node];
	}

	- (id) initWithNode: (CXMLNode*) node
	{
		if(self = [self init]) {
			for(CXMLElement* child in [node children])
			{
				SDZBloqueoWS* value = [[SDZBloqueoWS createWithNode: child] object];
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
			[s appendString: [item serialize: @"BloqueoWS"]];
		}
		return s;
	}
@end