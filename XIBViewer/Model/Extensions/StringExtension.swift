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
}
