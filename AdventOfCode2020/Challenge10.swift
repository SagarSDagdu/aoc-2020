//
//  Challenge10.swift
//  AdventOfCode2020
//
//  Created by Sagar Dagdu on 10/12/20.
//

import Cocoa

final class Challenge10: Challenge {
    
    lazy var sortedInputNumbers = InputFileHelper.readLinesFromFile(fileName: "10").filter { !$0.isEmpty }.map { Int($0)! }.sorted()
    
    lazy var joltages = [0] + sortedInputNumbers + [sortedInputNumbers.last! + 3]
    
    func solvePartOne() -> String {
        var countOf1Difference = 0
        var countOf3Difference = 0
        
        for index in 0 ..< joltages.count - 1 {
            let difference = joltages[index + 1] - joltages[index]
            
            if difference == 1 {
                countOf1Difference += 1
            }
            if difference == 3 {
                countOf3Difference += 1
            }

        }
        
        return "\(countOf1Difference * countOf3Difference)"
    }

    var indexToCountCache = [Int:Int]()
    
    func solvePartTwo() -> String {
        return "\(recursivelyCount(at: 0))"
    }
    

}


private extension Challenge10 {
    func recursivelyCount(at index: Int) -> Int {
        if index == joltages.count - 1 { return 1 }
        
        if let existingValue = indexToCountCache[index] {
            return existingValue
        }
        
        var total = 0
        var next = index + 1
        
        while next < joltages.count && joltages[next] - joltages[index] <= 3 {
            total += recursivelyCount(at: next)
            indexToCountCache[index] = total
            next += 1
        }
        
        return total
    }
    
}
