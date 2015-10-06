//
//  SoapLiteral.h
//  SudzC
//
//  Created by Jason Kichline on 8/7/10.
//  Copyright 2010 Jason Kichline. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface SoapLiteral : NSObject {
	NSString* value;
}

@property (nonatomic, retain) NSString* value;

-(id)initWithString:(NSString*)string;
+(SoapLiteral*)literalWithString:(NSString*)string;

@end
