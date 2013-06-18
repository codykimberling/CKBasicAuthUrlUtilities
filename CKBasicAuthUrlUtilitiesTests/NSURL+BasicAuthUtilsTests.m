//
//  Copyright (c) 2013 Cody Kimberling. All rights reserved.
//  Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
//  •  Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
//  •  Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
//  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE. 

#import "NSURL+BasicAuthUtilsTests.h"
#import "OCMock.h"
#import "NSURL+BasicAuthUtils.h"
#import "NSString+Utils.h"
#import "CKTestHelpers.h"

static NSString *kScheme = @"https";

@interface NSURL_BasicAuthUtilsTests ()

@property (nonatomic) NSString *oldUser;
@property (nonatomic) NSString *oldPassword;

@property (nonatomic) NSString *updatedUser;
@property (nonatomic) NSString *updatedPassword;

@end

@implementation NSURL_BasicAuthUtilsTests

- (void)setUp
{
    [super setUp];
    
    self.oldUser = @"frank";
    self.oldPassword = @"test123";
    
    self.updatedUser = @"bob";
    self.updatedPassword = @"fluffyKitty99";
}

- (void)testHasScheme
{
    NSURL *urlWithoutScheme = [NSURL URLWithString:@"www.google.com"];
    NSURL *urlWithoutSchemeCustom = [NSURL URLWithString:@"ck.local:8080"];
    NSURL *urlWithScheme = [NSURL URLWithString:@"https://www.google.com"];
    NSURL *urlWithSchemeCustom = [NSURL URLWithString:@"http://ck.local:8080"];

    STAssertFalse(urlWithoutScheme.hasHttpOrHttpsScheme, nil);
    STAssertFalse(urlWithoutSchemeCustom.hasHttpOrHttpsScheme, nil);
    STAssertTrue(urlWithScheme.hasHttpOrHttpsScheme, nil);
    STAssertTrue(urlWithSchemeCustom.hasHttpOrHttpsScheme, nil);
}

- (void)testHasAuthentication
{
    NSURL *urlWithoutUserOrPassword = [NSURL URLWithString:@"https://www.google.com"];
    NSURL *urlWithUserWithoutPassword = [self urlWithUser:@"user" andPassword:nil];
    NSURL *urlWithoutUserWithPassword = [self urlWithUser:nil andPassword:@"password"];
    NSURL *urlWithUserAndPassword = self.urlWithOldUserAndOldPassword;

    STAssertFalse(urlWithoutUserOrPassword.hasAuthentication, nil);
    STAssertTrue(urlWithUserWithoutPassword.hasAuthentication, nil);
    STAssertTrue(urlWithoutUserWithPassword.hasAuthentication, nil);
    STAssertTrue(urlWithUserAndPassword.hasAuthentication, nil);
}

- (void)testUrlWithUpdatedUsernameAndPassword
{
    NSURL *newUrl = [self.urlWithOldUserAndOldPassword urlWithUpdatedUsername:self.updatedUser andPassword:self.updatedPassword withScheme:kScheme];
    
    STAssertEqualObjects(newUrl.user, self.updatedUser, nil);
    STAssertEqualObjects(newUrl.password, self.updatedPassword, nil);
}

- (void)testUrlWithUpdatedUsernameOnly
{
    NSURL *newUrl = [self.urlWithOldUserAndOldPassword urlWithUpdatedUsername:self.updatedUser andPassword:self.oldPassword withScheme:kScheme];
    
    STAssertEqualObjects(newUrl.user, self.updatedUser, nil);
    STAssertEqualObjects(newUrl.password, self.oldPassword, nil);
}

- (void)testUrlWithUpdatedPasswordOnly
{
    NSURL *newUrl = [self.urlWithOldUserAndOldPassword urlWithUpdatedUsername:self.oldUser andPassword:self.updatedPassword withScheme:kScheme];
    
    STAssertEqualObjects(newUrl.user, self.oldUser, nil);
    STAssertEqualObjects(newUrl.password, self.updatedPassword, nil);
}

- (void)testUrlWithUpdatedUsernameOnlyWithNoPreviousUsername
{
    NSURL *oldUrl = [self urlWithUser:@"" andPassword:self.oldPassword];
    NSURL *newUrl = [oldUrl urlWithUpdatedUsername:self.updatedUser andPassword:self.oldPassword withScheme:kScheme];
    
    STAssertEqualObjects(newUrl.user, self.updatedUser, nil);
    STAssertEqualObjects(newUrl.password, self.oldPassword, nil);
}

