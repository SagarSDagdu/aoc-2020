//
//  Vertex.swift
//  AdventOfCode2020
//
//  Created by Sagar Dagdu on 08/12/20.
//

import Foundation

// MARK:- Vertex

public struct Vertex<T: Hashable> {
    var data: T
}

extension Vertex: Hashable {
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(data)
    }
    
    static public func ==(lhs: Vertex, rhs: Vertex) -> Bool {
        return lhs.data == rhs.data
    }
}

extension Vertex: CustomStringConvertible {
    public var description: String {
        return "\(data)"
    }
}
