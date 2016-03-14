//
//  UtilitiesTests.swift
//  Pulser
//
//  Created by David McQueen on 25/09/2015.
//  Copyright © 2015 David McQueen. All rights reserved.
//

import XCTest

class UtilitiesTests: XCTestCase {
    
    var lowerBound: UITextField = UITextField();
    var upperBound: UITextField = UITextField();
    var randomLowerValue: String = String();
    var randomUpperValue: String = String();
    
    override func setUp() {
        super.setUp()
        //Generate random values for the strings
        
        
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
        randomLowerValue = String();
        randomUpperValue = String();
        lowerBound.text = nil;
        upperBound.text = nil;
    }
    
    func test_convertNumberToStringRandom(){
        let number = randomNumberBetweenRange(0, upper: 2000);
        
        XCTAssertEqual(String(number), convertNumberToString(number));
    }
    
    
    func test_getZoneInputValues(){
        //provide a collection of input fields
        //Expects back an array of string (zones)
        
        randomLowerValue = convertNumberToString(randomNumberBetweenRange(0, upper: 200));
        randomUpperValue = convertNumberToString(randomNumberBetweenRange(50, upper: 250));
        
        lowerBound.text = randomLowerValue;
        upperBound.text = randomUpperValue;
        
        let results = getZoneInputValues([lowerBound, upperBound]);
        
        XCTAssertEqual(results[0], randomLowerValue);
        XCTAssertEqual(results[1], randomUpperValue);
    }
    
    
    func test_isValidBPM_True(){
        XCTAssertTrue(isValidBPM(convertNumberToString(randomNumberBetweenRange(0, upper: 999))));
    }
    
    func test_isValidBPM_False(){
        //Check that a number above 1000 is not valid.
        XCTAssertFalse(isValidBPM(convertNumberToString(randomNumberBetweenRange(1000, upper: 9999))));
    }
    
    func test_isValidBPM_False_String(){
        //Generate a random string, and check that it is not returned as valid
        //Maximum string length of 20
        XCTAssertFalse(isValidBPM(randomStringWithLength(Int(randomNumberBetweenRange(0, upper: 20)))));
    }
    
    func test_runTestMultipleTimes(){
        for _ in 1...500{
            self.test_getZoneInputValues();
            self.test_convertNumberToStringRandom();
            self.test_isValidBPM_True();
            self.test_isValidBPM_False_String();
        }
    }
    
    
    
    func randomStringWithLength (len : Int) -> String {
        
        let letters : NSString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"
        
        let randomString : NSMutableString = NSMutableString(capacity: len)
        
        for (var i=0; i < len; i++){
            let length = UInt32 (letters.length)
            let rand = arc4random_uniform(length)
            randomString.appendFormat("%C", letters.characterAtIndex(Int(rand)))
        }
        
        return randomString as String
    }
    
}
