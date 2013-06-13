//
//  Copyright (c) 2013 Cody Kimberling. All rights reserved.
//  Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
//  •  Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
//  •  Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
//  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

#import "CKBasicAuthUrlUtilitiesTests.h"
#import "CKBasicAuthUrlUtilities.h"

@implementation CKBasicAuthUrlUtilitiesTests

#pragma mark - CKBasicAuthUrlUtilitiesDefaultSchemeType tests

- (void)testBasicAuthUrlUtilitiesDefaultSchemeTypes
{
    STAssertTrue(CKBasicAuthUrlUtilitiesDefaultSchemeTypeHttps == 0, nil);
    STAssertTrue(CKBasicAuthUrlUtilitiesDefaultSchemeTypeHttp == 1, nil);
}

- (void)testBasicAuthUrlUtilitiesDefaultSchemeHttpsOnInit
{
    STAssertTrue(CKBasicAuthUrlUtilities.new.schemeType == CKBasicAuthUrlUtilitiesDefaultSchemeTypeHttps, nil);
}

#pragma mark - NSURL encode tests

- (void)testUrlWithEncodedOrNonEncodedString
{
//    - (NSURL *)urlWithEncodedOrNonEncodedString:(NSString *)encodedOrNonEncodedString;
    STAssertTrue(CKBasicAuthUrlUtilities.new.schemeType == CKBasicAuthUrlUtilitiesDefaultSchemeTypeHttps, nil);
}

//
//#pragma mark - NSURL Update User/Password
//
//- (NSURL *)urlWithUpdatedUsername:(NSString *)username forUrl:(NSURL *)url;
//- (NSURL *)urlWithUpdatedPassword:(NSString *)password forUrl:(NSURL *)url;
//- (NSURL *)urlWithUpdatedUsername:(NSString *)username andPassword:(NSString *)password forUrl:(NSURL *)url;
//
//#pragma mark - NSURL
//
//- (NSURL *)urlWithoutAuthenticationFromUrl:(NSURL *)url;

@end
