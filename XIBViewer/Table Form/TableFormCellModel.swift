import UIKit

class TableFormCellModel{
    
    init(fieldType: TableFieldTypes) {
        self.fieldType = fieldType
    }
    let id: String = UUID().uuidString
    let fieldType: TableFieldTypes
    var value: Any?
    
}

