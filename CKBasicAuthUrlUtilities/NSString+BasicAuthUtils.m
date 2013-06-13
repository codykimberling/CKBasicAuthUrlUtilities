//
//  Copyright (c) 2013 Cody Kimberling. All rights reserved.
//  Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
//  •  Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
//  •  Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
//  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

#import "NSString+BasicAuthUtils.h"

static NSString *kIllegalCharacterSet = @"!*'();:@&=+@,/?#[]";

@implementation NSString (BasicAuthUtils)

- (NSString *)urlSafeString
{
    return self.doesStringContainIllegalHttpCharacters ? self.stringWithUrlEncoding : self;
}

- (NSString *)stringWithUrlEncoding
{
    return CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (__bridge CFStringRef)(self),
                                                                     NULL, (__bridge CFStringRef)self.illegalCharacterSet, kCFStringEncodingUTF8));
}

- (BOOL)doesStringContainIllegalHttpCharacters
{
    return ([self rangeOfCharacterFromSet:[NSCharacterSet characterSetWithCharactersInString:self.illegalCharacterSet]].location != NSNotFound);
}

- (NSString *)basicAuthStringWithUser:(NSString *)user andPassword:(NSString *)password
{
    return [self basicAuthStringWithUser:user andPassword:password shouldEncode:YES];
}

- (NSString *)basicAuthStringWithUser:(NSString *)user andPassword:(NSString *)password shouldEncode:(BOOL)shouldEncode
{
    NSString *userToInsert = (shouldEncode) ? user.urlSafeString : user;
    NSString *passwordToInsert = (shouldEncode) ? password.urlSafeString : password;
    
    return [NSString stringWithFormat:@"%@:%@@", (userToInsert) ? userToInsert : @"", (passwordToInsert) ? passwordToInsert : @""];
}

- (NSString *)illegalCharacterSet
{
    return kIllegalCharacterSet;
}

@end