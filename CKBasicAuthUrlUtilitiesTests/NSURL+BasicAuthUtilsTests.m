//
//  Copyright (c) 2013 Cody Kimberling. All rights reserved.
//  Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
//  •  Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
//  •  Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
//  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE. 

#import "NSURL+BasicAuthUtilsTests.h"
#import "OCMock.h"
#import "NSURL+BasicAuthUtils.h"
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

    XCTAssertFalse(urlWithoutScheme.hasHttpOrHttpsScheme);
    XCTAssertFalse(urlWithoutSchemeCustom.hasHttpOrHttpsScheme);
    XCTAssertTrue(urlWithScheme.hasHttpOrHttpsScheme);
    XCTAssertTrue(urlWithSchemeCustom.hasHttpOrHttpsScheme);
}

- (void)testHasAuthentication
{
    NSURL *urlWithoutUserOrPassword = [NSURL URLWithString:@"https://www.google.com"];
    NSURL *urlWithUserWithoutPassword = [self urlWithUser:@"user" andPassword:nil];
    NSURL *urlWithoutUserWithPassword = [self urlWithUser:nil andPassword:@"password"];
    NSURL *urlWithUserAndPassword = self.urlWithOldUserAndOldPassword;

    XCTAssertFalse(urlWithoutUserOrPassword.hasAuthentication);
    XCTAssertTrue(urlWithUserWithoutPassword.hasAuthentication);
    XCTAssertTrue(urlWithoutUserWithPassword.hasAuthentication);
    XCTAssertTrue(urlWithUserAndPassword.hasAuthentication);
}

- (void)testUrlWithUpdatedUsernameAndPassword
{
    NSURL *newUrl = [self.urlWithOldUserAndOldPassword urlWithUpdatedUsername:self.updatedUser andPassword:self.updatedPassword withScheme:kScheme];
    
    XCTAssertEqualObjects(newUrl.user, self.updatedUser);
    XCTAssertEqualObjects(newUrl.password, self.updatedPassword);
}

- (void)testUrlWithUpdatedUsernameOnly
{
    NSURL *newUrl = [self.urlWithOldUserAndOldPassword urlWithUpdatedUsername:self.updatedUser andPassword:self.oldPassword withScheme:kScheme];
    
    XCTAssertEqualObjects(newUrl.user, self.updatedUser);
    XCTAssertEqualObjects(newUrl.password, self.oldPassword);
}

- (void)testUrlWithUpdatedPasswordOnly
{
    NSURL *newUrl = [self.urlWithOldUserAndOldPassword urlWithUpdatedUsername:self.oldUser andPassword:self.updatedPassword withScheme:kScheme];
    
    XCTAssertEqualObjects(newUrl.user, self.oldUser);
    XCTAssertEqualObjects(newUrl.password, self.updatedPassword);
}

- (void)testUrlWithUpdatedUsernameOnlyWithNoPreviousUsername
{
    NSURL *oldUrl = [self urlWithUser:@"" andPassword:self.oldPassword];
    NSURL *newUrl = [oldUrl urlWithUpdatedUsername:self.updatedUser andPassword:self.oldPassword withScheme:kScheme];
    
    XCTAssertEqualObjects(newUrl.user, self.updatedUser);
    XCTAssertEqualObjects(newUrl.password, self.oldPassword);
}

- (void)testUrlWithUpdatedPasswordOnlyWithNoPreviousPassword
{
    NSURL *oldUrl = [self urlWithUser:self.oldUser andPassword:@""];
    NSURL *newUrl = [oldUrl urlWithUpdatedUsername:self.oldUser andPassword:self.updatedPassword withScheme:kScheme];
    
    XCTAssertEqualObjects(newUrl.user, self.oldUser);
    XCTAssertEqualObjects(newUrl.password, self.updatedPassword);
}

- (void)testUrlWithUpdatedUsernameAndPasswordWithNilUser
{
    NSURL *newUrl = [self.urlWithOldUserAndOldPassword urlWithUpdatedUsername:nil andPassword:self.updatedPassword withScheme:kScheme];
    
    XCTAssertEqualObjects(newUrl.user, @"");
    XCTAssertEqualObjects(newUrl.password, self.updatedPassword);
}

