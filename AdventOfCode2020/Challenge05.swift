//
//  Challenge05.swift
//  AdventOfCode2020
//
//  Created by Sagar Dagdu on 05/12/20.
//

import Cocoa

class Challenge05: Challenge {
    
    lazy var allSeats = InputFileHelper.readLinesFromFile(fileName: "05").map { seatId(from: $0) }
    
    func solvePartOne() -> String {
        return "\(allSeats.max() ?? 0)"
    }
    
    func solvePartTwo() -> String {
        let sortedSeatIDs = allSeats.sorted()
        let allSeatsIfThereWouldBeNoMissingSeats = sortedSeatIDs[0]...sortedSeatIDs[sortedSeatIDs.count - 1]
        let missingSeatId = Set(allSeatsIfThereWouldBeNoMissingSeats).symmetricDifference(sortedSeatIDs)
        return "\(missingSeatId.first ?? 0)"
    }
}

private extension Challenge05 {
    func findRow(from rowString: String) -> Int {
        return findSeat(from: rowString, lowerBound: 0, upperBound: 128, lowerPartIdentifyingChar: Character("F"))
    }
    
    func findColumn(from columnString: String) -> Int {
        return findSeat(from: columnString, lowerBound: 0, upperBound: 8, lowerPartIdentifyingChar: Character("L"))
    }
    
    func findSeat(from string: String, lowerBound:Int, upperBound: Int, lowerPartIdentifyingChar: Character) -> Int {
        var lowerBound = lowerBound
        var upperBound = upperBound
        
        for character in string {
            let isFront = character == lowerPartIdentifyingChar
            let mid = upperBound - lowerBound
            if isFront {
                upperBound -= mid / 2
            } else {
                lowerBound += mid / 2
            }
        }
        
        return lowerBound
    }
    
    
    func parseRowAndColumnString(from seatString: String) -> (rowString: String, columnString: String) {
        return (String(seatString.prefix(7)),String(seatString.suffix(3)))
    }
    
    func seatId(from string:String) -> Int {
        let (rowString, columnString) = parseRowAndColumnString(from: string)
        let row = findRow(from: rowString)
        let column = findColumn(from: columnString)
        return (row * 8) + column
    }
}
