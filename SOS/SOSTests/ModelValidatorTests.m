//
//  ModelValidatorTests.m
//  SOS
//
//  Created by Leonid Kokhnovych on 2016-03-06.
//  Copyright © 2016 Team14. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "ModelValidator.h"

@interface ModelValidatorTests : XCTestCase

@end

@implementation ModelValidatorTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testNameValidation
{
    XCTAssertTrue([ModelValidator validateName:@"Igor Valiniy"]);
    XCTAssertTrue([ModelValidator validateName:@"Leonid Kokhnovych"]);
    XCTAssertTrue([ModelValidator validateName:@"Alex Dashkiev"]);
    XCTAssertTrue([ModelValidator validateName:@"Monotor"]);
    XCTAssertTrue([ModelValidator validateName:@"Daniil"]);
    XCTAssertTrue([ModelValidator validateName:@"Mathias d'Arras"]);
    XCTAssertTrue([ModelValidator validateName:@"Martin Luther King, Jr."]);
    XCTAssertTrue([ModelValidator validateName:@"Hector Sausage-Hausen"]);
    XCTAssertFalse([ModelValidator validateName:@""]);
    XCTAssertFalse([ModelValidator validateName:@"123 123"]);
    XCTAssertFalse([ModelValidator validateName:@"\\\\\\"]);
}

- (void)testPhoneNumberValidation
{
    XCTAssertFalse([ModelValidator validatePhoneNumber:@"774 849 23 43"]);
    XCTAssertTrue([ModelValidator validatePhoneNumber:@"555.123.4567"]);
    XCTAssertFalse([ModelValidator validatePhoneNumber:@"12322323223"]);
    XCTAssertFalse([ModelValidator validatePhoneNumber:@"+1 (223) 232 45 1323"]);
    XCTAssertFalse([ModelValidator validatePhoneNumber:@"Martin Luther King, Jr."]);
    XCTAssertFalse([ModelValidator validatePhoneNumber:@"Hector Sausage-Hausen"]);
    XCTAssertFalse([ModelValidator validatePhoneNumber:@""]);
    XCTAssertFalse([ModelValidator validatePhoneNumber:@"123 123"]);
    XCTAssertFalse([ModelValidator validatePhoneNumber:@"\\\\\\"]);
}

@end
