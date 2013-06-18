//
//  Copyright (c) 2013 Cody Kimberling. All rights reserved.
//  Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
//  •  Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
//  •  Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
//  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

#import <Foundation/Foundation.h>

typedef enum : NSInteger {
    CKBasicAuthUrlUtilitiesDefaultSchemeTypeHttps,
    CKBasicAuthUrlUtilitiesDefaultSchemeTypeHttp
}  CKBasicAuthUrlUtilitiesDefaultSchemeType;

@interface CKBasicAuthUrlUtilities : NSObject

// scheme type, default is HTTPS
@property (nonatomic) CKBasicAuthUrlUtilitiesDefaultSchemeType schemeType;

- (id)initWithDefaultSchemeType:(CKBasicAuthUrlUtilitiesDefaultSchemeType)schemeType;

#pragma mark - NSURL encode string if needed

//  Creates a NSURL with a non-encoded string, percent escaping the non-encoded string with NSUTF8StringEncoding
//  If URL does not contain a scheme, the default scheme is used
//  Returns nil if nonEncodedString is nil
- (NSURL *)urlWithUtf8EncodingForString:(NSString *)nonEncodedString;

#pragma mark - NSURL Update User/Password

//  Returns a NSURL with an updated username (username encoded if needed)
//  If URL does not contain a scheme, the default scheme is used
//  Returns nil if url is nil
- (NSURL *)urlWithUpdatedUsername:(NSString *)username forUrl:(NSURL *)url;

//  Returns a NSURL with an updated password (password encoded if needed)
//  If URL does not contain a scheme, the default scheme is used
//  Returns nil if url is nil
- (NSURL *)urlWithUpdatedPassword:(NSString *)password forUrl:(NSURL *)url;

//  Returns a NSURL with an updated username and password (username and password will be encoded if needed)
//  If URL does not contain a scheme, the default scheme is used
//  Returns nil if url is nil
- (NSURL *)urlWithUpdatedUsername:(NSString *)username andPassword:(NSString *)password forUrl:(NSURL *)url;

#pragma mark - NSURL 

//  Returns a NSURL with the authentication components stripped out
//  Returns nil if url is nil
- (NSURL *)urlWithoutAuthenticationFromUrl:(NSURL *)url;

#pragma mark - BOOL methods

//  Returns YES if URL contains HTTP or HTTPS scheme
//  Returns NO if url is nil
- (BOOL)urlHasHttpOrHttpsScheme:(NSURL *)url;

//  Returns YES if URL contains components for BASIC authentication
//  Returns NO if url is nil
- (BOOL)urlHasAuthentication:(NSURL *)url;

#pragma mark - NSString methods

//  Returns an absolute string represntation of a given url without the authentication components
//  Returns nil if url is nil
- (NSString *)absoluteStringWithoutAuthenticationForUrl:(NSURL *)url;

//  Returns an absolute string represntation of a given url with the password obfuscated
//  Returns nil if url is nil
- (NSString *)absoluteStringObfuscatedPassword:(NSURL *)url;

//  Returns a basic authentication string (encoded) from a given url, returns nil if url does not contain an auth string
//  Returns nil if url is nil
- (NSString *)basicAuthenticationStringWithEncodingForUrl:(NSURL *)url;

//  Returns a basic authentication string (non-encoded) from a given url, returns nil if url does not contain an auth string
//  Returns nil if url is nil
- (NSString *)basicAuthenticationStringWithoutEncodingForUrl:(NSURL *)url;

#pragma mark - NSURLRequest methods

//  Preempt Authentication callbacks by initializing a NSMutableURLRequest with the provided url.
//  If given URL has authentication, then add basic authentication to url request preemptively.
//  This can be used when the server returns a 401 without a 403 response and the standard NSURLConnectionDelegate
//  willSendRequestForAuthenticationChallenge is not automatically called
//  Returns nil if url is nil
- (NSMutableURLRequest *)urlRequestWithPreemptiveBasicAuthenticationWithUrl:(NSURL *)url;

#pragma mark - NSData-Base64 methods
//  Methods from NSData-Base64 (https://github.com/l4u/NSData-Base64/blob/master/NSData%2BBase64.h)

//  Returns NSData fromm a Base64 encoded string
//  Returns nil if string is nil
- (NSData *)dataFromBase64String:(NSString *)string;

//  Returns a NSString Base64 encoded
//  Returns nil if data is nil
- (NSString *)base64EncodedStringForData:(NSData *)data;

@end