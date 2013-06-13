//
//  Copyright (c) 2013 Cody Kimberling. All rights reserved.
//  Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
//  •  Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
//  •  Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
//  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

#import "CKBasicAuthUrlUtilities.h"
#import "NSURL+BasicAuthUtils.h"
#import "NSString+BasicAuthUtils.h"

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

- (NSURL *)urlWithEncodedOrNonEncodedString:(NSString *)encodedOrNonEncodedString
{
    return [NSURL URLWithString:encodedOrNonEncodedString.urlSafeString];
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
    return url.urlWithoutAuthentication;
}

- (NSString *)scheme
{
    return (self.schemeType == CKBasicAuthUrlUtilitiesDefaultSchemeTypeHttps) ? @"https" : @"http";
}

@end