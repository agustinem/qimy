/*
	SDZMensajeWS.h
	The implementation of properties and methods for the SDZMensajeWS object.
	Generated by SudzC.com
*/
#import "SDZMensajeWS.h"

@implementation SDZMensajeWS
	@synthesize _id = __id;
	@synthesize idemisor = _idemisor;
	@synthesize idreceptor = _idreceptor;
	@synthesize idmatch = _idmatch;
	@synthesize fecha = _fecha;
	@synthesize mensaje = _mensaje;

	- (id) init
	{
		if(self = [super init])
		{
			self.fecha = nil;
			self.mensaje = nil;

		}
		return self;
	}

	+ (SDZMensajeWS*) createWithNode: (CXMLNode*) node
	{
		if(node == nil) { return nil; }
		return [[self alloc] initWithNode: node];
	}

	- (id) initWithNode: (CXMLNode*) node {
		if(self = [super initWithNode: node])
		{
			self._id = [[Soap getNodeValue: node withName: @"id"] intValue];
			self.idemisor = [[Soap getNodeValue: node withName: @"idemisor"] intValue];
			self.idreceptor = [[Soap getNodeValue: node withName: @"idreceptor"] intValue];
			self.idmatch = [[Soap getNodeValue: node withName: @"idmatch"] intValue];
			self.fecha = [Soap getNodeValue: node withName: @"fecha"];
			self.mensaje = [Soap getNodeValue: node withName: @"mensaje"];
		}
		return self;
	}

	- (NSMutableString*) serialize
	{
		return [self serialize: @"MensajeWS"];
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
		[s appendFormat: @"<id>%@</id>", [NSString stringWithFormat: @"%i", self._id]];
		[s appendFormat: @"<idemisor>%@</idemisor>", [NSString stringWithFormat: @"%i", self.idemisor]];
		[s appendFormat: @"<idreceptor>%@</idreceptor>", [NSString stringWithFormat: @"%i", self.idreceptor]];
		[s appendFormat: @"<idmatch>%@</idmatch>", [NSString stringWithFormat: @"%i", self.idmatch]];
		if (self.fecha != nil) [s appendFormat: @"<fecha>%@</fecha>", [[self.fecha stringByReplacingOccurrencesOfString:@"\"" withString:@"&quot;"] stringByReplacingOccurrencesOfString:@"&" withString:@"&amp;"]];
		if (self.mensaje != nil) [s appendFormat: @"<mensaje>%@</mensaje>", [[self.mensaje stringByReplacingOccurrencesOfString:@"\"" withString:@"&quot;"] stringByReplacingOccurrencesOfString:@"&" withString:@"&amp;"]];

		return s;
	}
	
	- (NSMutableString*) serializeAttributes
	{
		NSMutableString* s = [super serializeAttributes];

		return s;
	}
	
	-(BOOL)isEqual:(id)object{
		if(object != nil && [object isKindOfClass:[SDZMensajeWS class]]) {
			return [[self serialize] isEqualToString:[object serialize]];
		}
		return NO;
	}
	
	-(NSUInteger)hash{
		return [Soap generateHash:self];

	}

@end
