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
    var value: Any?
    
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
    
    init(fieldType: TableFieldTypes, label: String?, selection: [String]) {
        self.choices = selection
        self.label = label
        super.init(fieldType: fieldType)
    }
    
    let choices: [String]
    let label: String?
}


struct TableForm{
    
    init(formOrder: [TableFieldComponent]) {
        self.formOrder = formOrder
    }
    var formOrder: [TableFieldComponent]
    
}

