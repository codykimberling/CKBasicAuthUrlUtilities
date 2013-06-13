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
    STAssertEqualObjects(self.string.illegalCharacterSet, @"!*'();:@&=+@,/?#[]",nil);
}

- (void)testStringWithUrlEncoding
{
    for(int i = 0; i < self.string.illegalCharacterSet.length; i++){
        unichar c = [self.string.illegalCharacterSet characterAtIndex:i];
        
        NSString *illegalCharacter = [NSString stringWithFormat: @"%C", c];
        NSString *actualCharacter = illegalCharacter.stringWithUrlEncoding;
        
        NSString *expectedCharacter = [self.illegalCharacterToUrlEncodedCharacterDictionary objectForKey:illegalCharacter];
        
        STAssertEqualObjects(actualCharacter, expectedCharacter, nil);
    }
}

- (void)testDoesStringContainIllegalHttpCharactersWithIllegalCharacters
{
    for(int i = 0; i < self.string.illegalCharacterSet.length; i++){
        unichar c = [self.string.illegalCharacterSet characterAtIndex:i];
        NSString *illegalCharacter = [NSString stringWithFormat: @"%C", c];
        
        STAssertTrue(illegalCharacter.doesStringContainIllegalHttpCharacters,nil);
    }

}

- (void)testDoesStringContainIllegalHttpCharactersWithLegalCharacters
{
    NSString *validCharacters = @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLKMNOPQRSTUVWXYZ0123456789-.\\_";
 
    for(int i = 0; i < validCharacters.length; i++){
        unichar c = [validCharacters characterAtIndex:i];
        NSString *legalCharacter = [NSString stringWithFormat: @"%C", c];
        
        STAssertFalse(legalCharacter.doesStringContainIllegalHttpCharacters,nil);
    }
}

- (void)testUrlSafeStringRetrunsEncodedString
{
    for (NSString *illegalString in self.illegalCharacterToUrlEncodedCharacterDictionary.allKeys){
        NSString *encodedString = [self.illegalCharacterToUrlEncodedCharacterDictionary objectForKey:illegalString];
        STAssertEqualObjects(illegalString.urlSafeString, encodedString, nil);
    }
}

#pragma mark - NSString Basic Auth Tests

- (void)testBasicAuthStringWithUserAndPassword
{
    NSString *expectedString = @"user:pass@";
    
    NSString *actualString = [@"" basicAuthStringWithUser:@"user" andPassword:@"pass"];
    
    STAssertEqualObjects(actualString, expectedString, nil);
}

- (void)testBasicAuthStringWithEmptyUserAndPassword
{
    NSString *expectedString = @":pass@";
    
    NSString *actualString = [@"" basicAuthStringWithUser:@"" andPassword:@"pass"];
    
    STAssertEqualObjects(actualString, expectedString, nil);
}

- (void)testBasicAuthStringWithNilUserAndPassword
{
    NSString *expectedString = @":pass@";
    
    NSString *actualString = [@"" basicAuthStringWithUser:nil andPassword:@"pass"];
    
    STAssertEqualObjects(actualString, expectedString, nil);
}

- (void)testBasicAuthStringWithUserAndEmptyPassword
{
    NSString *expectedString = @"user:@";
    
    NSString *actualString = [@"" basicAuthStringWithUser:@"user" andPassword:@""];
    
    STAssertEqualObjects(actualString, expectedString, nil);
}

- (void)testBasicAuthStringWithUserAndNilPassword
{
    NSString *expectedString = @"user:@";
    
    NSString *actualString = [@"" basicAuthStringWithUser:@"user" andPassword:nil];
    
    STAssertEqualObjects(actualString, expectedString, nil);
}

- (void)testBasicAuthStringWithUserAndPasswordEncodesByDefault
{
    NSString *str = NSString.new;
    id partialMock = [OCMockObject partialMockForObject:str];
    
    [[partialMock expect] basicAuthStringWithUser:@"user" andPassword:@"pass" shouldEncode:YES];
    
    [str basicAuthStringWithUser:@"user" andPassword:@"pass"];
    
    [partialMock verify];
    [partialMock stopMocking];
}

- (void)basicAuthStringWithUserAndPasswordShouldEncode
{
    NSString *illegalUsername = @"user!";
    NSString *encodedUsername = @"user%21";

    NSString *expectedString = [NSString stringWithFormat:@"%@:pass@", encodedUsername];
    
    NSString *actualString = [@"" basicAuthStringWithUser:illegalUsername andPassword:@"pass" shouldEncode:YES];
    
    STAssertEqualObjects(actualString, expectedString, nil);
}

- (void)basicAuthStringWithUserAndPasswordShouldNotEncode
{
    NSString *illegalUsername = @"user!";
    
    NSString *expectedString = [NSString stringWithFormat:@"%@:pass@", illegalUsername];
    
    NSString *actualString = [@"" basicAuthStringWithUser:illegalUsername andPassword:@"pass" shouldEncode:NO];
    
    STAssertEqualObjects(actualString, expectedString, nil);
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