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
    private let storage = UserDefaults.standard
}


extension TokenSingleton{
    func setInitialToken(access: String, refresh: String){
        storage.set(access, forKey: "AccessTK")
        storage.set(refresh, forKey: "RefreshTK")
    }
    
    func getAccessToken() -> String{
        return storage.string(forKey: "AccessTK") ?? ""
    }
    
    func removeToken(){
        storage.removeObject(forKey: "AccessTK")
        storage.removeObject(forKey: "RefreshTK")
    }
}
