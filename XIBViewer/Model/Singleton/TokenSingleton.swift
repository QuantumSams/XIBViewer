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
    func setInitialToken(access: String, refresh: String? = nil){
        storage.set(access, forKey: "AccessTK")
        
        if let refresh = refresh{
            storage.set(refresh, forKey: "RefreshTK")
            
        }
    }
    
    func getAccessToken() -> String{
        

        
        return storage.string(forKey: "AccessTK") ?? "."
    }
    
    func getRequestToken() -> String{
        return storage.string(forKey: "RefreshTK") ?? "."
    }
    
    func removeToken(){
        storage.removeObject(forKey: "AccessTK")
        storage.removeObject(forKey: "RefreshTK")
    }
}
