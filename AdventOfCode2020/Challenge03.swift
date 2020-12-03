//
//  Challenge03.swift
//  AdventOfCode2020
//
//  Created by Sagar Dagdu on 03/12/20.
//

import Foundation

class Challenge03: Challenge {
    
    lazy var matrix: [[Character]] = InputFileHelper.readLinesFromFile(fileName: "03").map { Array($0) }
    
    func solvePartOne() -> String {
        return "\(countTrees(in: matrix, right: 3, down: 1))"
    }
    
    func solvePartTwo() -> String {
        let slopes = [(1,1),(3,1),(5,1),(7,1),(1,2)]
        var product = 1

        slopes.forEach { (right, down) in
            product *= countTrees(in: matrix, right: right, down: down)
        }

        return "\(product)"
    }

    // MARK:- Helpers

    private func countTrees(in matrix:[[Character]], right:Int, down: Int) -> Int {
        var trees = 0
        var x = right

        for y in stride(from: down, to: matrix.count, by: down) {
            let width = matrix[y].count
            if matrix[y][x % width] == "#" {
                trees += 1
            }
            x += right
        }
        return trees
    }
    
}
