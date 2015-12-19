//
//  Copyright (c) 2013 Cody Kimberling. All rights reserved.
//  Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
//  •  Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
//  •  Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
//  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

#import "NSString+BasicAuthUtilsTests.h"
#import "NSString+BasicAuthUtils.h"
#import "OCMock.h"
#import "CKTestHelpers.h"

@interface NSString_BasicAuthUtilsTests ()

@property NSString *string;
@property NSDictionary *illegalCharacterToUrlEncodedCharacterDictionary;

@end

@implementation NSString_BasicAuthUtilsTests

- (void)setUp
{
    [super setUp];
    self.string = NSString.new;
    self.illegalCharacterToUrlEncodedCharacterDictionary = [self retrieveIllegalCharacterDictionary];
}

#pragma mark - Encoding Tests

- (void)testIllegalCharacters
{
    XCTAssertEqualObjects(self.string.illegalCharacterSet, @"!*'();:@&=+@,/?#[]");
}

- (void)testStringWithUrlEncoding
{
    for(int i = 0; i < self.string.illegalCharacterSet.length; i++){
        unichar c = [self.string.illegalCharacterSet characterAtIndex:i];
        
        NSString *illegalCharacter = [NSString stringWithFormat: @"%C", c];
        NSString *actualCharacter = illegalCharacter.stringWithUrlEncoding;
        
        NSString *expectedCharacter = [self.illegalCharacterToUrlEncodedCharacterDictionary objectForKey:illegalCharacter];
        
        XCTAssertEqualObjects(actualCharacter, expectedCharacter);
    }
}

- (void)testDoesStringContainIllegalHttpCharactersWithIllegalCharacters
{
    for(int i = 0; i < self.string.illegalCharacterSet.length; i++){
        unichar c = [self.string.illegalCharacterSet characterAtIndex:i];
        NSString *illegalCharacter = [NSString stringWithFormat: @"%C", c];
        
        XCTAssertTrue(illegalCharacter.doesStringContainIllegalUrlCharacters);
    }

}

- (void)testDoesStringContainIllegalHttpCharactersWithLegalCharacters
{
    NSString *validCharacters = @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLKMNOPQRSTUVWXYZ0123456789-.\\_";
 
    for(int i = 0; i < validCharacters.length; i++){
        unichar c = [validCharacters characterAtIndex:i];
        NSString *legalCharacter = [NSString stringWithFormat: @"%C", c];
        
        XCTAssertFalse(legalCharacter.doesStringContainIllegalUrlCharacters);
    }
}

- (void)testUrlSafeStringRetrunsEncodedString
{
    for (NSString *illegalString in self.illegalCharacterToUrlEncodedCharacterDictionary.allKeys){
        NSString *encodedString = [self.illegalCharacterToUrlEncodedCharacterDictionary objectForKey:illegalString];
        XCTAssertEqualObjects(illegalString.urlSafeString, encodedString);
    }
}

#pragma mark - NSString Basic Auth Tests

- (void)testBasicAuthStringWithUserAndPassword
{
    NSString *expectedString = @"user:pass@";
    
    NSString *actualString = [@"" basicAuthStringWithUser:@"user" andPassword:@"pass"];
    
    XCTAssertEqualObjects(actualString, expectedString);
}

- (void)testBasicAuthStringWithEmptyUserAndPassword
{
    NSString *expectedString = @":pass@";
    
    NSString *actualString = [@"" basicAuthStringWithUser:@"" andPassword:@"pass"];
    
    XCTAssertEqualObjects(actualString, expectedString);
}

- (void)testBasicAuthStringWithNilUserAndPassword
{
    NSString *expectedString = @":pass@";
    
    NSString *actualString = [@"" basicAuthStringWithUser:nil andPassword:@"pass"];
    
    XCTAssertEqualObjects(actualString, expectedString);
}

- (void)testBasicAuthStringWithUserAndEmptyPassword
{
    NSString *expectedString = @"user:@";
    
    NSString *actualString = [@"" basicAuthStringWithUser:@"user" andPassword:@""];
    
    XCTAssertEqualObjects(actualString, expectedString);
}

- (void)testBasicAuthStringWithUserAndNilPassword
{
    NSString *expectedString = @"user:@";
    
    NSString *actualString = [@"" basicAuthStringWithUser:@"user" andPassword:nil];
    
    XCTAssertEqualObjects(actualString, expectedString);
}

- (void)basicAuthStringWithUserAndPasswordShouldEncode
{
    NSString *illegalUsername = @"user!";
    NSString *encodedUsername = @"user%21";

    NSString *expectedString = [NSString stringWithFormat:@"%@:pass@", encodedUsername];
    
    NSString *actualString = [@"" basicAuthStringWithUser:illegalUsername andPassword:@"pass" shouldEncode:YES];
    
    XCTAssertEqualObjects(actualString, expectedString);
}

- (void)basicAuthStringWithUserAndPasswordShouldNotEncode
{
    NSString *illegalUsername = @"user!";
    
    NSString *expectedString = [NSString stringWithFormat:@"%@:pass@", illegalUsername];
    
    NSString *actualString = [@"" basicAuthStringWithUser:illegalUsername andPassword:@"pass" shouldEncode:NO];
    
    XCTAssertEqualObjects(actualString, expectedString);
}

- (NSDictionary *)retrieveIllegalCharacterDictionary
{
    return @{   @"!":@"%21",
                @"*":@"%2A",
                @"'":@"%27",
                @"(":@"%28",
                @")":@"%29",
                @";":@"%3B",
                @":":@"%3A",
                @"@":@"%40",
                @"&":@"%26",
                @"=":@"%3D",
                @"+":@"%2B",
                @"@":@"%40",
                @",":@"%2C",
                @"/":@"%2F",
                @"?":@"%3F",
                @"#":@"%23",
                @"[":@"%5B",
                @"]":@"%5D"};
}

@end