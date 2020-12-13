//
//  Challenge13.swift
//  AdventOfCode2020
//
//  Created by Sagar Dagdu on 13/12/20.
//

import Cocoa

final class Challenge13: Challenge {
    
    lazy var input = InputFileHelper.readLinesFromFile(fileName: "13").compactMap{$0}
    
    func solvePartOne() -> String {
        let initialTimestamp = Int(input.first!)!
        let busesAvailable = input[1].split(separator: ",").filter { $0 != "x" }.compactMap { Int(String($0)) }
        let departureTimestamps = busesAvailable.map { firstAvailableTimestamp(fromInitial: initialTimestamp, busId: $0) }
        
        let earliestTs = departureTimestamps.min()!
        let earliestDepartingBusIndex = departureTimestamps.firstIndex(of: earliestTs)!
        let boardingBusId = busesAvailable[earliestDepartingBusIndex]
        
        let timeDiff = earliestTs - initialTimestamp
        
        return "\(boardingBusId * timeDiff)"
    }
    
    func solvePartTwo() -> String {
//        let allBuses = input[1].split(separator: ",").compactMap { String($0) }
//        var timestampDiffs = Array<Int>(repeating: 0, count: allBuses.count)
//
//        for index in 0 ..< allBuses.count {
//            if let _ = Int(allBuses[index]) {
//                timestampDiffs[index] = index
//            } else {
//                timestampDiffs[index] = -1
//            }
//        }
//
//        let availableBuses = allBuses.filter { $0 != "x" }.compactMap { Int($0)! }
//        timestampDiffs = timestampDiffs.filter { $0 != -1 }
//
//        var initialTs = availableBuses[0]
//
//        while true {
//            if canAllBusesDepart(with: availableBuses, validDepTs: timestampDiffs, initialTs: initialTs) {
//                break;
//            } else {
//                initialTs += initialTs
//            }
//        }
//
//        return "\(initialTs)"
        return ""
    }
    
    
}

private extension Challenge13 {
    func firstAvailableTimestamp(fromInitial initialTimeStamp: Int, busId:Int) -> Int {
        for timestamp in initialTimeStamp ... 2 * initialTimeStamp {
            if timestamp % busId == 0 {
                return timestamp
            }
        }
        
        return 0
    }
    
    func canAllBusesDepart(with busIds: [Int], validDepTs:[Int], initialTs: Int) -> Bool {
        for index in 0 ..< busIds.count   {
            let busId = busIds[index]
            let validDepTs = validDepTs[index]
            let depTs = initialTs + validDepTs
            if !(depTs % busId == 0) {
                return false
            }
        }
        
        return true
    }
}
