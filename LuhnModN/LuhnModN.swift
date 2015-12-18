//
//  LuhnModN.swift
//  LuhnModN
//
//  Created by Arnaud Bultot on 17/12/15.
//  Copyright © 2015 ebluehands. All rights reserved.
//

/*
The MIT License (MIT)

Copyright (c) 2015 Arnaud Bultot

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
*/

import Darwin

enum LuhnError : ErrorType {
    case InvalidCharacters
    case ModuloOutOfRange
}

/// This is an implementation of the [Luhn mod N algorithm](https://en.wikipedia.org/wiki/Luhn_mod_N_algorithm)
public class LuhnModN {
    
    // MARK: Public
    
    /**
    Check if a string is valid
    
    - Parameter s: The string to validate
    - Parameter mod: The mod in which to compute. It corresponds to the number of valid characters
    
    - Returns: true if the string is valid, false otherwise
    */
    public static func isValid(s : String, mod : Int = 10) -> Bool {
        guard validatemod(mod) && !containsInvalidCharacters(s, mod: Int32(mod)) else { return false }
        
        let sum = calculateLuhnSum(s, mod: mod, shouldDouble: { ($0 % 2 != 0) })
        let remainder = sum % mod
        
        return remainder == 0
    }
    
    /**
     Add the check character
     
     - Parameter s: The string to add the check character
     - Parameter mod: The mod in which to compute. It corresponds to the number of valid characters
     
     - Throws: LuhnError
     
     - Returns: The string with the check character
     */
    public static func addCheckCharacter(s : String, mod : Int = 10) throws -> String {
        guard validatemod(mod) else { throw LuhnError.ModuloOutOfRange }
        guard !containsInvalidCharacters(s, mod: Int32(mod)) else { throw LuhnError.InvalidCharacters }
        
        return s + generateCheckCharacter(s, mod : mod)
    }
    
    // MARK: Private
    
    /**
    Calculate the luhn sum
    
    - Parameter s: The string
    - Parameter shouldDouble: A closure to know if the value should be doubled or not
    
    - Returns: The Luhn sum
    */
    private static func calculateLuhnSum(s : String, mod : Int, shouldDouble : (index : Int) -> Bool) -> Int {
        return [Character](s.characters)
            .reverse()
            .map { codePointFromCharacter($0, mod: Int32(mod)) }
            .enumerate()
            .map { sumDigits($1 * ((shouldDouble(index: $0)) ? 2 : 1), mod : mod) }
            .reduce(0, combine: +)
    }
    
    /**
     Calculate the check character
     
     - Parameter input: The input to string from which the check character should be calculated
     
     - Returns: The check character
     */
    private static func generateCheckCharacter(input : String, mod : Int) -> String {
        let sum = calculateLuhnSum(input, mod : mod, shouldDouble: { ($0 % 2 == 0) })
        let remainder = sum % mod
        let checkCodePoint = (mod - remainder) % mod
        return characterFromCodePoint(checkCodePoint, mod : mod)
    }
    
    
    /**
     Check if a string contains invalid characters
     - Parameter s : The string to check
     - Parameter mod: The mod in which to compute. It corresponds to the number of valid characters
     
     - Returns: true if one or more invalid characters were found, true otherwise
     */
    private static func containsInvalidCharacters(s : String, mod : Int32) -> Bool {
        return [Character](s.characters)
            .reduce(false) { $0 || (strtoul(String($1), nil, mod) == 0 && $1 != "0") }
    }
    
    /**
     Validate the mod. The mod should be between 2 and 36 inclusive
     
     - Parameter mod: The mod
     
     - Returns: true if the mod is valid, false otherwise
     */
    private static func validatemod(mod : Int) -> Bool {
        return mod > 1 && mod < 37
    }
    
    
    /**
     Get the int value of a character
     
     - Parameter character: The character
     - Parameter mod: The mod in which to compute. It corresponds to the number of valid characters
     
     - Returns: The int value of the character
     */
    private static func codePointFromCharacter(character : Character, mod : Int32) -> Int {
        return Int(strtoul(String(character), nil, mod))
    }
    
    /**
     Get the string value of an int
     
     - Parameter codePoint: The int to convert
     - Parameter mod: The mod in which to compute. It corresponds to the number of valid characters
     
     - Returns: The string value of the integer
     */
    private static func characterFromCodePoint(codePoint : Int, mod : Int) -> String {
        return String(codePoint, radix: mod)
    }
    
    /**
     Sum the digits of a number
     
     - Parameter addend: The number
     - Parameter mod: The mod in which to compute. It corresponds to the number of valid characters
     
     - Returns : The sum of its digit
     */
    private static func sumDigits(addend : Int, mod : Int) -> Int {
        return (addend / mod) + (addend % mod)
    }
    
}