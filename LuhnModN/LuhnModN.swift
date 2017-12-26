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

enum LuhnError: Error {
    case InvalidCharacters
    case ModuloOutOfRange
}

/// This is an implementation of the [Luhn mod N algorithm](https://en.wikipedia.org/wiki/Luhn_mod_N_algorithm)
public class LuhnModN {
    
    // MARK: Public
    
    /**
    Check if a string is valid
    
    - Parameter sequence: The string to validate
    - Parameter mod: The mod in which to compute. It corresponds to the number of valid characters
    
    - Returns: true if the string is valid, false otherwise
    */
    public static func isValid(_ sequence: String, withModulo mod: Int = 10) -> Bool {
        guard validate(modulo: mod) && !containsInvalidCharacters(sequence, withModulo: Int32(mod)) else { return false }
        
        let sum = calculateLuhnSum(for: sequence, withModulo: mod, shouldDouble: { ($0 % 2 != 0) })
        let remainder = sum % mod
        
        return remainder == 0
    }
    
    /**
     Add the check character
     
     - Parameter sequence: The string to add the check character
     - Parameter mod: The mod in which to compute. It corresponds to the number of valid characters
     
     - Throws: LuhnError
     
     - Returns: The string with the check character
     */
    public static func addCheckCharacter(to sequence: String, withModulo mod: Int = 10) throws -> String {
        guard validate(modulo: mod) else { throw LuhnError.ModuloOutOfRange }
        guard !containsInvalidCharacters(sequence, withModulo: Int32(mod)) else { throw LuhnError.InvalidCharacters }
        
        return sequence + generateCheckCharacter(for: sequence, withModulo : mod)
    }
    
    // MARK: Private
    
    /**
    Calculate the luhn sum
    
    - Parameter sequence: The string
    - Parameter mod: The mod in which to compute. It corresponds to the number of valid characters
    - Parameter shouldDouble: A closure to know if the value should be doubled or not
    
    - Returns: The Luhn sum
    */
    private static func calculateLuhnSum(for sequence: String, withModulo mod: Int, shouldDouble: (_ index : Int) -> Bool) -> Int {
        return sequence
            .reversed()
            .map { codePoint(fromCharacter: $0, withModulo: Int32(mod)) }
            .enumerated()
            .map { sum(digits: $1 * ((shouldDouble($0)) ? 2 : 1), withModulo : mod) }
            .reduce(0, +)
    }
    
    /**
     Calculate the check character
     
     - Parameter sequence: The input to string from which the check character should be calculated
     - Parameter mod: The mod in which to compute. It corresponds to the number of valid characters
     
     - Returns: The check character
     */
    private static func generateCheckCharacter(for sequence: String, withModulo mod: Int) -> String {
        let sum = calculateLuhnSum(for: sequence, withModulo : mod, shouldDouble: { ($0 % 2 == 0) })
        let remainder = sum % mod
        let checkCodePoint = (mod - remainder) % mod
        return character(fromCodePoint: checkCodePoint, withModulo : mod)
    }
    
    
    /**
     Check if a string contains invalid characters
     - Parameter sequence : The string to check
     - Parameter mod: The mod in which to compute. It corresponds to the number of valid characters
     
     - Returns: true if one or more invalid characters were found, true otherwise
     */
    private static func containsInvalidCharacters(_ sequence: String, withModulo mod: Int32) -> Bool {
        return sequence
            .reduce(false) { $0 || (strtoul(String($1), nil, mod) == 0 && $1 != "0") }
    }
    
    /**
     Validate the mod. The mod should be between 2 and 36 inclusive
     
     - Parameter mod: The mod
     
     - Returns: true if the mod is valid, false otherwise
     */
    private static func validate(modulo mod: Int) -> Bool {
        return mod > 1 && mod < 37
    }
    
    
    /**
     Get the int value of a character
     
     - Parameter character: The character
     - Parameter mod: The mod in which to compute. It corresponds to the number of valid characters
     
     - Returns: The int value of the character
     */
    private static func codePoint(fromCharacter character: Character, withModulo mod: Int32) -> Int {
        return Int(strtoul(String(character), nil, mod))
    }
    
    /**
     Get the string value of an int
     
     - Parameter codePoint: The int to convert
     - Parameter mod: The mod in which to compute. It corresponds to the number of valid characters
     
     - Returns: The string value of the integer
     */
    private static func character(fromCodePoint codePoint: Int, withModulo mod: Int) -> String {
        return String(codePoint, radix: mod)
    }
    
    /**
     Sum the digits of a number
     
     - Parameter addend: The number
     - Parameter mod: The mod in which to compute. It corresponds to the number of valid characters
     
     - Returns : The sum of its digit
     */
    private static func sum(digits addend: Int, withModulo mod: Int) -> Int {
        return (addend / mod) + (addend % mod)
    }
    
}
