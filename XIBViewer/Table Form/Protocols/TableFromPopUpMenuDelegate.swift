import Foundation
import UIKit

protocol TableFromPopUpMenuDelegate{
    
    func TableFormPopUpMenuConstructor(from literalStringChoices: [String], actionWhenChoiceChanged: @escaping UIActionHandler) -> UIMenu
}
