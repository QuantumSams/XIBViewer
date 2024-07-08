import Foundation
import UIKit

protocol TableFromPopUpMenuDelegate{
    
    func TableFormPopUpMenuConstructor(from literalStringChoices: [RoleModel], actionWhenChoiceChanged: @escaping UIActionHandler) -> UIMenu
}
