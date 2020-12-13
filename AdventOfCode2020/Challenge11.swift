//
//  Challenge11.swift
//  AdventOfCode2020
//
//  Created by Sagar Dagdu on 11/12/20.
//

import Cocoa

private enum Direction: CaseIterable {
    case top
    case bottom
    case left
    case right
    case topLeft
    case topRight
    case bottomLeft
    case bottomRight

    func nextPosition(row: Int, column: Int) -> (Int,Int){
        switch self {
        case .top: return (row - 1,column)
        case .bottom: return (row + 1, column)
        case .left: return (row, column - 1)
        case .right: return (row, column + 1)
        case .topLeft: return (row - 1, column - 1)
        case .topRight: return (row - 1, column + 1)
        case .bottomLeft: return (row + 1, column - 1)
        case .bottomRight: return (row + 1, column + 1)
        }
    }
}

final class Challenge11: Challenge {

    private let emptySeat: Character = "L"
    private let occupiedSeat: Character = "#"
    private let floor: Character = "."

    func solvePartOne() -> String {
        var cycles = 0
        var shouldStop = false
        var inputMatrix = InputFileHelper.readLinesFromFile(fileName: "11").map { Array($0) }

        while true {
            shouldStop = true
            var nextStepMatrix = inputMatrix

            for(row, columns) in inputMatrix.enumerated() {
                for column in 0 ..< columns.count {
                    let seat = inputMatrix[row][column]

                    if seat == emptySeat && shouldFillEmptySeat(at: row, column: column, inLayout: inputMatrix) {
                        nextStepMatrix[row][column] = occupiedSeat
                        shouldStop = false
                    }

                    if seat == occupiedSeat && shouldFreeOccupiedSeat(at: row, column: column, inLayout: inputMatrix) {
                        nextStepMatrix[row][column] = emptySeat
                        shouldStop = false
                    }
                }
            }

            cycles += 1
            print("\(cycles) cycles completed!")

            if shouldStop {
                break
            } else {
                inputMatrix = nextStepMatrix
            }
        }

        return "\(countOccupiedSeats(inLayout: inputMatrix))"
    }

    func solvePartTwo() -> String {
        var cycles = 0
        var shouldStop = false

        var matrix = InputFileHelper.readLinesFromFile(fileName: "11").map { Array($0) }
        while true {
            shouldStop = true
            var nextStepMatrix = matrix

            for(row, columns) in matrix.enumerated() {
                for column in 0 ..< columns.count {
                    let seat = matrix[row][column]

                    if seat == emptySeat && shouldFillEmptySeatP2(at: row, column: column, inLayout: matrix) {
                        nextStepMatrix[row][column] = occupiedSeat
                        shouldStop = false
                    }

                    if seat == occupiedSeat && shouldFreeOccupiedSeatP2(at: row, column: column, inLayout: matrix) {
                        nextStepMatrix[row][column] = emptySeat
                        shouldStop = false
                    }
                }
            }

            cycles += 1
            print("\(cycles) P2 cycles completed!")

            if shouldStop {
                break
            } else {
                matrix = nextStepMatrix
            }
        }

        return "\(countOccupiedSeats(inLayout: matrix))"
    }


}

// Part1
private extension Challenge11 {
    func getAdjacentSeats(to row: Int, column: Int) -> [(row:Int, column:Int)] {
        var adjacents = [(Int,Int)]()
        Direction.allCases.forEach { (direction) in
            adjacents.append(direction.nextPosition(row: row, column: column))
        }

        return adjacents
    }

    func shouldFillEmptySeat(at row:Int, column:Int, inLayout seats:[[Character]]) -> Bool {
        let adjacentSeats = getAdjacentSeats(to: row, column: column)

        for adjacentSeat in adjacentSeats {
            guard seats.contains(index: adjacentSeat.row, subIndex: adjacentSeat.column) else {
                continue
            }

            if seats[adjacentSeat.row][adjacentSeat.column] == occupiedSeat {
                return false
            }
        }

        return true
    }

    func shouldFreeOccupiedSeat(at row:Int, column:Int, inLayout seats:[[Character]]) -> Bool {
        let adjacentSeats = getAdjacentSeats(to: row, column: column)

        var occupiedAdjacentSeats = 0

        for adjacentSeat in adjacentSeats {
            guard seats.contains(index: adjacentSeat.row, subIndex: adjacentSeat.column) else {
                continue
            }

            if seats[adjacentSeat.row][adjacentSeat.column] == occupiedSeat {
                occupiedAdjacentSeats += 1
            }
        }

        return occupiedAdjacentSeats >= 4
    }

    func countOccupiedSeats(inLayout matrix:[[Character]]) -> Int {
        var occupiedSeats = 0
        for(row, columns) in matrix.enumerated() {
            for column in 0 ..< columns.count {
                let seat = matrix[row][column]
                if seat == occupiedSeat {
                    occupiedSeats += 1
                }
            }
        }

        return occupiedSeats
    }
}

// Part2
private extension Challenge11 {

    func findAllNeighbours(around row: Int, column: Int, matrix:[[Character]]) -> [(Int,Int)]  {
        var neighbours = [(Int,Int)]()

        Direction.allCases.forEach { (direction) in
            if let seat = findNeighbours(row: row, column: column, inLayout: matrix, inDirection: direction) {
                neighbours.append(seat)
            }
        }

        return neighbours
    }

    func findNeighbours(row:Int, column:Int, inLayout matrix:[[Character]], inDirection direction: Direction) -> (row:Int,column:Int)? {
        let searchIndex = direction.nextPosition(row: row, column: column)

        if matrix.contains(index: searchIndex.0, subIndex: searchIndex.1) {
            let seat = matrix[searchIndex.0][searchIndex.1]
            if seat == emptySeat || seat == occupiedSeat {
                return (searchIndex.0, searchIndex.1)
            } else {
                return findNeighbours(row: searchIndex.0, column: searchIndex.1, inLayout: matrix, inDirection: direction)
            }
        } else {
            return nil
        }
    }

    func shouldFreeOccupiedSeatP2(at row:Int, column:Int, inLayout matrix:[[Character]]) -> Bool {
        let freeSeats = findAllNeighbours(around: row, column: column, matrix: matrix)

        var occupiedAdjacentSeats = 0

        for freeSeat in freeSeats {
            guard matrix.contains(index: freeSeat.0, subIndex: freeSeat.1) else {
                continue
            }

            if matrix[freeSeat.0][freeSeat.1] == occupiedSeat {
                occupiedAdjacentSeats += 1
            }
        }

        return occupiedAdjacentSeats >= 5
    }

    func shouldFillEmptySeatP2(at row:Int, column:Int, inLayout matrix:[[Character]]) -> Bool {
        let adjacentSeats = findAllNeighbours(around: row, column: column, matrix: matrix)

        for adjacentSeat in adjacentSeats {
            guard matrix.contains(index: adjacentSeat.0, subIndex: adjacentSeat.1) else {
                continue
            }

            if matrix[adjacentSeat.0][adjacentSeat.1] == occupiedSeat {
                return false
            }
        }

        return true
    }

    func printSeats(_ matrix: [[Character]])  {
        for(row, columns) in matrix.enumerated() {
            var rowString = String()
            for column in 0 ..< columns.count {
                let seat = matrix[row][column]
                rowString.append(seat)
            }
            print(rowString)
        }
        print("----------------------")
    }
}
