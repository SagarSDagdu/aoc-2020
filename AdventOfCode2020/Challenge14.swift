//
//  Challenge14.swift
//  AdventOfCode2020
//
//  Created by Sagar Dagdu on 14/12/20.
//

import Cocoa

class Challenge14: Challenge {
    lazy var input = InputFileHelper.readLinesFromFile(fileName: "14")
    
    func solvePartOne() -> String {
        var currentMask = ""
        var memory = [Int:Int]()
        
        for inputLine in input {
            if inputLine.contains("mask") {
                currentMask = getMask(from: inputLine)
            } else {
                let memoryAddressAndValue = getMemoryAddressAndValue(from: inputLine)
                let updatedValue = getInMemoryRepresentation(of: memoryAddressAndValue.value, usingMask: currentMask)
                memory[memoryAddressAndValue.memoryAddress] = updatedValue
            }
        }
        
        let sum = memory.values.reduce(0, +)
        return "\(sum)"
    }
    
    func solvePartTwo() -> String {
        var currentMask = ""
        var memory = [Int:Int]()
        
        for inputLine in input {
            if inputLine.contains("mask") {
                currentMask = getMask(from: inputLine)
            } else {
                let memoryAddressAndValue = getMemoryAddressAndValue(from: inputLine)
                let updatedMemoryAddressWithFloats = updatedMemoryAddressString(from: memoryAddressAndValue.memoryAddress, using: currentMask)
                let allPossibleMemoryAddrs = allPossibleMemoryAddresses(from: updatedMemoryAddressWithFloats)
                
                allPossibleMemoryAddrs.forEach { memory[$0] = memoryAddressAndValue.value }
            }
        }
        
        let sum = memory.values.reduce(0, +)
        return "\(sum)"
    }
}

private extension Challenge14 {
    
    func getMask(from line: String) -> String {
        let parts = line.split(separator: "=")
        return parts.last!.trimmingCharacters(in: .whitespaces)
    }
    
    func getMemoryAddressAndValue(from line:String) -> (memoryAddress:Int, value: Int) {
        let parts = line.split(separator: "=")
        let value = Int(parts.last!.trimmingCharacters(in: .whitespaces))!
        
        let memoryAssignmentString = parts.first!.trimmingCharacters(in: .whitespaces)
        let firstBracketIndex = memoryAssignmentString.firstIndex(of: "[")!
        let lastBracketIndex = memoryAssignmentString.firstIndex(of: "]")!
        let memoryAddressString = memoryAssignmentString[firstBracketIndex ... lastBracketIndex].dropFirst().dropLast()
        
        let memoryAddress = Int(memoryAddressString)!
        return (memoryAddress, value)
    }
    
    func getInMemoryRepresentation(of number: Int, usingMask mask: String) -> Int {
        let binaryNumber = binaryRepresentation(number: number)
        var resultString = ""
        
        for index in 0 ..< 36 {
            let numDigit = binaryNumber[index]
            let maskChar = mask[index]
            
            if maskChar == "X" {
                resultString.append(numDigit)
            } else {
                resultString.append(maskChar)
            }
        }
        
        return decimalRepresentation(binaryString: resultString)
    }
    
    func binaryRepresentation(number: Int) -> String {
        let string = String(number, radix: 2)
        return padZeroes(to: string, finalSize: 36)
    }
    
    func decimalRepresentation(binaryString: String) -> Int {
        return Int(binaryString, radix: 2)!
    }
    
    func padZeroes(to string : String, finalSize: Int) -> String {
      var padded = string
      for _ in 0..<(finalSize - string.count) {
        padded = "0" + padded
      }
        return padded
    }
}

// Part 2
private extension Challenge14 {
    func updatedMemoryAddressString(from memoryAddress: Int, using mask: String) -> String {
        let binaryMemoryAddress = binaryRepresentation(number: memoryAddress)
        var updatedMemoryAddress = ""
        for index in 0 ..< 36 {
            let memAddrChar = binaryMemoryAddress[index]
            let maskChar = mask[index]
            
            if maskChar == "X" {
                updatedMemoryAddress.append("X")
            } else if maskChar == "0" {
                updatedMemoryAddress.append(memAddrChar)
            } else if maskChar == "1" {
                updatedMemoryAddress.append(maskChar)
            }
        }
        
        return updatedMemoryAddress
    }
    
    func allPossibleMemoryAddresses(from addressStringWithFloats: String) -> [Int] {
        let countOfXs = addressStringWithFloats.filter { $0 == "X" }.count
        let maxBinaryNumber = Int(pow(Double(2),Double(countOfXs)))
        
        let allBinaryNumbersUptoMax = allBinaryNumbers(upto: maxBinaryNumber)
        var resultMemoryAddresses = [Int]()
        
        for binaryNumber in allBinaryNumbersUptoMax {
            let result = memoryAddress(from: addressStringWithFloats, using: binaryNumber)
            resultMemoryAddresses.append(result)
        }
        
        return resultMemoryAddresses
    }
    
    func allBinaryNumbers(upto number: Int) -> [String] {
        var result = [String]()
        for i in 0 ..< number {
            let binaryNumber = String(i, radix: 2)
            result.append(binaryNumber)
        }
        
        let maxLenNumber = result.map { $0.count }.max()!
        
        return result.map { padZeroes(to: $0, finalSize: maxLenNumber)}
    }
    
    func memoryAddress(from floatingAddress: String, using binaryNumber: String) -> Int {
        var resultMemAddrString = ""
        var binIndex = 0
        for index in 0 ... floatingAddress.count {
            let flChar = floatingAddress[index]
            if flChar == "X" {
                resultMemAddrString.append(binaryNumber[binIndex])
                binIndex += 1
            } else {
                resultMemAddrString.append(flChar)
            }
        }

        return decimalRepresentation(binaryString: resultMemAddrString)
    }
}
