//
//  Challenge04.swift
//  AdventOfCode2020
//
//  Created by Sagar Dagdu on 04/12/20.
//

import Cocoa

private struct Passport {
    
    //MARK:- Properties
    
    private var birthYear: String?
    private var issueYear: String?
    private var expirationYear: String?
    private var height: String?
    private var hairColor: String?
    private var eyeColor: String?
    private var passportId: String?
    private var countryId: String?
    
    //MARK:- Public methods
    
    static func fromDict(_ dict:[String:String]) -> Passport {
        var passport = Passport(birthYear: nil, issueYear: nil, expirationYear: nil, height: nil, hairColor: nil, eyeColor: nil, passportId: nil, countryId: nil)
        passport.birthYear = dict["byr"]
        passport.issueYear = dict["iyr"]
        passport.expirationYear = dict["eyr"]
        passport.height = dict["hgt"]
        passport.hairColor = dict["hcl"]
        passport.eyeColor = dict["ecl"]
        passport.passportId = dict["pid"]
        passport.countryId =  dict["cid"]
        
        return passport
    }
    
    func hasAllMandatoryFields() -> Bool {
        let mandatoryFields = [birthYear, issueYear, expirationYear, height, hairColor, eyeColor, passportId]
        return mandatoryFields.count == mandatoryFields.compactMap { $0 }.count
    }
    
    func isValidPassport() -> Bool {
        guard hasAllMandatoryFields() else {
            return false
        }
        
        let validationFunctions = [validateBirthYear, validateIssueYear, validateExpirationYear, validateHeight, validateHairColor, validateEyeColor, validatePassportId]
        for validationFunction in validationFunctions {
            if !validationFunction() {
                return false
            }
        }
        
        return true
    }
    
    //MARK:- Private methods
    
    private func validateBirthYear() -> Bool {
        guard let birthYear = birthYear, let year = Int(birthYear) else { return false }
        return (1920...2002).contains(year)
    }
    
    private func validateIssueYear() -> Bool {
        guard let issueYear = issueYear, let year = Int(issueYear) else { return false }
        return (2010...2020).contains(year)
    }
    
    private func validateExpirationYear() -> Bool {
        guard let expirationYear = expirationYear, let year = Int(expirationYear) else { return false }
        return (2020...2030).contains(year)
    }
    
    private func validateHeight() -> Bool {
        guard let height = height, !height.isEmpty, (height.contains("in") || height.contains("cm")) else { return false }
        
        if let centimeters = height.components(separatedBy: "cm").first.flatMap(Int.init) {
            return (150...193).contains(centimeters)
        }

        if let inches = height.components(separatedBy: "in").first.flatMap(Int.init) {
            return (59...76).contains(inches)
        }

        return false
        
    }
    
    private func validateHairColor() -> Bool {
        guard let value = hairColor, value.hasPrefix("#") else { return false }
        
        let color = (value as NSString).substring(from: 1)
        return String(color).isAlphanumeric
    }
    
    private func validateEyeColor() -> Bool {
        return ["amb", "blu", "brn", "gry", "grn", "hzl", "oth"].contains(eyeColor)
    }
    
    private func validatePassportId() -> Bool {
        guard let passportId = passportId, passportId.count == 9 else { return false }
        
        return Int(passportId) != nil
    }
}

class Challenge04: Challenge {
    
    fileprivate var passports = [Passport]()
    
    init() {
        passports = InputFileHelper.readFileContent(fileName: "04").components(separatedBy: "\n\n").map { Passport.fromDict(parsePassportInfo(from: $0)) }
    }
    
    func solvePartOne() -> String {
        return "\(passports.filter { $0.hasAllMandatoryFields() }.count)"
    }
    
    func solvePartTwo() -> String {
        return "\(passports.filter { $0.isValidPassport() }.count)"
    }
    
    // MARK:- Helpers
    
    private func parsePassportInfo(from passportString: String) -> [String:String] {
        var passportInfo = [String:String]()
        
        let fields = passportString.components(separatedBy: .whitespacesAndNewlines).filter { !$0.isEmpty }
        
        for field in fields {
            let keyValuePair = field.split(separator: ":").map { String($0) }
            passportInfo[keyValuePair[0]] = keyValuePair[1]
        }
        
        return passportInfo
    }
}
