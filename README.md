##   CKBasicAuthUrlUtilities

###  Let's face it, dealing with BASIC authentication using NSURLs is a pain in the ass, this utility makes it slightly less painful.

Install via Cocoapods, add a line, like the one below, in your Podfile:

`pod 'CKBasicAuthUrlUtilities',	'~> 0.0.6'`

Then, um...use it:

	CKBasicAuthUrlUtilities urlUtilities = CKBasicAuthUrlUtilities.new;

Let's see what we can do:

Create a NSURL with a non-encoded string, percent escaping the non-encoded string with NSUTF8StringEncoding (prepends default scheme if missing):

	- (NSURL *)urlWithUtf8EncodingForString:(NSString *)nonEncodedString;

NSURL with an updated username, username encoded if needed (prepends default scheme if missing):

	- (NSURL *)urlWithUpdatedUsername:(NSString *)username forUrl:(NSURL *)url;

NSURL with an updated password, password encoded if needed (prepends default scheme if missing):

	- (NSURL *)urlWithUpdatedPassword:(NSString *)password forUrl:(NSURL *)url;

NSURL with an updated username and password, username and password will be encoded if needed (prepends default scheme if missing):

	- (NSURL *)urlWithUpdatedUsername:(NSString *)username andPassword:(NSString *)password forUrl:(NSURL *)url;

NSURL with the authentication components stripped out:

	- (NSURL *)urlWithoutAuthenticationFromUrl:(NSURL *)url;

Return YES if URL contains scheme:

	- (BOOL)urlHasScheme:(NSURL *)url;

Return YES if URL contains components for BASIC authentication:

	- (BOOL)urlHasAuthentication:(NSURL *)url;


Return an absolute string represntation of a given url without the authentication components:

	- (NSString *)absoluteStringWithoutAuthenticationForUrl:(NSURL *)url;

Return an absolute string represntation of a given url with the password obfuscated

	- (NSString *)absoluteStringObfuscatedPassword:(NSURL *)url;

Return a basic authentication string (encoded) from a given url, returns nil if url does not contain an auth string:

	- (NSString *)basicAuthenticationStringWithEncodingForUrl:(NSURL *)url;

Return a basic authentication string (non-encoded) from a given url, returns nil if url does not contain an auth string:

	- (NSString *)basicAuthenticationStringWithoutEncodingForUrl:(NSURL *)url;

Preempt Authentication callbacks by initializing a NSMutableURLRequest with the provided url.
If given URL has authentication, then add basic authentication to url request preemptively.
This can be used when the server returns a 401 without a 403 response and the standard NSURLConnectionDelegate willSendRequestForAuthenticationChallenge is not automatically called 

	- (NSMutableURLRequest *)urlRequestWithPreemptiveBasicAuthenticationWithUrl:(NSURL *)url;

Methods below from [NSData-Base64](https://github.com/l4u/NSData-Base64/blob/master/NSData%2BBase64.h)

Returns NSData fromm a Base64 encoded string:

	- (NSData *)dataFromBase64String:(NSString *)aString;

Return a NSString Base64 encoded:

	- (NSString *)base64EncodedStringForData:(NSData *)data;

----

If the [URL scheme component](http://en.wikipedia.org/wiki/URI_scheme#Official_IANA-registered_schemes) is missing in your NSURL,  CKBasicAuthUrlUtilities  automatically uses https by default, but can use http if desired.  It can be set via a property after initialization or on creation:

	urlUtils.schemeType = (CKBasicAuthUrlUtilitiesDefaultSchemeType);

or 

	CKBasicAuthUrlUtilities urlUtils = [[CKBasicAuthUrlUtilities alloc] initWithDefaultSchemeType:(CKBasicAuthUrlUtilitiesDefaultSchemeType)];


where `CKBasicAuthUrlUtilitiesDefaultSchemeType` is either:

`CKBasicAuthUrlUtilitiesDefaultSchemeTypeHttp` or 
`CKBasicAuthUrlUtilitiesDefaultSchemeTypeHttps`

But you shouldn't be using BASIC auth over HTTP anyway, so don't do this!

Nil or empty NSStrings should work as expected, see the unit tests for examples and feel free to contribute.


