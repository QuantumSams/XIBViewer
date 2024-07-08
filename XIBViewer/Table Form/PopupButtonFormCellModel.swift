import Foundation

final class PopupButtonFormCellModel: TableFormCellModel{
    
    init(fieldType: TableFieldTypes, label: String?) {
        self.label = label
        super.init(fieldType: fieldType)
    }
    
    let label: String?
}

