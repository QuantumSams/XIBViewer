import UIKit


class RoleSingleton{
    private init() {}
    static let accessSingleton = RoleSingleton()
    private var roleList: [RoleModel] = []
}


extension RoleSingleton{
    func setRole(newRole: [RoleModel]){
        roleList = newRole
    }
    
    func getRole() -> [RoleModel]{
        return roleList
    }
    
    func TableFormPopUpMenuConstructor(actionWhenChoiceChanged: @escaping UIActionHandler) -> UIMenu{
        var actions: [UIAction] = []
        for choice in self.roleList {
            actions.append(UIAction(title: choice.name, identifier: .init(String(choice.id)), handler: actionWhenChoiceChanged))
        }
        return UIMenu(children: actions)
    }
}
