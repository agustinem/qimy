/*
	SDZSudzc.m
	Creates a list of the services available with the SDZ prefix.
	Generated by SudzC.com
*/
#import "SDZSudzc.h"

@implementation SDZSudzC

@synthesize logging, server, defaultServer;

@synthesize wsclassService;


#pragma mark Initialization

-(id)initWithServer:(NSString*)serverName{
	if(self = [self init]) {
		self.server = serverName;
	}
	return self;
}

+(SDZSudzC*)sudzc{
	return (SDZSudzC*)[[SDZSudzC alloc] init];
}

+(SDZSudzC*)sudzcWithServer:(NSString*)serverName{
	return (SDZSudzC*)[[SDZSudzC alloc] initWithServer:serverName];
}

#pragma mark Methods

-(void)setLogging:(BOOL)value{
	logging = value;
	[self updateServices];
}

-(void)setServer:(NSString*)value{
	server = value;
	[self updateServices];
}

-(void)updateServices{

	[self updateService: self.wsclassService];
}

-(void)updateService:(SoapService*)service{
	service.logging = self.logging;
	if(self.server == nil || self.server.length < 1) { return; }
	service.serviceUrl = [service.serviceUrl stringByReplacingOccurrencesOfString:defaultServer withString:self.server];
}

#pragma mark Getter Overrides


-(SDZWsclassService*)wsclassService{
	if(wsclassService == nil) {
		wsclassService = [[SDZWsclassService alloc] init];
	}
	return wsclassService;
}


@end
			