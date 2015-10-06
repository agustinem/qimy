/*
	SDZBannerWS.h
	The interface definition of properties and methods for the SDZBannerWS object.
	Generated by SudzC.com
*/

#import "Soap.h"
	

@interface SDZBannerWS : SoapObject
{
	int __id;
	NSString* _ruta;
	int _peso;
	NSString* _web;
	
}
		
	@property int _id;
	@property (retain, nonatomic) NSString* ruta;
	@property int peso;
	@property (retain, nonatomic) NSString* web;

	+ (SDZBannerWS*) createWithNode: (CXMLNode*) node;
	- (id) initWithNode: (CXMLNode*) node;
	- (NSMutableString*) serialize;
	- (NSMutableString*) serialize: (NSString*) nodeName;
	- (NSMutableString*) serializeAttributes;
	- (NSMutableString*) serializeElements;

@end
