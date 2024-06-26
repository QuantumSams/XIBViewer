//
//  TokenSingleton.swift
//  XIBViewer
//
//  Created by Huy on 26/6/24.
//

import Foundation


class TokenSingleton{
    private init() {}
    
    static let getToken = TokenSingleton()
    
    private var accessToken = ""
    private var refreshToken = ""
}


extension TokenSingleton{
    func setInitialToken(access: String, refresh: String){
        self.accessToken = access
        self.refreshToken = refresh
    }
    
    func getAccessToken() -> String{
        return self.accessToken
    }
}
