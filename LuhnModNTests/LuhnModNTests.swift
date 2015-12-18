//
//  LuhnModNTests.swift
//  LuhnModNTests
//
//  Created by Arnaud Bultot on 17/12/15.
//  Copyright © 2015 ebluehands. All rights reserved.
//

import XCTest
@testable import LuhnModN

class LuhnModNTests: XCTestCase {
    
    let validStringMod10 = "1234567897"
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testValidateMethod() {
        XCTAssertTrue(LuhnModN.isValid(validStringMod10, mod : 10), "The string should be valid")
        XCTAssertFalse(LuhnModN.isValid(validStringMod10, mod : 5), "The string contains invalid characters")
        XCTAssertFalse(LuhnModN.isValid(validStringMod10, mod : 40), "The modulo is too big")
    }
    
    func testCheckCharacter() {
        let toAdd = "123456789"
        let added = try? LuhnModN.addCheckCharacter(toAdd, mod : 10)
        XCTAssertNotNil(added)
        XCTAssertTrue(LuhnModN.isValid(added!, mod : 10), "The string should be valid")
        
        
        do {
           try LuhnModN.addCheckCharacter("&123456789", mod : 10)
        }
        catch let error as LuhnError {
            XCTAssertEqual(error, LuhnError.InvalidCharacters)
        }
        catch {
            XCTFail("Unkown error")
        }
        
        do {
            try LuhnModN.addCheckCharacter(toAdd, mod : 40)
        }
        catch let error as LuhnError {
            XCTAssertEqual(error, LuhnError.ModuloOutOfRange)
        }
        catch {
            XCTFail("Unkown error")
        }
    }
    
    //From https://stripe.com/docs/testing
    func testCreditCardsValidation() {
        //Visa
        XCTAssertTrue(LuhnModN.isValid("4242424242424242", mod : 10), "The string should be valid")
        //Visa
        XCTAssertTrue(LuhnModN.isValid("4012888888881881", mod : 10), "The string should be valid")
        //Visa debit
        XCTAssertTrue(LuhnModN.isValid("4000056655665556", mod : 10), "The string should be valid")
        //Mastercard
        XCTAssertTrue(LuhnModN.isValid("5555555555554444", mod : 10), "The string should be valid")
        //Mastercard debit
        XCTAssertTrue(LuhnModN.isValid("5200828282828210", mod : 10), "The string should be valid")
        //Mastercard prepaid
        XCTAssertTrue(LuhnModN.isValid("5105105105105100", mod : 10), "The string should be valid")
        //American Express
        XCTAssertTrue(LuhnModN.isValid("378282246310005", mod : 10), "The string should be valid")
        //American Express
        XCTAssertTrue(LuhnModN.isValid("371449635398431", mod : 10), "The string should be valid")
        //Discover
        XCTAssertTrue(LuhnModN.isValid("6011111111111117", mod : 10), "The string should be valid")
        //Discover
        XCTAssertTrue(LuhnModN.isValid("6011000990139424", mod : 10), "The string should be valid")
        //Diners Club
        XCTAssertTrue(LuhnModN.isValid("30569309025904", mod : 10), "The string should be valid")
        //Diners Club
        XCTAssertTrue(LuhnModN.isValid("38520000023237", mod : 10), "The string should be valid")
        //JCB
        XCTAssertTrue(LuhnModN.isValid("3530111333300000", mod : 10), "The string should be valid")
        //JCB
        XCTAssertTrue(LuhnModN.isValid("3566002020360505", mod : 10), "The string should be valid")
    }
    
