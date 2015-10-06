/*
	SDZPerfilfalsoWS.h
	The interface definition of properties and methods for the SDZPerfilfalsoWS object.
	Generated by SudzC.com
*/

#import "Soap.h"
	

@interface SDZPerfilfalsoWS : SoapObject
{
	int __id;
	int _iddenunciante;
	int _iddenunciado;
	
}
		
	@property int _id;
	@property int iddenunciante;
	@property int iddenunciado;

	+ (SDZPerfilfalsoWS*) createWithNode: (CXMLNode*) node;
	- (id) initWithNode: (CXMLNode*) node;
	- (NSMutableString*) serialize;
	- (NSMutableString*) serialize: (NSString*) nodeName;
	- (NSMutableString*) serializeAttributes;
	- (NSMutableString*) serializeElements;

@end
