//
//  CKTestHelpers.h
//  CKBasicAuthUrlUtilities
//
//  Created by Cody Kimberling on 6/12/13.
//  Copyright (c) 2013 Cody Kimberling. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSString+BasicAuthUtils.h"
#import "NSURL+BasicAuthUtils.h"
#import "CKBasicAuthUrlUtilities.h"

@interface CKTestHelpers : NSObject

@end

#pragma mark - NSString Test Category

@interface NSString (Test)

- (NSString *)illegalCharacterSet;
- (NSString *)stringWithUrlEncoding;
- (NSString *)urlSafeString;
- (BOOL)doesStringContainIllegalUrlCharacters;

@end

@interface NSURL (Test)

- (NSURL *)urlWithDefaultSchemePrependedUsingScheme:(NSString *)scheme;

@end

@interface CKBasicAuthUrlUtilities (Test)

- (NSString *)scheme;
- (NSString *)basicAuthenticationStringShouldEncodeResult:(BOOL)shouldEncode;
- (NSData *)dataFromBase64String:(NSString *)string;
- (NSString *)base64EncodedStringForData:(NSData *)data;


@end
