//
//  NSString+UtilsTests.m
//  CKBasicAuthUrlUtilities
//
//  Created by Cody Kimberling on 6/12/13.
//  Copyright (c) 2013 Cody Kimberling. All rights reserved.
//

#import "NSString+UtilsTests.h"
#import "NSString+Utils.h"

@implementation NSString_UtilsTests

- (void)testPopulatedString
{
    NSString *stringToTest = @"ABC";
    
    STAssertFalse(stringToTest.isEmpty, nil);
    STAssertTrue(stringToTest.isNotEmpty, nil);
}

- (void)testPopulatedStringSpacesOnly
{
    NSString *stringToTest = @" ";
    
    STAssertFalse(stringToTest.isEmpty, nil);
    STAssertTrue(stringToTest.isNotEmpty, nil);
}

- (void)testEmptyString
{
    NSString *stringToTest = @"";
    
    STAssertTrue(stringToTest.isEmpty, nil);
    STAssertFalse(stringToTest.isNotEmpty, nil);
}

@end