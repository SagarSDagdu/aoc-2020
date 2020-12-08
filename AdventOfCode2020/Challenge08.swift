//
//  Challenge08.swift
//  AdventOfCode2020
//
//  Created by Sagar Dagdu on 08/12/20.
//

import Cocoa

enum Operation: String {
    case acc = "acc"
    case jmp = "jmp"
    case nop = "nop"
}

struct Instruction {
    var operation: Operation
    var argument: Int
    
    static func fromInstructionStatement(_ statement: String) -> Instruction {
        let components = statement.components(separatedBy: .whitespaces).filter { !$0.isEmpty }
        let operation = components[0]
        let argument = Int(components[1])!
        
        return Instruction(operation: Operation(rawValue: operation)!, argument: argument)
    }
}


class Challenge08: Challenge {
    
    var accumulator = 0
    
    lazy var instructionSet = InputFileHelper.readLinesFromFile(fileName: "08").map { Instruction.fromInstructionStatement($0) }
    
    func solvePartOne() -> String {
        let (hasLoop, accumulator) = executeLoader(with: instructionSet)
        if hasLoop {
            return "\(accumulator)"
        } else {
            return "invalid"
        }
    }
    
    func solvePartTwo() -> String {
        let possibleInstructionSet = possibleInstructionSets()
        for instructionSet in possibleInstructionSet {
            let (hasLoop, accumulator) = executeLoader(with: instructionSet)
            if !hasLoop {
                return "\(accumulator)"
            }
        }
        
        return "All variants have a loop"
    }
    
    func executeLoader(with instructionSet:[Instruction]) -> (hasLoop: Bool, accumulatorValue: Int) {
        var currentIndex = 0
        var executedOperationsIndex = Set<Int>()
        var accumulator = 0
        
        while currentIndex < instructionSet.count {
            if executedOperationsIndex.contains(currentIndex) {
                return (true, accumulator)
            }
            
            executedOperationsIndex.insert(currentIndex)
            let instruction = instructionSet[currentIndex]

            switch instruction.operation {
            case .acc:
                accumulator += instruction.argument
                currentIndex += 1
            case .nop:
                currentIndex += 1
            case .jmp:
                currentIndex += instruction.argument
            }
        }
        
        return (false, accumulator)
    }
    
    private func possibleInstructionSets() -> [[Instruction]] {
        var permutations = [[Instruction]]()
        
        for (index, instruction) in instructionSet.enumerated() {
            var instructionsCopy = instructionSet
            
            if instruction.operation == .jmp {
                instructionsCopy[index] = Instruction(operation: .nop, argument: instruction.argument)
                permutations.append(instructionsCopy)
            }
            
            if instruction.operation == .nop {
                instructionsCopy[index] = Instruction(operation: .jmp, argument: instruction.argument)
                permutations.append(instructionsCopy)
            }
        }
        return permutations
    }
    
}
