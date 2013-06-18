//
//  Copyright (c) 2013 Cody Kimberling. All rights reserved.
//  Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
//  •  Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
//  •  Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
//  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

#import "CKBasicAuthUrlUtilitiesTests.h"
#import "OCMock.h"
#import "CKBasicAuthUrlUtilities.h"
#import "NSString+BasicAuthUtils.h"
#import "NSURL+BasicAuthUtils.h"
#import "CKTestHelpers.h"
#import "NSData+Base64.h"

@interface CKBasicAuthUrlUtilitiesTests ()

@property (nonatomic) CKBasicAuthUrlUtilities *utilitiesHttpScheme;
@property (nonatomic) CKBasicAuthUrlUtilities *utilitiesHttpsScheme;
@property (nonatomic) id mockUrl;
@property (nonatomic) id mockString;
@property (nonatomic) id mockData;

@end

@implementation CKBasicAuthUrlUtilitiesTests

- (void)setUp
{
    [super setUp];
    
    self.mockUrl = [OCMockObject niceMockForClass:NSURL.class];
    self.mockString = [OCMockObject niceMockForClass:NSString.class];
    self.mockData = [OCMockObject niceMockForClass:NSData.class];
    
    self.utilitiesHttpScheme = CKBasicAuthUrlUtilities.new;
    self.utilitiesHttpScheme.schemeType = CKBasicAuthUrlUtilitiesDefaultSchemeTypeHttp;
    
    self.utilitiesHttpsScheme = CKBasicAuthUrlUtilities.new;
}

#pragma mark - CKBasicAuthUrlUtilitiesDefaultSchemeType tests

- (void)testBasicAuthUrlUtilitiesDefaultSchemeTypes
{
    STAssertTrue(CKBasicAuthUrlUtilitiesDefaultSchemeTypeHttps == 0, nil);
    STAssertTrue(CKBasicAuthUrlUtilitiesDefaultSchemeTypeHttp == 1, nil);
}

- (void)testBasicAuthUrlUtilitiesDefaultSchemeHttpsOnInit
{
    STAssertTrue(CKBasicAuthUrlUtilities.new.schemeType == CKBasicAuthUrlUtilitiesDefaultSchemeTypeHttps, nil);
    STAssertTrue(self.utilitiesHttpsScheme.schemeType == CKBasicAuthUrlUtilitiesDefaultSchemeTypeHttps, nil);
    STAssertTrue(self.utilitiesHttpScheme.schemeType == CKBasicAuthUrlUtilitiesDefaultSchemeTypeHttp, nil);
}

- (void)testSchemeTranslation
{    
    STAssertEqualObjects(self.utilitiesHttpsScheme.scheme, @"https", nil);
    STAssertEqualObjects(self.utilitiesHttpScheme.scheme, @"http", nil);
}

#pragma mark - NSURL encode tests

