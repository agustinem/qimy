/*
	SDZArrayOfBannerws.h
	The implementation of properties and methods for the SDZArrayOfBannerws array.
	Generated by SudzC.com
*/
#import "SDZArrayOfBannerws.h"

#import "SDZBannerWS.h"
@implementation SDZArrayOfBannerws

	+ (id) createWithNode: (CXMLNode*) node
	{
		return [[self alloc] initWithNode: node];
	}

	- (id) initWithNode: (CXMLNode*) node
	{
		if(self = [self init]) {
			for(CXMLElement* child in [node children])
			{
				SDZBannerWS* value = [[SDZBannerWS createWithNode: child] object];
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
			[s appendString: [item serialize: @"BannerWS"]];
		}
		return s;
	}
@end
