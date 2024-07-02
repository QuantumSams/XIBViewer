import Foundation

final class PopupButtonFormCellModel: TableFormCellModel{
    
    init(fieldType: TableFieldTypes, label: String?, selection: [String]) {
        self.choices = selection
        self.label = label
        super.init(fieldType: fieldType)
    }
    
    let choices: [String]
    let label: String?
}

