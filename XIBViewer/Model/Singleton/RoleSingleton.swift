import UIKit


class RoleSingleton{
    private init() {}
    static let accessSingleton = RoleSingleton()
    private var roleList: [Int:String] = [:]
}


extension RoleSingleton{
    func setRole(newRole: [RoleModel]){
        newRole.forEach { role in
            roleList[role.id] = role.name
        }
    }
    
    func getRole() -> [Int:String]{
        self.roleList
    }
    
    
    func getID(from name: String) -> Int?{
        if(roleList.isEmpty){
            return nil
        }
        if let key = roleList.first(where: { $0.value == name })?.key{
            return key
        }
        return nil
    }
    
    func convertToUIAction(handler: @escaping (UIAction) -> Void) -> [UIAction]{
       
        var out: [UIAction] = []
        
        for(_, value) in roleList{
            out.append(UIAction(title: value ,handler: handler))
            
        }
        return out
    }
    
    func getAllValue() ->[String]{
        let array = Array(roleList.values.sorted())
        return array
    }
}
