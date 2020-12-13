//
//  Challenge12.swift
//  AdventOfCode2020
//
//  Created by Sagar Dagdu on 12/12/20.
//

import Cocoa

enum Hand: String {
    case left = "L", right = "R"
}

enum RotationAngle: Int {
    case ninety = 90, oneEighty = 180, twoSeventy = 270
    
    var anticlockwiseAngle: RotationAngle {
        switch self {
        case .ninety:
            return .twoSeventy
        case .twoSeventy:
            return .ninety
        case .oneEighty:
            return .oneEighty
        }
    }
    
    var quadrantChanges: Int {
        var changes = 0
        switch self {
        case .ninety:
            changes = 1
        case .oneEighty:
            changes = 2
        case .twoSeventy:
            changes = 3
        }
        
        return changes
    }
}

struct Point {
    var x: Int
    var y: Int
    
    func pointByRotating(at angle: RotationAngle, onHand hand: Hand) -> Point {
        var newPoint = Point(x:0, y:0)
        var rotationAngle = angle
        
        if hand == .left {
            rotationAngle = rotationAngle.anticlockwiseAngle
        }
        
        switch rotationAngle {
        case .ninety:
            newPoint = Point(x: y, y: -x)
        case .oneEighty:
            newPoint = Point(x: -x, y: -y)
        case .twoSeventy:
            newPoint = Point(x: -y, y: x)
        }
        
        return newPoint
    }
    
    func pointByMoving(in direction: CardinalDirection, units: Int) -> Point {
        var newPoint = self
        switch direction  {
        case .north:
            newPoint.y += units
        case .east:
            newPoint.x += units
        case .south:
            newPoint.y -= units
        case .west:
            newPoint.x -= units
        }
        return newPoint
    }
}

enum CardinalDirection: String, CaseIterable {
    case east = "E", south = "S", west = "W", north = "N"
    
    func rotatingBy(angle: RotationAngle, onHand hand: Hand) -> CardinalDirection {
        let traversalDirections = hand == .right ? CardinalDirection.allCases : CardinalDirection.allCases.reversed()
        var currentIndex = traversalDirections.firstIndex(of: self)!
        
        for _ in 0 ..< angle.quadrantChanges {
            currentIndex += 1
            if currentIndex == traversalDirections.count  {
                currentIndex = 0
            }
        }
        
        let newDirection = traversalDirections[currentIndex]
        return newDirection
    }
}

struct CardinalPoint {
    var north: Int
    var south: Int
    var east: Int
    var west: Int
    
    func manhattanDistance() -> Int {
        return abs(north - south) + abs(east - west)
    }
    
    func pointAfterForwarding(in direction: CardinalDirection, by units: Int) -> CardinalPoint {
        var newPoint = CardinalPoint(north: north, south: south, east: east, west: west)
        switch direction {
        case .east:
            newPoint.east += units
        case .west:
            newPoint.west += units
        case .north:
            newPoint.north += units
        case .south:
            newPoint.south += units
        }
        
        return newPoint
    }
    
    func pointAfterMoving(byUnits units: Int, withWaypoint waypoint: Point) -> CardinalPoint {
        var newPoint = CardinalPoint(north: north, south: south, east: east, west: west)
        
        if waypoint.y > 0 {
            newPoint.north += waypoint.y * units
        } else {
            newPoint.south += abs(waypoint.y) * units
        }
        
        if waypoint.x > 0 {
            newPoint.east += waypoint.x * units
        } else {
            newPoint.west += abs(waypoint.x) * units
        }
        
        return newPoint
    }
    
    func pointAfterMoving(in direction: CardinalDirection, by units: Int) -> CardinalPoint {
        var newPoint = self
        switch direction {
        case .east:
            newPoint.east += units
        case .west:
            newPoint.west += units
        case .south:
            newPoint.south += units
        case .north:
            newPoint.north += units
        }
        
        return newPoint
    }
}

class Challenge12: Challenge {
    lazy var input = InputFileHelper.readLinesFromFile(fileName: "12")
    
    func solvePartOne() -> String {
        
        var shipLocation = CardinalPoint(north: 0, south: 0, east: 0, west: 0)
        var currentDirection = CardinalDirection.east

        for inputLine in input {
            let directionString = String(inputLine.prefix(1))
            let units = Int((inputLine as NSString).substring(from: 1))!

            if directionString == "F" {
                shipLocation = shipLocation.pointAfterForwarding(in: currentDirection, by: units)
            } else if let rotationHand = Hand(rawValue: directionString), let angle = RotationAngle(rawValue: units) { // rotation
                currentDirection = currentDirection.rotatingBy(angle: angle, onHand: rotationHand)
            } else {
                shipLocation = shipLocation.pointAfterMoving(in: CardinalDirection(rawValue: directionString)!, by: units)
            }
        }
        
        return "\(shipLocation.manhattanDistance())"
        
    }
    
    func solvePartTwo() -> String {
        var shipLocation = CardinalPoint(north: 0, south: 0, east: 0, west: 0)
        var waypointLocation = Point(x: 10, y: 1)
        
        for inputLine in input {
            let directionString = String(inputLine.prefix(1))
            let units = Int((inputLine as NSString).substring(from: 1))!
            
            if directionString == "F" {
                shipLocation = shipLocation.pointAfterMoving(byUnits: units, withWaypoint: waypointLocation)
            } else if let rotationHand = Hand(rawValue: directionString), let angle = RotationAngle(rawValue: units) { // rotation
                waypointLocation = waypointLocation.pointByRotating(at: angle, onHand: rotationHand)
            } else {
                waypointLocation = waypointLocation.pointByMoving(in: CardinalDirection(rawValue: directionString)!, units: units)
            }
            
            print("Instruction:\(directionString)\(units)")
            print("Current location : \(shipLocation)")
            print("Waypoint location : \(waypointLocation)")
            print("******")
        }
        
        return "\(shipLocation.manhattanDistance())"
    }
}
