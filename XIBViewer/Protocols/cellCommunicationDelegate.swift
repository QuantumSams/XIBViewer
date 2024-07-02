import Foundation
import UIKit

protocol cellCommunicationDelegate{
    func getPassword(from passwordField: TextFormCellModel?) -> String?
    func contructPopUpChoices(from literalStringChoices: [String], actionWhenChoiceChanged: @escaping UIActionHandler) -> UIMenu
}
