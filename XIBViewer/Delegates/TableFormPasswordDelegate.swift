import Foundation

protocol TableFormPasswordDelegate{
    func TableFormPasswordCollector(from passwordField: TextFormCellModel?) -> String?
}
