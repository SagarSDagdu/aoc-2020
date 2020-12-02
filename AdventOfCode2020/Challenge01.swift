//
//  Challenge01.swift
//  AdventOfCode2020
//
//  Created by Sagar Dagdu on 02/12/20.
//

import Foundation

class Challenge01: Challenge {
    
    lazy var numbers = InputFileHelper.readLinesFromFile(fileName: "01").compactMap { Int($0) }
    
    func solvePartOne() -> String {
        for number in self.numbers {
            let complement = 2020 - number
            if numbers.contains(complement) {
                return "\(number * complement)"
            }
        }
        
        return ""
    }
    
    func solvePartTwo() -> String {
        for number in numbers {
            let complement = 2020 - number
            for innerNumber in numbers {
                let innerComplement = complement - innerNumber
                if (numbers.contains(innerComplement)) {
                    return "\(number * innerNumber * innerComplement)"
                }
            }
        }
        return ""
    }
}