- (void)testUrlWithUpdatedUsernameAndPasswordWithNilPassword
{
    NSURL *newUrl = [self.urlWithOldUserAndOldPassword urlWithUpdatedUsername:self.updatedUser andPassword:nil withScheme:kScheme];
    
    XCTAssertEqualObjects(newUrl.user, self.updatedUser);
    XCTAssertEqualObjects(newUrl.password, @"");
}

- (void)testUrlWithUpdatedUsername
{
    NSURL *newUrl = [self.urlWithOldUserAndOldPassword urlWithUpdatedUsername:self.updatedUser withScheme:kScheme];
    
    XCTAssertEqualObjects(newUrl.user, self.updatedUser);
    XCTAssertEqualObjects(newUrl.password, self.urlWithOldUserAndOldPassword.password);
}

- (void)testUrlWithUpdatedUsernameAndPasswordWithEmptyStrings
{
    NSURL *newUrl = [self.urlWithOldUserAndOldPassword urlWithUpdatedUsername:@"" andPassword:@"" withScheme:@"http"];
    NSURL *expectedUrl = [NSURL URLWithString:@"http://www.google.com"];
    
    XCTAssertEqualObjects(newUrl, expectedUrl);
}

- (void)testUrlWithUpdatedUsernameAndPasswordWithNils
{
    NSURL *newUrl = [self.urlWithOldUserAndOldPassword urlWithUpdatedUsername:nil andPassword:nil withScheme:@"http"];
    NSURL *expectedUrl = [NSURL URLWithString:@"http://www.google.com"];
    
    XCTAssertEqualObjects(newUrl, expectedUrl);
}

- (void)testUrlWithUpdatedPassword
{
    NSURL *newUrl = [self.urlWithOldUserAndOldPassword urlWithUpdatedPassword:self.updatedPassword withScheme:kScheme];
    
    XCTAssertEqualObjects(newUrl.user, self.urlWithOldUserAndOldPassword.user);
    XCTAssertEqualObjects(newUrl.password, self.updatedPassword);
}

- (void)testUrlWithoutAuthentication
{
    NSURL *expectedUrl = [NSURL URLWithString:@"http://www.google.com"];
    
    NSURL *urlWithUserAndPassowrd = self.urlWithOldUserAndOldPassword;
    NSURL *urlWithUserOnly = [self urlWithUser:@"user" andPassword:nil];
    NSURL *urlWithPasswordOnly = [self urlWithUser:nil andPassword:@"password"];
    
    XCTAssertEqualObjects(urlWithUserAndPassowrd.urlWithoutAuthentication, expectedUrl);
    XCTAssertEqualObjects(urlWithUserOnly.urlWithoutAuthentication, expectedUrl);
    XCTAssertEqualObjects(urlWithPasswordOnly.urlWithoutAuthentication, expectedUrl);
}

- (void)testUrlWithDefaultSchemePrependedUsingSchemeWithExistingScheme
{
    NSURL *url = [NSURL URLWithString:@"https://www.yahoo.com"];
    XCTAssertEqual([url urlWithDefaultSchemePrependedUsingScheme:@"http"], url, @"Objects should be equal, perform no operation if scheme is provided");
}

- (void)testUrlWithDefaultSchemePrependedUsingSchemeWithoutExistingHttpScheme
{
    NSURL *inputUrl = [NSURL URLWithString:@"www.yahoo.com"];
    NSURL *expectedUrl = [NSURL URLWithString:@"http://www.yahoo.com"];
    
    NSURL *actualUrl = [inputUrl urlWithDefaultSchemePrependedUsingScheme:@"http"];
    
    XCTAssertEqualObjects(actualUrl, expectedUrl);
}