    func testCreditCardsGeneration() {
        //Visa
        let visa1 = try? LuhnModN.addCheckCharacter("424242424242424", mod : 10)
        XCTAssertNotNil(visa1)
        XCTAssertTrue(LuhnModN.isValid(visa1!, mod : 10), "The string should be valid")
        XCTAssertEqual(visa1!, "4242424242424242")
        
        //Visa 2
        let visa2 = try? LuhnModN.addCheckCharacter("401288888888188", mod : 10)
        XCTAssertNotNil(visa2)
        XCTAssertTrue(LuhnModN.isValid(visa2!, mod : 10), "The string should be valid")
        XCTAssertEqual(visa2!, "4012888888881881")

        
        //Visa debit
        let visaDebit = try? LuhnModN.addCheckCharacter("400005665566555", mod : 10)
        XCTAssertNotNil(visaDebit)
        XCTAssertTrue(LuhnModN.isValid(visaDebit!, mod : 10), "The string should be valid")
        XCTAssertEqual(visaDebit!, "4000056655665556")

        
        //Mastercard
        let mastercard1 = try? LuhnModN.addCheckCharacter("555555555555444", mod : 10)
        XCTAssertNotNil(mastercard1)
        XCTAssertTrue(LuhnModN.isValid(mastercard1!, mod : 10), "The string should be valid")
        XCTAssertEqual(mastercard1!, "5555555555554444")

        
        //Mastercard debit
        let mastercardDebit = try? LuhnModN.addCheckCharacter("520082828282821", mod : 10)
        XCTAssertNotNil(mastercardDebit)
        XCTAssertTrue(LuhnModN.isValid(mastercardDebit!, mod : 10), "The string should be valid")
        XCTAssertEqual(mastercardDebit!, "5200828282828210")

        
        //Mastercard prepaid
        let mastercardPrepaid = try? LuhnModN.addCheckCharacter("510510510510510", mod : 10)
        XCTAssertNotNil(mastercardPrepaid)
        XCTAssertTrue(LuhnModN.isValid(mastercardPrepaid!, mod : 10), "The string should be valid")
        XCTAssertEqual(mastercardPrepaid!, "5105105105105100")


        //American Express
        let americanExpress1 = try? LuhnModN.addCheckCharacter("37828224631000", mod : 10)
        XCTAssertNotNil(americanExpress1)
        XCTAssertTrue(LuhnModN.isValid(americanExpress1!, mod : 10), "The string should be valid")
        XCTAssertEqual(americanExpress1!, "378282246310005")

        
        //American Express 2
        let americanExpress2 = try? LuhnModN.addCheckCharacter("37144963539843", mod : 10)
        XCTAssertNotNil(americanExpress2)
        XCTAssertTrue(LuhnModN.isValid(americanExpress2!, mod : 10), "The string should be valid")
        XCTAssertEqual(americanExpress2!, "371449635398431")

        
        //Discover 1
        let discover1 = try? LuhnModN.addCheckCharacter("601111111111111", mod : 10)
        XCTAssertNotNil(discover1)
        XCTAssertTrue(LuhnModN.isValid(discover1!, mod : 10), "The string should be valid")
        XCTAssertEqual(discover1!, "6011111111111117")


        //Discover 2
        let discover2 = try? LuhnModN.addCheckCharacter("601100099013942", mod : 10)
        XCTAssertNotNil(discover2)
        XCTAssertTrue(LuhnModN.isValid(discover2!, mod : 10), "The string should be valid")
        XCTAssertEqual(discover2!, "6011000990139424")


        //Diners Club 1
        let dinersClub1 = try? LuhnModN.addCheckCharacter("3056930902590", mod : 10)
        XCTAssertNotNil(dinersClub1)
        XCTAssertTrue(LuhnModN.isValid(dinersClub1!, mod : 10), "The string should be valid")
        XCTAssertEqual(dinersClub1!, "30569309025904")


        //Diners Club 2
        let dinersClub2 = try? LuhnModN.addCheckCharacter("3852000002323", mod : 10)
        XCTAssertNotNil(dinersClub2)
        XCTAssertTrue(LuhnModN.isValid(dinersClub2!, mod : 10), "The string should be valid")
        XCTAssertEqual(dinersClub2!, "38520000023237")

        
        //JCB 1
        let jcb1 = try? LuhnModN.addCheckCharacter("353011133330000", mod : 10)
        XCTAssertNotNil(jcb1)
        XCTAssertTrue(LuhnModN.isValid(jcb1!, mod : 10), "The string should be valid")
        XCTAssertEqual(jcb1!, "3530111333300000")

 
        //JCB 2
        let jcb2 = try? LuhnModN.addCheckCharacter("356600202036050", mod : 10)
        XCTAssertNotNil(jcb2)
        XCTAssertTrue(LuhnModN.isValid(jcb2!, mod : 10), "The string should be valid")
        XCTAssertEqual(jcb2!, "3566002020360505")


    }
    
    
}