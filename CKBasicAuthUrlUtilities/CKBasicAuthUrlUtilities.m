//
//  Copyright (c) 2013 Cody Kimberling. All rights reserved.
//  Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
//  •  Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
//  •  Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
//  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

#import "CKBasicAuthUrlUtilities.h"
#import "NSURL+BasicAuthUtils.h"
#import "NSString+BasicAuthUtils.h"
#import "CKStringUtils.h"

@interface CKBasicAuthUrlUtilities ()

- (NSString *)scheme;

@end

@implementation CKBasicAuthUrlUtilities

#pragma mark - Initialization

- (id)init
{
    if(self = [super init]){
        self.schemeType = CKBasicAuthUrlUtilitiesDefaultSchemeTypeHttps;
    }
    return self;
}

- (id)initWithDefaultSchemeType:(CKBasicAuthUrlUtilitiesDefaultSchemeType)schemeType
{
    if(self = [super init]){
        self.schemeType = schemeType;
    }
    return self;
}

#pragma mark - NSURL encode string if needed

- (NSURL *)urlWithUtf8EncodingForString:(NSString *)nonEncodedString
{
    NSString *encodedString = [nonEncodedString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSURL *url = [NSURL URLWithString:encodedString];
    
    return [url urlWithDefaultSchemePrependedUsingScheme:self.scheme];
}

#pragma mark - NSURL Update User/Password

- (NSURL *)urlWithUpdatedUsername:(NSString *)username forUrl:(NSURL *)url
{
    return [url urlWithUpdatedUsername:username withScheme:self.scheme];
}

- (NSURL *)urlWithUpdatedPassword:(NSString *)password forUrl:(NSURL *)url
{
    return [url urlWithUpdatedPassword:password withScheme:self.scheme];
}

- (NSURL *)urlWithUpdatedUsername:(NSString *)username andPassword:(NSString *)password forUrl:(NSURL *)url
{
    return [url urlWithUpdatedUsername:username andPassword:password withScheme:self.scheme];
}

#pragma mark - NSURL

- (NSURL *)urlWithoutAuthenticationFromUrl:(NSURL *)url
{
    return [url.urlWithoutAuthentication urlWithDefaultSchemePrependedUsingScheme:self.scheme];
}

#pragma mark - BOOL

- (BOOL)urlHasHttpOrHttpsScheme:(NSURL *)url
{
    return url.hasHttpOrHttpsScheme;
}

- (BOOL)urlHasAuthentication:(NSURL *)url
{
    return url.hasAuthentication;
}

- (NSString *)scheme
{
    return (self.schemeType == CKBasicAuthUrlUtilitiesDefaultSchemeTypeHttps) ? @"https" : @"http";
}

- (BOOL)doesStringContainIllegalUrlCharacters:(NSString *)string
{
    return string.doesStringContainIllegalUrlCharacters;
}

#pragma mark - NSString methods

- (NSString *)absoluteStringWithoutAuthenticationForUrl:(NSURL *)url
{
    return url.urlWithoutAuthentication.absoluteString;
}

- (NSString *)absoluteStringObfuscatedPassword:(NSURL *)url
{
    if(!url.hasAuthentication){
        return url.absoluteString;
    }
    
    NSString *passwordString = [NSString stringWithFormat:@":%@@", url.password];
    
    return [url.absoluteString stringByReplacingOccurrencesOfString:passwordString withString:@":****@"];
}

- (NSString *)basicAuthenticationStringWithEncodingForUrl:(NSURL *)url
{
    return url.basicAuthenticationStringWithEncoding;
}

- (NSString *)basicAuthenticationStringWithoutEncodingForUrl:(NSURL *)url
{
    return url.basicAuthenticationStringWithoutEncoding;
}

- (NSString *)urlSafeStringFromString:(NSString *)string
{
    return [CKStringUtils isNil:string] ? nil : string.urlSafeString;
}

#pragma mark - NSURLRequest methods

- (NSMutableURLRequest *)urlRequestWithPreemptiveBasicAuthenticationWithUrl:(NSURL *)url
{
    return (!url) ? nil : [self urlRequestWithPreemptiveBasicAuthenticationWithNonNilUrl:url];
}

- (NSMutableURLRequest *)urlRequestWithPreemptiveBasicAuthenticationWithNonNilUrl:(NSURL *)url
{
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    if([self urlHasAuthentication:url]){
        
        NSString *usernamePasswordString = [NSString stringWithFormat:@"%@:%@", url.user, url.password];
        NSData *data = [self dataFromBase64String:usernamePasswordString];
        
        NSString *base64String = [self base64EncodedStringForData:data];
        
        NSString *authenticationValue = [NSString stringWithFormat:@"Basic %@", base64String];
        
        [request setValue:authenticationValue forHTTPHeaderField:@"Authorization"];
    }
    return request;
}

- (NSData *)dataFromBase64String:(NSString *)string
{
    return [CKStringUtils isNil:string] ? nil : [string dataUsingEncoding:NSUTF8StringEncoding];
}

- (NSString *)base64EncodedStringForData:(NSData *)data
{
    return [data base64EncodedStringWithOptions:0];
}


@end