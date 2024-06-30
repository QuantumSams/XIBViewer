//
//  StringExtension.swift
//  XIBViewer
//
//  Created by Huy on 25/6/24.
//

import Foundation


extension String{
    func getFirstAndLastName() -> [String]{
        let seperated = self.components(separatedBy: " ")
        
        let firstName = seperated.first ?? ""
        let lastName = seperated.last ?? ""
        
        return [firstName, lastName]
    }
    
    
    static func concatenateString(from errorList:[String]) -> String?{
        return errorList.isEmpty ? nil : errorList.joined(separator: "\n")
    }
    
    static func getOneString(from listOfStringList: [[String]?], defaut defaultReturnString: String) -> String{
        
        var returnString: String = ""
        
        for list in listOfStringList{
            guard let list = list else{
                continue
            }
            
            if let validString = concatenateString(from: list){
                returnString += validString
            }
        }
        return returnString != "" ? returnString : defaultReturnString
    }
}
