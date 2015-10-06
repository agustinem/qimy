/*
	SDZArrayOfBanner.h
	The implementation of properties and methods for the SDZArrayOfBanner object.
	Generated by SudzC.com
*/
#import "SDZArrayOfBanner.h"

#import "SDZArrayOfBannerws.h"
@implementation SDZArrayOfBanner
	@synthesize banners = _banners;

	- (id) init
	{
		if(self = [super init])
		{
			self.banners = [[NSMutableArray alloc] init];

		}
		return self;
	}

	+ (SDZArrayOfBanner*) createWithNode: (CXMLNode*) node
	{
		if(node == nil) { return nil; }
		return [[self alloc] initWithNode: node];
	}

	- (id) initWithNode: (CXMLNode*) node {
		if(self = [super initWithNode: node])
		{
			self.banners = [[SDZArrayOfBannerws createWithNode: [Soap getNode: node withName: @"banners"]] object];
		}
		return self;
	}

	- (NSMutableString*) serialize
	{
		return [self serialize: @"ArrayOfBanner"];
	}
  
	- (NSMutableString*) serialize: (NSString*) nodeName
	{
		NSMutableString* s = [NSMutableString string];
		[s appendFormat: @"<%@", nodeName];
		[s appendString: [self serializeAttributes]];
		[s appendString: @">"];
		[s appendString: [self serializeElements]];
		[s appendFormat: @"</%@>", nodeName];
		return s;
	}
	
	- (NSMutableString*) serializeElements
	{
		NSMutableString* s = [super serializeElements];
		if (self.banners != nil && self.banners.count > 0) {
			[s appendFormat: @"<banners>%@</banners>", [SDZArrayOfBannerws serialize: self.banners]];
		} else {
			[s appendString: @"<banners/>"];
		}

		return s;
	}
	
	- (NSMutableString*) serializeAttributes
	{
		NSMutableString* s = [super serializeAttributes];

		return s;
	}
	
	-(BOOL)isEqual:(id)object{
		if(object != nil && [object isKindOfClass:[SDZArrayOfBanner class]]) {
			return [[self serialize] isEqualToString:[object serialize]];
		}
		return NO;
	}
	
	-(NSUInteger)hash{
		return [Soap generateHash:self];

	}

@end