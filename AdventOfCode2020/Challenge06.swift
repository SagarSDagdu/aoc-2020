//
//  Challenge06.swift
//  AdventOfCode2020
//
//  Created by Sagar Dagdu on 06/12/20.
//

import Cocoa

class Challenge06: Challenge {
    
    lazy var groups = InputFileHelper.readFileContent(fileName: "06").components(separatedBy: "\n\n")
    
    func solvePartOne() -> String {
        var numberOfQuestions = 0
        for group in groups {
            let answers = group.components(separatedBy: .newlines).filter { !$0.isEmpty }
            numberOfQuestions +=  unionOfSets(constructSets(from: answers)).count
        }
        
        return "\(numberOfQuestions)"
    }
    
    func solvePartTwo() -> String {
        var numberOfQuestions = 0
        for group in groups {
            let answers = group.components(separatedBy: .newlines).filter { !$0.isEmpty }
            numberOfQuestions +=  intersectionOfSets(constructSets(from: answers)).count
        }
        
        return "\(numberOfQuestions)"
    }
}

private extension Challenge06 {
    func constructSets(from answers: [String]) -> [Set<Character>] {
        var sets = [Set<Character>]()
        answers.forEach { (answer) in
            var answerSet = Set<Character>()
            answer.forEach({ (character) in
                answerSet.insert(character)
            })
            sets.append(answerSet)
        }
        
        return sets
    }
    
    func intersectionOfSets(_ sets: [Set<Character>]) -> Set<Character> {
        guard sets.count > 0 else { return Set<Character>() }
        
        return sets.reduce(sets[0]) {
            return $0.intersection($1)
        }
    }
    
    func unionOfSets(_ sets: [Set<Character>]) -> Set<Character> {
        guard sets.count > 0 else { return Set<Character>() }
        
        return sets.reduce(sets[0]) {
            return $0.union($1)
        }
    }
}
