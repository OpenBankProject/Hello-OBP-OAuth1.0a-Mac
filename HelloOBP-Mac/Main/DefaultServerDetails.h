//
//  DefaultServerDetails.h
//  HelloOBP-Mac
//
//  Created by Torsten Louland on 26/01/2016.
//  Copyright © 2016 TESOBE. All rights reserved.
//

#ifndef ServerDetails_h
#define ServerDetails_h

#import <Foundation/Foundation.h>



#define kAccountsJSON @"accountsJSON"

#define OAUTH_AUTHENTICATE_URL @"https://apisandbox.openbankproject.com/"
#define OAUTH_BASE_URL @"https://apisandbox.openbankproject.com/obp/v1.2/"

// To get the values for the following fields, please register your client here:
// https://apisandbox.openbankproject.com/consumer-registration
#define OAUTH_CONSUMER_KEY @"1iz1zcsczwhkhyd3ztzb3i5whuubzetfqhfc52ve"
#define OAUTH_CONSUMER_SECRET_KEY @"p4li5mklyt1h43w3u0tx4w2evtn2yz3gmntyn2ty"

#define OAUTH_URL_SCHEME @"helloobp" // Your Application Name
#define OAUTH_CONSUMER_BANK_ID @"rbs" //Account of bank

#define USE_DIRECT_LOGIN 0



static NSString* const kDefaultServer_APIBase = OAUTH_BASE_URL;



NS_INLINE NSDictionary* DefaultServerDetails()
{
	return @{
		OBPServerInfo_APIBase			:	kDefaultServer_APIBase,
		OBPServerInfo_AuthServerBase	:	OAUTH_AUTHENTICATE_URL,
		OBPServerInfo_ClientKey			:	OAUTH_CONSUMER_KEY,
		OBPServerInfo_ClientSecret		:	OAUTH_CONSUMER_SECRET_KEY,
		// ...this is insecure because this only a demo app, but your production app should retrieve your client key and secret from a secure storage place rather than plain text in the app.
	};
}

#endif /* ServerDetails_h */