- (void)testUrlWithDefaultSchemePrependedUsingSchemeWithoutExistingHttpsScheme
{
    NSURL *inputUrl = [NSURL URLWithString:@"www.yahoo.com"];
    NSURL *expectedUrl = [NSURL URLWithString:@"https://www.yahoo.com"];
    
    NSURL *actualUrl = [inputUrl urlWithDefaultSchemePrependedUsingScheme:@"https"];
    
    XCTAssertEqualObjects(actualUrl, expectedUrl);
}

- (void)testBasicAuthenticationStringWithNoUserOrPassword
{
    NSURL *inputUrl = [NSURL URLWithString:@"http://www.yahoo.com"];
    
    NSString *authStringWithoutEncoding = [inputUrl basicAuthenticationStringWithoutEncoding];
    NSString *authStringWithEncoding = [inputUrl basicAuthenticationStringWithEncoding];
    
    XCTAssertTrue((authStringWithoutEncoding == nil));
    XCTAssertTrue((authStringWithEncoding == nil));
}

- (void)testBasicAuthenticationStringWithEmptyUserAndPassword
{
    NSURL *inputUrl = [NSURL URLWithString:@"http://:@www.yahoo.com"];
    
    NSString *authStringWithoutEncoding = [inputUrl basicAuthenticationStringWithoutEncoding];
    NSString *authStringWithEncoding = [inputUrl basicAuthenticationStringWithEncoding];
    
    XCTAssertTrue((authStringWithoutEncoding == nil));
    XCTAssertTrue((authStringWithEncoding == nil));
}

- (void)testBasicAuthenticationStringWithEmptyUserAndPopulatedPassword
{
    NSString *expectedString = @":pass";
    NSURL *inputUrl = [NSURL URLWithString:@"http://:pass@www.yahoo.com"];
    
    NSString *authStringWithoutEncoding = [inputUrl basicAuthenticationStringWithoutEncoding];
    NSString *authStringWithEncoding = [inputUrl basicAuthenticationStringWithEncoding];

    XCTAssertEqualObjects(authStringWithoutEncoding, expectedString);
    XCTAssertEqualObjects(authStringWithEncoding, expectedString);
}

- (void)testBasicAuthenticationStringPopulatedUserAndEmptyPassword
{
    NSString *expectedString = @"user:";
    NSURL *inputUrl = [NSURL URLWithString:@"http://user:@www.yahoo.com"];
    
    NSString *authStringWithoutEncoding = [inputUrl basicAuthenticationStringWithoutEncoding];
    NSString *authStringWithEncoding = [inputUrl basicAuthenticationStringWithEncoding];
    
    XCTAssertEqualObjects(authStringWithoutEncoding, expectedString);
    XCTAssertEqualObjects(authStringWithEncoding, expectedString);
}

- (void)testBasicAuthenticationStringPopulatedUsernameAndPassword
{
    NSString *expectedString = @"user:pass";
    NSURL *inputUrl = [NSURL URLWithString:@"http://user:pass@www.yahoo.com"];
    
    NSString *authStringWithoutEncoding = [inputUrl basicAuthenticationStringWithoutEncoding];
    NSString *authStringWithEncoding = [inputUrl basicAuthenticationStringWithEncoding];
    
    XCTAssertEqualObjects(authStringWithoutEncoding, expectedString);
    XCTAssertEqualObjects(authStringWithEncoding, expectedString);
}

- (void)testBasicAuthenticationStringNonEncodedUsernameAndPassword
{
    NSString *expectedNonEncodedString = @"user@hotmail.com:pass";
    NSString *expectedEncodedString = @"user%40hotmail.com:pass";
    
    NSURL *inputUrl = [[NSURL URLWithString:@"http://www.yahoo.com"] urlWithUpdatedUsername:@"user@hotmail.com" andPassword:@"pass" withScheme:@"http:"];
    
    NSString *authStringWithoutEncoding = [inputUrl basicAuthenticationStringWithoutEncoding];
    NSString *authStringWithEncoding = [inputUrl basicAuthenticationStringWithEncoding];
    
    XCTAssertEqualObjects(authStringWithoutEncoding, expectedNonEncodedString);
    XCTAssertEqualObjects(authStringWithEncoding, expectedEncodedString);
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