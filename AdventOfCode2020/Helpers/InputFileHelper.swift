//
//  InputFileHelper.swift
//  AdventOfCode2020
//
//  Created by Sagar Dagdu on 02/12/20.
//

import Foundation

final class InputFileHelper {
    
    static let inputFilesBundleName = "InputFiles.bundle"
    
    static func readFileContent(fileName: String) -> String {
        let currentDirectoryURL = URL(fileURLWithPath: FileManager.default.currentDirectoryPath)
        let bundleUrl = URL(fileURLWithPath: inputFilesBundleName, relativeTo: currentDirectoryURL)
        let bundle = Bundle(url: bundleUrl)!
        
        let inputFileUrl = bundle.url(forResource: fileName, withExtension: nil)!
        let contents = try! String(contentsOf: inputFileUrl, encoding: .utf8)
        return contents
    }
    
    static func readLinesFromFile(fileName: String) -> [String] {
        return readFileContent(fileName: fileName).split(separator: "\n").map(String.init)
    }
    
}
