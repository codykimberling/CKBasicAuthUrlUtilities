//
//  Copyright (c) 2013 Cody Kimberling. All rights reserved.
//  Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
//  •  Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
//  •  Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
//  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

#import "NSURL+BasicAuthUtils.h"
#import "NSString+BasicAuthUtils.h"
#import "CKStringUtils.h"

@implementation NSURL (BasicAuthUtils)

- (BOOL)hasHttpOrHttpsScheme
{
    return [@[@"http", @"https"] containsObject:self.scheme];
}

- (BOOL)hasAuthentication
{
    return [CKStringUtils isNotEmpty:self.user] || [CKStringUtils isNotEmpty:self.password];
}

#pragma mark - Update username or password Tests

- (NSURL *)urlWithUpdatedUsername:(NSString *)username withScheme:(NSString *)scheme
{
    return [self urlWithUpdatedUsername:username andPassword:self.password withScheme:scheme];
}

- (NSURL *)urlWithUpdatedPassword:(NSString *)password  withScheme:(NSString *)scheme
{
    return [self urlWithUpdatedUsername:self.user andPassword:password withScheme:scheme];
}

- (NSURL *)urlWithUpdatedUsername:(NSString *)username andPassword:(NSString *)password withScheme:(NSString *)scheme
{
    NSURL *url = [self urlWithDefaultSchemePrependedUsingScheme:scheme];
    
    NSString *oldAuthString = (url.hasAuthentication) ? [self.absoluteString basicAuthStringWithUser:url.user.urlSafeString andPassword:url.password.urlSafeString] : @"";

    NSString *newAuthString = ([CKStringUtils isNotEmpty:username] || [CKStringUtils isNotEmpty:password]) ? [self.absoluteString basicAuthStringWithUser:username andPassword:password] : @"";
    
    NSString *newUrlString;
    
    if([CKStringUtils isNotEmpty:oldAuthString]){
        newUrlString = [url.absoluteString
                        stringByReplacingOccurrencesOfString:oldAuthString
                        withString:newAuthString
                        options:NSCaseInsensitiveSearch
                        range:NSMakeRange(0, url.absoluteString.length)];
    }else{
        newUrlString = [url.absoluteString
                        stringByReplacingOccurrencesOfString:@"://"
                        withString:[NSString stringWithFormat:@"://%@", newAuthString]
                        options:NSCaseInsensitiveSearch
                        range:NSMakeRange(0, url.absoluteString.length)];
    }
    
    return [NSURL URLWithString:newUrlString];
}

- (NSURL *)urlWithoutAuthentication
{
    if (!self.hasAuthentication || (self.urlAuthDoesNotContainUsername && self.urlAuthDoesNotContainPassword)) {
        return self;
    }

    NSString *targetString = [NSString stringWithFormat:@"%@:%@@", self.user.urlSafeString, self.password.urlSafeString];
    
    NSString *updatedAbsoluteString = [self.absoluteString stringByReplacingOccurrencesOfString:targetString withString:@""];
    
    return [NSURL URLWithString:updatedAbsoluteString];
}

- (NSURL *)urlWithDefaultSchemePrependedUsingScheme:(NSString *)scheme
{
    return (self.hasHttpOrHttpsScheme) ? self : [NSURL URLWithString:[NSString stringWithFormat:@"%@://%@", scheme, self.absoluteString]];
}

- (BOOL)urlAuthContainsUsername
{
    return [self.absoluteString rangeOfString:[NSString stringWithFormat:@"%@:", self.user.urlSafeString]].location == NSNotFound;
}

- (BOOL)urlAuthDoesNotContainUsername
{
    return ![self urlContainsString:[NSString stringWithFormat:@"%@:", self.user.urlSafeString]];
}

- (BOOL)urlAuthDoesNotContainPassword
{
    return ![self urlContainsString:[NSString stringWithFormat:@":%@@", self.password.urlSafeString]];
}

- (BOOL)urlContainsString:(NSString *)string
{
    return [self.absoluteString rangeOfString:string].location != NSNotFound;
}

- (NSString *)basicAuthenticationStringWithoutEncoding
{
    return [self basicAuthenticationStringShouldEncodeResult:NO];
}

- (NSString *)basicAuthenticationStringWithEncoding
{
    return [self basicAuthenticationStringShouldEncodeResult:YES];
}

- (NSString *)basicAuthenticationStringShouldEncodeResult:(BOOL)shouldEncode
{
    if(self.hasAuthentication){
        if(shouldEncode){
            return [NSString stringWithFormat:@"%@:%@", self.user.urlSafeString, self.password.urlSafeString];
        }
        return [NSString stringWithFormat:@"%@:%@", self.user, self.password];
    }
    return nil;
}

@end