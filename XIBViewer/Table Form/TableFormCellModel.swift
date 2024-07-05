import UIKit

class TableFormCellModel{
    
    init(fieldType: TableFieldTypes) {
        self.fieldType = fieldType
    }
    let id: String = UUID().uuidString
    let fieldType: TableFieldTypes
    var value: Any?
}

extension TableFormCellModel{
    static func forceTableFormFieldToResign(count: Int, table: UITableView){
        for row in 0..<count{
            let indexPath = IndexPath(row: row, section: 0)
            guard let cell = table.cellForRow(at: indexPath) as? TextFormCell else{
                return
            }
            cell.textField.resignFirstResponder()
        }
    }
}

