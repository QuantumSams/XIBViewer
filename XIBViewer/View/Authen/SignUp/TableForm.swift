//
//  FormItemModel.swift
//  XIBViewer
//
//  Created by Huy on 30/6/24.
//

import UIKit
import Foundation

enum TableFieldTypes: String{
    case name = "name"
    case email = "email"
    case password = "password"
    case confirmPassword = "confirmPassword"
    case roleSelection = "roleSelection"
    case custom = "custom"
}

class TableFieldComponent{
    
    init(fieldType: TableFieldTypes) {
        self.fieldType = fieldType
    }
    let id: String = UUID().uuidString
    let fieldType: TableFieldTypes
}

final class TextFieldComponent: TableFieldComponent{
    
    init(fieldType: TableFieldTypes ,fieldPlaceholder: String? = nil, validationMethod: @escaping (String) -> String?) {
        self.fieldPlaceholder = fieldPlaceholder
        self.validationMethod = validationMethod
        super.init(fieldType: fieldType)
    }
    var fieldPlaceholder: String?
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

final class PopupButtonFieldComponent: TableFieldComponent{
    
    init(selection: UIMenu, fieldType: TableFieldTypes) {
        self.selection = selection
        super.init(fieldType: fieldType)
    }
    
    let selection: UIMenu
}


struct TableForm{
    
    init(formOrder: [TableFieldComponent]) {
        self.formOrder = formOrder
    }
    var formOrder: [TableFieldComponent]
    var returnValue: [String : Any] = [:]
    
    
    mutating func assignReturnValue(){
        for item in formOrder{
            self.returnValue[item.id] = " "
        }
    }
    
    mutating func setValue(id: String, value: Any){
        returnValue[id] = value
    }
    
    func getValue(id: String) -> Any?{
        returnValue[id]
    }
}

