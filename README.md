##   CKBasicAuthUrlUtilities

###  Let's face it, dealing with BASIC authentication using NSURLs is a pain in the ass, this utility makes it slightly less painful.

Install via Cocoapods, add a line, like the one below, in your Podfile:

`pod 'CKBasicAuthUrlUtilities',	'~> 0.0.1'`

Then, um, use it:

	CKBasicAuthUrlUtilities urlUtilities = CKBasicAuthUrlUtilities.new;

Let's see what we can do:

	//  Creates a NSURL, just like [NSURL urlWithString:] but encodes the NSString if needed
	- (NSURL *)urlWithEncodedOrNonEncodedString:(NSString *)encodedOrNonEncodedString;

	//  Returns a NSURL with an updated username
	- (NSURL *)urlWithUpdatedUsername:(NSString *)username forUrl:(NSURL *)url;

	//  Returns a NSURL with an updated password
	- (NSURL *)urlWithUpdatedPassword:(NSString *)password forUrl:(NSURL *)url;

	//  Returns a NSURL with an updated username and password
	- (NSURL *)urlWithUpdatedUsername:(NSString *)username andPassword:(NSString *)password forUrl:(NSURL *)url;

	//  Returns a NSURL with the authentication components stripped out
	//  so this: https://user_one:fluffyKitty17@www.someurl.com
	//  becomes this: https://www.someurl.com
	- (NSURL *)urlWithoutAuthenticationFromUrl:(NSURL *)url;

If the [URL scheme component](http://en.wikipedia.org/wiki/URI_scheme#Official_IANA-registered_schemes) is missing in your NSURL,  CKBasicAuthUrlUtilities  automatically uses https by default, but can use http if desired.  It can be set via a property after initialization or on creation:

	urlUtils.schemeType = (CKBasicAuthUrlUtilitiesDefaultSchemeType);

or 

	urlUtils = [[CKBasicAuthUrlUtilities alloc] initWithDefaultSchemeType:(CKBasicAuthUrlUtilitiesDefaultSchemeType)];


where `CKBasicAuthUrlUtilitiesDefaultSchemeType` is either:

`CKBasicAuthUrlUtilitiesDefaultSchemeTypeHttp` or 
`CKBasicAuthUrlUtilitiesDefaultSchemeTypeHttps`

But you shouldn't be using BASIC auth over HTTP anyway, so don't do this!

Nil or empty NSStrings should work as expected, see the unit tests for examples and feel free to contribute.


