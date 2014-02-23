##   CKBasicAuthUrlUtilities

###  Let's face it, dealing with BASIC authentication using NSURLs is a pain in the ass, this utility makes it slightly less painful.

Install via Cocoapods, add a line, like the one below, in your Podfile:

`pod 'CKBasicAuthUrlUtilities',	'~> 0.0.6'`

Then, um...use it:

	CKBasicAuthUrlUtilities urlUtilities = CKBasicAuthUrlUtilities.new;

Let's see what we can do:

Create a NSURL with a non-encoded string, percent escaping the non-encoded string with NSUTF8StringEncoding (prepends default scheme if missing)
Returns nil if nonEncodedString is nil.

	- (NSURL *)urlWithUtf8EncodingForString:(NSString *)nonEncodedString;

NSURL with an updated username, username encoded if needed (prepends default scheme if missing).  Returns nil if url is nil.

	- (NSURL *)urlWithUpdatedUsername:(NSString *)username forUrl:(NSURL *)url;

NSURL with an updated password, password encoded if needed (prepends default scheme if missing).  Returns nil if url is nil.

	- (NSURL *)urlWithUpdatedPassword:(NSString *)password forUrl:(NSURL *)url;

NSURL with an updated username and password, username and password will be encoded if needed (prepends default scheme if missing).  Returns nil if url is nil.

	- (NSURL *)urlWithUpdatedUsername:(NSString *)username andPassword:(NSString *)password forUrl:(NSURL *)url;

NSURL with the authentication components stripped out.  Returns nil if url is nil.

	- (NSURL *)urlWithoutAuthenticationFromUrl:(NSURL *)url;

Return YES if URL has a HTTP or HTTPS scheme.  Returns NO if url is nil.
	
	- (BOOL)urlHasHttpOrHttpsScheme:(NSURL *)url;

Return YES if URL contains components for BASIC authentication.  Returns NO if url is nil.

	- (BOOL)urlHasAuthentication:(NSURL *)url;


Return an absolute string represntation of a given url without the authentication components.  Returns nil if url is nil.

	- (NSString *)absoluteStringWithoutAuthenticationForUrl:(NSURL *)url;

Return an absolute string represntation of a given url with the password obfuscated.  Returns nil if url is nil.

	- (NSString *)absoluteStringObfuscatedPassword:(NSURL *)url;

Return a basic authentication string (encoded) from a given url, returns nil if url does not contain an auth string.  Returns nil if url is nil.

	- (NSString *)basicAuthenticationStringWithEncodingForUrl:(NSURL *)url;

Return a basic authentication string (non-encoded) from a given url, returns nil if url does not contain an auth string.  Returns nil if url is nil.

	- (NSString *)basicAuthenticationStringWithoutEncodingForUrl:(NSURL *)url;

Preempt Authentication callbacks by initializing a NSMutableURLRequest with the provided url.
If given URL has authentication, then add basic authentication to url request preemptively.
This can be used when the server returns a 401 without a 403 response and the standard NSURLConnectionDelegate willSendRequestForAuthenticationChallenge is not automatically called 
Returns nil if url is nil.

	- (NSMutableURLRequest *)urlRequestWithPreemptiveBasicAuthenticationWithUrl:(NSURL *)url;
    
Returns a URL safe string, encodes illegal characters.  Returns nil if string is nil
    
    - (NSString *)urlSafeStringFromString:(NSString *)string;

Returns YES if string contains illegal URL characters.  Returns NO if the string does not contain illegal characters or if the string is nil.

    - (BOOL)doesStringContainIllegalUrlCharacters:(NSString *)string;

----

If the [URL scheme component](http://en.wikipedia.org/wiki/URI_scheme#Official_IANA-registered_schemes) is missing in your NSURL,  CKBasicAuthUrlUtilities  automatically uses https by default, but can use http if desired.  It can be set via a property after initialization or on creation:

	urlUtils.schemeType = (CKBasicAuthUrlUtilitiesDefaultSchemeType);

or 

	urlUtils = [[CKBasicAuthUrlUtilities alloc] initWithDefaultSchemeType:(CKBasicAuthUrlUtilitiesDefaultSchemeType)];


where `CKBasicAuthUrlUtilitiesDefaultSchemeType` is either:

`CKBasicAuthUrlUtilitiesDefaultSchemeTypeHttp` or 
`CKBasicAuthUrlUtilitiesDefaultSchemeTypeHttps`

But you shouldn't be using basic auth over HTTP anyway, so don't do this!
