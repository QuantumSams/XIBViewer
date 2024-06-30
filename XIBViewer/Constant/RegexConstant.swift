//
//  RegexConstant.swift
//  XIBViewer
//
//  Created by Huy on 28/6/24.
//

import Foundation

struct RegexConstant{
    static let email: String = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
    static let password: String = "^(?=.*[a-z])(?=.*[A-Z])(?=.*[0-9])(?=.*[$@$#!%*?&]).{8,150}$"
    
}
