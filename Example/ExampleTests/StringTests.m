//
//  StringTests.m
//  Example
//
//  Created by B.Dog on 16/5/20.
//  Copyright © 2016年 JKSoft. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "NSString+StringValidator.h"

@interface StringTests : XCTestCase

@end

@implementation StringTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
    
//    NSString *phoneNum = @"18842310610";
//    NSLog(@"%d", [phoneNum isMobileTelephone]);
//    NSString *IDNum = @"220281199106100538";
//    NSLog(@"%d", [IDNum isIdentityCardNumber]);
    NSString *num = @"1234";
    
//    NSLog(@"%d", [num isNumericAppearance]);
//    NSLog(@"%d", [num isFloatAppearance]);
    NSLog(@"%d", [num isValidateVerifyCodeWithLimits:4]);
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