- (void)testUrlWithUpdatedPasswordOnlyWithNoPreviousPassword
{
    NSURL *oldUrl = [self urlWithUser:self.oldUser andPassword:@""];
    NSURL *newUrl = [oldUrl urlWithUpdatedUsername:self.oldUser andPassword:self.updatedPassword withScheme:kScheme];
    
    STAssertEqualObjects(newUrl.user, self.oldUser, nil);
    STAssertEqualObjects(newUrl.password, self.updatedPassword, nil);
}

- (void)testUrlWithUpdatedUsernameAndPasswordWithNilUser
{
    NSURL *newUrl = [self.urlWithOldUserAndOldPassword urlWithUpdatedUsername:nil andPassword:self.updatedPassword withScheme:kScheme];
    
    STAssertEqualObjects(newUrl.user, @"", nil);
    STAssertEqualObjects(newUrl.password, self.updatedPassword, nil);
}

- (void)testUrlWithUpdatedUsernameAndPasswordWithNilPassword
{
    NSURL *newUrl = [self.urlWithOldUserAndOldPassword urlWithUpdatedUsername:self.updatedUser andPassword:nil withScheme:kScheme];
    
    STAssertEqualObjects(newUrl.user, self.updatedUser, nil);
    STAssertEqualObjects(newUrl.password, @"", nil);
}

- (void)testUrlWithUpdatedUsername
{
    NSURL *newUrl = [self.urlWithOldUserAndOldPassword urlWithUpdatedUsername:self.updatedUser withScheme:kScheme];
    
    STAssertEqualObjects(newUrl.user, self.updatedUser, nil);
    STAssertEqualObjects(newUrl.password, self.urlWithOldUserAndOldPassword.password, nil);
}

- (void)testUrlWithUpdatedUsernameAndPasswordWithEmptyStrings
{
    NSURL *newUrl = [self.urlWithOldUserAndOldPassword urlWithUpdatedUsername:@"" andPassword:@"" withScheme:@"http"];
    NSURL *expectedUrl = [NSURL URLWithString:@"http://www.google.com"];
    
    STAssertEqualObjects(newUrl, expectedUrl, nil);
}

- (void)testUrlWithUpdatedUsernameAndPasswordWithNils
{
    NSURL *newUrl = [self.urlWithOldUserAndOldPassword urlWithUpdatedUsername:nil andPassword:nil withScheme:@"http"];
    NSURL *expectedUrl = [NSURL URLWithString:@"http://www.google.com"];
    
    STAssertEqualObjects(newUrl, expectedUrl, nil);
}

- (void)testUrlWithUpdatedPassword
{
    NSURL *newUrl = [self.urlWithOldUserAndOldPassword urlWithUpdatedPassword:self.updatedPassword withScheme:kScheme];
    
    STAssertEqualObjects(newUrl.user, self.urlWithOldUserAndOldPassword.user, nil);
    STAssertEqualObjects(newUrl.password, self.updatedPassword, nil);
}

- (void)testUrlWithoutAuthentication
{
    NSURL *expectedUrl = [NSURL URLWithString:@"http://www.google.com"];
    
    NSURL *urlWithUserAndPassowrd = self.urlWithOldUserAndOldPassword;
    NSURL *urlWithUserOnly = [self urlWithUser:@"user" andPassword:nil];
    NSURL *urlWithPasswordOnly = [self urlWithUser:nil andPassword:@"password"];
    
    STAssertEqualObjects(urlWithUserAndPassowrd.urlWithoutAuthentication, expectedUrl, nil);
    STAssertEqualObjects(urlWithUserOnly.urlWithoutAuthentication, expectedUrl, nil);
    STAssertEqualObjects(urlWithPasswordOnly.urlWithoutAuthentication, expectedUrl, nil);
}

- (void)testUrlWithDefaultSchemePrependedUsingSchemeWithExistingScheme
{
    NSURL *url = [NSURL URLWithString:@"https://www.yahoo.com"];
    STAssertEquals([url urlWithDefaultSchemePrependedUsingScheme:@"http"], url, @"Objects should be equal, perform no operation if scheme is provided");
}

- (void)testUrlWithDefaultSchemePrependedUsingSchemeWithoutExistingHttpScheme
{
    NSURL *inputUrl = [NSURL URLWithString:@"www.yahoo.com"];
    NSURL *expectedUrl = [NSURL URLWithString:@"http://www.yahoo.com"];
    
    NSURL *actualUrl = [inputUrl urlWithDefaultSchemePrependedUsingScheme:@"http"];
    
    STAssertEqualObjects(actualUrl, expectedUrl, nil);
}

