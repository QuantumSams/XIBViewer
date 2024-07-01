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
    case custom = "custom"
}


struct FormItemModel{
    let uuid: String = UUID().uuidString
    let fieldType: FieldType
    let fieldPlaceholder: String?
    let validationMethod: (String) -> String?
    
    var keyboardType: UIKeyboardType {
        switch fieldType{
            
        case .name:
                .default
        case .email:
                .emailAddress
        case .password:
                .default
        case .confirmPassword:
                .default
        default: 
                .default
        }
    }
    
    var secureEntry: Bool{
        
        switch fieldType{
            
        case .password, .confirmPassword: true
            
        default: false
        }
    }
}


struct OneForm{
    
    init(formOrder: [FormItemModel]) {
        self.formOrder = formOrder
    }
    var formOrder: [FormItemModel]
    var returnValue: [String : String] = [:]
    
    
    mutating func assignReturnValue(){
        for item in formOrder{
            self.returnValue[item.uuid] = " "
        }
    }
    
    mutating func setValue(id: String, value: String){
        returnValue[id] = value
    }
    
    func getValue(id: String) -> String?{
        returnValue[id]
    }
}

