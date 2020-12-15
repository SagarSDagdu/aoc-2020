//
//  Challenge15.swift
//  AdventOfCode2020
//
//  Created by Sagar Dagdu on 15/12/20.
//

import Cocoa

final class Challenge15: Challenge {
    
    let initialSequence = [6,13,1,15,2,0]
    
    typealias Turn = (recent: Int?, previous:Int?)
    
    var spokenNumbers = [Int:Turn]() // Number:Turn
    
    func solvePartOne() -> String {
        return speakUptoNumber(limit: 2020)
    }
    
    func solvePartTwo() -> String {
        return speakUptoNumber(limit: 30000000)
    }
    
}

private extension Challenge15 {
    
    func speakUptoNumber(limit: Int) -> String {
        var currentTurn = 1
        initialSequence.forEach { (number) in
            spokenNumbers[number] = Turn(recent: currentTurn, previous:nil)
            currentTurn += 1
        }
        
        var lastSpokenNumber = initialSequence.last!

        while true {
            var numberToSpeak = 0
            if let _ = spokenNumbers[lastSpokenNumber] {
                let lastTwo = getLastTwoTurns(for: lastSpokenNumber)
                if let recent = lastTwo?.recent, let previous = lastTwo?.previous {
                    numberToSpeak = recent - previous
                }
            }
            
            speakNumber(number: numberToSpeak, atTurn: currentTurn)
            lastSpokenNumber = numberToSpeak
            
            if currentTurn == limit {
                break
            }
            
            currentTurn += 1
        }
        return "\(lastSpokenNumber)"
    }
    
    func getLastTwoTurns(for number:Int) -> Turn? {
        return spokenNumbers[number]
    }
    
    func speakNumber(number: Int, atTurn turn: Int) {
        if let turns = spokenNumbers[number] {
            let newTurns = updateTurn(turn: turn, previousTurns: turns)
            spokenNumbers[number] = newTurns
        } else {
            spokenNumbers[number] = Turn(recent : turn, previous:nil)
        }
    }
    
    func updateTurn(turn: Int, previousTurns:Turn) -> Turn {
        return Turn(recent: turn, previous: previousTurns.recent)
    }
}
