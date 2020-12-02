//
//  Challenge02.swift
//  AdventOfCode2020
//
//  Created by Sagar Dagdu on 02/12/20.
//

import Cocoa

typealias PasswordValidationInput = (password: String, expectedCharacter: Character, minCount: Int, maxCount: Int)

class Challenge02: Challenge {
    
    lazy var inputs = parseInput(lines: InputFileHelper.readLinesFromFile(fileName: "02"))
    
    func solvePartOne() -> String {
        var validPasswordsCount = 0
        
        for input in inputs {
            if isPasswordValidForPartOne(expectedChar: input.expectedCharacter, minCount: input.minCount, maxCount: input.maxCount, password: input.password) {
                validPasswordsCount += 1
            }
        }
        return "\(validPasswordsCount)"
    }
    
    func solvePartTwo() -> String {
        var validPasswordsCount = 0
        
        for input in inputs {
            if isPasswordValidForPartTwo(expectedChar: input.expectedCharacter, firstPos: input.minCount, secondPos: input.maxCount, password: input.password) {
                validPasswordsCount += 1
            }
        }
        return "\(validPasswordsCount)"
    }
    
    // MARK:- Private Helpers
    
    private func isPasswordValidForPartOne(expectedChar: Character, minCount: Int, maxCount: Int, password: String) -> Bool {
        let expectedCharCount = password.filter { $0 == expectedChar }.count
        return (minCount...maxCount).contains(expectedCharCount)
    }
    
    private func isPasswordValidForPartTwo(expectedChar: Character, firstPos: Int, secondPos: Int, password: String) -> Bool {
        let positions = password.indicesOf(string: String(expectedChar)).map { $0 + 1 } // +1 To account the position
        
        return Set(positions).intersection([firstPos,secondPos]).count == 1
    }
    
    private func parseInput(lines: [String]) -> [PasswordValidationInput] {
        var inputs = [PasswordValidationInput]()
        for line in lines {
            let components = line.split(separator: " ").map(String.init)
            let rangeString = components[0]
            let expectedCharacterString = components[1]
            let password = components[2]
            
            let minMax = rangeString.split(separator: "-").compactMap { Int($0) }
            let minCount = minMax[0]
            let maxCount = minMax[1]
            let expectedChar = expectedCharacterString.split(separator: ":").compactMap(String.init).map { Character($0) }.first!
            let validationInput = PasswordValidationInput(password:password, expectedCharacter:expectedChar, minCount:minCount, maxCount:maxCount)
            inputs.append(validationInput)
        }
        
        return inputs
    }
}
