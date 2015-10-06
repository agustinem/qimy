/*
	SDZArrayOfBloqueo.h
	The implementation of properties and methods for the SDZArrayOfBloqueo object.
	Generated by SudzC.com
*/
#import "SDZArrayOfBloqueo.h"

#import "SDZArrayOfBloqueows.h"
@implementation SDZArrayOfBloqueo
	@synthesize bloqueos = _bloqueos;

	- (id) init
	{
		if(self = [super init])
		{
			self.bloqueos = [[NSMutableArray alloc] init];

		}
		return self;
	}

	+ (SDZArrayOfBloqueo*) createWithNode: (CXMLNode*) node
	{
		if(node == nil) { return nil; }
		return [[self alloc] initWithNode: node];
	}

	- (id) initWithNode: (CXMLNode*) node {
		if(self = [super initWithNode: node])
		{
			self.bloqueos = [[SDZArrayOfBloqueows createWithNode: [Soap getNode: node withName: @"bloqueos"]] object];
		}
		return self;
	}

	- (NSMutableString*) serialize
	{
		return [self serialize: @"ArrayOfBloqueo"];
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
		if (self.bloqueos != nil && self.bloqueos.count > 0) {
			[s appendFormat: @"<bloqueos>%@</bloqueos>", [SDZArrayOfBloqueows serialize: self.bloqueos]];
		} else {
			[s appendString: @"<bloqueos/>"];
		}

		return s;
	}
	
	- (NSMutableString*) serializeAttributes
	{
		NSMutableString* s = [super serializeAttributes];

		return s;
	}
	
	-(BOOL)isEqual:(id)object{
		if(object != nil && [object isKindOfClass:[SDZArrayOfBloqueo class]]) {
			return [[self serialize] isEqualToString:[object serialize]];
		}
		return NO;
	}
	
	-(NSUInteger)hash{
		return [Soap generateHash:self];

	}

@end