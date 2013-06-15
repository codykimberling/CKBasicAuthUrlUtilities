//
//  Copyright (c) 2013 Cody Kimberling. All rights reserved.
//  Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
//  •  Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
//  •  Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
//  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

#import <Foundation/Foundation.h>

typedef enum : NSInteger {
    CKBasicAuthUrlUtilitiesDefaultSchemeTypeHttps,
    CKBasicAuthUrlUtilitiesDefaultSchemeTypeHttp
}  CKBasicAuthUrlUtilitiesDefaultSchemeType;

@interface CKBasicAuthUrlUtilities : NSObject

// scheme type, default is HTTPS
@property (nonatomic) CKBasicAuthUrlUtilitiesDefaultSchemeType schemeType;

- (id)initWithDefaultSchemeType:(CKBasicAuthUrlUtilitiesDefaultSchemeType)schemeType;

#pragma mark - NSURL encode string if needed

//  Creates a NSURL with a non-encoded string, percent escapting the non-encoded string with NSUTF8StringEncoding
- (NSURL *)urlWithUtf8EncodingForString:(NSString *)nonEncodedString;

#pragma mark - NSURL Update User/Password

//  Returns a NSURL with an updated username (username encoded if needed)
- (NSURL *)urlWithUpdatedUsername:(NSString *)username forUrl:(NSURL *)url;

//  Returns a NSURL with an updated password (password encoded if needed)
- (NSURL *)urlWithUpdatedPassword:(NSString *)password forUrl:(NSURL *)url;

//  Returns a NSURL with an updated username and password (username and password will be encoded if needed)
- (NSURL *)urlWithUpdatedUsername:(NSString *)username andPassword:(NSString *)password forUrl:(NSURL *)url;

#pragma mark - NSURL 

//  Returns a NSURL with the authentication components stripped out
- (NSURL *)urlWithoutAuthenticationFromUrl:(NSURL *)url;

@end