- (void)testUrlWithUtf8EncodingForString
{
    NSString *nonEncodedString = @"http://www.google.com/?q=whoami?";
    NSString *encodedString = @"http://www.google.com/?q=whoami%3F";

    NSString *expectedUrl = [NSURL URLWithString:nonEncodedString];
    
    [[[self.mockString expect] andReturn:encodedString] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [[[self.mockUrl expect] andReturn:expectedUrl] URLWithString:encodedString];

    NSURL *actualUrl = [self.utilitiesHttpScheme urlWithUtf8EncodingForString:self.mockString];

    [self.mockString verify];
    [self.mockUrl verify];

    STAssertEquals(actualUrl, expectedUrl, nil);
}

- (void)testUrlWithUtf8EncodingForStringWithoutScheme
{
    NSString *urlWithoutScheme = @"www.google.com";
    
    NSURL *expectedUrlForHttpScheme = [NSURL URLWithString:@"http://www.google.com"];
    NSURL *expectedUrlForHttpsScheme = [NSURL URLWithString:@"https://www.google.com"];
    
    NSURL *actualUrlForHttpScheme = [self.utilitiesHttpScheme urlWithUtf8EncodingForString:urlWithoutScheme];
    NSURL *actualUrlForHttpsScheme = [self.utilitiesHttpsScheme urlWithUtf8EncodingForString:urlWithoutScheme];
    
    STAssertEqualObjects(actualUrlForHttpScheme, expectedUrlForHttpScheme, nil);
    STAssertEqualObjects(actualUrlForHttpsScheme, expectedUrlForHttpsScheme, nil);
}


#pragma mark - NSURL Update User/Password Tests

- (void)testUrlWithUpdatedUsername
{
    [self verifyUrlWithUpdatedUsernameWithSchemeType:CKBasicAuthUrlUtilitiesDefaultSchemeTypeHttp];
    [self verifyUrlWithUpdatedUsernameWithSchemeType:CKBasicAuthUrlUtilitiesDefaultSchemeTypeHttps];
}

- (void)testUrlWithUpdatedPassword
{
    [self verifyUrlWithUpdatedPasswordWithSchemeType:CKBasicAuthUrlUtilitiesDefaultSchemeTypeHttp];
    [self verifyUrlWithUpdatedPasswordWithSchemeType:CKBasicAuthUrlUtilitiesDefaultSchemeTypeHttps];
}

- (void)testUrlWithUpdatedUsernameAndPassword
{
    [self verifyUrlWithUpdatedUsernameAndPasswordWithSchemeType:CKBasicAuthUrlUtilitiesDefaultSchemeTypeHttp];
    [self verifyUrlWithUpdatedUsernameAndPasswordWithSchemeType:CKBasicAuthUrlUtilitiesDefaultSchemeTypeHttps];
}

- (void)verifyUrlWithUpdatedUsernameWithSchemeType:(CKBasicAuthUrlUtilitiesDefaultSchemeType)schemeType
{
    CKBasicAuthUrlUtilities *utils = (schemeType == CKBasicAuthUrlUtilitiesDefaultSchemeTypeHttps) ? self.utilitiesHttpsScheme : self.utilitiesHttpScheme;
    NSURL *expectedUrl = NSURL.new;
    
    [[[self.mockUrl expect] andReturn:expectedUrl] urlWithUpdatedUsername:self.mockString withScheme:utils.scheme];
    
    NSURL *actualUrl = [utils urlWithUpdatedUsername:self.mockString forUrl:self.mockUrl];
    
    [self.mockUrl verify];
    
    STAssertEquals(actualUrl, expectedUrl, nil);
}

- (void)verifyUrlWithUpdatedPasswordWithSchemeType:(CKBasicAuthUrlUtilitiesDefaultSchemeType)schemeType
{
    CKBasicAuthUrlUtilities *utils = (schemeType == CKBasicAuthUrlUtilitiesDefaultSchemeTypeHttps) ? self.utilitiesHttpsScheme : self.utilitiesHttpScheme;
    NSURL *expectedUrl = NSURL.new;
    
    [[[self.mockUrl expect] andReturn:expectedUrl] urlWithUpdatedPassword:self.mockString withScheme:utils.scheme];
    
    NSURL *actualUrl = [utils urlWithUpdatedPassword:self.mockString forUrl:self.mockUrl];
    
    [self.mockUrl verify];
    
    STAssertEquals(actualUrl, expectedUrl, nil);
}

- (void)verifyUrlWithUpdatedUsernameAndPasswordWithSchemeType:(CKBasicAuthUrlUtilitiesDefaultSchemeType)schemeType
{
    id mockUsernameString = self.mockString;
    id mockPasswordString = [OCMockObject niceMockForClass:NSString.class];
    
    CKBasicAuthUrlUtilities *utils = (schemeType == CKBasicAuthUrlUtilitiesDefaultSchemeTypeHttps) ? self.utilitiesHttpsScheme : self.utilitiesHttpScheme;
    NSURL *expectedUrl = NSURL.new;
    
    [[[self.mockUrl expect] andReturn:expectedUrl] urlWithUpdatedUsername:mockUsernameString andPassword:mockPasswordString withScheme:utils.scheme];
    
    NSURL *actualUrl = [utils urlWithUpdatedUsername:mockUsernameString andPassword:mockPasswordString forUrl:self.mockUrl];
    
    [self.mockUrl verify];
    
    STAssertEquals(actualUrl, expectedUrl, nil);
}

#pragma mark - NSURL Tests

- (void)testAbsoluteStringWithoutAuthenticationForUrlWithAuth
{
    NSURL *url = [NSURL URLWithString:@"http://user:pass@www.google.com"];
    NSString *expected = @"http://www.google.com";
    
    NSString *actual = [self.utilitiesHttpScheme absoluteStringWithoutAuthenticationForUrl:url];
    
    STAssertEqualObjects(expected, actual, nil);
}

- (void)testAbsoluteStringWithoutAuthenticationForUrlWithoutAuth
{
    NSURL *url = [NSURL URLWithString:@"http://www.google.com"];
    NSString *expected = @"http://www.google.com";
    
    NSString *actual = [self.utilitiesHttpScheme absoluteStringWithoutAuthenticationForUrl:url];
    
    STAssertEqualObjects(expected, actual, nil);
}

- (void)testAbsoluteStringObfuscatedPasswordWithAuth
{
    NSURL *url = [NSURL URLWithString:@"http://user:pass@www.google.com"];
    NSString *expected = @"http://user:****@www.google.com";
    
    NSString *actual = [self.utilitiesHttpScheme absoluteStringObfuscatedPassword:url];
    
    STAssertEqualObjects(expected, actual, nil);
}

- (void)testAbsoluteStringObfuscatedPasswordWithoutAuth
{
    NSURL *url = [NSURL URLWithString:@"http://www.google.com"];
    NSString *expected = @"http://www.google.com";
    
    NSString *actual = [self.utilitiesHttpScheme absoluteStringObfuscatedPassword:url];
    
    STAssertEqualObjects(expected, actual, nil);
}

- (void)testUrlWithoutAuthenticationFromUrl
{
    NSURL *expectedUrl = NSURL.new;
    
    [[[self.mockUrl expect] andReturn:expectedUrl] urlWithoutAuthentication];
    
    NSURL *actualUrl = [self.utilitiesHttpsScheme urlWithoutAuthenticationFromUrl:self.mockUrl];
    
    [self.mockUrl verify];
    
    STAssertEquals(actualUrl, expectedUrl, nil);
}

#pragma mark BOOL methods

- (void)testUrlHasSchemeReturnsTrue
{
    BOOL returnValue = YES;
    
    [[[self.mockUrl expect] andReturnValue:OCMOCK_VALUE(returnValue)] hasHttpOrHttpsScheme];
    
    BOOL result = [self.utilitiesHttpScheme urlHasHttpOrHttpsScheme:self.mockUrl];
    
    [self.mockUrl verify];
    
    STAssertTrue(result, nil);
}

- (void)testUrlHasSchemeReturnsFalse
{
    BOOL returnValue = NO;
    
    [[[self.mockUrl expect] andReturnValue:OCMOCK_VALUE(returnValue)] hasHttpOrHttpsScheme];
    
    BOOL result = [self.utilitiesHttpScheme urlHasHttpOrHttpsScheme:self.mockUrl];
    
    [self.mockUrl verify];
    
    STAssertFalse(result, nil);
}

- (void)testUrlHasAuthenticationReturnsTrue
{
    BOOL returnValue = YES;
    
    [[[self.mockUrl expect] andReturnValue:OCMOCK_VALUE(returnValue)] hasAuthentication];
    
    BOOL result = [self.utilitiesHttpScheme urlHasAuthentication:self.mockUrl];
    
    [self.mockUrl verify];
    
    STAssertTrue(result, nil);
}

- (void)testUrlHasAuthenticationReturnsFalse
{
    BOOL returnValue = NO;
    
    [[[self.mockUrl expect] andReturnValue:OCMOCK_VALUE(returnValue)] hasAuthentication];
    
    BOOL result = [self.utilitiesHttpScheme urlHasAuthentication:self.mockUrl];
    
    [self.mockUrl verify];
    
    STAssertFalse(result, nil);
}

- (void)testAuthenticationStringWithEncodingForUrl
{
    NSString *expected = @"user:pass";
    
    [[[self.mockUrl expect] andReturn:expected] basicAuthenticationStringWithEncoding];
    
    NSString *actual = [self.utilitiesHttpScheme basicAuthenticationStringWithEncodingForUrl:self.mockUrl];
    
    [self.mockUrl verify];
    
    STAssertEqualObjects(actual, expected, nil);
}

- (void)testAuthenticationStringWithoutEncodingForUrl
{
    NSString *expected = @"user:pass";
    
    [[[self.mockUrl expect] andReturn:expected] basicAuthenticationStringWithoutEncoding];
    
    NSString *actual = [self.utilitiesHttpScheme basicAuthenticationStringWithoutEncodingForUrl:self.mockUrl];
    
    [self.mockUrl verify];
    
    STAssertEqualObjects(actual, expected, nil);
}

#pragma mark - NSURLRequest

- (void)testUrlRequestReturnsInitializedRequesstWithoutAuthHeaderIfUrlDoesNotProvideUsernameOrPassword
{
    NSURL *expected = [NSURL URLWithString:@"http://www.yahoo.com"];
    
    NSMutableURLRequest *actual = [self.utilitiesHttpScheme urlRequestWithPreemptiveBasicAuthenticationWithUrl:expected];
    
    id value = [actual.allHTTPHeaderFields objectForKey:@"Authorization"];
    
    STAssertTrue((value == nil), nil);
    STAssertEqualObjects(actual.URL, expected, nil);
}

- (void)testUrlRequestReturnsInitializedRequesstWithoutAuthHeaderIfUrlDoesNotProvideUsernameOrPassword_
{
    id partialMockUtils = [OCMockObject partialMockForObject:self.utilitiesHttpScheme];
    
    NSURL *url = [NSURL URLWithString:@"http://user:password@www.yahoo.com"];
    NSString *encodedString = @"TESTING";
    NSString *expectedString = [NSString stringWithFormat:@"Basic %@", encodedString];
    
    [[[partialMockUtils expect] andReturn:self.mockString] basicAuthenticationStringWithEncodingForUrl:url];
    
    [[[self.mockString expect] andReturn:self.mockData] dataUsingEncoding:NSASCIIStringEncoding];
    
    [[[partialMockUtils expect] andReturn:encodedString] base64EncodedStringForData:self.mockData];
    
    
    NSMutableURLRequest *actual = [self.utilitiesHttpScheme urlRequestWithPreemptiveBasicAuthenticationWithUrl:url];
    
    id value = [actual.allHTTPHeaderFields objectForKey:@"Authorization"];
    
    [partialMockUtils verify];
    [self.mockString verify];
    
    STAssertEqualObjects(value, expectedString, nil);
    STAssertEqualObjects(actual.URL, url, nil);
    
    [partialMockUtils stopMocking];
}

#pragma mark - NSData-Base64 methods

- (void)testDataFromBase64String
{
    NSString *inputString = @"TEST";
    NSData *expected = NSData.new;
    
    [[[self.mockData expect] andReturn:expected] dataFromBase64String:inputString];
    
    NSData *actual = [self.utilitiesHttpScheme dataFromBase64String:inputString];
    
    [self.mockData verify];
    
    STAssertEqualObjects(actual, expected, nil);
}

- (void)testBase64EncodedStringForData
{
    NSString *expected = @"TEST";
    
    [[[self.mockData expect] andReturn:expected] base64EncodedString];
    
    NSString *actual = [self.utilitiesHttpScheme base64EncodedStringForData:self.mockData];
    
    [self.mockData verify];
    
    STAssertEqualObjects(actual, expected, nil);
}

@end