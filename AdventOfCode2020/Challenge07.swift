//
//  Challenge07.swift
//  AdventOfCode2020
//
//  Created by Sagar Dagdu on 07/12/20.
//

import Cocoa

enum EdgeDirection {
    //If BagA contains 2 BagB's then adjacency list will have BagA ---- 2 -----> BagB
    case containerToContainedBags
    
    //If BagA contains 2 BagB's then adjacency list will have BagB ---- 2 -----> BagA
    case containedBagsToContainer
}

class Challenge07: Challenge {
    
    lazy var input = InputFileHelper.readLinesFromFile(fileName: "07")
    
    func solvePartOne() -> String {
        // BFS search
        let targetVertex = Vertex(data: "shiny gold")
        let adjacencyList = getAdjacencyList(from: input, edgeDirection: .containedBagsToContainer)
        
        var queue = [Vertex<String>]()
        
        var visited = [Vertex<String>]()
        queue.append(targetVertex)
        
        while !queue.isEmpty {
            let current = queue.removeFirst()
            
            if !visited.contains(current) {
                visited.append(current)
                if let edges = adjacencyList.edges(from: current) {
                    for edge in edges {
                        queue.append(edge.destination)
                    }
                }
            }
        }
        
        return "\(visited.count - 1)" // Remove the originally counted root
    }
    
    func solvePartTwo() -> String {
        // DFS search
        let sourceVertex = Vertex(data: "shiny gold")
        let adjacencyList = getAdjacencyList(from: input, edgeDirection: .containerToContainedBags)
        let count = countBagsDepthFirst(adjacencyList: adjacencyList, sourceVertex: sourceVertex)
        
        return "\(count - 1)" // Remove the originally counted root
    }
}


private extension Challenge07 {
    
    //If BagA contains 2 BagB's then we will have BagB ---- 2 -----> BagA
    func getAdjacencyList(from input: [String], edgeDirection: EdgeDirection) -> AdjacencyList<String> {
        
        let adjacencyList = AdjacencyList<String>()
        
        // Parsing
        
        for line in input {
            let containerComponents = line.components(separatedBy: "contain")
            let containerBagColorComponents = containerComponents[0].components(separatedBy: .whitespaces)
                .filter { !$0.isEmpty }
                .dropLast()
                .map { String($0) }
            let containerBagColor = containerBagColorComponents.joined(separator: " ")
            
            let containerVertex = adjacencyList.createVertex(data: containerBagColor)
            
            let containedBagComponents = containerComponents[1]
            if containedBagComponents.contains("no other bags") { // No contained bag
                continue;
            }
            
            if containedBagComponents.contains(",") { // Multiple contained bags
                let containedBagsStatement = containedBagComponents.components(separatedBy: ",")
                for containedBagStatement in containedBagsStatement {
                    let bagData = containedBagStatement.trimmingCharacters(in: .whitespaces).components(separatedBy: .whitespaces).dropLast().map { String($0) }
                    let quantity = Int(bagData[0])!
                    let bagColor = bagData.dropFirst().joined(separator: " ")
                    
                    let containedBagVertex = adjacencyList.createVertex(data: bagColor)
                    
                    let sourceVertex = edgeDirection == .containerToContainedBags ? containerVertex : containedBagVertex
                    let destinationVertex = edgeDirection == .containerToContainedBags ? containedBagVertex : containerVertex

                    adjacencyList.add(.directed, from: sourceVertex, to: destinationVertex, weight: Double(quantity))
                }
            } else { // Single contained bag
                let containedBagStatementFragments = containedBagComponents.components(separatedBy: .whitespaces).filter { !$0.isEmpty }
                let containedBagQuantity = Int(containedBagStatementFragments[0])!
                let containedBagColor = containedBagStatementFragments.dropFirst().dropLast().joined(separator: " ")
                
                let containedBagVertex = adjacencyList.createVertex(data: containedBagColor)
                
                let sourceVertex = edgeDirection == .containerToContainedBags ? containerVertex : containedBagVertex
                let destinationVertex = edgeDirection == .containerToContainedBags ? containedBagVertex : containerVertex
                adjacencyList.add(.directed, from: sourceVertex, to: destinationVertex, weight: Double(containedBagQuantity))
            }
        }
        
        return adjacencyList
    }
    
    func countBagsDepthFirst(adjacencyList: AdjacencyList<String>, sourceVertex: Vertex<String>) -> Int {
        var count: Int = 1 // This bag itself
        
        if let edges  = adjacencyList.edges(from: sourceVertex), edges.count > 0 {
            for edge in edges {
                count += Int(edge.weight ?? 0) * countBagsDepthFirst(adjacencyList: adjacencyList, sourceVertex: edge.destination)
            }
        }
        
        return count
    }
    
}