- (void)testUrlWithDefaultSchemePrependedUsingSchemeWithoutExistingHttpsScheme
{
    NSURL *inputUrl = [NSURL URLWithString:@"www.yahoo.com"];
    NSURL *expectedUrl = [NSURL URLWithString:@"https://www.yahoo.com"];
    
    NSURL *actualUrl = [inputUrl urlWithDefaultSchemePrependedUsingScheme:@"https"];
    
    STAssertEqualObjects(actualUrl, expectedUrl, nil);
}

- (void)testBasicAuthenticationStringWithNoUserOrPassword
{
    NSURL *inputUrl = [NSURL URLWithString:@"http://www.yahoo.com"];
    
    NSString *authStringWithoutEncoding = [inputUrl basicAuthenticationStringWithoutEncoding];
    NSString *authStringWithEncoding = [inputUrl basicAuthenticationStringWithEncoding];
    
    STAssertTrue((authStringWithoutEncoding == nil), nil);
    STAssertTrue((authStringWithEncoding == nil), nil);
}

- (void)testBasicAuthenticationStringWithEmptyUserAndPassword
{
    NSURL *inputUrl = [NSURL URLWithString:@"http://:@www.yahoo.com"];
    
    NSString *authStringWithoutEncoding = [inputUrl basicAuthenticationStringWithoutEncoding];
    NSString *authStringWithEncoding = [inputUrl basicAuthenticationStringWithEncoding];
    
    STAssertTrue((authStringWithoutEncoding == nil), nil);
    STAssertTrue((authStringWithEncoding == nil), nil);
}

- (void)testBasicAuthenticationStringWithEmptyUserAndPopulatedPassword
{
    NSString *expectedString = @":pass";
    NSURL *inputUrl = [NSURL URLWithString:@"http://:pass@www.yahoo.com"];
    
    NSString *authStringWithoutEncoding = [inputUrl basicAuthenticationStringWithoutEncoding];
    NSString *authStringWithEncoding = [inputUrl basicAuthenticationStringWithEncoding];

    STAssertEqualObjects(authStringWithoutEncoding, expectedString, nil);
    STAssertEqualObjects(authStringWithEncoding, expectedString, nil);
}

- (void)testBasicAuthenticationStringPopulatedUserAndEmptyPassword
{
    NSString *expectedString = @"user:";
    NSURL *inputUrl = [NSURL URLWithString:@"http://user:@www.yahoo.com"];
    
    NSString *authStringWithoutEncoding = [inputUrl basicAuthenticationStringWithoutEncoding];
    NSString *authStringWithEncoding = [inputUrl basicAuthenticationStringWithEncoding];
    
    STAssertEqualObjects(authStringWithoutEncoding, expectedString, nil);
    STAssertEqualObjects(authStringWithEncoding, expectedString, nil);
}

- (void)testBasicAuthenticationStringPopulatedUsernameAndPassword
{
    NSString *expectedString = @"user:pass";
    NSURL *inputUrl = [NSURL URLWithString:@"http://user:pass@www.yahoo.com"];
    
    NSString *authStringWithoutEncoding = [inputUrl basicAuthenticationStringWithoutEncoding];
    NSString *authStringWithEncoding = [inputUrl basicAuthenticationStringWithEncoding];
    
    STAssertEqualObjects(authStringWithoutEncoding, expectedString, nil);
    STAssertEqualObjects(authStringWithEncoding, expectedString, nil);
}

- (void)testBasicAuthenticationStringNonEncodedUsernameAndPassword
{
    NSString *expectedNonEncodedString = @"user@hotmail.com:pass";
    NSString *expectedEncodedString = @"user%40hotmail.com:pass";
    
    NSURL *inputUrl = [[NSURL URLWithString:@"http://www.yahoo.com"] urlWithUpdatedUsername:@"user@hotmail.com" andPassword:@"pass" withScheme:@"http:"];
    
    NSString *authStringWithoutEncoding = [inputUrl basicAuthenticationStringWithoutEncoding];
    NSString *authStringWithEncoding = [inputUrl basicAuthenticationStringWithEncoding];
    
    STAssertEqualObjects(authStringWithoutEncoding, expectedNonEncodedString, nil);
    STAssertEqualObjects(authStringWithEncoding, expectedEncodedString, nil);
}

#pragma mark - Test helpers

- (NSURL *)urlWithOldUserAndOldPassword
{
    return [self urlWithUser:self.oldUser andPassword:self.oldPassword];
}

- (NSURL *)urlWithUser:(NSString *)user andPassword:(NSString *)password
{
    NSString *urlString = [NSString stringWithFormat:@"http://%@:%@@www.google.com", (user) ? user : @"", (password) ? password : @""];
    return [NSURL URLWithString:urlString];
}

@end