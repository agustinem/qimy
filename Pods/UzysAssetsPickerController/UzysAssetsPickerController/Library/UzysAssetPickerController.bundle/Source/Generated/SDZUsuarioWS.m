/*
	SDZUsuarioWS.h
	The implementation of properties and methods for the SDZUsuarioWS object.
	Generated by SudzC.com
*/
#import "SDZUsuarioWS.h"

#import "SDZArrayOfString.h"
@implementation SDZUsuarioWS
	@synthesize _id = __id;
	@synthesize idprovincia = _idprovincia;
	@synthesize email = _email;
	@synthesize password = _password;
	@synthesize role = _role;
	@synthesize nombre = _nombre;
	@synthesize edad = _edad;
	@synthesize provincia = _provincia;
	@synthesize latitud = _latitud;
	@synthesize longitud = _longitud;
	@synthesize sexo = _sexo;
	@synthesize interesahombre = _interesahombre;
	@synthesize interesamujer = _interesamujer;
	@synthesize descripcion = _descripcion;
	@synthesize esbot = _esbot;
	@synthesize activo = _activo;
	@synthesize fotos = _fotos;

	- (id) init
	{
		if(self = [super init])
		{
			self.email = nil;
			self.password = nil;
			self.role = nil;
			self.nombre = nil;
			self.provincia = nil;
			self.descripcion = nil;
			self.fotos = [[NSMutableArray alloc] init];

		}
		return self;
	}

	+ (SDZUsuarioWS*) createWithNode: (CXMLNode*) node
	{
		if(node == nil) { return nil; }
		return [[self alloc] initWithNode: node];
	}

	- (id) initWithNode: (CXMLNode*) node {
		if(self = [super initWithNode: node])
		{
			self._id = [[Soap getNodeValue: node withName: @"id"] intValue];
			self.idprovincia = [[Soap getNodeValue: node withName: @"idprovincia"] intValue];
			self.email = [Soap getNodeValue: node withName: @"email"];
			self.password = [Soap getNodeValue: node withName: @"password"];
			self.role = [Soap getNodeValue: node withName: @"role"];
			self.nombre = [Soap getNodeValue: node withName: @"nombre"];
			self.edad = [[Soap getNodeValue: node withName: @"edad"] intValue];
			self.provincia = [Soap getNodeValue: node withName: @"provincia"];
			self.latitud = [[Soap getNodeValue: node withName: @"latitud"] floatValue];
			self.longitud = [[Soap getNodeValue: node withName: @"longitud"] floatValue];
			self.sexo = [[Soap getNodeValue: node withName: @"sexo"] intValue];
			self.interesahombre = [[Soap getNodeValue: node withName: @"interesahombre"] intValue];
			self.interesamujer = [[Soap getNodeValue: node withName: @"interesamujer"] intValue];
			self.descripcion = [Soap getNodeValue: node withName: @"descripcion"];
			self.esbot = [[Soap getNodeValue: node withName: @"esbot"] intValue];
			self.activo = [[Soap getNodeValue: node withName: @"activo"] intValue];
			self.fotos = [[SDZArrayOfString createWithNode: [Soap getNode: node withName: @"fotos"]] object];
		}
		return self;
	}

	- (NSMutableString*) serialize
	{
		return [self serialize: @"UsuarioWS"];
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
		[s appendFormat: @"<idprovincia>%@</idprovincia>", [NSString stringWithFormat: @"%i", self.idprovincia]];
		if (self.email != nil) [s appendFormat: @"<email>%@</email>", [[self.email stringByReplacingOccurrencesOfString:@"\"" withString:@"&quot;"] stringByReplacingOccurrencesOfString:@"&" withString:@"&amp;"]];
		if (self.password != nil) [s appendFormat: @"<password>%@</password>", [[self.password stringByReplacingOccurrencesOfString:@"\"" withString:@"&quot;"] stringByReplacingOccurrencesOfString:@"&" withString:@"&amp;"]];
		if (self.role != nil) [s appendFormat: @"<role>%@</role>", [[self.role stringByReplacingOccurrencesOfString:@"\"" withString:@"&quot;"] stringByReplacingOccurrencesOfString:@"&" withString:@"&amp;"]];
		if (self.nombre != nil) [s appendFormat: @"<nombre>%@</nombre>", [[self.nombre stringByReplacingOccurrencesOfString:@"\"" withString:@"&quot;"] stringByReplacingOccurrencesOfString:@"&" withString:@"&amp;"]];
		[s appendFormat: @"<edad>%@</edad>", [NSString stringWithFormat: @"%i", self.edad]];
		if (self.provincia != nil) [s appendFormat: @"<provincia>%@</provincia>", [[self.provincia stringByReplacingOccurrencesOfString:@"\"" withString:@"&quot;"] stringByReplacingOccurrencesOfString:@"&" withString:@"&amp;"]];
		[s appendFormat: @"<latitud>%@</latitud>", [NSString stringWithFormat: @"%f", self.latitud]];
		[s appendFormat: @"<longitud>%@</longitud>", [NSString stringWithFormat: @"%f", self.longitud]];
		[s appendFormat: @"<sexo>%@</sexo>", [NSString stringWithFormat: @"%i", self.sexo]];
		[s appendFormat: @"<interesahombre>%@</interesahombre>", [NSString stringWithFormat: @"%i", self.interesahombre]];
		[s appendFormat: @"<interesamujer>%@</interesamujer>", [NSString stringWithFormat: @"%i", self.interesamujer]];
		if (self.descripcion != nil) [s appendFormat: @"<descripcion>%@</descripcion>", [[self.descripcion stringByReplacingOccurrencesOfString:@"\"" withString:@"&quot;"] stringByReplacingOccurrencesOfString:@"&" withString:@"&amp;"]];
		[s appendFormat: @"<esbot>%@</esbot>", [NSString stringWithFormat: @"%i", self.esbot]];
		[s appendFormat: @"<activo>%@</activo>", [NSString stringWithFormat: @"%i", self.activo]];
		if (self.fotos != nil && self.fotos.count > 0) {
			[s appendFormat: @"<fotos>%@</fotos>", [SDZArrayOfString serialize: self.fotos]];
		} else {
			[s appendString: @"<fotos/>"];
		}

		return s;
	}
	
	- (NSMutableString*) serializeAttributes
	{
		NSMutableString* s = [super serializeAttributes];

		return s;
	}
	
	-(BOOL)isEqual:(id)object{
		if(object != nil && [object isKindOfClass:[SDZUsuarioWS class]]) {
			return [[self serialize] isEqualToString:[object serialize]];
		}
		return NO;
	}
	
	-(NSUInteger)hash{
		return [Soap generateHash:self];

	}

@end