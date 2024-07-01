//
//  FormItemModel.swift
//  XIBViewer
//
//  Created by Huy on 30/6/24.
//

import UIKit
import Foundation

enum FieldType: String{
    case name = "name"
    case email = "email"
    case password = "password"
    case confirmPassword = "confirmPassword"
}


struct FormItemModel{
    let id: FieldType
    let fieldPlaceholder: String?
    let validationMethod: (String) -> String?
}


struct OneForm{
    
    init(formOrder: [FormItemModel]) {
        self.formOrder = formOrder
    }
    var formOrder: [FormItemModel]
    var returnValue: [String : String] = [:]
    
    
    mutating func assignReturnValue(){
        for item in formOrder{
            self.returnValue[item.id.rawValue] = "abc"
        }
    }
    
    mutating func setValue(ofKey key: FieldType, value: String){
        returnValue[key.rawValue] = value
    }
    
    func getValue(type key: FieldType) -> String?{
        returnValue[key.rawValue]
    }
}

