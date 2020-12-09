//
//  Challenge09.swift
//  AdventOfCode2020
//
//  Created by Sagar Dagdu on 09/12/20.
//

import Cocoa

class Challenge09: Challenge {
    
    lazy var numbers = InputFileHelper.readLinesFromFile(fileName: "09").map { Int($0)! }
    
    lazy var preamble = numbers.prefix(25).map { Int($0) }
    
    func solvePartOne() -> String {
        let preambleIndices = 0...24
        for index in 0 ..< numbers.count {
            if preambleIndices.contains(index) {
                continue
            }
            let number = numbers[index]
            let lastNNumbers = (0 + (index - 25))...(24 + (index - 25))
            let preamble = numbers[lastNNumbers.lowerBound ... lastNNumbers.upperBound].map { Int($0) }
            if !isSumPresentIn(array: preamble, number: number) {
                return "\(number)"
            }
        }
        
        return "invalid"
    }
    
    func solvePartTwo() -> String {
        let invalidNumber = Int(solvePartOne())!
        
        var currentSum = numbers[0]
        var start = 0
        
        for index in 1 ... numbers.count {
            while (currentSum > invalidNumber && start < (index - 1)) {
                currentSum -= numbers[start]
                start += 1
            }
            
            if (currentSum == invalidNumber) {
                var rangeArray = [Int]()
                for rangeIndex in start ... index - 1 {
                    rangeArray.append(numbers[rangeIndex])
                }
                return "\(rangeArray.min()! + rangeArray.max()!)"
            }
            
            if (index < numbers.count) {
                currentSum += numbers[index]
            }
            
        }
        return "invalid"
        
    }
}

private extension Challenge09 {
    func isSumPresentIn(array: [Int], number: Int) -> Bool {
        for preambleNumber in array {
            if array.contains(number - preambleNumber) {
                return true
            }
        }
        
        return false
    }
}
